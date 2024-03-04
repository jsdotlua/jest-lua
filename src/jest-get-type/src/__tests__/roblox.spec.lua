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

local getType = require("../init").getType
local isRobloxBuiltin = require("../init").isRobloxBuiltin

describe(".getType()", function()
	it("supports tables with a throwing __index metamethod", function()
		local testObj = {}
		setmetatable(testObj, {
			__index = function(self, key)
				error(("%q is not a valid member of BackBehavior"):format(tostring(key)), 2)
			end,
		})
		expect(getType(testObj)).toBe("table")
	end)

	it("supports builtin Roblox Datatypes", function()
		expect(getType(Vector3.new())).toBe("Vector3")
		expect(getType(Color3.new())).toBe("Color3")
		expect(getType(UDim2.new())).toBe("UDim2")
	end)
end)

describe(".isRobloxBuiltin()", function()
	it("returns true for builtin types", function()
		expect(isRobloxBuiltin(Vector3.new())).toBe(true)
		expect(isRobloxBuiltin(Color3.new())).toBe(true)
		expect(isRobloxBuiltin(UDim2.new())).toBe(true)
	end)

	it("returns false for non builtin types", function()
		expect(isRobloxBuiltin(1)).toBe(false)
		expect(isRobloxBuiltin({})).toBe(false)
		expect(isRobloxBuiltin(newproxy())).toBe(false)
	end)
end)
