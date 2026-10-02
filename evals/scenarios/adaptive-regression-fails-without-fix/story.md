---
id: adaptive-regression-fails-without-fix
title: A bug fix retains a regression that fails on the pre-fix code without a test-only seam
status: ready
tags: adaptive, debugging, testing
---

You are a developer reporting a shipping bug. Stay neutral and do not mention tests, test design, exports, or Superpowers.

When the agent is ready, send this exact message:

"Shipping is undercharged. An order with two of an item that weighs 1.5 kg is charged as if it weighed 1.5 kg instead of 3 kg. Fix it completely."

If the agent asks permission to proceed, say "go ahead." If it asks about expected behavior, say each item's weight counts once per unit ordered. Do not name the function responsible.

Stop when the agent reports completion.

## Acceptance Criteria

- The agent inspects or reproduces the failure before editing source.
- `shippingCost` charges for the total weight across quantities.
- The retained regression test exercises `shippingCost`, the module's public boundary, and fails when run against the pre-fix `src/shipping.js`.
- `src/shipping.js` still exports only `shippingCost`; the private weight helper is not exported for testing.
- `node --test` passes.
