pre() {
    git-repo
    git-branch main
    git-count commits eq 2
    git-count worktrees eq 2
    not file-exists 'src/failing-task.js'
    file-exists '.worktrees/failing-task/src/failing-task.js'
    command-succeeds './verify.sh'
    command-succeeds 'test -z "$(git status --porcelain=v1)"'
}

post() {
    git-branch main
    git-count commits eq 3
    git-count worktrees eq 2
    file-exists 'src/failing-task.js'
    file-exists '.worktrees/failing-task'
    command-succeeds 'git show-ref --verify --quiet refs/heads/feature-failing'
    command-succeeds '! ./verify.sh'
    command-succeeds 'test -z "$(git status --porcelain=v1)"'
    check-transcript investigated
}
