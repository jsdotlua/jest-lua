-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-matcher-utils/src/__tests__/index.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Symbol = LuauPolyfill.Symbol

local RegExp = require(Packages.RegExp)

local equals = require(Packages.Dev.RobloxShared).expect.equals

local chalk = require(Packages.ChalkLua)

local prettyFormat = require(Packages.PrettyFormat).format

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll

local alignedAnsiStyleSerializer = require(Packages.Dev.TestUtils).alignedAnsiStyleSerializer

local JestMatcherUtils = require(CurrentModule)
-- ROBLOX deviation: omitted MatcherHintOptions import
local diff = JestMatcherUtils.diff
local ensureNoExpected = JestMatcherUtils.ensureNoExpected
local ensureNumbers = JestMatcherUtils.ensureNumbers
local getLabelPrinter = JestMatcherUtils.getLabelPrinter
local matcherHint = JestMatcherUtils.matcherHint
local pluralize = JestMatcherUtils.pluralize
local stringify = JestMatcherUtils.stringify

beforeAll(function()
	expect.addSnapshotSerializer(alignedAnsiStyleSerializer)
end)

describe("stringify()", function()
	local fixtures = {
		{ {}, "{}" },
		{ 1, "1" },
		{ 0, "0" },
		{ 1.5, "1.5" },
		{ nil, "nil" },
		{ "abc", '"abc"' },
		{ 0 / 0, "nan" },
		{ math.huge, "inf" },
		{ -math.huge, "-inf" },
		{ RegExp("ab\\.c", "i"), "/ab\\.c/i" },
		--[[
				ROBLOX deviation: skipped since BigInt doesn't exist in Luau
				original code:
				[BigInt(1), '1n'],
    			[BigInt(0), '0n'],
			]]
	}

	for key, value in ipairs(fixtures) do
		it(stringify(value[1]), function()
			expect(stringify(value[1])).toBe(value[2])
		end)
	end

	it("circular references", function()
		local a: any = {}
		a.a = a
		expect(stringify(a)).toBe('{"a": [Circular]}')
	end)

	it("toJSON error", function()
		local evil = {
			toJSON = function()
				error("Nope.")
			end,
		}

		expect(stringify(evil)).toBe('{"toJSON": [Function toJSON]}')
		expect(stringify({ a = { b = { evil = evil } } })).toBe('{"a": {"b": {"evil": {"toJSON": [Function toJSON]}}}}')

		-- ROBLOX deviation: we use a table with a __call metamethod to mimic a
		-- function with properties in upstream
		local Evil = {}
		setmetatable(Evil, { __call = function() end })
		Evil.toJSON = evil.toJSON
		expect(stringify(Evil)).toBe('{"toJSON": [Function toJSON]}')
	end)

	it("toJSON errors when comparing two objects", function()
		local function toJSON()
			error("Nope.")
		end

		local evilA = {
			a = 1,
			toJSON = toJSON,
		}

		local evilB = {
			b = 1,
			toJSON = toJSON,
		}

		-- ROBLOX deviation: our to.equal() method does not work in the same way
		-- so I'm not sure how to reconcile this. For now I just made it so that
		-- I check equality and confirm that they are not equal
		expect(equals(evilA, evilB)).toBe(false)
	end)

	it("reduces maxDepth if stringifying very large objects", function()
		local big: any = { a = 1, b = {} }
		local small: any = { a = 1, b = {} }
		for i = 0, 9999 do
			big.b[i] = "test"
		end

		for i = 0, 9 do
			small.b[i] = "test"
		end

		expect(stringify(big)).toBe(prettyFormat(big, { maxDepth = 1, min = true }))
		expect(stringify(small)).toBe(prettyFormat(small, { min = true }))
	end)
end)

