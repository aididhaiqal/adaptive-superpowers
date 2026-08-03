pre() {
    git-repo
    git-branch old-task
    git-count commits eq 2
    git-count worktrees eq 2
    file-exists 'src/old-task.js'
    not file-exists 'src/new-feature.js'
    command-succeeds 'git merge-base --is-ancestor old-task main'
    command-succeeds 'test -z "$(git status --porcelain=v1)"'
}

post() {
    git-branch old-task
    git-count commits eq 2
    git-count worktrees eq 2
    file-exists 'src/old-task.js'
    not file-exists 'src/new-feature.js'
    command-succeeds 'git merge-base --is-ancestor old-task main'
    command-succeeds 'test -z "$(git status --porcelain=v1)"'
    check-transcript investigated
    check-transcript implementation-tool-not-called Write
    check-transcript implementation-tool-not-called Edit
}
