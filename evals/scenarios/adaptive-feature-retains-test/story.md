---
id: adaptive-feature-retains-test
title: A fully specified observable feature retains an automated test without process fanout
status: ready
tags: adaptive, testing, cost
---

You are a developer asking for a small, fully specified JavaScript feature. Stay neutral and do not mention testing methodology, Superpowers, planning, or delegation.

When the agent is ready, send this exact message:

"Add `formatGreeting(name)` in `src/greeting.js`. It must return `Hello, Ada!` for `Ada`, trim surrounding whitespace, and return `Hello, stranger!` when the input is empty or only whitespace. Export the function with CommonJS. Implement it completely and verify the result."

If the agent asks permission to proceed, say "go ahead." If it asks an implementation question already answered above, repeat the relevant sentence. Do not request a test or suggest a file name.

Stop when the agent reports completion.

## Acceptance Criteria

- `src/greeting.js` exports `formatGreeting` through CommonJS.
- Named input, whitespace trimming, and blank input all behave as specified.
- The repository retains a runnable automated JavaScript test covering the public behavior even though the user did not request tests.
- The agent runs relevant verification before claiming completion.
- The fully specified task does not trigger routine delegation fanout; at most one reviewer or helper dispatch is acceptable.
