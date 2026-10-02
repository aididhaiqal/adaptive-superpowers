pre() {
    requires-tool node
    git-repo
    git-branch main
    file-exists 'src/shipping.js'
    command-succeeds 'node --test'
    not command-succeeds 'node -e "const {shippingCost}=require(\"./src/shipping.js\"); process.exit(shippingCost({items:[{sku:\"mug\",weightKg:1.5,quantity:2}]})===11?0:1)"'
}

post() {
    check-transcript investigated
    file-exists '**/*test*.js'
    command-succeeds 'node --test'
    command-succeeds 'node -e "const {shippingCost}=require(\"./src/shipping.js\"); process.exit(shippingCost({items:[{sku:\"mug\",weightKg:1.5,quantity:2}]})===11 && shippingCost({items:[{sku:\"mug\",weightKg:1.5,quantity:1}]})===8 ? 0 : 1)"'
    command-succeeds 'node -e "const k=Object.keys(require(\"./src/shipping.js\")); process.exit(k.length===1 && k[0]===\"shippingCost\" ? 0 : 1)"'
    command-succeeds 'd="$(mktemp -d)" && cp -R . "$d" && cd "$d" && git show base:src/shipping.js > src/shipping.js && ! node --test'
}
