# Managing Project State Implementation Plan

**Status:** Locally implemented and verified; cross-model release evaluation pending.

**Goal:** Add `managing-project-state` as the thirteenth Adaptive Superpowers runtime skill, migrate durable-state ownership without weakening current persistent-goal contracts, and retain proportional no-churn behavior for routine work.

**Acceptance:** Follow the approved design in `docs/superpowers/specs/2026-08-02-managing-project-state-design.md`. Keep one canonical ledger, protect unresolved commitments, distinguish delivery evidence, archive only qualifying detail, preserve direct fast-path reconciliation, keep the gate within 450 words if clear wording fits, and keep the 13-skill bundle within 4,400 runtime words.

## Outcome 1: Runtime ownership and routing

**Files:** `skills/managing-project-state/`, `skills/using-superpowers/`, lifecycle skills, static contracts.

**Verify:** `bash tests/static/test-project-state-management.sh` and affected router/completion contracts.

## Outcome 2: Deterministic validation and scenarios

**Files:** `audit_project_state.py`, auditor tests, convention/managed fixtures, paired evaluation scenarios.

**Verify:** Auditor unit contracts and `bash tests/evals/test-scenarios.sh`.

## Outcome 3: Repository integration

**Files:** Inventory validation, adapters, README, architecture, evaluation, changelog, and canonical progress.

**Verify:** `bash tests/run-all.sh`, Claude plugin validation, staged adapters, and `git diff --check`.

## Delivery boundary

Implementation and local verification are authorized. Commit, push, installation, release, Atlas mutation, and live cross-model forward tests require separate authority or an independently applicable repository workflow.
