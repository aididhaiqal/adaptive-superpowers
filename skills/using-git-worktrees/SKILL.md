---
name: using-git-worktrees
description: "Create dedicated Git worktrees for new material tasks, or reuse an existing worktree only for an attributable continuation of the same unmerged task."
---

# Git Worktrees

Unrelated changes mean the current checkout is not appropriate isolation for new material or resumable work. Material or High-risk plan execution, concurrent or resumable work, and use of an editing subagent require isolation.

A linked worktree is reusable only for the same accepted task, expected branch and base, while unmerged. Isolation alone is insufficient. Unassigned host-managed workspaces are inherited.

1. Read repository instructions and establish the accepted task, intended base and fork point, repository root, worktree path, branch, HEAD, and status. Use the governing plan or canonical project record; do not invent parallel tracking.
2. Detect whether the checkout is a linked worktree or submodule. For a continuation, reuse it only when task and branch match, expected base identity is established and matches the recorded fork point or a reconciled base advance, and `HEAD` is not already contained in the intended base branch. Otherwise quarantine it.
3. If a pre-existing task branch's `HEAD` is already contained in the intended base branch, classify it as retired. A newly created empty branch for the current task remains active until work begins. Never start a new task in a retired worktree. Leave a clean owned candidate for `finishing-a-development-branch`; preserve unsafe candidates.
4. For a new material task or mismatch, create a dedicated branch and worktree without modifying the old checkout. Use harness-native worktrees only when they leave the original checkout unchanged; otherwise use `git worktree` outside the repository. Record task, path, branch, intended base, fork point, ownership, and active disposition in the governing record when durable state applies, or in current task context otherwise. Never add ignore files/rules to conceal them.
5. Follow directory preference, then repository convention; verify project-local directories are ignored.
6. Run only documented setup; avoid blind installs or lockfile mutation.
7. Run a cheap, relevant baseline check before implementation.

Revalidate after resume or compaction and before mutation, editing delegation, commit, or branch operations. Stop if path, branch, HEAD, ownership, or related work changed. Live state overrides stale summaries.

Dirty, untracked, inherited, detached, wrong-base, or ownership-ambiguous worktrees are quarantined when not attributable to the same active task: do not reuse or remove them. Resume same-task uncommitted work only with clear attribution. Do not edit `.gitignore` without authorization or silently work in place. Stop when overlap, permissions, conflicts, or baseline failures make attribution unsafe.

Report task identity, disposition, path, branch, base, setup, baseline, existing failures, and confirmation that user work remains untouched.
