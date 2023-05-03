-- ROBLOX upstream: https://github.com/facebook/jest/tree/v28.0.0/packages/jest-console/src/__tests__/CustomConsole.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent
local Packages = CurrentModule.Parent.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach
local Writeable = require(Packages.RobloxShared).Writeable

local chalk = require(Packages.ChalkLua)
local CustomConsoleModule = require(CurrentModule.Parent.CustomConsole)
local CustomConsole = CustomConsoleModule.default
type CustomConsole = CustomConsoleModule.CustomConsole

describe("CustomConsole", function()
	local _console: CustomConsole
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

		_console = CustomConsole.new(stdout, stderr)
	end)
	describe("log", function()
		it("should print to stdout", function()
			_console:log("Hello world!")
			expect(_stdout).toBe("Hello world!\n")
		end)
	end)
	describe("error", function()
		it("should print to stderr", function()
			_console:error("Found some error!")
			expect(_stderr).toBe("Found some error!\n")
		end)
	end)
	describe("warn", function()
		it("should print to stderr", function()
			_console:warn("Found some warning!")
			expect(_stderr).toBe("Found some warning!\n")
		end)
	end)
	describe("assert", function()
		it("do not log when the assertion is truthy", function()
			_console:assert(true)
			expect(_stderr).toMatch("")
		end)
		it("do not log when the assertion is truthy and there is a message", function()
			_console:assert(true, "ok")
			expect(_stderr).toMatch("")
		end)
		it("log the assertion error when the assertion is falsy", function()
			_console:assert(false)
			-- ROBLOX deviation: different assert message
			expect(_stderr).toMatch("assertion failed!")
		end)
		it("log the assertion error when the assertion is falsy with another message argument", function()
			_console:assert(false, "this should not happen")
			-- ROBLOX deviation: different assert message
			expect(_stderr).toMatch("assertion failed!")
			expect(_stderr).toMatch("this should not happen")
		end)
	end)
	describe("count", function()
		it("count using the default counter", function()
			_console:count()
			_console:count()
			_console:count()
			expect(_stdout).toEqual("default: 1\ndefault: 2\ndefault: 3\n")
		end)
		it("count using the a labeled counter", function()
			_console:count("custom")
			_console:count("custom")
			_console:count("custom")
			expect(_stdout).toEqual("custom: 1\ncustom: 2\ncustom: 3\n")
		end)
		it("countReset restarts default counter", function()
			_console:count()
			_console:count()
			_console:countReset()
			_console:count()
			expect(_stdout).toEqual("default: 1\ndefault: 2\ndefault: 1\n")
		end)
		it("countReset restarts custom counter", function()
			_console:count("custom")
			_console:count("custom")
			_console:countReset("custom")
			_console:count("custom")
			expect(_stdout).toEqual("custom: 1\ncustom: 2\ncustom: 1\n")
		end)
	end)
	describe("group", function()
		it("group without label", function()
			_console:group()
			_console:log("hey")
			_console:group()
			_console:log("there")
			expect(_stdout).toEqual("  hey\n    there\n")
		end)
		it("group with label", function()
			_console:group("first")
			_console:log("hey")
			_console:group("second")
			_console:log("there")
			expect(_stdout).toEqual(([[  %s
  hey
    %s
    there
]]):format(chalk.bold("first"), chalk.bold("second")))
		end)
		it("groupEnd remove the indentation of the current group", function()
			_console:group()
			_console:log("hey")
			_console:groupEnd()
			_console:log("there")
			expect(_stdout).toEqual("  hey\nthere\n")
		end)
		it("groupEnd can not remove the indentation below the starting point", function()
			_console:groupEnd()
			_console:groupEnd()
			_console:group()
			_console:log("hey")
			_console:groupEnd()
			_console:log("there")
			expect(_stdout).toEqual("  hey\nthere\n")
		end)
	end)
	describe("time", function()
		it("should return the time between time() and timeEnd() on default timer", function()
			_console:time()
			_console:timeEnd()
			expect(_stdout).toMatch("default: ")
			expect(_stdout).toMatch("ms")
		end)
		it("should return the time between time() and timeEnd() on custom timer", function()
			_console:time("custom")
			_console:timeEnd("custom")
			expect(_stdout).toMatch("custom: ")
			expect(_stdout).toMatch("ms")
		end)
	end)
	describe("dir", function()
		it("should print the deepest value", function()
			local deepObject = {
				[tostring(1)] = {
					[tostring(2)] = {
						[tostring(3)] = {
							[tostring(4)] = { [tostring(5)] = { [tostring(6)] = "value" } },
						},
					},
				},
			}
			_console:dir(deepObject, { depth = 6 })

			expect(_stdout).toMatch("value")
			expect(_stdout).never.toMatch("depth")
		end)
	end)
	describe("timeLog", function()
		it("should return the time between time() and timeEnd() on default timer", function()
			_console:time()
			_console:timeLog()
			expect(_stdout).toMatch("default: ")
			expect(_stdout).toMatch("ms")
			_console:timeEnd()
		end)
		it("should return the time between time() and timeEnd() on custom timer", function()
			_console:time("custom")
			_console:timeLog("custom")
			expect(_stdout).toMatch("custom: ")
			expect(_stdout).toMatch("ms")
			_console:timeEnd("custom")
		end)
		it("default timer with data", function()
			_console:time()
			_console:timeLog(nil, "foo", 5)
			expect(_stdout).toMatch("default: ")
			expect(_stdout).toMatch("ms foo 5")
			_console:timeEnd()
		end)
		it("custom timer with data", function()
			_console:time("custom")
			_console:timeLog("custom", "foo", 5)
			expect(_stdout).toMatch("custom: ")
			expect(_stdout).toMatch("ms foo 5")
			_console:timeEnd("custom")
		end)
	end)
	describe("console", function()
		it("should be able to initialize console instance", function()
			expect(_console.Console).toBeDefined()
		end)
	end)
end)
