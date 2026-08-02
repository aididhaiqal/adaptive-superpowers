# State model

## Authority hierarchy

Live source, Git, CI, deployment, and runtime evidence are authoritative. Plans and task reports remain intent or supporting evidence; they never override current evidence. The canonical current record summarizes the present accepted state and must not become a second source of implementation truth.

## Current states

- `queued`: accepted but not started.
- `active`: currently authorized work.
- `blocked`: accepted work waiting on a named condition or authority.
- `future-watch`: an accepted obligation triggered by a future condition.
- `completed`: accepted outcomes with required completion evidence, awaiting any qualifying archival.

Recommendations are not queued work until accepted. Keep implemented, tested, committed, pushed, merged, deployed, and runtime-verified as separate fields.

## Transitions

These are forward when their named evidence is recorded:

- `future-watch` to `queued` or `active` after its trigger;
- `queued` to `active`;
- `active` to `blocked` with a blocker;
- `blocked` to `active` with resolution evidence;
- `active` or `blocked` to `completed` with required completion evidence.

Any other protected-state transition, priority decrease, exclusion, replacement, or removal requires explicit authority and a recorded disposition. Archiving an evidenced `completed` item preserves its state and stable identity.

Consolidating a canonical record must preserve every unresolved blocker, external gate, accepted exclusion, pending outcome, and material watch item with an explicit disposition. Compress completed detail, not outstanding obligations.

## Resume and temporary state

After compaction or resume, reconcile the governing plan, canonical record, Git, and live checkout, then continue the first unfinished accepted outcome. Do not repeat completed work whose relevant state and evidence remain intact.

Temporary execution state may checkpoint completed outcomes, fix rounds, commits, and evidence pointers. It is workstream-scoped and supplemental; it never overrides or duplicates the canonical project record and is not required for routine work.
