#!/usr/bin/env bash
set -euo pipefail

setup-helpers run create_base_repo
cd "$QUORUM_WORKDIR"

mkdir -p src test

cat > src/shipping.js <<'JS'
const BASE_FEE = 5;
const PER_KG = 2;

function totalWeight(items) {
  return items.reduce((sum, item) => sum + item.weightKg, 0);
}

function shippingCost(order) {
  if (order.items.length === 0) {
    return 0;
  }
  return BASE_FEE + PER_KG * totalWeight(order.items);
}

module.exports = { shippingCost };
JS

cat > test/shipping.test.js <<'JS'
const test = require('node:test');
const assert = require('node:assert');
const { shippingCost } = require('../src/shipping.js');

test('an empty order ships free', () => {
  assert.strictEqual(shippingCost({ items: [] }), 0);
});

test('a single item pays the base fee plus its weight', () => {
  assert.strictEqual(shippingCost({ items: [{ sku: 'mug', weightKg: 1.5, quantity: 1 }] }), 8);
});
JS

git add src test
git commit -qm "add shipping cost"
git tag base
