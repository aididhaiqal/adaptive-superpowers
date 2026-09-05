'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { displayName } = require('../src/profile');

test('trims outer whitespace and uses the blank-input fallback', () => {
  assert.equal(displayName('  Ada  '), 'Ada');
  assert.equal(displayName('\tLin\n'), 'Lin');
  assert.equal(displayName(''), 'Anonymous');
  assert.equal(displayName(' \t\n'), 'Anonymous');
  assert.equal(displayName('Ada Lovelace'), 'Ada Lovelace');
});
