#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

test -f "$ROOT/README.md"
test -f "$ROOT/LICENSE"
test -f "$ROOT/assets/adaptive-superpowers-hero.svg"
grep -Fq 'Move fast. Keep the proof.' "$ROOT/assets/adaptive-superpowers-hero.svg"
grep -Fq 'Risk-adaptive engineering workflows optimized for GPT-5.6 and Claude 5.' "$ROOT/README.md"
grep -Fq 'aididhaiqal/adaptive-superpowers' "$ROOT/README.md"
grep -Fq '## Install' "$ROOT/README.md"
grep -Fq '```mermaid' "$ROOT/README.md"
grep -Fq '150-word adaptive gate' "$ROOT/README.md"
test -f "$ROOT/CHANGELOG.md"
test -f "$ROOT/AGENTS.md"
test -x "$ROOT/scripts/validate.sh"

grep -Fq 'd884ae04edebef577e82ff7c4e143debd0bbec99' "$ROOT/README.md"
grep -Fq 'aa973775906c8761a78019aaa21e4f0ccd987925' "$ROOT/README.md"
grep -Fq 'GPT-5.6 Sol' "$ROOT/README.md"
grep -Fq 'Claude Opus 4.8' "$ROOT/README.md"
grep -Fq 'Claude Fable 5' "$ROOT/README.md"
grep -Fq 'observable behavior' "$ROOT/README.md"
grep -Fq 'MIT License' "$ROOT/LICENSE"

bash "$ROOT/scripts/validate.sh"

echo 'repository contract passed'
