# Final Review Fix Wave

**Goal:** Resolve every whole-branch review finding while preserving `skills/` as the single behavioral source of truth.
**Why planning is required:** The fixes change public installation, startup, workflow, and release-evidence contracts across multiple surfaces.
**Acceptance:** Claude startup names a readable shared full-router path; staging and public Codex installation refuse dangling destination symlinks before mutation; the 150-word gate expresses feasible retained coverage and three phases with repairs inside phase 3; public evaluation documents record the approved Standard/Fast decision and accurate scenario scope; focused contracts, `bash tests/run-all.sh`, `git diff --check`, full diff inspection, and the tracked secret/artifact audit pass; one fix commit is created without pushing.

### Outcome 1: Deterministic Claude router handoff
- Work: Update `hooks/session-start` to inject a resolved path to the existing `skills/using-superpowers/references/full-router.md`, and retain an executable hook-output contract proving the named file is readable without copying behavioral policy into the adapter.
- Verify: `bash tests/static/test-router-gate.sh`

### Outcome 2: Dangling symlinks remain occupied destinations
- Work: Harden `scripts/stage-adapter.sh` and the README Codex all-or-nothing preflight so both existing entries and symlinks are rejected; retain focused staging and public-installation regressions in `tests/install/test-adapters.sh`.
- Verify: `bash tests/install/test-adapters.sh`

### Outcome 3: Gate language matches the approved workflow qualification
- Work: Keep `skills/using-superpowers/SKILL.md` at exactly 150 words while allowing genuinely infeasible automation and describing three phases with repair remaining in phase 3; align the router contract assertions.
- Verify: `bash tests/static/test-router-gate.sh && bash tests/static/test-profile.sh`

### Outcome 4: Public evidence and navigation match the approved release decision
- Work: Reconcile the governing optimized-router design and evaluation summary with the approved Standard/Fast decision and final candidate identity; distinguish the two tracked executable scenarios from planned coverage in the README; link the optimized summary from README and `docs/evaluation.md`.
- Verify: `bash tests/static/test-repository-contract.sh`

### Outcome 5: Candidate is verified, audited, and handed off
- Work: Run the repository-required full suite once after all fixes, inspect the complete diff and tracked paths for secrets/raw artifacts, write the ignored final report, and create one commit without pushing.
- Verify: `bash tests/run-all.sh && git diff --check`
