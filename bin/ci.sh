#!/bin/bash -e

find Packages/Dev -name "*.robloxrc" | xargs rm -f
find Packages/_Index -name "*.robloxrc" | xargs rm -f
roblox-cli analyze jest.project.json
roblox-cli run --load.model jest.project.json --run bin/spec.lua --testService.errorExitCode=1
