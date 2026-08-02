# Architecture

Adaptive Superpowers separates three concerns.

## Shared behavioral core

The root `skills/` tree defines task classification, diagnosis, testing, planning, project-state continuity, worktree safety, review, verification, and delivery behavior. These rules should remain invariant across capable coding models.

The router uses two stages. `skills/using-superpowers/SKILL.md` is a compact, always-triggered gate. It directly handles read-only requests, bounded-agent ownership, and precise low-risk implementations, including retained automated coverage and targeted verification. If any fast-path predicate fails or scope grows, the gate requires `skills/using-superpowers/references/full-router.md` before implementation or consequential action. The reference owns detailed tiers, dynamic planning, named risks, authorization, and broader evidence rules.

Implementation completion follows one shared lifecycle: technical verification, one proportional final review for omissions and material recommendations, then evidence-backed completion. Fast and mechanical work can use a bounded implementer review; material work uses a fresh reviewer when available. Material plan execution, concurrent or resumable implementation, and editing delegation require an isolated worktree unless the current checkout already provides it. Live repository identity is revalidated after resume and before mutations or branch operations, so stale context cannot silently cross feature histories. Branch delivery follows only after this gate and only with user or repository authority.

Persistent goals add a goal contract rather than a new workflow: accepted outcomes, automatic-execution boundary, verification cadence, and stop condition live in the governing plan or canonical project record. A clear stopping point is inferred from accepted evidence; the agent asks only when materially different interpretations would change scope. One plan governs the authorized workstream. Focused checks guide edits; broader suites and reviews run at coherent boundaries, with unchanged evidence reused.

`skills/managing-project-state/SKILL.md` conditionally owns durable continuity for material, resumable, persistent, or already tracked work. It follows an existing canonical record by default and creates no bookkeeping for routine isolated work. Its state model protects queued, active, blocked, and future-watch obligations; keeps implementation, test, commit, push, merge, deployment, and runtime evidence distinct; and archives detail only when retention has operational value. After compaction, live source, Git, and the canonical record identify the first unfinished outcome. Temporary execution state may support recovery but never becomes another project ledger.

Repository instructions remain a separate truth layer within that ownership boundary. Root and nested `AGENTS.md` files hold durable repository facts, safety rules, and canonical pointers; thin host files hold host-specific deltas. Progress and completed history do not flow into instructions. An optional managed profile supplies deterministic structural and Git-range checks without claiming that CI can prove semantic authority.

## Host adapters

Codex and Claude Code discover skills differently. Root plugin manifests, the Claude session-start hook, and `scripts/stage-adapter.sh` translate those mechanics without restating behavioral policy. Claude SessionStart injects only the small shared gate; Codex discovers the same gate through skill metadata. A complete stage is created only at a new path, so stale or fork-only skills cannot survive an update.

## Model profiles

No model-specific behavioral overrides ship initially. A profile is justified only after repeated runs show that one model violates a shared contract while the other targets follow it. Host limitations belong in adapters; universal failures belong in the shared core.

## Deliberate omissions

The bundle does not ship mandatory parallel-agent or subagent-driven workflows. The shared gate permits one bounded read-only explorer when an independent investigation would otherwise pollute the parent context; the host still owns agent availability, model selection, and orchestration. Coupled work and decisions stay with the parent. The bundle also omits the browser visual companion until its project-state files are written without following untrusted symlinks and that behavior is covered by tests.
