-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/expect/src/__tests__/matchers.test.js
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

--[[
	Heavily modified tests from upstream just to check functionality of the
	equals() function without the overhead of all the matchers that have not
	been translated

	ROBLOX TODO: refactor tests once the matchers code has been translated
]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local LuauPolyfill = require(Packages.LuauPolyfill)
local Symbol = LuauPolyfill.Symbol
local Set = LuauPolyfill.Set

local RegExp = require(Packages.RegExp)

local jasmineUtils = require(CurrentModule.jasmineUtils)
local equals = jasmineUtils.equals
local fnNameFor = jasmineUtils.fnNameFor
local isA = jasmineUtils.isA

describe("cyclic object equality", function()
	it("properties with the same circularity are equal", function()
		local a = {}
		a.x = a
		local b = {}
		b.x = b

		expect(a).toEqual(b)
		expect(b).toEqual(a)

		local c = {}
		c.x = a
		local d = {}
		d.x = b
		expect(c).toEqual(d)
		expect(d).toEqual(c)
	end)

	it("properties with different circularity are not equal", function()
		local a = {}
		a.x = { y = a }
		local b = {}
		local bx = {}
		b.x = bx
		bx.y = bx
		expect(a).never.toEqual(b)
		expect(b).never.toEqual(a)
	end)

	it("are not equal if circularity is not on the same property", function()
		local a = {}
		local b = {}
		a.a = a
		b.a = {}
		b.a.a = a
		expect(a).never.toEqual(b)
		expect(b).never.toEqual(a)

		local c = {}
		c.x = { x = c }
		local d = {}
		d.x = d
		expect(c).never.toEqual(d)
		expect(d).never.toEqual(c)
	end)

	it("tests equality between symbols", function()
		local a = Symbol.for_("foo")
		local b = Symbol.for_("foo")

		expect(a).toEqual(b)

		local c = {}
		local d = {}

		c[a] = 5
		d[b] = 5

		expect(c).toEqual(d)
	end)

	it("tests circularity defined on different property", function()
		local a = {}
		local b = {}
		a.a = a
		b.a = {}
		b.a.a = a
		expect(a).never.toEqual(b)
		expect(b).never.toEqual(a)
	end)
end)

describe("equality edge cases", function()
	it("tests keys with false value", function()
		expect(equals({ { a = false, b = 2 } :: any, { b = 2 } })).toBe(false)
	end)

	it("tests equality of regex", function()
		expect(equals(RegExp("abc"), RegExp("abd"))).toBe(false)
		expect(equals(RegExp("abc", "m"), RegExp("abc", "m"))).toBe(true)
		expect(equals(RegExp("abc", "m"), RegExp("abc"))).toBe(false)
	end)
end)

describe("set equality", function()
	-- not yet supported, these tests should be moved to iterableEquality when that
	-- is repurposed for the Set polyfill
	it.skip("basic sets", function()
		expect(equals(Set.new({ 1, 2 }), Set.new({ 3, 4 }))).toBe(false)
		expect(equals(Set.new({ 1, 2 }), Set.new({ 1, 2 }))).toBe(true)
		expect(equals(Set.new({ 2, 1 }), Set.new({ 1, 2 }))).toBe(true)
	end)
end)

-- ROBLOX deviation: these tests do not correlate to any upstream tests
describe("minor jasmineUtils functions", function()
	it("tests fnNameFor", function()
		local func = function() end

		expect(fnNameFor(func)).toBe("[Function]")
	end)

	it("tests isA", function()
		local func = function() end
		expect(isA("function", func)).toBe(true)
		expect(isA("string", "abc")).toBe(true)
		expect(isA("boolean", true)).toBe(true)
	end)

	it("tests hasProperty", function()
		local objA = { prop3 = "test" }
		local metaA = { prop1 = 5, prop2 = "prop" }
		setmetatable(objA, { __index = metaA })
		expect(jasmineUtils.hasProperty(objA, "prop1")).toBe(true)
		expect(jasmineUtils.hasProperty(objA, "prop2")).toBe(true)
		expect(jasmineUtils.hasProperty(objA, "prop3")).toBe(true)
		expect(jasmineUtils.hasProperty(objA, "prop4")).toBe(false)

		local objB = { prop1 = "test" }
		local metaB = { prop1 = 3, prop2 = { a = 1, b = {} } }
		setmetatable(objB, {
			__index = function(table, key)
				return metaB[key]
			end,
		})
		expect(jasmineUtils.hasProperty(objB, "prop1")).toBe(true)
		expect(jasmineUtils.hasProperty(objB, "prop2")).toBe(true)
		expect(jasmineUtils.hasProperty(objB, "prop3")).toBe(false)

		local objC = { prop1 = "test" }
		setmetatable(objC, {
			__index = function(table, key)
				error("invalid access")
			end,
		})
		expect(function()
			jasmineUtils.hasProperty(objC, "prop1")
		end).never.toThrow()
		expect(function()
			jasmineUtils.hasProperty(objC, "prop2")
		end).toThrow()
	end)
end)
