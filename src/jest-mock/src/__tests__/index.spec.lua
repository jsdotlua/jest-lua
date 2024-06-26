-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-mock/src/__tests__/index.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

local ModuleMocker = require("../init").ModuleMocker
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local moduleMocker
beforeEach(function()
	moduleMocker = ModuleMocker.new()
end)

describe("moduleMocker", function()
	describe("generateFromMetadata", function()
		describe("mocked functions", function()
			it("tracks calls to mocks", function()
				local fn = moduleMocker:fn()
				expect(fn.mock.calls).toEqual({})

				fn(1, 2, 3)
				expect(fn.mock.calls).toEqual({ { 1, 2, 3 } })

				fn("a", "b", "c")
				expect(fn.mock.calls).toEqual({
					{ 1, 2, 3 } :: any,
					{ "a", "b", "c" },
				})
			end)

			it("tracks instances made by mocks", function()
				local fn = moduleMocker:fn()
				expect(fn.mock.instances).toEqual({})

				-- ROBLOX deviation: We have to call fn.new() because we don't have a new keyword
				local instance1 = fn.new()
				expect(fn.mock.instances[1]).toBe(instance1)

				-- ROBLOX deviation: We have to call fn.new() because we don't have a new keyword
				local instance2 = fn.new()
				expect(fn.mock.instances[2]).toBe(instance2)
			end)

			it("tracks context objects passed to mock calls", function()
				local fn = moduleMocker:fn()
				expect(fn.mock.instances).toEqual({})
				local ctx0 = {}
				fn(ctx0, {})
				expect(fn.mock.contexts[1]).toBe(ctx0)
				local ctx1 = {}
				fn(ctx1)
				expect(fn.mock.contexts[2]).toBe(ctx1)

				local ctx2 = {}
				local bound2 = function(...)
					return fn(ctx2, ...)
				end
				bound2()
				expect(fn.mock.contexts[
					3 --[[ ROBLOX adaptation: added 1 to array index ]]
				]).toBe(ctx2)

				-- null context
				fn(nil, table.unpack({}))
				expect(fn.mock.contexts[4]).toBe(nil)
				fn(nil)
				expect(fn.mock.contexts[5]).toBe(nil);

				(function(...)
					return fn(nil, ...)
				end)()
				expect(fn.mock.contexts[
					6 --[[ ROBLOX adaptation: added 1 to array index ]]
				]).toBe(nil)

				-- Unspecified context is `undefined` in strict mode (like in this test) and `window` otherwise.
				fn()
				expect(fn.mock.contexts[7]).toBe(nil)
			end)

			it("supports clearing mock calls", function()
				local fn = moduleMocker:fn()
				expect(fn.mock.calls).toEqual({})

				fn(1, 2, 3)
				expect(fn.mock.calls).toEqual({ { 1, 2, 3 } })

				fn.mockReturnValue("abcd")

				fn.mockClear()
				expect(fn.mock.calls).toEqual({})
			end)

			it("supports clearing mocks", function()
				local fn = moduleMocker:fn()
				expect(fn.mock.calls).toEqual({})

				fn(1, 2, 3)
				expect(fn.mock.calls).toEqual({ { 1, 2, 3 } })

				fn.mockClear()
				expect(fn.mock.calls).toEqual({})

				fn("a", "b", "c")
				expect(fn.mock.calls).toEqual({ { "a", "b", "c" } })
			end)

			it("supports clearing all mocks", function()
				local fn1 = moduleMocker:fn()
				fn1.mockImplementation(function()
					return "abcd"
				end)
				fn1(1, 2, 3)
				expect(fn1.mock.calls).toEqual({ { 1, 2, 3 } })

				local fn2 = moduleMocker:fn()
				fn2.mockReturnValue("abcde")
				fn2("a", "b", "c", "d")
				expect(fn2.mock.calls).toEqual({ { "a", "b", "c", "d" } })

				moduleMocker:clearAllMocks()
				expect(fn1.mock.calls).toEqual({})
				expect(fn2.mock.calls).toEqual({})
				expect(fn1()).toEqual("abcd")
				expect(fn2()).toEqual("abcde")
			end)

			it("supports resetting mock return values", function()
				local fn = moduleMocker:fn()
				fn.mockReturnValue("abcd")

				local before = fn()
				expect(before).toEqual("abcd")

				fn.mockReset()

				local after = fn()
				expect(after).never.toEqual("abcd")
			end)

			it("supports resetting single use mock return values", function()
				local fn = moduleMocker:fn()
				fn.mockReturnValueOnce("abcd")

				fn.mockReset()

				local after = fn()
				expect(after).never.toEqual("abcd")
			end)

			it("supports resetting mock implementation", function()
				local fn = moduleMocker:fn()
				fn.mockImplementation(function()
					return "abcd"
				end)

				local before = fn()
				expect(before).toEqual("abcd")

				fn.mockReset()

				local after = fn()
				expect(after).never.toEqual("abcd")
			end)

			it("supports resetting single use mock implementations", function()
				local fn = moduleMocker:fn()
				fn.mockImplementationOnce(function()
					return "abcd"
				end)

				fn.mockReset()

				local after = fn()
				expect(after).never.toEqual("abcd")
			end)

			it("supports resetting all mocks", function()
				local fn1 = moduleMocker:fn()
				fn1.mockImplementation(function()
					return "abcd"
				end)
				fn1(1, 2, 3)
				expect(fn1.mock.calls).toEqual({ { 1, 2, 3 } })

				local fn2 = moduleMocker:fn()
				fn2.mockReturnValue("abcd")
				fn2("a", "b", "c")
				expect(fn2.mock.calls).toEqual({ { "a", "b", "c" } })

				moduleMocker:resetAllMocks()
				expect(fn1.mock.calls).toEqual({})
				expect(fn2.mock.calls).toEqual({})
				expect(fn1()).never.toEqual("abcd")
				expect(fn2()).never.toEqual("abcd")
			end)

			-- ROBLOX deviation: test is itSKIPped because we currently don't
			-- implement this ability to inspect functionArity
			it.skip("maintains function arity", function()
				local mockFunctionArity1 = moduleMocker:fn(function(x)
					return x
				end)
				local mockFunctionArity2 = moduleMocker:fn(function(x, y)
					return y
				end)

				expect(#mockFunctionArity1).toBe(1)
				expect(#mockFunctionArity2).toBe(2)
			end)

			-- ROBLOX deviation: tests commented out for now, not yet implemented spyOn
			-- it('mocks the method in the passed object itself', function()
			-- 	local parent = {func = function() return 'abcd' end}
			-- 	local child = Object.create(parent)

			-- 	moduleMocker.spyOn(child, 'func').mockReturnValue('efgh')

			-- 	expect(child['func']).never.toBe(nil)
			-- 	expect(child.func()).toEqual('efgh')
			-- 	expect(parent.func()).toEqual('abcd')
			-- end)

			-- it('should delete previously inexistent methods when restoring', function()
			-- 	local parent = {func = function() return  'abcd' end}
			-- 	local child = Object.create(parent)

			-- 	moduleMocker.spyOn(child, 'func').mockReturnValue('efgh')

			-- 	moduleMocker.restoreAllMocks()
			-- 	expect(child.func()).toEqual('abcd')

			-- 	moduleMocker.spyOn(parent, 'func').mockReturnValue('jklm')

			-- 	expect(child.hasOwnProperty('func')).toBe(false)
			-- 	expect(child.func()).toEqual('jklm')
			-- end)

			-- it('supports mock value returning undefined', function()
			-- 	local obj = {
			-- 		func = function() return 'some text' end
			-- 	}

			-- 	moduleMocker.spyOn(obj, 'func').mockReturnValue(undefined)

			-- 	expect(obj.func()).never.toEqual('some text')
			-- end)

			-- it('supports mock value once returning undefined', function()
			-- 	local obj = {
			-- 		func = function() return 'some text' end,
			-- 	}

			-- 	moduleMocker.spyOn(obj, 'func').mockReturnValueOnce(undefined)

			-- 	expect(obj.func()).never.toEqual('some text')
			-- end)

			it("mockReturnValueOnce mocks value just once", function()
				local fake = moduleMocker:fn(function(a: number)
					return a + 2
				end)
				fake.mockReturnValueOnce(42)
				expect(fake(2)).toEqual(42)
				expect(fake(2)).toEqual(4)
			end)

			it("mocks a function with return value of nil", function()
				local fn = moduleMocker:fn(function()
					return nil
				end)
				expect(fn()).toEqual(nil)
				expect(fn.mock.calls).toEqual({ {} })
			end)
		end)
	end)
end)

describe("mocked", function()
	it("should return unmodified input", function()
		local subject = {}
		expect(moduleMocker:mocked(subject)).toBe(subject)
	end)
end)

--[[
		ROBLOX deviation: skipped code:
		original code lines 1462 - 1467
	]]
