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
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local Writeable = require(Packages.RobloxShared).Writeable

local ConsoleModule = require(CurrentModule.Parent.Console)
local Console = ConsoleModule.default
type Console = ConsoleModule.Console

describe("Console", function()
	local _console: Console
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

		_console = Console.new(stdout, stderr)
	end)

	it("can write to the console", function()
		_console:log("Hello, world!")
		jestExpect(_stdout).toBe("Hello, world!\n")
	end)

	it("properly formats input", function()
		_console:log("Hello, %s!", "world")
		jestExpect(_stdout).toBe("Hello, world!\n")
	end)

	it("writes to stderr", function()
		_console:error("Hello, world!")
		jestExpect(_stderr).toBe("Hello, world!\n")
	end)
end)

return {}
