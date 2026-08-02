---
name: managing-project-state
description: "Manage durable project state for material, resumable, persistent, or repository-tracked work: select and reconcile one canonical ledger, protect accepted obligations, archive qualifying evidence, and maintain repository-instruction pointers. Use for tracked state transitions, compaction recovery, protected commitments, canonical-record changes, or explicit state audits; skip routine isolated work."
---

# Managing Project State

> Compact history without weakening unresolved commitments.

For read-only requests, inspect and report without changing artifacts.

1. At the start of material or resumable work, identify the repository-designated canonical current record. If none exists, use or create one `docs/progress.md`. Do not create a parallel ledger.
2. Choose the **Convention profile** when repository instructions already identify an unambiguous record. Choose the **Managed profile** only when the repository opts into `.superpowers/project-state.yaml` and deterministic CI checks.
3. Store any durable goal contract in its governing plan or canonical current record. Record accepted outcomes, owner, current state, blockers, stopping condition, and only evidence that changes a claim.
4. Reconcile at meaningful transitions, coherent milestones and completion—not after every edit, tool call, or test. Resume the first unfinished accepted outcome after checking live state.
5. Keep implemented, tested, committed, pushed, merged, deployed, and runtime-verified distinct. Current source, Git, CI, deployment, and runtime evidence override summaries.
6. Preserve protected commitments. Read [state-model.md](references/state-model.md) before deferring, reprioritizing, replacing, removing, resuming, or compacting tracked work.
7. Read [repository-instructions.md](references/repository-instructions.md) only when durable repository truth or a canonical pointer may have changed.
8. Read [archival-and-validation.md](references/archival-and-validation.md) only when configuring validation, comparing transitions, or archiving qualifying evidence.

Skip routine isolated work unless repository policy requires a direct existing-record update. Never create configuration, a ledger, an archive, or a work item merely because this skill loaded. Recommendations remain outside accepted work until authorized.
