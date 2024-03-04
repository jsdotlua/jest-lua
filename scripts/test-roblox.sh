#!/bin/sh

set -e

DARKLUA_CONFIG=.darklua-tests.json
OUTPUT=build/debug/test-place.rbxl

rm -rf roblox
rm -f $OUTPUT

mkdir -p roblox

cp -rL node_modules/ roblox/
cp -r roblox-model/ roblox/
mkdir roblox/scripts
cp scripts/run-roblox-tests.lua roblox/scripts/
cp scripts/jest-setup.lua roblox/scripts/

cp test-place.project.json roblox
cp jest.config.lua roblox

rojo sourcemap roblox/test-place.project.json -o roblox/sourcemap.json

cp $DARKLUA_CONFIG roblox

darklua process --config roblox/$DARKLUA_CONFIG roblox/scripts/run-roblox-tests.lua roblox/scripts/run-roblox-tests.lua
darklua process --config roblox/$DARKLUA_CONFIG roblox/scripts/jest-setup.lua roblox/scripts/jest-setup.lua
darklua process --config roblox/$DARKLUA_CONFIG roblox/roblox-model roblox/roblox-model
darklua process --config roblox/$DARKLUA_CONFIG roblox/node_modules roblox/node_modules

mkdir -p $(dirname $OUTPUT)

rojo build roblox/test-place.project.json -o $OUTPUT

run-in-roblox --place $OUTPUT --script roblox/scripts/run-roblox-tests.lua
