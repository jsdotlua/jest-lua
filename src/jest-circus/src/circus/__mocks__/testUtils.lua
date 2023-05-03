-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-circus/src/__mocks__/testUtils.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local exports = {}
type ExecaSyncReturnValue = any

type Result = ExecaSyncReturnValue & { status: number, error_: string }
local function runTest(source: string)
	local content = ([[
		return function(script_)
			-- ROBLOX deviation START
			local Module = require(script_.Parent.Module)
			Module.resetModules()
			local require = Module.requireOverride
			local LuauPolyfill = require(script_.Parent.Parent.Parent.Parent.LuauPolyfill)
			local Array = LuauPolyfill.Array
			local Error = LuauPolyfill.Error
			local console = LuauPolyfill.console

			local stdout = {}

			local function getStdout()
				return Array.join(stdout, "\n")
			end

			local function log(...)
				table.insert(stdout, Array.join({ ... }, " "))
			end

			console.log = log

			local global = getfenv()
			-- ROBLOX deviation END

			local circus = require(script_.Parent.Parent)


			global.test = circus.test
			global.describe = circus.describe
			global.beforeEach = circus.beforeEach
			global.afterEach = circus.afterEach
			global.beforeAll = circus.beforeAll
			global.afterAll = circus.afterAll

			local testEventHandler = require(script_.Parent.testEventHandler).default
			local addEventHandler = require(script_.Parent.Parent.state).addEventHandler
			addEventHandler(testEventHandler)

			%s

			local run = require(script_.Parent.Parent.run).default

			run();

			return getStdout()
		end
  ]]):format(source)

	local getTest, error_ = loadstring(content)

	assert(getTest, ("Error while loading code: %s"):format(tostring(error_)))

	local run = getTest()

	local stdout = run(script)

	return {
		stdout = stdout,
	}
end
exports.runTest = runTest
return exports
