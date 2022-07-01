#!/bin/bash -e
roblox-cli run --load.model jest.project.json --run bin/new-runtime-example.lua --testService.errorExitCode=1 --fastFlags.allOnLuau --fastFlags.overrides EnableLoadModule=true
