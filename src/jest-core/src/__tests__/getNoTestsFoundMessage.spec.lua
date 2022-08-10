-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-core/src/__tests__/getNoTestsFoundMessage.test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local Packages = script.Parent.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
local getNoTestsFoundMessage = require(script.Parent.Parent.getNoTestsFoundMessage).default

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local describe = (JestGlobals.describe :: any) :: Function
local it = (JestGlobals.it :: any) :: Function
local jestExpect = JestGlobals.expect

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
