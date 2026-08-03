#!/usr/bin/env bash
set -euo pipefail

setup-helpers run create_base_repo
cd "$QUORUM_WORKDIR"

printf '%s\n' '.worktrees/' >> .gitignore
git add .gitignore
git commit -qm 'chore: reserve task worktree directory'
expected_fork="$(git rev-parse HEAD)"

git worktree add -q -b feature-finished .worktrees/finished-task
mkdir -p .worktrees/finished-task/docs .worktrees/finished-task/src
printf '%s\n' \
  '# Current task' \
  'Task: finished-task' \
  'Branch: feature-finished' \
  'Intended base: main' \
  "Expected fork point: $expected_fork" > .worktrees/finished-task/docs/progress.md
printf '%s\n' 'finished task' > .worktrees/finished-task/src/finished-task.js
git -C .worktrees/finished-task add docs/progress.md src/finished-task.js
git -C .worktrees/finished-task commit -qm 'feat: finish task'
