#!/bin/bash

set -x

echo "Run static analysis"
selene src
stylua -c src
robloxdev-cli analyze jest.project.json --fastFlags.allOnLuau

echo "Run tests"
robloxdev-cli run --load.model jest.project.json --run bin/spec.lua --testService.errorExitCode=1 --fastFlags.allOnLuau --fastFlags.overrides EnableLoadModule=true DebugDisableOptimizedBytecode=true --lua.globals=UPDATESNAPSHOT=false --lua.globals=CI=false --load.asRobloxScript --fs.readwrite="$(pwd)"
# robloxdev-cli run --load.model jest.project.json --run bin/spec.lua --testService.errorExitCode=1 --fastFlags.allOnLuau --fastFlags.overrides EnableLoadModule=true DebugDisableOptimizedBytecode=true  --lua.globals=UPDATESNAPSHOT=true --lua.globals=CI=true --load.asRobloxScript --fs.readwrite="$(pwd)"
