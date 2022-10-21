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
-- ROBLOX note: no upstream

local CurrentModule = script.Parent
local Packages = CurrentModule.Parent.Parent
local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local helpersModule = require(CurrentModule.Parent.helpers)
local format = helpersModule.format
local formatWithOptions = helpersModule.formatWithOptions

describe("format", function()
	it("formats a string as expected", function()
		expect(format("%s - 1 - %s - 2", "Hello", "World")).toBe("Hello - 1 - World - 2")
		expect(format("%d%d", 1, 2)).toBe("12")
		expect(format("hello")).toBe("hello")
	end)

	it("concats any extra args to the end of the string", function()
		expect(format("%s - 1 - %s - 2", "Hello", "World", "Another one!")).toBe("Hello - 1 - World - 2 Another one!")
		expect(format("Hello,", "world", "another", "one")).toBe("Hello, world another one")
	end)

	it("inspects complex values", function()
		expect(format({ { "value" } })).toMatch("value")
		expect(format({ "in table" }, "hello")).toMatch("hello")
	end)
end)

describe("formatWithOptions", function()
	it("accepts a depth option to enable printing deeper in nested tables", function()
		local nestedValue = { { { { { { { "value" } } } } } } }
		expect(formatWithOptions({ depth = 2 }, nestedValue)).never.toMatch("value")
		expect(formatWithOptions({ depth = 7 }, nestedValue)).toMatch("value")
	end)
end)
