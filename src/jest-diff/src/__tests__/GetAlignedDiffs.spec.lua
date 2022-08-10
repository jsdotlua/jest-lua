-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-diff/src/__tests__/getAlignedDiffs.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

return (function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	type Function = (...any) -> ...any

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local describe = (JestGlobals.describe :: any) :: Function
	local it = (JestGlobals.it :: any) :: Function
	local beforeAll = (JestGlobals.beforeAll :: any) :: Function
	local afterAll = (JestGlobals.afterAll :: any) :: Function

	local diffStringsUnified = require(CurrentModule.PrintDiffs).diffStringsUnified

	-- 1. Use options to omit line colors.
	local identity = function(s)
		return s
	end
	-- ROBLOX FIXME Luau: Luau should know s is string since changeColor var gets assigned to options, which gets passed to a function that types that table's field as DiffOptionsColor = (string) -> string
	local changeColor = function(s: string)
		return "<i>" .. s .. "</i>"
	end
	local options = {
		aColor = identity,
		bColor = identity,
		changeColor = changeColor,
		commonColor = identity,
		omitAnnotationLines = true,
		patchColor = identity,
	}

	local function testAlignedDiffs(a: string, b: string): string
		return diffStringsUnified(a, b, options)
	end

	beforeAll(function()
		jestExpect.addSnapshotSerializer({
			serialize = function(val: string)
				return val
			end,
			test = function(val: any)
				return typeof(val) == "string"
			end,
		})
	end)

	afterAll(function()
		jestExpect.resetSnapshotSerializers()
	end)

	describe("getAlignedDiffs", function()
		describe("lines", function()
			it("change preceding and following common", function()
				local a = "delete\ncommon between changes\nprev"
				local b = "insert\ncommon between changes\nnext"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("common preceding and following change", function()
				local a = "common preceding\ndelete\ncommon following"
				local b = "common preceding\ninsert\ncommon following"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("common at end when both current change lines are empty", function()
				local a = "delete\ncommon at end"
				local b = "common at end"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("common between delete and insert", function()
				local a = "delete\ncommon between changes"
				local b = "common between changes\ninsert"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("common between insert and delete", function()
				local a = "common between changes\ndelete"
				local b = "insert\ncommon between changes"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)
		end)

		describe("newline", function()
			it("delete only", function()
				local a = "preceding\nfollowing"
				local b = "precedingfollowing"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("insert only", function()
				local a = "precedingfollowing"
				local b = "preceding\nfollowing"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("delete with adjacent change", function()
				local a = "preceding\nfollowing"
				local b = "precededfollowing"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("insert with adjacent changes", function()
				local a = "precededfollowing"
				local b = "preceding\nFollowing"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("change from space", function()
				local a = "preceding following"
				local b = "preceding\nfollowing"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("change to space", function()
				local a = "preceding\nfollowing"
				local b = "preceding following"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)
		end)

		describe("substrings first", function()
			it("common when both current change lines are empty", function()
				local a = "first\nmiddle\nlast prev"
				local b = "insert\nfirst\nmiddle\nlast next"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("common when either current change line is non-empty", function()
				local a = "expected first\n\nlast"
				local b = "first\n\nlast"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("delete completes the current line", function()
				local a = "common preceding first\nmiddle\nlast and following"
				local b = "common preceding and following"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("insert completes the current line", function()
				local a = "common preceding"
				local b = "common preceding first\nmiddle\n"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)
		end)

		describe("substrings middle", function()
			it("is empty in delete between common", function()
				local a = "common at start precedes delete\n\nexpected common at end"
				local b = "common at start precedes received common at end"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("is empty in insert at start", function()
				local a = "expected common at end"
				local b = "insert line\n\nreceived common at end"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("is non-empty in delete at end", function()
				local a = "common at start precedes delete\nnon-empty line\nnext"
				local b = "common at start precedes prev"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("is non-empty in insert between common", function()
				local a = "common at start precedes delete expected"
				local b = "common at start precedes insert\nnon-empty\nreceived"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)
		end)

		describe("substrings last", function()
			it("is empty in delete at end", function()
				local a = "common string preceding prev\n"
				local b = "common string preceding next"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("is empty in insert at end", function()
				local a = "common string preceding prev"
				local b = "common string preceding next\n"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("is non-empty in common not at end", function()
				local a = "common first\nlast expected"
				local b = "common first\nlast received"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)
		end)

		describe("strings", function()
			it("change at start and delete or insert at end", function()
				local a = "prev change common delete\nunchanged\nexpected change common"
				local b = "next change common\nunchanged\nreceived change common insert"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)

			it("delete or insert at start and change at end", function()
				local a = "common change prev\nunchanged\ndelete common change this"
				local b = "insert common change next\nunchanged\ncommon change that"
				jestExpect(testAlignedDiffs(a, b)).toMatchSnapshot()
			end)
		end)
	end)

	return {}
end)()
