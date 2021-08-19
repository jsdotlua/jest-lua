#!/bin/bash -e

roblox-cli analyze jest.project.json
roblox-cli run --load.model jest.project.json --run bin/spec.lua --testService.errorExitCode=1
