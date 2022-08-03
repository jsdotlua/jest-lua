#!/bin/bash -e
selene src
stylua -c src
robloxdev-cli analyze jest.project.json --fastFlags.allOnLuau
robloxdev-cli run --load.model jest.project.json --run bin/spec.lua --testService.errorExitCode=1 --fastFlags.allOnLuau --fastFlags.overrides EnableLoadModule=true DebugDisableOptimizedBytecode=true
# robloxdev-cli run --load.model jest.project.json --run bin/spec.lua --testService.errorExitCode=1 --fastFlags.allOnLuau --fastFlags.overrides EnableLoadModule=true DebugDisableOptimizedBytecode=true --lua.globals=UPDATESNAPSHOT="all" --load.asRobloxScript --fs.readwrite="$(pwd)"