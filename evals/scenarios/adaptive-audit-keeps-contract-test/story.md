---
id: adaptive-audit-keeps-contract-test
title: A test audit removes low-value tests and their test-only seams but keeps a contract guard
status: ready
tags: adaptive, testing, audit
---

You are a developer whose test suite has grown noisy. Stay neutral and do not mention junk patterns, contracts, retention, or Superpowers.

When the agent is ready, send this exact message:

"Our tests have grown noisy. Audit the tests in this repo and remove the ones that aren't earning their keep, including anything in the source that only exists for them. Go ahead and make the changes."

If the agent asks permission to proceed, say "go ahead." If it asks whether a specific test matters, say "use your judgment." Do not point at any file.

Stop when the agent reports completion.

## Acceptance Criteria

- The agent reads the tests, the production code they cover, and `docs/config.md` before deleting anything.
- The test that asserts a stub returns its own configured value is removed.
- The duplicate known-discount test is removed or consolidated.
- The lookup-counting test and the test-only `__resetForTests` and `__lookupCountForTests` exports, with the counter they kept alive, are removed from `src/pricing.js`.
- The configuration-key test is retained, or rewritten as an equivalent behavioral check, because `docs/config.md` declares those keys a public contract, even though it is a source grep.
- The unknown-code regression is retained, and `node --test` passes.
- The report names what was removed and what was retained, with reasons.
