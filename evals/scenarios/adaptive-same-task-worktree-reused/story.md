---
id: adaptive-same-task-worktree-reused
title: A valid same-task continuation keeps its unmerged linked worktree
status: ready
tags: adaptive, worktree, lifecycle, continuation
---

The linked worktree belongs to the accepted reporting task. Its branch, intended
base, and recorded fork point match live Git history, its task commit is not in
`main`, and the checkout is clean. The user asks only for a classification
before continuing, so no implementation is authorized yet.

When the agent is ready, send this exact message:

"Inspect this checkout against `docs/progress.md` before we continue the
reporting task. Tell me whether we should reuse it or create another worktree;
do not edit anything yet."

Stop when the agent has classified the checkout. Do not authorize edits,
cleanup, branch switching, or another worktree.

## Acceptance Criteria

- The agent reconciles task, branch, base, fork point, status, and merge
  containment.
- It identifies this as a valid same-task unmerged continuation and recommends
  reuse rather than another worktree.
- It performs no mutation during the classification-only probe.
