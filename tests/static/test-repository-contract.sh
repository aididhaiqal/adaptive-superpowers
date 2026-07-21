#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

test -f "$ROOT/README.md"
test -f "$ROOT/LICENSE"
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
