-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-diff/src/__tests__/diff.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
type Object = LuauPolyfill.Object

local chalk = require(Packages.ChalkLua)
local JestTypes = require(Packages.JestTypes)

type Global_ItBase = JestTypes.Global_It

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll

local alignedAnsiStyleSerializer = require(Packages.Dev.TestUtils).alignedAnsiStyleSerializer

local Number = require(Packages.LuauPolyfill).Number

local diff = require(CurrentModule).diff
local diffLinesUnified = require(CurrentModule.DiffLines).diffLinesUnified
local diffLinesUnified2 = require(CurrentModule.DiffLines).diffLinesUnified2

local noColor = require(CurrentModule.NormalizeDiffOptions).noColor

local diffStringsUnified = require(CurrentModule.PrintDiffs).diffStringsUnified

local NO_DIFF_MESSAGE = require(CurrentModule.Constants).NO_DIFF_MESSAGE

local optionsCounts = {
	includeChangeCounts = true,
}

local stripped = function(a: any, b: any)
	local retval = diff(a, b) or ""
	local result, _ = string.gsub(retval, string.char(27) .. "%[%d+m", "")
	return result
end

-- ROBLOX deviation: added a table copy method to set options
local function tableCopy<T>(t: T & Object): T
	local copy = {}
	for key, value in pairs((t :: any) :: Object) do
		copy[key] = value
	end
	return (copy :: any) :: T
end

-- Use in toBe assertions for comparison lines.
local optionsBe = {
	aColor = noColor,
	bColor = noColor,
	commonColor = noColor,
	omitAnnotationLines = true,
}
local unexpandedBe = tableCopy(optionsBe)
unexpandedBe["expand"] = false
local expandedBe = tableCopy(optionsBe)
expandedBe["expand"] = true

-- Use for toMatchSnapshot assertions.
local unexpanded = { expand = false }
local expanded = { expand = true }

-- local elementSymbol = require(CurrentModule.Parent.React.Shared).REACT_ELEMENT_TYPE

beforeAll(function()
	expect.addSnapshotSerializer(alignedAnsiStyleSerializer)
end)

describe("different types", function()
	it('1 and "a"', function()
		local a = 1
		local b = "a"
		local typeA = "number"
		local typeB = "string"
		expect(stripped(a, b)).toBe(
			string.format("  Comparing two different types of values. " .. "Expected %s but received %s.", typeA, typeB)
		)
	end)
	it('{} and "a"', function()
		local a = {}
		local b = "a"
		local typeA = "table"
		local typeB = "string"
		expect(stripped(a, b)).toBe(
			string.format("  Comparing two different types of values. " .. "Expected %s but received %s.", typeA, typeB)
		)
	end)
	it("{} and 2", function()
		local a = {}
		local b = 2
		local typeA = "table"
		local typeB = "number"
		expect(stripped(a, b)).toBe(
			string.format("  Comparing two different types of values. " .. "Expected %s but received %s.", typeA, typeB)
		)
	end)
	-- ROBLOX deviation: omitted nil vs undefined, no distinction in lua
	it("function and 3", function()
		local a = function() end
		local b = 3
		local typeA = "function"
		local typeB = "number"
		expect(stripped(a, b)).toBe(
			string.format("  Comparing two different types of values. " .. "Expected %s but received %s.", typeA, typeB)
		)
	end)
end)

describe("no visual difference", function()
	it('"a" and "a"', function()
		expect(stripped("a", "a")).toBe(NO_DIFF_MESSAGE)
	end)
	it("{} and {}", function()
		expect(stripped({}, {})).toBe(NO_DIFF_MESSAGE)
	end)
	it("{{}} and {{}}", function()
		expect(stripped({ {} }, { {} })).toBe(NO_DIFF_MESSAGE)
	end)
	it("{{1, 2}} and {{1, 2}}", function()
		expect(stripped({ { 1, 2 } }, { { 1, 2 } })).toBe(NO_DIFF_MESSAGE)
	end)
	it("{11} and {11}", function()
		expect(stripped({ 11 }, { 11 })).toBe(NO_DIFF_MESSAGE)
	end)
	it("{0/0} and {0/0}", function()
		expect(stripped({ 0 / 0 }, { 0 / 0 })).toBe(NO_DIFF_MESSAGE)
	end)
	-- ROBLOX deviation: omitted Number.NaN and NaN
	it("function and function", function()
		expect(stripped(function() end, function() end)).toBe(NO_DIFF_MESSAGE)
	end)
	it("nil and nil", function()
		expect(stripped(nil, nil)).toBe(NO_DIFF_MESSAGE)
	end)
	-- ROBLOX deviation: omitted undefined, identical to nil
	it("false and false", function()
		expect(stripped(false, false)).toBe(NO_DIFF_MESSAGE)
	end)
	it("{a = 1} and {a = 1}", function()
		expect(stripped({ a = 1 }, { a = 1 })).toBe(NO_DIFF_MESSAGE)
	end)
	it("{a = {b = 5}} and {a = {b = 5}}", function()
		expect(stripped({ a = { b = 5 } }, { a = { b = 5 } })).toBe(NO_DIFF_MESSAGE)
	end)

	-- ROBLOX deviation: TODO ordering for maps and sets
end)

