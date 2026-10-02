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
| `using-superpowers` gate | Fast-path tests protect observable behavior, fail without the change, and need no test-only seam or duplicate coverage. |
| Full router | Work that adds or changes tests reads the reference and checks each new test before the completion review; test-suite audits route to `auditing-tests`. |
| `test-driven-development` | Applies the authoring gate before a red test; keeps mock and double guidance in `testing-anti-patterns.md`. |
| `systematic-debugging` | Places the one regression at the owner boundary. |
| `requesting-code-review` | Judges added or changed tests against the value bar. |
| `receiving-code-review` | Rejects requested tests that fail the authoring gate. |
| Repository instructions | Name repository-specific pinning tests, test commands, and known pre-existing failures. The bundle stays repository-neutral. |

## Trigger

The description front-loads one discriminative branch, auditing, pruning, or deduplicating existing tests, plus one judgment branch for a specific existing test or test-only seam. Test writing never loads the skill itself, so implementation sessions never load audit procedure.

## Creation time

The bar is enforced when a test is written, not only when it is audited or reviewed, because a model rarely doubts its own test:

- The fast path carries the authoring gate as one clause: the test protects observable behavior, fails without the change, and needs no test-only production seam or duplicate coverage. Fast-path work does not load the reference.
- Standard and High-risk work that adds or changes tests reads `test-value.md` and checks each new test against the authoring gate and junk patterns before the completion review. TDD does the same for each red test. The reference is about 600 words; it loads only when tests change.
- A test not seen failing without the change is not yet evidence. Seeing it fail means writing it first, or running it against the pre-fix source in a scratch copy, never discarding work in the live checkout.
- Review applies the same bar afterwards; it is the backstop, not the primary check.

## Authorization

Loading the skill authorizes no edits. Discovery and candidate evidence are read-only and reported before any deletion. Commits, pushes, and landing follow `finishing-a-development-branch`; deferred batches and uncertain candidates go to the canonical project record when `managing-project-state` applies.

## Budget

The skill body stays under the per-skill ceiling, and the bundle stays under the existing 4,400-word runtime total; the reference is outside the counted surface. No ceiling is raised.

## Evaluation

`adaptive-audit-keeps-contract-test` seeds one low-value test (asserting a stub's configured value), one duplicate, one test-only production export, and one source-inspection test that greps the configuration source for the public keys `docs/config.md` declares. A passing run removes the stub test, the duplicate, and the seam, and keeps the key guard or rewrites it as an equivalent behavioral check, with the suite green. `adaptive-regression-fails-without-fix` reports a quantity bug inside a private helper. A passing run fixes it, keeps the module's single export, and retains a regression through the public function that fails when run against the pre-fix source; exporting the helper to test it fails. Untreated baselines and live cross-model runs are owed for both; the repository contract validates the fixtures locally.
