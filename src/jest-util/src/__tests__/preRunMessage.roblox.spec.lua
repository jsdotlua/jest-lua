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
local jest = JestGlobals.jest
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local preRunMessageModule = require("../preRunMessage")
local print_, remove = preRunMessageModule.print, preRunMessageModule.remove

describe("preRunMessage", function()
	local writeMock
	local stream
	beforeEach(function()
		writeMock = jest.fn()
		stream = {
			write = writeMock,
		}
	end)

	it("should execute print without error", function()
		expect(function()
			print_(stream)
		end).never.toThrow()
	end)

	it("should execute remove without error", function()
		expect(function()
			remove(stream)
		end).never.toThrow()
	end)
end)
