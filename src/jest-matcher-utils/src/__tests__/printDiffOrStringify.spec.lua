-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-matcher-utils/src/__tests__/printDiffOrStringify.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local Symbol = require(Packages.LuauPolyfill).Symbol

local printDiffOrStringify = require(CurrentModule).printDiffOrStringify
-- ROBLOX deviation: omitted INVERTED_COLOR import because it doesn't have an
-- actual implementation yet

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll
local afterAll = JestGlobals.afterAll

local alignedAnsiStyleSerializer = require(Packages.Dev.TestUtils).alignedAnsiStyleSerializer

local LuauPolyfill = require(Packages.LuauPolyfill)
type Array<T> = LuauPolyfill.Array<T>
type Map<X, Y> = { [X]: Y }

beforeAll(function()
	jestExpect.addSnapshotSerializer(alignedAnsiStyleSerializer)
end)

afterAll(function()
	jestExpect.resetSnapshotSerializers()
end)

describe("printDiffOrStringify", function()
	local function testDiffOrStringify(expected: any, received: any): string
		return printDiffOrStringify(expected, received, "Expected", "Received", true)
	end

	it("expected is empty and received is single line", function()
		local expected = ""
		local received = "single line"
		jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
	end)

	it("expected is multi line and received is empty", function()
		local expected = "multi\nline"
		local received = ""
		jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
	end)

	it("expected and received are single line with multiple changes", function()
		local expected = "delete common expected common prev"
		local received = "insert common received common next"
		jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
	end)

	it("expected and received are multi line with trailing spaces", function()
		local expected = "delete \ncommon expected common\nprev "
		local received = "insert \ncommon received common\nnext "
		jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
	end)

	it("has no common after clean up chaff multiline", function()
		local expected = "delete\ntwo"
		local received = "insert\n2"
		jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
	end)

	it("has no common after clean up chaff one-line", function()
		local expected = "delete"
		local received = "insert"
		jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
	end)

	it("object contain readonly symbol key object", function()
		local expected = { b = 2 }
		local received = { b = 1 }
		-- ROBLOX deviation: test modified from upstream so we don't have to deal
		-- with non-deterministic ordering of keys
		local symbolKey = Symbol("key")
		expected["a"] = symbolKey
		received["a"] = symbolKey
		jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
	end)

	describe("MAX_DIFF_STRING_LENGTH", function()
		-- ROBLOX deviation: omitted lessChange because since we don't have
		-- output coloring implemented yet, it wouldn't match differently
		-- local lessChange = INVERTED_COLOR("single ")
		local less = "single line"
		local more = "multi line" .. string.rep("\n123456789", 2000) -- 10 + 20K chars

		it("both are less", function()
			local difference = testDiffOrStringify("multi\nline", less)

			jestExpect(difference).toMatch("%- multi")
			jestExpect(difference).toMatch("%- line")

			-- ROBLOX deviation: omitted expect.not.toMatch call since we don't
			-- have the chalk library implemented and diffStringsUnified
			-- won't actually change the string
			-- ROBLOX deviation: omitted expect.toMatch call with lessChange
		end)

		it("expected is more", function()
			local difference = testDiffOrStringify(more, less)

			jestExpect(difference).toMatch("%- multi line")
			jestExpect(difference).toMatch("%+ single line")

			-- ROBLOX deviation: omitted expect.not.toMatch call with lessChange
		end)

		it("received is more", function()
			local difference = testDiffOrStringify(less, more)

			jestExpect(difference).toMatch("%- single line")
			jestExpect(difference).toMatch("%+ multi line")

			-- ROBLOX deviation: omitted expect.not.toMatch call with lessChange
		end)
	end)

	-- ROBLOX TODO: Implement these tests once we have asymmetricMatcher (ADO-1247)
	describe("asymmetricMatcher", function()
		it("minimal test", function()
			local expected = { a = jestExpect.any("number"), b = 2 }
			local received = { a = 1, b = 1 }
			jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("jest asymmetricMatcher", function()
			local expected = {
				a = jestExpect.any("number"),
				b = jestExpect.anything(),
				c = jestExpect.arrayContaining({ 1, 3 }),
				d = "jest is awesome",
				e = "jest is awesome",
				f = {
					a = DateTime.now(),
					b = "jest is awesome",
				},
				g = true,
			}
			-- ROBLOX deviation: test modified from upstream so we don't have to deal
			-- with non-deterministic ordering of keys
			expected["h"] = {}
			expected["h"][Symbol.for_("h")] = "jest is awesome"
			local received = {
				a = 1,
				b = "anything",
				c = { 1, 2, 3 },
				d = jestExpect.stringContaining("jest"),
				e = jestExpect.stringMatching("jest"),
				f = jestExpect.objectContaining({
					a = jestExpect.any("DateTime"),
				}),
				g = false,
			}
			-- ROBLOX deviation: test modified from upstream so we don't have to deal
			-- with non-deterministic ordering of keys
			received["h"] = {}
			received["h"][Symbol.for_("h")] = jestExpect.any("string")

			jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		-- ROBLOX TODO: implement this test once we can write custom asymmetricMatchers
		-- test('custom asymmetricMatcher', () => {
		-- 	expect.extend({
		-- 		equal5(received: unknown) {
		-- 			if (received === 5)
		-- 				return {
		-- 					message: () => `expected ${received} not to be 5`,
		-- 					pass: true,
		-- 				};
		-- 			return {
		-- 				message: () => `expected ${received} to be 5`,
		-- 				pass: false,
		-- 			};
		-- 		},
		-- 	});
		-- 	const expected = {
		-- 		a: expect.equal5(),
		-- 		b: false,
		-- 	};
		-- 	const received = {
		-- 		a: 5,
		-- 		b: true,
		-- 	};

		-- 	jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot();
		-- });

		it("nested object", function()
			local expected = {
				a = 1,
				b = {
					a = 1,
					b = jestExpect.any("number"),
				},
				c = 2,
			}
			local received = {
				a = jestExpect.any("number"),
				b = {
					a = 1,
					b = 2,
				},
				c = 1,
			}
			jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("array", function()
			local expected: Array<any> = { 1, jestExpect.any("number"), 3 }
			local received: Array<any> = { 1, 2, 2 }
			jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("object in array", function()
			local expected: Array<any> = { 1, { a = 1, b = jestExpect.any("number") }, 3 }
			local received: Array<any> = { 1, { a = 1, b = 2 }, 2 }
			jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("map", function()
			local expected: Map<any, any> = {
				a = 1,
				b = jestExpect.any("number"),
				c = 3,
			}
			local received: Map<any, any> = {
				a = 1,
				b = 2,
				c = 2,
			}
			jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("circular object", function()
			local expected: any = {
				b = jestExpect.any("number"),
				c = 3,
			}
			expected.a = expected
			local received: any = {
				b = 2,
				c = 2,
			}
			received.a = received
			jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("transitive circular", function()
			local expected: any = {
				a = 3,
			}
			expected.nested = { b = jestExpect.any("number"), parent = expected }
			local received: any = {
				a = 2,
			}
			received.nested = { b = 2, parent = received }
			jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("circular array", function()
			local expected: Array<any> = { 1, jestExpect.any("number"), 3 }
			table.insert(expected, expected)
			local received: Array<any> = { 1, 2, 2 }
			table.insert(received, received)
			jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("circular map", function()
			local expected: Map<any, any> = {
				a = 1,
				b = jestExpect.any("number"),
				c = 3,
			}
			expected["circular"] = expected
			local received: Map<any, any> = {
				a = 1,
				b = 2,
				c = 2,
			}
			received["circular"] = received
			jestExpect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)
	end)
end)

return {}
