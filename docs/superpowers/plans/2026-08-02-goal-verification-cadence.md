# Goal and Verification Cadence

**Status:** Locally implemented; cross-model evaluation pending.

**Goal:** Keep long-running and persistent-goal work autonomous without multiplying plans, repeated verification, review waves, or adjacent scope.

**Why planning is required:** This changes the shared workflow contract used by Codex, Claude, and Fable across resumable implementation, testing, review, and project-status tracking.

**Acceptance:** One governing plan covers an authorized workstream; persistent goals establish an execution and stopping boundary; resumes continue at the first unfinished accepted outcome; focused evidence is reused until invalidated; broad suites and reviews run at coherent boundaries; applicable repository abstractions are preferred over parallel low-level paths; the approved project-state design raises the runtime inventory to 13 skills; and the repository suite passes. No model-specific profile, mandatory subagent workflow, per-plan SDD workspace, release, install, or push is included.

### Outcome 1: Encode the missing workflow contracts

- Work: Add static contracts for governing-plan reuse, persistent-goal closure, coherent verification and review cadence, compaction recovery, canonical progress cadence, and applicable repository paths. Add a behavioral evaluation fixture for a multi-slice persistent goal without prescribing global test-count or time budgets.
- Verify: `bash tests/run-all.sh`

### Outcome 2: Refine the shared runtime policy

- Work: Update only the directly affected router, planning, execution, TDD, and review skills. Preserve conditional TDD, host-native delegation, retained automated coverage, worktree safety, authorization boundaries, and the canonical-project-ledger model.
- Verify: `bash scripts/validate.sh && bash tests/run-all.sh`

### Outcome 3: Reconcile documentation and final evidence

- Work: Document the goal contract and project-ledger versus temporary execution-state boundary, update the changelog without declaring a release, reconcile `docs/progress.md`, inspect the complete diff, and run the full repository suite plus `git diff --check`.
- Verify: `bash tests/run-all.sh && git diff --check`
