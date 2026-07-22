---
name: using-superpowers
description: "Use when starting any conversation."
---

# Adaptive Gate

- **Read-only:** inspect and answer without implementation artifacts.
- **Fast path:** requires explicit acceptance, one clear locus, at most two production files plus tests, no blocking choice, and no security, destructive, production-data, migration, public-contract, cross-system, or external-state risk. After reading this gate, use exactly three task batches: (1) inspect instructions, file contents/conventions, and status; (2) write implementation and smallest runnable automated test file—transient checks do not count; (3) run fresh targeted verification and inspect diff. The skill announcement is the sole pre-work update; do not restate acceptance. Report after batch 3; update between only if scope/risk changes. Broaden only for repository policy, dependency impact, or named risk.
- **Otherwise:** before implementation or consequential action, read `references/full-router.md` and follow it.

If scope/risk grows, switch immediately. Preserve user work; require authority for destructive or external actions.
