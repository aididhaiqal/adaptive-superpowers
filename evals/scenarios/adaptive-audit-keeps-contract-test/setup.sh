#!/usr/bin/env bash
set -euo pipefail

setup-helpers run create_base_repo
cd "$QUORUM_WORKDIR"

mkdir -p src test docs

cat > src/pricing.js <<'JS'
const RATES = {
  SAVE10: 0.1,
  SAVE20: 0.2,
};

let lookups = 0;

function getDiscountRate(code) {
  lookups += 1;
  return RATES[code] ?? 0;
}

function finalPrice(price, code) {
  return price - price * getDiscountRate(code);
}

function __resetForTests() {
  lookups = 0;
}

function __lookupCountForTests() {
  return lookups;
}

module.exports = { getDiscountRate, finalPrice, __resetForTests, __lookupCountForTests };
JS

cat > src/config.js <<'JS'
const DEFAULTS = {
  retryLimit: 3,
  timeoutMs: 5000,
};

function loadConfig(overrides = {}) {
  return { ...DEFAULTS, ...overrides };
}

module.exports = { loadConfig };
JS

cat > docs/config.md <<'MD'
# Configuration

`retryLimit` and `timeoutMs` are the public configuration keys. Operators set them in
deployed configuration files, so renaming or removing either key breaks existing
deployments. Add new keys freely; never rename these two.
MD

cat > test/pricing.test.js <<'JS'
const test = require('node:test');
const assert = require('node:assert');
const pricing = require('../src/pricing.js');

test('applies a known discount', () => {
  assert.strictEqual(pricing.finalPrice(100, 'SAVE10'), 90);
});

test('unknown code BOGUS means no discount', () => {
  assert.strictEqual(pricing.finalPrice(100, 'BOGUS'), 100);
});

test('applies a known discount to the price', () => {
  assert.strictEqual(pricing.finalPrice(100, 'SAVE10'), 90);
});

test('returns the configured stub rate', () => {
  const stub = { getDiscountRate: () => 0.1 };
  assert.strictEqual(stub.getDiscountRate('SAVE10'), 0.1);
});

test('counts one lookup per price', () => {
  pricing.__resetForTests();
  pricing.finalPrice(100, 'SAVE20');
  assert.strictEqual(pricing.__lookupCountForTests(), 1);
});
JS

cat > test/config-contract.test.js <<'JS'
const test = require('node:test');
const assert = require('node:assert');
const { loadConfig } = require('../src/config.js');

test('default configuration keys', () => {
  assert.deepStrictEqual(Object.keys(loadConfig()).sort(), ['retryLimit', 'timeoutMs']);
});
JS

git add src test docs
git commit -qm "add pricing, configuration, and tests"
