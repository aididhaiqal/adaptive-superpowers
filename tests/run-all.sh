#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

bash "$ROOT/tests/static/test-profile.sh"
bash "$ROOT/tests/static/test-router-gate.sh"
bash "$ROOT/tests/static/test-adaptive-refinements.sh"
bash "$ROOT/tests/static/test-brainstorming-contract.sh"
bash "$ROOT/tests/static/test-goal-execution-contract.sh"
bash "$ROOT/tests/static/test-project-state-management.sh"
bash "$ROOT/tests/static/test-completion-lifecycle.sh"
bash "$ROOT/tests/static/test-checkout-safety.sh"
bash "$ROOT/tests/install/test-adapters.sh"
PYTHONDONTWRITEBYTECODE=1 python3 "$ROOT/tests/install/test_codex_metadata.py"
PYTHONDONTWRITEBYTECODE=1 python3 "$ROOT/tests/install/test_installation_check.py"
PYTHONDONTWRITEBYTECODE=1 python3 "$ROOT/tests/install/test_hook_dispatch.py"
bash "$ROOT/tests/static/test-repository-contract.sh"
bash "$ROOT/tests/evals/test-scenarios.sh"
PYTHONDONTWRITEBYTECODE=1 python3 "$ROOT/tests/evals/test_refinement_probe.py"

echo 'all repository tests passed'
