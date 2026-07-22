---
name: using-superpowers
description: "Use when starting any conversation."
---

# Adaptive Gate

- **Read-only:** inspect and answer without implementation artifacts.
- **Fast path:** only with explicit acceptance, one clear locus, at most two production files plus tests, no blocking choice, and no security, destructive, production-data, migration, public-contract, cross-system, or external-state risk. After reading this gate, use exactly three task batches: (1) inspect instructions, file contents/conventions, and status together; (2) write implementation and smallest runnable automated test file together—transient checks do not count; (3) run fresh targeted verification and inspect diff together. Send plan/acceptance before batch 1 and final evidence after batch 3; update between only if scope/risk changes. Broaden only for repository policy, dependency impact, or named risk.
- **Otherwise:** before implementation or consequential action, read `references/full-router.md` and follow it.

If scope grows or a predicate fails, switch immediately. Preserve user work; require authority for destructive or external actions.