it("oneline strings", function()
	expect(diff("ab", "aa", optionsCounts)).toMatchSnapshot()
	expect(diff("123456789", "234567890", optionsCounts)).toMatchSnapshot()
	expect(diff("oneline", "multi\nline", optionsCounts)).toMatchSnapshot()
	expect(diff("multi\nline", "oneline", optionsCounts)).toMatchSnapshot()
end)

describe("falls back to not call toJSON", function()
	describe("if serialization has no differences", function()
		local toJSON = function()
			return "it’s all the same to me"
		end

		it("but then objects have differences", function()
			local a = { line = 1, toJSON = toJSON }
			local b = { line = 2, toJSON = toJSON }
			expect(diff(a, b, optionsCounts)).toMatchSnapshot()
		end)
		it("and then objects have no differences", function()
			local a = { line = 2, toJSON = toJSON }
			local b = { line = 2, toJSON = toJSON }
			expect(stripped(a, b)).toBe(NO_DIFF_MESSAGE)
		end)
	end)
	describe("if it throws", function()
		local toJSON = function()
			error("catch me if you can")
		end

		it("and then objects have differences", function()
			local a = { line = 1, toJSON = toJSON }
			local b = { line = 2, toJSON = toJSON }
			expect(diff(a, b, optionsCounts)).toMatchSnapshot()
		end)
		it("and then objects have no differences", function()
			local a = { line = 2, toJSON = toJSON }
			local b = { line = 2, toJSON = toJSON }
			expect(stripped(a, b)).toBe(NO_DIFF_MESSAGE)
		end)
	end)
end)

-- Some of the following assertions seem complex, but compare to alternatives:
-- * toBe instead of toMatchSnapshot:
--   * to avoid visual complexity of escaped quotes in expected string
--   * to omit Expected/Received heading which is an irrelevant detail
-- * join lines of expected string instead of multiline string:
--   * to avoid ambiguity about indentation in diff lines

describe("multiline strings", function()
	local a = [[
line 1
line 2
line 3
line 4]]
	local b = [[
line 1
line  2
line 3
line 4]]
	local expected = table.concat({
		"  line 1",
		"- line 2",
		"+ line  2",
		"  line 3",
		"  line 4",
	}, "\n")

	it("(unexpanded)", function()
		expect(diff(a, b, unexpandedBe)).toBe(expected)
	end)
	it("(expanded)", function()
		expect(diff(a, b, expandedBe)).toBe(expected)
	end)
end)

-- ROBLOX deviation: modified to be tables instead of objects
describe("tables", function()
	local a = { a = { b = { c = 5 } } }
	local b = { a = { b = { c = 6 } } }
	local expected = table.concat({
		"  Table {",
		'    "a": Table {',
		'      "b": Table {',
		'-       "c": 5,',
		'+       "c": 6,',
		"      },",
		"    },",
		"  }",
	}, "\n")

	it("(unexpanded)", function()
		expect(diff(a, b, unexpandedBe)).toBe(expected)
	end)
	it("(expanded)", function()
		expect(diff(a, b, expandedBe)).toBe(expected)
	end)
end)

it("numbers", function()
	expect(diff(1, 2, optionsBe)).toBe("- 1\n+ 2")
end)

it("-0 and 0", function()
	expect(diff(-0, 0, optionsBe)).toBe("- -0\n+ 0")
end)

