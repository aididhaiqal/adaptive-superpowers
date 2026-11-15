# Test Owed, Not Feasible

**Candidate:** plugin 0.3.4 (`feat/test-owed-not-feasible`)
**Verdict:** Released. A one-line log wording change stopped attracting a test while a new feature and a confirmed bug still retained theirs.

## Question

The owner found agents writing worthless tests ("a mere unit test that are worthless are annoying sometimes"). Under 0.3.3 the gate's fast path said "When feasible, create or update a runnable automated test file", and the router added "do not ask whether to add it", so feasibility triggered a test and the value gate ran afterwards. A Fable consult (brief `brief-testrule-k7q2`) decided the rule: a test is owed for a credible regression no existing test catches, decided before writing, and `No new test: <reason>` is a complete outcome. An independent Opus review then tightened the router, the retention bar, and the pins.

## Method

- Headless Claude Code, Opus 5.5 at high effort, `--setting-sources project --strict-mcp-config`, one plugin copy per arm via `--plugin-dir`, a fresh Git fixture under the session scratchpad for every run.
- Scenarios: the exact prompts of `adaptive-feature-retains-test` and `adaptive-bug-retains-regression`, and the new `adaptive-log-wording-adds-no-test`.
- Scored from the resulting tree (test files present, `node --test`, the scenario's behavior checks) and the final report. Cost about $0.13 to $0.42 per run.

## Results

| scenario | 0.3.3 | 0.3.4 gate sentence | reviewer's alternative gate sentence |
|---|---|---|---|
| log wording adds no test | 0/2 (both added a log-capturing test and a `test` script) | 9/11 | 0/2 |
| new feature retains a test | not rerun | 2/2 | 1/1 |
| confirmed bug retains a failing-first regression | not rerun | 2/2 | 1/1 |

The 0.3.4 column pools two rounds whose gate text is identical (5/5 and 4/6); no run in either round opened `full-router.md` or `test-value.md`, so the router and reference edits between the rounds did not reach these agents and the difference is sampling noise. The reviewer's gate sentence ("When breaking new or changed behavior would pass existing tests") read a reworded log line as changed behavior and lost the effect, so it was not adopted; its router-side fixes were kept.

A fourth scenario, raising a configured timeout whose only test compared the value with the constant itself, did not discriminate: both arms added a test pinning 10 seconds, and the 0.3.4 run justified it correctly (the existing test would pass if the value went back to 5 seconds). It was dropped.

## Untested

Codex hosts, Fable, and Standard-tier work that reads the router were not run. The new router wording and the retention-bar bullet are covered by review and static contracts only.
