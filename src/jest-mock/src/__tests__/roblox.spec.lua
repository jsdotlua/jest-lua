--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]
--!strict
-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
type Object = LuauPolyfill.Object

local exports = require("../init")
local ModuleMocker = exports.ModuleMocker
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jest = JestGlobals.jest
local expect = JestGlobals.expect
local it = JestGlobals.it
local describe = JestGlobals.describe
local beforeEach = JestGlobals.beforeEach

local JestConfig = require("@pkg/@jsdotlua/jest-config")

local moduleMocker
beforeEach(function()
	moduleMocker = ModuleMocker.new(JestConfig.projectDefaults)
end)

it("mock return chaining", function()
	local myMock = moduleMocker:fn()
	expect(myMock()).toBeNil()

	myMock.mockReturnValueOnce(10).mockReturnValueOnce("x").mockReturnValue(true)
	expect(myMock()).toBe(10)
	expect(myMock()).toBe("x")
	expect(myMock()).toBe(true)
	expect(myMock()).toBe(true)
end)

it("default mock function name is jest.fn()", function()
	local myMock = moduleMocker:fn()
	expect(myMock.getMockName()).toBe("jest.fn()")
end)

it("returns a function as the second return value", function()
	local mock, mockFn = moduleMocker:fn()
	mock.mockImplementationOnce(function(a: string, b: string)
		return a .. b
	end)
	mock.mockReturnValue(true)

	expect(typeof(mockFn)).toBe("function")

	expect(mockFn("a", "b")).toBe("ab")
	expect(mock).toHaveBeenLastCalledWith("a", "b")
	expect(mock).toHaveLastReturnedWith("ab")

	expect(mockFn()).toBe(true)
	expect(mock).toHaveLastReturnedWith(true)
end)

-- These tests are placed here rather than in JestMockGenv because they require
-- use of the ModuleMocker functions.
describe("global mocking & spying", function()
	it("globalEnv can spy on top-level global functions", function()
		local mockPrint = moduleMocker:spyOn(jest.globalEnv, "print")
		mockPrint.mockReturnValueOnce("abcde")

		local print2 = print :: any -- satisfy the type checker
		local returnValue = print2("This is an intentional print from a unit test")
		local callsAfter = #mockPrint.mock.calls

		expect(callsAfter).toBe(1)
		expect(returnValue).toBe("abcde")

		mockPrint.mockReset()
	end)

	it("globalEnv can spy on nested global functions", function()
		local mockRand = moduleMocker:spyOn(jest.globalEnv.math, "random")
		mockRand.mockReturnValueOnce("abcde")

		local random2 = math.random :: any -- satisfy the type checker
		local returnValue = random2()
		local callsAfter = #mockRand.mock.calls

		expect(callsAfter).toBe(1)
		expect(returnValue).toBe("abcde")

		mockRand.mockReset()
	end)

	it("globalEnv unmocked functions bypass mock impls", function()
		local mockRand = moduleMocker:spyOn(jest.globalEnv.math, "random")
		mockRand.mockReturnValueOnce("abcde")

		local returnValue = jest.globalEnv.math.random()
		local callsAfter = #mockRand.mock.calls

		expect(callsAfter).toBe(0)
		expect(returnValue).never.toBe("abcde")
		expect(returnValue).toEqual(expect.any("number"))

		mockRand.mockReset()
	end)

	it("globalEnv mocks do not persist beyond restoration", function()
		local mockRand = moduleMocker:spyOn(jest.globalEnv.math, "random")
		mockRand.mockReturnValueOnce("abcde")
		mockRand.mockRestore()

		local returnValue = math.random()

		expect(returnValue).never.toBe("abcde")
		expect(returnValue).toEqual(expect.any("number"))
	end)

	it("globalEnv can still be mocked after restoration", function()
		local mockRand = moduleMocker:spyOn(jest.globalEnv.math, "random")
		mockRand.mockReturnValueOnce("abcde")
		mockRand.mockRestore()
		mockRand.mockReturnValueOnce("vwxyz")

		local returnValue = math.random()

		expect(returnValue).toBe("vwxyz")
	end)

	it("oldFunctionSpying = true injects mock objects", function()
		local config = table.clone(JestConfig.projectDefaults)
		config.oldFunctionSpying = true
		local configuredMocker = ModuleMocker.new(config)

		local guineaPig = {
			foo = function() end,
		}
		local mockObj = configuredMocker:spyOn(guineaPig, "foo")

		expect(mockObj).toEqual(expect.any("table"))
		expect(guineaPig.foo).toEqual(expect.any("table"))
		expect(guineaPig.foo).toEqual(mockObj)
	end)

	it("oldFunctionSpying = false injects alike types", function()
		local config = table.clone(JestConfig.projectDefaults)
		config.oldFunctionSpying = false
		local configuredMocker = ModuleMocker.new(config)

		local guineaPig = {
			foo = function() end,
		}
		local mockObj = configuredMocker:spyOn(guineaPig, "foo")

		expect(mockObj).toEqual(expect.any("table"))
		expect(guineaPig.foo).toEqual(expect.any("function"))
		expect(guineaPig.foo).never.toEqual(mockObj)
	end)

	it("oldFunctionSpying defaults to backwards compatibile behaviour", function()
		local guineaPig = {
			foo = function() end,
		}
		local mockObj = moduleMocker:spyOn(guineaPig, "foo")

		expect(mockObj).toEqual(expect.any("table"))
		expect(guineaPig.foo).toEqual(expect.any("table"))
		expect(guineaPig.foo).toEqual(mockObj)
	end)
end)
