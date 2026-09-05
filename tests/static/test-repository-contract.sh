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
grep -Fq '### Choose your host' "$ROOT/README.md"
grep -Fq '### Clone once' "$ROOT/README.md"
grep -Fq '### Install on Codex' "$ROOT/README.md"
grep -Fq '### Install on Claude Code' "$ROOT/README.md"
grep -Fq '### Verify the installation' "$ROOT/README.md"
grep -Fq '### Update' "$ROOT/README.md"
grep -Fq '### Remove' "$ROOT/README.md"
grep -Fq 'Do not enable Adaptive Superpowers alongside another Superpowers installation.' "$ROOT/README.md"
grep -Fq 'claude plugin disable superpowers@claude-plugins-official' "$ROOT/README.md"
grep -Fq 'claude plugin marketplace add "$REPO"' "$ROOT/README.md"
grep -Fq 'claude plugin install adaptive-superpowers@adaptive-superpowers-dev' "$ROOT/README.md"
grep -Fq 'claude plugin details adaptive-superpowers@adaptive-superpowers-dev' "$ROOT/README.md"
grep -Fq 'claude --plugin-dir "$REPO"' "$ROOT/README.md"
grep -Fq 'claude plugin update adaptive-superpowers@adaptive-superpowers-dev' "$ROOT/README.md"
grep -Fq 'claude plugin uninstall adaptive-superpowers@adaptive-superpowers-dev' "$ROOT/README.md"
grep -Fq 'Start a new Codex task or Claude session after installing or updating.' "$ROOT/README.md"
grep -Fq '## Optional Codex subagents' "$ROOT/README.md"
grep -Fq '~/.codex/agents/explorer.toml' "$ROOT/README.md"
grep -Fq '~/.codex/agents/feature-reviewer.toml' "$ROOT/README.md"
grep -Fq '~/.codex/agents/final-reviewer.toml' "$ROOT/README.md"
grep -Fq 'These model assignments are an optional Codex POC profile' "$ROOT/README.md"
grep -Fq 'Adaptive Superpowers does not set global thread or depth limits.' "$ROOT/README.md"
grep -Fq 'Codex still applies its own defaults when those settings are absent.' "$ROOT/README.md"
grep -Fq 'Delegation follows scope, independence, and host limits' "$ROOT/README.md"
grep -Fq 'Task review is selective, not a per-task ceremony.' "$ROOT/README.md"
grep -Fq 'Overall review is the integration gate for a substantial branch or release.' "$ROOT/README.md"
if grep -Eq '^max_(threads|depth) = ' "$ROOT/README.md"; then
  echo 'README must not prescribe global Codex thread or depth limits' >&2
  exit 1
fi
mermaid_count="$(grep -Fc '```mermaid' "$ROOT/README.md")"
if [[ "$mermaid_count" -lt 4 ]]; then
  echo "README must keep the four distinct visual explanations; found $mermaid_count" >&2
  exit 1
fi
grep -Fq '#### One clone, two hosts' "$ROOT/README.md"
grep -Fq '### The proof loop' "$ROOT/README.md"
grep -Fq 'Parent<br/>decisions · architecture · acceptance' "$ROOT/README.md"
grep -Fq 'A compact gate is always loaded' "$ROOT/README.md"
grep -Fq 'The Claude output should show 13 skills and one `SessionStart` hook.' "$ROOT/README.md"
grep -Fq 'Project state without project-management theatre' "$ROOT/README.md"
grep -Fq 'There are 13 shared runtime skills.' "$ROOT/README.md"
test -f "$ROOT/docs/superpowers/specs/2026-08-02-managing-project-state-design.md"
grep -Fq '**Status:** Approved for implementation on 2026-08-02.' \
  "$ROOT/docs/superpowers/specs/2026-08-02-managing-project-state-design.md"

install_line="$(grep -n '^## Install$' "$ROOT/README.md" | cut -d: -f1)"
why_line="$(grep -n '^## Why$' "$ROOT/README.md" | cut -d: -f1)"
if [[ -z "$install_line" || -z "$why_line" || "$install_line" -ge "$why_line" ]]; then
  echo 'README must put installation before architecture and project rationale' >&2
  exit 1
fi
test -f "$ROOT/CHANGELOG.md"
test -f "$ROOT/AGENTS.md"
test -x "$ROOT/scripts/validate.sh"

grep -Fq 'd884ae04edebef577e82ff7c4e143debd0bbec99' "$ROOT/README.md"
grep -Fq 'aa973775906c8761a78019aaa21e4f0ccd987925' "$ROOT/README.md"
grep -Fq 'GPT-5.6 Sol' "$ROOT/README.md"
grep -Fq 'GPT-5.6 Sol Standard' "$ROOT/README.md"
grep -Fq 'GPT-5.6 Terra Standard' "$ROOT/README.md"
grep -Fq 'Claude Opus 5' "$ROOT/README.md"
grep -Fq 'Claude Fable 5' "$ROOT/README.md"
grep -Fq 'observable behavior' "$ROOT/README.md"
grep -Fq 'All six untreated controls produced working behavior but no retained test.' "$ROOT/README.md"
grep -Fq "the focused guard then changed Fable's" "$ROOT/README.md"
grep -Fq 'Fast reduced median Codex wall time' "$ROOT/README.md"
grep -Fq 'adaptive-feature-retains-test' "$ROOT/README.md"
grep -Fq 'adaptive-bug-retains-regression' "$ROOT/README.md"
grep -Fq 'planned broader coverage' "$ROOT/README.md"
grep -Fq 'docs/evaluations/2026-07-25-opus5-precision-benchmark.md' "$ROOT/README.md"
grep -Fq 'evaluations/2026-07-25-opus5-precision-benchmark.md' "$ROOT/docs/evaluation.md"
grep -Fq 'evaluations/2026-07-22-optimized-adaptive-router.md' "$ROOT/docs/evaluation.md"
grep -Fq 'evaluations/2026-07-22-codex-terra-explorer-poc.md' "$ROOT/docs/evaluation.md"
test -f "$ROOT/docs/evaluations/2026-07-25-opus5-precision-benchmark.md"
test -f "$ROOT/docs/evaluations/2026-07-22-codex-terra-explorer-poc.md"
grep -Fq '**Candidate commit:** `0a62f38`' \
  "$ROOT/docs/evaluations/2026-07-22-optimized-adaptive-router.md"
grep -Fq '**Verdict:** Approved for experimental release under the 2026-07-22 Fast-mode feasibility qualification.' \
  "$ROOT/docs/evaluations/2026-07-22-optimized-adaptive-router.md"
grep -Fq '**Status:** Approved for experimental release under the 2026-07-22 Fast-mode feasibility qualification.' \
  "$ROOT/docs/superpowers/specs/2026-07-22-optimized-adaptive-router-design.md"
grep -Fq 'MIT License' "$ROOT/LICENSE"

python3 "$ROOT/tests/static/validate-readme-agent-blocks.py"
bash "$ROOT/scripts/validate.sh"

echo 'repository contract passed'
