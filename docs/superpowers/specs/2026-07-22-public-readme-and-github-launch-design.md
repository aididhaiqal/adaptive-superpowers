# Public README and GitHub Launch Design

## Goal

Publish the project as the public `aididhaiqal/adaptive-superpowers` repository with a README that presents it as risk-adaptive Superpowers optimized and tested for GPT-5.6 and Claude 5-family coding models.

## README structure

Use a product-first narrative:

1. Lead with the project name, model focus, and one-paragraph value proposition.
2. Explain the problem: model autonomy can skip safeguards, while fixed workflow chains can add unnecessary ceremony.
3. Show how the always-loaded adaptive gate selects read-only, fast-path, or fuller workflow behavior.
4. Provide copyable installation instructions for Codex and Claude Code.
5. Report the tested model matrix and retained-test benchmark results, clearly separating timing from correctness evidence.
6. Explain repository architecture, local validation, safety boundaries, provenance, and MIT licensing.

The README will describe version 0.1.0 as experimental but usable. It will not claim endorsement by the official Superpowers project or universal performance improvements.

## Publication

Keep the current `eval/optimized-adaptive-router` history, commit the README revision, create the public GitHub repository, add it as `origin`, and push the current branch. Because this is a new standalone repository with no existing default branch, publish the validated current branch as `main` rather than opening a pull request against a nonexistent base.

Raw model trajectories, credentials, and ignored evaluation artifacts remain local. Only tracked source, tests, documentation, and summarized evaluation evidence are published.

## Verification

Before publication:

- run `bash tests/run-all.sh`;
- run `git diff --check`;
- inspect the tracked file list for secrets and raw trajectories;
- verify the README installation commands match the adapter scripts and manifests;
- verify the GitHub repository is public after pushing.
