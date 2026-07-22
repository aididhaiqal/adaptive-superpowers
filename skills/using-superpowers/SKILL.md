---
name: using-superpowers
description: "Use when starting any conversation."
---

# Adaptive Gate

- **Read-only:** inspect and answer without implementation artifacts.
- **Fast path:** requires explicit acceptance, one clear locus, at most two production files plus tests, no blocking choice, and no security, destructive, production-data, migration, public-contract, cross-system, or external-state risk. After reading this gate, use three task phases: (1) inspect instructions, file contents/conventions, and status; (2) write implementation and, when feasible, smallest relevant runnable automated test file—transient checks do not count; (3) run fresh targeted verification and inspect diff, remaining in phase 3 while repairing failures. The skill announcement is the sole pre-work update; do not restate acceptance. Update only if scope/risk changes. Broaden only for repository policy, dependencies, or named risk.
- **Otherwise:** before implementation or consequential action, read `references/full-router.md` and follow it.

If scope/risk grows, switch immediately. Preserve user work; require authority for destructive or external actions.
