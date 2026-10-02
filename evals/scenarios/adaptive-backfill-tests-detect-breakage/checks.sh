pre() {
    requires-tool node
    requires-tool perl
    git-repo
    git-branch main
    file-exists 'src/tax.js'
    not file-exists '**/*test*.js'
}

post() {
    file-exists '**/*test*.js'
    command-succeeds 'node --test'
    command-succeeds 'git diff --quiet base -- src/tax.js'
    command-succeeds 'd="$(mktemp -d)" && cp -R . "$d" && cd "$d" && perl -0pi -e "s/STANDARD_RATE = 0\.2;/STANDARD_RATE = 0.25;/ or die" src/tax.js && ! node --test'
    command-succeeds 'd="$(mktemp -d)" && cp -R . "$d" && cd "$d" && perl -0pi -e "s/new Set\(\[.food., .books.\]\)/new Set([])/ or die" src/tax.js && ! node --test'
    command-succeeds 'd="$(mktemp -d)" && cp -R . "$d" && cd "$d" && perl -0pi -e "s/Math\.round\(amount \* STANDARD_RATE \* 100\) \/ 100;/amount * STANDARD_RATE;/ or die" src/tax.js && ! node --test'
    command-succeeds 'd="$(mktemp -d)" && cp -R . "$d" && cd "$d" && perl -0pi -e "s/throw new RangeError\(.amount must not be negative.\);/return -1;/ or die" src/tax.js && ! node --test'
}
