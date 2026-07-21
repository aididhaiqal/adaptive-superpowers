# Cross-model sentinel evaluation — 2026-07-21

## Verdict

The candidate retained runnable automated coverage for both a new behavior and a confirmed regression on GPT-5.6 Sol, Claude Opus 4.8, and Claude Fable 5.

This is evidence for the narrow claim that the adaptive router still creates test files without requiring the user to ask. It is not yet evidence that the candidate is broadly faster than official Superpowers or the GPT-5.6 fork; baseline cells and read-only scenarios remain to be run.

## Candidate

- Repository commit before the router revision: `8df3578`
- Candidate state: dirty only because the test-retention revision and this report were under evaluation
- Runtime profile: 12 skills, 2,682 words after the revision
- Codex model: `gpt-5.6-sol`
- Claude models: `claude-opus-4-8` and `claude-fable-5`
- Claude adapter evidence: plugin loaded 12 candidate skills and the SessionStart hook injected the revised router
- Raw trajectories and isolated workspaces remain ignored and local

## Results

| Scenario | Sol | Opus 4.8 | Fable 5 |
|---|---|---|---|
| New greeting behavior retains tests | Pass — 4 tests | Pass — 5 assertions in a runnable test file | Pass — 4 tests |
| Confirmed pricing bug retains regression | Pass — 2 tests | Pass — 3 tests | Pass — 4 tests |
| Independent `node --test` rerun | Pass | Pass | Pass |
| Native delegated-agent calls in clean bug run | 0 | 0 | 0 |

The pricing checks also confirmed that `getDiscountRate('BOGUS')` returns a number, `finalPrice(100, 'BOGUS')` returns `100`, and known discount codes still work.

## Process observations

- Sol reproduced the pricing failure, traced it to the upstream rate lookup, observed a focused regression test fail, fixed the producer, and reran the test green.
- Fable likewise wrote and ran the regression test before changing production code.
- Opus reproduced the failure and retained a verified regression test, but edited production code before creating the test. The final outcome meets the retention contract but not the router's preferred red-before-fix order. This is useful evidence for keeping test retention separate from mandatory TDD.
- Sol and Fable chose slightly different test locations; the contract correctly accepts behavior rather than prescribing directory layout.
- Sol and Opus used an own-property check, protecting rate lookup from inherited property names. Fable used nullish fallback, which meets the scenario but is a narrower fix.

## Economics

These are single samples, not performance distributions.

| Scenario | Model | Duration | Cost | Output tokens |
|---|---|---:|---:|---:|
| Greeting | Sol | not captured | subscription | 1,425 |
| Greeting | Opus 4.8 | 29.384 s | $0.196768 | 1,305 |
| Greeting | Fable 5 | 25.886 s | $0.453712 | 1,543 |
| Pricing bug | Sol | not captured | subscription | 2,466 |
| Pricing bug | Opus 4.8 | 55.732 s | $0.340498 | 3,448 |
| Pricing bug | Fable 5 | 37.142 s | $0.574598 | 2,288 |

The clean Opus bug run used no delegated agent. An earlier sandbox-constrained Opus attempt did invoke one native Explore agent, ran for 251.649 seconds, then could not create Claude Code's session environment or execute tests. That attempt is indeterminate because of the host restriction, not a candidate failure. It nevertheless confirms an important design point: removing subagent-driven workflow skills does not disable a capable model's native delegation, and native delegation can still add substantial overhead.

## Environment limitations

- Full Quorum orchestration is unavailable because `gauntlet` is not installed. Quorum still prepared the isolated Codex homes and workspaces; deterministic checks were rerun independently.
- The first direct Opus bug attempt was blocked by `EPERM` while Claude Code created `.claude/session-env`. A clean rerun outside that filesystem restriction passed.
- No installed Superpowers directory was modified, and no remote repository was created or pushed.

## Next decision gate

Before claiming general readiness or lower overhead:

1. Run diagnosis-only and review-only non-mutation scenarios.
2. Run matched official-Superpowers and GPT-5.6-fork baselines with the same prompts and model versions.
3. Repeat the sentinel cells enough times to measure variance, native delegation frequency, duplicated narration, duration, and token use.
4. Add model-specific policy only if repeated failures cluster by model. The current samples do not justify profiles.
