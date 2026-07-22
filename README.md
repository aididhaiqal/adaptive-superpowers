# Adaptive Superpowers

Risk-adaptive engineering workflows for capable coding models.

Adaptive Superpowers sits between two extremes:

- **Model autonomy alone:** fast, but important testing or safety steps may be inconsistent.
- **Official Superpowers:** strong discipline, but fixed workflow chains can add planning, approval, delegation, and verification overhead to small tasks.

This project defines a mandatory engineering baseline and allows the model to add process only when task evidence or risk justifies it. A 145-word gate is always loaded; detailed routing policy is loaded only when a task is not precise and low-risk.

> **Status:** experimental and under evaluation. The repository is not an official obra/superpowers distribution and is not ready to replace an installed plugin yet.

## The idea in one table

| Model autonomy alone | Adaptive Superpowers | Official Superpowers |
| --- | --- | --- |
| Model chooses nearly everything | Policy fixes the minimum; model chooses proportional extras | Applicable workflows are mandatory |
| Fast but variable | Fast for precise work, stricter for risky work | Consistent but process-heavy |
| Tests may be skipped | Observable behavior normally retains automated coverage | Strict test-first workflow |
| Host behavior is implicit | Host adapters are explicit | Multi-host package with custom workflows |
| Review may be self-review without disclosure | Independence is named honestly | Fresh-agent review is central |

## What remains mandatory

The model does not receive unlimited discretion. Every task is classified into the highest applicable tier:

| Tier | Required behavior |
| --- | --- |
| Read-only | Inspect and report without implementation artifacts or external mutation. |
| Mechanical | Inspect, make a provably non-behavioral edit, run a narrow check, review the diff, report. |
| Standard | State a brief plan and acceptance, implement narrowly, add or update automated coverage for observable behavior changes unless infeasible, run focused checks, review the diff, report evidence. |
| High-risk | Follow Standard and add a durable plan plus explicit claim-to-evidence verification before consequential action. |

The model may decide whether brainstorming, strict red-green TDD, a worktree, independent review, or delegation adds value. It may not skip authorization boundaries, dirty-worktree protection, applicable automated coverage, or evidence-backed completion.

## Same request, different workflow

Request:

> Add CSV export to the existing report page.

Official Superpowers can route this through brainstorming, multiple approaches, design approval, a committed specification, detailed planning, test-first implementation, review, and a separate completion gate.

Adaptive Superpowers normally does this:

1. Inspect existing report and export conventions.
2. Ask only if a material choice remains unresolved.
3. State a short plan in the required skill announcement; do not restate acceptance already explicit in the request.
4. Implement the smallest coherent change and retain an automated CSV behavior test.
5. Run focused checks, inspect the final diff, and report current evidence.

High-risk details still raise the workflow. Exporting sensitive production records, for example, requires a durable plan, target checks, recovery controls, and explicit verification.

## Shared core, host adapters, model profiles

```text
skills/                 mandatory gate, conditional router, and shared behavior policy
.codex-plugin/          Codex discovery metadata
.claude-plugin/         Claude Code discovery metadata
hooks/                  Claude Code router bootstrap
adapters/               host-specific operating notes
profiles/               initially no model-specific overrides
tests/                  static, packaging, and behavioral contracts
```

The 12 shared skills contain no required bundle-owned subagent workflow. `using-superpowers/SKILL.md` is the always-triggered cross-host gate, while its `references/full-router.md` is read only when the fast-path predicate fails or scope grows. Native delegation is used only when the host exposes it, current policy permits it, and the task benefits from it.

Target evaluation models:

- Codex with **GPT-5.6 Sol**
- Claude Code with **Claude Opus 4.8**
- Claude Code with **Claude Fable 5**

Fable uses the Claude Code adapter with `--model claude-fable-5`; it is not a separate host integration. Model profiles remain empty until repeated evidence demonstrates a model-specific failure.

## Safety decisions

- Review-only and diagnosis-only requests remain read-only.
- Destructive and externally visible actions require authority.
- Fresh verification evidence is reused when relevant state has not changed.
- A self-review is never described as independent review.
- Staging refuses to overlay an existing destination, preventing hybrid skill sets.
- The inherited browser visual companion is intentionally omitted until its state-file writes reject symlink targets and have automated security coverage.

## Local development

Run all repository checks:

```bash
bash tests/run-all.sh
```

Validate the skill profile and packaging metadata:

```bash
bash scripts/validate.sh
```

Create a clean isolated adapter tree:

```bash
bash scripts/stage-adapter.sh codex /tmp/adaptive-superpowers-codex
bash scripts/stage-adapter.sh claude /tmp/adaptive-superpowers-claude
```

The staging command refuses an existing destination. It never writes to installed skills or user configuration.

Claude Code can load a staged Claude adapter for a single run:

```bash
claude --plugin-dir /tmp/adaptive-superpowers-claude --model claude-opus-4-8
```

Codex installation and marketplace publication remain intentionally undocumented until isolated adapter and behavior evaluations pass.

## Evaluation policy

The candidate is tested before comparison with the baselines. Initial scenarios cover:

- fully specified small work without unnecessary ceremony;
- a behavior-changing feature that must retain a runnable test;
- a confirmed bug that must retain a regression test;
- diagnosis-only and review-only non-mutation;
- dirty-worktree preservation;
- unavailable delegation;
- evidence-backed completion.

Unavailable model access, expired credentials, and rate limits are reported as indeterminate rather than behavioral failures. Raw trajectories remain local.

See [Architecture](docs/architecture.md) and [Evaluation](docs/evaluation.md).

## Provenance and license

Adaptive Superpowers is derived from MIT-licensed [obra/superpowers](https://github.com/obra/superpowers) and incorporates concise policy ideas from [eagleagentic/superpowers-gpt-5.6](https://github.com/eagleagentic/superpowers-gpt-5.6).

The initial audit and implementation are pinned to:

- official Superpowers 6.1.1: `d884ae04edebef577e82ff7c4e143debd0bbec99`
- GPT-5.6 fork: `aa973775906c8761a78019aaa21e4f0ccd987925`
- Superpowers eval harness: `58aaf6d118e4249eb0c9803e9f9d7df133b7639a`

Distributed under the [MIT License](LICENSE). “Superpowers” remains associated with its original project and authors; this experimental adaptation is not endorsed by them.
