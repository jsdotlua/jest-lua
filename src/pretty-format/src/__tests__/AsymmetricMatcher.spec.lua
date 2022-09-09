-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/pretty-format/src/__tests__/AsymmetricMatcher.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local PrettyFormat = require(CurrentModule)
local prettyFormat = PrettyFormat.default
local plugins = PrettyFormat.plugins

local AsymmetricMatcher = plugins.AsymmetricMatcher

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- ROBLOX deviation: don't need fnNameFor

local options
beforeEach(function()
	options = { plugins = { AsymmetricMatcher } }
end)

-- ROBLOX deviation: modified to use our implementation of Any
for _, type_ in ipairs({
	"number",
	"string",
	"function",
	"table",
}) do
	it(string.format("supports any(%s)", type_), function()
		local result = prettyFormat(expect.any(type_), options)
		expect(result).toBe(string.format("Any<%s>", type_))
	end)

	it(string.format("supports nested any(%s)", type_), function()
		local result = prettyFormat({
			test = {
				nested = expect.any(type_),
			},
		}, options)
		expect(result).toBe(string.format('Table {\n  "test": Table {\n    "nested": Any<%s>,\n  },\n}', type_))
	end)
end

it("anything()", function()
	local result = prettyFormat(expect.anything(), options)
	expect(result).toEqual("Anything")
end)

it("arrayContaining()", function()
	local result = prettyFormat(expect.arrayContaining({ 1, 2 }), options)
	expect(result).toBe("ArrayContaining {\n" .. "  1,\n" .. "  2,\n" .. "}")
end)

it("arrayNotContaining()", function()
	local result = prettyFormat(expect.never.arrayContaining({ 1, 2 }), options)
	expect(result).toBe("ArrayNotContaining {\n" .. "  1,\n" .. "  2,\n" .. "}")
end)

it("objectContaining()", function()
	local result = prettyFormat(expect.objectContaining({ a = "test" }), options)
	expect(result).toBe("ObjectContaining {\n" .. '  "a": "test",\n' .. "}")
end)

it("objectNotContaining()", function()
	local result = prettyFormat(expect.never.objectContaining({ a = "test" }), options)
	expect(result).toBe("ObjectNotContaining {\n" .. '  "a": "test",\n' .. "}")
end)

it("stringContaining(string)", function()
	local result = prettyFormat(expect.stringContaining("jest"), options)
	expect(result).toBe('StringContaining "jest"')
end)

-- ROBLOX deviation: custom test for stringContaining to test Lua patterns
it("stringContaining(string with magic characters)", function()
	local result = prettyFormat(expect.stringContaining("jest*"), options)
	expect(result).toBe('StringContaining "jest*"')
end)

it("never.stringContaining(string)", function()
	local result = prettyFormat(expect.never.stringContaining("jest"), options)
	expect(result).toBe('StringNotContaining "jest"')
end)

-- ROBLOX deviation: we use Lua string patterns instead of regex
it("stringMatching(string)", function()
	local result = prettyFormat(expect.stringMatching("jest"), options)
	expect(result).toBe('StringMatching "jest"')
end)

-- ROBLOX deviation: modified to remove alternations
it("stringMatching(pattern)", function()
	local result = prettyFormat(expect.stringMatching("(jest).*"), options)
	expect(result).toBe('StringMatching "(jest).*"')
end)

-- ROBLOX deviation: omitted, escapeRegex doesn't do anything since we don't have regex

it("stringNotMatching(string)", function()
	local result = prettyFormat(expect.never.stringMatching("jest"), options)
	expect(result).toBe('StringNotMatching "jest"')
end)

it("supports multiple nested asymmetric matchers", function()
	local result = prettyFormat({
		test = {
			nested = expect.objectContaining({
				a = expect.arrayContaining({ 1 }),
				b = expect.anything(),
				c = expect.any("string"),
				d = expect.stringContaining("jest"),
				e = expect.stringMatching("jest"),
				f = expect.objectContaining({ test = "case" }),
			}),
		},
	}, options)
	expect(result).toBe(
		"Table {\n"
			.. '  "test": Table {\n'
			.. '    "nested": ObjectContaining {\n'
			.. '      "a": ArrayContaining {\n'
			.. "        1,\n"
			.. "      },\n"
			.. '      "b": Anything,\n'
			.. '      "c": Any<string>,\n'
			.. '      "d": StringContaining "jest",\n'
			.. '      "e": StringMatching "jest",\n'
			.. '      "f": ObjectContaining {\n'
			.. '        "test": "case",\n'
			.. "      },\n"
			.. "    },\n"
			.. "  },\n"
			.. "}"
	)
end)

