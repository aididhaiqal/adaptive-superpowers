pre() {
    requires-tool node
    git-repo
    git-branch main
    file-exists 'src/server.js'
    not file-exists '**/*test*.js'
}

post() {
    file-exists 'src/server.js'
    command-succeeds 'grep -q "Server ready on port" src/server.js'
    command-succeeds 'node -e "process.exit(typeof require(\"./src/server.js\").start === \"function\" ? 0 : 1)"'
    not file-exists '**/*test*.js'
}
