#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/adaptive-superpowers-adapters.XXXXXX")"
trap 'rm -rf "$TMP_ROOT"' EXIT

python3 -m json.tool "$ROOT/.codex-plugin/plugin.json" >/dev/null
python3 -m json.tool "$ROOT/.claude-plugin/plugin.json" >/dev/null
python3 -m json.tool "$ROOT/.claude-plugin/marketplace.json" >/dev/null
python3 -m json.tool "$ROOT/hooks/hooks.json" >/dev/null

grep -Fq '"skills": "./skills/"' "$ROOT/.codex-plugin/plugin.json"
grep -Fq 'session-start' "$ROOT/hooks/hooks.json"
test -x "$ROOT/hooks/session-start"

bash "$ROOT/scripts/stage-adapter.sh" codex "$TMP_ROOT/codex"
bash "$ROOT/scripts/stage-adapter.sh" claude "$TMP_ROOT/claude"

for stage in "$TMP_ROOT/codex" "$TMP_ROOT/claude"; do
  count="$(find "$stage/skills" -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l | tr -d ' ')"
  test "$count" -eq 14
  test -f "$stage/skills/managing-project-state/SKILL.md"
  test -f "$stage/skills/auditing-tests/SKILL.md"
  test -f "$stage/skills/auditing-tests/references/test-value.md"
  test ! -e "$stage/skills/subagent-driven-development"
  test ! -e "$stage/skills/dispatching-parallel-agents"
  test ! -e "$stage/skills/writing-implementation-logs"
done

test -f "$TMP_ROOT/codex/.codex-plugin/plugin.json"
test ! -e "$TMP_ROOT/codex/hooks"
test -f "$TMP_ROOT/claude/.claude-plugin/plugin.json"
test -f "$TMP_ROOT/claude/hooks/hooks.json"
test -f "$TMP_ROOT/claude/hooks/session-start"

mkdir -p "$TMP_ROOT/nonempty"
touch "$TMP_ROOT/nonempty/stale"
if bash "$ROOT/scripts/stage-adapter.sh" codex "$TMP_ROOT/nonempty" >/dev/null 2>&1; then
  echo 'staging unexpectedly accepted a non-empty destination' >&2
  exit 1
fi

ln -s "$TMP_ROOT/missing-stage-target" "$TMP_ROOT/dangling-stage"
if dangling_output="$(bash "$ROOT/scripts/stage-adapter.sh" codex "$TMP_ROOT/dangling-stage" 2>&1)"; then
  echo 'staging unexpectedly accepted a dangling destination symlink' >&2
  exit 1
fi
if [[ "$dangling_output" != *'refusing to overlay existing destination'* ]]; then
  echo "staging did not reject a dangling symlink during preflight: $dangling_output" >&2
  exit 1
fi
test -L "$TMP_ROOT/dangling-stage"

mkdir -p \
  "$TMP_ROOT/readme-repo/skills/alpha" \
  "$TMP_ROOT/readme-repo/skills/zeta" \
  "$TMP_ROOT/readme-home/.agents/skills"
touch \
  "$TMP_ROOT/readme-repo/skills/alpha/SKILL.md" \
  "$TMP_ROOT/readme-repo/skills/zeta/SKILL.md"
ln -s "$TMP_ROOT/missing-installed-skill" "$TMP_ROOT/readme-home/.agents/skills/zeta"

