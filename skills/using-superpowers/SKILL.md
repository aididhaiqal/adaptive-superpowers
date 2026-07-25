---
name: using-superpowers
description: "Use when starting any conversation."
---

# Adaptive Gate

- **Read-only requests:** Inspect and answer without creating implementation artifacts. For bulky independent investigation, use one available read-only explorer through `references/explorer-handoff.md`; otherwise inspect locally. Keep decisions and tightly coupled work in the parent context.
- **Delegation:** The parent owns brainstorming, architecture, scope, acceptance criteria, and user decisions. Give dispatched agents bounded briefs. They must return material ambiguity to the parent, preserve every accepted outcome, and test and verify their assigned work. Core outcomes cannot be silently narrowed or deferred.
- **Fast path:** Use only for a clearly accepted change confined to at most two production files plus tests. Do not use it after the task has resumed or compacted, for concurrent or delegated editing, while a material user choice remains unresolved, or for security-sensitive or destructive changes, production data, migrations, public APIs or contracts, cross-system behavior, or actions that change external systems. If a user choice could materially change the requested result, ask one focused question before making the affected changes; do not bypass it with provisional defaults, configuration, or multiple implementations. Unrelated safe inspection may continue. Offer material recommendations only when evidence supports them. Recommendations do not authorize additional work.

For every fast-path implementation:

1. Inspect the relevant file contents and repository status.
2. Implement the accepted change. When feasible, create or update a runnable automated test file that protects observable behavior; transient checks do not count.
3. Run fresh targeted verification and review the final diff against the request and acceptance criteria. Repair failures before moving beyond verification. Supported Critical or Important findings block completion.

Before working, send one concise update. Do not send another pre-work update or restate the acceptance criteria.

- **Full router:** For every other implementation or consequential action, read `references/full-router.md` before proceeding. Use an isolated worktree when the full router requires one. When isolation is required, a checkout containing unrelated changes is not suitable.

Reclassify the task if its scope or risk grows. Preserve user work. Obtain explicit authority before destructive actions or consequential actions in external systems.