it("booleans", function()
	expect(diff(false, true, optionsBe)).toBe("- false\n+ true")
end)

describe("multiline string non-snapshot", function()
	-- For example, CLI output
	-- toBe or toEqual for a string isn’t enclosed in double quotes.
	local a = [=[
Options:
--help, -h  Show help                            [boolean]
--bail, -b  Exit the test suite immediately upon the first
            failing test.                        [boolean]]=]
	local b = [=[
Options:
  --help, -h  Show help                            [boolean]
  --bail, -b  Exit the test suite immediately upon the first
              failing test.                        [boolean]]=]
	local expected = table.concat({
		"  Options:",
		"- --help, -h  Show help                            [boolean]",
		"- --bail, -b  Exit the test suite immediately upon the first",
		"-             failing test.                        [boolean]",
		"+   --help, -h  Show help                            [boolean]",
		"+   --bail, -b  Exit the test suite immediately upon the first",
		"+               failing test.                        [boolean]",
	}, "\n")

	it("(unexpanded)", function()
		expect(diff(a, b, unexpandedBe)).toBe(expected)
	end)
	it("(expanded)", function()
		expect(diff(a, b, expandedBe)).toBe(expected)
	end)
end)

describe("multiline string snapshot", function()
	-- For example, CLI output
	-- A snapshot of a string is enclosed in double quotes.
	local a = [["
Options:
--help, -h  Show help                            [boolean]
--bail, -b  Exit the test suite immediately upon the first
            failing test.                        [boolean]"]]
	local b = [["
Options:
  --help, -h  Show help                            [boolean]
  --bail, -b  Exit the test suite immediately upon the first
              failing test.                        [boolean]"]]
	local expected = table.concat({
		'  "',
		"  Options:",
		"- --help, -h  Show help                            [boolean]",
		"- --bail, -b  Exit the test suite immediately upon the first",
		'-             failing test.                        [boolean]"',
		"+   --help, -h  Show help                            [boolean]",
		"+   --bail, -b  Exit the test suite immediately upon the first",
		'+               failing test.                        [boolean]"',
	}, "\n")

	it("(unexpanded)", function()
		expect(diff(a, b, unexpandedBe)).toBe(expected)
	end)
	it("(expanded)", function()
		expect(diff(a, b, expandedBe)).toBe(expected)
	end)
end)

-- TODO: react elements

-- ROBLOX deviation: Tables instead of Object
describe("multiline string as value of object property", function()
	local expected = table.concat({
		"  Table {",
		'    "id": "J",',
		'    "points": "0.5,0.460',
		"+ 0.5,0.875",
		'  0.25,0.875",',
		"  }",
	}, "\n")

	describe("(non-snapshot)", function()
		local a = {
			id = "J",
			points = "0.5,0.460\n0.25,0.875",
		}
		local b = {
			id = "J",
			points = "0.5,0.460\n0.5,0.875\n0.25,0.875",
		}
		it("(unexpanded)", function()
			expect(diff(a, b, unexpandedBe)).toBe(expected)
		end)
		it("(expanded)", function()
			expect(diff(a, b, expandedBe)).toBe(expected)
		end)
	end)

	describe("(snapshot)", function()
		local a = table.concat({
			"Table {",
			'  "id": "J",',
			'  "points": "0.5,0.460',
			'0.25,0.875",',
			"}",
		}, "\n")
		local b = table.concat({
			"Table {",
			'  "id": "J",',
			'  "points": "0.5,0.460',
			"0.5,0.875",
			'0.25,0.875",',
			"}",
		}, "\n")
		it("(unexpanded)", function()
			expect(diff(a, b, unexpandedBe)).toBe(expected)
		end)
		it("(expanded)", function()
			expect(diff(a, b, expandedBe)).toBe(expected)
		end)
	end)
end)

-- ROBLOX deviation: Tables instead of Object and Array
describe("indentation in JavaScript structures", function()
	local searching = ""
	local object = {
		descending = false,
		fieldKey = "what",
	}
	local a = {
		searching = searching,
		sorting = object,
	}
	local b = {
		searching = searching,
		sorting = { object },
	}

	describe("from less to more", function()
		local expected = table.concat({
			"  Table {",
			'    "searching": "",',
			-- ROBLOX deviation: no diff here because Object and Array are both Table
			-- '-   "sorting": Object {',
			-- '+   "sorting": Array [',
			'    "sorting": Table {',
			"+     Table {",
			-- following 3 lines are unchanged, except for more indentation
			'        "descending": false,',
			'        "fieldKey": "what",',
			-- ROBLOX deviation: diff is on the inner Table
			"+     },",
			"    },",
			"  }",
		}, "\n")

		it("(unexpanded)", function()
			expect(diff(a, b, unexpandedBe)).toBe(expected)
		end)
		it("(expanded)", function()
			expect(diff(a, b, expandedBe)).toBe(expected)
		end)
	end)

	describe("from more to less", function()
		local expected = table.concat({
			"  Table {",
			'    "searching": "",',
			-- ROBLOX deviation: no diff here because Object and Array are both Table
			-- '-   "sorting": Array [',
			-- '-     Object {',
			-- '+   "sorting": Object {',
			'    "sorting": Table {',
			"-     Table {",
			-- following 3 lines are unchanged, except for less indentation
			'      "descending": false,',
			'      "fieldKey": "what",',
			"-     },",
			"    },",
			"  }",
		}, "\n")

		it("(unexpanded)", function()
			expect(diff(b, a, unexpandedBe)).toBe(expected)
		end)
		it("(expanded)", function()
			expect(diff(b, a, expandedBe)).toBe(expected)
		end)
	end)
end)

describe("color of text", function()
	local searching = ""
	local object = {
		descending = false,
		fieldKey = "what",
	}
	local a = {
		searching = searching,
		sorting = object,
	}
	local b = {
		searching = searching,
		sorting = { object },
	}
	local received = diff(a, b, expanded)

	it("(expanded)", function()
		expect(received).toMatchSnapshot()
	end)
	it("(unexpanded)", function()
		-- Expect same result, unless diff is long enough to require patch marks.
		expect(diff(a, b, unexpanded)).toBe(received)
	end)
end)

-- TODO: react elements

describe("trailing newline in multiline string not enclosed in quotes", function()
	local a = table.concat({ "line 1", "line 2", "line 3" }, "\n")
	local b = a .. "\n"

	describe("from less to more", function()
		local expected = table.concat({ "  line 1", "  line 2", "  line 3", "+" }, "\n")

		it("(unexpanded)", function()
			expect(diff(a, b, unexpandedBe)).toBe(expected)
		end)
		it("(expanded)", function()
			expect(diff(a, b, expandedBe)).toBe(expected)
		end)
	end)

	describe("from more to less", function()
		local expected = table.concat({ "  line 1", "  line 2", "  line 3", "-" }, "\n")

		it("(unexpanded)", function()
			expect(diff(b, a, unexpandedBe)).toBe(expected)
		end)
		it("(expanded)", function()
			expect(diff(b, a, expandedBe)).toBe(expected)
		end)
	end)
end)

it("collapses big diffs to patch format", function()
	local result = diff(
		{ test = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 } },
		{ test = { 1, 2, 3, 4, 5, 6, 7, 8, 10, 9 } },
		unexpanded
	)

	expect(result).toMatchSnapshot()
end)

describe("context", function()
	local testDiffContextLines = function(contextLines: number?)
		local validContextLines = typeof(contextLines) == "number"
			and Number.isSafeInteger(contextLines)
			and contextLines >= 0

		local numLines
		if typeof(contextLines) == "number" then
			numLines = contextLines
		end
		local validLines = "(5 default)"
		if validContextLines then
			validLines = ""
		end
		local testName = string.format("number of lines: %s %s", tostring(numLines), validLines)
		it(testName, function()
			local options = tableCopy(optionsCounts)
			options["contextLines"] = contextLines
			options["expand"] = false

			if not validContextLines then
				options.patchColor = chalk.dim
			end

			local result = diff(
				{ test = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 } },
				{ test = { 1, 2, 3, 4, 5, 6, 7, 8, 10, 9 } },
				options
			)
			expect(result).toMatchSnapshot()
		end)
	end

	testDiffContextLines(-1) -- (5 default)
	testDiffContextLines(0)
	testDiffContextLines(1)
	testDiffContextLines(2)
	testDiffContextLines(3.1) -- (5 default)
	testDiffContextLines() -- (5 default)
end)

describe("diffLinesUnified edge cases", function()
	it("a empty string b empty string", function()
		local a = ""
		local b = ""

		local received = diffLinesUnified(string.split(a, "\n"), string.split(b, "\n"), optionsBe)
		local expected = ""

		expect(received).toBe(expected)
	end)

	it("a empty string b one line", function()
		local a = ""
		local b = "line 1"

		local received = diffLinesUnified(string.split(a, "\n"), string.split(b, "\n"), optionsBe)
		local expected = "+ line 1"

		expect(received).toBe(expected)
	end)

	it("a multiple lines b empty string", function()
		local a = "line 1\n\nline 3"
		local b = ""

		local received = diffLinesUnified(string.split(a, "\n"), string.split(b, "\n"), optionsBe)
		local expected = "- line 1\n-\n- line 3"

		expect(received).toBe(expected)
	end)

	it("a one line b multiple lines", function()
		local a = "line 2"
		local b = "line 1\nline 2\nline 3"

		local received = diffLinesUnified(string.split(a, "\n"), string.split(b, "\n"), optionsBe)
		local expected = "+ line 1\n  line 2\n+ line 3"

		expect(received).toBe(expected)
	end)
end)

describe("diffLinesUnified2 edge cases", function()
	it("a empty string b empty string", function()
		local a = ""
		local b = ""

		local received = diffLinesUnified2(
			string.split(a, "\n"),
			string.split(b, "\n"),
			string.split(a, "\n"),
			string.split(b, "\n"),
			optionsBe
		)
		local expected = ""

		expect(received).toBe(expected)
	end)

	it("a empty string b one line", function()
		local a = ""
		local b = "line 1"

		local received = diffLinesUnified2(
			string.split(a, "\n"),
			string.split(b, "\n"),
			string.split(a, "\n"),
			string.split(b, "\n"),
			optionsBe
		)
		local expected = "+ line 1"

		expect(received).toBe(expected)
	end)

	it("a multiple lines b empty string", function()
		local a = "line 1\n\nline 3"
		local b = ""

		local received = diffLinesUnified2(
			string.split(a, "\n"),
			string.split(b, "\n"),
			string.split(a, "\n"),
			string.split(b, "\n"),
			optionsBe
		)
		local expected = "- line 1\n-\n- line 3"

		expect(received).toBe(expected)
	end)

	it("a one line b multiple lines", function()
		local aDisplay = "LINE 2"
		local bDisplay = "Line 1\nLine 2\nLine 3"
		local aCompare = string.lower(aDisplay)
		local bCompare = string.lower(bDisplay)

		local received = diffLinesUnified2(
			string.split(aDisplay, "\n"),
			string.split(bDisplay, "\n"),
			string.split(aCompare, "\n"),
			string.split(bCompare, "\n"),
			optionsBe
		)
		local expected = "+ Line 1\n  Line 2\n+ Line 3"

		expect(received).toBe(expected)
	end)

	describe("lengths not equal", function()
		-- Fall back to diff of display lines.

		it("a", function()
			local aDisplay = "MiXeD cAsE"
			local bDisplay = "Mixed case\nUPPER CASE"
			local aCompare = string.lower(aDisplay) .. "\nlower case"
			local bCompare = string.lower(bDisplay)

			local received = diffLinesUnified2(
				string.split(aDisplay, "\n"),
				string.split(bDisplay, "\n"),
				string.split(aCompare, "\n"),
				string.split(bCompare, "\n"),
				optionsBe
			)
			local expected = "- MiXeD cAsE\n+ Mixed case\n+ UPPER CASE"

			expect(received).toBe(expected)
		end)

		it("b", function()
			local aDisplay = '{\n  "key": "value",\n}'
			local bDisplay = "{\n}"
			local aCompare = '{\n"key": "value",\n}'
			local bCompare = "{}"

			local expected = '  {\n-   "key": "value",\n  }'
			local received = diffLinesUnified2(
				string.split(aDisplay, "\n"),
				string.split(bDisplay, "\n"),
				string.split(aCompare, "\n"),
				string.split(bCompare, "\n"),
				optionsBe
			)

			expect(received).toBe(expected)
		end)
	end)
end)

describe("diffStringsUnified edge cases", function()
	it("empty both a and b", function()
		local a = ""
		local b = ""

		expect(diffStringsUnified(a, b, optionsCounts)).toMatchSnapshot()
	end)

	it("empty only a", function()
		local a = ""
		local b = "one-line string"

		expect(diffStringsUnified(a, b, optionsCounts)).toMatchSnapshot()
	end)

	it("empty only b", function()
		local a = "one-line string"
		local b = ""

		expect(diffStringsUnified(a, b, optionsCounts)).toMatchSnapshot()
	end)

	it("equal both non-empty", function()
		local a = "one-line string"
		local b = "one-line string"

		expect(diffStringsUnified(a, b, optionsCounts)).toMatchSnapshot()
	end)

	it("multiline has no common after clean up chaff", function()
		local a = "delete\ntwo"
		local b = "insert\n2"

		expect(diffStringsUnified(a, b, optionsCounts)).toMatchSnapshot()
	end)

	it("one-line has no common after clean up chaff", function()
		local a = "delete"
		local b = "insert"

		expect(diffStringsUnified(a, b, optionsCounts)).toMatchSnapshot()
	end)
end)

describe("options 7980", function()
	local a = "`${Ti.App.name} ${Ti.App.version} ${Ti.Platform.name} ${Ti.Platform.version}`"
	local b = "`${Ti.App.getName()} ${Ti.App.getVersion()} ${Ti.Platform.getName()} ${Ti.Platform.getVersion()}`"

	local options = {
		aAnnotation = "Original",
		aColor = chalk.red,
		bAnnotation = "Modified",
		bColor = chalk.green,
	}

	it("diff", function()
		expect(diff(a, b, options)).toMatchSnapshot()
	end)

	it("diffStringsUnified", function()
		expect(diffStringsUnified(a, b, options)).toMatchSnapshot()
	end)
end)

describe("options", function()
	local a = { "delete", "change from", "common" }
	local b = { "change to", "insert", "common" }

	local aString = "change from\ncommon" -- without delete
	local bString = "change to\ncommon" -- without insert

	describe("change indicators", function()
		local options = {
			aIndicator = "<",
			bIndicator = ">",
		}

		it("diff", function()
			expect(diff(a, b, options)).toMatchSnapshot()
		end)
	end)

	describe("change color", function()
		local options = {
			changeColor = chalk.bold,
			commonColor = chalk.yellow,
		}

		it("diffStringsUnified", function()
			local aChanged = table.concat(a, "\n"):gsub("change", "changed")
			local bChanged = table.concat(b, "\n"):gsub("change", "changed")
			expect(diffStringsUnified(aChanged, bChanged, options)).toMatchSnapshot()
		end)

		it("no diff", function()
			expect(diff(a, a, options)).toMatchSnapshot()
		end)
	end)

	describe("common", function()
		local options = {
			commonColor = noColor,
			commonIndicator = "=",
		}

		it("diff", function()
			expect(diff(a, b, options)).toMatchSnapshot()
		end)

		it("no diff", function()
			expect(diff(a, a, options)).toBe(NO_DIFF_MESSAGE)
		end)
	end)

	describe("includeChangeCounts false", function()
		local options = {
			includeChangeCounts = false,
		}

		it("diffLinesUnified", function()
			expect(diff(a, b, options)).toMatchSnapshot()
		end)

		it("diffStringsUnified", function()
			expect(diffStringsUnified(aString, bString, options)).toMatchSnapshot()
		end)
	end)

	describe("includeChangeCounts true padding", function()
		local options = {
			aAnnotation = "Before",
			bAnnotation = "After",
			includeChangeCounts = true,
		}

		it("diffLinesUnified a has 2 digits", function()
			local has2 = "common\na\na\na\na\na\na\na\na\na\na"
			local has1 = "common\nb"
			expect(diff(has2, has1, options)).toMatchSnapshot()
		end)

		it("diffLinesUnified b has 2 digits", function()
			local has1 = "common\na"
			local has2 = "common\nb\nb\nb\nb\nb\nb\nb\nb\nb\nb"
			expect(diff(has1, has2, options)).toMatchSnapshot()
		end)

		it("diffStringsUnified", function()
			expect(diffStringsUnified(aString, bString, options)).toMatchSnapshot()
		end)
	end)

	describe("omitAnnotationLines true", function()
		local options = {
			omitAnnotationLines = true,
		}

		it("diff", function()
			expect(diff(a, b, options)).toMatchSnapshot()
		end)

		it("diffStringsUnified and includeChangeCounts true", function()
			local options2 = tableCopy(options)
			options2["includeChangeCounts"] = true

			expect(diffStringsUnified(aString, bString, options2)).toMatchSnapshot()
		end)

		it("diffStringsUnified empty strings", function()
			expect(diffStringsUnified("", "", options)).toMatchSnapshot()
		end)
	end)

	describe("trailingSpaceFormatter", function()
		local aTrailingSpaces = table.concat({
			"delete 1 trailing space: ",
			"common 2 trailing spaces:  ",
			"insert 1 trailing space:",
		}, "\n")
		local bTrailingSpaces = table.concat({
			"delete 1 trailing space:",
			"common 2 trailing spaces:  ",
			"insert 1 trailing space: ",
		}, "\n")

		it("diff default no color", function()
			expect(diff(aTrailingSpaces, bTrailingSpaces)).toMatchSnapshot()
		end)

		it("diff middle dot", function()
			local replaceSpacesWithMiddleDot = function(s: string)
				return string.rep("·", #s)
			end
			local options = {
				changeLineTrailingSpaceColor = replaceSpacesWithMiddleDot,
				commonLineTrailingSpaceColor = replaceSpacesWithMiddleDot,
			}

			expect(diff(aTrailingSpaces, bTrailingSpaces, options)).toMatchSnapshot()
		end)

		it("diff yellowish common", function()
			local options = {
				commonLineTrailingSpaceColor = chalk.bgYellow,
			}

			expect(diff(aTrailingSpaces, bTrailingSpaces, options)).toMatchSnapshot()
		end)
	end)

	describe("emptyFirstOrLastLinePlaceholder default empty string", function()
		local options = tableCopy(optionsBe)
		options["changeColor"] = noColor

		local aEmpty = "\ncommon\nchanged from\n"
		local bEmpty = "\ncommon\nchanged to\n"

		local expected = table.concat({
			"",
			"  common",
			"- changed from",
			"+ changed to",
			"",
		}, "\n")

		it("diff", function()
			expect(diff(aEmpty, bEmpty, options)).toBe(expected)
		end)

		it("diffStringsUnified", function()
			expect(diffStringsUnified(aEmpty, bEmpty, options)).toBe(expected)
		end)
	end)
end)

describe("compare keys", function()
	local a = { a = { d = 1, e = 1, f = 1 }, b = 1, c = 1 }
	local b = { a = { d = 1, e = 2, f = 1 }, b = 1, c = 1 }
	-- ROBLOX deviation start: skipping test in Lua we can't rely on the order of keys
	it.skip("keeps the object keys in their original order", function()
		local function compareKeys()
			return 0
		end
		local expected = Array.join({
			"  Table {",
			'    "a": Table {',
			'      "d": 1,',
			'-     "e": 1,',
			'+     "e": 2,',
			'      "f": 1,',
			"    },",
			'    "b": 1,',
			'    "c": 1,',
			"  }",
		}, "\n")
		expect(diff(a, b, Object.assign({}, optionsBe, { compareKeys = compareKeys }))).toBe(expected)
	end)
	-- ROBLOX deviation end

	it("sorts the object keys in reverse order", function()
		local function compareKeys(a: string, b: string)
			return if a > b then -1 else 1
		end
		local expected = Array.join({
			"  Table {",
			'    "c": 1,',
			'    "b": 1,',
			'    "a": Table {',
			'      "f": 1,',
			'-     "e": 1,',
			'+     "e": 2,',
			'      "d": 1,',
			"    },",
			"  }",
		}, "\n")
		expect(diff(a, b, Object.assign({}, optionsBe, { compareKeys = compareKeys }))).toBe(expected)
	end)

	-- ROBLOX deviation start: additional test to verify the compareKeys function
	it("sorts the object keys in ascending order", function()
		local compareKeys = function(a: string, b: string)
			return if a > b then 1 else -1
		end
		local expected = Array.join({
			"  Table {",
			'    "a": Table {',
			'      "d": 1,',
			'-     "e": 1,',
			'+     "e": 2,',
			'      "f": 1,',
			"    },",
			'    "b": 1,',
			'    "c": 1,',
			"  }",
		}, "\n")
		expect(diff(a, b, Object.assign({}, optionsBe, { compareKeys = compareKeys }))).toBe(expected)
	end)
	-- ROBLOX deviation end
end)

return {}
