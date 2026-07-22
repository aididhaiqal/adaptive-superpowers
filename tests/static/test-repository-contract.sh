#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

test -f "$ROOT/README.md"
test -f "$ROOT/LICENSE"
test -f "$ROOT/assets/adaptive-superpowers-hero.svg"
grep -Fq 'Move fast. Keep the proof.' "$ROOT/assets/adaptive-superpowers-hero.svg"
grep -Fq 'Risk-adaptive engineering workflows optimized for GPT-5.6 and Claude 5.' "$ROOT/README.md"
grep -Fq 'aididhaiqal/adaptive-superpowers' "$ROOT/README.md"
grep -Fq '## Install' "$ROOT/README.md"
grep -Fq '```mermaid' "$ROOT/README.md"
grep -Fq '150-word adaptive gate' "$ROOT/README.md"
test -f "$ROOT/CHANGELOG.md"
test -f "$ROOT/AGENTS.md"
test -x "$ROOT/scripts/validate.sh"

grep -Fq 'd884ae04edebef577e82ff7c4e143debd0bbec99' "$ROOT/README.md"
grep -Fq 'aa973775906c8761a78019aaa21e4f0ccd987925' "$ROOT/README.md"
grep -Fq 'GPT-5.6 Sol' "$ROOT/README.md"
grep -Fq 'GPT-5.6 Sol Standard' "$ROOT/README.md"
grep -Fq 'Claude Opus 4.8' "$ROOT/README.md"
grep -Fq 'Claude Fable 5' "$ROOT/README.md"
grep -Fq 'observable behavior' "$ROOT/README.md"
grep -Fq 'Fast mode uses 2.5 times ChatGPT credits' "$ROOT/README.md"
grep -Fq 'sub-60-second Sol Fast cohort' "$ROOT/README.md"
grep -Fq 'adaptive-feature-retains-test' "$ROOT/README.md"
grep -Fq 'adaptive-bug-retains-regression' "$ROOT/README.md"
grep -Fq 'planned broader coverage' "$ROOT/README.md"
grep -Fq 'docs/evaluations/2026-07-22-optimized-adaptive-router.md' "$ROOT/README.md"
grep -Fq 'evaluations/2026-07-22-optimized-adaptive-router.md' "$ROOT/docs/evaluation.md"
grep -Fq '**Candidate commit:** `0a62f38`' \
  "$ROOT/docs/evaluations/2026-07-22-optimized-adaptive-router.md"
grep -Fq '**Verdict:** Approved for experimental release under the 2026-07-22 Fast-mode feasibility qualification.' \
  "$ROOT/docs/evaluations/2026-07-22-optimized-adaptive-router.md"
grep -Fq '**Status:** Approved for experimental release under the 2026-07-22 Fast-mode feasibility qualification.' \
  "$ROOT/docs/superpowers/specs/2026-07-22-optimized-adaptive-router-design.md"
grep -Fq 'MIT License' "$ROOT/LICENSE"

bash "$ROOT/scripts/validate.sh"

echo 'repository contract passed'
