# Behavioral evaluations

These scenarios are consumed by the pinned Superpowers Quorum harness. They avoid assertions tied to the official plugin namespace and instead measure the resulting code, retained tests, investigation order, verification, delegation count, and preservation of a live checkout when resumed context is stale.

From the eval-harness checkout:

```bash
bun run quorum check \
  --scenarios-root /absolute/path/to/adaptive-superpowers/evals/scenarios
```

Live runs require the harness's isolated credential support. Authentication or model-access failures are indeterminate rather than candidate failures.

## Small native execution probe

`probes/existing-coverage/probe.py setup <new-directory>` creates a disposable Git fixture. Give a fresh agent the request in `probes/existing-coverage/request.md`, the target directory, and the exact candidate skill root. Do not give it the checker or expected routing verdict. Then run `probe.py check <directory>`.

Run the baseline before the candidate, with the same host constraints. The checker proves fixture outcomes, not the reasoning path or general model quality. Record which checkout the agent used and any extra artifacts. This simulates a resumed user request; it does not exercise real host compaction. `tests/evals/test_refinement_probe.py` validates the checker against broken behavior, a correct fix, weakened tests, redundant test edits, and bookkeeping churn.
