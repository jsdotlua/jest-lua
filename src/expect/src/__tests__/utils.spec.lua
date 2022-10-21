-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/expect/src/__tests__/utils.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local test = JestGlobals.test
local testSKIP = JestGlobals.test.skip

local LuauPolyfill = require(Packages.LuauPolyfill)
local Set = LuauPolyfill.Set

local stringify = require(Packages.JestMatcherUtils).stringify

local emptyObject = require(CurrentModule.utils).emptyObject
local getObjectSubset = require(CurrentModule.utils).getObjectSubset
local getPath = require(CurrentModule.utils).getPath
local iterableEquality = require(CurrentModule.utils).iterableEquality
local subsetEquality = require(CurrentModule.utils).subsetEquality

type Array<T> = LuauPolyfill.Array<T>

type GetPath = {
	hasEndProp: boolean?,
	lastTraversedObject: any,
	traversedPath: Array<string>,
	value: any?,
}

describe("getPath()", function()
	test("property exists", function()
		expect(getPath({ a = { b = { c = 5 } } }, "a.b.c")).toEqual({
			hasEndProp = true,
			lastTraversedObject = { c = 5 },
			traversedPath = { "a", "b", "c" },
			value = 5,
		})

		expect(getPath({ a = { b = { c = { d = 1 } } } }, "a.b.c.d")).toEqual({
			hasEndProp = true,
			lastTraversedObject = { d = 1 },
			traversedPath = { "a", "b", "c", "d" },
			value = 1,
		})
	end)

	test("property doesnt exist", function()
		expect(getPath({ a = { b = {} } }, "a.b.c")).toEqual({
			hasEndProp = false,
			lastTraversedObject = {},
			traversedPath = { "a", "b" },
			value = nil,
		})
	end)

	test("property exist but undefined", function()
		expect(getPath({ a = { b = { c = "undefined" } } }, "a.b.c")).toEqual({
			hasEndProp = true,
			lastTraversedObject = { c = "undefined" },
			traversedPath = { "a", "b", "c" },
			value = "undefined",
		})
	end)

	-- ROBLOX deviation START: modified test because we don't have built in getters
	test("property is a getter on class instance", function()
		local A = {}
		A.a = "a"
		A.b = { c = "c" }

		expect(getPath(A, "a")).toEqual({
			hasEndProp = true,
			lastTraversedObject = { a = "a", b = { c = "c" } },
			traversedPath = { "a" },
			value = "a",
		})

		expect(getPath(A, "b.c")).toEqual({
			hasEndProp = true,
			lastTraversedObject = { c = "c" },
			traversedPath = { "b", "c" },
			value = "c",
		})
	end)
	-- ROBLOX deviation END

	test("property is inherited", function()
		local A = {} :: { [string]: any }
		local prototypeA = { a = "a" }
		setmetatable(A, { __index = prototypeA })
		expect(getPath((A :: any) :: { [string]: any }, "a")).toEqual({
			hasEndProp = true,
			lastTraversedObject = A,
			traversedPath = { "a" },
			value = "a",
		})
	end)

	test("path breaks", function()
		expect(getPath({ a = {} }, "a.b.c")).toEqual({
			hasEndProp = false,
			lastTraversedObject = {},
			traversedPath = { "a" },
			value = nil,
		})
	end)

	test("empty object at the end", function()
		expect(getPath({ a = { b = { c = {} } } }, "a.b.c.d")).toEqual({
			hasEndProp = false,
			lastTraversedObject = {},
			traversedPath = { "a", "b", "c" },
			value = nil,
		})
	end)
end)

