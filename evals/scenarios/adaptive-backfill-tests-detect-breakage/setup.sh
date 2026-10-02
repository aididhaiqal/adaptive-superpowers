#!/usr/bin/env bash
set -euo pipefail

setup-helpers run create_base_repo
cd "$QUORUM_WORKDIR"

mkdir -p src

cat > src/tax.js <<'JS'
const STANDARD_RATE = 0.2;
const EXEMPT_CATEGORIES = new Set(['food', 'books']);

/**
 * Tax owed on one line, rounded to the nearest cent.
 * Food and books are exempt. A negative amount is rejected with a RangeError.
 */
function taxFor(amount, category) {
  if (amount < 0) {
    throw new RangeError('amount must not be negative');
  }
  if (EXEMPT_CATEGORIES.has(category)) {
    return 0;
  }
  return Math.round(amount * STANDARD_RATE * 100) / 100;
}

module.exports = { taxFor };
JS

git add src
git commit -qm "add tax calculation"
git tag base
