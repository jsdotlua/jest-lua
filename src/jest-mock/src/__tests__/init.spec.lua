-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-mock/src/__tests__/index.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local ModuleMocker = require(CurrentModule)
	local jestExpect = require(Packages.Dev.Expect)

	local moduleMocker
	beforeEach(function()
		moduleMocker = ModuleMocker.new()
	end)

	describe('moduleMocker', function()
		describe('generateFromMetadata', function()
			describe('mocked functions', function()
				it('tracks calls to mocks', function()
					local fn = moduleMocker:fn()
					jestExpect(fn.mock.calls).toEqual({})

					fn(1, 2, 3)
					jestExpect(fn.mock.calls).toEqual({{1, 2, 3}})

					fn('a', 'b', 'c')
					jestExpect(fn.mock.calls).toEqual({
						{1, 2, 3},
						{'a', 'b', 'c'}
					})
				end)

				it('tracks instances made by mocks', function()
					local fn = moduleMocker:fn()
					jestExpect(fn.mock.instances).toEqual({})

					-- ROBLOX deviation: We have to call fn.new() because we don't have a new keyword
					local instance1 = fn.new()
					jestExpect(fn.mock.instances[1]).toBe(instance1)

					-- ROBLOX deviation: We have to call fn.new() because we don't have a new keyword
					local instance2 = fn.new()
					jestExpect(fn.mock.instances[2]).toBe(instance2)
				end)

				it('supports clearing mock calls', function()
					local fn = moduleMocker:fn()
					jestExpect(fn.mock.calls).toEqual({})

					fn(1, 2, 3)
					jestExpect(fn.mock.calls).toEqual({{1, 2, 3}})

					fn.mockReturnValue('abcd')

					fn.mockClear()
					jestExpect(fn.mock.calls).toEqual({})
				end)

				it('supports clearing mocks', function()
					local fn = moduleMocker:fn()
					jestExpect(fn.mock.calls).toEqual({})

					fn(1, 2, 3)
					jestExpect(fn.mock.calls).toEqual({{1,2, 3}})

					fn.mockClear()
					jestExpect(fn.mock.calls).toEqual({})

					fn('a', 'b', 'c')
					jestExpect(fn.mock.calls).toEqual({{'a', 'b', 'c'}})
				end)

				it('supports clearing all mocks', function()
					local fn1 = moduleMocker:fn()
					fn1.mockImplementation(function() return 'abcd' end)
					fn1(1, 2, 3)
					jestExpect(fn1.mock.calls).toEqual({{1, 2, 3}})

					local fn2 = moduleMocker:fn()
					fn2.mockReturnValue('abcde')
					fn2('a', 'b', 'c', 'd')
					jestExpect(fn2.mock.calls).toEqual({{'a', 'b', 'c', 'd'}})

					moduleMocker:clearAllMocks()
					jestExpect(fn1.mock.calls).toEqual({})
					jestExpect(fn2.mock.calls).toEqual({})
					jestExpect(fn1()).toEqual('abcd')
					jestExpect(fn2()).toEqual('abcde')
				end)

				it('supports resetting mock return values', function()
					local fn = moduleMocker:fn()
					fn.mockReturnValue('abcd')

					local before = fn()
					jestExpect(before).toEqual('abcd')

					fn.mockReset()

					local after = fn()
					jestExpect(after).never.toEqual('abcd')
				end)

				it('supports resetting single use mock return values', function()
					local fn = moduleMocker:fn()
					fn.mockReturnValueOnce('abcd')

					fn.mockReset()

					local after = fn()
					jestExpect(after).never.toEqual('abcd')
				end)

				it('supports resetting mock implementation', function()
					local fn = moduleMocker:fn()
					fn.mockImplementation(function() return 'abcd' end)

					local before = fn()
					jestExpect(before).toEqual('abcd')

					fn.mockReset()

					local after = fn()
					jestExpect(after).never.toEqual('abcd')
				end)

				it('supports resetting single use mock implementations', function()
					local fn = moduleMocker:fn()
					fn.mockImplementationOnce(function() return 'abcd' end)

					fn.mockReset()

					local after = fn()
					jestExpect(after).never.toEqual('abcd')
				end)

				it('supports resetting all mocks', function()
					local fn1 = moduleMocker:fn()
					fn1.mockImplementation(function() return 'abcd' end)
					fn1(1, 2, 3)
					jestExpect(fn1.mock.calls).toEqual({{1, 2, 3}})

					local fn2 = moduleMocker:fn()
					fn2.mockReturnValue('abcd')
					fn2('a', 'b', 'c')
					jestExpect(fn2.mock.calls).toEqual({{'a', 'b', 'c'}})

					moduleMocker:resetAllMocks()
					jestExpect(fn1.mock.calls).toEqual({})
					jestExpect(fn2.mock.calls).toEqual({})
					jestExpect(fn1()).never.toEqual('abcd')
					jestExpect(fn2()).never.toEqual('abcd')
				end)

				-- ROBLOX deviation: test is itSKIPped because we currently don't
				-- implement this ability to inspect functionArity
				itSKIP('maintains function arity', function()
					local mockFunctionArity1 = moduleMocker:fn(function(x) return x end)
					local mockFunctionArity2 = moduleMocker:fn(function(x, y) return y end)

					jestExpect(#mockFunctionArity1).toBe(1)
					jestExpect(#mockFunctionArity2).toBe(2)
				end)

				-- ROBLOX deviation: tests commented out for now, not yet implemented spyOn
				-- it('mocks the method in the passed object itself', function()
				-- 	local parent = {func = function() return 'abcd' end}
				-- 	local child = Object.create(parent)

				-- 	moduleMocker.spyOn(child, 'func').mockReturnValue('efgh')

				-- 	jestExpect(child['func']).never.toBe(nil)
				-- 	jestExpect(child.func()).toEqual('efgh')
				-- 	jestExpect(parent.func()).toEqual('abcd')
				-- end)

				-- it('should delete previously inexistent methods when restoring', function()
				-- 	local parent = {func = function() return  'abcd' end}
				-- 	local child = Object.create(parent)

				-- 	moduleMocker.spyOn(child, 'func').mockReturnValue('efgh')

				-- 	moduleMocker.restoreAllMocks()
				-- 	jestExpect(child.func()).toEqual('abcd')

				-- 	moduleMocker.spyOn(parent, 'func').mockReturnValue('jklm')

				-- 	jestExpect(child.hasOwnProperty('func')).toBe(false)
				-- 	jestExpect(child.func()).toEqual('jklm')
				-- end)

				-- it('supports mock value returning undefined', function()
				-- 	local obj = {
				-- 		func = function() return 'some text' end
				-- 	}

				-- 	moduleMocker.spyOn(obj, 'func').mockReturnValue(undefined)

				-- 	jestExpect(obj.func()).never.toEqual('some text')
				-- end)

				-- it('supports mock value once returning undefined', function()
				-- 	local obj = {
				-- 		func = function() return 'some text' end,
				-- 	}

				-- 	moduleMocker.spyOn(obj, 'func').mockReturnValueOnce(undefined)

				-- 	jestExpect(obj.func()).never.toEqual('some text')
				-- end)

				it('mockReturnValueOnce mocks value just once', function()
					local fake = moduleMocker:fn(function(a) return a + 2 end)
					fake.mockReturnValueOnce(42)
					jestExpect(fake(2)).toEqual(42)
					jestExpect(fake(2)).toEqual(4)
				end)

				it('mocks a function with return value of nil', function()
					local fn = moduleMocker:fn(function() return nil end)
					jestExpect(fn()).toEqual(nil)
					jestExpect(fn.mock.calls).toEqual({{}})
				end)
			end)
		end)
	end)

	describe('mocked', function()
		it('should return unmodified input', function()
		  local subject = {};
		  jestExpect(moduleMocker:mocked(subject)).toBe(subject);
		end);
	end);

	--[[
		ROBLOX deviation: skipped code:
		original code lines 1462 - 1467
	]]
end