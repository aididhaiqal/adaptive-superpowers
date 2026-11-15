# Changelog

## Unreleased

- A test is owed for a credible behavior regression no existing test catches, not because one is feasible: the agent names the regression before writing the test, and `No new test: <reason>` is a complete outcome (gate fast path, full router, `test-value.md`). Seen-failing counts only an assertion failure on the protected behavior, once per behavior; presence guards are exempt. Wording meant to change agent behavior is proved by a forward test, and phrase pins only guard against deletion (`writing-skills`, bundle `AGENTS.md`, retention bar). TDD no longer implies a test for every change, debugging adds no second regression beside an already failing test, plans may say `Proof: none: <reason>`, and review judges declined tests too. Decided by a Fable consult on the owner's "ask fable" (2026-11-15) and tightened by an independent review: a test that needs a seam moves to the real boundary, and pins guard links, names, and wording a forward test or recorded decision established. New scenario `adaptive-log-wording-adds-no-test`; forward results in `docs/evaluations/2026-11-15-test-owed-not-feasible.md`. Plugin version 0.3.4.
- A child on another provider's model gets the effort option under that provider's own name (Codex `reasoningEffort`, Claude `effort`) at this session's level, never the provider's default (Codex models in T3 default as low as `low`). `check-children.py --codex <marker> --expect-model <id>` proves a Codex delegate's model and effort from its session log, and a T3 child's `executedModel` proves the model elsewhere. Plugin version 0.3.3.
- Children run on the parent's model and effort: a new conditional reference, `using-superpowers/references/delegation.md`, has every dispatch pass the parent's exact model and reasoning effort unless the user names another (built-in specialist agent types otherwise ran on a smaller model), pick a foreground or background channel, fan out only independent work under a six-child default cap, brief with a unique marker and a fixed last line, wait without polling, and report the pair from the host's record. `scripts/check-children.py` proves it from Claude Code transcripts. The gate, the full router and the explorer handoff point to it. Plugin version 0.3.2 so installs refresh.
- Repair repository consistency: the validator rejects skill text that names a missing `.sh` or `.py` script, the profile test requires all three plugin manifests to agree on one version instead of pinning a literal, the Codex manifest moves to 0.3.1 with the Claude manifests, and `root-cause-tracing.md` replaces the never-shipped `find-polluter.sh` with the one-file-at-a-time search it performed.
- Delegated slices deliver in batches: a dispatched agent commits its slice on its own branch and stops; the parent gathers what is ready, integrates it as one batch through the repository's wrapper, verifies once, attributes a failing check to the first slice it fails with and delivers the rest (`finishing-a-development-branch`, `using-git-worktrees`, the gate's delegation rule). Plugin version 0.3.1 so installs refresh.
- Add `auditing-tests` as the fourteenth conditional runtime skill: read-only discovery, per-candidate evidence, and owner-boundary pruning of low-value tests and the test-only production seams they keep alive. Adapted from the OpenClaw `test-audit` value bar without its host-specific tooling.
- Make `auditing-tests/references/test-value.md` the single owner of the authoring gate, junk patterns, and retention bar; standard work that adds or changes tests reads it and checks each new test before the completion review, TDD checks each red test, both review skills judge against it, and the gate and debugging carry one-clause summaries.
- Fast-path tests protect observable behavior, fail if that behavior breaks, and need no test-only seam or duplicate coverage; a test is evidence only once seen failing, without the change or with the protected behavior broken in a scratch copy, and a bug's one regression lives at the owner boundary.
- Plans name one proof owner per outcome, so per-layer duplicate tests are not scheduled up front.
- Add the `adaptive-backfill-tests-detect-breakage` scenario: tests written for untested code must fail under each of four breakages of its documented behavior.
- Add the `adaptive-regression-fails-without-fix` scenario: the retained regression must go through the public function, keep the module's single export, and fail against the pre-fix source.
- Add the `adaptive-audit-keeps-contract-test` scenario: remove a self-asserting stub test, a duplicate, and a test-only seam while keeping a source-inspection guard that pins public configuration keys.
- Document linking skills added since the last update for existing Codex installs.

## 0.3.0 - 2026-08-02

- Add `managing-project-state` as the thirteenth conditional runtime skill inside Adaptive Superpowers.
- Keep routine isolated work free of new ledgers, configuration, evidence archives, and instruction churn.
- Protect queued, active, blocked, and future-watch obligations from silent downgrade, replacement, deferral, or removal.
- Add convention and managed profiles, a deterministic structural/Git-range auditor, bounded evidence admission, and repository-instruction continuity.
- Raise the 13-skill bundle ceiling proportionally to 4,400 words while keeping the always-loaded gate below 450 words.
- Bound persistent goals with accepted outcomes, an automatic-execution boundary, verification cadence, and an explicit stopping condition.
- Reuse one governing plan and resume at the first unfinished accepted outcome after compaction.
- Use focused checks during implementation and broader suites at coherent milestones or final verification, reusing unchanged evidence.
- Require fast-path automation omissions to be explained and reviewers to validate claims unsupported by supplied evidence.
- Review coherent feature ranges, reuse implementer test evidence, and group final findings into one fix wave and scoped re-review.
- Preserve unresolved blockers, external gates, accepted exclusions, pending outcomes, and material watch items when consolidating canonical records.
- Prefer applicable repository abstractions over parallel low-level parsing, validation, mapping, configuration, command, or event paths.

## 0.2.1 - 2026-08-01

- Reconcile material or resumable work into one repository-designated canonical progress record.
- Fall back to `docs/progress.md` when a project has no existing progress, roadmap, or status record.
- Keep routine isolated work exempt and avoid per-task implementation logs or duplicate ledgers.

## 0.2.0 - 2026-07-25

- Scale brainstorming by decision consequence, preserve conversation-level promises, and require explicit approval for material deferrals.
- Pause affected implementation when an unresolved user choice controls the result, while allowing unrelated safe inspection to continue.
- Prevent provisional defaults, configuration switches, or multiple implementations from bypassing a required user decision.
- Tighten isolation so unrelated changes disqualify a checkout for new material or resumable work.
- Keep harness-native worktrees only when they leave the original checkout unchanged; never add ignore files or rules to conceal them.
- Keep the mandatory gate compact and readable instead of enforcing an arbitrary word target.
- Add a parent-owned delegation boundary without restoring mandatory subagent workflows.
- Validate the precision revision across Opus 5, Fable 5, Sol, Terra, Sol Fast, and Terra Fast.

## 0.1.0 - 2026-07-23

- Establish a 12-skill risk-adaptive shared core.
- Preserve automated coverage for observable behavior changes and confirmed regressions.
- Remove bundle-owned parallel-agent, subagent-driven, and implementation-log workflows.
- Add isolated Codex and Claude Code staging adapters.
- Omit the inherited visual companion pending security hardening.
- Add static profile, adapter, and repository contract tests.
- Add a proportional final completion review for missed requirements, integration gaps, and material recommendations before branch delivery.
- Require isolation for material plan execution, concurrent or resumable implementation, and editing delegation unless the checkout is already isolated.
- Revalidate live checkout identity after resume and before mutations or branch operations, overriding stale summaries and retired progress workflows.
- Add an executable stale-resume scenario that preserves another session's dirty feature branch.
- Put verified Codex and Claude installation, verification, update, and removal paths at the top of the README.
