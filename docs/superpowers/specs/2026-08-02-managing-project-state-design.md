# Managing Project State Design

**Status:** Approved for implementation on 2026-08-02. Runtime behavior remains unchanged until the implementation and evaluation gates pass.

## Decision

Add one specialist skill, `managing-project-state`, inside Adaptive Superpowers. It owns durable work state and repository-instruction continuity. Do not publish or install a separate repository-instructions plugin.

The central invariant is:

> Compact history without weakening unresolved commitments.

## Problem

Long or resumed work needs enough durable state to survive compaction, handoff, and model changes. The current router already selects canonical progress records, but that policy is spread across routing, planning, execution, verification, and branch completion. Projects can consequently accumulate duplicate plans, progress files, task reports, and repeated test output—or compress them so aggressively that blockers, accepted exclusions, queued work, and future-watch obligations disappear.

Repository instructions have the complementary problem. `AGENTS.md` and host adapters must identify durable repository facts and canonical records, but they must not become progress journals or duplicate the live ledger.

## Ownership boundary

| Owner | Responsibility |
| --- | --- |
| `using-superpowers` | Select the existing workflow tier and invoke state management only when its trigger matches. Establish any persistent-goal contract once. |
| `brainstorming` | Produce accepted outcomes, explicit deferrals, open decisions, and acceptance. |
| `writing-plans` | Own a durable outcome contract when planning independently triggers. |
| `managing-project-state` | Select and reconcile the canonical current ledger, protect unresolved commitments, archive qualifying completed evidence, and maintain canonical repository-instruction pointers. |
| `executing-plans` | Execute accepted outcomes and pass material state transitions and evidence to the state owner. |
| Verification and review skills | Produce qualified evidence and blocking findings; never write parallel status reports. |
| `finishing-a-development-branch` | Produce delivery and cleanup evidence for final reconciliation. |

Live source, Git, CI, deployment, and runtime evidence remain authoritative. Plans express accepted intent. The current ledger summarizes present state. The optional evidence archive preserves only qualifying completed detail. None silently overrides another.

## Routing and fast-path boundary

Project-state routing maps onto the existing tiers; it does not create another tier taxonomy.

| Existing route | Project-state behavior |
| --- | --- |
| Read-only | Audit and report only when explicitly requested; create no artifacts. |
| Mechanical | Skip state management unless repository policy requires one direct record reconciliation. |
| Fast path | Keep the existing inline requirement to reconcile a repository-required canonical record from fresh evidence. Do not load `managing-project-state` merely because the repository has a ledger. |
| Standard | Invoke only when work is material, resumable, already tracked, or changes a protected obligation or canonical instruction pointer. |
| High-risk | Invoke before execution and after verification. Existing cross-system, production-data, migration, security, public-contract, destructive, and external-state predicates remain authoritative. |
| Persistent or open-ended goal | Invoke when the goal needs durable cross-turn state, whether or not a durable plan independently triggers. |

The fast path never creates `.superpowers/project-state.yaml`, a new ledger, an archive directory, or a new work item. It may update an existing repository-required row directly. If that update would add, remove, downgrade, defer, replace, or archive a protected obligation, reclassify to the full router and invoke `managing-project-state`.

Replace, rather than append to, the current persistent-goal gate prose with a concise bridge that establishes the goal contract and delegates durable storage when needed. The gate remains self-sufficient for routine work.

## State and evidence model

The compact current index may use these workflow states:

- `queued`: accepted but not started;
- `active`: currently authorized work;
- `blocked`: accepted work waiting on a named condition or authority;
- `future-watch`: an accepted obligation triggered by a future condition;
- `completed`: accepted outcomes whose required completion evidence is present and awaiting any qualifying archival.

Recommendations remain outside accepted work until authorized. `implemented`, `tested`, `committed`, `pushed`, `merged`, `deployed`, and `runtime-verified` are independent evidence fields, never synonyms for `completed`.

An agent may add evidence, strengthen verification, or move work forward within existing authority. Lowering priority, deferring, excluding, replacing, or removing queued, active, blocked, or future-watch work requires explicit authority and a recorded disposition. Completion does not authorize adjacent recommendations.

The managed profile treats these as forward transitions when their named evidence is recorded: `future-watch` to `queued` or `active` after its trigger; `queued` to `active`; `active` to `blocked` with a blocker; `blocked` to `active` with resolution evidence; and `active` or `blocked` to `completed` with required completion evidence. Moving a protected item through any other state transition, decreasing its priority, replacing or excluding it, or removing it requires a disposition and authority reference. Archiving an evidenced `completed` item under the admission policy preserves rather than changes its commitment state.

The gate owns asking for or inferring the persistent-goal contract: accepted outcomes, automatic-execution boundary, verification cadence, and stopping condition. `managing-project-state` stores that contract in the governing plan or canonical current record when durable state triggers. Without a durable plan, one current work item owns it. No second goal-contract artifact is created.

## Repository profiles and artifacts

