---
name: requesting-code-review
description: Review a completed material implementation after technical verification or before integration; identify missed work and bounded improvements, excluding incoming feedback.
---

# Requesting Code Review

Do not use this workflow merely to evaluate incoming reviewer feedback.

Review at a coherent feature boundary after technical verification or before integration, not after every outcome. Fast or mechanical work may use bounded self-review; material work uses this independent workflow when available.

1. Define the exact change range from a recorded base, merge base, staged diff, or named files. Never assume `HEAD~1` covers the work.
2. Read the original request, acceptance, and named risks—not only the implementer's summary.
3. Inspect the actual range, affected callers, tests, contracts, applicable repository abstractions, and surrounding integration far enough to find anything missing, incorrect, incomplete, or poorly integrated, including duplication.
4. Validate every finding and recommendation against code and requirements.

Keep the review read-only. Reuse fresh implementer evidence, but verify any claim its evidence does not support. Do not ask a reviewer to rerun tests against the same code. Return three sections:

- **Blocking findings:** supported Critical and Important defects, omissions, or integration gaps, with file and line evidence, impact, and a concrete fix.
- **Material recommendations:** evidence-backed improvements with expected value and relevant cost or trade-off. Recommendations do not block completion or authorize more implementation. Do not invent recommendations merely to fill the section.
- **Verdict:** ready or not ready for completion or integration, with unresolved evidence limits.

Omit praise, generic advice, and speculative scope expansion.

Use a fresh proportional host-native reviewer when available. If no independent reviewer is available, call the result self-review. Use a bounded feature reviewer for a material feature change after focused verification. Use the strongest available final reviewer for a substantial branch or release after final verification; security, financial-ledger, migration, and public-contract work warrants it at the feature boundary too. Give exact range, requirements, risks, and evidence.

Do not automatically run both reviews. A whole-range review can satisfy feature review when it covers the same work and evidence. Do not substitute review for verification.

Block integration on supported Critical and Important findings. Flag bypass or duplication of an applicable repository abstraction without demonstrated constraint. Re-review only after substantial correction; otherwise run affected verification. Group final findings into one grouped fix wave and one scoped re-review.
