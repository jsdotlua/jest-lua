-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-matcher-utils/src/__tests__/Replaceable.test.ts
-- /**
-- * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
-- *
-- * This source code is licensed under the MIT license found in the
-- * LICENSE file in the root directory of this source tree.
-- */

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local Replaceable = require(CurrentModule.Replaceable)

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local expect = JestGlobals.expect
local describe = (JestGlobals.describe :: any) :: Function
local it = (JestGlobals.it :: any) :: Function
local itSKIP = JestGlobals.it.skip

describe("Replaceable", function()
	describe("constructor", function()
		it("init with object", function()
			local replaceable = Replaceable.new({ a = 1, b = 2 })
			expect(replaceable.object).toEqual({ a = 1, b = 2 })
			expect(replaceable.type).toBe("table")
		end)

		it("init with array", function()
			local replaceable = Replaceable.new({ 1, 2, 3 })
			expect(replaceable.object).toEqual({ 1, 2, 3 })
			expect(replaceable.type).toBe("table")
		end)

		-- ROBLOX deviation: test skipped because it tests a map that is identical
		-- to the object test above in lua
		itSKIP("init with Map", function()
			--[[
					const replaceable = new Replaceable(
						new Map([
							['a', 1],
							['b', 2],
						]),
					);
					expect(replaceable.object).toEqual(
						new Map([
							['a', 1],
							['b', 2],
						]),
					);
					expect(replaceable.type).toBe('map');
				]]
		end)

		it("init with other type should throw error", function()
			expect(function()
				Replaceable.new(DateTime.now())
			end).toThrow("Type DateTime is not supported in Replaceable!")
		end)
	end)

	describe("get", function()
		it("get object item", function()
			local replaceable = Replaceable.new({ a = 1, b = 2 })
			expect(replaceable:get("b")).toBe(2)
		end)

		it("get array item", function()
			local replaceable = Replaceable.new({ 1, 2, 3 })
			expect(replaceable:get(2)).toBe(2)
		end)

		-- ROBLOX deviation: test skipped because it tests a map that is identical
		-- to the object test above in lua
		itSKIP("get Map item", function()
			--[[
					const replaceable = new Replaceable(
						new Map([
							['a', 1],
							['b', 2],
						]),
					);
					expect(replaceable.get('b')).toBe(2);
				]]
		end)
	end)

	describe("set", function()
		it("set object item", function()
			local replaceable = Replaceable.new({ a = 1, b = 2 })
			replaceable:set("b", 3)
			expect(replaceable.object).toEqual({ a = 1, b = 3 })
		end)

		it("set array item", function()
			local replaceable = Replaceable.new({ 1, 2, 3 })
			replaceable:set(2, 3)
			expect(replaceable.object).toEqual({ 1, 3, 3 })
		end)

		-- ROBLOX deviation: test skipped because it tests a map that is identical
		-- to the object test above in lua
		itSKIP("set Map item", function()
			--[[
					const replaceable = new Replaceable(
						new Map([
							['a', 1],
							['b', 2],
						]),
					);
					replaceable.set('b', 3);
					expect(replaceable.object).toEqual(
						new Map([
							['a', 1],
							['b', 3],
						]),
					);
				]]
		end)
	end)

	describe("forEach", function()
		--[[
				ROBLOX deviation: we have to use this sorting function to sort the
				calls made by the forEach method since the forEach method does
				not follow any deterministic order in iterating because Lua
				tables don't have any inherent order
			]]
		local function sortingFunction(x, y)
			return x[1] <= y[1]
		end

		it("object forEach", function()
			local object = { a = 1, b = 2, jest = 3 }
			local replaceable = Replaceable.new(object)

			local spy = jest.fn()
			replaceable:forEach(spy)
			expect(spy).toHaveBeenCalledTimes(3)
			local calls = spy.mock.calls

			table.sort(calls, sortingFunction)
			expect(calls[1]).toEqual({ 1, "a", object })
			expect(calls[2]).toEqual({ 2, "b", object })
			expect(calls[3]).toEqual({ 3, "jest", object })
		end)

		it("array forEach", function()
			-- ROBLOX deviation: test changed from {1, 2, 3} --> {4, 5, 6} for
			-- clarity between table values and table indices
			local object = { 4, 5, 6 }
			local replaceable = Replaceable.new(object)

			local spy = jest.fn()
			replaceable:forEach(spy)
			expect(spy).toHaveBeenCalledTimes(3)
			local calls = spy.mock.calls

			table.sort(calls, sortingFunction)
			expect(calls[1]).toEqual({ 4, 1, object })
			expect(calls[2]).toEqual({ 5, 2, object })
			expect(calls[3]).toEqual({ 6, 3, object })
		end)

		it("map forEach", function()
			local object = { a = 1, b = 2 }
			local replaceable = Replaceable.new(object)

			local spy = jest.fn()
			replaceable:forEach(spy)
			expect(spy).toHaveBeenCalledTimes(2)
			local calls = spy.mock.calls

			table.sort(calls, sortingFunction)
			expect(calls[1]).toEqual({ 1, "a", object })
			expect(calls[2]).toEqual({ 2, "b", object })
		end)

		-- ROBLOX deviation: test skipped because we don't have an enumerable
		-- property in lua
		itSKIP("forEach should ignore nonenumerable property", function()
			--[[
					const symbolKey = Symbol('jest');
					const symbolKey2 = Symbol('awesome');
					const object = {a: 1, [symbolKey]: 3};
					Object.defineProperty(object, 'b', {
						configurable: true,
						enumerable: false,
						value: 2,
						writable: true,
					});
					Object.defineProperty(object, symbolKey2, {
						configurable: true,
						enumerable: false,
						value: 4,
						writable: true,
					});
					const replaceable = new Replaceable(object);
					const cb = jest.fn();
					replaceable.forEach(cb);
					expect(cb).toHaveBeenCalledTimes(2);
					expect(cb.mock.calls[0]).toEqual([1, 'a', object]);
					expect(cb.mock.calls[1]).toEqual([3, symbolKey, object]);
				]]
		end)
	end)

	describe("isReplaceable", function()
		it("should return true if two object types equal and support", function()
			expect(Replaceable.isReplaceable({ a = 1 }, { b = 2 })).toBe(true)
			expect(Replaceable.isReplaceable({}, { 1, 2, 3 })).toBe(true)
			expect(Replaceable.isReplaceable({}, { a = 1, b = 2 })).toBe(true)
		end)

		-- ROBLOX deviation: test skipped because we don't have different object
		-- types in Lua, we only have tables
		itSKIP("should return false if two object types not equal", function()
			--[[
				      expect(Replaceable.isReplaceable({a: 1}, [1, 2, 3])).toBe(false);
				]]
		end)

		it("should return false if object types not support", function()
			expect(Replaceable.isReplaceable("foo", "bar")).toBe(false)
		end)
	end)
end)

return {}
