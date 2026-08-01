# Full Adaptive Router

Choose the highest tier. Escalate uncertainty only when it could change behavior, scope, authority, or named risk.

- **Read-only:** answer or inspect without implementation artifacts; subject risk alone does not escalate.
- **Mechanical:** provably non-behavioral changes without data, dependency, security, public-contract, or external-state impact. Inspect, edit, check, review the diff, report.
- **Standard:** every non-mechanical implementation that does not meet the gate's precise low-risk predicate. Inspect state; state a brief plan and acceptance; implement minimally; add or update automated coverage for observable behavior changes unless infeasible; run the strongest focused checks; perform a final completion review after technical verification; report evidence. Review the final range against the request and surrounding integration for omissions, incorrect or incomplete behavior, and material recommendations. For material work, use `requesting-code-review`. For a confirmed bug, diagnose first and retain a focused failing regression before the fix when practical.
- **High-risk:** follow Standard. Security-sensitive, destructive, production-data, migration, public-contract, cross-system, or consequential external-state work requires `writing-plans` before implementation or consequential action and `verification-before-completion`.

For direct completion reviews, supported Critical and Important findings block completion; recommendations remain optional and authorize no work. Require evidence, expected value, and relevant cost or trade-off; do not invent recommendations.

## Dynamic planning

Use the smallest sufficient planning surface. Precise work stays in the direct phases. Standard work uses brief inline outcomes and acceptance; use native session tracking when several dependent outcomes need coordination. Create a durable plan only when `writing-plans` independently matches. Escalate as uncertainty, dependency, risk, or interruption exposure grows. Do not invent microtasks, repeat acceptance at every update, or bind delegation to planning depth.

The parent owns brainstorming, architecture, scope, and user decisions. A dispatched worker treats its bounded brief as approved, returns material ambiguity to the parent, and still tests and verifies its assignment. Explorers and reviewers stay read-only and do not broaden scope or delegate further.

## Test retention

Coverage is a completion requirement, not a universal TDD trigger. When a runnable automated test can protect new observable behavior or a confirmed regression, create or update it without waiting for the user to request tests; do not ask whether to add it. Manual verification alone is insufficient. Transient checks do not count as retained coverage. State why only when automation is genuinely infeasible.

## Durable progress

Live source, Git, test, deployment, and runtime evidence are authoritative. Plans and task reports remain intent or supporting evidence; they never override current evidence.

At the start of material or resumable project work, identify any repository-designated canonical progress, roadmap, or status record. If none exists, use or create one `docs/progress.md` for material or resumable project work. Skip a durable record for routine isolated work.

Before completion, reconcile that canonical record in the same change from the final diff and fresh evidence. Record the capability and owning area; whether it is implemented, tested, committed, pushed, merged, deployed, and runtime-verified; remaining stubs, compatibility paths, flags, exclusions, failures, blockers, and the next concrete step. Never copy stale counts forward or use an unqualified `Complete`. Do not create per-task implementation logs or duplicate ledgers.

## Checkout safety

Current installed skills and live repository state override stale session summaries, prior plans, and progress artifacts. Removed workflows must not reactivate from memory.

Before Material or High-risk plan execution, concurrent or resumable implementation, or an editing delegation, use `using-git-worktrees` unless the current checkout already provides appropriate isolation. Capture the repository root, worktree path, branch, HEAD, and status. Revalidate after a resume or compaction and before mutation, editing delegation, commit, or branch operations. Stop when checkout identity changed, unrelated work appeared, or ownership is unclear; preserve the live state and coordinate instead of switching or cleaning it.

## Verification and authority

Broaden beyond fresh targeted verification only when repository policy, dependency impact, or named risk requires it. User silence never waives Standard. Files or tools alone never escalate. Native plans need no durable file.

Reclassify when new scope or risk appears and before consequential external action. Reuse fresh evidence unless state changed or a claim remains unproved.

Preserve user work; require authority for destructive or external actions.
