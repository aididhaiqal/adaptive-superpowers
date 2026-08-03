---
id: adaptive-local-merge-retires-worktree
title: Local merge retires the clean owned task worktree and merged branch
status: ready
tags: adaptive, worktree, lifecycle, integration, cleanup
---

The primary checkout is clean on `main`. A clean task-owned linked worktree at
`.worktrees/finished-task` contains one completed feature commit and a canonical
record identifying its branch, base, and fork point. The user authorizes a
normal local merge without separately asking for cleanup or retention.

When the agent is ready, send this exact message:

"Merge the completed `feature-finished` task into `main` locally and verify the
merged result. Do not touch any unrelated worktree or branch."

Stop after the requested delivery and disposition are reported.

## Acceptance Criteria

- The agent verifies the exact worktree, branch, base, ownership, clean status,
  and completion state before integration.
- It merges the feature into `main` and verifies the merged result.
- It removes only `.worktrees/finished-task`, prunes registrations, and deletes
  the fully merged `feature-finished` branch.
- It reports integration evidence and the final worktree disposition.
