#!/usr/bin/env python3
"""Retained behavioral contracts for check-children.py, on synthetic Claude Code transcripts."""

from __future__ import annotations

import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]
CHECKER = ROOT / "skills" / "using-superpowers" / "scripts" / "check-children.py"
PARENT = ("claude-fable-5-2", "max")


def records(pair, n=2, first_user="", start="2026-11-14T10:00:00Z"):
    out = [{"type": "user", "timestamp": start, "message": {"role": "user", "content": first_user}}]
    for _ in range(n):
        out.append({"type": "api-request", "params": {"model": pair[0], "output_config": {"effort": pair[1]}}})
    return out


def write(path: Path, recs, meta=None):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("".join(json.dumps(r) + "\n" for r in recs))
    if meta is not None:
        path.with_suffix(".meta.json").write_text(json.dumps(meta))


class TranscriptCase(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.projects = Path(self.tmp.name) / "projects"
        self.project = self.projects / "-work-repo"
        write(self.project / "parent.jsonl", records(PARENT, first_user="build it"))

    def tearDown(self):
        self.tmp.cleanup()

    def child(self, name, pair, brief):
        write(self.project / "parent" / "subagents" / f"{name}.jsonl",
              records(pair, first_user=brief), {"agentType": "general-purpose", "description": brief})

    def run_checker(self, *args, session="parent"):
        env = dict(os.environ, CLAUDE_CODE_SESSION_ID=session)
        return subprocess.run([sys.executable, "-I", str(CHECKER), "--root", str(self.projects), *args],
                              capture_output=True, text=True, env=env)


class CheckChildrenContractTests(TranscriptCase):
    def test_children_on_the_parent_pair_pass(self):
        self.child("agent-a", PARENT, "brief-a")
        self.child("agent-b", PARENT, "brief-b")
        done = self.run_checker()
        self.assertEqual(done.returncode, 0, done.stdout + done.stderr)
        self.assertIn("2 checked, all match", done.stdout)

    def test_a_child_on_another_model_fails(self):
        self.child("agent-a", PARENT, "brief-a")
        self.child("agent-guide", ("claude-haiku-5-5", "medium"), "brief-guide")
        done = self.run_checker()
        self.assertEqual(done.returncode, 1, done.stdout + done.stderr)
        self.assertIn("DIFFERS model=claude-haiku-5-5 effort=medium", done.stdout)

    def test_a_marker_checks_only_its_children(self):
        self.child("agent-a", PARENT, "brief-a")
        self.child("agent-guide", ("claude-haiku-5-5", "medium"), "brief-guide")
        done = self.run_checker("--marker", "brief-a")
        self.assertEqual(done.returncode, 0, done.stdout + done.stderr)

    def test_nothing_checked_is_never_a_pass(self):
        self.child("agent-a", PARENT, "brief-a")
        self.assertEqual(self.run_checker("--marker", "brief-missing").returncode, 2)
        self.assertEqual(self.run_checker(session="no-such-session").returncode, 2)

    def test_a_delegate_is_the_newest_other_session_holding_the_marker_and_matches_this_session(self):
        # The parent's own brief quotes the marker too; the delegate starts later.
        write(self.project / "parent.jsonl", records(PARENT, first_user="start brief-dx-1 please"))
        write(self.project / "older.jsonl", records(("claude-opus-5-5", "high"), first_user="brief-dx-1",
                                                    start="2026-11-14T09:00:00Z"))
        write(self.project / "delegate.jsonl", records(PARENT, first_user="brief-dx-1",
                                                       start="2026-11-14T11:00:00Z"))
        done = self.run_checker("--delegate", "brief-dx-1")
        self.assertEqual(done.returncode, 0, done.stdout + done.stderr)
        self.assertIn("session delegate", done.stdout)

    def test_a_marker_only_in_this_sessions_own_brief_is_not_a_delegate(self):
        write(self.project / "parent.jsonl", records(PARENT, first_user="start brief-dx-3 please"))
        self.assertEqual(self.run_checker("--delegate", "brief-dx-3").returncode, 2)

    def test_a_delegate_on_another_pair_fails_unless_the_user_named_it(self):
        write(self.project / "delegate.jsonl", records(("claude-opus-5-5", "high"), first_user="brief-dx-2",
                                                       start="2026-11-14T11:00:00Z"))
        self.assertEqual(self.run_checker("--delegate", "brief-dx-2").returncode, 1)
        named = self.run_checker("--delegate", "brief-dx-2", "--expect-model", "claude-opus-5-5",
                                 "--expect-effort", "high")
        self.assertEqual(named.returncode, 0, named.stdout + named.stderr)


def codex_rollout(path: Path, brief, pair, start="2026-11-14T11:00:00Z"):
    recs = [
        {"timestamp": start, "type": "session_meta", "payload": {"id": path.stem[-36:], "originator": "T3 Code"}},
        {"type": "response_item", "payload": {"type": "message", "role": "user",
                                             "content": [{"type": "input_text", "text": "# AGENTS.md instructions"}]}},
        # A T3-started Codex session carries the brief as a user response item (seen 2026-11-15).
        {"type": "response_item", "payload": {"type": "message", "role": "user",
                                             "content": [{"type": "input_text", "text": "Act as the test sub-agent.\n\n" + brief}]}},
    ]
    recs += [{"type": "turn_context", "payload": {"model": pair[0], "effort": pair[1]}}] * 2
    write(path, recs)


class CodexDelegateContractTests(TranscriptCase):
    """A delegate on another provider (Codex) is proved from its own session log."""

    def setUp(self):
        super().setUp()
        self.codex = Path(self.tmp.name) / "codex"
        self.sessions = self.codex / "sessions" / "2026" / "11" / "14"

    def run_codex(self, marker, *args):
        return self.run_checker("--codex", marker, "--codex-home", str(self.codex), *args)

    def test_a_codex_delegate_at_the_requested_pair_passes(self):
        codex_rollout(self.sessions / "rollout-2026-11-14T11-00-00-aaaa.jsonl", "brief-sol-1 go", ("gpt-6.1-sol", "max"))
        done = self.run_codex("brief-sol-1", "--expect-model", "gpt-6.1-sol")
        self.assertEqual(done.returncode, 0, done.stdout + done.stderr)
        self.assertIn("model=gpt-6.1-sol effort=max", done.stdout)

    def test_a_codex_delegate_left_on_the_provider_default_effort_fails(self):
        # No effort named: the expected effort is this session's own (max), and the default low differs.
        codex_rollout(self.sessions / "rollout-2026-11-14T11-00-00-bbbb.jsonl", "brief-sol-2 go", ("gpt-6.1-sol", "low"))
        done = self.run_codex("brief-sol-2", "--expect-model", "gpt-6.1-sol")
        self.assertEqual(done.returncode, 1, done.stdout + done.stderr)

    def test_a_codex_check_needs_the_named_model_and_a_matching_log(self):
        codex_rollout(self.sessions / "rollout-2026-11-14T11-00-00-cccc.jsonl", "brief-sol-3 go", ("gpt-6.1-sol", "max"))
        self.assertEqual(self.run_codex("brief-sol-3").returncode, 2)
        self.assertEqual(self.run_codex("brief-missing", "--expect-model", "gpt-6.1-sol").returncode, 2)



if __name__ == "__main__":
    unittest.main(verbosity=1)
