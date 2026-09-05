# Codex adapter

Codex discovers the canonical root `skills/` tree through `.codex-plugin/plugin.json`. Use `scripts/stage-adapter.sh codex <new-directory>` for isolated evaluation. The adapter contains packaging metadata only; workflow behavior remains in the shared skills.

Each skill's `agents/openai.yaml` supplies presentation metadata only; implicit invocation remains enabled by default. `python3 scripts/check-installation.py --host codex` compares the selected on-disk skill tree and its discoverable version with this checkout. Use `--codex-skills` for another location. This is an on-demand source-repository utility, not a staged plugin hook or proof of active-session loading.
