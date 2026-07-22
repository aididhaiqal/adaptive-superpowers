# Full Adaptive Router

Choose the highest tier. Escalate uncertainty only when it could change behavior, scope, authority, or named risk.

- **Read-only:** answer or inspect without implementation artifacts; subject risk alone does not escalate.
- **Mechanical:** provably non-behavioral changes without data, dependency, security, public-contract, or external-state impact. Inspect, edit, check, review the diff, report.
- **Standard:** every non-mechanical implementation that does not meet the gate's precise low-risk predicate. Inspect state; state a brief plan and acceptance; implement minimally; add or update automated coverage for observable behavior changes unless infeasible; run the strongest focused checks; perform a final completion review after technical verification; report evidence. Review the final range against the request and surrounding integration for omissions, incorrect or incomplete behavior, and material recommendations. For material work, use `requesting-code-review`. For a confirmed bug, diagnose first and retain a focused failing regression before the fix when practical.
- **High-risk:** follow Standard. Security-sensitive, destructive, production-data, migration, public-contract, cross-system, or consequential external-state work requires `writing-plans` before implementation or consequential action and `verification-before-completion`.

For direct completion reviews, supported Critical and Important findings block completion; recommendations remain optional and authorize no work. Require evidence, expected value, and relevant cost or trade-off; do not invent recommendations.

## Test retention

Coverage is a completion requirement, not a universal TDD trigger. When a runnable automated test can protect new observable behavior or a confirmed regression, create or update it without waiting for the user to request tests; do not ask whether to add it. Manual verification alone is insufficient. Transient checks do not count as retained coverage. State why only when automation is genuinely infeasible.

## Verification and authority

Broaden beyond fresh targeted verification only when repository policy, dependency impact, or named risk requires it. User silence never waives Standard. Files or tools alone never escalate. Native plans need no durable file.

Reclassify when new scope or risk appears and before consequential external action. Reuse fresh evidence unless state changed or a claim remains unproved.

Preserve user work; require authority for destructive or external actions.
