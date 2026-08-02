#!/usr/bin/env python3
"""Retained behavioral contracts for audit_project_state.py."""

from __future__ import annotations

import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]
AUDITOR = ROOT / "skills" / "managing-project-state" / "scripts" / "audit_project_state.py"
HEADER = (
    "| ID | State | Priority | Outcome | Implemented | Tested | Committed | Pushed | "
    "Merged | Deployed | Runtime verified | Disposition | Authority |\n"
    "| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |\n"
)


class AuditorContractTests(unittest.TestCase):
    def run_audit(self, root: Path, *extra: str) -> dict:
        completed = subprocess.run(
            [sys.executable, str(AUDITOR), "--root", str(root), "--format", "json", *extra],
            check=True,
            capture_output=True,
            text=True,
        )
        return json.loads(completed.stdout)

    @staticmethod
    def write_config(root: Path, protected: str = "queued, active, blocked, future-watch") -> None:
        config = root / ".superpowers" / "project-state.yaml"
        config.parent.mkdir(parents=True, exist_ok=True)
        config.write_text(
            "version: 1\n"
            "ledger: docs/progress.md\n"
            "archive: docs/project-evidence\n"
            f"protected_states: [{protected}]\n"
            "current_completed_limit: 10\n"
            "archive_entry_max_kib: 64\n",
            encoding="utf-8",
        )

    @staticmethod
    def write_ledger(root: Path, rows: str) -> None:
        ledger = root / "docs" / "progress.md"
        ledger.parent.mkdir(parents=True, exist_ok=True)
        ledger.write_text("# Current work\n\n" + HEADER + rows, encoding="utf-8")

    def test_valid_managed_profile_is_structured_and_transition_is_not_evaluated(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            self.write_config(root)
            self.write_ledger(
                root,
                "| item-1 | active | high | Ship it | Yes | Yes | No | No | No | No | No |  |  |\n",
            )

            report = self.run_audit(root)

            self.assertEqual(report["profile"], "managed")
            self.assertEqual(report["transition_check"], "not_evaluated")
            self.assertFalse([item for item in report["findings"] if item["severity"] == "error"])

    def test_managed_profile_rejects_narrowed_protection_and_duplicate_ids(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            self.write_config(root, "active")
            row = "| item-1 | active | high | Ship it | No | No | No | No | No | No | No |  |  |\n"
            self.write_ledger(root, row + row)

            report = self.run_audit(root)
            rules = {item["rule"] for item in report["findings"]}

            self.assertIn("protected-states", rules)
            self.assertIn("duplicate-id", rules)

    def test_instruction_secret_is_suppressed(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            secret = "ghp_abcdefghijklmnopqrstuvwxyz1234567890"
            (root / "AGENTS.md").write_text(f"token={secret}\nAlways run rm -rf build\n", encoding="utf-8")

            report = self.run_audit(root)
            rendered = json.dumps(report)
            rules = {item["rule"] for item in report["findings"]}

            self.assertIn("possible-secret", rules)
            self.assertIn("unsafe-directive", rules)
            self.assertNotIn(secret, rendered)

    def test_symlinked_instruction_is_not_read(self) -> None:
        with tempfile.TemporaryDirectory() as temp, tempfile.TemporaryDirectory() as external:
            root = Path(temp)
            secret = "ghp_abcdefghijklmnopqrstuvwxyz1234567890"
            outside = Path(external) / "AGENTS.md"
            outside.write_text(f"token={secret}\n", encoding="utf-8")
            (root / "AGENTS.md").symlink_to(outside)

            report = self.run_audit(root)
            rendered = json.dumps(report)

            self.assertIn("instruction-symlink", {item["rule"] for item in report["findings"]})
            self.assertNotIn(secret, rendered)

    def test_convention_profile_uses_instruction_pointer_and_ignores_worktrees(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            canonical = root / "docs" / "platform" / "current-progress-and-roadmap.md"
            canonical.parent.mkdir(parents=True)
            canonical.write_text("# Current platform state\n", encoding="utf-8")
            (canonical.parent / "progress.md").write_text("# Supplemental detail\n", encoding="utf-8")
            policy = "`docs/platform/current-progress-and-roadmap.md` is the canonical platform ledger.\nDo not add TODO placeholders.\n"
            (root / "AGENTS.md").write_text(policy, encoding="utf-8")
            copied = root / ".worktrees" / "feature" / "AGENTS.md"
            copied.parent.mkdir(parents=True)
            copied.write_text(policy, encoding="utf-8")

            report = self.run_audit(root)
            rules = {item["rule"] for item in report["findings"]}

            self.assertEqual(report["profile"], "convention")
            self.assertEqual(report["ledger"], "docs/platform/current-progress-and-roadmap.md")
            self.assertEqual(report["ledger_source"], "instruction")
            self.assertNotIn("duplicate-ledger", rules)
            self.assertNotIn("duplicate-instruction", rules)
            self.assertNotIn("placeholder", rules)

    def test_convention_profile_prefers_canonical_pointer_over_supplemental_records(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            canonical = root / "docs" / "platform" / "progress.md"
            canonical.parent.mkdir(parents=True)
            canonical.write_text("# Current platform state\n", encoding="utf-8")
            supplemental = root / ".superpowers" / "sdd" / "progress.md"
            supplemental.parent.mkdir(parents=True)
            supplemental.write_text("# Execution evidence\n", encoding="utf-8")
            (root / "AGENTS.md").write_text(
                "`docs/platform/progress.md` is the only canonical platform progress ledger.\n"
                "Dated plans and `.superpowers/sdd/progress.md` may retain detailed execution "
                "evidence, but they are supplemental and never override the canonical ledger.\n",
                encoding="utf-8",
            )

            report = self.run_audit(root)

            self.assertEqual(report["ledger"], "docs/platform/progress.md")
            self.assertEqual(report["ledger_source"], "instruction")
            self.assertNotIn("ambiguous-ledger-pointer", {item["rule"] for item in report["findings"]})

    def test_convention_profile_reports_a_missing_declared_canonical_ledger(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            (root / "AGENTS.md").write_text(
                "`docs/platform/progress.md` is the canonical project ledger.\n",
                encoding="utf-8",
            )

            report = self.run_audit(root)

            self.assertEqual(report["ledger"], "docs/platform/progress.md")
            self.assertEqual(report["ledger_source"], "instruction")
            self.assertIn("missing-ledger", {item["rule"] for item in report["findings"]})

    def test_protected_transition_requires_disposition_and_authority(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            self.write_config(root)
            self.write_ledger(
                root,
                "| item-1 | active | high | Ship it | No | No | No | No | No | No | No |  |  |\n",
            )
            subprocess.run(["git", "init", "-q"], cwd=root, check=True)
            subprocess.run(["git", "add", "."], cwd=root, check=True)
            subprocess.run(
                ["git", "-c", "user.name=Test", "-c", "user.email=test@example.com", "commit", "-qm", "base"],
                cwd=root,
                check=True,
            )
            self.write_ledger(
                root,
                "| item-1 | future-watch | high | Ship it | No | No | No | No | No | No | No |  |  |\n",
            )
            subprocess.run(["git", "add", "."], cwd=root, check=True)
            subprocess.run(
                ["git", "-c", "user.name=Test", "-c", "user.email=test@example.com", "commit", "-qm", "defer"],
                cwd=root,
                check=True,
            )

            report = self.run_audit(root, "--base-ref", "HEAD^", "--head-ref", "HEAD")

            self.assertEqual(report["transition_check"], "evaluated")
            self.assertIn("protected-transition", {item["rule"] for item in report["findings"]})

            self.write_ledger(
                root,
                "| item-1 | future-watch | high | Ship it | No | No | No | No | No | No | No | Deferred by request | User decision |\n",
            )
            subprocess.run(["git", "add", "."], cwd=root, check=True)
            subprocess.run(
                ["git", "-c", "user.name=Test", "-c", "user.email=test@example.com", "commit", "-qm", "authorize"],
                cwd=root,
                check=True,
            )
            authorized = self.run_audit(root, "--base-ref", "HEAD^^", "--head-ref", "HEAD")
            self.assertNotIn("protected-transition", {item["rule"] for item in authorized["findings"]})

    def test_archived_removal_requires_an_exact_stable_id(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            self.write_config(root)
            self.write_ledger(
                root,
                "| item-1 | active | high | Ship it | Yes | Yes | No | No | No | No | No |  |  |\n",
            )
            subprocess.run(["git", "init", "-q"], cwd=root, check=True)
            subprocess.run(["git", "add", "."], cwd=root, check=True)
            subprocess.run(
                ["git", "-c", "user.name=Test", "-c", "user.email=test@example.com", "commit", "-qm", "base"],
                cwd=root,
                check=True,
            )
            self.write_ledger(root, "")
            archive = root / "docs" / "project-evidence" / "item-10.md"
            archive.parent.mkdir(parents=True)
            archive.write_text(
                "ID: item-10\nDisposition: Completed and archived\nAuthority: Accepted scope\n",
                encoding="utf-8",
            )
            subprocess.run(["git", "add", "."], cwd=root, check=True)
            subprocess.run(
                ["git", "-c", "user.name=Test", "-c", "user.email=test@example.com", "commit", "-qm", "collision"],
                cwd=root,
                check=True,
            )

            collision = self.run_audit(root, "--base-ref", "HEAD^", "--head-ref", "HEAD")
            self.assertIn("protected-transition", {item["rule"] for item in collision["findings"]})

            archive.write_text(
                "ID: item-1\nDisposition: Completed and archived\nAuthority: Accepted scope\n",
                encoding="utf-8",
            )
            subprocess.run(["git", "add", "."], cwd=root, check=True)
            subprocess.run(
                ["git", "-c", "user.name=Test", "-c", "user.email=test@example.com", "commit", "-qm", "exact"],
                cwd=root,
                check=True,
            )

            exact = self.run_audit(root, "--base-ref", "HEAD^^", "--head-ref", "HEAD")
            self.assertNotIn("protected-transition", {item["rule"] for item in exact["findings"]})


if __name__ == "__main__":
    unittest.main()
