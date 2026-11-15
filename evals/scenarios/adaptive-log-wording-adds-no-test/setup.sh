#!/usr/bin/env bash
set -euo pipefail

setup-helpers run create_base_repo
cd "$QUORUM_WORKDIR"

mkdir -p src
cat > src/server.js <<'JS'
const http = require('http');

function start(port) {
  const server = http.createServer((req, res) => {
    res.end('ok');
  });
  server.listen(port, () => console.log(`listening on ${port}`));
  return server;
}

module.exports = { start };
JS

git add src/server.js
git commit -qm "add server module"
