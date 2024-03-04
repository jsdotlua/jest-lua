-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-core/src/lib/__tests__/logDebugMessages.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]

local Promise = require("@pkg/@jsdotlua/promise")

local RobloxShared = require("@pkg/@jsdotlua/jest-roblox-shared")
local nodeUtils = RobloxShared.nodeUtils
local JSON = nodeUtils.JSON
type NodeJS_WriteStream = RobloxShared.NodeJS_WriteStream

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll
local expect = JestGlobals.expect

local test_utilsModule = require("@pkg/@jsdotlua/test-utils")
local makeGlobalConfig = test_utilsModule.makeGlobalConfig
local makeProjectConfig = test_utilsModule.makeProjectConfig
local logDebugMessages = require("../logDebugMessages").default

-- ROBLOX deviation START: no jest.mock functionality
-- jest.mock("../../../package.json", function()
-- 	return { version = 123 }
-- end)

-- jest.mock("myRunner", function()
-- 	return { name = "My Runner" }
-- end, { virtual = true })
-- ROBLOX deviation END

local JestSnapshotSerializerRaw = require("@pkg/@jsdotlua/jest-snapshot-serializer-raw")

beforeAll(function()
	expect.addSnapshotSerializer(JestSnapshotSerializerRaw)
end)

local function getOutputStream(resolve: (message: string) -> ())
	return {
		write = function(self, message: string)
			resolve(message)
		end,
	} :: NodeJS_WriteStream
end

it("prints the jest version", function()
	return Promise.resolve():andThen(function()
		expect.assertions(1)
		local message = Promise.new(function(resolve)
			logDebugMessages(
				makeGlobalConfig({ watch = true }),
				makeProjectConfig({ testRunner = "myRunner" }),
				getOutputStream(resolve)
			)
		end):expect()

		expect(JSON.parse(message).version).toBe("27.4.7")
	end)
end)

it("prints the test framework name", function()
	return Promise.resolve():andThen(function()
		expect.assertions(1)
		local message = Promise.new(function(resolve)
			logDebugMessages(
				makeGlobalConfig({ watch = true }),
				makeProjectConfig({ testRunner = "myRunner" }),
				getOutputStream(resolve)
			)
		end):expect()

		expect(JSON.parse(message).configs.testRunner).toBe("myRunner")
	end)
end)

-- ROBLOX FIXME: the order of keys in the prited object changes after upgrade
it.skip("prints the config object", function()
	return Promise.resolve():andThen(function()
		expect.assertions(1)
		local globalConfig = makeGlobalConfig({ watch = true })
		local config = makeProjectConfig({
			automock = false,
			rootDir = "/path/to/dir",
			roots = { "path/to/dir/test" },
			testRunner = "myRunner",
		})
		local message = Promise.new(function(resolve)
			logDebugMessages(globalConfig, config, getOutputStream(resolve))
		end):expect()
		expect(message).toMatchSnapshot()
	end)
end)
