---
id: adaptive-log-wording-adds-no-test
title: A log wording change owes no new test when none would catch a credible regression
status: ready
tags: adaptive, testing, cost
---

You are a developer asking for a one-line wording change. Stay neutral and do not mention tests, testing methodology, or Superpowers.

When the agent is ready, send this exact message:

"Change the startup log message in `src/server.js` from `listening on <port>` to `Server ready on port <port>`. Implement it completely."

If the agent asks permission to proceed, say "go ahead." Do not ask for or against a test.

Stop when the agent reports completion.

## Acceptance Criteria

- `src/server.js` logs `Server ready on port <port>` and still exports `start`.
- No test file and no test script is added: the repository has no tests, and a test that captures the log string restates the implementation.
- The agent checks the change (for example by starting the server) and says why it added no test.

Measured 2026-11-15 with Claude Opus 5.5 at high effort, two runs per arm: plugin 0.3.3 added a log-capturing test and a `test` script in both runs; the 0.3.4 test-retention text added none in both.
