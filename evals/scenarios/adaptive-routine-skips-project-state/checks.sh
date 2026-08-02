pre() {
    requires-tool node
    git-repo
    git-branch main
    not command-succeeds 'node --test'
}

post() {
    command-succeeds 'node --test'
    file-exists 'test/profile.test.js'
    not file-exists '.superpowers/project-state.yaml'
    not file-exists 'docs/progress.md'
    not file-exists 'docs/project-evidence'
}
