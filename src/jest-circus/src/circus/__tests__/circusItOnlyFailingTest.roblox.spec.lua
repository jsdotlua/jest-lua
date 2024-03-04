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
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local jest = JestGlobals.jest
local it = JestGlobals.it
local afterAll = JestGlobals.afterAll

describe("it.only.failing works", function()
	local fail = jest.fn(function()
		expect(true).toBe(false)
	end)
	afterAll(function()
		expect(fail).toHaveBeenCalledTimes(1)
	end)

	it.only.failing("only this test should run", function()
		fail()
	end)
	it.failing("skip failing test", function()
		fail()
	end)
end)
