#!/usr/bin/env bash
set -euo pipefail

setup-helpers run create_base_repo
cd "$QUORUM_WORKDIR"

printf '%s\n' '.worktrees/' >> .gitignore
printf '%s\n' '#!/usr/bin/env bash' 'test ! -f src/failing-task.js' > verify.sh
chmod +x verify.sh
git add .gitignore verify.sh
git commit -qm 'chore: add merged-result verification'
expected_fork="$(git rev-parse HEAD)"

git worktree add -q -b feature-failing .worktrees/failing-task
mkdir -p .worktrees/failing-task/docs .worktrees/failing-task/src
printf '%s\n' \
  '# Current task' \
  'Task: failing-task' \
  'Branch: feature-failing' \
  'Intended base: main' \
  "Expected fork point: $expected_fork" > .worktrees/failing-task/docs/progress.md
printf '%s\n' 'break merged verification' > .worktrees/failing-task/src/failing-task.js
git -C .worktrees/failing-task add docs/progress.md src/failing-task.js
git -C .worktrees/failing-task commit -qm 'feat: add failing task'
