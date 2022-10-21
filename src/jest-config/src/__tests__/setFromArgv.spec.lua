-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-config/src/__tests__/setFromArgv.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]

local Packages = script.Parent.Parent.Parent
local typesModule = require(Packages.JestTypes)

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local it = JestGlobals.it

type Config_Argv = typesModule.Config_Argv
type Config_InitialOptions = typesModule.Config_InitialOptions
local setFromArgv = require(script.Parent.Parent.setFromArgv).default

it("maps special values to valid options", function()
	local options = {} :: Config_InitialOptions
	local argv = { coverage = true, env = "node", json = true, watchAll = true } :: Config_Argv
	expect(setFromArgv(options, argv)).toMatchObject({
		-- ROBLOX deviation START: not supported
		-- collectCoverage = true,
		-- testEnvironment = "node",
		-- ROBLOX deviation END
		useStderr = true,
		-- ROBLOX deviation START: not supported
		-- watch = false,
		-- ROBLOX deviation END
		watchAll = true,
	})
end)

-- ROBLOX deviation START: not supported
-- it("maps regular values to themselves", function()
-- 	local options = {} :: Config_InitialOptions
-- 	local argv = {
-- 		collectCoverageOnlyFrom = { "a", "b" },
-- 		coverageDirectory = "covDir",
-- 		watchman = true,
-- 	} :: Config_Argv
-- 	expect(setFromArgv(options, argv)).toMatchObject({
-- 		collectCoverageOnlyFrom = { "a", "b" },
-- 		coverageDirectory = "covDir",
-- 		watchman = true,
-- 	})
-- end)

-- it("works with string objects", function()
-- 	local options = {} :: Config_InitialOptions
-- 	local argv = {
-- 		moduleNameMapper = '{"types/(.*)": "<rootDir>/src/types/$1", "types2/(.*)": ["<rootDir>/src/types2/$1", "<rootDir>/src/types3/$1"]}',
-- 		testEnvironmentOptions = '{"userAgent": "Agent/007"}',
-- 		transform = '{"*.js": "<rootDir>/transformer"}',
-- 	} :: Config_Argv
-- 	expect(setFromArgv(options, argv)).toMatchObject({
-- 		moduleNameMapper = {
-- 			["types/(.*)"] = "<rootDir>/src/types/$1",
-- 			["types2/(.*)"] = { "<rootDir>/src/types2/$1", "<rootDir>/src/types3/$1" },
-- 		},
-- 		testEnvironmentOptions = { userAgent = "Agent/007" },
-- 		transform = { ["*.js"] = "<rootDir>/transformer" },
-- 	})
-- end)
-- ROBLOX deviation END

it("explicit flags override those from --config", function()
	local options = {} :: Config_InitialOptions
	local argv = { config = '{"watch": false}', watch = true } :: Config_Argv
	expect(setFromArgv(options, argv)).toMatchObject({ watch = true })
end)
