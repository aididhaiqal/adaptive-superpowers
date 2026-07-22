---
name: finishing-a-development-branch
description: Complete an authorized commit, push, integration, PR, branch, or worktree action while preserving user state. Use after relevant verification when the user or repository requires delivery.
---

# Finishing a Development Branch

Inspect and record repository root, worktree path, status, branch, and HEAD with read-only commands. Revalidate that identity immediately before commit, push, integration, branch, or cleanup operations. If it changed or unrelated work appeared, stop and preserve the live state. Preserve unrelated user changes.

Confirm the task diff is understood, relevant required checks are fresh for the state to deliver, and any required completion review has no unresolved blocking findings. Preserve optional recommendations for the user; they do not prevent authorized delivery. Do not require a separate plan, log, or reconciliation artifact unless the user or repository does.

- If the user or repository policy already authorizes commit or push, perform it after verification.
- Ask one concise question only when merge, PR, push, retention, or cleanup authority remains unresolved.
- Do not switch branches, pull, merge into a base branch, create a PR, or force-push without corresponding authority.
- In a detached or externally managed workspace, report the exact limitation and preserve the work for the host workflow.
- Remove a worktree only when this session created it, the user authorized cleanup, and no required work remains inside it.

If commit or push fails, preserve the verified state and report the original error. Do not pull, rebase, merge, or force without separate authority.

Never offer discard routinely. If requested, show the exact branch, unique commits, uncommitted files, and worktree path at risk; require confirmation containing `discard` for that target.

After delivery, report the checks run, commit or branch state, remote action, and anything deliberately preserved. Follow repository-provided command wrappers when they exist and apply to the operation.
