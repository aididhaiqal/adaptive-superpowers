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
require_text "$GATE" 'Existing sufficient retained coverage counts'
require_text "$GATE" 'understood local impact and focused verification'
require_text "$GATE" 'fresh targeted verification'
require_text "$GATE" 'For every fast-path implementation'
require_text "$GATE" 'file contents'
require_text "$GATE" 'Before working, send one concise update.'
require_text "$GATE" 'Do not send another pre-work update or restate the acceptance criteria.'
require_text "$GATE" 'Repair failures before moving beyond verification'
require_text "$GATE" 'references/full-router.md'
require_text "$GATE" 'After resume or compaction, revalidate'
require_text "$GATE" 'concurrent or delegated editing'
require_text "$GATE" 'For bulky independent investigation, use available read-only explorers'
require_text "$GATE" 'otherwise inspect locally'
require_text "$GATE" 'Keep integration and user decisions in the parent context.'
require_text "$GATE" 'references/explorer-handoff.md'
require_text "$GATE" 'If a user choice could materially change the requested result, ask one focused question before making the affected changes'
require_text "$GATE" 'do not bypass it with provisional defaults, configuration, or multiple implementations.'
require_text "$GATE" 'Unrelated safe inspection may continue.'
require_text "$GATE" 'Offer material recommendations only when evidence supports them.'
require_text "$GATE" 'Recommendations do not authorize additional work.'
require_text "$GATE" '`managing-project-state`'

require_text "$EXPLORER_HANDOFF" 'Keep user decisions and coupled implementation with their owner.'
require_text "$EXPLORER_HANDOFF" 'would materially burden the parent context'
require_text "$EXPLORER_HANDOFF" 'Never claim runtime behavior from inspection alone.'
require_text "$EXPLORER_HANDOFF" 'Measure elapsed time in the parent'
require_text "$EXPLORER_HANDOFF" 'If no explorer is available'

if grep -Fq 'repeat batch 3' "$GATE"; then
  echo 'router gate must keep repairs inside phase 3 instead of repeating a batch' >&2
  exit 1
fi

gate_words="$(wc -w < "$GATE" | tr -d ' ')"
require_text "$ROOT/README.md" 'A compact gate is always loaded'

exact_count_message='expected exactly 2''00'
exact_count_comparison='gate_words != 2''00'
if grep -Fq "$exact_count_message" "$0" || grep -Fq "$exact_count_comparison" "$0"; then
  echo 'router gate contract must not enforce an exact 200-word target' >&2
  exit 1
fi
if grep -Eq '200-word([[:space:]]+adaptive)?[[:space:]]+gate' "$GATE" "$ROOT/README.md" "$ROOT/docs/architecture.md"; then
  echo 'active router documentation must describe behavior instead of a 200-word target' >&2
  exit 1
fi

require_text "$FULL_ROUTER" 'retain sufficient automated coverage for observable behavior changes unless infeasible'
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
