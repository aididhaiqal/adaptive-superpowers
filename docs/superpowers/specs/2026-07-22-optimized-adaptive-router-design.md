# Optimized Adaptive Router Design

**Status:** Approved for experimental release under the 2026-07-22 Fast-mode feasibility qualification.

## Goal

Reduce the routine latency and repeated workflow narration of Adaptive Superpowers without weakening its reliable test-retention baseline across Sol, Terra, Opus, and Fable.

## Evidence behind the change

- Current Adaptive retained tests reliably but used 12-18 command batches and took 81.26-126.25 seconds in the matched Sol samples.
- No-plugin control used three command batches and took 35.30 seconds, but retained no test.
- The description-only Minimal Guardrail was faster, but Sol retained a test in only two of three runs because precise tasks did not reliably load the skill body.
- Retained tests from Sol, Terra, Opus, and Fable caught the seeded whitespace mutation, so retention is protecting real behavior rather than creating ceremonial files.

## Approaches considered

1. **Keep the full router always loaded.** Reliable, but preserves the measured policy-reading and classification overhead.
2. **Use a tiny always-triggered gate with a conditional reference.** Selected. It makes the minimum contract unavoidable while moving uncommon classification detail off the fast path.
3. **Enforce the fast path in each host adapter.** Rejected because adapters would duplicate behavioral policy and could drift across hosts.

## Architecture

`skills/using-superpowers/SKILL.md` remains the mandatory entry point for every conversation and is limited to 150 words including frontmatter. It handles three outcomes:

- **Read-only:** inspect and answer without creating implementation artifacts.
- **Precise low-risk implementation:** use the host-required skill announcement as the sole pre-work plan update without restating explicit acceptance; use one bounded inspection phase; implement narrowly; leave the smallest relevant runnable automated test file unless automation is genuinely infeasible; run fresh targeted verification; inspect the diff; report evidence.
- **Everything else:** load `references/full-router.md` before implementation or consequential action.

The fast path is allowed only when acceptance is explicit, one local implementation locus is clear, expected scope is no more than two production files plus tests, no blocking choice remains, and no named high-risk condition applies. Scope growth immediately routes to the full reference.

`skills/using-superpowers/references/full-router.md` owns tier detail, authorization, dirty-worktree protection, high-risk planning, evidence reuse, and broader verification rules. The Claude startup hook injects the gate plus the deterministic path of this existing shared file, not the full router contents. The shared `skills/` tree remains the sole behavioral source of truth.

## Verification policy

Fast-path completion uses the smallest fresh targeted command that exercises the changed behavior. The model remains within verification phase 3 while repairing failures until the check passes. Broaden verification only when required by repository policy, affected dependency surface, or a named risk. A full suite is not an automatic extra step.

For observable behavior changes, transient assertions do not satisfy the contract: a runnable automated test file must remain in the workspace unless automation is genuinely infeasible. Confirmed bugs should retain a focused regression; strict RED-before-GREEN remains situational rather than universally mandatory.

## Adapter behavior

- Claude SessionStart injects the tiny gate plus a deterministic location for the existing shared full router, without duplicating its behavioral contents.
- Codex discovers and reads the same tiny gate through normal skill loading.
- Fable uses the unchanged Claude adapter.
- No model-specific policy profile is introduced.

## Evaluation gate

The original design required a sub-60-second Sol Standard median. On 2026-07-22, the user approved experimental release under this superseding feasibility qualification:

- Sol Standard retained an effective test in 5/5 runs but measured a 73.86-second median, so the original Standard target was not met;
- Sol Fast retained an effective test in 5/5 runs and measured a 55.47-second median while using 2.5 times ChatGPT credits;
- Terra Fast retained an effective test in 5/5 runs, Opus in 3/3, and Fable in 3/3;
- one retained test from each of the four target models failed against the seeded mutation and passed after restoration; and
- repository tests and `git diff --check` pass.

Acceptance therefore rests on retained-test correctness across all four target models plus the sub-60-second Sol Fast cohort, not a claim that Standard met 60 seconds. Full cohort details and exclusions are recorded in the [optimized-router evaluation](../../evaluations/2026-07-22-optimized-adaptive-router.md).

Failed driver setup, authentication, rate limits, or incomplete tasks are reported separately from model behavior and excluded from performance claims.

## Non-goals

- No change to the 12-skill runtime inventory.
- No restoration of bundle-owned delegation or implementation-log skills.
- No per-model behavioral forks.
- No installation into user skill directories during evaluation.
