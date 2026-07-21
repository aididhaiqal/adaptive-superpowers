#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EXPECTED_SKILLS=12
MAX_SKILL_WORDS=400
MAX_TOTAL_WORDS=3200

SKILL_FILES=()
while IFS= read -r file; do
  SKILL_FILES+=("$file")
done < <(find "$ROOT/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -print | sort)

if [[ "${#SKILL_FILES[@]}" -ne "$EXPECTED_SKILLS" ]]; then
  echo "expected $EXPECTED_SKILLS skills, found ${#SKILL_FILES[@]}" >&2
  exit 1
fi

total=0
for file in "${SKILL_FILES[@]}"; do
  first="$(sed -n '1p' "$file")"
  [[ "$first" == '---' ]] || { echo "missing front matter: $file" >&2; exit 1; }
  grep -Eq '^name:[[:space:]]+[a-z0-9-]+$' "$file"
  grep -Eq '^description:[[:space:]]+.' "$file"
  words="$(wc -w < "$file" | tr -d ' ')"
  if [[ "$words" -gt "$MAX_SKILL_WORDS" ]]; then
    echo "skill exceeds $MAX_SKILL_WORDS words: $file ($words)" >&2
    exit 1
  fi
  total=$((total + words))

  while IFS= read -r link; do
    target="$(dirname "$file")/${link%%#*}"
    [[ -e "$target" ]] || { echo "broken skill link: $file -> $link" >&2; exit 1; }
  done < <(grep -Eo '\]\([^):]+\.md(#[^)]*)?\)' "$file" | sed -E 's/^\]\(([^)]+)\)$/\1/' || true)
done

if [[ "$total" -gt "$MAX_TOTAL_WORDS" ]]; then
  echo "runtime skill total exceeds $MAX_TOTAL_WORDS words: $total" >&2
  exit 1
fi

for json in .codex-plugin/plugin.json .claude-plugin/plugin.json .claude-plugin/marketplace.json hooks/hooks.json; do
  python3 -m json.tool "$ROOT/$json" >/dev/null
done

while IFS= read -r script; do
  bash -n "$script"
done < <(find "$ROOT" -type f \( -name '*.sh' -o -path "$ROOT/hooks/session-start" \) -print)

if [[ -d "$ROOT/.git" ]]; then
  git -C "$ROOT" diff --check
fi

printf 'validated %d skills, %d runtime words\n' "${#SKILL_FILES[@]}" "$total"
