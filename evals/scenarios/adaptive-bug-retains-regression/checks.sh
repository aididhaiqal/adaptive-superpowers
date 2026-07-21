pre() {
    requires-tool node
    git-repo
    git-branch main
    file-exists 'src/pricing.js'
    not command-succeeds 'node -e "const {finalPrice}=require(\"./src/pricing.js\"); process.exit(finalPrice(100,\"BOGUS\")===100?0:1)"'
}

post() {
    check-transcript investigated
    command-succeeds 'node -e "const {getDiscountRate}=require(\"./src/pricing.js\"); const rate=getDiscountRate(\"BOGUS\"); process.exit(typeof rate===\"number\" && !Number.isNaN(rate) ? 0 : 1)"'
    command-succeeds 'node -e "const {finalPrice}=require(\"./src/pricing.js\"); process.exit(finalPrice(100,\"BOGUS\")===100 && finalPrice(100,\"SAVE10\")===90 ? 0 : 1)"'
    file-exists '**/*test*.js'
    command-succeeds 'node --test'
}
