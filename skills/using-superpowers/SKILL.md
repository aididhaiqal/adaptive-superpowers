---
name: using-superpowers
description: "Use when starting any conversation."
---

# Adaptive Gate

- **Read-only requests:** Inspect and answer without implementation artifacts. For bulky independent investigation, use available read-only explorers through `references/explorer-handoff.md`; otherwise inspect locally. Keep integration and user decisions in the parent context.
- **Delegation:** The parent owns integration, accepted scope, and user decisions. Give dispatched agents bounded briefs. They may decide implementation details within that scope, but return material ambiguity to the parent and test and verify their assigned work. Core outcomes cannot be silently narrowed or deferred.
- **Project state:** Use `managing-project-state` for material, resumable, persistent, or repository-tracked work; skip routine isolated work. For persistent goals, establish accepted outcomes, execution boundary, verification cadence, and stopping condition. Infer the stopping condition when clear; ask only when materially different interpretations change scope. After resume, continue unfinished accepted work only. Completion and optional recommendations do not extend the goal.
- **Fast path:** Use for a small, clearly accepted change with understood local impact and focused verification. Exclude concurrent or delegated editing, unresolved material user choices, security-sensitive or destructive changes, production data, migrations, public APIs or contracts, cross-system behavior, and external-system changes. After resume or compaction, revalidate checkout, accepted scope, and applicable project records; then classify the remaining work, not the session history. If a user choice could materially change the requested result, ask one focused question before making the affected changes; do not bypass it with provisional defaults, configuration, or multiple implementations. Unrelated safe inspection may continue. Offer material recommendations only when evidence supports them. Recommendations do not authorize additional work.

For every fast-path implementation:

1. Inspect the relevant file contents and repository status.
2. Implement the accepted change. Existing sufficient retained coverage counts; add or update runnable tests for missing behavioral coverage, not process compliance; transient checks do not count. When automation is infeasible, state why.
3. Run fresh targeted verification, reconcile any repository-required canonical progress or status record from final evidence, and review the final diff against the request and acceptance criteria. Repair failures before moving beyond verification. Supported Critical or Important findings block completion.

Before working, send one concise update. Do not send another pre-work update or restate the acceptance criteria.

- **Full router:** For every other implementation or consequential action, read `references/full-router.md` before proceeding. Use an isolated worktree when the full router requires one. When isolation is required, a checkout containing unrelated changes is not suitable.

Reclassify the task if its scope or risk grows. Preserve user work. Obtain explicit authority before destructive actions or consequential actions in external systems.

User instructions take precedence over skill defaults within host safety rules. Do not re-ask for authority already granted within the accepted scope.
