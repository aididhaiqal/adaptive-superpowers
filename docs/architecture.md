# Architecture

Adaptive Superpowers separates three concerns.

## Shared behavioral core

The root `skills/` tree defines task classification, diagnosis, testing, planning, worktree safety, review, verification, and delivery behavior. These rules should remain invariant across capable coding models.

The router uses two stages. `skills/using-superpowers/SKILL.md` is an always-triggered gate capped at 150 words. It directly handles read-only requests and precise low-risk implementations, including retained automated coverage and targeted verification. If any fast-path predicate fails or scope grows, the gate requires `skills/using-superpowers/references/full-router.md` before implementation or consequential action. The reference owns detailed tiers, named risks, authorization, and broader evidence rules.

Implementation completion follows one shared lifecycle: technical verification, one proportional final review for omissions and material recommendations, then evidence-backed completion. Fast and mechanical work can use a bounded implementer review; material work uses a fresh reviewer when available. Branch delivery follows only after this gate and only with user or repository authority.

## Host adapters

Codex and Claude Code discover skills differently. Root plugin manifests, the Claude session-start hook, and `scripts/stage-adapter.sh` translate those mechanics without restating behavioral policy. Claude SessionStart injects only the small shared gate; Codex discovers the same gate through skill metadata. A complete stage is created only at a new path, so stale or fork-only skills cannot survive an update.

## Model profiles

No model-specific behavioral overrides ship initially. A profile is justified only after repeated runs show that one model violates a shared contract while the other targets follow it. Host limitations belong in adapters; universal failures belong in the shared core.

## Deliberate omissions

The bundle does not ship mandatory parallel-agent or subagent-driven workflows. The shared gate permits one bounded read-only explorer when an independent investigation would otherwise pollute the parent context; the host still owns agent availability, model selection, and orchestration. Coupled work and decisions stay with the parent. The bundle also omits the browser visual companion until its project-state files are written without following untrusted symlinks and that behavior is covered by tests.
