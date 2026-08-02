# Archival and validation

## Archive admission

Routine and ordinary Standard completion stays compact in the current ledger and Git history. Create `docs/project-evidence/` only with the first qualifying entry. Evidence qualifies when repository, regulatory, security, incident, migration, or production-data policy requires retention; a High-risk or persistent workstream needs it for future safe operation; an external gate remains linked; or the user explicitly requests it.

Keep stable ID, accepted outcome, consequential decisions, qualified evidence references, delivery state, and dispositions. For managed transition checks, encode identity as an exact `ID: <stable-id>` field and include non-empty `Disposition:` and `Authority:` fields. Exclude raw model trajectories, repeated command output, per-edit narration, and content canonical elsewhere. Never truncate unresolved obligations to satisfy a size threshold.

Routine sessions must not enumerate or load the evidence archive. Load one entry only when a specific active item, audit, incident, or user request identifies it.

Convention-profile automatic discovery accepts an explicit canonical-ledger declaration in root `AGENTS.md`, `AGENTS.override.md`, or `CLAUDE.md`. When an established repository source elsewhere owns the pointer, follow it semantically and pass `--ledger` for that audit rather than scanning arbitrary historical documentation.

## Managed profile

`.superpowers/project-state.yaml` configures paths and limits only:

```yaml
version: 1
ledger: docs/progress.md
archive: docs/project-evidence
protected_states: [queued, active, blocked, future-watch]
current_completed_limit: 10
archive_entry_max_kib: 64
```

The protected set may add states but cannot omit the four defaults. The managed Markdown ledger requires stable `ID`, `State`, `Priority`, `Disposition`, and `Authority` columns plus distinct delivery-evidence columns.

Run:

```bash
python3 scripts/audit_project_state.py --root <repo> [--ledger <path>] [--base-ref <ref> --head-ref <ref>] [--format text|json]
```

`--ledger` overrides discovery for that run; managed CI must omit it or match configuration. Without both revision refs, transition checks report `not_evaluated`. CI can require authority and disposition references but cannot prove they are honest. The model remains responsible for semantic truth.
