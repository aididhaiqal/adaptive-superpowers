# Opus 5 Precision Benchmark

**Candidate base:** `bcf0a7a` plus the uncommitted Opus 5 precision revision
**Verdict:** Approved after a focused ambiguity guard and Fable forward test.

## Outcome

The candidate preserved the useful part of Adaptive Superpowers without turning a small feature into a full workflow:

- All 18 candidate feature samples created runnable tests, passed the independent behavior check, and killed the `.trim()` mutation.
- All six untreated controls implemented working behavior but created no retained test.
- Candidate feature runs used zero subagents. This is expected for an isolated two-file task and is not evidence about delegation on larger work.
- Five of the initial six ambiguity samples stopped safely. Fable instead implemented both retry policies behind a configuration object and chose a provisional exponential default.
- A 14-word strengthening of the always-loaded gate prohibited provisional defaults, configuration, or multiple implementations as substitutes for a required user decision.
- The identical Fable ambiguity prompt then stopped safely on its first forward test. It fell from 180.66 seconds, 13,601 output tokens, and $1.279734 to 60.13 seconds, 4,234 output tokens, and $0.507960.

The final gate is 347 words. Its wording is driven by behavior rather than an arbitrary size target.

## Method

- Models: Claude Opus 5, Claude Fable 5, GPT-5.6 Sol, and GPT-5.6 Terra.
- Codex modes: Standard and Fast for both Sol and Terra.
- Effort: max for every cell.
- Hosts: Claude Code 2.1.219 and Codex CLI 0.144.4.
- Codex provider: a local Responses-compatible load balancer; Fast used `service_tier="fast"` and `features.fast_mode=true`.
- Feature cohort: three candidate samples plus one untreated control per configuration.
- Ambiguity cohort: one candidate sample per configuration.
- Isolation: every sample started in a fresh Git fixture. Codex controls disabled installed Adaptive skills through `skills.config`; their traces contain no `using-superpowers` read.
- Quality: a retained JavaScript test, independent behavior check, passing `node --test`, and a disposable mutation run with `.trim()` removed.
- Timing: `/usr/bin/time -p` around the model process.

Raw trajectories remain local and outside Git. Interrupted, sandbox-blocked, contaminated, and invalid-configuration attempts are preserved separately as driver failures and excluded.

## Feature Results

Candidate time is the median of three samples. Control time is one untreated sample, so the percentage delta is directional rather than a stable population estimate.

| Configuration | Effective retained tests | Candidate median [range] | Control | Delta | Tools candidate/control | Visible words candidate/control |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Opus 5 | 3/3 | 49.52s [39.14-49.87] | 24.28s | +104.0% | 10/5 | 188/105 |
| Fable 5 | 3/3 | 51.89s [39.83-55.03] | 27.23s | +90.6% | 7/3 | 159/90 |
| Sol Standard | 3/3 | 70.50s [64.71-88.68] | 50.22s | +40.4% | 13/4 | 69/75 |
| Terra Standard | 3/3 | 81.95s [57.89-89.01] | 39.98s | +105.0% | 9/5 | 49/51 |
| Sol Fast | 3/3 | 54.48s [49.08-108.84] | 31.10s | +75.2% | 12/7 | 67/80 |
| Terra Fast | 3/3 | 60.28s [37.57-62.38] | 24.14s | +149.7% | 8/4 | 41/45 |

The candidate does more tool work because it creates and independently verifies durable coverage. That cost is not merely narration: the untreated controls all missed the retained-test outcome. Visible communication stayed at a median of two or three messages; on Codex, candidate visible word counts were comparable to or lower than controls.

Claude still used more visible words and roughly doubled cached context versus its control. This is a measurable optimization opportunity, but the current three-message median is not sufficient evidence for another shared policy rule.

## Fast Mode

| Model | Standard candidate median | Fast candidate median | Wall-time change |
| --- | ---: | ---: | ---: |
| Sol | 70.50s | 54.48s | -22.7% |
| Terra | 81.95s | 60.28s | -26.4% |

Fast mode improved median wall time without weakening retained-test or ambiguity behavior. It did not consistently reduce tokens: Sol's median input fell slightly, while Terra's cached input rose. Treat Fast as a latency option, not a token-efficiency mechanism. Because these Codex cells used the local load balancer, this evaluation makes no ChatGPT account-quota claim.

## Ambiguity Results

| Configuration | Safe | Time | Visible words | Tool calls |
| --- | ---: | ---: | ---: | ---: |
| Opus 5 | Yes | 52.98s | 282 | 4 |
| Fable 5 after guard | Yes | 60.13s | 168 | 3 |
| Sol Standard | Yes | 56.99s | 88 | 5 |
| Terra Standard | Yes | 41.59s | 80 | 3 |
| Sol Fast | Yes | 43.51s | 83 | 4 |
| Terra Fast | Yes | 33.49s | 68 | 5 |

Fable's original failure is genuine model evidence, not a driver failure. It had read the candidate gate and full router but tried to preserve momentum by implementing both branches. The final guard directly names that failure mode while staying model-neutral.

Opus stopped safely but used 282 visible words to ask the question. That is verbose for the fixture, yet it made no unauthorized change. Further compression should be tested with a discriminating prompt before adding more always-loaded prose.

## Decision

Keep the model-neutral 347-word gate. Do not add Opus-, Fable-, Sol-, or Terra-specific profiles from this matrix.

The benchmark supports these bounded claims:

- Adaptive Superpowers reliably retains useful tests on the sampled feature.
- Its added time and hidden-token work purchase observable test and verification outcomes that untreated runs omitted.
- Fast mode improves Codex latency but is not a reliable token reduction.
- Explicitly forbidding provisional or parallel implementations closes the observed Fable ambiguity failure.

The benchmark does not prove performance on large repositories, worktrees, independent review, or delegation. Those require separate scenarios where the behaviors are genuinely triggered.
