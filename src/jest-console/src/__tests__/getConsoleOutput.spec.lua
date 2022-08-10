-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-console/src/__tests__/getConsoleOutput.test.ts
--[[*
* Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
*
* This source code is licensed under the MIT license found in the
* LICENSE file in the root directory of this source tree.
]]

local CurrentModule = script.Parent
local Packages = CurrentModule.Parent.Parent

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = (JestGlobals.describe :: any) :: Function
local it = (JestGlobals.it :: any) :: Function
local beforeEach = (JestGlobals.beforeEach :: any) :: Function

local jestTypesModule = require(Packages.JestTypes)
type GlobalConfig = jestTypesModule.Config_GlobalConfig

local getConsoleOutput = require(CurrentModule.Parent.getConsoleOutput).default

local BufferedConsoleModule = require(CurrentModule.Parent.BufferedConsole)
local BufferedConsole = BufferedConsoleModule.default
type BufferedConsole = BufferedConsoleModule.BufferedConsole

local typesModule = require(CurrentModule.Parent.types)
type ConsoleBuffer = typesModule.ConsoleBuffer

describe("getConsoleOutput", function()
	local _console: BufferedConsole

	beforeEach(function()
		_console = BufferedConsole.new()
	end)

	-- ROBLOX deviation START: Added tests to make sure ported getConsoleOutput works
	it("creates a properly formatted string from a console buffer", function()
		local globalConfig = { noStackTrace = true } :: GlobalConfig
		_console:log("Hello world!")

		local buffer = _console:getBuffer()
		if buffer == nil then
			buffer = {}
		end

		local output = getConsoleOutput(buffer :: ConsoleBuffer, { rootDir = Packages, testMatch = {} }, globalConfig)
		jestExpect(output).toMatch("console.log")
		jestExpect(output).toMatch("Hello world!")
	end)

	it("should return the entire console buffer", function()
		local globalConfig = { noStackTrace = true } :: GlobalConfig
		_console:log("Hello world!")
		_console:error("Found some error!")
		_console:warn("Found some warning!")

		local buffer = _console:getBuffer()
		if buffer == nil then
			buffer = {}
		end

		local output = getConsoleOutput(buffer :: ConsoleBuffer, { rootDir = Packages, testMatch = {} }, globalConfig)
		jestExpect(output).toMatch("console.log")
		jestExpect(output).toMatch("Hello world!")
		jestExpect(output).toMatch("console.error")
		jestExpect(output).toMatch("Found some error!")
		jestExpect(output).toMatch("console.warn")
		jestExpect(output).toMatch("Found some warning!")
	end)
end)
-- ROBLOX deviation END

-- ROBLOX todo: Uncomment these tests when module mocking is supported
-- local each = require(Packages.JestEach).default({
-- 	it = it,
-- 	itFOCUS = itFOCUS,
-- })
-- local makeGlobalConfig = require(Packages.JestUtil).makeGlobalConfig
-- local formatStackTrace = require(Packages.JestMessageUtils).formatStackTrace
-- local BufferedConsole = require(CurrentModule.Parent.BufferedConsole)
-- local getConsoleOutput = require(CurrentModule.Parent.getConsoleOutput)

-- local ModuleMocker = require(Packages.JestMock).ModuleMocker
-- local jestExpect = require(Packages.Dev.JestGlobals).expect

-- local typesModule = require(CurrentModule.Parent.types)
-- type LogType = typesModule.LogType

-- local moduleMocker = ModuleMocker.new()
-- local formatStackTrace = moduleMocker:fn()

-- describeFOCUS("getConsoleOutput", function()
-- 	local globalConfig = { noStackTrace = true }
-- 	formatStackTrace:mockImplementation(function()
-- 		return 'throw new Error("Whoops!");'
-- 	end)

-- 	each(
-- 		"logType",
-- 		{ "assert" },
-- 		{ "count" },
-- 		{ "debug" },
-- 		{ "dir" },
-- 		{ "dirxml" },
-- 		{ "error" },
-- 		{ "group" },
-- 		{ "groupCollapsed" },
-- 		{ "info" },
-- 		{ "log" },
-- 		{ "time" },
-- 		{ "warn" }
-- 	).itFOCUS("takes noStackTrace and pass it on for $logType", function(ref)
-- 		local logType = ref.logType
-- 		getConsoleOutput(
-- 			BufferedConsole.write({}, logType :: LogType, "message", 4),
-- 			{ rootDir = "root", testMatch = {} },
-- 			globalConfig
-- 		)
-- 		jestExpect(formatStackTrace).toHaveBeenCalled()
-- 		jestExpect(formatStackTrace).toHaveBeenCalledWith(
-- 			jestExpect.anything(),
-- 			jestExpect.anything(),
-- 			jestExpect.objectContaining({ noCodeFrame = jestExpect.anything(), noStackTrace = true })
-- 		)
-- 	end)
-- end)

return {}
