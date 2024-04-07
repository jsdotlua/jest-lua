#!/bin/sh

set -e

rm -rf roblox/node_modules

mkdir -p roblox

cp -rL node_modules roblox/

./scripts/remove-tests.sh roblox/node_modules

rm -rf build/wally

for module_path in src/*; do
    module_name=$(basename $module_path)

    original_package=node_modules/@jsdotlua/$module_name

    if [ -f $original_package/package.json ]; then
        echo Process package $module_name

        wally_package=build/wally/$module_name
        roblox_package=roblox/node_modules/@jsdotlua/$module_name

        mkdir -p $wally_package
        mkdir -p $wally_package/src
        cp LICENSE $wally_package/LICENSE
        node ./scripts/npm-to-wally.js $roblox_package/package.json $wally_package/wally.toml $wally_package/default.project.json $roblox_package/wally-package.project.json --workspace-path src

        cp .darklua-wally.json $roblox_package
        cp -r roblox/node_modules/.luau-aliases/* $roblox_package

        rojo sourcemap $roblox_package/wally-package.project.json --output $roblox_package/sourcemap.json

        darklua process --config $roblox_package/.darklua-wally.json $roblox_package/src $wally_package/src

        wally package --project-path $wally_package --list

        echo ""
    fi
done

