pre() {
    git-repo
    git-branch main
    git-count commits eq 2
    git-count worktrees eq 2
    file-exists 'host-worktree/local-notes.txt'
    command-succeeds 'test -z "$(git -C host-worktree branch --show-current)"'
    command-succeeds 'test -n "$(git -C host-worktree status --porcelain=v1)"'
    command-succeeds 'test -z "$(git status --porcelain=v1)"'
}

post() {
    git-branch main
    git-count commits eq 2
    git-count worktrees eq 2
    file-exists 'host-worktree/local-notes.txt'
    command-succeeds 'test -z "$(git -C host-worktree branch --show-current)"'
    command-succeeds 'test -n "$(git -C host-worktree status --porcelain=v1)"'
    command-succeeds 'test -z "$(git status --porcelain=v1)"'
    check-transcript investigated
    check-transcript implementation-tool-not-called Write
    check-transcript implementation-tool-not-called Edit
}
