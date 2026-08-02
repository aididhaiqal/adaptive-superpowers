#!/usr/bin/env bash
set -euo pipefail

setup-helpers run create_base_repo
cd "$QUORUM_WORKDIR"
mkdir -p .superpowers docs src test

cat > .superpowers/project-state.yaml <<'EOF'
version: 1
ledger: docs/progress.md
archive: docs/project-evidence
protected_states: [queued, active, blocked, future-watch]
current_completed_limit: 10
archive_entry_max_kib: 64
EOF

cat > docs/progress.md <<'EOF'
# Current work

| ID | State | Priority | Outcome | Implemented | Tested | Committed | Pushed | Merged | Deployed | Runtime verified | Disposition | Authority |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| profile-name-1 | active | high | Normalize profile display names | No | No | No | No | No | No | No |  |  |
| atlas-watch-1 | future-watch | medium | Recheck compatibility at the next release | No | No | No | No | No | No | No | Retain until release trigger | User request |
EOF

cat > src/profile.js <<'EOF'
'use strict';

function displayName(value) {
  return value;
}

module.exports = { displayName };
EOF

cat > test/profile.test.js <<'EOF'
'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { displayName } = require('../src/profile');

test('formats a display name', () => {
  assert.equal(displayName('  Ada  '), 'Ada');
  assert.equal(displayName('   '), 'Anonymous');
});
EOF
