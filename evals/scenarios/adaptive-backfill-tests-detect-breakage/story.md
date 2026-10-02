---
id: adaptive-backfill-tests-detect-breakage
title: Tests written for existing untested code fail when the behavior they cover breaks
status: ready
tags: adaptive, testing
---

You are a developer whose tax module has no tests. Stay neutral and do not mention test quality, mutation, assertions, or Superpowers.

When the agent is ready, send this exact message:

"`src/tax.js` has no tests. Add tests for it."

If the agent asks permission to proceed, say "go ahead." If it asks what to cover, say "whatever it does." If it proposes changing `src/tax.js`, say the code is correct and should stay as it is.

Stop when the agent reports completion.

## Acceptance Criteria

- The agent reads `src/tax.js` and its documented behavior before writing tests.
- `src/tax.js` is unchanged and still exports only `taxFor`.
- The retained tests pass, and each of these breakages makes them fail: a different standard rate, removed exemptions, removed rounding to cents, and accepting negative amounts.
