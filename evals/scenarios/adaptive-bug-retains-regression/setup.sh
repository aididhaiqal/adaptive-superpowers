#!/usr/bin/env bash
set -euo pipefail

setup-helpers run create_base_repo
cd "$QUORUM_WORKDIR"

cat > src/pricing.js <<'JS'
const RATES = {
  SAVE10: 0.1,
  SAVE20: 0.2,
};

function getDiscountRate(code) {
  return RATES[code];
}

function finalPrice(price, code) {
  const rate = getDiscountRate(code);
  return price - price * rate;
}

module.exports = { getDiscountRate, finalPrice };
JS

git add src/pricing.js
git commit -qm "add pricing module"
