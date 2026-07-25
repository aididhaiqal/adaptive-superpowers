---
name: using-git-worktrees
description: "Create or reuse an isolated Git worktree for material plan execution, risky or concurrent implementation, or editing delegation when isolation protects existing work."
---

# Git Worktrees

Skip creation for short local changes that can safely preserve user work. Unrelated changes mean the current checkout is not appropriate isolation for new material or resumable work. Material or High-risk plan execution, concurrent or resumable implementation, and use of an editing subagent require isolation unless the current checkout already supplies it.

1. Read repository instructions and capture the repository root, worktree path, branch, HEAD, and status before changing state.
2. Detect whether the current checkout is a linked worktree or submodule; reuse valid existing isolation.
3. Use harness-native worktrees only when they leave the original checkout unchanged; otherwise use `git worktree` outside the repository. Never add ignore files/rules to conceal them.
4. Follow explicit directory preference, then repository convention; verify any project-local directory is already ignored.
5. Create a dedicated branch and worktree without disturbing existing changes.
6. Run only repository-documented setup commands; avoid blind dependency installation or lockfile mutation.
7. Run a cheap, relevant baseline check before implementation.

Revalidate checkout identity after resume or compaction and before mutation, editing delegation, commit, or branch operations. Stop if the worktree, branch, HEAD, or ownership changed, or if unrelated work appeared. Live state overrides stale summaries and progress artifacts.

Do not edit `.gitignore` without authorization or silently work in place when isolation is required. Stop when overlapping changes, permissions, conflicts, or baseline failures make attribution unsafe; proceed with a known failure only when it is clearly unrelated and reported.

Report the path, branch, setup, baseline result, pre-existing failures, and confirmation that the original checkout and user work remain untouched.
