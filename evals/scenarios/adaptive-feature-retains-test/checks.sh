pre() {
    requires-tool node
    git-repo
    git-branch main
    not file-exists 'src/greeting.js'
}

post() {
    file-exists 'src/greeting.js'
    file-exists '**/*test*.js'
    command-succeeds 'node -e "const {formatGreeting}=require(\"./src/greeting.js\"); process.exit(formatGreeting(\"Ada\")==\"Hello, Ada!\" && formatGreeting(\"  Lin  \")==\"Hello, Lin!\" && formatGreeting(\"   \")==\"Hello, stranger!\" ? 0 : 1)"'
    command-succeeds 'node --test'
    check-transcript tool-count Agent lte 1
}
