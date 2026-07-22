#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HOST="${1:-}"
DESTINATION="${2:-}"

if [[ "$HOST" != "codex" && "$HOST" != "claude" ]]; then
  echo 'usage: stage-adapter.sh <codex|claude> <new-destination>' >&2
  exit 2
fi
if [[ -z "$DESTINATION" ]]; then
  echo 'destination is required' >&2
  exit 2
fi
if [[ -e "$DESTINATION" || -L "$DESTINATION" ]]; then
  echo "refusing to overlay existing destination: $DESTINATION" >&2
  exit 1
fi

PARENT="$(dirname "$DESTINATION")"
mkdir -p "$PARENT"
STAGE="$(mktemp -d "$PARENT/.adaptive-superpowers-stage.XXXXXX")"
cleanup() {
  if [[ -n "${STAGE:-}" && -d "$STAGE" ]]; then
    rm -rf "$STAGE"
  fi
}
trap cleanup EXIT

cp -R "$ROOT/skills" "$STAGE/skills"
if [[ "$HOST" == "codex" ]]; then
  cp -R "$ROOT/.codex-plugin" "$STAGE/.codex-plugin"
else
  cp -R "$ROOT/.claude-plugin" "$STAGE/.claude-plugin"
  cp -R "$ROOT/hooks" "$STAGE/hooks"
fi

mv "$STAGE" "$DESTINATION"
STAGE=""
printf 'staged %s adapter at %s\n' "$HOST" "$DESTINATION"
