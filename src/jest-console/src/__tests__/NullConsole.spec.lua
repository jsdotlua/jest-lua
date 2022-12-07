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
local beforeEach = JestGlobals.beforeEach

local Writeable = require(Packages.JestRobloxShared).Writeable

local NullConsoleModule = require(CurrentModule.Parent.NullConsole)
local NullConsole = NullConsoleModule.default
type NullConsole = NullConsoleModule.NullConsole

describe("NullConsole", function()
	local _console: NullConsole
	local _stdout: string
	local _stderr: string

	beforeEach(function()
		_stdout = ""
		_stderr = ""

		local stdout = Writeable.new({
			write = function(message: string)
				_stdout ..= message .. "\n"
			end,
		})

		local stderr = Writeable.new({
			write = function(message: string)
				_stderr ..= message .. "\n"
			end,
		})

		_console = NullConsole.new(stdout, stderr)
	end)

	it("should not write to the console stdout", function()
		_console:log("Hello, world!")
		expect(_stdout).toBe("")
	end)

	it("should not write to the console stderr", function()
		_console:error("Somethign went wrong")
		expect(_stdout).toBe("")
	end)
end)
