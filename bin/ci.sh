#!/bin/bash -e

rojo build jest.project.json --output model.rbxmx
roblox-cli analyze jest.project.json
roblox-cli run --load.model model.rbxmx --run bin/spec.lua --fastFlags.overrides "UseDateTimeType3=true" --testService.errorExitCode=1
