#!/usr/bin/env bash
set -euo pipefail

setup-helpers run create_base_repo
main_repo="${QUORUM_WORKDIR}-main"
mv "$QUORUM_WORKDIR" "$main_repo"

git -C "$main_repo" switch -qc old-task
mkdir -p "$main_repo/src"
printf '%s\n' 'completed old task' > "$main_repo/src/old-task.js"
git -C "$main_repo" add src/old-task.js
git -C "$main_repo" commit -qm 'feat: complete old task'
git -C "$main_repo" branch -f main HEAD
git -C "$main_repo" switch -q main
git -C "$main_repo" worktree add -q "$QUORUM_WORKDIR" old-task
