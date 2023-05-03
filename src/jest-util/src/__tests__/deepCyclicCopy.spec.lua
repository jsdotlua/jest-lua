-- ROBLOX upstream: https://github.com/facebook/jest/tree/v28.0.0/packages/jest-util/src/__tests__/deepCyclicCopy.test.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Number = LuauPolyfill.Number
local Set = LuauPolyfill.Set
local Symbol = LuauPolyfill.Symbol

local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local expect = JestGlobals.expect
local it = JestGlobals.it

local deepCyclicCopy = require(script.Parent.Parent.deepCyclicCopy).default
it("returns the same value for primitive or function values", function()
	local function fn() end
	expect(deepCyclicCopy(nil)).toBe(nil)
	-- ROBLOX deviation: no difference between null and undefined in Lua
	-- expect(deepCyclicCopy(nil)).toBe(nil)
	expect(deepCyclicCopy(true)).toBe(true)
	expect(deepCyclicCopy(42)).toBe(42)
	expect(Number.isNaN(deepCyclicCopy(0 / 0))).toBe(true)
	expect(deepCyclicCopy("foo")).toBe("foo")
	expect(deepCyclicCopy(fn)).toBe(fn)
end)

it("does not execute getters/setters, but copies them", function()
	local fn = jest.fn()
	local obj = {
		-- @ts-expect-error
		foo = function(self)
			fn()
		end,
	}
	local copy = deepCyclicCopy(obj)
	--[[
			ROBLOX deviation: not property descriptors in Lua
			original code:
		expect(Object.getOwnPropertyDescriptor(copy, 'foo')).toBeDefined();
		]]
	expect(copy["foo"]).toBeDefined()
	expect(fn).never.toBeCalled()
end)

it("copies symbols", function()
	local symbol = Symbol("foo")
	local obj = { [symbol] = 42 }
	expect(deepCyclicCopy(obj)[symbol]).toBe(42)
end)

it("copies arrays as array objects", function()
	-- ROBLOX deviation: Lua doesn't support arrays with "holes"
	local array = { --[[nil,]]
		-- ROBLOX FIXME: have to cast first Array element to `any` to avoid type narrowing issue
		42 :: any,
		"foo",
		"bar",
		{},
		{},
	}

	expect(deepCyclicCopy(array)).toEqual(array)
	expect(Array.isArray(deepCyclicCopy(array))).toBe(true)
end)

it("handles cyclic dependencies", function()
	local cyclic: any = { a = 42, subcycle = {} }

	cyclic.subcycle.baz = cyclic
	cyclic.bar = cyclic

	expect(function()
		return deepCyclicCopy(cyclic)
	end).never.toThrow()

	local copy = deepCyclicCopy(cyclic)

	expect(copy.a).toBe(42)
	expect(copy.bar).toEqual(copy)
	expect(copy.subcycle.baz).toEqual(copy)
end)

it("uses the blacklist to avoid copying properties on the first level", function()
	local obj = {
		blacklisted = 41,
		blacklisted2 = 42,
		subObj = {
			blacklisted = 43,
		},
	}

	expect(deepCyclicCopy(obj, {
		blacklist = Set.new({ "blacklisted", "blacklisted2" }),
	})).toEqual({
		subObj = {
			blacklisted = 43,
		},
	})
end)

