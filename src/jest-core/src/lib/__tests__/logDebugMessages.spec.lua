-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-core/src/lib/__tests__/logDebugMessages.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]

return (function()
	local Packages = script.Parent.Parent.Parent.Parent
	local Promise = require(Packages.Promise)

	local RobloxShared = require(Packages.RobloxShared)
	local nodeUtils = RobloxShared.nodeUtils
	local JSON = nodeUtils.JSON
	type NodeJS_WriteStream = RobloxShared.NodeJS_WriteStream

	type Function = (...any) -> ...any

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local it = (JestGlobals.it :: any) :: Function
	local beforeAll = (JestGlobals.beforeAll :: any) :: Function
	local afterAll = (JestGlobals.afterAll :: any) :: Function
	local jestExpect = JestGlobals.expect

	local wrap = require(Packages.Dev.JestSnapshotSerializerRaw).wrap
	local test_utilsModule = require(Packages.Dev.TestUtils)
	local makeGlobalConfig = test_utilsModule.makeGlobalConfig
	local makeProjectConfig = test_utilsModule.makeProjectConfig
	local logDebugMessages = require(script.Parent.Parent.logDebugMessages).default

	-- ROBLOX deviation START: no jest.mock functionality
	-- jest.mock("../../../package.json", function()
	-- 	return { version = 123 }
	-- end)

	-- jest.mock("myRunner", function()
	-- 	return { name = "My Runner" }
	-- end, { virtual = true })
	-- ROBLOX deviation END

	local JestSnapshotSerializerRaw = require(Packages.Dev.JestSnapshotSerializerRaw)

	beforeAll(function()
		jestExpect.addSnapshotSerializer(JestSnapshotSerializerRaw)
	end)

	afterAll(function()
		jestExpect.resetSnapshotSerializers()
	end)

	local function getOutputStream(resolve: (message: string) -> ())
		return {
			write = function(self, message: string)
				resolve(message)
			end,
		} :: NodeJS_WriteStream
	end

	it("prints the jest version", function()
		return Promise.resolve()
			:andThen(function()
				-- ROBLOX deviation START: no expect.assertions functionality
				-- expect:assertions(1)
				-- ROBLOX deviation END
				local message = Promise.new(function(resolve)
					logDebugMessages(
						makeGlobalConfig({ watch = true }),
						makeProjectConfig({ testRunner = "myRunner" }),
						getOutputStream(resolve)
					)
				end):expect()

				jestExpect(JSON.parse(message).version).toBe("27.4.7")
			end)
			:expect()
	end)

	it("prints the test framework name", function()
		return Promise.resolve():andThen(function()
			-- ROBLOX deviation START: no expect.assertions functionality
			-- expect:assertions(1)
			-- ROBLOX deviation END
			local message = Promise.new(function(resolve)
				logDebugMessages(
					makeGlobalConfig({ watch = true }),
					makeProjectConfig({ testRunner = "myRunner" }),
					getOutputStream(resolve)
				)
			end):expect()

			jestExpect(JSON.parse(message).configs.testRunner).toBe("myRunner")
		end)
	end)

	it("prints the config object", function()
		return Promise.resolve():andThen(function()
			-- ROBLOX deviation START: no expect.assertions functionality
			-- expect:assertions(1)
			-- ROBLOX deviation END
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
			jestExpect(wrap(message)).toMatchSnapshot()
		end)
	end)

	return {}
end)()