describe("getObjectSubset", function()
	local fixtures = {
		{ { a = "b", c = "d" } :: any, { a = "d" }, { a = "b" } },
		{ { a = { 1, 2 }, b = "b" } :: any, { a = { 3, 4 } }, { a = { 1, 2 } } },
		{ { { a = "b", c = "d" } } :: any, { { a = "z" } }, { { a = "b" } } },
		{
			{ 1, 2 },
			{ 1, 2, 3 },
			{ 1, 2 },
		},
		{ { a = { 1 } }, { a = { 1, 2 } }, { a = { 1 } } },
		{
			DateTime.fromUniversalTime(2015, 11, 30),
			DateTime.fromUniversalTime(2015, 12, 30),
			DateTime.fromUniversalTime(2015, 11, 30),
		},
	}

	for _, value in fixtures do
		test(
			string.format(
				"expect(getObjectSubset(%s, %s)).toEqual(%s)",
				stringify(value[1]),
				stringify(value[2]),
				stringify(value[3])
			),
			function()
				expect(getObjectSubset(value[1], value[2])).toEqual(value[3])
			end
		)
	end

	describe("returns the object instance if the subset has no extra properties", function()
		test("Date", function()
			local object = DateTime.fromUniversalTime(2015, 11, 30)
			local subset = DateTime.fromUniversalTime(2016, 12, 30)

			expect(getObjectSubset(object, subset)).toBe(object)
		end)
	end)

	describe("returns the subset instance if its property values are equal", function()
		test("Object", function()
			local object = { key0 = "zero", key1 = "one", key2 = "two" }
			local subset = { key0 = "zero", key2 = "two" }

			expect(getObjectSubset(object, subset)).toBe(subset)
			-- ROBLOX FIXME END
		end)
	end)

	describe("Uint8Array", function()
		local equalObject = { [1] = 0, [2] = 0, [3] = 0 }
		local typedArray = { 0, 0, 0 }

		test("expected", function()
			local object = equalObject
			local subset = typedArray

			-- ROBLOX FIXME START: using toEqual instead of toBe
			expect(getObjectSubset(object, subset)).toEqual(subset)
			-- ROBLOX FIXME END
		end)

		test("received", function()
			local object = typedArray
			local subset = equalObject

			-- ROBLOX FIXME START: using toEqual instead of toBe
			expect(getObjectSubset(object, subset)).toEqual(subset)
			-- ROBLOX FIXME END
		end)
	end)

	describe("calculating subsets of objects with circular references", function()
		test("simple circular references", function()
			type CircularObj = { a: string?, b: string?, ref: any? }

			local nonCircularObj = { a = "world", b = "something" }

			local circularObjA: CircularObj = { a = "hello" }
			circularObjA.ref = circularObjA

			local circularObjB: CircularObj = { a = "world" }
			circularObjB.ref = circularObjB

			local primitiveInsteadOfRef: CircularObj = { b = "something" }
			primitiveInsteadOfRef.ref = "not a ref"

			local nonCircularRef: CircularObj = { b = "something" }
			nonCircularRef.ref = {}

			expect(getObjectSubset(circularObjA, nonCircularObj)).toEqual({
				a = "hello",
			})

			expect(getObjectSubset(nonCircularObj, circularObjA)).toEqual({
				a = "world",
			})

			expect(getObjectSubset(circularObjB, circularObjA)).toEqual(circularObjB)

			expect(getObjectSubset(primitiveInsteadOfRef, circularObjA)).toEqual({
				ref = "not a ref",
			})

			expect(getObjectSubset(nonCircularRef, circularObjA)).toEqual({
				ref = {},
			})
		end)

		test("transitive circular references", function()
			type CircularObj = { a: string?, nestedObj: any? }

			local nonCircularObj = { a = "world", b = "something" }

			local transitiveCircularObjA: CircularObj = { a = "hello" }
			transitiveCircularObjA.nestedObj = { parentObj = transitiveCircularObjA }

			local transitiveCircularObjB: CircularObj = { a = "world" }
			transitiveCircularObjB.nestedObj = { parentObj = transitiveCircularObjB }

			local primitiveInsteadOfRef: CircularObj = {}
			primitiveInsteadOfRef.nestedObj = { otherProp = "not the parent ref" }

			local nonCircularRef: CircularObj = {}
			nonCircularRef.nestedObj = { otherProp = {} }

			expect(getObjectSubset(transitiveCircularObjA, nonCircularObj)).toEqual({
				a = "hello",
			})

			expect(getObjectSubset(nonCircularObj, transitiveCircularObjA)).toEqual({
				a = "world",
			})

			expect(getObjectSubset(transitiveCircularObjB, transitiveCircularObjA)).toEqual(transitiveCircularObjB)

			expect(getObjectSubset(primitiveInsteadOfRef, transitiveCircularObjA)).toEqual({
				nestedObj = { otherProp = "not the parent ref" },
			})

			expect(getObjectSubset(nonCircularRef, transitiveCircularObjA)).toEqual({
				nestedObj = { otherProp = {} },
			})
		end)
	end)
end)

