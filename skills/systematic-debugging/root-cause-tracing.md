# Root-Cause Tracing

Use this pattern when a failure appears far from the code or input that created the invalid state. Trace the value or side effect backward; do not patch only the final symptom.

## Trace Backward

1. Capture the exact symptom, failing operation, inputs, and stack.
2. Find the line that directly produces the failure.
3. Identify who called it and where each relevant argument came from.
4. Repeat through callers, transformations, defaults, and stored state until reaching the first incorrect value or decision.
5. Distinguish the origin from missing guards. Fix the origin first; add a guard only where risk justifies it.
6. Run the smallest check that proves the proposed origin creates the symptom.

Example trace:

```text
git init used process.cwd()
← directory argument was ""
← createWorkspace received an unset tempDir
← test read tempDir before setup completed
```

Fix the premature read, then verify that the full chain receives the expected directory.

## Instrument Safely

Add temporary instrumentation immediately before the dangerous operation when static tracing stops:

```typescript
console.error('DEBUG git init', {
  directory,
  cwd: process.cwd(),
  stack: new Error().stack,
});
```

Log only fields needed to identify the caller and value flow. Never log secrets, tokens, credentials, or sensitive payloads. Remove noisy instrumentation after diagnosis unless it provides durable operational value.

## Find a Test Polluter

When a clean test run creates a persistent file or directory and the responsible test is unknown, start from a state where the artifact does not exist, run the candidate test files one at a time with the repository's test command, and stop at the first run after which the artifact exists. Reproduce that test alone, then trace the creating operation backward. This search cannot observe in-memory, timing-only, or cross-process pollution.

## Evidence

Record the symptom, caller chain, originating value or decision, discriminating check, source fix, and fresh post-fix reproduction.
