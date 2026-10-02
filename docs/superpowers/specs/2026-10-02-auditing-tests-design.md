# Auditing Tests Design

**Status:** Approved for implementation on 2026-10-02. The bundle owner approved raising the runtime inventory from 13 to 14 skills for this capability.

## Decision

Add one specialist skill, `auditing-tests`, and make it the single owner of the test value bar: the authoring gate, the junk patterns, and the retention bar. Every other path that writes or judges a test applies that bar by reference instead of restating it.

The central invariant is:

> Optimize for confidence, not test count or deletion count.

## Problem

The bundle already requires retained automated coverage for observable behavior, but it says nothing about which tests earn their maintenance cost. Models asked to "keep the proof" add near-duplicate tests at every layer a bug crosses, assert that a stub returns its configured value, export production internals only for tests, and keep fixtures that hand the subject the very admission or callback the production owner should produce. The last pattern is the most expensive: the test passes while the real path is dead.

The opposite failure appears in audits. A naive sweep deletes source-inspection and pinning tests because they resemble implementation, although they are often the cheapest independent guard for a load-bearing reference, ordering, registration, or user-facing key.

The source of the method is the OpenClaw `test-audit` skill. Its value bar is host-neutral; its validation, landing, and campaign mechanics name OpenClaw tooling (Vitest wrappers, remote runners, PR scripts) and are not adopted.

## Ownership boundary

| Owner | Responsibility |
| --- | --- |
| `auditing-tests` | Own the value bar in `references/test-value.md`; run read-only discovery and evidence-backed pruning of existing tests when asked. |
| `using-superpowers` gate | Fast-path tests protect observable behavior without duplicating existing coverage. |
| Full router | Every retained test passes the authoring gate; test-suite audits route to `auditing-tests`. |
| `test-driven-development` | Applies the authoring gate before a red test; keeps mock and double guidance in `testing-anti-patterns.md`. |
| `systematic-debugging` | Places the one regression at the owner boundary. |
| `requesting-code-review` | Judges added or changed tests against the value bar. |
| `receiving-code-review` | Rejects requested tests that fail the authoring gate. |
| Repository instructions | Name repository-specific pinning tests, test commands, and known pre-existing failures. The bundle stays repository-neutral. |

## Trigger

The description front-loads one discriminative branch, auditing, pruning, or deduplicating existing tests, plus one judgment branch for a specific doubtful test or test-only seam. Routine test writing does not load the skill: the gate and router carry the authoring gate inline and link the reference only for doubtful cases. This keeps every implementation session from loading audit procedure.

## Authorization

Loading the skill authorizes no edits. Discovery and candidate evidence are read-only and reported before any deletion. Commits, pushes, and landing follow `finishing-a-development-branch`; deferred batches and uncertain candidates go to the canonical project record when `managing-project-state` applies.

## Budget

The skill body stays under the per-skill ceiling, and the bundle stays under the existing 4,400-word runtime total; the reference is outside the counted surface. No ceiling is raised.

## Evaluation

`adaptive-audit-keeps-contract-test` seeds one low-value test (asserting a stub's configured value), one test-only production export, and one source-inspection contract test that looks like implementation coupling but guards a public configuration key. A passing run removes the first two and keeps the contract test, with the suite green. Live cross-model runs are owed; the repository contract validates the fixture locally.
