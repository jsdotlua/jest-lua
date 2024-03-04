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
local it = JestGlobals.it
local describe = JestGlobals.describe

local prettyFormat = require("../init").default

it("userdata", function()
	local testObject = newproxy()

	expect(prettyFormat(testObject)).toContain("userdata: 0x")
end)

it("Instance", function()
	local testObject = Instance.new("Frame")

	expect(prettyFormat(testObject)).toEqual("Frame")
end)

it("Builtin Datatypes", function()
	expect(prettyFormat(Color3.new(1, 1, 1))).toEqual("Color3(1, 1, 1)")
	expect(prettyFormat(UDim2.new(1, 50, 0, 50))).toEqual("UDim2({1, 50}, {0, 50})")
	expect(prettyFormat(Vector3.new(10, 20, 30))).toEqual("Vector3(10, 20, 30)")
end)

describe("bad plugin", function()
	local badPlugin = {
		test = function(val)
			return val and val.foo ~= nil -- bad check, should be typeof(val) == "table"
		end,
		serialize = function(val, config, indentation, depth, refs, printer)
			return "Pretty foo: " .. printer(val.foo, config, indentation, depth, refs, printer)
		end,
	}
	local options: any = { plugins = { badPlugin } }

	it("should throw PrettyFormatPluginError", function()
		local bar = {
			foo = {
				a = 1,
				b = 2,
			},
		}
		local ok, result = pcall(function()
			prettyFormat(bar, options)
		end)
		expect(ok).toBeFalsy()
		expect(result.name).toBe("PrettyFormatPluginError")
		expect(result.message).toMatch("attempt to index number with 'foo'")
	end)
end)
