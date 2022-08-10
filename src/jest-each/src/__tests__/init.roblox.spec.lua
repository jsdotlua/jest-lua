-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-each/src/__tests__/index.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]
return (function()
	local Packages = script.Parent.Parent.Parent
	type Function = (...any) -> ...any

	require(script.Parent.setup)
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local describe = (JestGlobals.describe :: any) :: Function
	local it = (JestGlobals.it :: any) :: Function

	local NIL = require(script.Parent.Parent.nilPlaceholder)

	local each = require(script.Parent.Parent).default({ it = it })

	describe("array", function()
		describe(".add", function()
			each({ { 0, 0, 0 }, { 0, 1, 1 }, { 1, 1, 2 } }).it(
				"returns the result of adding %s to %s",
				function(a: number, b: number, expected)
					jestExpect(a + b).toBe(expected)
				end
			)
		end)

		-- ROBLOX COMMENT: no upstream test.
		describe("replaces NIL", function()
			each({ { NIL } }).it("properly converts %s to nil before running the tests", function(value: any)
				jestExpect(value).toBe(nil)
			end)
		end)
	end)
	describe("concurrent", function()
		-- ROBLOX TODO: skipping tests as concurrent is not available
		-- describe(".add", function()
		-- 	each({ { 0, 0, 0 }, { 0, 1, 1 }, { 1, 1, 2 } }).test.concurrent(
		-- 		"returns the result of adding %s to %s",
		-- 		function(a, b, expected)
		-- 			return Promise.resolve():andThen(function()
		-- 				jestExpect(a + b).toBe(expected)
		-- 			end)
		-- 		end
		-- 	)
		-- end)
	end)
	describe("template", function()
		describe(".add", function()
			each("a | b | expected", { 0, 0, 0 }, { 0, 1, 1 }, { 1, 1, 2 }).it(
				"returns $expected when given $a and $b",
				function(ref)
					local a: number, b: number, expected = ref.a, ref.b, ref.expected
					jestExpect(a + b).toBe(expected)
				end
			)
		end)

		-- ROBLOX COMMENT: no upstream test.
		describe("templates replaces NIL", function()
			each("expected", { NIL }).it(
				"templates properly convert $expected to nil before running the tests",
				function(ref)
					jestExpect(ref.expected).toBe(nil)
				end
			)
		end)
	end)

	it("throws an error when not called with the right number of arguments", function()
		jestExpect(function()
			return each(
				{ { 1, 1, 2 }, { 1, 2, 3 }, { 2, 1, 3 } },
				"seems like a title but should not be here",
				function() end
			)
		end).toThrowErrorMatchingSnapshot()
	end)

	return {}
end)()
