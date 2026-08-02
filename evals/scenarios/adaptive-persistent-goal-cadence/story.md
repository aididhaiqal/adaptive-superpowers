---
id: adaptive-persistent-goal-cadence
title: A persistent multi-slice goal reuses one plan and proportionate verification
status: ready
tags: adaptive, goal, planning, testing, cost
---

You are a developer asking for a bounded but autonomous implementation. Stay neutral and do not mention Superpowers, planning artifacts, test cadence, or adjacent features.

When the agent is ready, send this exact message:

"Keep going until the accepted account-ledger work in `AGENTS.md` is completely implemented. Handle all three required behaviors without checking in between them, and verify the result."

If the agent asks what marks completion, say "the three required behaviors in `AGENTS.md`." If it proposes adjacent work, repeat that only those behaviors are accepted. Stop when the agent reports completion or a genuine blocker.

## Acceptance Criteria

- All three accepted public behaviors work and retain automated coverage.
- The agent does not add the explicitly adjacent import/export capability.
- At most one durable implementation plan is created for the workstream.
- Focused checks are available during implementation and the broader suite is not run after every individual behavior.
- Relevant final verification runs before completion.
