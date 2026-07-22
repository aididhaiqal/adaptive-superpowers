---
name: using-superpowers
description: "Use when starting any conversation."
---

# Adaptive Gate

Classify before acting.

- **Read-only:** inspect and answer without implementation artifacts.
- **Precise low-risk implementation:** use this path only when acceptance is explicit, one local locus is clear, scope is at most two production files plus tests, no blocking choice remains, and no security, destructive, production-data, migration, public-contract, cross-system, or external-state risk exists. Use one bounded inspection batch. State plan and acceptance together. Implement minimally and leave the smallest relevant runnable automated test file for observable behavior; transient checks do not count. Run fresh targeted verification and inspect the final diff. Broaden only for repository policy, dependency impact, or named risk.
- **Otherwise:** before implementation or consequential action, read `references/full-router.md` and follow it.

If scope grows or a predicate fails, switch immediately. Preserve user work; require authority for destructive or external actions.
