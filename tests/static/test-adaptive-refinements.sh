#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# Policy-presence lint, not proof of model behavior. Runtime fixtures are separate.
python3 - "$ROOT" <<'PY'
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
requirements = {
    "skills/using-superpowers/SKILL.md": [
        "User instructions take precedence over skill defaults",
        "Do not re-ask for authority already granted",
        "Existing sufficient retained coverage counts",
        "After resume or compaction, revalidate",
    ],
    "skills/using-superpowers/references/delegation.md": [
        "Batch small same-shape changes",
        "Resume the existing implementer",
        "Nested delegation",
        "duplicate review",
    ],
    "skills/test-driven-development/testing-anti-patterns.md": [
        "Derive expected values independently",
        "source-text checks",
        "not a mandatory mutation-testing run",
    ],
    "skills/writing-plans/SKILL.md": ["existing specification", "binding constraints"],
    "skills/writing-skills/SKILL.md": ["Structural lint is not behavioral proof"],
}
errors = []
for name, phrases in requirements.items():
    path = root / name
    if not path.is_file():
        errors.append(f"missing reference: {name}")
        continue
    content = path.read_text()
    errors.extend(f"{name}: missing policy {phrase!r}" for phrase in phrases if phrase not in content)
for name in [
    "skills/using-superpowers/SKILL.md",
    "skills/using-superpowers/references/full-router.md",
    "skills/using-superpowers/references/explorer-handoff.md",
]:
    content = (root / name).read_text()
    for obsolete in ["at most two production files", "Use one explorer only", "or delegate further"]:
        if obsolete in content:
            errors.append(f"{name}: obsolete constraint {obsolete!r}")
if errors:
    raise SystemExit("\n".join(errors))
print("adaptive refinement policy lint passed (not behavioral proof)")
PY
