-- ROBLOX upstream: https://github.com/facebook/jest/tree/v28.0.0/packages/jest-util/src/__tests__/isInteractive.test.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent
local isInteractive = require(CurrentModule.isInteractive).default

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

-- ROBLOX deviation START: no equivalent in Lua. Always returning false
describe("isInteractive", function()
	it("Returns false", function()
		expect(isInteractive).toBe(false)
	end)
end)
-- local oldIsTTY: typeof(__unhandledIdentifier__ --[[ ROBLOX TODO: Unhandled node for type: TSQualifiedName ]] --[[ process.stdout.isTTY ]])
-- local oldTERM: string | any --[[ ROBLOX TODO: Unhandled node for type: TSUndefinedKeyword ]] --[[ undefined ]]
-- beforeEach(function()
-- 	oldIsTTY = process.stdout.isTTY
-- 	oldTERM = process.env.TERM
-- end)
-- afterEach(function()
-- 	process.stdout.isTTY = oldIsTTY
-- 	process.env.TERM = oldTERM
-- 	jest:resetModules()
-- end)
-- it("Returns true when running on interactive environment", function()
-- 	jest:doMock("ci-info", function()
-- 		return { isCI = false }
-- 	end)
-- 	process.stdout.isTTY = true
-- 	process.env.TERM = "xterm-256color"
-- 	local isInteractive = require("../isInteractive").default
-- expect(isInteractive).toBe(true)
-- end)
-- it("Returns false when running on a non-interactive environment", function()
-- 	local isInteractive
-- 	local expectedResult = false -- Test with isCI being true and isTTY false
-- 	jest:doMock("ci-info", function()
-- 		return { isCI = true }
-- 	end)
-- 	process.stdout.isTTY = nil
-- 	process.env.TERM = "xterm-256color"
-- 	isInteractive = require("../isInteractive").default
-- expect(isInteractive).toBe(expectedResult) -- Test with isCI being false and isTTY false
-- 	jest:resetModules()
-- 	jest:doMock("ci-info", function()
-- 		return { isCI = false }
-- 	end)
-- 	process.stdout.isTTY = nil
-- 	process.env.TERM = "xterm-256color"
-- 	isInteractive = require("../isInteractive").default
-- expect(isInteractive).toBe(expectedResult) -- Test with isCI being true and isTTY true
-- 	jest:resetModules()
-- 	jest:doMock("ci-info", function()
-- 		return { isCI = true }
-- 	end)
-- 	process.stdout.isTTY = true
-- 	process.env.TERM = "xterm-256color"
-- 	isInteractive = require("../isInteractive").default
-- expect(isInteractive).toBe(expectedResult) -- Test with dumb terminal
-- 	jest:resetModules()
-- 	jest:doMock("ci-info", function()
-- 		return { isCI = false }
-- 	end)
-- 	process.stdout.isTTY = nil
-- 	process.env.TERM = "dumb"
-- 	isInteractive = require("../isInteractive").default
-- expect(isInteractive).toBe(expectedResult)
-- end)

-- ROBLOX deviation END
