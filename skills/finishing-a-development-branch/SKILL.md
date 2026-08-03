---
name: finishing-a-development-branch
description: Complete authorized commit, push, local merge, PR, or disposition; after verified local merge, retire the owned worktree and fully merged feature branch by default.
---

# Finishing a Development Branch

Record repository root, worktree path, status, branch, and HEAD read-only. Revalidate immediately before commit, push, integration, branch, or cleanup. Stop on identity drift or unrelated work and preserve user changes.

Confirm the task diff, fresh required checks, that applicable project state is reconciled, and that any required completion review has no unresolved blocking findings. Optional recommendations do not block delivery. Require no separate artifact unless policy does.

- If the user or repository policy already authorizes commit or push, perform it after verification.
- When delivery authority is unresolved, ask one concise question that distinguishes local merge, push/PR, and explicit retention. A successful authorized local merge retires the exact clean task-owned worktree by default. Preserve it only when the user explicitly asks to retain it; local merge never authorizes sweeping other worktrees.
- Do not switch branches, pull, merge into a base branch, create a PR, or force-push without corresponding authority.
- In a detached or externally managed workspace, report the exact limitation and preserve the work for the host workflow.
- Push/PR and explicit-retention outcomes preserve the worktree and branch for follow-up.

Verify the merged result before worktree or branch removal. If verification fails, preserve both the worktree and feature branch for investigation.

Before retiring a locally merged worktree, revalidate from outside it that the exact path, branch, HEAD, intended base, and ownership match; the tree is clean, including untracked files; `HEAD` is contained in the intended base; no required work or protected project-state obligation remains; and the target is neither primary nor externally managed. Establish ownership from the accepted task or canonical record and path convention. Preserve and report dirty, inherited, detached, wrong-base, or ambiguous worktrees.

After those gates pass, remove only the exact task worktree and prune stale registrations:

```bash
git worktree remove <exact-task-worktree-path>
git worktree prune
```

After verified local merge and worktree removal, delete only that fully merged feature branch with `git branch -d <feature-branch>`. Preserve the branch if deletion is not proven safe or the user explicitly requested retention. Never force-delete through this path.

If commit or push fails, preserve the verified state and report the original error. Do not pull, rebase, merge, or force without separate authority.

Never offer discard routinely. If requested, show the exact branch, unique commits, uncommitted files, and worktree path at risk; require confirmation containing `discard` for that target.

After delivery, reconcile the task's recorded worktree disposition, then report checks, commit or branch state, remote action, disposition, and anything preserved. Follow applicable repository command wrappers.
