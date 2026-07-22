---
name: requesting-code-review
description: Review a completed material implementation after technical verification or before integration; identify missed work and bounded improvements, excluding incoming feedback.
---

# Requesting Code Review

Do not use this workflow merely to evaluate incoming reviewer feedback.

Implementation ends with a final review after technical verification and before a completion claim. Fast or mechanical work may use the implementer's bounded diff review; material work uses this independent workflow when available.

1. Define the exact change range from a recorded base, merge base, staged diff, or named files. Never assume `HEAD~1` covers the work.
2. Read the original request, acceptance, and named risks—not only the implementer's summary.
3. Inspect the actual range, affected callers, tests, contracts, and surrounding integration far enough to find anything missing, incorrect, incomplete, or poorly integrated.
4. Validate every finding and recommendation against code and requirements.

Keep the review read-only. Return three sections:

- **Blocking findings:** supported Critical and Important defects, omissions, or integration gaps, with file and line evidence, impact, and a concrete fix.
- **Material recommendations:** evidence-backed improvements with expected value and relevant cost or trade-off. Recommendations do not block completion or authorize more implementation. Do not invent recommendations merely to fill the section.
- **Verdict:** ready or not ready for completion or integration, with unresolved evidence limits.

Omit praise, generic advice, and speculative scope expansion.

Use a fresh host-native reviewer when available and proportional. If no independent reviewer is available, describe the result as self-review rather than claiming independence.

Use a bounded feature reviewer for a material feature change after focused verification. Give it the exact feature range, requirements, named risks, and targeted evidence. Use the strongest available final reviewer for a substantial branch or release after final verification. Give it the merge base, whole change range, requirements, named risks, and broad evidence; ask for cross-feature and integration failures rather than a repeat of task reviews. Security-sensitive, financial-ledger, migration, and public-contract changes warrant the strongest reviewer at the feature boundary too.

Do not automatically run both reviews. A whole-range review can satisfy the final feature review when it covers the same implementation, requirements, and evidence. Routine or tightly coupled work stays with the implementer, but still receives the final bounded review. Do not substitute review for verification.

Block integration on supported Critical and Important findings. Re-review only when a substantial correction changes the risk surface; otherwise run the affected verification directly.
