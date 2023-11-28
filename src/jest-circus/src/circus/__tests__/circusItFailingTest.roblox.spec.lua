--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License")
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
local Packages = SrcModule.Parent.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local test = JestGlobals.test
local jest = JestGlobals.jest
local afterAll = JestGlobals.afterAll

describe("it.failing works", function()
	local fail = jest.fn(function()
		expect(true).toBe(false)
	end)

	afterAll(function()
		expect(fail).toHaveBeenCalledTimes(2)
	end)

	it.failing("failing fails = passes", function()
		fail()
	end)

	test.failing("failing fails = passes with test syntax", function()
		fail()
	end)

	it.skip.failing("skipped failing 1", function()
		fail()
	end)

	test.skip.failing("skipped failing 2", function()
		fail()
	end)

	-- There currently isn't a good way to ensure that certain behavior fails when it is expected to fail.
	-- TODO: Set up some sort of e2e testing similar to upstream: https://github.com/jestjs/jest/tree/main/e2e/test-failing/__tests__

	-- test.failing("failing passes = fails", function()
	-- 	expect(10).toBe(10)
	-- end)
end)
