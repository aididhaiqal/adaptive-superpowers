---
name: writing-skills
description: Create, edit, or audit this adaptive Superpowers bundle; use the host's general skill-authoring guidance for unrelated skills.
---

# Maintaining Superpowers Skills

1. Read the nearest `AGENTS.md`, inspect the working tree, and audit each directly affected skill. For bundle-wide policy, compare every direct skill's description and body; load support resources only when activation or an intended edit depends on them.
2. Front-load one discriminative trigger per invocation branch in each description. Keep only non-obvious procedure in the body; make branch-only resources conditional and directly linked.
3. Remove duplication, stale prose, model-relative no-ops, and lifecycle rules owned elsewhere. Preserve authorization, user-work, security, and evidence guardrails.
4. Consult the current host's skill-authoring guidance when creating structure, changing metadata format, or resolving a validation question; routine wording revisions do not need its full guide reloaded.
5. Run `bash scripts/validate.sh`, the affected repository tests, and `git diff --check`.

Forward-test when inspection and validators cannot establish activation or behavior. Record the untreated baseline first, use the smallest discriminating scenario, do not leak the expected answer, and keep raw transcripts local. Report measured size, behavior changes, checks, and untested risk.

Structural lint is not behavioral proof. Keep inventory, schema, link, and intentional wording checks, but evaluate routing and execution claims through fresh consuming-agent scenarios. An unchanged cross-model result does not transfer automatically to revised policy.