-- ROBLOX deviation START: prototypes are not supported
do
	it.skip("does not keep the prototype by default when top level is object", function()
		-- -- @ts-expect-error
		-- local sourceObject = (function()
		-- 	local self = {}
		-- 	return self
		-- end)() -- @ts-expect-error
		-- sourceObject.nestedObject = (function()
		-- 	local self = {}
		-- 	return self
		-- end)() -- @ts-expect-error
		-- sourceObject.nestedArray = (function()
		-- 	local self = {}
		-- 	-- @ts-expect-error
		-- 	self.length = 0
		-- 	return self
		-- end)()
		-- local spy = jest.spyOn(Array, "isArray"):mockImplementation(function(object)
		-- 	return object == sourceObject.nestedArray
		-- end)
		-- local copy = deepCyclicCopy(sourceObject, { keepPrototype = false })
		-- expect(Object.getPrototypeOf(copy)).never.toBe(Object.getPrototypeOf(sourceObject))
		-- expect(Object.getPrototypeOf(copy.nestedObject)).never.toBe(
		-- 	Object.getPrototypeOf(sourceObject.nestedObject)
		-- )
		-- expect(Object.getPrototypeOf(copy.nestedArray)).never.toBe(
		-- 	Object.getPrototypeOf(sourceObject.nestedArray)
		-- )
		-- expect(Object.getPrototypeOf(copy)).toBe(Object.getPrototypeOf({}))
		-- expect(Object.getPrototypeOf(copy.nestedObject)).toBe(Object.getPrototypeOf({}))
		-- expect(Object.getPrototypeOf(copy.nestedArray)).toBe(Object.getPrototypeOf({}))
		-- spy:mockRestore()
	end)

	it.skip("does not keep the prototype by default when top level is array", function()
		-- local spy = jest.spyOn(Array, "isArray"):mockImplementation(function()
		-- 	return true
		-- end) -- @ts-expect-error
		-- local sourceArray = (function()
		-- 	local self = {}
		-- 	-- @ts-expect-error
		-- 	self.length = 0
		-- 	return self
		-- end)()
		-- local copy = deepCyclicCopy(sourceArray)
		-- expect(Object.getPrototypeOf(copy)).never.toBe(Object.getPrototypeOf(sourceArray))
		-- expect(Object.getPrototypeOf(copy)).toBe(Object.getPrototypeOf({}))
		-- spy:mockRestore()
	end)

	it.skip("does not keep the prototype of arrays when keepPrototype = false", function()
		-- local spy = jest.spyOn(Array, "isArray"):mockImplementation(function()
		-- 	return true
		-- end) -- @ts-expect-error
		-- local sourceArray = (function()
		-- 	local self = {}
		-- 	-- @ts-expect-error
		-- 	self.length = 0
		-- 	return self
		-- end)()
		-- local copy = deepCyclicCopy(sourceArray, { keepPrototype = false })
		-- expect(Object.getPrototypeOf(copy)).never.toBe(Object.getPrototypeOf(sourceArray))
		-- expect(Object.getPrototypeOf(copy)).toBe(Object.getPrototypeOf({}))
		-- spy:mockRestore()
	end)

	it.skip("keeps the prototype of arrays when keepPrototype = true", function()
		-- local spy = jest.spyOn(Array, "isArray"):mockImplementation(function()
		-- 	return true
		-- end) -- @ts-expect-error
		-- local sourceArray = (function()
		-- 	local self = {}
		-- 	-- @ts-expect-error
		-- 	self.length = 0
		-- 	return self
		-- end)()
		-- local copy = deepCyclicCopy(sourceArray, { keepPrototype = true })
		-- expect(Object.getPrototypeOf(copy)).toBe(Object.getPrototypeOf(sourceArray))
		-- spy:mockRestore()
	end)

	it.skip("does not keep the prototype for objects when keepPrototype = false", function()
		-- -- @ts-expect-error
		-- local sourceobject = (function()
		-- 	local self = {}
		-- 	return self
		-- end)() -- @ts-expect-error
		-- sourceobject.nestedObject = (function()
		-- 	local self = {}
		-- 	return self
		-- end)() -- @ts-expect-error
		-- sourceobject.nestedArray = (function()
		-- 	local self = {}
		-- 	-- @ts-expect-error
		-- 	self.length = 0
		-- 	return self
		-- end)()
		-- local spy = jest.spyOn(Array, "isArray"):mockImplementation(function(object)
		-- 	return object == sourceobject.nestedArray
		-- end)
		-- local copy = deepCyclicCopy(sourceobject, { keepPrototype = false })
		-- expect(Object.getPrototypeOf(copy)).never.toBe(Object.getPrototypeOf(sourceobject))
		-- expect(Object.getPrototypeOf(copy.nestedObject)).never.toBe(
		-- 	Object.getPrototypeOf(sourceobject.nestedObject)
		-- )
		-- expect(Object.getPrototypeOf(copy.nestedArray)).never.toBe(
		-- 	Object.getPrototypeOf(sourceobject.nestedArray)
		-- )
		-- expect(Object.getPrototypeOf(copy)).toBe(Object.getPrototypeOf({}))
		-- expect(Object.getPrototypeOf(copy.nestedObject)).toBe(Object.getPrototypeOf({}))
		-- expect(Object.getPrototypeOf(copy.nestedArray)).toBe(Object.getPrototypeOf({}))
		-- spy:mockRestore()
	end)

	it.skip("keeps the prototype for objects when keepPrototype = true", function()
		-- -- @ts-expect-error
		-- local sourceObject = (function()
		-- 	local self = {}
		-- 	return self
		-- end)() -- @ts-expect-error
		-- sourceObject.nestedObject = (function()
		-- 	local self = {}
		-- 	return self
		-- end)() -- @ts-expect-error
		-- sourceObject.nestedArray = (function()
		-- 	local self = {}
		-- 	-- @ts-expect-error
		-- 	self.length = 0
		-- 	return self
		-- end)()
		-- local spy = jest.spyOn(Array, "isArray"):mockImplementation(function(object)
		-- 	return object == sourceObject.nestedArray
		-- end)
		-- local copy = deepCyclicCopy(sourceObject, { keepPrototype = true })
		-- expect(Object.getPrototypeOf(copy)).toBe(Object.getPrototypeOf(sourceObject))
		-- expect(Object.getPrototypeOf(copy.nestedObject)).toBe(Object.getPrototypeOf(sourceObject.nestedObject))
		-- expect(Object.getPrototypeOf(copy.nestedArray)).toBe(Object.getPrototypeOf(sourceObject.nestedArray))
		-- spy:mockRestore()
	end)
end
-- ROBLOX deviation END
