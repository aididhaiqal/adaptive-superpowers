---
name: auditing-tests
description: "Use when auditing, pruning, or deduplicating existing tests, or when judging whether a specific test or test-only production seam earns its maintenance cost."
---

# Auditing Tests

Optimize for confidence, not deletion count. Loading this skill does not authorize edits: discovery and judgment stay read-only until edits are authorized. Read [test-value.md](references/test-value.md) before judging any test; it owns the junk patterns and retention bar.

1. Read root and scoped repository instructions first: they name test commands, deliberate pinning tests, and known pre-existing failures.
2. Discover read-only. For broad scope, split by owner area plus one cross-cutting pattern sweep, using an explorer only under the gate's rule. Prefer a few high-confidence candidates over a speculative inventory.
3. For each candidate, read the complete test, its production owner, entry point, callers, overlapping tests, CI routing, and history; inspect the dependency when the test claims dependency behavior. Record:
   - exact test name and location;
   - the failure it can actually detect;
   - non-test callers of the covered seam;
   - the stronger remaining owner-boundary proof, or why none is needed;
   - why the test or seam exists;
   - the production or test-support deletion it unlocks;
   - risk and the focused validation command.

   A missing field means the candidate is not ready.
4. Report candidates and retained false positives before editing.
5. When authorized, edit one coherent owner-boundary batch. Delete low-value tests with the test-only exports, flags, wrappers, and dead production paths they kept alive; move retained regressions to their canonical owner; consolidate duplicates into one table-driven contract. Do not add replacement tests that restate the implementation or turn uncertain candidates into cleanup.
6. Verify with the owner and sibling suites, the executable or dry run that owns any contract a removed inspection test claimed, and the repository's changed-path gate. A retained test failing on the baseline is a possible product bug: route it to `systematic-debugging`.
7. Report removed categories, production simplifications, retained false positives with reasons, checks actually run, production versus test line counts, and follow-ups. Record deferred batches in the canonical record when `managing-project-state` applies.

Continue a broad audit as separate batches; after each integrates, rediscover from current main instead of reusing a stale inventory.
