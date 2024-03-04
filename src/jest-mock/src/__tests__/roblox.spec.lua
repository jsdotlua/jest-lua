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
-- ROBLOX NOTE: no upstream

local ModuleMocker = require("../init").ModuleMocker
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local moduleMocker
beforeEach(function()
	moduleMocker = ModuleMocker.new()
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
