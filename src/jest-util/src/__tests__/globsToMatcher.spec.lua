-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/__tests__/globsToMatcher.test.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent
local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local it = JestGlobals.it

--[[
		ROBLOX deviation: not using micromatch. Inlining results of calls to micromatch
		original code:
		import micromatch = require('micromatch');
	]]

local globsToMatcher = require(CurrentModule.globsToMatcher).default

it("works like micromatch with only positive globs", function()
	local globs = { "**/*.test.js", "**/*.test.jsx" }
	local matcher = globsToMatcher(globs)

	expect(matcher("some-module.js")).toBe(
		--[[
				ROBLOX deviation: inline micromatch expected result
				original code:
				micromatch(["some-module.js"], globs).length > 0
			]]
		false
	)
	expect(matcher("some-module.test.js")).toBe(
		--[[
				ROBLOX deviation: inline micromatch expected result
				original code:
				micromatch(["some-module.test.js"], globs).length > 0
			]]
		true
	)
end)

it("works like micromatch with a mix of overlapping positive and negative globs", function()
	local globs = { "**/*.js", "!**/*.test.js", "**/*.test.js" }
	local matcher = globsToMatcher(globs)

	expect(matcher("some-module.js")).toBe(
		--[[
				ROBLOX deviation: inline micromatch expected result
				original code:
				micromatch(["some-module.js"], globs).length > 0
			]]
		true
	)
	expect(matcher("some-module.test.js")).toBe(
		--[[
				ROBLOX deviation: inline micromatch expected result
				original code:
				micromatch(["some-module.test.js"], globs).length > 0
			]]
		true
	)
	local globs2 = { "**/*.js", "!**/*.test.js", "**/*.test.js", "!**/*.test.js" }
	local matcher2 = globsToMatcher(globs2)

	expect(matcher2("some-module.js")).toBe(
		--[[
				ROBLOX deviation: inline micromatch expected result
				original code:
				micromatch(["some-module.js" }, globs2).length > 0
			]]
		true
	)
	expect(matcher2("some-module.test.js")).toBe(
		--[[
				ROBLOX deviation: inline micromatch expected result
				original code:
				micromatch(["some-module.test.js" }, globs2).length > 0
			]]
		false
	)
end)

it("works like micromatch with only negative globs", function()
	local globs = { "!**/*.test.js", "!**/*.test.jsx" }
	local matcher = globsToMatcher(globs)

	expect(matcher("some-module.js")).toBe(
		--[[
				ROBLOX deviation: inline micromatch expected result
				original code:
				micromatch(["some-module.js"], globs).length > 0
			]]
		true
	)
	expect(matcher("some-module.test.js")).toBe(
		--[[
				ROBLOX deviation: inline micromatch expected result
				original code:
				micromatch(["some-module.test.js"], globs).length > 0
			]]
		false
	)
end)

it("works like micromatch with empty globs", function()
	local globs = {}
	local matcher = globsToMatcher(globs)

	expect(matcher("some-module.js")).toBe(
		--[[
				ROBLOX deviation: inline micromatch expected result
				original code:
				micromatch(["some-module.js"], globs).length > 0
			]]
		false
	)
	expect(matcher("some-module.test.js")).toBe(
		--[[
				ROBLOX deviation: inline micromatch expected result
				original code:
				micromatch(["some-module.test.js"], globs).length > 0
			]]
		false
	)
end)

it("works like micromatch with pure negated extglobs", function()
	local globs = { "**/*.js", "!(some-module.test.js)" }
	local matcher = globsToMatcher(globs)

	expect(matcher("some-module.js")).toBe(
		--[[
				ROBLOX deviation: inline micromatch expected result
				original code:
				micromatch(["some-module.js"], globs).length > 0
			]]
		true
	)
	expect(matcher("some-module.test.js")).toBe(
		--[[
				ROBLOX deviation: inline micromatch expected result
				original code:
				micromatch(["some-module.test.js"], globs).length > 0
			]]
		false
	)
end)

it("works like micromatch with negated extglobs", function()
	local globs = { "**/*.js", "!(tests|coverage)/*.js" }
	local matcher = globsToMatcher(globs)

	expect(matcher("some-module.js")).toBe(
		--[[
				ROBLOX deviation: inline micromatch expected result
				original code:
				micromatch(["some-module.js"], globs).length > 0
			]]
		false
	)
	expect(matcher("tests/some-module.test.js")).toBe(
		--[[
				ROBLOX deviation: inline micromatch expected result
				original code:
				micromatch(["tests/some-module.test.js"], globs).length > 0
			]]
		false
	)
end)