Prefer the repository's existing canonical ledger and instruction convention. Two profiles keep adoption proportional.

### Convention profile

When root `AGENTS.md`, `AGENTS.override.md`, or `CLAUDE.md` unambiguously identifies a canonical record, use it without creating configuration. The model may also follow an established repository convention found elsewhere, but automatic auditor discovery is deliberately limited to those root instruction files; pass `--ledger` when auditing another established source. The model performs semantic reconciliation. The validator can check path resolution, duplicate candidate ledgers, instruction hygiene, and size, but must report protected-transition validation as unavailable.

### Managed profile

Repositories that want CI enforcement may add:

```yaml
version: 1
ledger: docs/progress.md
archive: docs/project-evidence
protected_states: [queued, active, blocked, future-watch]
current_completed_limit: 10
archive_entry_max_kib: 64
```

This `.superpowers/project-state.yaml` file configures paths and limits only; it never duplicates work items or workflow prose. The managed ledger keeps stable work-item IDs plus explicit `State`, `Priority`, `Disposition`, and `Authority` fields in its repository-selected structured Markdown table or supported structured-data format. The first implementation supports one documented Markdown-table schema; foreign formats fall back to the convention profile rather than being rewritten.

`protected_states` may add repository-specific states but must include `queued`, `active`, `blocked`, and `future-watch`. Narrowing that baseline is a managed-profile validation error, not a way to weaken transition protection.

`AGENTS.md` owns repository-specific facts, safety boundaries, commands, and the canonical ledger pointer. Nested `AGENTS.md` owns narrower facts. `CLAUDE.md` remains a thin host-specific adapter. Update these files only when durable repository truth or the pointer changes—not for routine progress, test counts, temporary commands, or completed history.

## Validation contract

`audit_project_state.py` accepts `--root`, optional `--ledger`, and optional `--base-ref`/`--head-ref` for transition checks. It emits concise text or JSON and never prints suspected secret values. `--ledger` overrides discovery for that run and the report names the source; managed-profile CI must omit the override or match the configured ledger, otherwise validation fails rather than checking a different record.

In both profiles it may validate:

- discovery and effective instruction pointers;
- missing, empty, placeholder, oversized, or exactly duplicated instruction rules;
- possible-secret and unsafe-directive patterns as clearly labelled heuristic warnings;
- configured path existence, duplicate current ledgers, and well-formed limits.

In the managed profile it may additionally validate:

- unique stable work-item IDs and allowed states;
- required evidence columns and distinct delivery fields;
- current completed-item and archive-entry size limits;
- archive identity linkage;
- across a supplied Git range, removal or downgrade of a protected item only when the new state or archive contains a disposition and authority reference.

Without a revision range, transition checks report `not_evaluated`; they never claim that a point-in-time scan proved authorization. CI can require a reference but cannot prove it is honest. The model still compares all claims with current source, Git, CI, deployment, runtime, and user decisions.

## Archival policy

Routine and ordinary Standard completion stays compact in the current ledger and Git history. Do not create an evidence file merely because work completed.

Detailed evidence qualifies for `docs/project-evidence/` only when at least one applies:

- repository, regulatory, security, incident, migration, or production-data policy requires retention;
- a High-risk or persistent workstream has decisions or evidence needed for future safe operation;
- an accepted external gate remains linked to otherwise completed work;
- the user explicitly requests a durable evidence package.

Archive entries contain stable ID, accepted outcome, consequential decisions, qualified evidence references, delivery state, and dispositions. Exclude raw model trajectories, repeated command output, per-edit narration, and information already canonical elsewhere. Create the archive directory only with its first qualifying entry. The configured per-entry limit is a review threshold, not permission to truncate obligations.

At completion, compact qualifying detail out of the current index while preserving stable identity and Git history. Keep unresolved blockers, external gates, accepted exclusions, pending outcomes, and material watch items visible with explicit dispositions. Archival never converts unresolved work into completion and never authorizes deletion, commit, push, or external action.

Routine sessions read the compact current index only. They must not enumerate or load `docs/project-evidence/`; a specific active item, audit, incident, or user request must identify an archive entry first.

## Runtime budget and inventory

This approved design changes the runtime inventory from 12 to 13 skills and raises only the bundle-wide anti-bloat ceiling in proportion to the new capability. Ceilings remain guards, not writing targets.

- Keep `MAX_SKILL_WORDS=450`.
- Raise `MAX_TOTAL_WORDS` from 4,000 to 4,400 for the 13-skill inventory.
- Target `managing-project-state/SKILL.md` at no more than 380 words, including frontmatter.
- Keep `using-superpowers/SKILL.md` at no more than 450 words by replacing and compressing existing persistent-goal/progress wording rather than appending a bridge.
- Conditional references do not count toward the runtime-body ceiling, but remain directly linked and are loaded only by their branch.
- Update `EXPECTED_SKILLS`, adapter inventory tests, README inventory, architecture, manifests when necessary, and the `AGENTS.md` approved-count rule to 13.

