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
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach
local afterEach = JestGlobals.afterEach

local createDirectory = require(SrcModule.createDirectory).default

describe("createDirectory", function()
	local mockFileSystem: any
	local mockFileSystemPrevValue

	beforeEach(function()
		mockFileSystem = {}
		mockFileSystemPrevValue = _G.__MOCK_FILE_SYSTEM__
		_G.__MOCK_FILE_SYSTEM__ = mockFileSystem
	end)

	afterEach(function()
		_G.__MOCK_FILE_SYSTEM__ = mockFileSystemPrevValue
	end)

	it("should re-throw error from CreateDirectories", function()
		function mockFileSystem:CreateDirectories()
			error("kaboom")
		end

		expect(function()
			createDirectory("Packages/foo/bar")
		end).toThrow("kaboom")
	end)

	it("should throw 'Provided path is invalid' when access denied", function()
		function mockFileSystem:CreateDirectories()
			error("Error(13): Access Denied. Path is outside of sandbox.")
		end

		expect(function()
			createDirectory("Packages/foo/bar")
		end).toThrow(
			"Provided path is invalid: you likely need to provide a different argument to --fs.readwrite.\nYou may need to pass in `--fs.readwrite=$PWD`"
		)
	end)

	it("should not throw when CreateDirectories executes successfully", function()
		function mockFileSystem:CreateDirectories() end

		expect(function()
			createDirectory("Packages/foo/bar")
		end).never.toThrow()
	end)
end)
