#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
EXPECTED=(
  brainstorming
  executing-plans
  finishing-a-development-branch
  receiving-code-review
  requesting-code-review
  systematic-debugging
  test-driven-development
  using-git-worktrees
  using-superpowers
  verification-before-completion
  writing-plans
  writing-skills
)

mapfile_compat() {
  while IFS= read -r line; do
    SKILL_FILES+=("$line")
  done
}

SKILL_FILES=()
mapfile_compat < <(find "$ROOT/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -print | sort)

if [[ "${#SKILL_FILES[@]}" -ne "${#EXPECTED[@]}" ]]; then
  echo "expected ${#EXPECTED[@]} skills, found ${#SKILL_FILES[@]}" >&2
  exit 1
fi

for skill in "${EXPECTED[@]}"; do
  test -f "$ROOT/skills/$skill/SKILL.md"
done

for removed in dispatching-parallel-agents subagent-driven-development writing-implementation-logs; do
  test ! -e "$ROOT/skills/$removed"
done

GATE="$ROOT/skills/using-superpowers/SKILL.md"
FULL_ROUTER="$ROOT/skills/using-superpowers/references/full-router.md"

grep -Fq 'runnable automated test file' "$GATE"
grep -Fq 'transient checks do not count' "$GATE"
grep -Fq 'add or update automated coverage for observable behavior changes unless infeasible' \
  "$FULL_ROUTER"
grep -Fq 'Manual verification alone is insufficient' "$FULL_ROUTER"
grep -Fq 'do not ask whether to add it' "$FULL_ROUTER"
grep -Fq 'confirmed regression' "$ROOT/skills/test-driven-development/SKILL.md"
grep -Fq 'Evaluation-only requests remain read-only.' \
  "$ROOT/skills/receiving-code-review/SKILL.md"
grep -Fq 'For diagnosis-only requests' \
  "$ROOT/skills/systematic-debugging/SKILL.md"
grep -Fq 'If no independent reviewer is available' \
  "$ROOT/skills/requesting-code-review/SKILL.md"
grep -Fq 'Reuse fresh evidence' \
  "$ROOT/skills/verification-before-completion/SKILL.md"

if grep -Eiq 'mandatory subagent|fresh subagent|spawn_agent|followup_task|fork_turns' "${SKILL_FILES[@]}"; then
  echo 'runtime skills contain bundle-owned delegation policy' >&2
  exit 1
fi

test ! -e "$ROOT/skills/brainstorming/scripts/server.cjs"

echo "profile contract passed: ${#EXPECTED[@]} skills"
