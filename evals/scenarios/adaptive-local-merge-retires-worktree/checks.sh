pre() {
    git-repo
    git-branch main
    git-count commits eq 2
    git-count worktrees eq 2
    not file-exists 'src/finished-task.js'
    file-exists '.worktrees/finished-task/src/finished-task.js'
    command-succeeds 'test -z "$(git status --porcelain=v1)"'
}

post() {
    git-branch main
    git-count commits eq 3
    git-count worktrees eq 1
    file-exists 'src/finished-task.js'
    not file-exists '.worktrees/finished-task'
    command-succeeds '! git show-ref --verify --quiet refs/heads/feature-finished'
    command-succeeds 'test -z "$(git status --porcelain=v1)"'
    check-transcript investigated
}
