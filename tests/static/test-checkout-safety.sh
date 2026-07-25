#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GATE="$ROOT/skills/using-superpowers/SKILL.md"
ROUTER="$ROOT/skills/using-superpowers/references/full-router.md"
WORKTREES="$ROOT/skills/using-git-worktrees/SKILL.md"
EXECUTE="$ROOT/skills/executing-plans/SKILL.md"
PLANS="$ROOT/skills/writing-plans/SKILL.md"

require_text() {
  local file="$1"
  local text="$2"
  if ! grep -Fq "$text" "$file"; then
    echo "checkout-safety contract missing from ${file#"$ROOT/"}: $text" >&2
    exit 1
  fi
}

require_text "$ROUTER" 'Current installed skills and live repository state override stale session summaries'
require_text "$ROUTER" 'after a resume or compaction'
require_text "$ROUTER" 'before mutation, editing delegation, commit, or branch operations'
require_text "$ROUTER" 'repository root, worktree path, branch, HEAD, and status'
require_text "$GATE" 'Use an isolated worktree when the full router requires one.'
require_text "$GATE" 'When isolation is required, a checkout containing unrelated changes is not suitable.'
require_text "$WORKTREES" 'Material or High-risk plan execution'
require_text "$WORKTREES" 'editing subagent'
require_text "$WORKTREES" 'after resume or compaction'
require_text "$WORKTREES" 'Unrelated changes mean the current checkout is not appropriate isolation for new material or resumable work.'
require_text "$WORKTREES" 'Use harness-native worktrees only when they leave the original checkout unchanged'
require_text "$WORKTREES" 'Never add ignore files/rules to conceal them.'
require_text "$EXECUTE" 'Revalidate the live checkout identity'
require_text "$PLANS" 'Do not duplicate supplied incidents or specifications'
require_text "$PLANS" 'does not authorize commits or shared-checkout branch switching'

echo 'checkout safety contract passed'
