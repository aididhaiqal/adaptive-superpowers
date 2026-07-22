pre() {
    git-repo
    git-branch other-session
    git-count commits eq 1
    git-count worktrees eq 1
    file-exists 'src/other-session.js'
    not file-exists 'src/feature.js'
    command-succeeds 'test "$(git status --porcelain=v1)" = "?? src/other-session.js"'
}

post() {
    git-branch other-session
    git-count commits eq 1
    git-count worktrees eq 1
    command-succeeds 'test "$(git hash-object src/other-session.js)" = e27bdb5e39a89a9febf4242ad264c829f4e4d932'
    command-succeeds 'test "$(git status --porcelain=v1)" = "?? src/other-session.js"'
    not file-exists 'src/feature.js'
    check-transcript investigated
    check-transcript implementation-tool-not-called Write
    check-transcript implementation-tool-not-called Edit
}
