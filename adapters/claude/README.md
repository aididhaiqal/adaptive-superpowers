# Claude Code adapter

Claude Code loads the repository with `--plugin-dir`. The root `.claude-plugin/` manifest and `hooks/session-start` expose the canonical `skills/` tree and inject the shared router on startup. The adapter does not redefine workflow policy.
