# Shared refinement validation

**Candidate:** `feat/adaptive-model-refinements` changeset based on `92356b0`; Git records its delivery revision.
**Status:** Local technical checks and the resumed candidate execution probe passed. Independent final review passed after status-record reconciliation. Not a release approval or cross-model benchmark.

## Deterministic evidence

- Updated policy-presence lint failed on the old implementation, then passed after the policy changes. This is structural evidence, not model behavior.
- `bash tests/run-all.sh` passed, including existing contracts, adapter staging, nine project-state auditor tests, and six new executable probe-checker contracts.
- The probe checker rejects broken behavior, changed tests, and unexpected final artifacts/worktrees/branch or reachable commit count, and accepts the minimal correct fix. It checks final state, not transient activity that was undone. Fixture setup refuses an existing target.
- `bash scripts/validate.sh` and `git diff --check` passed.
- Inventory remains 13 skills. Direct skill text: 4,182 → 4,357 words; gate: 423 → 446. Conditional references: full router 892, delegation 307, explorer handoff 163, testing reference 591 words. These are inventory sizes, not per-run token usage.
- Native Claude marketplace and plugin manifest validation passed without errors or warnings; no skill-content or runtime verdict was returned by those manifest checks.

## Simulated continuation probe

Both agents received the same small, already-tested formatter request phrased as a continuation after compaction, with an explicit policy root and separate disposable repository. Neither saw the checker. Delegation was disabled for this small fixture in both arms.

| Arm | Observation | Interpretation |
| --- | --- | --- |
| Baseline at `92356b0` | Created `fix/profile-formatter` in another worktree; implemented the correct one-line fix; existing tests failed before and passed after; test file unchanged | The old resume rule imposed isolation overhead despite the small remaining task. Functional work succeeded in the new worktree; the no-churn fixture contract did not pass in the original checkout. |
| Candidate | Selected fast path after inspecting the clean checkout and existing coverage; observed the intended failing test. Initially credit-blocked before editing; after user-authorized continuation, revalidated and completed the one-line fix in the original checkout, with existing tests unchanged and green | Parent independently ran `probe.py check` successfully: correct behavior, retained tests, only the intended source change, no residual extra worktree/artifacts, and unchanged reachable commit count. The agent reported no delivery action. |

This is one local probe per arm, not a real context-window compaction, latency comparison, or Astra/Sol/Fable/Opus matrix. The candidate resumed after an external interruption, so wall-clock time is not comparable. The completed result supports this bounded continuation/retained-coverage behavior only; it does not establish general activation or performance.

## Review

A fresh final reviewer was dispatched but initially failed before returning findings because the workspace was out of credits. After the user's continuation approval, it reviewed the complete uncommitted range independently against `92356b0`. It found no supported policy/test blocker. Its Important finding was stale plan/canonical status still reporting the candidate and Claude-document access as credit-blocked; those records were reconciled to current evidence. Its optional checker recommendation is recorded as an explicit limit: final state does not establish absence of transient create-then-delete activity; future action-efficiency measurements need tool-trajectory evidence.

The reviewer verified those corrections and returned **ready for completion of the uncommitted refinement**, with no remaining blocking findings. This verdict is not release, installation, or cross-model approval. Existing suite evidence was reused because policy/test code was unchanged in this continuation; final documentation passed `git diff --check`.

Pending: preserve the existing cross-model and lifecycle evaluation backlog; no general performance, native activation, or transient-action claim is established. Claude native evaluation is early-access gated locally, confirmed by a blank-template command that created no files and ran no model. The original evaluation performed no delivery; the later user request authorizes a combined local commit including the Windows hook repair. No push, merge, installation, or paid native Claude evaluation is authorized by that request.

## Windows dispatch follow-up

The existing Claude SessionStart hook now selects Bash and launches through `hooks/run-hook.cmd`, following upstream's cross-platform dispatch approach. Unlike the earlier staged draft, the batch fallback reports missing Bash and propagates the actual hook exit code through separate labels; LF attributes protect Bash-consumed files during Windows checkout. The gate payload, startup matcher, and Codex empty-hooks configuration are unchanged.

Focused contracts first failed without the dispatcher/shell/line-ending rules, then passed. Six POSIX cases exercise the configured command, paths containing spaces/parentheses, payload, argument/missing-file errors, child failure propagation, and LF attributes. Three native Windows cases (payload, exit code, missing Bash) are retained and skipped on macOS; neither shell inspection nor POSIX success is Windows runtime proof. The full repository suite, adapter staging, bundle validator, and diff checks pass. The original staged upstream-adoption draft remains byte-for-byte unchanged.

Independent final integration review found no blocking findings and approved the authorized single combined local commit. It recommends running the retained native Windows cases before release or installation claims. That validation remains outstanding; the review does not authorize remote delivery or installation.
