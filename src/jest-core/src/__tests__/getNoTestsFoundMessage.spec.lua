-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-core/src/__tests__/getNoTestsFoundMessage.test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

return (function()
	local Packages = script.Parent.Parent.Parent
	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Object = LuauPolyfill.Object
	local getNoTestsFoundMessage = require(script.Parent.Parent.getNoTestsFoundMessage).default

	type Function = (...any) -> ...any

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local describe = (JestGlobals.describe :: any) :: Function
	local it = (JestGlobals.it :: any) :: Function
	-- local itSKIP = JestGlobals.it.skip
	local beforeAll = (JestGlobals.beforeAll :: any) :: Function
	local afterAll = (JestGlobals.afterAll :: any) :: Function
	local jestExpect = JestGlobals.expect
	-- ROBLOX deviation START: this should be added in global jest config
	local ConvertAnsi = require(Packages.PrettyFormat).plugins.ConvertAnsi
	local JestSnapshotSerializerRaw = require(Packages.Dev.JestSnapshotSerializerRaw)

	beforeAll(function()
		jestExpect.addSnapshotSerializer({
			serialize = ConvertAnsi.toHumanReadableAnsi,
			test = ConvertAnsi.test,
		})
		jestExpect.addSnapshotSerializer(JestSnapshotSerializerRaw)
	end)

	afterAll(function()
		jestExpect.resetSnapshotSerializers()
	end)
	-- ROBLOX deviation END

	describe("getNoTestsFoundMessage", function()
		local function createGlobalConfig(options)
			return Object.assign({}, { rootDir = "/root/dir", testPathPattern = "/path/pattern" }, options)
		end

		-- ROBLOX deviation START: not supported
		-- it("returns correct message when monitoring only failures", function()
		-- 	local config = createGlobalConfig({ onlyFailures = true })
		-- 	jestExpect(getNoTestsFoundMessage({}, config)).toMatchSnapshot()
		-- end)

		-- it("returns correct message when monitoring only changed", function()
		-- 	local config = createGlobalConfig({ onlyChanged = true })
		-- 	jestExpect(getNoTestsFoundMessage({}, config)).toMatchSnapshot()
		-- end)
		-- ROBLOX deviation END

		it("returns correct message with verbose option", function()
			local config = createGlobalConfig({ verbose = true })
			jestExpect(getNoTestsFoundMessage({}, config)).toMatchSnapshot()
		end)

		it("returns correct message without options", function()
			local config = createGlobalConfig()
			jestExpect(getNoTestsFoundMessage({}, config)).toMatchSnapshot()
		end)

		it("returns correct message with passWithNoTests", function()
			local config = createGlobalConfig({ passWithNoTests = true })
			jestExpect(getNoTestsFoundMessage({}, config)).toMatchSnapshot()
		end)
	end)

	return {}
end)()
