pre() {
    requires-tool node
    git-repo
    git-branch main
    command-succeeds 'node --test'
    file-contains 'src/pricing.js' '__resetForTests'
    file-contains 'test/pricing.test.js' 'returns the configured stub'
}

post() {
    command-succeeds 'node --test'
    not file-contains 'test/pricing.test.js' 'returns the configured stub'
    not file-contains 'test/pricing.test.js' '__lookupCountForTests'
    not file-contains 'src/pricing.js' '__resetForTests'
    not file-contains 'src/pricing.js' '__lookupCountForTests'
    not file-contains 'src/pricing.js' 'lookups'
    file-contains 'test/pricing.test.js' 'BOGUS'
    file-exists 'test/config-contract.test.js'
    file-contains 'test/config-contract.test.js' 'retryLimit'
    command-succeeds 'node -e "const {finalPrice}=require(\"./src/pricing.js\"); process.exit(finalPrice(100,\"BOGUS\")===100 && finalPrice(100,\"SAVE10\")===90 ? 0 : 1)"'
}
