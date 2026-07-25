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
require_text "$BRAINSTORM" 'When one unanswered user decision controls the direction, ask one focused question before proposing a detailed design or implementing the affected behavior.'
require_text "$BRAINSTORM" 'Do not use reversibility, configuration, defaults, or parallel branches to choose a consequential outcome without approval.'
require_text "$BRAINSTORM" 'Unrelated safe inspection may continue.'

require_text "$GATE" 'The parent owns brainstorming, architecture, scope, acceptance criteria, and user decisions.'
require_text "$GATE" 'Give dispatched agents bounded briefs.'
require_text "$GATE" 'return material ambiguity to the parent'
require_text "$GATE" 'test and verify their assigned work'
require_text "$GATE" 'Core outcomes cannot be silently narrowed or deferred.'
require_text "$GATE" 'If a user choice could materially change the requested result, ask one focused question before making the affected changes'
require_text "$GATE" 'do not bypass it with provisional defaults, configuration, or multiple implementations.'
require_text "$GATE" 'Offer material recommendations only when evidence supports them.'
require_text "$GATE" 'Recommendations do not authorize additional work.'

require_text "$ROUTER" 'smallest sufficient planning surface'
require_text "$ROUTER" 'native session tracking'
require_text "$ROUTER" 'Do not invent microtasks'
require_text "$WRITE_PLAN" 'Do not introduce an unapproved deferral'
require_text "$EXECUTE" 'Do not narrow conversation-level acceptance'

echo 'brainstorming and dynamic-planning contract passed'
