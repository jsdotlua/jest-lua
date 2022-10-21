--!strict
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

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local jestModule = require(CurrentModule)

describe("Jest", function()
	describe("re-exports JestCore", function()
		it("SearchSource", function()
			expect(jestModule.SearchSource).toBeDefined()
		end)

		it("TestWatcher", function()
			expect(jestModule.TestWatcher).toBeDefined()
		end)

		it("createTestScheduler", function()
			expect(jestModule.createTestScheduler).toBeDefined()
		end)

		-- ROBLOX NOTE: not ported
		it.skip("getVersion", function()
			-- expect(jestModule.getVersion).toBeDefined()
		end)

		it("runCLI", function()
			expect(jestModule.runCLI).toBeDefined()
		end)
	end)
end)
