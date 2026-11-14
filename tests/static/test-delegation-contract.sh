#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GATE="$ROOT/skills/using-superpowers/SKILL.md"
FULL_ROUTER="$ROOT/skills/using-superpowers/references/full-router.md"
EXPLORER_HANDOFF="$ROOT/skills/using-superpowers/references/explorer-handoff.md"
DELEGATION="$ROOT/skills/using-superpowers/references/delegation.md"
CHECKER="$ROOT/skills/using-superpowers/scripts/check-children.py"

require_text() {
  local file="$1"
  local text="$2"
  if [[ ! -f "$file" ]]; then
    echo "delegation contract missing file: ${file#"$ROOT/"}" >&2
    exit 1
  fi
  if ! grep -Fq -- "$text" "$file"; then
    echo "delegation contract missing from ${file#"$ROOT/"}: $text" >&2
    exit 1
  fi
}

# Every dispatch path reaches the delegation reference.
require_text "$GATE" "Pass each child this session's model and effort explicitly (\`references/delegation.md\`)."
require_text "$FULL_ROUTER" '[delegation.md](delegation.md)'
require_text "$EXPLORER_HANDOFF" '[delegation.md](delegation.md)'

# Model and effort parity, passed explicitly because host defaults differ.
require_text "$DELEGATION" "the parent's exact model and reasoning effort"
require_text "$DELEGATION" 'unless the user names another'
require_text "$DELEGATION" 'Pass both on every dispatch'
require_text "$DELEGATION" "Never switch a running child's model"
require_text "$DELEGATION" 'Say which pair each child got and why.'

# Channel, fan-out, briefing and waiting.
require_text "$DELEGATION" 'Fan out only independent work'
require_text "$DELEGATION" 'One writer per checkout'
require_text "$DELEGATION" 'not your conclusion'
require_text "$DELEGATION" 'commit <sha or none> · tests <command: outcome> · open <items>'
require_text "$DELEGATION" 'Do not poll'

# Proof comes from what the host recorded, never from the request.
require_text "$DELEGATION" 'requested, not verified'
require_text "$DELEGATION" 'scripts/check-children.py'

python3 -I "$CHECKER" --help >/dev/null
python3 "$ROOT/tests/static/test_check_children.py" 2>&1 | tail -1

echo 'delegation contract passed'
