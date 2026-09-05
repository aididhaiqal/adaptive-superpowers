---
name: executing-plans
description: Execute an existing plan when implementation is authorized and dependent outcomes need tracking; skip short routine checklists.
---

# Executing Plans

A plan does not authorize implementation. Without that authority, inspect and report only.

1. Read the plan, its linked requirements, nearest `AGENTS.md`, and relevant repository state. When `managing-project-state` applies, use its canonical current record. For Material or High-risk execution, concurrent implementation, or editing delegation, use `using-git-worktrees` unless already appropriately isolated. Existing isolation is valid only for the same accepted task on its expected unmerged branch; a new material task receives a dedicated worktree. Capture repository root, worktree path, branch, intended base, HEAD, and status.
2. Reconcile the plan, canonical record, Git, and live checkout after resume or compaction, then continue at the first unfinished accepted outcome. Do not repeat completed outcomes whose relevant state and evidence remain intact. Announce the first outcome without repeating prior updates. Revalidate the live checkout identity before an editing batch, delegation, commit, or branch operations, and on external-change signals; stop on unexpected drift or unrelated work.
3. Implement the minimum change per outcome; batch checks when they prove the same behavior.
4. After the final change, run required technical checks.
5. Reconcile applicable project state from the final diff and fresh evidence. Compare the complete result with the plan and surrounding integration; perform the final completion review after technical verification, resolve blocking findings, and preserve optional recommendations for the user.
6. After the completion gate passes, use `finishing-a-development-branch` only when delivery is requested or already authorized. Distinguish local merge from PR or explicit retention; verified local merge retires the owned task worktree and fully merged feature branch by default.

Treat the plan as an outcome contract, not a transcript. Adapt mechanics when repository reality differs while preserving scope and acceptance. Update a durable plan before continuing only when a material requirement, design, or verification strategy changes.

Do not narrow conversation-level acceptance to match an easier implementation. Stop and obtain explicit approval before deferring or substituting a core outcome; update the governing plan only after that decision.

Stop when accepted outcomes are complete. Adjacent discoveries and optional recommendations require separate authority before becoming implementation work.

Later relevant mutations invalidate only affected evidence; rerun those checks before claiming completion.

Resolve recoverable failures with safe diagnostics and alternatives. Ask the user only when missing authority, an architectural choice, or ambiguous requirements would change the result.

A plan alone does not authorize commit, push, merge, PR creation, shared-checkout branch switching, or cleanup.
