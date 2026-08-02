#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GATE="$ROOT/skills/using-superpowers/SKILL.md"
ROUTER="$ROOT/skills/using-superpowers/references/full-router.md"
PLANS="$ROOT/skills/writing-plans/SKILL.md"
EXECUTE="$ROOT/skills/executing-plans/SKILL.md"
TDD="$ROOT/skills/test-driven-development/SKILL.md"
REVIEW="$ROOT/skills/requesting-code-review/SKILL.md"
STATE="$ROOT/skills/managing-project-state/SKILL.md"
STATE_MODEL="$ROOT/skills/managing-project-state/references/state-model.md"

require_text() {
  local file="$1"
  local text="$2"
  if ! grep -Fq "$text" "$file"; then
    echo "goal execution contract missing from ${file#"$ROOT/"}: $text" >&2
    exit 1
  fi
}

require_text "$GATE" 'Project state'
require_text "$GATE" 'Infer the stopping condition'
require_text "$GATE" 'optional recommendations do not extend the goal'
require_text "$GATE" 'When automation is infeasible, state why.'

require_text "$ROUTER" 'applicable canonical path'
require_text "$ROUTER" 'materially different stopping conditions'
require_text "$ROUTER" 'broader affected or full suites'
require_text "$ROUTER" 'known environment-blocked lane'
require_text "$STATE" 'governing plan or canonical current record'
require_text "$STATE" 'coherent milestones and completion'
require_text "$STATE_MODEL" 'Temporary execution state may checkpoint'
require_text "$STATE_MODEL" 'never overrides or duplicates the canonical project record'
require_text "$STATE_MODEL" 'Consolidating a canonical record must preserve every unresolved blocker, external gate, accepted exclusion, pending outcome, and material watch item with an explicit disposition.'

require_text "$PLANS" 'One governing plan'
require_text "$PLANS" 'resumed turns'
require_text "$PLANS" 'worth an independent review boundary'

require_text "$EXECUTE" 'first unfinished accepted outcome'
require_text "$EXECUTE" 'Do not repeat completed outcomes'

require_text "$TDD" 'Do not run a broader suite after every slice.'

require_text "$REVIEW" 'coherent feature boundary'
require_text "$REVIEW" 'Do not ask a reviewer to rerun tests'
require_text "$REVIEW" 'verify any claim its evidence does not support'
require_text "$REVIEW" 'one grouped fix wave'
require_text "$REVIEW" 'applicable repository abstraction'

echo 'goal, planning, verification, and review cadence contract passed'
