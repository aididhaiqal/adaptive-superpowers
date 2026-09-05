"""Test the probe's real acceptance boundary, not instruction text."""
import importlib.util
import pathlib
import shutil
import subprocess
import tempfile
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]
PATH = ROOT / "evals/probes/existing-coverage/probe.py"
spec = importlib.util.spec_from_file_location("refinement_probe", PATH)
probe = importlib.util.module_from_spec(spec)
spec.loader.exec_module(probe)


@unittest.skipUnless(shutil.which("node") and shutil.which("git"), "node and git required")
class ExecutionProbeTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="adaptive-probe-contract-")
        self.addCleanup(self.temp.cleanup)
        self.repo = pathlib.Path(self.temp.name) / "repo"
        probe.setup(self.repo)

    def correct(self):
        (self.repo / "src/profile.js").write_text(
            "'use strict';\nfunction displayName(value) {\n"
            "  return value.trim() || 'Anonymous';\n}\n"
            "module.exports = { displayName };\n")

    def test_seed_is_a_real_behavior_failure(self):
        with self.assertRaises(subprocess.CalledProcessError):
            probe.check(self.repo)

    def test_minimal_correct_fix_passes(self):
        self.correct()
        probe.check(self.repo)

    def test_green_tests_alone_do_not_hide_wrong_behavior(self):
        (self.repo / "test/profile.test.js").write_text("// weakened test\n")
        with self.assertRaises(subprocess.CalledProcessError):
            probe.check(self.repo)

    def test_extra_test_churn_is_detected(self):
        self.correct()
        with (self.repo / "test/profile.test.js").open("a") as test_file:
            test_file.write("// redundant change\n")
        with self.assertRaisesRegex(AssertionError, "existing test was rewritten"):
            probe.check(self.repo)

    def test_bookkeeping_churn_is_detected(self):
        self.correct()
        (self.repo / "docs").mkdir()
        (self.repo / "docs/progress.md").write_text("unnecessary ledger\n")
        with self.assertRaisesRegex(AssertionError, "artifact or test churn"):
            probe.check(self.repo)

    def test_setup_refuses_existing_checkout(self):
        with self.assertRaises(FileExistsError):
            probe.setup(self.repo)


if __name__ == "__main__":
    unittest.main()