describe("emptyObject()", function()
	test("matches an empty object", function()
		expect(emptyObject({})).toBe(true)
	end)

	test("does not match an object with keys", function()
		expect(emptyObject({ foo = "undefined" })).toBe(false)
	end)

	test("does not match a non-object", function()
		expect(emptyObject(nil)).toBe(false)
		expect(emptyObject(34)).toBe(false)
	end)
end)

describe("subsetEquality()", function()
	test("matching object returns true", function()
		expect(subsetEquality({ foo = "bar" }, { foo = "bar" })).toBe(true)
	end)

	test("object without keys is undefined", function()
		expect(subsetEquality("foo", "bar")).toBe(nil)
	end)

	test("objects to not match", function()
		expect(subsetEquality({ foo = "bar" }, { foo = "baz" })).toBe(false)
		expect(subsetEquality("foo", { foo = "baz" })).toBe(false)
	end)

	test("null does not return errors", function()
		expect(subsetEquality(nil, { foo = "bar" })).never.toBeTruthy()
	end)

	--[[
			ROBLOX NOTE:
			test is identical to the one directly above
			since we don't have a distinct undefined type
		]]
	test("undefined does not return errors", function()
		expect(subsetEquality(nil, { foo = "bar" })).never.toBeTruthy()
	end)

	describe("matching subsets with circular references", function()
		test("simple circular references", function()
			type CircularObj = { a: string?, ref: any? }

			local circularObjA1: CircularObj = { a = "hello" }
			circularObjA1.ref = circularObjA1

			local circularObjA2: CircularObj = { a = "hello" }
			circularObjA2.ref = circularObjA2

			local circularObjB: CircularObj = { a = "world" }
			circularObjB.ref = circularObjB

			local primitiveInsteadOfRef: CircularObj = {}
			primitiveInsteadOfRef.ref = "not a ref"

			expect(subsetEquality(circularObjA1, {})).toBe(true)
			expect(subsetEquality({}, circularObjA1)).toBe(false)
			expect(subsetEquality(circularObjA2, circularObjA1)).toBe(true)
			expect(subsetEquality(circularObjB, circularObjA1)).toBe(false)
			expect(subsetEquality(primitiveInsteadOfRef, circularObjA1)).toBe(false)
		end)

		test("referenced object on same level should not regarded as circular reference", function()
			local referencedObj = { abc = "def" }
			local object = {
				a = { abc = "def" },
				b = { abc = "def", zzz = "zzz" },
			}
			local thisIsNotCircular = {
				a = referencedObj,
				b = referencedObj,
			}

			expect(subsetEquality(object, thisIsNotCircular)).toBeTruthy()
		end)

		test("transitive circular references", function()
			type CircularObj = { a: string, nestedObj: any? }

			local transitiveCircularObjA1: CircularObj = { a = "hello" }
			transitiveCircularObjA1.nestedObj = { parentObj = transitiveCircularObjA1 }

			local transitiveCircularObjA2: CircularObj = { a = "hello" }
			transitiveCircularObjA2.nestedObj = {
				parentObj = transitiveCircularObjA2,
			}

			local transitiveCircularObjB: CircularObj = { a = "world" }
			transitiveCircularObjB.nestedObj = {
				parentObj = transitiveCircularObjB,
			}

			local primitiveInsteadOfRef = {
				parentObj = "not the parent ref",
			}

			expect(subsetEquality(transitiveCircularObjA1, {})).toBe(true)
			expect(subsetEquality({}, transitiveCircularObjA1)).toBe(false)
			expect(subsetEquality(transitiveCircularObjA2, transitiveCircularObjA1)).toBe(true)
			expect(subsetEquality(transitiveCircularObjB, transitiveCircularObjA1)).toBe(false)
			expect(subsetEquality(primitiveInsteadOfRef, transitiveCircularObjA1)).toBe(false)
		end)
	end)
end)

