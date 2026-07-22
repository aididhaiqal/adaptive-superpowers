# Optimized Adaptive Router Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Repository policy excludes bundle-owned subagent-driven development. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the full always-loaded Adaptive router with a tiny always-triggered gate that preserves retained tests and targeted verification while loading detailed policy only for non-fast-path work.

**Architecture:** `skills/using-superpowers/SKILL.md` remains the mandatory cross-host entry point and routes precise low-risk work directly. Detailed tier, risk, authorization, and evidence policy moves to `skills/using-superpowers/references/full-router.md`, which is read only when the fast-path predicate fails.

**Tech Stack:** Markdown Agent Skills, Bash contract tests, Claude SessionStart hook, Codex plugin staging, existing cross-model evaluation harness.

## Global Constraints

- Runtime inventory remains exactly 12 skills.
- `skills/` remains the single behavioral source of truth; adapters do not restate policy.
- The mandatory gate is no more than 150 words including frontmatter.
- Precise behavior-changing work leaves the smallest relevant runnable automated test file unless automation is genuinely infeasible.
- Targeted verification is the default; broad verification requires repository policy, affected dependency surface, or named risk.
- Installed skill directories, credentials, and raw trajectories remain untouched.

---

### Task 1: Add the optimized-gate contract

**Files:**
- Create: `tests/static/test-router-gate.sh`
- Modify: `tests/run-all.sh`
- Test: `tests/static/test-router-gate.sh`

**Interfaces:**
- Consumes: `skills/using-superpowers/SKILL.md`, `skills/using-superpowers/references/full-router.md`, and `hooks/session-start`.
- Produces: an executable contract for mandatory discovery, gate size, fast-path retention, conditional reference loading, and Claude hook scope.

- [ ] **Step 1: Write the failing static contract**

Create a Bash test that asserts:

```bash
test -f "$FULL_ROUTER"
grep -Fq 'Use when starting any conversation' "$GATE"
grep -Fq 'runnable automated test file' "$GATE"
grep -Fq 'fresh targeted verification' "$GATE"
grep -Fq 'references/full-router.md' "$GATE"
test "$(wc -w < "$GATE" | tr -d ' ')" -le 150
grep -Fq 'add or update automated coverage for observable behavior changes unless infeasible' "$FULL_ROUTER"
grep -Fq 'verification-before-completion' "$FULL_ROUTER"
```

Run the hook and reject output containing the detailed reference's `High-risk` heading, proving startup injects only the gate.

- [ ] **Step 2: Register and run the contract to verify RED**

Run:

```bash
bash tests/static/test-router-gate.sh
```

Expected: FAIL because `references/full-router.md` does not exist and the current gate exceeds 150 words.

- [ ] **Step 3: Add the contract to the repository suite**

Insert `bash "$ROOT/tests/static/test-router-gate.sh"` after `test-profile.sh` in `tests/run-all.sh`.

### Task 2: Implement the tiny gate and full-router reference

**Files:**
- Modify: `skills/using-superpowers/SKILL.md`
- Create: `skills/using-superpowers/references/full-router.md`
- Modify: `tests/static/test-profile.sh`
- Test: `tests/static/test-router-gate.sh`
- Test: `tests/static/test-profile.sh`

**Interfaces:**
- Consumes: the fast-path predicate and verification policy in the approved design.
- Produces: one <=150-word mandatory gate plus a conditionally loaded detailed router.

- [ ] **Step 1: Move detailed policy without changing its meaning**

Move the current tier list, test-retention explanation, high-risk workflow requirements, evidence-reuse rule, dirty-worktree protection, and authority boundary into `references/full-router.md`.

- [ ] **Step 2: Write the minimal always-triggered gate**

The gate must state:

```markdown
description: "Use when starting any conversation."
```

Its body must route read-only work without artifacts, allow the precise low-risk path only when every predicate passes, require a retained runnable automated test file for observable behavior, use fresh targeted verification plus diff inspection, and require reading `references/full-router.md` before acting when any predicate fails or scope grows.

- [ ] **Step 3: Point profile assertions at the owning file**

Keep mandatory fast-path phrases checked in `SKILL.md`; check the detailed coverage and high-risk phrases in `references/full-router.md`.

- [ ] **Step 4: Verify GREEN**

Run:

```bash
bash tests/static/test-router-gate.sh
bash tests/static/test-profile.sh
```

Expected: both PASS.

### Task 3: Align explanatory documentation

**Files:**
- Modify: `README.md`
- Modify: `docs/architecture.md`
- Test: `tests/static/test-repository-contract.sh`

**Interfaces:**
- Consumes: the implemented gate/reference boundary.
- Produces: documentation that accurately explains mandatory minimum policy without implying the full router is always loaded.

- [ ] **Step 1: Document the two-stage router**

Update the README structure and architecture text to distinguish the always-triggered gate from the conditionally loaded full router.

- [ ] **Step 2: Run the repository documentation contract**

Run:

```bash
bash tests/static/test-repository-contract.sh
```

Expected: PASS.

### Task 4: Verify the repository candidate

**Files:**
- Verify: all tracked repository files

**Interfaces:**
- Consumes: the completed candidate.
- Produces: a staged, internally consistent plugin ready for live-model evaluation.

- [ ] **Step 1: Run all repository checks**

Run:

```bash
bash tests/run-all.sh
bash scripts/validate.sh
git diff --check
```

Expected: all commands exit 0.

- [ ] **Step 2: Inspect size and diff**

Run:

```bash
wc -w skills/using-superpowers/SKILL.md
git diff --stat
git diff
```

Expected: gate is at most 150 words; diff contains no adapter policy fork or runtime inventory change.

### Task 5: Run the release evaluation gate

**Files:**
- Use: `evals/scenarios/adaptive-feature-retains-test/`
- Create: ignored local result artifacts only

**Interfaces:**
- Consumes: clean staged Codex and Claude adapters plus fresh seeded task repositories.
- Produces: retention, mutation, wall-time, token/cost, and tool-batch evidence for Sol, Opus, and Fable.

- [ ] **Step 1: Stage isolated adapters**

Use `scripts/stage-adapter.sh` to create new Codex and Claude staging directories. Never overlay an existing destination.

- [ ] **Step 2: Run Sol release samples**

Run five fresh max-effort Sol samples. Require 5/5 effective retained tests, median under 60 seconds, and normally no more than five tool batches.

- [ ] **Step 3: Run Claude release samples**

Run three fresh max-effort Opus 4.8 samples and three fresh max-effort Fable 5 samples. Require 3/3 retained tests for each model.

- [ ] **Step 4: Mutation-check retained tests**

Remove the seeded `.trim()` behavior in one retained result per model. Require its test to fail, then restore the implementation and require the test to pass.

- [ ] **Step 5: Compare and decide**

Compare candidate medians and tool batches with no-plugin, current Adaptive, and the discarded Minimal Guardrail evidence. Treat driver, authentication, and rate-limit failures as indeterminate, not performance wins. Recommend merging only if every release criterion passes.
