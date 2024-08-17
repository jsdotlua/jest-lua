-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-mock/src/__tests__/index.test.ts
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
local beforeEach = JestGlobals.beforeEach
local jest = JestGlobals.jest

local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local Error = LuauPolyfill.Error

local parentModule = require("../init")
local ModuleMocker = parentModule.ModuleMocker
local fn = parentModule.fn
local mocked = parentModule.mocked
local spyOn = parentModule.spyOn

describe("moduleMocker", function()
	local moduleMocker
	beforeEach(function()
		moduleMocker = ModuleMocker.new()
	end)

	--[[
		ROBLOX deviation: skipped code:
		original code lines 25 - 119
	]]

	describe("generateFromMetadata", function()
		--[[
			ROBLOX deviation: skipped code:
			original code lines 122 - 410
		]]

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

				fn("a", "b", "c")

				expect(fn.mock.calls).toEqual({ { "a", "b", "c" } })

				expect(fn()).toEqual("abcd")
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
			-- preserve function arity for mocked functions
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
		end)

		it("mocks the method in the passed object itself", function()
			local parent = {
				func = function()
					return "abcd"
				end,
			}
			-- ROBLOX deviation: use metatables for prototype-like inheritance
			local child = setmetatable({}, { __index = parent })

			moduleMocker:spyOn(child, "func").mockReturnValue("efgh")

			-- ROBLOX deviation: use rawget to access through metatable
			expect(rawget(child :: any, "func")).never.toBeNil()
			expect(child.func()).toEqual("efgh")
			expect(parent.func()).toEqual("abcd")
		end)

		it("should delete previously inexistent methods when restoring", function()
			local parent = {
				func = function()
					return "abcd"
				end,
			}
			-- ROBLOX deviation: use metatables for prototype-like inheritance
			local child = setmetatable({}, { __index = parent })

			moduleMocker:spyOn(child, "func").mockReturnValue("efgh")

			moduleMocker:restoreAllMocks()
			expect(child.func()).toEqual("abcd")

			moduleMocker:spyOn(parent, "func").mockReturnValue("jklm")

			-- ROBLOX deviation: use rawget instead of hasOwnProperty
			expect(rawget(child :: any, "func")).toBeNil()
			expect(child.func()).toEqual("jklm")
		end)

		it("supports mock value returning nil", function()
			local obj = {
				func = function()
					return "some text"
				end,
			}

			moduleMocker:spyOn(obj, "func").mockReturnValue(nil)

			expect(obj.func()).never.toEqual("some text")
		end)

		it("supports mock value once returning nil", function()
			local obj = {
				func = function()
					return "some text"
				end,
			}

			moduleMocker:spyOn(obj, "func").mockReturnValueOnce(nil)

			expect(obj.func()).never.toEqual("some text")
		end)

		it("mockReturnValueOnce mocks value just once", function()
			local fake = moduleMocker:fn(function(a: number)
				return a + 2
			end)
			fake.mockReturnValueOnce(42)
			expect(fake(2)).toEqual(42)
			expect(fake(2)).toEqual(4)
		end)

		--[[
			ROBLOX deviation: skipped code:
			original code lines 647 - 692
		]]

		describe("return values", function()
			it("tracks return values", function()
				local fn = moduleMocker:fn(function(x: number)
					return x * 2
				end)
				expect(fn.mock.results).toEqual({})
				fn(1)
				fn(2)
				expect(fn.mock.results).toEqual({
					{ type = "return", value = 2 },
					{ type = "return", value = 4 },
				} :: { any })
			end)

			it("tracks mocked return values", function()
				local fn = moduleMocker:fn(function(x: number)
					return x * 2
				end)
				fn.mockReturnValueOnce("MOCKED!")
				fn(1)
				fn(2)
				expect(fn.mock.results).toEqual({
					{ type = "return", value = "MOCKED!" },
					{ type = "return", value = 4 },
				} :: { any })
			end)

			it("supports resetting return values", function()
				local fn = moduleMocker:fn(function(x: number)
					return x * 2
				end)
				expect(fn.mock.results).toEqual({})
				fn(1)
				fn(2)
				expect(fn.mock.results).toEqual({
					{ type = "return", value = 2 },
					{ type = "return", value = 4 },
				})
				fn.mockReset()
				expect(fn.mock.results).toEqual({})
			end)
		end)

		it("tracks thrown errors without interfering with other tracking", function()
			local error_ = Error.new("ODD!")
			local fn = moduleMocker:fn(function(x: number, y: number)
				-- multiply params
				local result = x * y
				if result % 2 == 1 then
					-- throw error if result is odd
					error(error_)
				else
					return result
				end
			end)
			expect(fn(2, 4)).toBe(8) -- Mock still throws the error even though it was internally
			-- caught and recorded
			expect(function()
				fn(3, 5)
			end).toThrow("ODD!")
			expect(fn(6, 3)).toBe(18) -- All call args tracked
			expect(fn.mock.calls).toEqual({ { 2, 4 }, { 3, 5 }, { 6, 3 } }) -- Results are tracked
			expect(fn.mock.results).toEqual({
				{ type = "return", value = 8 },
				{ type = "throw", value = error_ },
				{ type = "return", value = 18 },
			} :: { any })
		end)

		-- ROBLOX deviation: use `nil` instead of undefined for test
		it("a call that throws nil is tracked properly", function()
			local fn = moduleMocker:fn(function()
				-- eslint-disable-next-line no-throw-literal
				error(nil)
			end)
			pcall(function()
				fn(2, 4)
			end)
			expect(fn.mock.calls).toEqual({ { 2, 4 } }) -- Results are tracked
			expect(fn.mock.results).toEqual({ { type = "throw", value = nil } })
		end)

		it("results of recursive calls are tracked properly", function()
			-- sums up all integers from 0 -> value, using recursion
			local fn: any
			-- ROBLOX deviation; separate declaration from assignment for
			fn = moduleMocker:fn(function(value: number)
				if value == 0 then
					return 0
				else
					return value + fn(value - 1)
				end
			end)
			fn(4) -- All call args tracked
			expect(fn.mock.calls).toEqual({ { 4 }, { 3 }, { 2 }, { 1 }, { 0 } }) -- Results are tracked
			-- (in correct order of calls, rather than order of returns)
			expect(fn.mock.results).toEqual({
				{ type = "return", value = 10 },
				{ type = "return", value = 6 },
				{ type = "return", value = 3 },
				{ type = "return", value = 1 },
				{ type = "return", value = 0 },
			})
		end)

		it("test results of recursive calls from within the recursive call", function()
			-- sums up all 	integers from 0 -> value, using recursion
			local fn: any
			-- ROBLOX deviation; separate declaration from assignment for
			fn = moduleMocker:fn(function(value: number)
				if value == 0 then
					return 0
				else
					local recursiveResult = fn(value - 1)
					if value == 3 then
						-- All recursive calls have been made at this point.
						expect(fn.mock.calls).toEqual({ { 4 }, { 3 }, { 2 }, { 1 }, { 0 } }) -- But only the last 3 calls have returned at this point.
						expect(fn.mock.results).toEqual({
							{ type = "incomplete", value = nil },
							{ type = "incomplete", value = nil },
							{ type = "return", value = 3 },
							{ type = "return", value = 1 },
							{ type = "return", value = 0 },
						} :: { any })
					end
					return value + recursiveResult
				end
			end)
			fn(4)
		end)

		it("call mockClear inside recursive mock", function()
			-- sums up all integers from 0 -> value, using recursion
			local fn: any
			-- ROBLOX deviation; separate declaration from assignment for
			fn = moduleMocker:fn(function(value: number)
				if value == 3 then
					fn:mockClear()
				end
				if value == 0 then
					return 0
				else
					return value + fn(value - 1)
				end
			end)
			fn(3) -- All call args (after the call that cleared the mock) are tracked
			expect(fn.mock.calls).toEqual({ { 2 }, { 1 }, { 0 } }) -- Results (after the call that cleared the mock) are tracked
			expect(fn.mock.results).toEqual({
				{ type = "return", value = 3 },
				{ type = "return", value = 1 },
				{ type = "return", value = 0 },
			})
		end)

		describe("invocationCallOrder", function()
			it("tracks invocationCallOrder made by mocks", function()
				local fn1 = moduleMocker:fn()
				expect(fn1.mock.invocationCallOrder).toEqual({})
				fn1(1, 2, 3)
				expect(fn1.mock.invocationCallOrder[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]).toBe(1)
				fn1("a", "b", "c")
				expect(fn1.mock.invocationCallOrder[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]).toBe(2)
				fn1(1, 2, 3)
				expect(fn1.mock.invocationCallOrder[
					3 --[[ ROBLOX adaptation: added 1 to array index ]]
				]).toBe(3)
				local fn2 = moduleMocker:fn()
				expect(fn2.mock.invocationCallOrder).toEqual({})
				fn2("d", "e", "f")
				expect(fn2.mock.invocationCallOrder[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]).toBe(4)
				fn2(4, 5, 6)
				expect(fn2.mock.invocationCallOrder[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]).toBe(5)
			end)

			it("supports clearing mock invocationCallOrder", function()
				local fn = moduleMocker:fn()
				expect(fn.mock.invocationCallOrder).toEqual({})
				fn(1, 2, 3)
				expect(fn.mock.invocationCallOrder).toEqual({ 1 })
				fn.mockReturnValue("abcd")
				fn.mockClear()
				expect(fn.mock.invocationCallOrder).toEqual({})
				fn("a", "b", "c")
				expect(fn.mock.invocationCallOrder).toEqual({ 2 })
				expect(fn()).toEqual("abcd")
			end)

			it("supports clearing all mocks invocationCallOrder", function()
				local fn1 = moduleMocker:fn()
				fn1.mockImplementation(function()
					return "abcd"
				end)
				fn1(1, 2, 3)
				expect(fn1.mock.invocationCallOrder).toEqual({ 1 })
				local fn2 = moduleMocker:fn()
				fn2.mockReturnValue("abcde")
				fn2("a", "b", "c", "d")
				expect(fn2.mock.invocationCallOrder).toEqual({ 2 })
				moduleMocker:clearAllMocks()
				expect(fn1.mock.invocationCallOrder).toEqual({})
				expect(fn2.mock.invocationCallOrder).toEqual({})
				expect(fn1()).toEqual("abcd")
				expect(fn2()).toEqual("abcde")
			end)

			-- ROBLOX deviation START: skip non-applicable test
			-- it("handles a property called `prototype`", function()
			-- 	local mock =
			-- 		moduleMocker:generateFromMetadata(moduleMocker:getMetadata({ prototype = 1 }))
			-- 	expect(mock.prototype).toBe(1)
			-- end)
			-- ROBLOX deviation END
		end)
	end)

	describe("getMockImplementation", function()
		it("should mock calls to a mock function", function()
			local mockFn = moduleMocker:fn()
			mockFn.mockImplementation(function()
				return "Foo"
			end)
			expect(typeof(mockFn.getMockImplementation())).toBe("function")
			expect(mockFn.getMockImplementation()()).toBe("Foo")
		end)
	end)
	describe("mockImplementationOnce", function()
		-- ROBLOX deviation START: disable Module constructor test
		-- it("should mock constructor", function()
		-- 	local mock1 = jest.fn()
		-- 	local mock2 = jest.fn()
		-- 	local Module = jest.fn(function()
		-- 		return { someFn = mock1 }
		-- 	end)
		-- 	local function testFn()
		-- 		local m = Module.new()
		-- 		m:someFn()
		-- 	end
		-- 	Module:mockImplementationOnce(function()
		-- 		return { someFn = mock2 }
		-- 	end)
		-- 	testFn()
		-- 	expect(mock2).toHaveBeenCalled()
		-- 	expect(mock1)["not"].toHaveBeenCalled()
		-- 	testFn()
		-- 	expect(mock1).toHaveBeenCalled()
		-- end)
		-- ROBLOX deviation END

		it("should mock single call to a mock function", function()
			local mockFn = moduleMocker:fn()
			mockFn
				.mockImplementationOnce(function()
					return "Foo"
				end)
				.mockImplementationOnce(function()
					return "Bar"
				end)
			expect(mockFn()).toBe("Foo")
			expect(mockFn()).toBe("Bar")
			expect(mockFn()).toBeUndefined()
		end)

		it("should fallback to default mock function when no specific mock is available", function()
			local mockFn = moduleMocker:fn()
			mockFn
				.mockImplementationOnce(function()
					return "Foo"
				end)
				.mockImplementationOnce(function()
					return "Bar"
				end)
				.mockImplementation(function()
					return "Default"
				end)
			expect(mockFn()).toBe("Foo")
			expect(mockFn()).toBe("Bar")
			expect(mockFn()).toBe("Default")
			expect(mockFn()).toBe("Default")
		end)
	end)

	it("mockReturnValue does not override mockImplementationOnce", function()
		local mockFn = jest.fn().mockReturnValue(1).mockImplementationOnce(function()
			return 2
		end)
		expect(mockFn()).toBe(2)
		expect(mockFn()).toBe(1)
	end)

	it("mockImplementation resets the mock", function()
		local fn = jest.fn()
		expect(fn()).toBeNil()
		fn.mockReturnValue("returnValue")
		fn.mockImplementation(function()
			return "foo"
		end)
		expect(fn()).toBe("foo")
	end)

	it("should recognize a mocked function", function()
		local mockFn = moduleMocker:fn()
		expect(moduleMocker:isMockFunction(function() end)).toBe(false)
		expect(moduleMocker:isMockFunction(mockFn)).toBe(true)
	end)

	it("default mockName is jest.fn()", function()
		local fn = jest.fn()
		expect(fn.getMockName()).toBe("jest.fn()")
	end)

	it("mockName sets the mock name", function()
		local fn = jest.fn()
		fn.mockName("myMockFn")
		expect(fn.getMockName()).toBe("myMockFn")
	end)

	it("jest.fn should provide the correct lastCall", function()
		local mock = jest.fn()
		expect(mock.mock).never.toHaveProperty("lastCall")
		mock("first")
		mock("second")
		mock("last", "call")
		expect(mock).toHaveBeenLastCalledWith("last", "call")
		expect(mock.mock.lastCall).toEqual({ "last", "call" })
	end)

	it("lastCall gets reset by mockReset", function()
		local mock = jest.fn()
		mock("first")
		mock("last", "call")
		expect(mock.mock.lastCall).toEqual({ "last", "call" })
		mock.mockReset()
		expect(mock.mock).never.toHaveProperty("lastCall")
	end)

	it("mockName gets reset by mockReset", function()
		local fn = jest.fn()
		expect(fn.getMockName()).toBe("jest.fn()")
		fn.mockName("myMockFn")
		expect(fn.getMockName()).toBe("myMockFn")
		fn.mockReset()
		expect(fn.getMockName()).toBe("jest.fn()")
	end)

	it("mockName gets reset by mockRestore", function()
		local fn = jest.fn()
		expect(fn.getMockName()).toBe("jest.fn()")
		fn.mockName("myMockFn")
		expect(fn.getMockName()).toBe("myMockFn")
		fn.mockRestore()
		expect(fn.getMockName()).toBe("jest.fn()")
	end)

	it("mockName is not reset by mockClear", function()
		local fn = jest.fn(function()
			return false
		end)
		fn.mockName("myMockFn")
		expect(fn.getMockName()).toBe("myMockFn")
		fn.mockClear()
		expect(fn.getMockName()).toBe("myMockFn")
	end)

	describe("spyOn", function()
		it("should work", function()
			local isOriginalCalled = false
			local originalCallThis
			local originalCallArguments: { any }?
			local obj = {
				-- ROBLOX deviation START: use ... for args
				method = function(self, ...)
					isOriginalCalled = true
					originalCallThis = self
					originalCallArguments = table.pack(...)
				end,
				-- ROBLOX deviation END
			}
			local spy = moduleMocker:spyOn(obj, "method")
			local thisArg = { this = true }
			local firstArg = { first = true }
			local secondArg = { second = true }
			obj.method(thisArg, firstArg, secondArg)
			expect(isOriginalCalled).toBe(true)
			expect(originalCallThis).toBe(thisArg)
			assert(originalCallArguments, "luau narrow")
			expect(#originalCallArguments).toBe(2)
			expect(originalCallArguments[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(firstArg)
			expect(originalCallArguments[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(secondArg)
			expect(spy).toHaveBeenCalled()
			isOriginalCalled = false
			originalCallThis = nil
			originalCallArguments = nil
			spy.mockRestore()
			obj.method(thisArg, firstArg, secondArg)
			expect(isOriginalCalled).toBe(true)
			expect(originalCallThis).toBe(thisArg)
			assert(originalCallArguments, "luau narrow")
			expect(#originalCallArguments).toBe(2)
			expect(originalCallArguments[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(firstArg)
			expect(originalCallArguments[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(secondArg)
			expect(spy).never.toHaveBeenCalled()
		end)

		it("should throw on invalid input", function()
			expect(function()
				moduleMocker:spyOn(nil, "method")
			end).toThrow()
			expect(function()
				moduleMocker:spyOn({}, "method")
			end).toThrow()
			expect(function()
				moduleMocker:spyOn({ method = 10 }, "method")
			end).toThrow()
		end)

		it("supports restoring all spies", function()
			local methodOneCalls = 0
			local methodTwoCalls = 0
			local obj = {
				methodOne = function(self)
					methodOneCalls += 1
				end,
				methodTwo = function(self)
					methodTwoCalls += 1
				end,
			}
			local spy1 = moduleMocker:spyOn(obj, "methodOne")
			local spy2 = moduleMocker:spyOn(obj, "methodTwo") -- First, we call with the spies: both spies and both original functions
			-- should be called.
			obj:methodOne()
			obj:methodTwo()
			expect(methodOneCalls).toBe(1)
			expect(methodTwoCalls).toBe(1)
			expect(#spy1.mock.calls).toBe(1)
			expect(#spy2.mock.calls).toBe(1)
			moduleMocker:restoreAllMocks() -- Then, after resetting all mocks, we call methods again. Only the real
			-- methods should bump their count, not the spies.
			obj:methodOne()
			obj:methodTwo()
			expect(methodOneCalls).toBe(2)
			expect(methodTwoCalls).toBe(2)
			expect(#spy1.mock.calls).toBe(1)
			expect(#spy2.mock.calls).toBe(1)
		end)

		--[[
			ROBLOX deviation: skipped code (getters & prototypes):
			original code lines 1250 - 1300
		]]
	end)
	--[[
		ROBLOX deviation: skipped code (spyOnProperty not supported):
		original code lines 1098 - 1307
	]]

	-- ROBLOX deviation START: add additional test for luau case
	it("mocks a function with return value of nil", function()
		local fn = moduleMocker:fn(function()
			return nil
		end)
		expect(fn()).toEqual(nil)
		expect(fn.mock.calls).toEqual({ {} })
	end)
	-- ROBLOX deviation END
end)

describe("mocked", function()
	it("should return unmodified input", function()
		local subject = {}
		expect(mocked(subject)).toBe(subject)
	end)
end)

it("`fn` and `spyOn` do not throw", function()
	expect(function()
		fn()
		spyOn({ apple = function() end }, "apple")
	end).never.toThrow()
end)
