# Repository instructions

Update instructions only when live repository truth materially changes:

- build, test, lint, format, or development commands;
- architecture, canonical implementation paths, or module ownership;
- security, destructive-action, data, deployment, or release boundaries;
- canonical progress, roadmap, or status ownership;
- worktree, branch, CI, agent-workflow, or nested-subtree conventions;
- referenced paths or commands that became stale.

Do not update instructions for routine implementation, temporary diagnostics, one-off failures, test counts, completed-task history, or unaccepted plans.

Place shared repository facts in root `AGENTS.md`, narrower facts in the nearest nested `AGENTS.md`, and deliberate local replacements in `AGENTS.override.md`. Keep `CLAUDE.md` thin and host-specific; point to shared policy instead of copying it. Preserve a sound established convention rather than reorganizing merely to match these defaults.

Before editing, discover the effective instruction chain and compare claims with live source, Git, CI, runnable commands, deployment configuration, and canonical documentation. Audit-only requests remain read-only. Update the narrowest canonical rule, replace stale text rather than appending a contradiction, then verify changed commands and paths.

Never place credentials, tokens, personal data, or copied secret values in instructions. Treat the bundled auditor's possible-secret and dangerous-directive findings as heuristic warnings requiring inspection, not semantic proof.
