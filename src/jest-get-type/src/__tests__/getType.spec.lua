-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-get-type/src/__tests__/getType.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local Error = require("@pkg/@jsdotlua/luau-polyfill").Error
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set
local Symbol = LuauPolyfill.Symbol

local RegExp = require("@pkg/luau-regexp")

local getType = require("../init").getType

describe(".getType()", function()
	it("nil", function()
		expect(getType(nil)).toBe("nil")
	end)

	--[[
			ROBLOX deviation: test omitted because lua has no primitive undefined type
			original code:
			test('undefined', () => expect(getType(undefined)).toBe('undefined'));
		]]

	--[[
			ROBLOX deviation: lua makes no distinction between tables, objects, and arrays
			original code:
			test('object', () => expect(getType({})).toBe('object'));
  			test('array', () => expect(getType([])).toBe('array'));
		]]
	it("table", function()
		expect(getType({})).toBe("table")
	end)

	it("number", function()
		expect(getType(1)).toBe("number")
	end)

	it("string", function()
		expect(getType("oi")).toBe("string")
	end)

	it("function", function()
		expect(getType(function() end)).toBe("function")
	end)

	it("boolean", function()
		expect(getType(true)).toBe("boolean")
	end)

	it("buffer", function()
		expect(getType(buffer.fromstring("test"))).toBe("buffer")
	end)

	-- ROBLOX deviation start: additional symbol tests
	it("symbol", function()
		expect(getType(Symbol("test"))).toBe("symbol")
		expect(getType(Symbol.for_("test"))).toBe("symbol")
		expect(getType(Symbol.for_("test2"))).toBe("symbol")
		expect(getType(Symbol())).toBe("symbol")
	end)
	-- ROBLOX deviation end

	it("regexp", function()
		expect(getType(RegExp("abc"))).toBe("regexp")
	end)

	it("map", function()
		expect(getType(Map.new())).toBe("map")
	end)

	it("set", function()
		expect(getType(Set.new())).toBe("set")
	end)

	-- ROBLOX deviation: checking DateTime instead of Date
	it("DateTime", function()
		expect(getType(DateTime.now())).toBe("DateTime")
	end)

	--[[
			ROBLOX deviation: test omitted because lua has no primitive bigint type
			original code:
			test('bigint', () => expect(getType(BigInt(1))).toBe('bigint'));
		]]

	-- ROBLOX deviation start: additional Luau tests
	it("error", function()
		expect(getType(Error("abc"))).toBe("error")
	end)

	it("Instance", function()
		expect(getType(Instance.new("Frame"))).toBe("Instance")
	end)

	it("userdata", function()
		expect(getType(newproxy())).toBe("userdata")
	end)
	-- ROBLOX deviation end
end)