-- ROBLOX TODO: (ADO-1217) implement tests once we have Map functionality
describe("iterableEquality", function()
	test("returns true when given circular Set", function()
		local a = Set.new({})
		a:add(a)
		local b = Set.new({})
		b:add(b)
		expect(iterableEquality(a, b)).toBe(true)
	end)

	test("returns true when given nested Sets", function()
		expect(
			iterableEquality(
				Set.new({ Set.new({ { 1 } }), Set.new({ { 2 } }) }),
				Set.new({ Set.new({ { 2 } }), Set.new({ { 1 } }) })
			)
		).toBe(true)
		expect(
			iterableEquality(
				Set.new({ Set.new({ { 1 } }), Set.new({ { 2 } }) }),
				Set.new({ Set.new({ { 3 } }), Set.new({ { 1 } }) })
			)
		).toBe(false)
	end)

	test("returns false when given inequal set within a set", function()
		expect(iterableEquality(Set.new({ Set.new({ 2 }) }), Set.new({ Set.new({ 1, 2 }) }))).toBe(false)
		-- ROBLOX NOTE: duplicate call in upstream?
		expect(iterableEquality(Set.new({ Set.new({ 2 }) }), Set.new({ Set.new({ 1, 2 }) }))).toBe(false)
	end)

	testSKIP("returns false when given inequal set within a map", function() end)

	test("returns true when given circular Set shape", function()
		local a1 = Set.new()
		local a2 = Set.new()
		a1:add(a2)
		a2:add(a1)
		local b = Set.new()
		b:add(b)
		expect(iterableEquality(a1, b)).toEqual(true)
	end)

	testSKIP("returns true when given circular key in Map", function() end)

	testSKIP("returns true when given nested Maps", function() end)

	testSKIP("returns true when given circular key and value in Map", function() end)

	testSKIP("returns true when given circular value in Map", function() end)

	-- ROBLOX deviation START: skipped as Lua doesn't support ArrayBuffer
	-- describe('arrayBufferEquality', function()
	-- 	test('returns undefined if given a non instance of ArrayBuffer', function()
	-- 	expect(arrayBufferEquality(2, 's')).toBeUndefined()
	-- 	expect(arrayBufferEquality(nil, 2)).toBeUndefined()
	-- 	expect(arrayBufferEquality(Date.new(), ArrayBuffer.new(2))).toBeUndefined()
	-- 	end)

	-- 	test('returns false when given non-matching buffers', function()
	-- 		local a = Array.from(Uint8Array, { 2, 4 }).buffer
	-- 		local b = Array.from(Uint16Array, { 1, 7 }).buffer
	-- 	expect(arrayBufferEquality(a, b)).not_.toBeTruthy()
	-- 	end)

	-- 	test('returns true when given matching buffers', function()
	-- 		local a = Array.from(Uint8Array, { 1, 2 }).buffer
	-- 		local b = Array.from(Uint8Array, { 1, 2 }).buffer
	-- 	expect(arrayBufferEquality(a, b)).toBeTruthy()
	-- 	end)
	-- end)
	-- ROBLOX deviation END
end)
