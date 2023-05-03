-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-diff/src/__tests__/diffStringsRaw.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local DIFF_DELETE = require(CurrentModule).DIFF_DELETE
local DIFF_EQUAL = require(CurrentModule).DIFF_EQUAL
local DIFF_INSERT = require(CurrentModule).DIFF_INSERT
local Diff = require(CurrentModule).Diff
local diffStringsRaw = require(CurrentModule).diffStringsRaw

describe("diffStringsRaw", function()
	it("one-line with cleanup", function()
		local expected = {
			Diff.new(DIFF_EQUAL, "change "),
			Diff.new(DIFF_DELETE, "from"),
			Diff.new(DIFF_INSERT, "to"),
		}
		local received = diffStringsRaw("change from", "change to", true)
		expect(received).toEqual(expected)
	end)

	it("one-line without cleanup", function()
		local expected = {
			Diff.new(DIFF_EQUAL, "change "),
			Diff.new(DIFF_DELETE, "fr"),
			Diff.new(DIFF_INSERT, "t"),
			Diff.new(DIFF_EQUAL, "o"),
			Diff.new(DIFF_DELETE, "m"),
		}
		local received = diffStringsRaw("change from", "change to", false)
		expect(received).toEqual(expected)
	end)
end)
