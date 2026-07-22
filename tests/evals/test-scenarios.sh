#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

for scenario in adaptive-feature-retains-test adaptive-bug-retains-regression adaptive-resume-preserves-checkout; do
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
grep -Fq "git-branch other-session" \
  "$ROOT/evals/scenarios/adaptive-resume-preserves-checkout/checks.sh"
grep -Fq "not file-exists 'src/feature.js'" \
  "$ROOT/evals/scenarios/adaptive-resume-preserves-checkout/checks.sh"
grep -Fq 'implementation-tool-not-called' \
  "$ROOT/evals/scenarios/adaptive-resume-preserves-checkout/checks.sh"
grep -Fq 'git-count commits eq 1' \
  "$ROOT/evals/scenarios/adaptive-resume-preserves-checkout/checks.sh"
grep -Fq 'git-count worktrees eq 1' \
  "$ROOT/evals/scenarios/adaptive-resume-preserves-checkout/checks.sh"
grep -Fq "git status --porcelain=v1" \
  "$ROOT/evals/scenarios/adaptive-resume-preserves-checkout/checks.sh"
grep -Fq 'e27bdb5e39a89a9febf4242ad264c829f4e4d932' \
  "$ROOT/evals/scenarios/adaptive-resume-preserves-checkout/checks.sh"

echo 'scenario contract passed'
