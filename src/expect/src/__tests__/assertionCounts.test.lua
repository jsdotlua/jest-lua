-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/expect/src/__tests__/assertionCounts.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]
local Packages = script.Parent.Parent.Parent
local JestGlobals = require(Packages.Dev.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local alignedAnsiStyleSerializer = require(Packages.Dev.TestUtils).alignedAnsiStyleSerializer
local jestExpect = require(script.Parent.Parent)

expect.addSnapshotSerializer(alignedAnsiStyleSerializer)

describe(".assertions()", function()
	it("does not throw", function()
		jestExpect.assertions(2)
		jestExpect("a").never.toBe("b")
		jestExpect("a").toBe("a")
	end)

	it("redeclares different assertion count", function()
		jestExpect.assertions(3)
		jestExpect("a").never.toBe("b")
		jestExpect("a").toBe("a")
		jestExpect.assertions(2)
	end)
	it("expects no assertions", function()
		jestExpect.assertions(0)
	end)
end)
describe(".hasAssertions()", function()
	it("does not throw if there is an assertion", function()
		jestExpect.hasAssertions()
		jestExpect("a").toBe("a")
	end)

	it("throws if expected is not undefined", function()
		jestExpect(function()
			-- @ts-expect-error
			(jestExpect.hasAssertions :: any)(2)
		end).toThrowErrorMatchingSnapshot()
	end)

	it("hasAssertions not leaking to global state", function() end)
end)
