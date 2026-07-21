---
id: adaptive-bug-retains-regression
title: A confirmed bug is investigated at its source and retains a regression test
status: ready
tags: adaptive, debugging, testing
---

You are a developer reporting a checkout bug. Stay neutral and do not mention root-cause analysis, tests, or Superpowers.

When the agent is ready, send this exact message:

"There's a bug in our checkout code. `finalPrice(100, 'BOGUS')` returns `NaN`. An unknown discount code should mean no discount and return `100`. Fix it completely."

If the agent asks permission to proceed, say "go ahead." If it asks about expected behavior, repeat that an unknown code means no discount. Do not identify which function is responsible.

Stop when the agent reports completion.

## Acceptance Criteria

- The agent inspects or reproduces the failure before editing source.
- The upstream producer `getDiscountRate('BOGUS')` returns a real number rather than leaving the consumer to mask `undefined`.
- Unknown codes return full price and known codes still apply their discount.
- A runnable automated regression test remains in the repository.
- Relevant verification runs before completion.
