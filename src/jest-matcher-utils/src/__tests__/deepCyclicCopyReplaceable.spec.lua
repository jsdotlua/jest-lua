-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-matcher-utils/src/__tests__/deepCyclicCopyReplaceable.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local it = (JestGlobals.it :: any) :: Function
local itSKIP = JestGlobals.it.skip

local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Number = LuauPolyfill.Number

local deepCyclicCopyReplaceable = require(CurrentModule.deepCyclicCopyReplaceable)

type anyTable = { [any]: any }

it("returns the same value for primitive or function values", function()
	local fn = function() end

	expect(deepCyclicCopyReplaceable(nil)).toBe(nil)
	expect(deepCyclicCopyReplaceable(true)).toBe(true)
	expect(deepCyclicCopyReplaceable(42)).toBe(42)
	expect(Number.isNaN(deepCyclicCopyReplaceable(0 / 0))).toBe(true)
	expect(deepCyclicCopyReplaceable("foo")).toBe("foo")
	expect(deepCyclicCopyReplaceable(fn)).toBe(fn)
end)

-- ROBLOX deviation: test skipped because Lua doesn't have functionality
-- corresponding to these property descriptors
itSKIP("convert accessor descriptor into value descriptor", function()
	--[[
			const obj = {
				set foo(_) {},
				get foo() {
					return 'bar';
				},
			};
			expect(Object.getOwnPropertyDescriptor(obj, 'foo')).toEqual({
				configurable: true,
				enumerable: true,
				get: expect.any(Function),
				set: expect.any(Function),
			});
			const copy = deepCyclicCopyReplaceable(obj);

			expect(Object.getOwnPropertyDescriptor(copy, 'foo')).toEqual({
				configurable: true,
				enumerable: true,
				value: 'bar',
				writable: true,
			});
		]]
end)

-- ROBLOX deviation: test skipped because Lua has no concept of enumerables and
-- non-enumerables
itSKIP("shuold not skips non-enumerables", function()
	--[[
			const obj = {};
			Object.defineProperty(obj, 'foo', {enumerable: false, value: 'bar'});

			const copy = deepCyclicCopyReplaceable(obj);

			expect(Object.getOwnPropertyDescriptors(copy)).toEqual({
				foo: {
					configurable: true,
					enumerable: false,
					value: 'bar',
					writable: true,
				},
			});
		]]
end)

-- ROBLOX deviation: test skipped because Lua has no Symbol type
itSKIP("copies symbols", function()
	--[[
			const symbol = Symbol('foo');
  			const obj = {[symbol]: 42};

  			expect(deepCyclicCopyReplaceable(obj)[symbol]).toBe(42);
		]]
end)

it("copies arrays as array objects", function()
	local array = { 42, "foo", "bar", {}, {} }

	expect(deepCyclicCopyReplaceable(array)).toEqual(array)
	expect(Array.isArray(deepCyclicCopyReplaceable(array))).toBe(true)
end)

it("handles cyclic dependencies", function()
	local cyclic: anyTable = { a = 42, subcycle = {} }

	cyclic.subcycle.baz = cyclic
	cyclic.bar = cyclic

	expect(function()
		deepCyclicCopyReplaceable(cyclic)
	end).never.toThrow()

	local copy = deepCyclicCopyReplaceable(cyclic)

	expect(copy.a).toBe(42)
	expect(copy.bar).toEqual(copy)
	expect(copy.subcycle.baz).toEqual(copy)
end)

it("Copy Map", function()
	local map = { a = 1, b = 2 }

	local copy = deepCyclicCopyReplaceable(map)

	expect(map).toEqual(copy)

	-- ROBLOX deviation START: omitted expect call because there's no functionality to
	-- compare constructors in the same way
	-- expect(copy.constructor).toBe(Map);
	-- ROBLOX deviation END
end)

it("Copy cyclic Map", function()
	local map = { a = 1, b = 2 }
	map.map = map
	expect(deepCyclicCopyReplaceable(map)).toEqual(map)
end)

it("return same value for built-in object type except array, map and object", function()
	local date = DateTime.now()
	local numberArray = { 1, 2, 3 }
	local set = { foo = true, bar = true }

	expect(deepCyclicCopyReplaceable(date)).toBe(date)
	expect(deepCyclicCopyReplaceable(numberArray)).toEqual(numberArray)
	expect(deepCyclicCopyReplaceable(set)).toEqual(set)
	-- ROBLOX deviation: omitted expect calls because there are no distinct
	-- buffer or regular expression types in Lua
end)

-- ROBLOX deviation START: test skipped because Lua has no Symbol type
itSKIP("should copy object symbol key property", function()
	--[[
			const symbolKey = Symbol.for('key');
			expect(deepCyclicCopyReplaceable({[symbolKey]: 1})).toEqual({[symbolKey]: 1});
		]]
end)
-- ROBLOX deviation END

-- ROBLOX deviation START: test skipped because Lua doesn't have properties like
-- 'configurable' and 'writable'
itSKIP("should set writable, configurable to true", function()
	--[[
			const a = {};
			Object.defineProperty(a, 'key', {
				configurable: false,
				enumerable: true,
				value: 1,
				writable: false,
			});
			const copied = deepCyclicCopyReplaceable(a);
			expect(Object.getOwnPropertyDescriptors(copied)).toEqual({
				key: {configurable: true, enumerable: true, value: 1, writable: true},
			});
		]]
end)
-- ROBLOX deviation END

-- ROBLOX deviation START: Test not present in upstream
it("should keep metatable on copied table", function()
	local a = {}
	setmetatable(a, { test = 1 })

	expect(getmetatable(deepCyclicCopyReplaceable(a))["test"]).toBe(1)
end)
-- ROBLOX deviation END

return {}
