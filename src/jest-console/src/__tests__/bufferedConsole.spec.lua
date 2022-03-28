-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-console/src/__tests__/bufferedConsole.test.ts
--[[*
* Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
*
* This source code is licensed under the MIT license found in the
* LICENSE file in the root directory of this source tree.
]]
return function()
	local CurrentModule = script.Parent
	local Packages = CurrentModule.Parent.Parent

	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Array = LuauPolyfill.Array

	local jestExpect = require(Packages.Dev.Expect)

	local chalk = require(Packages.ChalkLua)
	local BufferedConsoleModule = require(CurrentModule.Parent.BufferedConsole)
	local BufferedConsole = BufferedConsoleModule.default
	type BufferedConsole = BufferedConsoleModule.BufferedConsole

	local typesModule = require(CurrentModule.Parent.types)
	type ConsoleBuffer = typesModule.ConsoleBuffer

	describe("BufferedConsole", function()
		local _console: BufferedConsole
		local function stdout()
			local buffer = _console:getBuffer()
			if buffer == nil then
				return ""
			end
			return Array.join(
				Array.map(buffer :: ConsoleBuffer, function(log)
					return log.message
				end),
				"\n"
			)
		end
		beforeEach(function()
			_console = BufferedConsole.new()
		end)
		describe("assert", function()
			it("do not log when the assertion is truthy", function()
				_console:assert(true)
				jestExpect(stdout()).toMatch("")
			end)
			it("do not log when the assertion is truthy and there is a message", function()
				_console:assert(true, "ok")
				jestExpect(stdout()).toMatch("")
			end)
			it("log the assertion error when the assertion is falsy", function()
				_console:assert(false)
				-- ROBLOX deviation START: lua assert has different outputs
				jestExpect(stdout()).toMatch("assertion failed!")
				-- jestExpect(stdout()).toMatch("false == true")
				-- ROBLOX deviation END
			end)
			it("log the assertion error when the assertion is falsy with another message argument", function()
				_console:assert(false, "ok")
				-- ROBLOX deviation: lua assert has different outputs
				jestExpect(stdout()).toMatch("assertion failed!")
				jestExpect(stdout()).toMatch("ok")
			end)
		end)
		describe("count", function()
			it("count using the default counter", function()
				_console:count()
				_console:count()
				_console:count()
				jestExpect(stdout()).toEqual("default: 1\ndefault: 2\ndefault: 3")
			end)
			it("count using the a labeled counter", function()
				_console:count("custom")
				_console:count("custom")
				_console:count("custom")
				jestExpect(stdout()).toEqual("custom: 1\ncustom: 2\ncustom: 3")
			end)
			it("countReset restarts default counter", function()
				_console:count()
				_console:count()
				_console:countReset()
				_console:count()
				jestExpect(stdout()).toEqual("default: 1\ndefault: 2\ndefault: 1")
			end)
			it("countReset restarts custom counter", function()
				_console:count("custom")
				_console:count("custom")
				_console:countReset("custom")
				_console:count("custom")
				jestExpect(stdout()).toEqual("custom: 1\ncustom: 2\ncustom: 1")
			end)
		end)
		describe("group", function()
			it("group without label", function()
				_console:group()
				_console:log("hey")
				_console:group()
				_console:log("there")
				jestExpect(stdout()).toEqual("  hey\n    there")
			end)
			it("group with label", function()
				_console:group("first")
				_console:log("hey")
				_console:group("second")
				_console:log("there")
				jestExpect(stdout()).toEqual(([[  %s
  hey
    %s
    there]]):format(chalk.bold("first"), chalk.bold("second")))
			end)
			it("groupEnd remove the indentation of the current group", function()
				_console:group()
				_console:log("hey")
				_console:groupEnd()
				_console:log("there")
				jestExpect(stdout()).toEqual("  hey\nthere")
			end)
			it("groupEnd can not remove the indentation below the starting point", function()
				_console:groupEnd()
				_console:groupEnd()
				_console:group()
				_console:log("hey")
				_console:groupEnd()
				_console:log("there")
				jestExpect(stdout()).toEqual("  hey\nthere")
			end)
		end)
		describe("time", function()
			it("should return the time between time() and timeEnd() on default timer", function()
				_console:time()
				_console:timeEnd()
				jestExpect(stdout()).toMatch("default: ")
				jestExpect(stdout()).toMatch("ms")
			end)
			it("should return the time between time() and timeEnd() on custom timer", function()
				_console:time("custom")
				_console:timeEnd("custom")
				jestExpect(stdout()).toMatch("custom: ")
				jestExpect(stdout()).toMatch("ms")
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
				jestExpect(stdout()).toMatch("value")
				jestExpect(stdout()).never.toMatch("depth")
			end)
		end)
		describe("timeLog", function()
			it("should return the time between time() and timeEnd() on default timer", function()
				_console:time()
				_console:timeLog()
				jestExpect(stdout()).toMatch("default: ")
				jestExpect(stdout()).toMatch("ms")
				_console:timeEnd()
			end)
			it("should return the time between time() and timeEnd() on custom timer", function()
				_console:time("custom")
				_console:timeLog("custom")
				jestExpect(stdout()).toMatch("custom: ")
				jestExpect(stdout()).toMatch("ms")
				_console:timeEnd("custom")
			end)
			it("default timer with data", function()
				_console:time()
				_console:timeLog(nil, "foo", 5)
				jestExpect(stdout()).toMatch("default: ")
				jestExpect(stdout()).toMatch("ms foo 5")
				_console:timeEnd()
			end)
			it("custom timer with data", function()
				_console:time("custom")
				_console:timeLog("custom", "foo", 5)
				jestExpect(stdout()).toMatch("custom: ")
				jestExpect(stdout()).toMatch("ms foo 5")
				_console:timeEnd("custom")
			end)
		end)
		describe("console", function()
			it("should be able to initialize console instance", function()
				jestExpect(_console.Console).toBeDefined()
			end)
		end)
	end)
end
