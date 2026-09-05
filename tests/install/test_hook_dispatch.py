#!/usr/bin/env python3
"""Execute hook dispatch without invoking a model; Windows cases run only there."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]


class HookDispatchTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="adaptive hooks (paths) ")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name) / "plugin (copy)"
        shutil.copytree(ROOT / "hooks", self.root / "hooks")
        shutil.copytree(ROOT / "skills/using-superpowers",
                        self.root / "skills/using-superpowers")
        self.wrapper = self.root / "hooks/run-hook.cmd"

    def run_bash(self, *args):
        return subprocess.run(["bash", str(self.wrapper), *args],
                              cwd=self.temp.name, text=True, capture_output=True, timeout=15)

    def assert_payload(self, result):
        self.assertEqual(result.returncode, 0, result.stderr)
        output = json.loads(result.stdout)["hookSpecificOutput"]
        self.assertEqual(output["hookEventName"], "SessionStart")
        context = output["additionalContext"]
        gate = self.root / "skills/using-superpowers/SKILL.md"
        self.assertIn(gate.read_bytes().decode("utf-8").rstrip(), context)
        self.assertEqual(context.count("<ADAPTIVE_SUPERPOWERS>"), 1)
        self.assertIn("<ADAPTIVE_SUPERPOWERS_FULL_ROUTER>", context)
        # On Windows Git Bash may render this as /c/... instead of C:\...
        self.assertIn("/skills/using-superpowers/references/full-router.md", context.replace("\\", "/"))

    def test_declared_shell_and_command_preserve_bootstrap(self):
        config = json.loads((self.root / "hooks/hooks.json").read_text())
        event = config["hooks"]["SessionStart"][0]
        self.assertEqual(event["matcher"], "startup|clear|compact")
        hook = event["hooks"][0]
        self.assertEqual(hook.get("shell"), "bash")
        self.assertFalse(hook["async"])
        self.assertEqual(hook["command"], '"${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd" session-start')
        environment = dict(os.environ, CLAUDE_PLUGIN_ROOT=str(self.root))
        result = subprocess.run(["bash", "-c", hook["command"]], env=environment,
                                cwd=self.temp.name, text=True, capture_output=True, timeout=15)
        self.assert_payload(result)

    def test_wrapper_handles_spaces_and_parentheses(self):
        self.assert_payload(self.run_bash("session-start"))

    def test_missing_script_or_argument_fails(self):
        for args in ((), ("missing-hook",)):
            with self.subTest(args=args):
                result = self.run_bash(*args)
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(result.stdout, "")
                self.assertIn("run-hook.cmd:", result.stderr)

    def test_hook_failure_propagates(self):
        (self.root / "hooks/failing-hook").write_text("exit 23\n")
        result = self.run_bash("failing-hook")
        self.assertEqual(result.returncode, 23)
        self.assertEqual(result.stdout, "")

    def test_missing_router_is_not_silent_success(self):
        (self.root / "skills/using-superpowers/SKILL.md").unlink()
        result = self.run_bash("session-start")
        self.assertEqual(result.returncode, 1)
        self.assertEqual(result.stdout, "")
        self.assertIn("router is missing", result.stderr)

    def test_git_preserves_lf_for_bash_consumed_files(self):
        paths = ["hooks/run-hook.cmd", "hooks/session-start"]
        result = subprocess.run(["git", "-C", str(ROOT), "check-attr", "eol", "--", *paths],
                                text=True, capture_output=True, check=True)
        self.assertEqual(result.stdout.splitlines(), [f"{p}: eol: lf" for p in paths])
        for path in paths:
            self.assertNotIn(b"\r", (ROOT / path).read_bytes())

    @unittest.skipUnless(os.name == "nt", "requires native Windows cmd.exe and Git Bash")
    def test_native_windows_cmd_payload(self):
        command = f'cmd.exe /d /s /c ""{self.wrapper}" session-start"'
        result = subprocess.run(command, cwd=self.temp.name, text=True,
                                capture_output=True, timeout=15)
        self.assert_payload(result)

    @unittest.skipUnless(os.name == "nt", "requires native Windows cmd.exe and Git Bash")
    def test_native_windows_cmd_exit_status(self):
        (self.root / "hooks/failing-hook").write_text("exit 23\n")
        command = f'cmd.exe /d /s /c ""{self.wrapper}" failing-hook"'
        result = subprocess.run(command, cwd=self.temp.name, text=True,
                                capture_output=True, timeout=15)
        self.assertEqual(result.returncode, 23, result.stderr)

    @unittest.skipUnless(os.name == "nt", "requires native Windows cmd.exe")
    def test_native_windows_missing_bash_is_visible(self):
        cmd = Path(os.environ["SystemRoot"]) / "System32/cmd.exe"
        environment = dict(os.environ)
        environment.update({"ProgramFiles": self.temp.name,
                            "ProgramFiles(x86)": self.temp.name, "PATH": ""})
        command = f'"{cmd}" /d /s /c ""{self.wrapper}" session-start"'
        result = subprocess.run(command, env=environment, cwd=self.temp.name,
                                text=True, capture_output=True, timeout=15)
        self.assertEqual(result.returncode, 1)
        self.assertEqual(result.stdout, "")
        self.assertIn("install Git for Windows", result.stderr)


if __name__ == "__main__":
    unittest.main()
