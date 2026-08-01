---
name: writing-plans
description: Create a durable plan when explicitly requested, required by the High-risk tier, or needed for resumable dependency coordination; skip routine native planning.
---

# Durable Plans

Use a repository file only when the High-risk tier requires it or for cross-session survival and material dependency coordination. A native plan alone does not require this file.

1. Read the nearest `AGENTS.md`, requirements, relevant code, and repository documentation convention.
2. Follow the repository's durable-plan convention. When none exists, reuse a same-scope record or create `docs/plans/YYYY-MM-DD-HHMMSS-01-plan-<slug>.md`; keep that timestamp and slug stable.
3. Resolve material ambiguity, then record the smallest set of independently verifiable outcomes.

```markdown
# <Task title>

**Goal:** <one sentence>
**Why planning is required:** <material trigger>
**Acceptance:** <observable completion criteria>

### Outcome N: <result>
- Work: <requirements, named files/resources, state/data flow, and failure behavior>
- Risks/open questions: <material privacy, security, or blocking unknowns; omit when none>
- Verify: `<repo-specific command>`
```

Keep outcomes dependency-ordered and omit code, routine mechanics, predicted output, and artificial microsteps. Update the same plan only after a material requirement, scope, design, or verification-strategy change.

Reconcile the plan with the original request and approved scope closure. Do not introduce an unapproved deferral, exclusion, or substitute outcome merely because it is easier to implement.

Do not duplicate supplied incidents or specifications in the plan, and do not create companion incident, specification, implementation-log, or progress-ledger artifacts for routine work. When durable progress is repository-required or selected by the router for material or resumable work, use one canonical project record rather than per-plan logs. Approval to plan or implement does not authorize commits or shared-checkout branch switching.

Create it before implementation. For destructive or consequential external-state work, put recovery, stop conditions, and pre-execution checks in acceptance. For production-data work, include target, approvals, dry-run counts, backup/restore evidence, integrity checks, batch/abort thresholds, and sensitive-output hygiene. For production deployment, include target revision, approvals, rollout, health evidence, rollback, and monitoring stop conditions.

If the current mode forbids writes, name the intended path and create it only after writes are authorized. A durable plan does not automatically require a log, review, worktree, or separate completion gate; select each independently.
