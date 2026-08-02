---
name: test-driven-development
description: "Use when the user requests TDD or test-first work, when a confirmed bug needs a focused regression before the fix, or when a focused failing test is needed to resolve material implementation ambiguity."
---

# Test-Driven Development

The user need not request TDD; loading it does not authorize implementation. Expected behavior must be clear. Auto-trigger only when a focused red test resolves material ambiguity between plausible implementations or captures a confirmed regression at a public boundary. Do not auto-trigger for a precise low-risk feature merely because a cheap test is possible.

Coverage is broader than this workflow's trigger: an observable behavior change normally retains an automated test even when strict test-first execution adds no useful discrimination. This skill governs red-green order only when its trigger matches.

For an unclear cause, `systematic-debugging` owns investigation; enter red-green only after the expected behavior and red signal are trustworthy. Skip documentation, configuration-only changes, generated code, prototypes, untestable behavior, and behavior-preserving refactors; check the last green before and after.

1. Define one thin vertical slice of observable behavior through its public boundary.
2. Write or identify one focused test; an existing accurate failure can be the red state.
3. Run it and confirm it fails for the intended missing behavior, not setup or syntax.
4. Implement the smallest production change that passes it.
5. Run the focused test, refactor only when useful, keep it green, and repeat.

The focused red and green runs are expected. Do not run a broader suite after every slice. Batch related green slices, then run affected regression coverage at a coherent milestone; reuse unchanged evidence.

Test public outputs, state, errors, or durable effects. Mock only necessary boundaries. Read [testing-anti-patterns.md](testing-anti-patterns.md) only when adding mocks, doubles, or test-only production APIs.

If automated coverage is impractical, state why and use the strongest boundary, integration, compile, or manual check. Preserve pre-existing user code. Retain the red reason, green result, final proportionate regression result, and any untested behavior.