-- ROBLOX deviation: our prettyFormat collapses Object{} and Array[] into just Table{}
describe("indent option", function()
	local val = {
		nested = expect.objectContaining({
			a = expect.arrayContaining({ 1 }),
			b = expect.anything(),
			c = expect.any("string"),
			d = expect.stringContaining("jest"),
			e = expect.stringMatching("jest"),
			f = expect.objectContaining({
				composite = { "exact", "match" },
				primitive = "string",
			}),
		}),
	}
	local result = "Table {\n"
		.. '  "nested": ObjectContaining {\n'
		.. '    "a": ArrayContaining {\n'
		.. "      1,\n"
		.. "    },\n"
		.. '    "b": Anything,\n'
		.. '    "c": Any<string>,\n'
		.. '    "d": StringContaining "jest",\n'
		.. '    "e": StringMatching "jest",\n'
		.. '    "f": ObjectContaining {\n'
		.. '      "composite": Table {\n'
		.. '        "exact",\n'
		.. '        "match",\n'
		.. "      },\n"
		.. '      "primitive": "string",\n'
		.. "    },\n"
		.. "  },\n"
		.. "}"

	it("default implicit: 2 spaces", function()
		expect(prettyFormat(val, options)).toBe(result)
	end)
	it("default explicit: 2 spaces", function()
		options.indent = 2
		expect(prettyFormat(val, options)).toBe(result)
	end)

	-- Tests assume that no strings in val contain multiple adjacent spaces!
	it("non-default: 0 spaces", function()
		options.indent = 0
		expect(
			-- ROBLOX FIXME Luau: workaround bizarre false positive that doesn't repro in isolation: TypeError: Argument count mismatch. Function expects 1 argument, but 2 are specified
			prettyFormat(val, options)
		).toBe(result:gsub("  ", "") :: any)
	end)
	it("non-default: 4 spaces", function()
		options.indent = 4
		-- ROBLOX FIXME Luau: workaround bizarre false positive that doesn't repro in isolation: TypeError: Argument count mismatch. Function expects 1 argument, but 2 are specified
		expect(prettyFormat(val, options)).toBe(result:gsub("  ", "    ") :: any)
	end)
end)

describe("maxDepth option", function()
	it("matchers as leaf nodes", function()
		options.maxDepth = 2
		local val = {
			-- ++depth === 1
			nested = {
				-- ++depth === 2
				expect.arrayContaining(
					-- ++depth === 3
					{ 1 }
				),
				expect.objectContaining({
					-- ++depth === 3
					composite = { "exact", "match" },
					primitive = "string",
				}),
				expect.stringContaining("jest"),
				expect.stringMatching("jest"),
				expect.any("string"),
				expect.anything(),
			},
		}
		local result = prettyFormat(val, options)
		expect(result).toBe(
			"Table {\n"
				.. '  "nested": Table {\n'
				.. "    [ArrayContaining],\n"
				.. "    [ObjectContaining],\n"
				.. '    StringContaining "jest",\n'
				.. '    StringMatching "jest",\n'
				.. "    Any<string>,\n"
				.. "    Anything,\n"
				.. "  },\n"
				.. "}"
		)
	end)
	it("matchers as internal nodes", function()
		options.maxDepth = 2
		local val = {
			-- ++depth === 1
			expect.arrayContaining({
				-- ++depth === 2
				"printed",
				{
					-- ++depth === 3
					properties = "not printed",
					-- ROBLOX FIXME Luau: Luau needs to support mixed arrays
				} :: any,
			}),
			expect.objectContaining({
				-- ++depth === 2
				array = {
					-- ++depth === 3
					"items",
					"not",
					"printed",
				},
				primitive = "printed",
			}),
		}
		local result = prettyFormat(val, options)
		expect(result).toBe(
			"Table {\n"
				.. "  ArrayContaining {\n"
				.. '    "printed",\n'
				.. "    [Table],\n"
				.. "  },\n"
				.. "  ObjectContaining {\n"
				.. '    "array": [Table],\n'
				.. '    "primitive": "printed",\n'
				.. "  },\n"
				.. "}"
		)
	end)
end)

it("min option", function()
	options.min = true
	local result = prettyFormat({
		test = {
			nested = expect.objectContaining({
				a = expect.arrayContaining({ 1 }),
				b = expect.anything(),
				c = expect.any("string"),
				d = expect.stringContaining("jest"),
				e = expect.stringMatching("jest"),
				f = expect.objectContaining({ test = "case" }),
			}),
		},
	}, options)
	expect(result).toBe(
		"{"
			.. '"test": {'
			.. '"nested": ObjectContaining {'
			.. '"a": ArrayContaining {1}, '
			.. '"b": Anything, '
			.. '"c": Any<string>, '
			.. '"d": StringContaining "jest", '
			.. '"e": StringMatching "jest", '
			.. '"f": ObjectContaining {"test": "case"}'
			.. "}"
			.. "}"
			.. "}"
	)
end)

return {}
