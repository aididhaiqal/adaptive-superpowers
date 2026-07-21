# Architecture

Adaptive Superpowers separates three concerns.

## Shared behavioral core

The root `skills/` tree defines task classification, diagnosis, testing, planning, worktree safety, review, verification, and delivery behavior. These rules should remain invariant across capable coding models.

## Host adapters

Codex and Claude Code discover skills differently. Root plugin manifests, the Claude session-start hook, and `scripts/stage-adapter.sh` translate those mechanics without restating behavioral policy. A complete stage is created only at a new path, so stale or fork-only skills cannot survive an update.

## Model profiles

No model-specific behavioral overrides ship initially. A profile is justified only after repeated runs show that one model violates a shared contract while the other targets follow it. Host limitations belong in adapters; universal failures belong in the shared core.

## Deliberate omissions

The bundle does not ship custom parallel-agent or subagent-driven workflows because delegation is host- and policy-dependent. It also omits the browser visual companion until its project-state files are written without following untrusted symlinks and that behavior is covered by tests.
