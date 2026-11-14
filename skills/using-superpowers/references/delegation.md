# Delegation

Read before dispatching any child agent: explorer, reviewer, worker, or a fan-out of them.

## Same model, same effort

A child runs on the parent's exact model and reasoning effort unless the user names another, for one task or as a standing rule. Read both from the host: the model ID it states for this session and the session's effort setting.

Pass both on every dispatch. Host defaults differ from the parent: a built-in specialist agent type can carry its own smaller model and effort. Never switch a running child's model unasked. Say which pair each child got and why.

| host | pass the pair |
|---|---|
| Claude Code `Agent` tool | `model` (alias: `fable`, `opus`, `sonnet`, `haiku`) and `effort` (`low`..`max`); the session effort is `$CLAUDE_EFFORT`. A `fork` runs on the parent's pair. |
| T3 Code `delegate_task` | `target.model` (exact ID) and `target.options.effort`; `orchestrator_capabilities` reports the inherited pair. |
| any other host | its model and effort parameters; when it has none, say the child runs on the host default. |

## Channel

Run a short read-only lookup that the very next step needs in the foreground. Run anything long, anything that edits, and any fan-out in the background, so the parent stays free for the user and its inbox; a foreground batch blocks until every child returns.

## Fan out only independent work

Each child pays a base context cost before its first file read (measured on Claude Code: roughly 40k to 70k tokens), and one model's usage limit stops every child on it together. Run at most six children at once unless the user sets another cap. One writer per checkout: an editing child gets its own worktree (`using-git-worktrees`). Give reviewers the code and the question, not your conclusion.

## Brief

Each brief carries the goal and when it is done; files and interfaces; what is ruled out; what is forbidden (destructive Git, push, integration, further delegation unless asked); a checkpoint commit before any long proof phase; a time-box after which it returns an honest open list; a marker unique to the child (for example `brief-<slug>-<4 random characters>`) in its first line; and the line it ends on: `commit <sha or none> · tests <command: outcome> · open <items>`.

## While children run

Do not poll: a background child's completion reaches the parent. Carry on with other work or end the turn. A dispatched agent that ends its turn while its own children run says so in its summary, because its parent sees it as finished. Check a terse "completed" once before acting on it. After a usage-limit stop, resume once with a checkpoint commit first, then ask the user.

## Prove it

Report the pair each child ran on from the host's own record, never from what was requested. On Claude Code, run `scripts/check-children.py` (beside this skill) after the children answer: no arguments checks this session and its native children, `--marker <m>` only the children whose brief holds it, `--delegate <m>` a T3 delegate against this session's pair, and `--expect-model`/`--expect-effort` a pair the user named. Exit 0 means every checked agent matched, 1 one differed, 2 nothing was checked, which is never a pass. Paste its lines into the report. On a host that records no model per child, report the pair as requested, not verified.
