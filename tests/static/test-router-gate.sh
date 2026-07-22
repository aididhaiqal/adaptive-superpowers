#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GATE="$ROOT/skills/using-superpowers/SKILL.md"
FULL_ROUTER="$ROOT/skills/using-superpowers/references/full-router.md"
EXPLORER_HANDOFF="$ROOT/skills/using-superpowers/references/explorer-handoff.md"

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
if [[ ! -f "$EXPLORER_HANDOFF" ]]; then
  echo 'router contract missing conditional reference: skills/using-superpowers/references/explorer-handoff.md' >&2
  exit 1
fi

require_text "$GATE" 'description: "Use when starting any conversation."'
require_text "$GATE" 'runnable automated test file'
require_text "$GATE" 'when feasible'
require_text "$GATE" 'fresh targeted verification'
require_text "$GATE" 'After reading this gate, use three task phases'
require_text "$GATE" 'file contents'
require_text "$GATE" 'sole pre-work update'
require_text "$GATE" 'do not restate acceptance'
require_text "$GATE" 'Remain in phase 3 while repairing failures'
require_text "$GATE" 'references/full-router.md'
require_text "$GATE" 'For bulky independent investigation, use one available read-only explorer'
require_text "$GATE" 'otherwise inspect locally'
require_text "$GATE" 'Keep coupled work here'
require_text "$GATE" 'references/explorer-handoff.md'

require_text "$EXPLORER_HANDOFF" 'Keep decisions and coupled implementation in the parent.'
require_text "$EXPLORER_HANDOFF" 'would materially burden the parent context'
require_text "$EXPLORER_HANDOFF" 'Never claim runtime behavior from inspection alone.'
require_text "$EXPLORER_HANDOFF" 'Measure elapsed time in the parent'
require_text "$EXPLORER_HANDOFF" 'If no explorer is available'

if grep -Fq 'repeat batch 3' "$GATE"; then
  echo 'router gate must keep repairs inside phase 3 instead of repeating a batch' >&2
  exit 1
fi

gate_words="$(wc -w < "$GATE" | tr -d ' ')"
if (( gate_words != 150 )); then
  echo "router gate has $gate_words words (expected exactly 150)" >&2
  exit 1
fi
require_text "$ROOT/README.md" "A ${gate_words}-word gate is always loaded"

require_text "$FULL_ROUTER" 'add or update automated coverage for observable behavior changes unless infeasible'
require_text "$FULL_ROUTER" 'verification-before-completion'
require_text "$FULL_ROUTER" 'Manual verification alone is insufficient'
require_text "$FULL_ROUTER" 'Preserve user work'

require_text "$ROOT/skills/test-driven-development/SKILL.md" \
  'Do not auto-trigger for a precise low-risk feature'

HOOK_PROJECT="$(mktemp -d "${TMPDIR:-/tmp}/adaptive-superpowers-hook.XXXXXX")"
trap 'rm -rf "$HOOK_PROJECT"' EXIT
hook_output="$(cd "$HOOK_PROJECT" && "$ROOT/hooks/session-start")"
require_text "$ROOT/hooks/session-start" 'skills/using-superpowers/SKILL.md'
hook_context="$(printf '%s\n' "$hook_output" | python3 -c 'import json, sys; print(json.load(sys.stdin)["hookSpecificOutput"]["additionalContext"])')"
if [[ "$hook_context" != *'description: "Use when starting any conversation."'* ]]; then
  echo 'Claude startup hook did not inject the mandatory gate' >&2
  exit 1
fi
hook_router_path="$(printf '%s\n' "$hook_context" | sed -n 's#^<ADAPTIVE_SUPERPOWERS_FULL_ROUTER>\(.*\)</ADAPTIVE_SUPERPOWERS_FULL_ROUTER>$#\1#p')"
if [[ "$hook_router_path" != "$FULL_ROUTER" ]]; then
  echo "Claude startup hook did not identify the shared full router: $hook_router_path" >&2
  exit 1
fi
if [[ ! -r "$hook_router_path" ]]; then
  echo "Claude startup hook identified an unreadable full router: $hook_router_path" >&2
  exit 1
fi
if [[ "$hook_output" == *'**High-risk:**'* ]]; then
  echo 'Claude startup hook injected the detailed router instead of only the gate' >&2
  exit 1
fi

echo "optimized router gate contract passed: $gate_words words"
