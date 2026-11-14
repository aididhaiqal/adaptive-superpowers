# Delegation Parity Design

**Status:** Requested by the bundle owner on 2026-11-15 ("consider working on the subagents improvement in the skills itself"), after a working draft was proved in a Claude Code project on 2026-11-14. No runtime skill is added; the inventory stays at 14.

## Problem

A parent that dispatches child agents does not reliably give them its own model and effort. On Claude Code, measured from on-the-wire request records:

- `general-purpose` and `Explore` children inherit the parent's pair when nothing is passed (proved under Opus 5.5 high and Fable 5.2 max).
- The built-in `claude-code-guide` type ran on Haiku 5.5 at medium effort under an Opus 5.5 high parent.

So a parent at Fable max can fan out children that quietly run on a smaller model, and nothing in the bundle told it to pass the pair, choose a channel, bound a fan-out, or check what actually ran.

## Decision

One conditional reference, `skills/using-superpowers/references/delegation.md`, owns child-agent dispatch:

- same model and reasoning effort as the parent unless the user names another, passed explicitly on every dispatch, with a small host mapping table (Claude Code `Agent`, T3 Code `delegate_task`, other hosts);
- foreground only for a short lookup the next step needs, background otherwise;
- fan out only independent work, at most six at once unless the user sets a cap, one writer per checkout, reviewers get the code and not the parent's conclusion;
- a brief with a unique marker and a fixed last line;
- no polling; a dispatched parent that ends its turn with children running says so;
- the reported pair comes from the host's record: `scripts/check-children.py` on Claude Code, "requested, not verified" elsewhere.

Every dispatch path reaches it: the gate's delegation rule (one imperative sentence, paid for by shortening five gate sentences without changing their meaning; a descriptive "children get this session's model and effort" was injected and ignored in both forward-test runs), the full router's delegation paragraph, and the explorer handoff.

## Another provider's model (0.3.3)

A model on another provider (a Codex `gpt-6.1-sol` from a Claude session) runs only when the user names it. Its effort option has the provider's own name (`reasoningEffort` for Codex, from `orchestrator_capabilities`). Its default can be `low` (`gpt-6.1-sol` in T3, 2026-11-15), so the child gets this session's level when offered, the nearest offered level otherwise. Codex writes `turn_context` records holding `model` and `effort` to `~/.codex/sessions/**/rollout-*.jsonl`, and a T3-started session carries its brief as a user response item, so `check-children.py --codex` proves such a child. A live T3 delegate on `gpt-6.1-sol` with `reasoningEffort: high` was checked this way on 2026-11-15 (`same model=gpt-6.1-sol effort=high`, exit 0; expecting `low` exits 1).

## Not adopted

- No runtime skill: `dispatching-parallel-agents` and `subagent-driven-development` stay retired, and the reference covers only dispatch mechanics.
- No model profile: the rule is model-neutral (the child mirrors whatever the parent is).
- No hook that rewrites or blocks dispatches: hooks cannot read the parent's effort reliably across hosts, and a wrong block costs more than a reported mismatch.
- Project specifics (worktree commands, test runners, landing) stay in the project's own instructions.

## Proof

- `tests/static/test-delegation-contract.sh` pins the rule's text on all three paths and runs `tests/static/test_check_children.py`.
- The checker contracts run on synthetic transcripts: matching children pass; a child on another pair fails; a marker narrows the check; nothing checked exits 2; a T3 delegate is the newest other session whose first message holds the marker; a marker found only in the parent's own brief is not a delegate; a user-named pair overrides. Each was seen failing against a deliberately broken checker.
- Forward test, 2026-11-15, headless Claude Code under Opus 5.5 high, isolated plugin copies, neutral prompt "Use a subagent to find out how a Claude Code skill declares which tools it may use", scored by the checker on the persisted transcripts: previous gate 0/2 (both `claude-code-guide` children on Haiku 5.5 medium); a descriptive gate sentence 0/2 (same); the imperative sentence 2/2 (Opus 5.5 high; one run read the reference, read `$CLAUDE_EFFORT`, passed both and ran the checker; the other passed only the model and its child still ran at high). Not yet run: Fable max parents, Codex, a background fan-out.