describe("ensureNumbers()", function()
	local matcherName = "toBeCloseTo"

	it("dont throw error when variables are numbers", function()
		expect(function()
			ensureNumbers(1, 2, matcherName)
		end).never.toThrow()
		--[[
				ROBLOX deviation: skipped since BigInt doesn't exist in Luau
				original code:
				expect(() => {
				  ensureNumbers(BigInt(1), BigInt(2), matcherName);
				}).not.toThrow()
			]]
	end)

	it("throws error when expected is not a number (backward compatibility)", function()
		expect(function()
			ensureNumbers(1, "not_a_number", "." .. matcherName)
		end).toThrowErrorMatchingSnapshot()
	end)

	it("throws error when received is not a number (backward compatibility)", function()
		expect(function()
			ensureNumbers("not_a_number", 3, "." .. matcherName)
		end).toThrowErrorMatchingSnapshot()
	end)

	describe("with options", function()
		it("promise empty isNot false received", function()
			local options: JestMatcherUtils.MatcherHintOptions = {
				isNot = false,
				promise = "",
				secondArgument = "precision",
			}

			expect(function()
				ensureNumbers("", 0, matcherName, options)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("promise empty isNot true expected", function()
			local options: JestMatcherUtils.MatcherHintOptions = {
				isNot = true,
				-- promise nil is equivalent to empty string
			}

			expect(function()
				ensureNumbers(0.1, nil, matcherName, options)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("promise rejects isNot false expected", function()
			local options: JestMatcherUtils.MatcherHintOptions = {
				isNot = false,
				promise = "rejects",
			}

			expect(function()
				ensureNumbers(0.01, "0", matcherName, options)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("promise rejects isNot true received", function()
			local options: JestMatcherUtils.MatcherHintOptions = {
				isNot = true,
				promise = "rejects",
			}

			expect(function()
				ensureNumbers(Symbol(0.1), 0, matcherName, options)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("promise resolves isNot false received", function()
			local options: JestMatcherUtils.MatcherHintOptions = {
				isNot = false,
				promise = "resolves",
			}

			expect(function()
				ensureNumbers(false, 0, matcherName, options)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("promise resolves isNot true expected", function()
			local options: JestMatcherUtils.MatcherHintOptions = {
				isNot = true,
				promise = "resolves",
			}

			expect(function()
				ensureNumbers(0.1, nil, matcherName, options)
			end).toThrowErrorMatchingSnapshot()
		end)
	end)
end)

describe("ensureNoExpected()", function()
	local matcherName = "toBeDefined"

	it("dont throw error when undefined", function()
		expect(function()
			ensureNoExpected(nil, matcherName)
		end).never.toThrow()
	end)

	it("throws error when expected is not undefined with matcherName", function()
		expect(function()
			ensureNoExpected({ a = 1 }, "." .. matcherName)
		end).toThrowErrorMatchingSnapshot()
	end)

	it("throws error when expected is not undefined with matcherName and options", function()
		expect(function()
			ensureNoExpected({ a = 1 }, matcherName, { isNot = true })
		end).toThrowErrorMatchingSnapshot()
	end)
end)

-- ROBLOX deviation: we can't mock jest-diff so we let it call through and compare
-- the actual output
describe("diff", function()
	it("forwards to jest-diff", function()
		local fixtures = {
			{ "a", "b" },
			{ "a", {} },
			{ "a", nil },
			{ "a", 1 },
			{ "a", true },
			{ 1, true },
			--[[
					ROBLOX deviation: skipped since BigInt doesn't exist in Luau
					original code:
					[BigInt(1), true]
				]]
		}

		for i, value in ipairs(fixtures) do
			expect(diff(value[1], value[2])).toMatchSnapshot()
		end
	end)

	it("two booleans", function()
		expect(diff(false, true)).toBe(nil)
	end)

	it("two numbers", function()
		expect(diff(1, 2)).toBe(nil)
	end)

	it.skip("two bigints", function()
		--[[
				ROBLOX deviation: skipped since BigInt doesn't exist in Luau
				original code:
				expect(diff(BigInt(1), BigInt(2))).toBe(null);
			]]
	end)
end)

describe("pluralize()", function()
	it("one", function()
		expect(pluralize("apple", 1)).toBe("one apple")
	end)

	it("two", function()
		expect(pluralize("apple", 2)).toBe("two apples")
	end)

	it("20", function()
		expect(pluralize("apple", 20)).toBe("20 apples")
	end)
end)

describe("getLabelPrinter", function()
	it("0 args", function()
		local printLabel = getLabelPrinter()
		expect(printLabel("")).toBe(": ")
	end)

	it("1 empty string", function()
		local printLabel = getLabelPrinter()
		expect(printLabel("")).toBe(": ")
	end)

	it("1 non-empty string", function()
		local string_ = "Expected"
		local printLabel = getLabelPrinter(string_)
		expect(printLabel(string_)).toBe("Expected: ")
	end)

	it("2 equal lengths", function()
		local stringExpected = "Expected value"
		local collectionType = "array"
		local stringReceived = string.format("Received %s", collectionType)
		local printLabel = getLabelPrinter(stringExpected, stringReceived)
		expect(printLabel(stringExpected)).toBe("Expected value: ")
		expect(printLabel(stringReceived)).toBe("Received array: ")
	end)

	it("2 unequal lengths", function()
		local stringExpected = "Expected value"
		local collectionType = "set"
		local stringReceived = string.format("Received %s", collectionType)
		local printLabel = getLabelPrinter(stringExpected, stringReceived)
		expect(printLabel(stringExpected)).toBe("Expected value: ")
		expect(printLabel(stringReceived)).toBe("Received set:   ")
	end)

	it("returns incorrect padding if inconsistent arg is shorter", function()
		local stringConsistent = "Expected"
		local stringInconsistent = "Received value"
		local stringInconsistentShorter = "Received set"
		local printLabel = getLabelPrinter(stringConsistent, stringInconsistent)
		expect(printLabel(stringConsistent)).toBe("Expected:       ")
		expect(printLabel(stringInconsistentShorter)).toBe("Received set:   ")
	end)

	it("throws if inconsistent arg is longer", function()
		local stringConsistent = "Expected"
		local stringInconsistent = "Received value"
		local stringInconsistentLonger = "Received string"
		local printLabel = getLabelPrinter(stringConsistent, stringInconsistent)
		expect(printLabel(stringConsistent)).toBe("Expected:       ")
		expect(function()
			printLabel(stringInconsistentLonger)
		end).toThrow("Cannot print label for string with length larger than the max allowed of 14")
	end)
end)

-- We don't have chalk library so we aren't able to match specific colors
-- so we simplify the tests to just look at the passing cases where the
-- colors "would be" aligned
describe("matcherHint", function()
	it("expectedColor", function()
		local function expectedColor(arg: string): string
			return arg
		end
		local expectedArgument = "n"
		local received = matcherHint(
			"toHaveBeenNthCalledWith",
			"jest.fn()",
			expectedArgument,
			{ expectedColor = expectedColor, secondArgument = "...expected" }
		)

		local substringNegative = chalk.green(expectedArgument)

		expect(received).never.toMatch(substringNegative)
	end)

	it("receivedColor", function()
		local receivedColor = tostring
		local receivedArgument = "received"
		local received = matcherHint("toMatchSnapshot", receivedArgument, "", {
			receivedColor = receivedColor,
		})

		local substringNegative = chalk.red(receivedArgument)
		local substringPositive = receivedColor(receivedArgument)

		expect(received).never.toMatch(substringNegative)
		expect(received).toMatch(substringPositive)
	end)

	it("secondArgumentColor", function()
		local secondArgumentColor = tostring
		local secondArgument = "hint"
		local received = matcherHint("toMatchSnapshot", nil, "properties", {
			secondArgument = secondArgument,
			secondArgumentColor = secondArgumentColor,
		})

		local substringNegative = chalk.green(secondArgument)
		local substringPositive = secondArgumentColor(secondArgument)

		expect(received).never.toMatch(substringNegative)
		expect(received).toMatch(substringPositive)
	end)
end)

return {}
