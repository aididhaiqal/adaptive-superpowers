# Optimized Adaptive Router Evaluation

**Candidate commit:** `0c3ca8a`  
**Verdict:** Retain as the optimized Adaptive candidate; do not merge into `main` yet.

## Candidate

The final candidate keeps `using-superpowers` mandatory with a 150-word entry file. Precise low-risk implementations use three task batches after the Codex skill read:

1. inspect instructions, relevant file contents, conventions, and repository status;
2. write the implementation and retained runnable test together; and
3. run targeted verification and inspect the diff, repairing and repeating this batch when verification fails.

Detailed tier and high-risk policy lives in `skills/using-superpowers/references/full-router.md` and is loaded only when the fast-path predicate fails. Strict TDD no longer auto-triggers merely because a cheap test is possible. The host-required skill announcement is the only pre-work update; explicit acceptance is not restated.

## Method

- Exact greeting prompt from `adaptive-feature-retains-test`.
- Sol, Opus 4.8, and Fable 5 at max effort.
- Fresh Git task repository for every sample.
- Task workspaces created under `/tmp` so parent repository instructions cannot leak into the run.
- Isolated Codex and Claude homes with exact staged adapters.
- Retention scored by the presence of a runnable JavaScript test, an independent passing run, and removal of `.trim()` in a disposable mutation copy.
- Wall time measured with `/usr/bin/time -p`.

Driver failures are excluded. One early Codex cell had an enabled marketplace but no installed plugin cache. Two early Claude cells used an expired credential snapshot. Two early Sol cells ran inside the Adaptive worktree and could discover its parent `AGENTS.md`; they are not timing evidence.

## Final Sol matrix

| Sample | Retained effective test | Time | Codex tool batches | Visible agent messages |
| --- | ---: | ---: | ---: | ---: |
| 1 | Yes | 112.03s | 6 | 2 |
| 2 | Yes | 67.51s | 6 | 2 |
| 3 | Yes | 73.86s | 4 | 2 |
| 4 | Yes | 62.63s | 5 | 2 |
| 5 | Yes | 105.63s | 5 | 2 |

Sol result:

- Retention: **5/5**
- Median time: **73.86s**
- Tool-batch range: **4-6**
- Median tokens: 100,673 input; 82,432 cached input; 2,807 output; 1,328 reasoning output

The candidate meets retention and used five or fewer tool batches in three of five samples. It misses the release requirement of a Sol median under 60 seconds.

## Claude evidence

The preceding V3 candidate, which differed only by one redundant pre-work acceptance update, completed the full matrix:

| Model | Retained test | Median time | Median reported cost |
| --- | ---: | ---: | ---: |
| Opus 4.8 | 3/3 | 55.91s | $0.279436 |
| Fable 5 | 3/3 | 58.30s | $0.617506 |

Current V4 smoke results also retained effective tests:

| Model | Retained test | Time | Reported cost |
| --- | ---: | ---: | ---: |
| Opus 4.8 | 1/1 | 87.94s | $0.392559 |
| Fable 5 | 1/1 | 36.43s | $0.519309 |

### Hardened V4 Claude matrix

Three fresh samples per model used the 150-word gate through the Claude SessionStart hook at max effort:

| Model | Retained effective test | Median | Range | Median reported cost | Visible text blocks |
| --- | ---: | ---: | ---: | ---: | ---: |
| Opus 4.8 | 3/3 | 63.36s | 57.54-63.54s | $0.306347 | 5-6 |
| Fable 5 | 3/3 | 70.50s | 62.33-84.20s | $0.659776 | 3 |

All six workspaces passed independent `node --test` verification. Removing `.trim()` from one disposable Opus copy and one Fable copy made each retained test fail. Several runs first invoked `node --test test/`, which Node 22 rejected; the new repair clause correctly kept the model in batch 3 until the explicit test-file invocation passed.

The quality contract passed, but the communication contract did not fully converge. Opus narrated conventions and batch transitions in all three runs; Fable emitted a routine batch-3 update in all three. These are materially leaner than the original workflow chain, but only Codex consistently reached the intended two-message shape. Treat reduced Claude chatter as the remaining optimization target rather than adding more shared policy text without a tested wording change.

## Mutation result

One retained V4 test from each model was run against a copy with `.trim()` removed:

| Model | Baseline | Mutation | Restored |
| --- | ---: | ---: | ---: |
| Sol | Pass | Fail | Pass |
| Opus 4.8 | Pass | Fail | Pass |
| Fable 5 | Pass | Fail | Pass |

The retained files protect the requested whitespace behavior; they are not ceremonial tests.

## Fast-mode follow-up

Codex Fast mode was enabled with `service_tier="fast"` and `features.fast_mode=true` while keeping max reasoning effort. Fast mode consumes GPT-5.6 ChatGPT credits at 2.5 times the Standard rate.

| Model | Candidate | Retained effective test | Median | Range | Tool batches | Visible messages |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| Sol Fast | Original V4 gate | 5/5 | 55.47s | 44.39-68.26s | 4-5 | 2 |
| Terra Fast | Hardened 150-word gate | 5/5 | 52.17s | 48.36-58.57s | 4-7 | 2 |

The final Terra samples explicitly preinstalled marketplace commit `172f8f3` before the timed model process. Every trace used `gpt-5.6-terra` at max effort, read `using-superpowers` first, retained a runnable JavaScript test, and passed independent verification. Removing `.trim()` from one disposable copy made the retained test fail.

Two Terra setup cohorts are excluded:

- Samples 1-5 checked out stale marketplace commit `e62e9bb`; they are original-V4 evidence, not hardened-candidate evidence.
- Samples 6-10 downloaded the renamed marketplace during the timed Codex invocation, after the session skill inventory was built. They never read the gate and retained no tests. Their 24.13-27.03s timings are driver failures, not performance wins.

Terra Fast was 3.30 seconds faster than Sol Fast at the median in this synthetic task, but its 4-7 tool-batch range still misses the existing expectation of normally no more than five. Fast mode improves wall time at higher credit consumption; it does not replace Standard-mode acceptance or broader behavioral scenarios.

## Historical comparison

| Variant | Sol retained test | Representative time | Trace size |
| --- | ---: | ---: | ---: |
| No plugin | No | 35.30s | 3 command batches |
| Description-only Minimal Guardrail | 2/3 | 44.47s median | 3-4 tool batches |
| Current Adaptive | Yes | 81.26-126.25s | 12-18 command batches |
| Optimized Adaptive V4 | 5/5 | 73.86s median | 4-6 tool batches |

The optimized candidate removes most visible workflow overhead and recovers reliable retention, but max-effort Sol wall time remains variable and materially above the no-plugin control.

## Decision

Do not add more shared policy text. The remaining fixed Codex cost includes a mandatory skill-read round trip. Codex plugin manifests do not support plugin-level prompt injection or hooks, while Claude can inject the same gate through SessionStart. Removing the Codex read would require host/global configuration mutation, policy duplication in task repositories, or a future Codex plugin capability.

Keep the candidate branch for further evaluation. Merge only after either:

- a native Codex injection mechanism removes the mandatory read; or
- repeated product work shows that the 73.86-second synthetic median is acceptable and the release threshold is intentionally revised.
