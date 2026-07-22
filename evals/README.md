# Behavioral evaluations

These scenarios are consumed by the pinned Superpowers Quorum harness. They avoid assertions tied to the official plugin namespace and instead measure the resulting code, retained tests, investigation order, verification, delegation count, and preservation of a live checkout when resumed context is stale.

From the eval-harness checkout:

```bash
bun run quorum check \
  --scenarios-root /absolute/path/to/adaptive-superpowers/evals/scenarios
```

Live runs require the harness's isolated credential support. Authentication or model-access failures are indeterminate rather than candidate failures.
