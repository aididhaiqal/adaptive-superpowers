#!/usr/bin/env bash
set -euo pipefail

setup-helpers run create_base_repo
cd "$QUORUM_WORKDIR"

git switch -qc other-session
mkdir -p src
printf '%s\n' 'other session work' > src/other-session.js
