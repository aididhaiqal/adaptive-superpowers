# Evaluation

Every run records the candidate commit, adapter, model identifier, CLI version, scenario, duration, test files, tool calls, skill loads, duplicated explanations, duplicated verification, and deterministic result.

Candidate runs precede baseline spending. A model or adapter smoke failure stops later cells for that target. Missing entitlement, authentication failure, rate limiting, or transcript-capture failure is indeterminate and is not counted as a behavioral failure.

The initial targets are GPT-5.6 Sol and Terra through Codex CLI, Claude Opus 4.8 through Claude Code, and Claude Fable 5 through Claude Code. Raw prompts and trajectories stay local; published summaries contain redacted evidence and aggregate metrics only.

Recorded evaluations:

- [2026-07-21 cross-model sentinel](evaluations/2026-07-21-cross-model-sentinel.md)
- [2026-07-22 optimized adaptive router](evaluations/2026-07-22-optimized-adaptive-router.md)
- [2026-07-22 Codex Terra explorer POC](evaluations/2026-07-22-codex-terra-explorer-poc.md)
