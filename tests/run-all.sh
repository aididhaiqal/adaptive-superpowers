#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

bash "$ROOT/tests/static/test-profile.sh"
bash "$ROOT/tests/static/test-router-gate.sh"
bash "$ROOT/tests/static/test-completion-lifecycle.sh"
bash "$ROOT/tests/static/test-checkout-safety.sh"
bash "$ROOT/tests/install/test-adapters.sh"
bash "$ROOT/tests/static/test-repository-contract.sh"
bash "$ROOT/tests/evals/test-scenarios.sh"

echo 'all repository tests passed'
