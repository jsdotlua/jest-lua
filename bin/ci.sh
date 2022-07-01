#!/bin/bash -e
selene src
stylua -c src
roblox-cli analyze jest.project.json --fastFlags.allOnLuau
roblox-cli run --load.model jest.project.json --run bin/spec.lua --testService.errorExitCode=1 --fastFlags.allOnLuau --fastFlags.overrides EnableLoadModule=true
# roblox-cli run --load.model jest.project.json --run bin/spec.lua --testService.errorExitCode=1 --fastFlags.allOnLuau --lua.globals=UPDATESNAPSHOT="all" --load.asRobloxScript --fs.readwrite="$(pwd)" --fastFlags.overrides EnableLoadModule=true