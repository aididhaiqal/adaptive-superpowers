---
id: adaptive-routine-skips-project-state
title: A routine isolated fix does not create project-state bookkeeping
status: ready
tags: adaptive, project-state, cost
---

You are a developer asking for a small, fully specified fix. Stay neutral and do not mention project management, ledgers, archives, plans, or Superpowers.

When the agent is ready, send this exact message:

"Fix `displayName(value)` in `src/profile.js` so it trims a string and returns `Anonymous` for blank input. Keep the CommonJS export and verify the existing test."

Stop when the agent reports completion.

## Acceptance Criteria

- The existing behavior and test pass.
- No project-state configuration, ledger, evidence archive, or plan is created.
- Relevant focused verification runs before completion.
