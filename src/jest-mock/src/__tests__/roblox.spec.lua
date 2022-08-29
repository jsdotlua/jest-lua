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

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local ModuleMocker = require(CurrentModule).ModuleMocker
local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local moduleMocker
beforeEach(function()
	moduleMocker = ModuleMocker.new()
end)

it("mock return chaining", function()
	local myMock = moduleMocker:fn()
	jestExpect(myMock()).toBeNil()

	myMock.mockReturnValueOnce(10).mockReturnValueOnce("x").mockReturnValue(true)
	jestExpect(myMock()).toBe(10)
	jestExpect(myMock()).toBe("x")
	jestExpect(myMock()).toBe(true)
	jestExpect(myMock()).toBe(true)
end)

it("default mock function name is jest.fn()", function()
	local myMock = moduleMocker:fn()
	jestExpect(myMock.getMockName()).toBe("jest.fn()")
end)

it("returns a function as the second return value", function()
	local mock, mockFn = moduleMocker:fn()
	mock.mockImplementationOnce(function(a, b)
		return a .. b
	end)
	mock.mockReturnValue(true)

	jestExpect(typeof(mockFn)).toBe("function")

	jestExpect(mockFn("a", "b")).toBe("ab")
	jestExpect(mock).toHaveBeenLastCalledWith("a", "b")
	jestExpect(mock).toHaveLastReturnedWith("ab")

	jestExpect(mockFn()).toBe(true)
	jestExpect(mock).toHaveLastReturnedWith(true)
end)

return {}
