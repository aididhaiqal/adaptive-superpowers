#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GATE="$ROOT/skills/using-superpowers/SKILL.md"
FULL_ROUTER="$ROOT/skills/using-superpowers/references/full-router.md"

require_text() {
  local file="$1"
  local text="$2"
  if ! grep -Fq "$text" "$file"; then
    echo "router contract missing from ${file#"$ROOT/"}: $text" >&2
    exit 1
  fi
}

if [[ ! -f "$FULL_ROUTER" ]]; then
  echo 'router contract missing conditional reference: skills/using-superpowers/references/full-router.md' >&2
  exit 1
fi

require_text "$GATE" 'description: "Use when starting any conversation."'
require_text "$GATE" 'runnable automated test file'
require_text "$GATE" 'fresh targeted verification'
require_text "$GATE" 'exactly three tool batches'
require_text "$GATE" 'references/full-router.md'

gate_words="$(wc -w < "$GATE" | tr -d ' ')"
if (( gate_words > 150 )); then
  echo "router gate is too large: $gate_words words (maximum 150)" >&2
  exit 1
fi

require_text "$FULL_ROUTER" 'add or update automated coverage for observable behavior changes unless infeasible'
require_text "$FULL_ROUTER" 'verification-before-completion'
require_text "$FULL_ROUTER" 'Manual verification alone is insufficient'
require_text "$FULL_ROUTER" 'Preserve user work'

require_text "$ROOT/skills/test-driven-development/SKILL.md" \
  'Do not auto-trigger for a precise low-risk feature'

hook_output="$("$ROOT/hooks/session-start")"
require_text "$ROOT/hooks/session-start" 'skills/using-superpowers/SKILL.md'
if [[ "$hook_output" == *'**High-risk:**'* ]]; then
  echo 'Claude startup hook injected the detailed router instead of only the gate' >&2
  exit 1
fi

echo "optimized router gate contract passed: $gate_words words"
