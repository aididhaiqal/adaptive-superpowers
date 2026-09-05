# Native host integration study

Checked 2026-09-05 against official OpenAI and Claude Code documentation, installed Claude Code 2.1.260 help and a local availability check, and this repository. This is a study, not authorization to install, publish, run paid evaluations, or change host settings.

## Recommendation

Keep one shared behavioral core. Use native packaging, discovery, agent roles, and lifecycle signals to deliver and observe it; do not build another agent orchestrator.

The first approved follow-up adds Codex presentation metadata and an on-demand installation-consistency checker to the source tree. It does not update installations or activate more policy. Claude's native plugin evaluation runner is promising, but the installed CLI blocks even blank-template creation behind an early-access gate. Keep the current fixtures usable independently; do not make that runner a prerequisite. Additional runtime hooks should remain opt-in and prove their benefit first.

A later explicit request includes the existing Claude startup hook's Windows dispatch repair in the combined local commit. This changes shell selection and launch/error handling, not the startup matcher or router payload, and does not add another lifecycle hook. Codex's explicit empty-hooks configuration remains unchanged. POSIX tests pass; native Windows tests are retained but unverified. No installation is updated by the source commit.

| Need | Verified native mechanism | Adaptive fit |
| --- | --- | --- |
| Package and update shared skills | Codex plugin manifest and marketplaces; Claude plugin install/update and session-only `--plugin-dir` | Keep the two host manifests pointing at the same skills. Align revision/version before comparing models. |
| Clear skill discovery | Codex `agents/openai.yaml` interface and invocation policy | All 13 source skills now have concise UI metadata; implicit invocation and existing project-state metadata are preserved. Installation is separate. |
| Specialized delegation | Codex standalone custom-agent TOML; Claude plugin `agents/`, `--agents`, and selective `skills` preloading | Optional host-native roles, not another SDD workflow. Keep model/effort selection host-configurable and avoid preloading the whole bundle. |
| Recover after compaction | Codex `SessionStart` with `compact`/`resume` sources and `PreCompact`/`PostCompact` events | Consider an optional short canonical-record pointer, never replay the full ledger or duplicate the router. |
| Verify plugin use | Claude `plugin details`, `--include-hook-events`, and stream-json output | Capture actual hook/skill activity in local evaluations instead of inferring activation from installed inventory. |
| Compare with no plugin | Claude `plugin eval` help lists with/without ablation, model choice, repeated runs, and graders; local use is early-access gated | Retain our independent fixtures. Pilot the native runner only after access and its case/grader schema are verified. |
| Task-owned isolation | Claude `--worktree`; Codex host-managed workspaces and our Git fallback | Prefer native isolation only when it preserves the original checkout and satisfies task ownership/base checks. |

## Codex: confirmed details

Sources:

