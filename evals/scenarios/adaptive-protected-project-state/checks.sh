pre() {
    requires-tool node
    git-repo
    git-branch main
    not command-succeeds 'node --test'
    file-contains 'docs/progress.md' 'atlas-watch-1'
}

post() {
    command-succeeds 'node --test'
    file-contains 'docs/progress.md' 'profile-name-1'
    file-contains 'docs/progress.md' 'atlas-watch-1'
    file-contains 'docs/progress.md' 'future-watch'
    not file-exists 'docs/project-evidence/atlas-watch-1.md'
}
