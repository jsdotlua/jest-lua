-- upstream: https://github.com/facebook/jest/blob/v27.2.5/packages/jest-matcher-utils/src/__tests__/index.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */
return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Symbol = LuauPolyfill.Symbol

	local RegExp = require(Packages.RegExp)

	local equals = require(Packages.Dev.RobloxShared).expect.equals

	local chalk = require(Packages.ChalkLua)

	local prettyFormat = require(Packages.PrettyFormat).prettyFormat

	local jestExpect = require(Packages.Dev.Expect)
	local alignedAnsiStyleSerializer = require(Packages.Dev.TestUtils).alignedAnsiStyleSerializer

	local JestMatcherUtils = require(CurrentModule)
	-- deviation: omitted MatcherHintOptions import
	local diff = JestMatcherUtils.diff
	local ensureNoExpected = JestMatcherUtils.ensureNoExpected
	local ensureNumbers = JestMatcherUtils.ensureNumbers
	local getLabelPrinter = JestMatcherUtils.getLabelPrinter
	local matcherHint = JestMatcherUtils.matcherHint
	local pluralize = JestMatcherUtils.pluralize
	local stringify = JestMatcherUtils.stringify

	beforeAll(function()
		jestExpect.addSnapshotSerializer(alignedAnsiStyleSerializer)
	end)

	afterAll(function()
		jestExpect.resetSnapshotSerializers()
	end)

	describe("stringify()", function()
		local fixtures = {
			{{}, "{}"},
			{1, "1"},
			{0, "0"},
			{1.5, "1.5"},
			{nil, "nil"},
			{"abc", "\"abc\""},
			{0/0, "nan"},
			{math.huge, "inf"},
			{-math.huge, "-inf"},
			{RegExp("ab\\.c", "i"), "/ab\\.c/i"}
		}

		for key, value in ipairs(fixtures) do
			it(stringify(value[1]), function()
				jestExpect(stringify(value[1])).toBe(value[2])
			end)
		end

		it("circular references", function()
			local a: any = {}
			a.a = a
			jestExpect(stringify(a)).toBe("{\"a\": [Circular]}")
		end)

		it("toJSON error", function()
			local evil = {
				toJSON = function()
					error("Nope.")
				end
			}

			jestExpect(stringify(evil)).toBe("{\"toJSON\": [Function anonymous]}")
			-- deviation: PrettyFormat returns [Function anonymous] since we
			-- can't get function information
			jestExpect(stringify({a = {b = {evil = evil}}})).toBe("{\"a\": {\"b\": {\"evil\": {\"toJSON\": [Function anonymous]}}}}")

			-- deviation: we use a table with a __call metamethod to mimic a
			-- function with properties in upstream
			local Evil = {}
			setmetatable(Evil, {__call = function() end})
			Evil.toJSON = evil.toJSON
			jestExpect(stringify(Evil)).toBe("{\"toJSON\": [Function anonymous]}")

		end)

		it("toJSON errors when comparing two objects", function()
			local function toJSON()
				error("Nope.")
			end

			local evilA = {
				a = 1,
				toJSON = toJSON
			}

			local evilB = {
				b = 1,
				toJSON = toJSON
			}

			-- deviation: our to.equal() method does not work in the same way
			-- so I'm not sure how to reconcile this. For now I just made it so that
			-- I check equality and confirm that they are not equal
			jestExpect(equals(evilA, evilB)).toBe(false)
		end)

		it("reduces maxDepth if stringifying very large objects", function()
			local big: any = {a = 1, b = {}}
			local small: any = {a = 1, b = {}}
			for i = 0, 9999 do
				big.b[i] = "test"
			end

			for i = 0, 9 do
				small.b[i] = "test"
			end

			jestExpect(stringify(big)).toBe(prettyFormat(big, {maxDepth = 1, min = true}))
			jestExpect(stringify(small)).toBe(prettyFormat(small, {min = true}))
		end)
	end)

	describe("ensureNumbers()", function()
		local matcherName = "toBeCloseTo"

		it("dont throw error when variables are numbers", function()
			jestExpect(function()
				ensureNumbers(1, 2, matcherName)
			end).never.toThrow()
		end)

		it("throws error when expected is not a number (backward compatibility)", function()
			jestExpect(function()
				ensureNumbers(1, "not_a_number", "." .. matcherName)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("throws error when received is not a number (backward compatibility)", function()
			jestExpect(function()
				ensureNumbers("not_a_number", 3, "." .. matcherName)
			end).toThrowErrorMatchingSnapshot()
		end)

		describe("with options", function()
			it("promise empty isNot false received", function()
				local options: JestMatcherUtils.MatcherHintOptions = {
					isNot = false,
					promise = "",
					secondArgument = "precision"
				}

				jestExpect(function()
					ensureNumbers("", 0, matcherName, options)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("promise empty isNot true expected", function()
				local options: JestMatcherUtils.MatcherHintOptions = {
					isNot = true,
					-- promise nil is equivalent to empty string
				}

				jestExpect(function()
					ensureNumbers(0.1, nil, matcherName, options)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("promise rejects isNot false expected", function()
				local options: JestMatcherUtils.MatcherHintOptions = {
					isNot = false,
					promise = "rejects"
				}

				jestExpect(function()
					ensureNumbers(0.01, "0", matcherName, options)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("promise rejects isNot true received", function()
				local options: JestMatcherUtils.MatcherHintOptions = {
					isNot = true,
					promise = "rejects"
				}

				jestExpect(function()
					ensureNumbers(Symbol(0.1), 0, matcherName, options)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("promise resolves isNot false received", function()
				local options: JestMatcherUtils.MatcherHintOptions = {
					isNot = false,
					promise = "resolves"
				}

				jestExpect(function()
					ensureNumbers(false, 0, matcherName, options)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("promise resolves isNot true expected", function()
				local options: JestMatcherUtils.MatcherHintOptions = {
					isNot = true,
					promise = "resolves"
				}

				jestExpect(function()
					ensureNumbers(0.1, nil, matcherName, options)
				end).toThrowErrorMatchingSnapshot()
			end)
		end)
	end)

	describe("ensureNoExpected()", function()
		local matcherName = "toBeDefined"

		it("dont throw error when undefined", function()
			jestExpect(function()
				ensureNoExpected(nil, matcherName)
			end).never.toThrow()
		end)

		it("throws error when expected is not undefined with matcherName", function()
			jestExpect(function()
				ensureNoExpected({a = 1}, "." .. matcherName)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("throws error when expected is not undefined with matcherName and options", function()
			jestExpect(function()
				ensureNoExpected({a = 1}, matcherName, {isNot = true})
			end).toThrowErrorMatchingSnapshot()
		end)
	end)

	-- deviation: we can't mock jest-diff so we let it call through and compare
	-- the actual output
	describe("diff", function()
		it("forwards to jest-diff", function()
			local fixtures = {
				{"a", "b"},
				{"a", {}},
				{"a", nil},
				{"a", 1},
				{"a", true},
				{1, true}
			}

			for i, value in ipairs(fixtures) do
				jestExpect(diff(value[1], value[2])).toMatchSnapshot()
			end
		end)

		it("two booleans", function()
			jestExpect(diff(false, true)).toBe(nil)
		end)

		it("two numbers", function()
			jestExpect(diff(1, 2)).toBe(nil)
		end)

		-- deviation: skipped test testing bigints since we don't have this
		-- type in lua
		itSKIP("two bigints", function()
			jestExpect(diff(1, 2)).toBe(nil)
		end)
	end)

	describe("pluralize()", function()
		it("one", function()
			jestExpect(pluralize("apple", 1)).toBe("one apple")
		end)

		it("two", function()
			jestExpect(pluralize("apple", 2)).toBe("two apples")
		end)

		it("20", function()
			jestExpect(pluralize("apple", 20)).toBe("20 apples")
		end)
	end)

	describe("getLabelPrinter", function()
		it("0 args", function()
			local printLabel = getLabelPrinter()
			jestExpect(printLabel("")).toBe(": ")
		end)

		it("1 empty string", function()
			local printLabel = getLabelPrinter()
			jestExpect(printLabel("")).toBe(": ")
		end)

		it("1 non-empty string", function()
			local string_ = "Expected"
			local printLabel = getLabelPrinter(string_)
			jestExpect(printLabel(string_)).toBe("Expected: ")
		end)

		it("2 equal lengths", function()
			local stringExpected = "Expected value"
			local collectionType = "array"
			local stringReceived = string.format("Received %s", collectionType)
			local printLabel = getLabelPrinter(stringExpected, stringReceived)
			jestExpect(printLabel(stringExpected)).toBe("Expected value: ")
			jestExpect(printLabel(stringReceived)).toBe("Received array: ")
		end)

		it("2 unequal lengths", function()
			local stringExpected = "Expected value"
			local collectionType = "set"
			local stringReceived = string.format("Received %s", collectionType)
			local printLabel = getLabelPrinter(stringExpected, stringReceived)
			jestExpect(printLabel(stringExpected)).toBe("Expected value: ")
			jestExpect(printLabel(stringReceived)).toBe("Received set:   ")
		end)

		it("returns incorrect padding if inconsistent arg is shorter", function()
			local stringConsistent = "Expected"
			local stringInconsistent = "Received value"
			local stringInconsistentShorter = "Received set"
			local printLabel = getLabelPrinter(stringConsistent, stringInconsistent)
			jestExpect(printLabel(stringConsistent)).toBe("Expected:       ")
			jestExpect(printLabel(stringInconsistentShorter)).toBe("Received set:   ")
		end)

		it("throws if inconsistent arg is longer", function()
			local stringConsistent = "Expected"
			local stringInconsistent = "Received value"
			local stringInconsistentLonger = "Received string"
			local printLabel = getLabelPrinter(stringConsistent, stringInconsistent)
			jestExpect(printLabel(stringConsistent)).toBe("Expected:       ")
			jestExpect(function()
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
				{expectedColor = expectedColor, secondArgument = "...expected"}
			)

			local substringNegative = chalk.green(expectedArgument)

			jestExpect(received).never.toMatch(substringNegative)
		end)

		it("receivedColor", function()
			local receivedColor = tostring
			local receivedArgument = "received"
			local received = matcherHint("toMatchSnapshot", receivedArgument, "", {
				receivedColor = receivedColor,
			})

			local substringNegative = chalk.red(receivedArgument)
			local substringPositive = receivedColor(receivedArgument)

			jestExpect(received).never.toMatch(substringNegative)
			jestExpect(received).toMatch(substringPositive)
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

			jestExpect(received).never.toMatch(substringNegative)
			jestExpect(received).toMatch(substringPositive)
		end)
	end)
end