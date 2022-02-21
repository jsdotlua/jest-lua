-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/__tests__/deepCyclicCopy.test.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent
	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Array = LuauPolyfill.Array
	local Object = LuauPolyfill.Object
	local Number = LuauPolyfill.Number
	local Set = LuauPolyfill.Set
	local Symbol = LuauPolyfill.Symbol

	local jest = require(Packages.Dev.Jest)
	local jestExpect = require(Packages.Expect)

	local deepCyclicCopy = require(script.Parent.Parent.deepCyclicCopy).default
	it("returns the same value for primitive or function values", function()
		local function fn() end
		jestExpect(deepCyclicCopy(nil)).toBe(nil)
		-- ROBLOX deviation: no difference between null and undefined in Lua
		-- jestExpect(deepCyclicCopy(nil)).toBe(nil)
		jestExpect(deepCyclicCopy(true)).toBe(true)
		jestExpect(deepCyclicCopy(42)).toBe(42)
		jestExpect(Number.isNaN(deepCyclicCopy(0 / 0))).toBe(true)
		jestExpect(deepCyclicCopy("foo")).toBe("foo")
		jestExpect(deepCyclicCopy(fn)).toBe(fn)
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
		jestExpect(copy["foo"]).toBeDefined()
		jestExpect(fn).never.toBeCalled()
	end)

	it("copies symbols", function()
		local symbol = Symbol("foo")
		print("Symbol: ", symbol)
		local obj = { [symbol] = 42 }
		print(#Object.keys(obj))
		jestExpect(deepCyclicCopy(obj)[symbol]).toBe(42)
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

		jestExpect(deepCyclicCopy(array)).toEqual(array)
		jestExpect(Array.isArray(deepCyclicCopy(array))).toBe(true)
	end)

	it("handles cyclic dependencies", function()
		local cyclic: any = { a = 42, subcycle = {} }

		cyclic.subcycle.baz = cyclic
		cyclic.bar = cyclic

		jestExpect(function()
			return deepCyclicCopy(cyclic)
		end).never.toThrow()

		local copy = deepCyclicCopy(cyclic)

		jestExpect(copy.a).toBe(42)
		jestExpect(copy.bar).toEqual(copy)
		jestExpect(copy.subcycle.baz).toEqual(copy)
	end)

	it("uses the blacklist to avoid copying properties on the first level", function()
		local obj = {
			blacklisted = 41,
			blacklisted2 = 42,
			subObj = {
				blacklisted = 43,
			},
		}

		jestExpect(deepCyclicCopy(obj, {
			blacklist = Set.new({ "blacklisted", "blacklisted2" }),
		})).toEqual({
			subObj = {
				blacklisted = 43,
			},
		})
	end)

	-- ROBLOX deviation START: prototypes are not supported
	do
		itSKIP("does not keep the prototype by default when top level is object", function()
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
			-- jestExpect(Object.getPrototypeOf(copy)).never.toBe(Object.getPrototypeOf(sourceObject))
			-- jestExpect(Object.getPrototypeOf(copy.nestedObject)).never.toBe(
			-- 	Object.getPrototypeOf(sourceObject.nestedObject)
			-- )
			-- jestExpect(Object.getPrototypeOf(copy.nestedArray)).never.toBe(
			-- 	Object.getPrototypeOf(sourceObject.nestedArray)
			-- )
			-- jestExpect(Object.getPrototypeOf(copy)).toBe(Object.getPrototypeOf({}))
			-- jestExpect(Object.getPrototypeOf(copy.nestedObject)).toBe(Object.getPrototypeOf({}))
			-- jestExpect(Object.getPrototypeOf(copy.nestedArray)).toBe(Object.getPrototypeOf({}))
			-- spy:mockRestore()
		end)

		itSKIP("does not keep the prototype by default when top level is array", function()
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
			-- jestExpect(Object.getPrototypeOf(copy)).never.toBe(Object.getPrototypeOf(sourceArray))
			-- jestExpect(Object.getPrototypeOf(copy)).toBe(Object.getPrototypeOf({}))
			-- spy:mockRestore()
		end)

		itSKIP("does not keep the prototype of arrays when keepPrototype = false", function()
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
			-- jestExpect(Object.getPrototypeOf(copy)).never.toBe(Object.getPrototypeOf(sourceArray))
			-- jestExpect(Object.getPrototypeOf(copy)).toBe(Object.getPrototypeOf({}))
			-- spy:mockRestore()
		end)

		itSKIP("keeps the prototype of arrays when keepPrototype = true", function()
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
			-- jestExpect(Object.getPrototypeOf(copy)).toBe(Object.getPrototypeOf(sourceArray))
			-- spy:mockRestore()
		end)

		itSKIP("does not keep the prototype for objects when keepPrototype = false", function()
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
			-- jestExpect(Object.getPrototypeOf(copy)).never.toBe(Object.getPrototypeOf(sourceobject))
			-- jestExpect(Object.getPrototypeOf(copy.nestedObject)).never.toBe(
			-- 	Object.getPrototypeOf(sourceobject.nestedObject)
			-- )
			-- jestExpect(Object.getPrototypeOf(copy.nestedArray)).never.toBe(
			-- 	Object.getPrototypeOf(sourceobject.nestedArray)
			-- )
			-- jestExpect(Object.getPrototypeOf(copy)).toBe(Object.getPrototypeOf({}))
			-- jestExpect(Object.getPrototypeOf(copy.nestedObject)).toBe(Object.getPrototypeOf({}))
			-- jestExpect(Object.getPrototypeOf(copy.nestedArray)).toBe(Object.getPrototypeOf({}))
			-- spy:mockRestore()
		end)

		itSKIP("keeps the prototype for objects when keepPrototype = true", function()
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
			-- jestExpect(Object.getPrototypeOf(copy)).toBe(Object.getPrototypeOf(sourceObject))
			-- jestExpect(Object.getPrototypeOf(copy.nestedObject)).toBe(Object.getPrototypeOf(sourceObject.nestedObject))
			-- jestExpect(Object.getPrototypeOf(copy.nestedArray)).toBe(Object.getPrototypeOf(sourceObject.nestedArray))
			-- spy:mockRestore()
		end)
	end
	-- ROBLOX deviation END
end
