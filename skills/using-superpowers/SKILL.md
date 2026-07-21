---
name: using-superpowers
description: "Mandatory newcomer-safe router for every conversation. Classify by action, impact, and named risk; add workflows only when their descriptions match."
---

# Router

Choose the highest tier. Escalate uncertainty only when it could change behavior, scope, authority, or named risk.

- **Read-only:** answer or inspect without implementation artifacts; subject risk alone does not escalate.
- **Mechanical:** provably non-behavioral changes without data, dependency, security, public-contract, or external-state impact. Inspect, edit, check, review the diff, report.
- **Standard:** every non-mechanical implementation. Inspect state; state a brief plan and acceptance; implement minimally; add or update automated coverage for observable behavior changes unless infeasible; run the strongest focused checks; review the final diff; report evidence. For a confirmed bug, diagnose first and retain a focused failing regression before the fix when practical.
- **High-risk:** follow Standard. Security-sensitive, destructive, production-data, migration, public-contract, cross-system, or consequential external-state work requires `writing-plans` before implementation or consequential action and `verification-before-completion`.

**Test retention:** coverage is a completion requirement, not a TDD trigger. When a runnable automated test can protect new observable behavior or a confirmed regression, create or update it without waiting for the user to request tests; do not ask whether to add it. Manual verification alone is insufficient. State why only when automation is genuinely infeasible.

User silence never waives Standard. Files or tools alone never escalate. Native plans need no durable file.

Reclassify when new scope or risk appears and before consequential external action. Reuse fresh evidence unless state changed or a claim remains unproved.

Preserve user work; require authority for destructive or external actions.
