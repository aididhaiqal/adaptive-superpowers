# Test Value

A test earns its maintenance cost by protecting observable behavior, a credible regression, or an independently meaningful contract. The authoring gate applies whenever a test is written or changed; the junk patterns and retention bar apply both when writing and when auditing.

## Authoring gate

Before adding or changing a test, answer four questions:

1. What observable behavior, invariant, or independent contract does it protect?
2. What credible regression makes it fail?
3. Why does existing coverage not already catch that failure? Each contract has one primary test owner at the strongest boundary; another layer needs its own distinct risk, such as a transport or lifecycle failure the owner cannot reach. Extend a table-driven case or shared fixture before adding a near-duplicate, and consolidate duplicated setup in the same change.
4. Does it need a production seam (export, flag, wrapper, injection hook) that no production caller needs? If so, test at the real boundary instead.

A missing answer means do not add it yet. Then check the test against every junk pattern; a match fails the gate unless the retention bar names the contract it independently guards. A test that would break under behavior-preserving refactoring asserts implementation; rewrite it at the owning boundary before landing it.

Before relying on a new test, see it fail without the change: write it before the change, or run it against the pre-fix source in a scratch copy, never by discarding work in the live checkout. A bug regression test must fail on the pre-fix code for the intended reason and pass after the owner-boundary repair. A regression that never demonstrably failed proves the mock, not the fix. One regression at the owner boundary covers the bug; do not replay the same scenario at every layer it crosses.

## Junk patterns

- assertion-free coverage probes;
- self-comparisons and identity copiers;
- copied fixtures, inventories, manifests, or export lists;
- exact source, import, or string greps;
- private predicate or call-shape tests duplicated at real boundaries;
- duplicate invocations of the same contract;
- per-implementation replays of a shared helper's own tests;
- tests whose only purpose is preserving test-only exports, globals, or wrappers;
- dead production code whose only callers are tests;
- expected values produced by the helper or renderer under test;
- mocks that implement the asserted behavior, or one identical mock standing in for different APIs;
- fixtures that supply the receipt, admission, or callback ordering the owner should produce, or persistence asserted against a store the path never writes;
- capability tests that restate declared flags instead of exercising the delivery or acknowledgement the flag promises;
- negative controls that pass for an unrelated reason, such as a denial from a different guard or a rejection the production path never reaches;
- names or fixtures that promise more than the input exercises.

## Retention bar

Keep a test when it independently enforces a public API, SDK, protocol, configuration, migration, storage, security, platform, default, prompt-byte, generated cross-language, package, release, or architecture contract. Also keep:

- call ordering when order is observable behavior;
- regressions with a credible failure mode;
- source or structure inspection when it is the cheapest independent guard: it fails when the contract changes (the user-facing key, byte, path, registration, or load-bearing ordering) and survives an identifier-only rename;
- a retained test that fails on the baseline: treat it as a possible product bug, reproduce it through `systematic-debugging`, and repair the owner rather than deleting it.

Static or slow is not a deletion reason. A test that resembles implementation may still be the independent contract; prove otherwise before removing it. An existing test that must change under a behavior-preserving reorganization is suspect, not automatically deletable.
