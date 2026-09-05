# Full Adaptive Router

Choose the highest tier. Escalate uncertainty only when it could change behavior, scope, authority, or named risk.

- **Read-only:** answer or inspect without implementation artifacts; subject risk alone does not escalate.
- **Mechanical:** provably non-behavioral changes without data, dependency, security, public-contract, or external-state impact. Inspect, edit, check, review the diff, report.
- **Standard:** every non-mechanical implementation that does not meet the gate's precise low-risk predicate. Inspect state; state a brief plan and acceptance; implement minimally; retain sufficient automated coverage for observable behavior changes unless infeasible; run the strongest focused checks; perform a final completion review after technical verification; report evidence. Review the final range against the request and surrounding integration for omissions, incorrect or incomplete behavior, and material recommendations. For material work, use `requesting-code-review`. For a confirmed bug, diagnose first and retain a focused failing regression before the fix when practical.
- **High-risk:** follow Standard. Security-sensitive, destructive, production-data, migration, public-contract, cross-system, or consequential external-state work requires `writing-plans` before implementation or consequential action and `verification-before-completion`.

For direct completion reviews, supported Critical and Important findings block completion; recommendations remain optional and authorize no work. Require evidence, expected value, and relevant cost or trade-off; do not invent recommendations.

## Dynamic planning

Use the smallest sufficient planning surface. Precise work stays in the direct phases. Standard work uses brief inline outcomes and acceptance; use native session tracking when several dependent outcomes need coordination. Create a durable plan only when `writing-plans` independently matches. Escalate as uncertainty, dependency, risk, or interruption exposure grows. Do not invent microtasks, repeat acceptance at every update, or bind delegation to planning depth.

For a persistent or open-ended goal, establish the accepted outcomes, automatic-execution boundary, verification cadence, and stopping condition once. Infer the stopping condition from the accepted request, governing plan, or canonical record when clear; do not ask merely to restate it. Ask one focused question only when materially different stopping conditions would change scope. Use `managing-project-state` when durable cross-turn storage is needed. On continuation or compaction, resume the first unfinished accepted outcome; completed work and optional recommendations do not create another outcome.

Choose routine implementation details within accepted requirements without another approval cycle. Resolve mechanics against current repository evidence and the governing requirements; ask when a conflict changes accepted behavior, scope, authority, or a consequential user decision. Skill-required gates are defaults, not new authority and not a reason to disregard explicit user instructions.

## Delegation

Use [delegation.md](delegation.md) when dispatching work. The parent owns integration and user decisions; workers own implementation choices within their bounded assignments. Explorers and reviewers remain read-only. Independent work may run in parallel when ownership and interfaces avoid collisions; delegation is not a mandatory phase or tied to planning depth.

## Repository fit

Before adding boundary-handling code, identify whether the repository has an applicable canonical path for parsing, validation, mapping, configuration, commands, or events. Extend it instead of creating a parallel low-level implementation. Deviate only for a demonstrated constraint, keeping the exception explicit and local.

## Test retention

Coverage is a completion requirement, not a universal TDD trigger. Run relevant retained tests; existing sufficient coverage satisfies it unchanged. Add or update tests for missing or incorrect behavioral coverage without waiting for the user; do not ask whether to add it. Manual verification alone is insufficient when automation is feasible. Transient checks do not count as retained coverage. State why only when automation is genuinely infeasible. For nontrivial test design or questionable coverage, read [testing-anti-patterns.md](../../test-driven-development/testing-anti-patterns.md) without activating strict TDD.

## Checkout safety

Current installed skills and live repository state override stale session summaries, prior plans, and progress artifacts. Removed workflows must not reactivate from memory.

Before Material or High-risk plan execution, concurrent implementation, or an editing delegation, use `using-git-worktrees` unless the current checkout already provides appropriate same-task isolation. A resume alone does not require new isolation for routine work. A linked checkout is not reusable merely because it is isolated: validate the accepted task, branch, intended base, and unmerged state, and create a dedicated worktree for a new material task. Capture the repository root, worktree path, branch, HEAD, and status. Revalidate after a resume or compaction and before an editing batch, editing delegation, commit, or branch operations; recheck sooner on evidence of external changes. Expected same-task edits do not require repeated identity checks before every patch. Stop when identity or ownership unexpectedly changes or unrelated work appears; preserve the live state and coordinate instead of switching or cleaning it.

## Verification and authority

During implementation, use the narrowest check whose result can change the next edit. Run broader affected or full suites only at a coherent milestone or final gate, or after a change whose dependency surface requires them—not as routine per-outcome confirmation. Before rerunning a command, identify the relevant source, test, dependency, configuration, or environment change that invalidated its evidence; otherwise reuse the result. Do not rerun a known environment-blocked lane until relevant state changes. Prefer concise output for successful checks and verbose output for a specific failure.

Broaden beyond fresh targeted verification only when repository policy, dependency impact, or named risk requires it. User silence never waives Standard. Files or tools alone never escalate. Native plans need no durable file.

Reclassify when new scope or risk appears and before consequential external action. Reuse fresh evidence unless state changed or a claim remains unproved.

Preserve user work; require authority for destructive or external actions.
