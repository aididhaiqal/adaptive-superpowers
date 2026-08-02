#!/usr/bin/env bash
set -euo pipefail

setup-helpers run create_base_repo
cd "$QUORUM_WORKDIR"
mkdir -p src test

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
