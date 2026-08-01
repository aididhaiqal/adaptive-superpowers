#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
REVIEW="$ROOT/skills/requesting-code-review/SKILL.md"
EXECUTE="$ROOT/skills/executing-plans/SKILL.md"
FINISH="$ROOT/skills/finishing-a-development-branch/SKILL.md"
WRITING="$ROOT/skills/writing-plans/SKILL.md"
ROUTER="$ROOT/skills/using-superpowers/references/full-router.md"
GATE="$ROOT/skills/using-superpowers/SKILL.md"
README="$ROOT/README.md"

require_text() {
  local file="$1"
  local text="$2"
  if ! grep -Fq "$text" "$file"; then
    echo "completion contract missing from ${file#"$ROOT/"}: $text" >&2
    exit 1
  fi
}

require_text "$ROUTER" 'final completion review after technical verification'
require_text "$REVIEW" 'anything missing, incorrect, incomplete, or poorly integrated'
require_text "$REVIEW" 'Blocking findings'
require_text "$REVIEW" 'Material recommendations'
require_text "$REVIEW" 'Recommendations do not block completion or authorize more implementation.'
require_text "$REVIEW" 'Do not invent recommendations merely to fill the section.'
require_text "$EXECUTE" 'perform the final completion review after technical verification'
require_text "$EXECUTE" 'use `finishing-a-development-branch` only when delivery is requested or already authorized'
require_text "$EXECUTE" 'canonical progress or status record'
require_text "$FINISH" 'required completion review has no unresolved blocking findings'
require_text "$FINISH" 'required canonical progress or status record is reconciled'
require_text "$GATE" 'review the final diff against the request and acceptance criteria'
require_text "$GATE" 'repository-required canonical progress or status record'
require_text "$GATE" 'Supported Critical or Important findings block completion'
require_text "$GATE" 'Offer material recommendations only when evidence supports them.'
require_text "$GATE" 'Recommendations do not authorize additional work.'
require_text "$ROUTER" 'recommendations remain optional and authorize no work'
require_text "$ROUTER" '## Durable progress'
require_text "$ROUTER" 'docs/progress.md'
require_text "$ROUTER" 'If none exists, use or create one `docs/progress.md` for material or resumable project work'
require_text "$ROUTER" 'implemented, tested, committed, pushed, merged, deployed, and runtime-verified'
require_text "$ROUTER" 'Plans and task reports remain intent or supporting evidence'
require_text "$WRITING" 'one canonical project record rather than per-plan logs'
require_text "$README" 'Separate supported blocking findings from material recommendations.'
require_text "$README" 'For each recommendation, cite evidence, expected value, and relevant cost or trade-off.'
require_text "$README" 'P --> C'

if grep -Fq 'P --> CR' "$README"; then
  echo 'full-router diagram must not skip implementation and verification' >&2
  exit 1
fi

echo 'completion lifecycle contract passed'
