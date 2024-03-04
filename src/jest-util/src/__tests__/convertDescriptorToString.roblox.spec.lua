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

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local convertDescriptorToString = require("../convertDescriptorToString").default

describe("convertDescriptorToString", function()
	it("should return same value if provided string", function()
		expect(convertDescriptorToString("foo")).toBe("foo")
	end)

	it("should return the value converted to string if provided a number", function()
		expect(convertDescriptorToString(1)).toBe("1")
	end)

	it("should return the value converted to string if provided nil", function()
		expect(convertDescriptorToString(nil)).toBe("nil")
	end)

	it("should return function name", function()
		local function foo() end
		expect(convertDescriptorToString(foo)).toEqual("foo")
	end)

	it("should throw an error for anonymous functions", function()
		local foo = function() end
		expect(function()
			convertDescriptorToString(foo)
		end).toThrowError(
			"Invalid first argument, [Function anonymous]. It must be a named function, number, or string."
		)
	end)
end)
