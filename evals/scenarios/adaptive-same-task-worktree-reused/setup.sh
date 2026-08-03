#!/usr/bin/env bash
set -euo pipefail

setup-helpers run create_base_repo
main_repo="${QUORUM_WORKDIR}-main"
mv "$QUORUM_WORKDIR" "$main_repo"
expected_fork="$(git -C "$main_repo" rev-parse HEAD)"

git -C "$main_repo" switch -qc feature-reporting
mkdir -p "$main_repo/docs" "$main_repo/src"
printf '%s\n' \
  '# Current task' \
  'Task: reporting' \
  'Branch: feature-reporting' \
  'Intended base: main' \
  "Expected fork point: $expected_fork" > "$main_repo/docs/progress.md"
printf '%s\n' 'accepted reporting work' > "$main_repo/src/reporting-work.js"
git -C "$main_repo" add docs/progress.md src/reporting-work.js
git -C "$main_repo" commit -qm 'feat: begin reporting task'

git -C "$main_repo" switch -q main
git -C "$main_repo" worktree add -q "$QUORUM_WORKDIR" feature-reporting
