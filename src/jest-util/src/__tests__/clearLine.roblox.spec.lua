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

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local clearLine = require(SrcModule.clearLine).default

describe("clearLine", function()
	local writeMock
	local stream
	beforeEach(function()
		writeMock = jest.fn()
		stream = {
			write = writeMock,
		}
	end)

	it("should NOT clear line if stream is NOT TTY", function()
		clearLine(stream)

		expect(writeMock).never.toHaveBeenCalled()
	end)

	it("should clear line if stream is TTY", function()
		stream.isTTY = true
		clearLine(stream)

		expect(writeMock).toHaveBeenCalledTimes(1)
		expect(writeMock).toHaveBeenCalledWith(stream, "\x1b[999D\x1b[K")
	end)
end)
