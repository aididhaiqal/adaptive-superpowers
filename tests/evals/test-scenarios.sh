#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

for scenario in adaptive-feature-retains-test adaptive-bug-retains-regression; do
  dir="$ROOT/evals/scenarios/$scenario"
  test -f "$dir/story.md"
  test -x "$dir/setup.sh"
  test -f "$dir/checks.sh"
  grep -Fq 'file-exists' "$dir/checks.sh"
  grep -Fq 'command-succeeds' "$dir/checks.sh"
done

grep -Fq "file-exists '**/*test*.js'" \
  "$ROOT/evals/scenarios/adaptive-feature-retains-test/checks.sh"
grep -Fq "file-exists '**/*test*.js'" \
  "$ROOT/evals/scenarios/adaptive-bug-retains-regression/checks.sh"
grep -Fq 'check-transcript investigated' \
  "$ROOT/evals/scenarios/adaptive-bug-retains-regression/checks.sh"

echo 'scenario contract passed'
