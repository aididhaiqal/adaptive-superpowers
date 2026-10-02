#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
AUDIT="$ROOT/skills/auditing-tests/SKILL.md"
VALUE="$ROOT/skills/auditing-tests/references/test-value.md"
GATE="$ROOT/skills/using-superpowers/SKILL.md"
ROUTER="$ROOT/skills/using-superpowers/references/full-router.md"
TDD="$ROOT/skills/test-driven-development/SKILL.md"
DOUBLES="$ROOT/skills/test-driven-development/testing-anti-patterns.md"
DEBUG="$ROOT/skills/systematic-debugging/SKILL.md"
REVIEW="$ROOT/skills/requesting-code-review/SKILL.md"
RECEIVE="$ROOT/skills/receiving-code-review/SKILL.md"

require_text() {
  local file="$1"
  local text="$2"
  if [[ ! -f "$file" ]]; then
    echo "test-value contract missing file: ${file#"$ROOT/"}" >&2
    exit 1
  fi
  if ! grep -Fq -- "$text" "$file"; then
    echo "test-value contract missing from ${file#"$ROOT/"}: $text" >&2
    exit 1
  fi
}

# The audit skill owns one discriminative trigger and stays read-only until authorized.
require_text "$AUDIT" 'name: auditing-tests'
require_text "$AUDIT" 'description: "Use when auditing, pruning, or deduplicating existing tests'
require_text "$AUDIT" 'does not authorize edits'
require_text "$AUDIT" '[test-value.md](references/test-value.md)'
require_text "$AUDIT" 'A missing field means the candidate is not ready.'
require_text "$AUDIT" 'Optimize for confidence, not deletion count.'
require_text "$VALUE" '`systematic-debugging`'
require_text "$AUDIT" 'specific existing test'
require_text "$AUDIT" 'callees, sibling implementations'
require_text "$AUDIT" 'without preserving aliases'
require_text "$AUDIT" 'Prefer net-negative production lines.'
require_text "$VALUE" '- exact source, import, or string greps;'
require_text "$AUDIT" '`managing-project-state`'

# The shared value bar serves authoring and audit alike.
require_text "$VALUE" '## Authoring gate'
require_text "$VALUE" '## Junk patterns'
require_text "$VALUE" '## Retention bar'
require_text "$VALUE" 'A missing answer means do not add it yet.'
require_text "$VALUE" 'must fail on the pre-fix code for the intended reason'
require_text "$VALUE" 'cheapest independent guard'
require_text "$VALUE" 'Static or slow is not a deletion reason.'
require_text "$VALUE" 'fixtures that supply the receipt, admission, or callback ordering the owner should produce'

# Every test-writing and test-judging path knows where the bar lives.
require_text "$GATE" 'fails without the change, and needs no test-only production seam or duplicate coverage'
require_text "$ROUTER" 'When the change adds or changes tests, read'
require_text "$ROUTER" 'before the completion review'
require_text "$VALUE" 'see it fail without the change'
require_text "$VALUE" 'against the pre-fix source in a scratch copy'
require_text "$ROUTER" '../../auditing-tests/references/test-value.md#authoring-gate'
require_text "$ROUTER" 'use `auditing-tests`'
require_text "$TDD" 'Check each red test against the authoring gate and junk patterns in [test-value.md](../auditing-tests/references/test-value.md#authoring-gate)'
require_text "$DOUBLES" '../auditing-tests/references/test-value.md'
require_text "$DEBUG" 'at the owner boundary'
require_text "$REVIEW" '[test-value.md](../auditing-tests/references/test-value.md)'
require_text "$RECEIVE" '[authoring gate](../auditing-tests/references/test-value.md#authoring-gate)'

# Reference files are outside validate.sh's SKILL.md link check; resolve their links here.
for file in "$ROUTER" "$DOUBLES" "$VALUE" "$AUDIT" "$TDD" "$REVIEW" "$RECEIVE"; do
  while IFS= read -r link; do
    target="$(dirname "$file")/${link%%#*}"
    if [[ ! -f "$target" ]]; then
      echo "test-value contract: broken link in ${file#"$ROOT/"}: $link" >&2
      exit 1
    fi
  done < <(grep -Eo '\]\([^):]+\.md(#[^)]*)?\)' "$file" | sed -E 's/^\]\(([^)]+)\)$/\1/' || true)
done

# Host-specific tooling from the source skill must not leak into shared policy.
for leaked in vitest crabbox autoreview openclaw run-vitest check-changed; do
  if grep -Fqi -- "$leaked" "$AUDIT" "$VALUE"; then
    echo "test-value contract: host-specific tooling leaked into shared policy: $leaked" >&2
    exit 1
  fi
done

echo 'test-value contract passed'
