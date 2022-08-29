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
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local pluralize = require(SrcModule.pluralize).default

describe("pluralize", function()
	it("should not pluralize when count is 1", function()
		jestExpect(pluralize("test", 1)).toEqual("1 test")
	end)

	it("should pluralize when count is 0", function()
		jestExpect(pluralize("test", 0)).toEqual("0 tests")
	end)

	it("should pluralize when count is more than 1", function()
		for i = 2, 100 do
			jestExpect(pluralize("test", i)).toEqual(tostring(i) .. " tests")
		end
	end)
end)

return {}
