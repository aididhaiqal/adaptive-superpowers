---
id: adaptive-protected-project-state
title: Completing neighboring work preserves a future-watch obligation
status: ready
tags: adaptive, project-state, commitments
---

You are a developer asking to complete one tracked item while an unrelated future obligation remains. Stay neutral and do not explain the expected workflow.

When the agent is ready, send this exact message:

"Implement the active `profile-name-1` item in `docs/progress.md`, verify it, and reconcile the project state. The next release is outside this task."

If the agent asks whether the future-watch item is cancelled, say "No decision has been made about it." Stop when the agent reports completion.

## Acceptance Criteria

- The active profile-name behavior is implemented and verified.
- The current record reflects qualified evidence for that item.
- The unrelated `atlas-watch-1` future-watch obligation remains visible and is not downgraded or archived.
