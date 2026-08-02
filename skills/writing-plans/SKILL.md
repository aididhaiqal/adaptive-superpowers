---
name: writing-plans
description: Create a durable plan when explicitly requested, required by the High-risk tier, or needed for resumable dependency coordination; skip routine native planning.
---

# Durable Plans

Use a repository file only for High-risk work, cross-session survival, or material dependency coordination; native plans do not require one.

1. Read the nearest `AGENTS.md`, requirements, relevant code, and repository documentation convention.
2. One governing plan covers the authorized objective, outcomes, resumed turns, review fixes, and integration. Create another only for a separately authorized objective with independent acceptance or lifecycle. Otherwise follow repository convention, updating the existing plan or creating `docs/plans/YYYY-MM-DD-HHMMSS-01-plan-<slug>.md` with stable identity.
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

An outcome is an independently testable deliverable worth an independent review boundary. Fold setup, configuration, scaffolding, and documentation into it; split only when one outcome could be accepted while another is rejected. Keep outcomes ordered; omit code, routine mechanics, predicted output, and artificial microsteps. Update only for material requirement, scope, design, or verification changes.

Reconcile the plan with the original request and approved scope closure. Do not introduce an unapproved deferral, exclusion, or substitute outcome merely because it is easier to implement.

Do not duplicate supplied incidents or specifications, or create companion logs and ledgers for routine work. Use one canonical project record rather than per-plan logs. Planning or implementation authority does not authorize commits or shared-checkout branch switching.

Create it before implementation. For destructive or consequential actions include target, authority, recovery, stop conditions, and prechecks. For production data include target, approvals, dry-run counts, backup/restore evidence, integrity checks, batch/abort thresholds, and sensitive-output hygiene. For deployment include target revision, approvals, rollout health, rollback, and monitoring stop conditions.

If the current mode forbids writes, name the intended path and create it only after writes are authorized. A durable plan does not automatically require a log, review, worktree, or separate completion gate; select each independently.