- [Build skills: optional metadata](https://learn.chatgpt.com/docs/build-skills#optional-metadata)
- [Native subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents)
- [Hooks](https://learn.chatgpt.com/docs/hooks)
- [Plugin packaging](https://developers.openai.com/plugins/build/plugins)

### Metadata and roles

`agents/openai.yaml` supports display names, descriptions, starter prompts, invocation policy, and MCP dependencies. `allow_implicit_invocation` defaults to true; setting it false would be inappropriate for our automatically selected router. Do not add tool dependencies that the workflow does not actually require.

The approved metadata follow-up adds only display names and short descriptions to the 12 skills that lacked them. Existing `managing-project-state` metadata, including its starter prompt, is unchanged. No runtime `SKILL.md` instructions or model/effort settings were changed by this follow-up.

Current local Codex documentation allows delegation through direct user requests or applicable project/skill instructions. Custom roles live in `~/.codex/agents/` or project `.codex/agents/`, with name, description, and developer instructions. Model/effort and sandbox choices are host configuration, not intrinsic skill behavior. The documentation does not establish that arbitrary role files inside a plugin are automatically installed as global roles; do not assume that packaging path.

The existing Terra/Sol examples are optional profiles. Astra, Sol, Fable, and Opus do not need separate copies of the engineering rules. Runtime tool contracts, configured roles, and actual model availability override stale examples.

### Hooks: useful but not a free safety layer

Codex supports SessionStart, SubagentStart/Stop, tool events, compaction events, Stop, and other lifecycle events. Non-managed hooks must be reviewed and trusted; changed definitions need fresh trust. Matching hooks accumulate and command hooks can run concurrently. Tool coverage has exceptions, so hooks are not a complete enforcement boundary.

An important existing safeguard: our Codex manifest explicitly sets `"hooks": {}`. Codex otherwise discovers a default `hooks/hooks.json`, and it supplies Claude-compatible plugin-root environment variables. Keep that explicit empty configuration until a Codex hook is intentionally designed and evaluated; do not accidentally enable the Claude bootstrap twice.

If piloting recovery hooks, emit only the governing-record path, task identity, and a short revalidation reminder. Use the native SessionStart compact/resume signal; do not reconstruct the entire conversation or create a second ledger. Never run a full test suite after every tool call or unconditionally turn Stop into another implementation cycle.

## Claude: documented integration, gated native evaluation

Primary sources fetched:

- [Skills: frontmatter, lifecycle, and forked execution](https://code.claude.com/docs/en/skills)
- [Subagents: configuration, startup context, and nesting](https://code.claude.com/docs/en/sub-agents)
- [Plugins reference: agent components and loading](https://code.claude.com/docs/en/plugins-reference)

The previous documentation-access blocker is resolved. These pages establish skill and agent formats; they do not document the native eval case/grader schema in the inspected sections. Eval capabilities below come from installed CLI help and the availability check, not assumed account access.

Commands inspected:

- `claude --version`: 2.1.260
- `claude --help`
- `claude plugin --help`
- `claude plugin eval --help`
- `claude plugin eval init --help`
- `claude plugin validate --help`

### Native evaluation: useful capability, unavailable in this check

`claude plugin eval` accepts a plugin path or installed plugin identity. It supports:

- no-plugin baseline ablation (`--ablation with-without`);
- model selection and repeated cases (`--model`, `--runs`);
- case/tag filters, thresholds, and JSON/HTML reports;
- optional scaffold scripts and explicit tool grants;
- a cost ceiling, with documented possible overrun by one agent run;
- hook/skill-aware evaluation, without treating a plugin-only invocation indicator as an unfair baseline score penalty.

Reports can publish to claude.ai by default when supported. Any proposed local run must explicitly set `--no-publish`, keep transcripts/results outside installed skill directories and Git, and inspect tool grants/scaffold scripts first.

Help lists two case layouts: `case.yaml`, or `prompt.md` plus `graders/*.md`. To inspect the native template without a model run, we invoked `claude plugin eval init --bare retained-coverage --eval-dir evals` in a fresh temporary directory. It exited 1 with: **`plugin eval` is currently in early access**. No case files were created and no evaluation or authoring model ran. Do not attempt to bypass the gate. Case/grader fields and scaffold behavior remain unverified; no native eval suite is implemented or promised ready.

### Integrate selectively, not by injecting more policy

1. **Keep routing in the main conversation.** Claude's `context: fork` turns a skill into a separate task; it is not a general context-saving switch. The forked skill does not see conversation history and needs a concrete task. Do not put it on `using-superpowers`, brainstorming, or project-state management. Our existing parent-owned scope and decision boundaries remain appropriate.
2. **Preload narrowly for optional native roles.** Claude plugin agents can declare `skills`, which injects full skill content at startup. Ordinary subagents do not inherit the parent's invoked skills; forks are the exception. Built-in Explore and Plan also omit CLAUDE.md and the Git-status snapshot. Pass binding repository constraints in the handoff rather than assuming inheritance. Do not preload all 13 skills or make a reviewer restart the parent review-dispatch workflow.
3. **Leave model and effort with the host/user.** Skills and agents can override both, but fixed frontmatter could override Ultra/Ultracode or the user's chosen model. Use host-configurable role choices and session inheritance unless the user intentionally opts into a profile. Native depth/concurrency limits vary by host/version; do not reproduce them as skill limits.
4. **Preserve actual permission boundaries.** Plugin agents support `tools` and `disallowedTools`, but ignore `permissionMode`, `hooks`, and `mcpServers` frontmatter. Excluding Write/Edit alone does not make an agent read-only if unrestricted shell or mutating MCP tools remain. Define the role and usable tool surface deliberately; policy text is not an operating-system sandbox.
5. **Do not duplicate native skill retention.** Claude keeps invoked skill content across turns, deduplicates identical re-invocations, and carries recent skills through compaction within documented budgets. This reduces the case for adding another large recovery hook. Reference-file reads and every old instruction are not promised the same treatment. A compact canonical-record pointer may still be worth testing, but not replaying the whole ledger or bundle.

These findings support the current conditional references and bounded handoffs. Native role packaging is an optional adapter improvement, not a new runtime skill or separate model policy.

### Native loading and observability

`--plugin-dir` supports a directory or zip for one session. Installed CLI help requires restart after `plugin update`. Official docs separately describe live `SKILL.md` change detection for watched skill directories and `/reload-plugins` for other skills-directory plugin components. Do not assume those paths replace old instructions already present in a resumed session. `--include-hook-events` and `--forward-subagent-text` can expose lifecycle and child activity in stream-json output; these offer a better activation check than asking the model whether it used the plugin.

`--agents`, `--agent`, `--worktree`, and `--resume` support host-owned roles, isolation, and continuation. The help lists Fable and Opus as model selections on the same host. It also warns that system-prompt snapshots can retain earlier prompting across resumes. Test fresh start, resume, clear, and compaction explicitly rather than assuming a plugin update replaces every old instruction immediately. Claude agent `isolation: worktree` defaults to branching from the configured default branch, not necessarily the parent HEAD, and automatic cleanup is documented only for unchanged worktrees; retain Adaptive's base/ownership and disposition checks.

Avoid `--safe-mode` as a candidate test: it disables skills/plugins/hooks. `--bare` also changes loading and authentication behavior, so it is not an equivalent baseline unless the experiment is specifically about those differences.

Both the existing marketplace manifest and plugin manifest passed native `claude plugin validate --json` with zero errors/warnings. Those reports had empty contents arrays; they establish manifest validity, not runtime skill behavior.

## Recommended next milestones

1. The resumed candidate execution probe passes its independent checker and independent source review found no policy/test blockers. Preserve broader validation obligations and reconcile the older staged draft before any separately authorized integration. See [validation evidence](evaluations/2026-09-05-model-refinement-probe.md).
2. Presentation metadata and the read-only checker are implemented locally following approval. Use `scripts/check-installation.py` on demand to compare the selected installed files and version labels; same-version content drift remains visible. Its Codex default covers user skill links, and Claude v2 registry discovery is best-effort with explicit path overrides. Enablement, shadowing, and active-session state remain outside its evidence. Deployment and narrowly scoped native role packaging are separate decisions.
3. When Claude native eval access is available, verify its case/grader schema and propose a small local-only evaluation using the existing fixtures. Until then use the existing independent evaluation path only with authorization for model runs.
4. Evaluate recovery/activation hooks separately. No blanket Stop gate, permanent per-tool logging, automatic full-suite runner, or new global agent limits.

The Windows-hook intent from the older staged upstream-adoption draft is now selectively incorporated following explicit approval. Preserve that old worktree unchanged: its broader testing-reference rewrite and other proposed workflow changes were not imported wholesale, and native Windows checks remain outstanding. Neither this study nor the combined local commit authorizes deleting it.
