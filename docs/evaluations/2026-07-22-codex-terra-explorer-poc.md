# Codex Terra explorer POC — 2026-07-22

## Decision

Retain a small host-neutral delegation boundary: use one read-only explorer for bulky independent investigation when its concise return prevents substantial parent-context noise. Do not restore mandatory subagent-driven development, parallel write-heavy work, or fixed agent counts.

Codex used GPT-5.6 Terra at high reasoning effort for two read-only traces in the approximately 5,700-file Atlas/Broker checkout. The parent used GPT-5.6 Sol and preserved the dirty worktree.

## Runs

| Scenario | Parent-measured duration | Result |
| --- | ---: | --- |
| Money Pocket / wallet and payment flow | 234 seconds | Traced the client, BFF, Payments, Ledger, events, persistence, and tests; surfaced a statically verifiable missing-binding contradiction. The initial prompt allowed an inaccurate self-estimated duration and an over-specific runtime interpretation. |
| Client onboarding and KYC flow | 134 seconds | Returned a bounded static trace across Gateway, Identity, ClientBFF, Onboarding, File Sandbox, AdminBFF, ClientAccount, and tests. It labelled all evidence as static, made no unexecuted runtime claim, and limited adjacent scope to one material caveat. |

The parent spot-checked the main contract claims and cited test names against the checkout. Neither run edited files or executed the Atlas test suite. Raw trajectories remain local.

## Tailoring retained

- Give one precise question and repository root.
- Keep the explorer read-only and prevent further delegation.
- Prefer targeted searches and stop when the question is answered.
- Request concise file-and-symbol evidence and explicit uncertainty.
- Separate inspected code from executed runtime evidence.
- Let the parent measure duration; child estimates are not trustworthy.
- Permit at most one adjacent issue when it materially affects the requested work.

## Limits

This POC establishes usefulness and prompt discipline, not a speedup against a no-agent baseline. Total cross-agent token usage was not captured. Claude Opus and Fable were not rerun for this scenario, so the shared rule leaves host and model selection native. No model-specific profile ships from this evidence alone.
