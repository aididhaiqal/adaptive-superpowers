# Optimized Adaptive Router Evaluation

**Candidate commit:** `0c3ca8a`  
**Verdict:** Retain as the optimized Adaptive candidate; do not merge into `main` yet.

## Candidate

The final candidate keeps `using-superpowers` mandatory but reduces its entry file to 147 words. Precise low-risk implementations use three task batches after the Codex skill read:

1. inspect instructions, relevant file contents, conventions, and repository status;
2. write the implementation and retained runnable test together; and
3. run targeted verification and inspect the diff.

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

The candidate meets retention and normally stays at five or fewer tool batches. It misses the release requirement of a Sol median under 60 seconds.

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

## Mutation result

One retained V4 test from each model was run against a copy with `.trim()` removed:

| Model | Baseline | Mutation | Restored |
| --- | ---: | ---: | ---: |
| Sol | Pass | Fail | Pass |
| Opus 4.8 | Pass | Fail | Pass |
| Fable 5 | Pass | Fail | Pass |

The retained files protect the requested whitespace behavior; they are not ceremonial tests.

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
