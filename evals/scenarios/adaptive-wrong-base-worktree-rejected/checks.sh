pre() {
    git-repo
    git-branch feature-reporting
    git-count commits eq 3
    git-count worktrees eq 2
    file-exists 'src/release-only.js'
    file-exists 'src/reporting-work.js'
    file-contains 'docs/progress.md' 'Expected fork point:'
    not file-exists 'src/new-report.js'
    command-succeeds 'test "$(git merge-base feature-reporting main)" != "$(git rev-parse main)"'
    command-succeeds 'test -z "$(git status --porcelain=v1)"'
}

post() {
    git-branch feature-reporting
    git-count commits eq 3
    git-count worktrees eq 2
    file-exists 'src/release-only.js'
    file-exists 'src/reporting-work.js'
    file-contains 'docs/progress.md' 'Expected fork point:'
    not file-exists 'src/new-report.js'
    command-succeeds 'test "$(git merge-base feature-reporting main)" != "$(git rev-parse main)"'
    command-succeeds 'test -z "$(git status --porcelain=v1)"'
    check-transcript investigated
    check-transcript implementation-tool-not-called Write
    check-transcript implementation-tool-not-called Edit
}
