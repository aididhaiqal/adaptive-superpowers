pre() {
    requires-tool node
    git-repo
    git-branch main
    not command-succeeds 'node --test'
    not file-exists 'src/account-import.js'
}

post() {
    command-succeeds './scripts/check-all'
    file-exists '**/*test*.js'
    not file-exists 'src/account-import.js'
    command-succeeds 'test "$(find docs -type f -path "*/plans/*" 2>/dev/null | wc -l | tr -d " ")" -le 1'
    command-succeeds 'test -s .evidence/focused.log'
    command-succeeds 'test "$(wc -l < .evidence/full.log | tr -d " ")" -le 2'
}
