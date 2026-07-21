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
  test "$count" -eq 12
  test ! -e "$stage/skills/subagent-driven-development"
  test ! -e "$stage/skills/dispatching-parallel-agents"
  test ! -e "$stage/skills/writing-implementation-logs"
done

test -f "$TMP_ROOT/codex/.codex-plugin/plugin.json"
test ! -e "$TMP_ROOT/codex/hooks"
test -f "$TMP_ROOT/claude/.claude-plugin/plugin.json"
test -f "$TMP_ROOT/claude/hooks/session-start"

mkdir -p "$TMP_ROOT/nonempty"
touch "$TMP_ROOT/nonempty/stale"
if bash "$ROOT/scripts/stage-adapter.sh" codex "$TMP_ROOT/nonempty" >/dev/null 2>&1; then
  echo 'staging unexpectedly accepted a non-empty destination' >&2
  exit 1
fi

echo 'adapter contract passed'
