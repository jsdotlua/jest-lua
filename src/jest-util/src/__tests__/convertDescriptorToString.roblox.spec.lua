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

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local convertDescriptorToString = require(SrcModule.convertDescriptorToString).default

describe("convertDescriptorToString", function()
	it("should return same value if provided string", function()
		expect(convertDescriptorToString("foo")).toBe("foo")
	end)

	it("should return same value it provided number", function()
		expect(convertDescriptorToString(1)).toBe(1)
	end)

	it("should return same value it provided nil", function()
		expect(convertDescriptorToString(nil)).toBe(nil)
	end)

	it("should return function name", function()
		local function foo() end
		expect(convertDescriptorToString(foo)).toEqual("foo")
	end)

	it('should return "[Function anonymous]" for anonymous function', function()
		local foo = function() end
		expect(convertDescriptorToString(foo)).toEqual("[Function anonymous]")
	end)
end)

return {}
