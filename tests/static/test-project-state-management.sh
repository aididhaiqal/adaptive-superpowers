#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
STATE="$ROOT/skills/managing-project-state/SKILL.md"
MODEL="$ROOT/skills/managing-project-state/references/state-model.md"
INSTRUCTIONS="$ROOT/skills/managing-project-state/references/repository-instructions.md"
ARCHIVE="$ROOT/skills/managing-project-state/references/archival-and-validation.md"
AUDITOR="$ROOT/skills/managing-project-state/scripts/audit_project_state.py"
GATE="$ROOT/skills/using-superpowers/SKILL.md"

require_text() {
  local file="$1"
  local text="$2"
  if ! grep -Fq "$text" "$file"; then
    echo "project-state contract missing from ${file#"$ROOT/"}: $text" >&2
    exit 1
  fi
}

test -f "$STATE"
test -f "$MODEL"
test -f "$INSTRUCTIONS"
test -f "$ARCHIVE"
test -x "$AUDITOR"

require_text "$STATE" 'name: managing-project-state'
require_text "$STATE" 'material, resumable, persistent, or repository-tracked work'
require_text "$STATE" 'skip routine isolated work'
require_text "$STATE" 'Compact history without weakening unresolved commitments.'
require_text "$STATE" 'implemented, tested, committed, pushed, merged, deployed, and runtime-verified'
require_text "$STATE" 'Convention profile'
require_text "$STATE" 'Managed profile'
require_text "$STATE" 'Do not create a parallel ledger'
require_text "$STATE" 'task, worktree path, branch, intended base and fork point, ownership, and disposition'
require_text "$GATE" '`managing-project-state`'
require_text "$GATE" 'repository-required canonical progress or status record'

require_text "$MODEL" 'queued'
require_text "$MODEL" 'future-watch'
require_text "$MODEL" 'explicit authority and a recorded disposition'
require_text "$MODEL" 'first unfinished accepted outcome'
require_text "$MODEL" 'never overrides or duplicates the canonical project record'
require_text "$MODEL" 'every unresolved blocker, external gate, accepted exclusion, pending outcome, and material watch item'

require_text "$INSTRUCTIONS" 'AGENTS.md'
require_text "$INSTRUCTIONS" 'CLAUDE.md'
require_text "$INSTRUCTIONS" 'routine implementation'
require_text "$ARCHIVE" 'must not enumerate or load the evidence archive'
require_text "$ARCHIVE" 'raw model trajectories'
require_text "$ARCHIVE" 'not_evaluated'

require_text "$ROOT/scripts/validate.sh" 'EXPECTED_SKILLS=13'
require_text "$ROOT/scripts/validate.sh" 'MAX_TOTAL_WORDS=4400'

python3 "$AUDITOR" --help >/dev/null
python3 "$ROOT/tests/static/test_project_state_auditor.py"

echo 'project-state management contract passed'