The current measured baseline is 3,563 runtime words with a 437-word gate. A 380-word skill plus a non-growing gate leaves 457 words of bundle headroom. Implementation should remain materially below 4,400 when concise wording is sufficient and must report final measured counts. Raising the per-skill or gate ceiling, or raising the total beyond 4,400, requires a new explicit decision.

## Contract migration matrix

Existing protections move with their tests; they are not deleted and re-created from memory.

| Current owner and contract | Destination | Test migration |
| --- | --- | --- |
| Gate persistent-goal fields and stopping boundary | Concise gate bridge; durable storage semantics in `managing-project-state` | Update `test-goal-execution-contract.sh` to require the bridge in the gate and storage contract in the new skill. |
| `full-router.md` persistent-goal planning paragraph | Keep inference, materially-different stopping-condition, and resume boundaries in the router; move its canonical-storage sentence to `managing-project-state` | Keep the router assertion for `materially different stopping conditions`; add a new-owner assertion for governing-plan/current-record storage. |
| `full-router.md` `## Durable progress`, canonical-record selection, default `docs/progress.md`, evidence fields, milestone reconciliation | New skill body plus `references/state-model.md` | Move the corresponding assertions in `test-completion-lifecycle.sh` to the new owner. |
| Consolidation preserves blockers, gates, exclusions, pending outcomes, and watch items | `references/state-model.md` | Move the exact obligation assertion in `test-goal-execution-contract.sh`. |
| Temporary execution state never overrides or duplicates the canonical record | `references/state-model.md` | Move both temporary-state assertions to the new owner. |
| Verification cadence and evidence invalidation | Remain in `full-router.md` | Keep existing router assertions. |
| `writing-plans` forbids parallel logs and ledgers | Remain in `writing-plans` | Keep the completion-lifecycle assertion. |
| Fast-path repository-required reconciliation | Remain inline in the gate | Keep the completion-lifecycle assertion against the gate. |
| Executing and finishing skills pass/reconcile canonical evidence | Keep concise handoff clauses in those skills | Retarget only assertions whose ownership genuinely moves. |

The current uncommitted persistent-goal refinements are the migration baseline. Implementation first records their full passing contract set, then changes one owner at a time while retaining green behavior.

## Implementation structure

```text
skills/managing-project-state/
├── SKILL.md
├── references/
│   ├── state-model.md
│   ├── repository-instructions.md
│   └── archival-and-validation.md
└── scripts/
    └── audit_project_state.py
```

The useful decision rules and structural auditor from the local sibling prototype `../adaptive-repository-instructions` are migration input only. The implementation must independently review and adapt them; the prototype is neither installed nor published and is not a runtime dependency.

Atlas is the first real integration target. The evaluation report must record the exact supplied Atlas repository root, branch, HEAD, dirty state, existing canonical ledger, and applicable `AGENTS.md` chain. It must not embed a developer-specific absolute path in this public specification or rewrite Atlas's established ledger merely to use the managed profile.

## Implementation and evaluation gates

1. Record the untreated 12-skill baseline: full contract results, 3,563-word total, 437-word gate, and the uncommitted persistent-goal diff.
2. Add failing static and scenario contracts for 13-skill inventory, routing, protected obligations, duplicate-ledger prevention, instruction updates, archive admission, context exclusion, and evidence-state separation.
3. Add the skill and migrate each contract according to the matrix.
4. Update inventory, architecture, README, progress, manifests/adapters, and validation within the approved 450-word per-skill and 4,400-word bundle ceilings.
5. Validate synthetic convention and managed-profile fixtures.
6. Validate Atlas in convention profile first. Managed-profile adoption is a separate explicit repository decision.
7. Forward-test in fresh Codex and Claude contexts:
   - routine fix leaves project-state artifacts unchanged;
   - fast-path repository-required reconciliation stays direct and does not load the archive;
   - normal material feature updates one concise item;
   - blocked work survives neighboring completion and compaction;
   - silent downgrade or removal is rejected;
   - qualifying completed detail archives with stable identity;
   - a fresh routine session never reads the evidence archive;
   - a durable command or canonical-pointer change updates the narrowest instruction layer;
   - routine implementation does not edit `AGENTS.md` or `CLAUDE.md`.

## Acceptance

- Adaptive Superpowers remains one project and one installation with 13 runtime skills.
- Routine work incurs no new ledger, configuration, archive, or instruction churn.
- The fast path preserves repository-required reconciliation without loading the specialist skill by default.
- Material or resumable work has one canonical current record and qualified delivery evidence.
- Historical detail is archived only when it meets explicit admission criteria and is excluded from routine context.
- No unresolved accepted obligation is silently completed, downgraded, deferred, replaced, or removed.
- Repository instructions remain concise, evidence-backed, scoped, and separate from work history.
- The current persistent-goal, authority, user-work, worktree, testing, review, and completion protections remain intact.
- All repository tests, bundle validation, adapter validation, synthetic fixtures, Atlas convention-profile checks, and paired Codex/Claude forward tests pass before release.
