---
name: using-git-worktrees
description: "Create or reuse an isolated Git worktree for material plan execution, risky or concurrent implementation, or editing delegation when isolation protects existing work."
---

# Git Worktrees

Skip creation for short local changes that can safely preserve user work. Reuse the current checkout when it already provides appropriate isolation. Material or High-risk plan execution, concurrent or resumable implementation, and use of an editing subagent require isolation unless the current checkout already supplies it.

1. Read repository instructions and capture the repository root, worktree path, branch, HEAD, and status before changing state.
2. Detect whether the current checkout is a linked worktree or submodule; reuse valid existing isolation.
3. Prefer a Codex CLI or harness-native worktree mechanism. Fall back to `git worktree` only when no native mechanism exists.
4. Follow an explicit directory preference, then an established repository convention. For a project-local directory, verify it is ignored before creation.
5. Create a dedicated branch and worktree without disturbing existing changes.
6. Run only repository-documented setup commands; avoid blind dependency installation or lockfile mutation.
7. Run a cheap, relevant baseline check before implementation.

Revalidate checkout identity after resume or compaction and before mutation, editing delegation, commit, or branch operations. Stop if the worktree, branch, HEAD, or ownership changed, or if unrelated work appeared. Live state overrides stale summaries and progress artifacts.

Do not edit `.gitignore` without authorization or silently work in place when isolation is required. Stop when overlapping changes, permissions, conflicts, or baseline failures make attribution unsafe; proceed with a known failure only when it is clearly unrelated and reported.

Report the path, branch, setup, baseline result, pre-existing failures, and confirmation that the original checkout and user work remain untouched.
