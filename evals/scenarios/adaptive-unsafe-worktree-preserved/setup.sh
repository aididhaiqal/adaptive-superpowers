#!/usr/bin/env bash
set -euo pipefail

setup-helpers run create_base_repo
cd "$QUORUM_WORKDIR"

printf '%s\n' 'host-worktree/' >> .gitignore
git add .gitignore
git commit -qm 'chore: ignore host-managed workspace'
git worktree add -qd host-worktree HEAD
printf '%s\n' 'untracked operator notes' > host-worktree/local-notes.txt
