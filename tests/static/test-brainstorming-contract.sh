#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BRAINSTORM="$ROOT/skills/brainstorming/SKILL.md"
GATE="$ROOT/skills/using-superpowers/SKILL.md"
ROUTER="$ROOT/skills/using-superpowers/references/full-router.md"
WRITE_PLAN="$ROOT/skills/writing-plans/SKILL.md"
EXECUTE="$ROOT/skills/executing-plans/SKILL.md"

require_text() {
  local file="$1"
  local text="$2"
  if ! grep -Fq "$text" "$file"; then
    echo "brainstorming contract missing from ${file#"$ROOT/"}: $text" >&2
    exit 1
  fi
}

require_text "$BRAINSTORM" 'Scale depth to decision consequence'
require_text "$BRAINSTORM" 'core outcomes promised in the conversation'
require_text "$BRAINSTORM" 'Any exclusion or deferral that weakens a core outcome requires explicit approval.'
require_text "$BRAINSTORM" 'Must deliver'
require_text "$BRAINSTORM" 'Explicitly deferred'
require_text "$BRAINSTORM" 'Open decisions'
require_text "$BRAINSTORM" 'Material adjacent suggestions'
require_text "$BRAINSTORM" 'Stop brainstorming once consequential decisions and acceptance are clear.'

require_text "$GATE" 'Parent owns brainstorming, architecture, scope, and acceptance.'
require_text "$GATE" 'Dispatched agents follow bounded briefs'
require_text "$GATE" 'return material ambiguity to the parent'
require_text "$GATE" 'still test and verify assigned work'
require_text "$GATE" 'Core outcomes cannot be silently narrowed or deferred.'

require_text "$ROUTER" 'smallest sufficient planning surface'
require_text "$ROUTER" 'native session tracking'
require_text "$ROUTER" 'Do not invent microtasks'
require_text "$WRITE_PLAN" 'Do not introduce an unapproved deferral'
require_text "$EXECUTE" 'Do not narrow conversation-level acceptance'

echo 'brainstorming and dynamic-planning contract passed'
