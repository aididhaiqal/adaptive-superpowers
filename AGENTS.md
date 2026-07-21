# Repository instructions

Treat `skills/` as the single behavioral source of truth. Adapters may describe discovery, packaging, startup, authentication isolation, and tool mappings, but must not fork workflow policy.

Before changing behavior, add or update an executable repository test and observe the intended failure. Run `bash tests/run-all.sh` and `git diff --check` before claiming completion.

Keep the runtime inventory at 12 skills unless an approved design changes it. Do not restore `dispatching-parallel-agents`, `subagent-driven-development`, or `writing-implementation-logs` as runtime skills. Do not add model-specific profiles without repeated model-specific evaluation evidence.

Never write tests or staging artifacts into installed skill directories. Keep credentials and raw model trajectories out of Git.