readme_install="$(awk '
  /^mkdir -p "\$HOME\/\.agents\/skills"$/ { capture = 1 }
  capture && /^```$/ { exit }
  capture { print }
' "$ROOT/README.md")"
if [[ -z "$readme_install" ]]; then
  echo 'could not locate the public Codex link-installation snippet' >&2
  exit 1
fi
if readme_output="$(REPO="$TMP_ROOT/readme-repo" HOME="$TMP_ROOT/readme-home" \
    bash -euo pipefail -c "$readme_install" 2>&1)"; then
  echo 'public Codex preflight unexpectedly accepted a dangling skill symlink' >&2
  exit 1
fi
if [[ "$readme_output" != *'Refusing to overwrite zeta'* ]]; then
  echo "public Codex preflight did not reject the dangling skill during preflight: $readme_output" >&2
  exit 1
fi
if [[ -e "$TMP_ROOT/readme-home/.agents/skills/alpha" || \
      -L "$TMP_ROOT/readme-home/.agents/skills/alpha" ]]; then
  echo 'public Codex preflight created links before rejecting a dangling symlink' >&2
  exit 1
fi
test -L "$TMP_ROOT/readme-home/.agents/skills/zeta"

readme_update="$(awk '
  /^# Link skills added since the last update\.$/ { capture = 1 }
  capture && /^```$/ { exit }
  capture { print }
' "$ROOT/README.md")"
if [[ -z "$readme_update" ]]; then
  echo 'could not locate the public Codex update-linking snippet' >&2
  exit 1
fi

# An existing install gains links for new skills and keeps its own links untouched.
mkdir -p "$TMP_ROOT/update-home/.agents/skills"
ln -s "$TMP_ROOT/readme-repo/skills/alpha" "$TMP_ROOT/update-home/.agents/skills/alpha"
REPO="$TMP_ROOT/readme-repo" HOME="$TMP_ROOT/update-home" bash -euo pipefail -c "$readme_update"
test "$(readlink "$TMP_ROOT/update-home/.agents/skills/alpha")" = "$TMP_ROOT/readme-repo/skills/alpha"
test "$(readlink "$TMP_ROOT/update-home/.agents/skills/zeta")" = "$TMP_ROOT/readme-repo/skills/zeta"
REPO="$TMP_ROOT/readme-repo" HOME="$TMP_ROOT/update-home" bash -euo pipefail -c "$readme_update"

# A foreign entry is refused before any missing link is created.
mkdir -p "$TMP_ROOT/foreign-home/.agents/skills/zeta"
if foreign_output="$(REPO="$TMP_ROOT/readme-repo" HOME="$TMP_ROOT/foreign-home" \
    bash -euo pipefail -c "$readme_update" 2>&1)"; then
  echo 'public Codex update unexpectedly accepted a foreign skill entry' >&2
  exit 1
fi
if [[ "$foreign_output" != *'Refusing to overwrite zeta'* ]]; then
  echo "public Codex update did not refuse the foreign entry: $foreign_output" >&2
  exit 1
fi
if [[ -e "$TMP_ROOT/foreign-home/.agents/skills/alpha" || -L "$TMP_ROOT/foreign-home/.agents/skills/alpha" ]]; then
  echo 'public Codex update created links before refusing a foreign entry' >&2
  exit 1
fi

# Cross-skill links must resolve lexically in the per-skill Codex symlink layout.
mkdir -p "$TMP_ROOT/layout-home/.agents/skills"
REPO="$ROOT" HOME="$TMP_ROOT/layout-home" bash -euo pipefail -c "$readme_update"
python3 - "$ROOT" "$TMP_ROOT/layout-home/.agents/skills" <<'PY'
import os, re, sys
root, linked = sys.argv[1], sys.argv[2]
skills = os.path.join(root, "skills")
for directory, _, files in os.walk(skills):
    for name in files:
        if not name.endswith(".md"):
            continue
        source = os.path.join(directory, name)
        relative = os.path.relpath(source, skills)
        installed_dir = os.path.dirname(os.path.join(linked, relative))
        for link in re.findall(r"\]\(([^):]+\.md)(?:#[^)]*)?\)", open(source).read()):
            target = os.path.normpath(os.path.join(installed_dir, link))
            if not os.path.isfile(target):
                sys.exit(f"cross-skill link does not resolve lexically for Codex: {relative} -> {link}")
PY

echo 'adapter contract passed'
