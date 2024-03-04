-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-core/src/__tests__/getNoTestsFoundMessage.test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local Object = LuauPolyfill.Object
local getNoTestsFoundMessage = require("../getNoTestsFoundMessage").default

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local describe = JestGlobals.describe
local it = JestGlobals.it
local expect = JestGlobals.expect

describe("getNoTestsFoundMessage", function()
	local function createGlobalConfig(options)
		return Object.assign({}, { rootDir = "/root/dir", testPathPattern = "/path/pattern" }, options)
	end

	-- ROBLOX deviation START: not supported
	-- it("returns correct message when monitoring only failures", function()
	-- 	local config = createGlobalConfig({ onlyFailures = true })
	-- 	expect(getNoTestsFoundMessage({}, config)).toMatchSnapshot()
	-- end)

	-- it("returns correct message when monitoring only changed", function()
	-- 	local config = createGlobalConfig({ onlyChanged = true })
	-- 	expect(getNoTestsFoundMessage({}, config)).toMatchSnapshot()
	-- end)
	-- ROBLOX deviation END

	it("returns correct message with verbose option", function()
		local config = createGlobalConfig({ verbose = true })
		expect(getNoTestsFoundMessage({}, config)).toMatchSnapshot()
	end)

	it("returns correct message without options", function()
		local config = createGlobalConfig()
		expect(getNoTestsFoundMessage({}, config)).toMatchSnapshot()
	end)

	it("returns correct message with passWithNoTests", function()
		local config = createGlobalConfig({ passWithNoTests = true })
		expect(getNoTestsFoundMessage({}, config)).toMatchSnapshot()
	end)
end)
