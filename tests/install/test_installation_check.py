#!/usr/bin/env python3
"""Exercise the on-disk checker through its CLI using disposable installations."""
import json
import pathlib
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]
SCRIPT = ROOT / "scripts/check-installation.py"


class InstallationCheckTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.base = pathlib.Path(self.temp.name)
        self.source = self.base / "source"
        for host in ("codex", "claude"):
            self.write(self.source / f".{host}-plugin/plugin.json",
                       json.dumps({"name": "adaptive-superpowers", "version": "0.3.0"}))
        for name in ("using-superpowers", "writing-plans"):
            self.write(self.source / f"skills/{name}/SKILL.md", f"name: {name}\n")
        self.write(self.source / "skills/using-superpowers/references/router.md", "current\n")
        self.write(self.source / "skills/using-superpowers/agents/openai.yaml", "interface:\n")
        self.write(self.source / "hooks/session-start", "exit 99\n")
        self.installed = self.base / "installed"
        shutil.copytree(self.source, self.installed)
        self.links = self.base / "links"
        self.links.mkdir()
        for skill in (self.installed / "skills").iterdir():
            (self.links / skill.name).symlink_to(skill, target_is_directory=True)

    @staticmethod
    def write(path, text):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)

    def run_check(self, host="codex", *extra):
        args = [sys.executable, str(SCRIPT), "--source", str(self.source),
                "--host", host, "--json"]
        if host in ("codex", "all"):
            args += ["--codex-skills", str(self.links)]
        if host in ("claude", "all") and "--claude-registry" not in extra:
            args += ["--claude-plugin", str(self.installed)]
        result = subprocess.run(args + list(extra), text=True, capture_output=True)
        self.assertIn(result.returncode, (0, 1, 2), result.stderr)
        self.assertTrue(result.stdout.strip(), result.stderr)
        return result.returncode, json.loads(result.stdout)

    def registry(self, entries):
        path = self.base / "installed_plugins.json"
        self.write(path, json.dumps({"version": 2, "plugins": {
            "adaptive-superpowers@market": entries}}))
        return path

    def test_matching_links_and_plugin(self):
        code, result = self.run_check("all")
        self.assertEqual(code, 0)
        self.assertEqual([i["status"] for i in result["installations"]], ["match", "match"])
        self.assertEqual(result["runtime_activation"], "not_checked")

    def test_same_version_does_not_hide_reference_drift(self):
        self.write(self.installed / "skills/using-superpowers/references/router.md", "stale\n")
        code, result = self.run_check()
        self.assertEqual(code, 1)
        item = result["installations"][0]
        self.assertTrue(item["version_match"])
        self.assertIn("skills/using-superpowers/references/router.md", item["changed"])

    def test_metadata_and_hook_drift_are_visible(self):
        for relative in ("skills/using-superpowers/agents/openai.yaml", "hooks/session-start"):
            with self.subTest(relative=relative):
                target = self.installed / relative
                original = target.read_text()
                target.write_text("old\n")
                code, result = self.run_check("claude")
                self.assertEqual(code, 1)
                self.assertIn(relative, result["installations"][0]["changed"])
                target.write_text(original)

    def test_missing_dangling_skill_is_not_healthy(self):
        shutil.rmtree(self.installed / "skills/writing-plans")
        code, result = self.run_check()
        self.assertEqual(code, 1)
        self.assertIn("skills/writing-plans/SKILL.md", result["installations"][0]["missing"])

    def test_extra_plugin_skill_is_drift_but_unrelated_user_skill_is_ignored(self):
        self.write(self.links / "unrelated/SKILL.md", "unrelated\n")
        self.assertEqual(self.run_check()[0], 0)
        self.write(self.installed / "skills/obsolete/SKILL.md", "obsolete\n")
        code, result = self.run_check("claude")
        self.assertEqual(code, 1)
        self.assertIn("skills/obsolete/SKILL.md", result["installations"][0]["unexpected"])

    def test_version_mismatch(self):
        self.write(self.installed / ".claude-plugin/plugin.json",
                   json.dumps({"name": "adaptive-superpowers", "version": "0.2.0"}))
        code, result = self.run_check("claude")
        self.assertEqual(code, 1)
        self.assertFalse(result["installations"][0]["version_match"])

    def test_unversioned_copies_are_unknown_not_version_aligned(self):
        (self.installed / ".codex-plugin/plugin.json").unlink()
        code, result = self.run_check()
        self.assertEqual(code, 2)
        self.assertEqual(result["installations"][0]["status"], "unknown")
        self.assertTrue(result["installations"][0]["content_match"])

    def test_registry_discovers_single_install_and_checks_reported_version(self):
        entry = {"scope": "user", "installPath": str(self.installed), "version": "0.3.0"}
        registry = self.registry([entry])
        self.assertEqual(self.run_check("claude", "--claude-registry", str(registry))[0], 0)
        entry["version"] = "0.1.0"
        self.registry([entry])
        self.assertEqual(self.run_check("claude", "--claude-registry", str(registry))[0], 1)

    def test_ambiguous_registry_requires_explicit_path(self):
        registry = self.registry([{"installPath": str(self.installed)},
                                  {"installPath": str(self.source)}])
        code, result = self.run_check("claude", "--claude-registry", str(registry))
        self.assertEqual(code, 2)
        self.assertIn("--claude-plugin", result["installations"][0]["error"])

    def test_malformed_registry_is_unknown(self):
        registry = self.base / "bad.json"
        self.write(registry, "{")
        code, result = self.run_check("claude", "--claude-registry", str(registry))
        self.assertEqual(code, 2)
        self.assertEqual(result["installations"][0]["status"], "unknown")

    def test_read_only_no_generated_files_or_hook_execution(self):
        before = {str(p.relative_to(self.base)): p.read_bytes()
                  for p in self.base.rglob("*") if p.is_file()}
        self.assertEqual(self.run_check("all")[0], 0)
        after = {str(p.relative_to(self.base)): p.read_bytes()
                 for p in self.base.rglob("*") if p.is_file()}
        self.assertEqual(before, after)

    def test_internal_symlinks_require_manual_inspection(self):
        for relative in ("skills/using-superpowers/SKILL.md",
                         "skills/using-superpowers/references",
                         "skills/using-superpowers",
                         "hooks", ".claude-plugin", ".claude-plugin/plugin.json"):
            with self.subTest(relative=relative):
                target = self.installed / relative
                moved = self.base / "outside-installation"
                target.rename(moved)
                target.symlink_to(moved, target_is_directory=moved.is_dir())
                try:
                    code, result = self.run_check("claude")
                    self.assertEqual(code, 2)
                    self.assertEqual(result["installations"][0]["status"], "unknown")
                    self.assertIn("symlink", result["installations"][0]["error"])
                finally:
                    target.unlink()
                    moved.rename(target)

    def test_internal_file_link_in_codex_skill_is_not_a_match(self):
        target = self.installed / "skills/using-superpowers/SKILL.md"
        target.unlink()
        target.symlink_to(self.source / "skills/using-superpowers/SKILL.md")
        code, result = self.run_check()
        self.assertEqual(code, 2)
        self.assertEqual(result["installations"][0]["status"], "unknown")


if __name__ == "__main__":
    unittest.main()
