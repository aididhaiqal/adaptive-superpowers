# Testing Anti-Patterns

Test observable production behavior. Use mocks and doubles only to control a necessary boundary, not as the subject of the test.

## Make Coverage Discriminating

- Identify a realistic defect the test catches: a wrong branch or argument, missing effect, broken boundary, or violated contract. Do not add a test merely because a file changed; sufficient existing coverage may stay unchanged.
- Derive expected values independently of the implementation being checked. Do not compute the oracle through the same function or helper whose correctness is at issue. Use hand-checked fixtures or an independent contract.
- Prefer behavior over change detectors: exercise retry limits rather than only asserting a constant's value. Exact values or text are legitimate assertions when they are themselves a promised external contract.
- Use source-text checks for intentional structural or wording constraints, not as proof of execution. Run scripts against controlled inputs and check outputs, side effects, and exit status; evaluate agent instructions through representative consuming-agent behavior.
- For nontrivial coverage, consider a representative wrong branch, argument, or missing effect: would the test fail? This is a lightweight falsifiability check, not a mandatory mutation-testing run. Execute a focused mutation only when it resolves meaningful doubt.

## Test Real Behavior

- Assert public outputs, state, errors, or durable side effects.
- Avoid assertions that merely prove a mock component exists or a stub returns its configured value.
- Assert calls only when the interaction itself is a contract, such as sending one message or withholding a destructive operation.
- Test the application's contract at dependency boundaries—registered routes, emitted queries, mapped payloads, or error handling—not framework internals already covered upstream. Keep focused integration or characterization tests where configuration, dependency interaction, or version-sensitive behavior could break that contract; upstream coverage does not prove our wiring.

```typescript
test('rejects a duplicate server', async () => {
  const store = new InMemoryConfigStore();
  const transport = { start: vi.fn() }; // isolate only the external boundary
  const service = new ServerService(store, transport);

  await service.add({ id: 'docs' });

  await expect(service.add({ id: 'docs' })).rejects.toThrow('duplicate');
  expect(await store.has('docs')).toBe(true);
});
```

Keep the state transition real; replace only the external startup.

## Mock Deliberately

1. Identify the real dependency's outputs, side effects, errors, and ordering.
2. Run with the real or in-memory implementation first when those behaviors are unclear.
3. Mock the narrowest slow, external, destructive, or nondeterministic boundary.
4. Preserve every behavior the test relies on; do not mock the higher-level operation under test.
5. Prefer a small fake over a chain of interaction mocks when stateful behavior matters.

## Keep Test-Only APIs Out of Production

- Do not add a production method used only for setup, inspection, or cleanup in tests.
- Put test orchestration in fixtures, builders, or test utilities.
- Keep a lifecycle method in production only when the production object genuinely owns that lifecycle and real callers need it.
- Expose behavior through the public contract; do not weaken visibility solely for tests.

## Build Faithful Doubles

- Make doubles satisfy the real interface or schema at compile time when possible.
- Include all required fields, nested values, side effects, and failure modes consumed along the exercised path.
- Centralize representative objects in typed factories instead of hand-writing partial objects per test.
- Add a contract test when multiple implementations or API-backed fixtures must remain interchangeable.
- Fail loudly on unsupported calls; do not return permissive `undefined` values that hide missing behavior.

## Escalate to Real Components

Replace complex mocks with real in-memory components or a focused integration test when setup exceeds the assertion, mocks mirror implementation details, or cross-component behavior is the requirement.

## Evidence

Observe the test fail for the intended behavior, then pass after the production change. Run the relevant contract or integration check when a double represents an external schema or stateful dependency.
