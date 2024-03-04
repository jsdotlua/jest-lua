-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-matcher-utils/src/__tests__/printDiffOrStringify.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

local Symbol = require("@pkg/@jsdotlua/luau-polyfill").Symbol

local printDiffOrStringify = require("../init").printDiffOrStringify
-- ROBLOX deviation: omitted INVERTED_COLOR import because it doesn't have an
-- actual implementation yet

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll

local alignedAnsiStyleSerializer = require("@pkg/@jsdotlua/test-utils").alignedAnsiStyleSerializer

local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
type Array<T> = LuauPolyfill.Array<T>
type Map<X, Y> = { [X]: Y }

beforeAll(function()
	expect.addSnapshotSerializer(alignedAnsiStyleSerializer)
end)

describe("printDiffOrStringify", function()
	local function testDiffOrStringify(expected: any, received: any): string
		return printDiffOrStringify(expected, received, "Expected", "Received", true)
	end

	it("expected is empty and received is single line", function()
		local expected = ""
		local received = "single line"
		expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
	end)

	it("expected is multi line and received is empty", function()
		local expected = "multi\nline"
		local received = ""
		expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
	end)

	it("expected and received are single line with multiple changes", function()
		local expected = "delete common expected common prev"
		local received = "insert common received common next"
		expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
	end)

	it("expected and received are multi line with trailing spaces", function()
		local expected = "delete \ncommon expected common\nprev "
		local received = "insert \ncommon received common\nnext "
		expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
	end)

	it("has no common after clean up chaff multiline", function()
		local expected = "delete\ntwo"
		local received = "insert\n2"
		expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
	end)

	it("has no common after clean up chaff one-line", function()
		local expected = "delete"
		local received = "insert"
		expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
	end)

	it("object contain readonly symbol key object", function()
		local expected = { b = 2 }
		local received = { b = 1 }
		-- ROBLOX deviation: test modified from upstream so we don't have to deal
		-- with non-deterministic ordering of keys
		local symbolKey = Symbol("key")
		expected["a"] = symbolKey
		received["a"] = symbolKey
		expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
	end)

	describe("MAX_DIFF_STRING_LENGTH", function()
		-- ROBLOX deviation: omitted lessChange because since we don't have
		-- output coloring implemented yet, it wouldn't match differently
		-- local lessChange = INVERTED_COLOR("single ")
		local less = "single line"
		local more = "multi line" .. string.rep("\n123456789", 2000) -- 10 + 20K chars

		it("both are less", function()
			local difference = testDiffOrStringify("multi\nline", less)

			expect(difference).toMatch("%- multi")
			expect(difference).toMatch("%- line")

			-- ROBLOX deviation: omitted expect.not.toMatch call since we don't
			-- have the chalk library implemented and diffStringsUnified
			-- won't actually change the string
			-- ROBLOX deviation: omitted expect.toMatch call with lessChange
		end)

		it("expected is more", function()
			local difference = testDiffOrStringify(more, less)

			expect(difference).toMatch("%- multi line")
			expect(difference).toMatch("%+ single line")

			-- ROBLOX deviation: omitted expect.not.toMatch call with lessChange
		end)

		it("received is more", function()
			local difference = testDiffOrStringify(less, more)

			expect(difference).toMatch("%- single line")
			expect(difference).toMatch("%+ multi line")

			-- ROBLOX deviation: omitted expect.not.toMatch call with lessChange
		end)
	end)

	-- ROBLOX TODO: Implement these tests once we have asymmetricMatcher (ADO-1247)
	describe("asymmetricMatcher", function()
		it("minimal test", function()
			local expected = { a = expect.any("number"), b = 2 }
			local received = { a = 1, b = 1 }
			expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("jest asymmetricMatcher", function()
			local expected = {
				a = expect.any("number"),
				b = expect.anything(),
				c = expect.arrayContaining({ 1, 3 }),
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
				d = expect.stringContaining("jest"),
				e = expect.stringMatching("jest"),
				f = expect.objectContaining({
					a = expect.any("DateTime"),
				}),
				g = false,
			}
			-- ROBLOX deviation: test modified from upstream so we don't have to deal
			-- with non-deterministic ordering of keys
			received["h"] = {}
			received["h"][Symbol.for_("h")] = expect.any("string")

			expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
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

		-- 	expect(testDiffOrStringify(expected, received)).toMatchSnapshot();
		-- });

		it("nested object", function()
			local expected = {
				a = 1,
				b = {
					a = 1,
					b = expect.any("number"),
				},
				c = 2,
			}
			local received = {
				a = expect.any("number"),
				b = {
					a = 1,
					b = 2,
				},
				c = 1,
			}
			expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("array", function()
			local expected: Array<any> = { 1, expect.any("number"), 3 }
			local received: Array<any> = { 1, 2, 2 }
			expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("object in array", function()
			local expected: Array<any> = { 1, { a = 1, b = expect.any("number") }, 3 }
			local received: Array<any> = { 1, { a = 1, b = 2 }, 2 }
			expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("map", function()
			local expected: Map<any, any> = {
				a = 1,
				b = expect.any("number"),
				c = 3,
			}
			local received: Map<any, any> = {
				a = 1,
				b = 2,
				c = 2,
			}
			expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("circular object", function()
			local expected: any = {
				b = expect.any("number"),
				c = 3,
			}
			expected.a = expected
			local received: any = {
				b = 2,
				c = 2,
			}
			received.a = received
			expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("transitive circular", function()
			local expected: any = {
				a = 3,
			}
			expected.nested = { b = expect.any("number"), parent = expected }
			local received: any = {
				a = 2,
			}
			received.nested = { b = 2, parent = received }
			expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("circular array", function()
			local expected: Array<any> = { 1, expect.any("number"), 3 }
			table.insert(expected, expected)
			local received: Array<any> = { 1, 2, 2 }
			table.insert(received, received)
			expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)

		it("circular map", function()
			local expected: Map<any, any> = {
				a = 1,
				b = expect.any("number"),
				c = 3,
			}
			expected["circular"] = expected
			local received: Map<any, any> = {
				a = 1,
				b = 2,
				c = 2,
			}
			received["circular"] = received
			expect(testDiffOrStringify(expected, received)).toMatchSnapshot()
		end)
	end)
end)
