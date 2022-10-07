-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/pretty-format/src/__tests__/prettyFormat.test.ts
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
local Error = LuauPolyfill.Error
local Set = LuauPolyfill.Set

local RegExp = require(Packages.RegExp)

local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local prettyFormat = require(CurrentModule).default

describe("prettyFormat()", function()
	-- ROBLOX deviation: omitted, no Argument type in lua

	it("prints an empty array", function()
		local val = {}
		expect(prettyFormat(val)).toEqual("Table {}")
	end)

	it("prints an array with items", function()
		local val = { 1, 2, 3 }
		expect(prettyFormat(val)).toEqual("Table {\n  1,\n  2,\n  3,\n}")
	end)

	-- ROBLOX deviation start: skipping test as Lua doesn't support sparse arrays with only holes
	it.skip("prints a sparse array with only holes", function()
		-- eslint-disable-next-line no-sparse-arrays
		local val = { nil, nil, nil, nil }
		expect(prettyFormat(val)).toEqual("Table {\n  ,\n  ,\n  ,\n}")
	end)
	-- ROBLOX deviation end

	it("prints a sparse array with items", function()
		-- eslint-disable-next-line no-sparse-arrays
		-- ROBLOX Luau FIXME: Luau needs to support mixed arrays
		local val = { 1 :: any, nil, nil, 4 }
		expect(prettyFormat(val)).toEqual("Table {\n  1,\n  ,\n  ,\n  4,\n}")
	end)

	-- ROBLOX deviation start: skipping test as Lua doesn't support sparse arrays with value surrounded by holes
	it.skip("prints a sparse array with value surrounded by holes", function()
		-- eslint-disable-next-line no-sparse-arrays
		-- ROBLOX Luau FIXME: Luau needs to support mixed arrays
		local val = { nil :: any, 5, nil, nil }
		expect(prettyFormat(val)).toEqual("Table {\n  ,\n  5,\n  ,\n}")
	end)
	-- ROBLOX deviation end

	-- ROBLOX deviation start: skipping test as Lua doesn't provide a way to differentiate between nil value a no value provided
	it.skip("prints a sparse array also containing undefined values", function()
		-- eslint-disable-next-line no-sparse-arrays
		-- ROBLOX Luau FIXME: Luau needs to support mixed arrays
		local val = { 1 :: any, nil, nil, nil, nil, 4 }
		expect(prettyFormat(val)).toEqual("Table {\n  1,\n  ,\n  nil,\n  nil,\n  ,\n  4,\n}")
	end)
	-- ROBLOX deviation end

	-- ROBLOX deviation: omitted, no typed arrays in lua

	it("prints a nested array", function()
		local val = { { 1, 2, 3 } }
		expect(prettyFormat(val)).toEqual("Table {\n  Table {\n    1,\n    2,\n    3,\n  },\n}")
	end)

	it("prints true", function()
		local val = true
		expect(prettyFormat(val)).toEqual("true")
	end)

	it("prints false", function()
		local val = false
		expect(prettyFormat(val)).toEqual("false")
	end)

	it("prints an error", function()
		local val = Error()
		expect(prettyFormat(val)).toEqual("[Error]")
	end)

	-- ROBLOX deviation: omitted, no Function constructor in lua

	it("prints an anonymous callback function", function()
		local val
		local f = function(cb)
			val = cb
		end
		f(function() end)
		expect(prettyFormat(val)).toEqual("[Function anonymous]")
	end)

	it("prints an anonymous assigned function", function()
		local val = function() end
		expect(prettyFormat(val)).toEqual("[Function anonymous]")
	end)

	it("can customize function names", function()
		local val = function() end
		expect(prettyFormat(val, {
			printFunctionName = false,
		})).toEqual("[Function]")
	end)

	it("prints inf", function()
		local val = math.huge
		expect(prettyFormat(val)).toEqual("inf")
	end)

	it("prints -inf", function()
		local val = -math.huge
		expect(prettyFormat(val)).toEqual("-inf")
	end)

	-- ROBLOX deviation: omitted, identical to 'prints an empty array' test

	it("prints a table with values", function()
		local val = {
			prop1 = "value1",
			prop2 = "value2",
		}
		expect(prettyFormat(val)).toEqual('Table {\n  "prop1": "value1",\n  "prop2": "value2",\n}')
	end)

	it("prints a table with non-string keys", function()
		local val = {
			-- ROBLOX FIXME Luau: Luau should support mixed index arrays indexers
			[false :: any] = "boolean",
			["false"] = "string",
			[0] = "number",
			["0"] = "string",
			["nil"] = "string",
		}
		local expected = table.concat({
			"Table {",
			'  false: "boolean",',
			'  0: "number",',
			'  "0": "string",',
			'  "false": "string",',
			'  "nil": "string",',
			"}",
		}, "\n")
		expect(prettyFormat(val)).toEqual(expected)
	end)

	-- ROBLOX deviation: separate test case for table keys because table ordering is non-deterministic
	it("prints a table with table keys", function()
		local val = {
			[{ "array", "key" }] = "array",
		}
		local expected = table.concat({
			"Table {",
			"  Table {",
			'    "array",',
			'    "key",',
			'  }: "array",',
			"}",
		}, "\n")
		expect(prettyFormat(val)).toEqual(expected)
	end)

	it("prints nan", function()
		local val = 0 / 0
		expect(prettyFormat(val)).toEqual("nan")
	end)

	it("prints nil", function()
		local val = nil
		expect(prettyFormat(val)).toEqual("nil")
	end)

	it("prints a positive number", function()
		local val = 123
		expect(prettyFormat(val)).toEqual("123")
	end)

	it("prints a negative number", function()
		local val = -123
		expect(prettyFormat(val)).toEqual("-123")
	end)

	it("prints zero", function()
		local val = 0
		expect(prettyFormat(val)).toEqual("0")
	end)

	it("prints negative zero", function()
		local val = -0
		expect(prettyFormat(val)).toEqual("-0")
	end)

	-- ROBLOX deviation: omitted, no BigInt type in lua

	-- ROBLOX deviation: Date modified to use Roblox DateTime
	it("prints a date", function()
		local val = DateTime.fromUnixTimestampMillis(10e11)
		expect(prettyFormat(val)).toEqual("2001-09-09T01:46:40.000Z")
	end)

	-- ROBLOX deviation: omitted, Roblox DateTime throws an error with an invalid constructor

	it("prints an object with sorted properties", function()
		-- eslint-disable-next-line sort-keys
		local val = { b = 1, a = 2 }
		expect(prettyFormat(val)).toEqual('Table {\n  "a": 2,\n  "b": 1,\n}')
	end)

	-- ROBLOX deviation start: skipping test in Lua we can't rely on the order of keys
	it.skip("prints an object with keys in their original order", function()
		-- eslint-disable-next-line sort-keys
		local val = { b = 1, a = 2 }
		local compareKeys = function()
			return 0
		end
		expect(prettyFormat(val, { compareKeys = compareKeys })).toEqual('Table {\n  "b": 1,\n  "a": 2,\n}')
	end)
	-- ROBLOX deviation end

	it("prints an object with keys sorted in reverse order", function()
		local val = { a = 1, b = 2 }
		local compareKeys = function(a: string, b: string)
			return if a > b then -1 else 1
		end
		expect(prettyFormat(val, { compareKeys = compareKeys })).toEqual('Table {\n  "b": 2,\n  "a": 1,\n}')
	end)

	-- ROBLOX deviation start: additional test to verify the compareKeys function
	it("prints an object with keys sorted in ascending order", function()
		local val = { a = 1, b = 2 }
		local compareKeys = function(a: string, b: string)
			return if a > b then 1 else -1
		end
		expect(prettyFormat(val, { compareKeys = compareKeys })).toEqual('Table {\n  "a": 1,\n  "b": 2,\n}')
	end)
	-- ROBLOX deviation end

	it("prints regular expressions from constructors", function()
		local val = RegExp("regexp")

		expect(prettyFormat(val)).toEqual("/regexp/")
	end)

	it("prints regular expressions from literals", function()
		-- ROBLOX deviation: we also use the RegExp polyfill here since we don't
		-- have regex literals. The 'g' flag is not supported so we just
		-- include the 'i' flag
		local val = RegExp("regexp", "i")

		expect(prettyFormat(val)).toEqual("/regexp/i")
	end)

	it("prints regular expressions {escapeRegex: false}", function()
		local val = RegExp([[regexp\d]], "i")

		expect(prettyFormat(val)).toEqual("/regexp\\d/i")
	end)

	it("prints regular expressions {escapeRegex: true}", function()
		local val = RegExp([[regexp\d]], "i")
		expect(prettyFormat(val, { escapeRegex = true })).toEqual("/regexp\\\\d/i")
	end)

	it("escapes regular expressions nested inside object", function()
		local obj = { test = RegExp("regexp\\d", "i") }

		expect(prettyFormat(obj, { escapeRegex = true })).toEqual('Table {\n  "test": /regexp\\\\d/i,\n}')
	end)

	it("prints an empty set", function()
		local val = Set.new()
		expect(prettyFormat(val)).toEqual("Set {}")
	end)

	it("prints a set with values", function()
		local val = Set.new()
		val:add("value1")
		val:add("value2")
		expect(prettyFormat(val)).toEqual('Set {\n  "value1",\n  "value2",\n}')
	end)

	it("prints a string", function()
		local val = "string"
		expect(prettyFormat(val)).toEqual('"string"')
	end)

	it("prints and escape a string", function()
		local val = "\"'\\"
		expect(prettyFormat(val)).toEqual('"\\"\'\\\\"')
	end)

	it("doesn't escape string with {escapeString: false}", function()
		local val = "\"'\\n"
		expect(prettyFormat(val, { escapeString = false })).toEqual('""\'\\n"')
	end)

	it("prints a string with escapes", function()
		expect(prettyFormat('"-"')).toEqual('"\\"-\\""')
		expect(prettyFormat("\\ \\\\")).toEqual('"\\\\ \\\\\\\\"')
	end)

	it("prints a multiline string", function()
		local val = table.concat({ "line 1", "line 2", "line 3" }, "\n")
		expect(prettyFormat(val)).toEqual('"' .. val .. '"')
	end)

	it("prints a multiline string as value of table", function()
		local polyline = {
			props = {
				id = "J",
				points = table.concat({ "0.5,0.460", "0.5,0.875", "0.25,0.875" }, "\n"),
			},
			type = "polyline",
		}
		local val = {
			props = {
				children = polyline,
			},
			type = "svg",
		}
		expect(prettyFormat(val)).toEqual(table.concat({
			"Table {",
			'  "props": Table {',
			'    "children": Table {',
			'      "props": Table {',
			'        "id": "J",',
			'        "points": "0.5,0.460',
			"0.5,0.875",
			'0.25,0.875",',
			"      },",
			'      "type": "polyline",',
			"    },",
			"  },",
			'  "type": "svg",',
			"}",
		}, "\n"))
	end)

	-- ROBLOX deviation: omitted, no Symbol, undefined, WeakMap, WeakSet

	-- ROBLOX deviation: converted these tests to use tables
	it("prints deeply nested tables", function()
		local val = { prop = { prop = { prop = "value" } } }
		expect(prettyFormat(val)).toEqual(
			'Table {\n  "prop": Table {\n    "prop": Table {\n      "prop": "value",\n    },\n  },\n}'
		)
	end)

	it("prints circular references", function()
		local val = {}
		val["prop"] = val
		expect(prettyFormat(val)).toEqual('Table {\n  "prop": [Circular],\n}')
	end)

	it("prints parallel references", function()
		local inner = {}
		local val = { prop1 = inner, prop2 = inner }
		expect(prettyFormat(val)).toEqual('Table {\n  "prop1": Table {},\n  "prop2": Table {},\n}')
	end)

	describe("indent option", function()
		local val = {
			{
				id = "8658c1d0-9eda-4a90-95e1-8001e8eb6036",
				-- ROBLOX FIXME Luau: Luau should infer val as { id: string, text: string?, type: string } without this explicit nil field
				text = "Add alternative serialize API for pretty-format plugins" :: string?,
				type = "ADD_TODO",
			},
			{
				id = "8658c1d0-9eda-4a90-95e1-8001e8eb6036",
				-- ROBLOX FIXME Luau: Luau should infer val as { id: string, text: string?, type: string } without this explicit nil field
				text = nil,
				type = "TOGGLE_TODO",
			},
		}
		local expected = table.concat({
			"Table {",
			"  Table {",
			'    "id": "8658c1d0-9eda-4a90-95e1-8001e8eb6036",',
			'    "text": "Add alternative serialize API for pretty-format plugins",',
			'    "type": "ADD_TODO",',
			"  },",
			"  Table {",
			'    "id": "8658c1d0-9eda-4a90-95e1-8001e8eb6036",',
			'    "type": "TOGGLE_TODO",',
			"  },",
			"}",
		}, "\n")
		it("default implicit: 2 spaces", function()
			expect(prettyFormat(val)).toEqual(expected)
		end)
		it("default explicit: 2 spaces", function()
			expect(prettyFormat(val, { indent = 2 })).toEqual(expected)
		end)

		-- Tests assume that no strings in val contain multiple adjacent spaces!
		it("non-default: 0 spaces", function()
			local result = expected:gsub("  ", "")
			expect(prettyFormat(val, { indent = 0 })).toEqual(result)
		end)
		it("non-default: 4 spaces", function()
			local result = expected:gsub("  ", "    ")
			expect(prettyFormat(val, { indent = 4 })).toEqual(result)
		end)
	end)

	-- ROBLOX deviation: modified since Lua doesn't distinguish between an Array and Object
	it("can omit basic prototypes", function()
		local val = {
			deeply = { nested = { object = {} } },
			["empty array"] = {},
			["empty object"] = {},
			["nested array"] = { { {} } },
			-- ROBLOX deviation: omitted, no typed arrays in lua
			-- ['typed array']= new Uint8Array(),
		}
		expect(prettyFormat(val, { maxDepth = 2, printBasicPrototype = false })).toBe(Array.join({
			"{",
			'  "deeply": {',
			'    "nested": [Table],',
			"  },",
			'  "empty array": {},',
			'  "empty object": {},',
			'  "nested array": {',
			"    [Table],",
			"  },",
			-- ROBLOX deviation: omitted, no typed arrays in lua
			-- '  "typed array": Uint8Array [],',
			"}",
		}, "\n"))
	end)

	-- ROBLOX deviation: modified since we don't have most of these types
	it("can customize the max depth", function()
		local val = {
			{
				["array literal empty"] = {},
				["array literal non-empty"] = { "item" },
				["table nested"] = { name = { name = "value" } },
				["table non-empty"] = { name = "value" },
				["set empty"] = Set.new(),
				["set non-empty"] = Set.new({ "value" }),
			},
		}
		expect(prettyFormat(val, { maxDepth = 2 })).toEqual(table.concat({
			-- ROBLOX deviation: output re-ordered because we print keys alphabetically
			"Table {",
			"  Table {",
			'    "array literal empty": [Table],',
			'    "array literal non-empty": [Table],',
			'    "set empty": [Set],',
			'    "set non-empty": [Set],',
			'    "table nested": [Table],',
			'    "table non-empty": [Table],',
			"  },",
			"}",
		}, "\n"))
	end)

	it("throws on invalid options", function()
		expect(function()
			prettyFormat({}, { invalidOption = true })
		end).toThrow()
	end)

	it("supports plugins", function()
		local Foo = {
			name = "Foo",
		}

		expect(prettyFormat(Foo, {
			plugins = {
				{
					print = function()
						return "class Foo"
					end,
					test = function(object)
						return object.name == "Foo"
					end,
				},
			},
		})).toEqual("class Foo")
	end)

	it("supports plugins that return empty string", function()
		local val = {
			payload = "",
		}
		local options = {
			plugins = {
				{
					print = function(v)
						return v.payload
					end,
					test = function(v)
						return v and typeof(v.payload) == "string"
					end,
				},
			},
		}
		expect(prettyFormat(val, options)).toEqual("")
	end)

	it("throws if plugin does not return a string", function()
		local val = 123
		local options = {
			plugins = {
				{
					print = function(v)
						return v
					end,
					test = function(v)
						return true
					end,
				},
			},
		}
		expect(function()
			prettyFormat(val, options)
		end).toThrow()
	end)

	it("throws PrettyFormatPluginError if test throws an error", function()
		local options = {
			plugins = {
				{
					-- ROBLOX TODO: TS shouldn't allow this, contribute fix upstream
					print = function(_, _print, _indent, _pluginOptions, _colors)
						return ""
					end,
					test = function(_: any): boolean
						error("Where is the error?")
					end,
				},
			},
		}

		local _, err = pcall(function()
			prettyFormat("", options)
		end)
		expect(err.name).toBe("PrettyFormatPluginError")
	end)

	it("throws PrettyFormatPluginError if print throws an error", function()
		local options = {
			plugins = {
				{
					-- ROBLOX TODO: TS shouldn't allow this, contribute fix upstream
					print = function()
						error("Where is the error?")
					end :: any,
					test = function(_: any): boolean
						return true
					end,
				},
			},
		}

		local _, err = pcall(function()
			prettyFormat("", options)
		end)
		expect(err.name).toBe("PrettyFormatPluginError")
	end)

	it("throws PrettyFormatPluginError if serialize throws an error", function()
		local options = {
			plugins = {
				{
					-- ROBLOX TODO: TS shouldn't allow this, contribute fix upstream
					serialize = function()
						error("Where is the error?")
					end :: any,
					test = function(_: any): boolean
						return true
					end,
				},
			},
		}

		local _, err = pcall(function()
			prettyFormat("", options)
		end)
		expect(err.name).toBe("PrettyFormatPluginError")
	end)

	it("supports plugins with deeply nested arrays (#24)", function()
		local val = {
			{ 1, 2 },
			{ 3, 4 },
		}
		expect(prettyFormat(val, {
			plugins = {
				{
					print = function(v, f)
						local t = {}
						for i, _ in ipairs(v) do
							t[i] = f(v[i])
						end
						return table.concat(t, " - ")
					end,
					test = function(v)
						return typeof(v) == "table"
					end,
				},
			},
		})).toEqual("1 - 2 - 3 - 4")
	end)

	it("should call plugins on nested basic values", function()
		local val = { prop = 42 }
		expect(prettyFormat(val, {
			plugins = {
				{
					print = function(_val, _print)
						return "[called]"
					end,
					test = function(v)
						return typeof(v) == "string" or typeof(v) == "number"
					end,
				},
			},
		})).toEqual("Table {\n  [called]: [called],\n}")
	end)

	-- ROBLOX deviation: omitted, identical to empty table test

	it("calls toJSON and prints its return value", function()
		expect(prettyFormat({
			toJSON = function()
				return { value = false }
			end,
			value = true,
		})).toEqual('Table {\n  "value": false,\n}')
	end)

	it("calls toJSON and prints an internal representation.", function()
		expect(prettyFormat({
			toJSON = function()
				return "[Internal Object]"
			end,
			value = true,
		})).toEqual('"[Internal Object]"')
	end)

	it("calls toJSON only on functions", function()
		expect(prettyFormat({
			toJSON = false,
			value = true,
		})).toEqual('Table {\n  "toJSON": false,\n  "value": true,\n}')
	end)

	it("does not call toJSON recursively", function()
		expect(prettyFormat({
			toJSON = function()
				return {
					toJSON = function()
						return { value = true }
					end,
				}
			end,
			value = false,
		})).toEqual('Table {\n  "toJSON": [Function toJSON],\n}')
	end)

	it("calls toJSON on Sets", function()
		local set = Set.new();
		(set :: any).toJSON = function()
			return "map"
		end
		expect(prettyFormat(set)).toEqual('"map"')
	end)

	-- ROBLOX deviation: test not included in upstream
	it("calls toJSON on Tables", function()
		local set = {}
		set.toJSON = function()
			return "map"
		end
		expect(prettyFormat(set)).toEqual('"map"')
	end)

	it("disables toJSON calls through options", function()
		local value = {
			apple = "banana",
			toJSON = function()
				return "1"
			end,
		}
		local set = Set.new({ value });
		(set :: any).toJSON = function()
			return "map"
		end
		expect(prettyFormat(set, {
			callToJSON = false,
		})).toEqual('Set {\n  Table {\n    "apple": "banana",\n    "toJSON": [Function toJSON' .. "],\n  },\n}")

		-- ROBLOX deviation: as of right now, calling prettyFormat on an object
		-- that has toJSON as a mocked function won't print the expected
		-- [Function anonymous] but rather it will print out the entire
		-- table of a mock (i.e. _isMockFunction, getMockImplementation, etc.)
		-- since our implementation of mocks are as tables with __call
		-- metafunctions. Therefore, we don't call an expectation on
		-- prettyFormat in the following code but rather just evaluate the
		-- toBeCalled expectations
		value = { apple = "banana", toJSON = jest.fn(function()
			return "1"
		end) }
		set = Set.new({ value });
		(set :: any).toJSON = jest.fn(function()
			return "map"
		end)
		prettyFormat(set, {
			callToJSON = false,
		})
		expect((set :: any).toJSON).never.toBeCalled()
		expect(value.toJSON).never.toBeCalled()
	end)

	-- ROBLOX deviation: test not included in upstream
	it("disables toJSON calls through options Lua", function()
		local value = {
			apple = "banana",
			toJSON = function()
				return "1"
			end,
		}
		local set = { [1] = value }
		set["toJSON"] = function()
			return "map"
		end
		expect(prettyFormat(set, {
			callToJSON = false,
		})).toEqual('Table {\n  Table {\n    "apple": "banana",\n    "toJSON": [Function toJSON' .. "],\n  },\n}")
	end)

	describe("min", function()
		it("prints some basic values in min mode", function()
			local val = {
				["boolean"] = { false, true },
				-- ROBLOX deviation: not set to nil because if value is nil then the key isn't set
				["nil"] = 0,
				["number"] = { 0, -0, 123, -123, math.huge, -math.huge, 0 / 0 },
				["string"] = { "", "non-empty" },
			}
			expect(prettyFormat(val, {
				min = true,
			})).toEqual("{" .. table.concat({
				'"boolean": {false, true}',
				'"nil": 0',
				'"number": {0, -0, 123, -123, inf, -inf, nan}',
				'"string": {"", "non-empty"}',
			}, ", ") .. "}")
		end)

		-- ROBLOX deviation: modified since we don't have most of these types
		it("prints some complex values in min mode", function()
			local val = {
				["array literal empty"] = {},
				["array literal non-empty"] = { "item" },
				["table non-empty"] = { name = "value" },
				["set empty"] = Set.new(),
				["set non-empty"] = Set.new({ "value" }),
			}
			expect(prettyFormat(val, {
				min = true,
			})).toEqual(
				-- ROBLOX deviation: output re-ordered because we print keys alphabetically
				"{"
					.. table.concat({
						'"array literal empty": {}',
						'"array literal non-empty": {"item"}',
						'"set empty": Set {}',
						'"set non-empty": Set {"value"}',
						'"table non-empty": {"name": "value"}',
					}, ", ")
					.. "}"
			)
		end)

		it("does not allow indent !== 0 in min mode", function()
			expect(function()
				prettyFormat(1, { indent = 1, min = true })
			end).toThrow()
		end)
	end)
end)

return {}
