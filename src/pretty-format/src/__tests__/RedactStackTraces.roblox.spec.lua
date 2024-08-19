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

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local PrettyFormat = require(CurrentModule)
local prettyFormat = PrettyFormat.default
local RedactStackTraces = PrettyFormat.plugins.RedactStackTraces

local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local function pretty(val: any)
	return prettyFormat(val, {
		plugins = { RedactStackTraces },
		redactStackTracesInStrings = true,
	})
end

local function prettyNoStr(val: any)
	return prettyFormat(val, {
		plugins = { RedactStackTraces },
		redactStackTracesInStrings = false,
	})
end

local function prettyNoPlugin(val: any)
	return prettyFormat(val, {
		plugins = {},
	})
end

local LUA_ERROR = "LoadedCode.JestRoblox._Workspace.JestSnapshot.JestSnapshot.__tests__.snapshot.roblox.spec:35: "
	.. "Every journey in the debugger starts with a single step"

local JS_STACK = "Error: If at first you don't succeed, pray you're in a protected call\n"
	.. "LoadedCode.JestRoblox._Workspace.JestSnapshot.JestSnapshot.__tests__.snapshot.roblox.spec:35 function foo\n"
	.. "LoadedCode.JestRoblox._Workspace.JestSnapshot.JestSnapshot.__tests__.snapshot.roblox.spec:35\n"
	.. "LoadedCode.JestRoblox._Workspace.JestSnapshot.JestSnapshot.__tests__.snapshot.roblox.spec:35"

local JS_ERROR = Error.new(JS_STACK)
JS_ERROR.stack = JS_STACK

local UNRELATED = "this.is.not.related: 25, unrelated_message:64"

describe("Lua errors (strings)", function()
	it("does not keep the file path", function()
		expect(pretty(LUA_ERROR)).never.toContain(
			"LoadedCode.JestRoblox._Workspace.JestSnapshot.JestSnapshot.__tests__.snapshot.roblox.spec"
		)
	end)

	it("does not keep the line number", function()
		expect(pretty(LUA_ERROR)).never.toContain("35")
	end)

	it("keeps the message intact", function()
		expect(pretty(LUA_ERROR)).toContain("Every journey in the debugger starts with a single step")
	end)

	it("doesn't touch unrelated messages", function()
		expect(pretty(UNRELATED)).toEqual(prettyNoPlugin(UNRELATED))
	end)

	it("respects the configuration setting to disable string redaction", function()
		expect(prettyNoStr(LUA_ERROR)).toEqual(prettyNoPlugin(LUA_ERROR))
	end)
end)

describe("JS errors (non-strings)", function()
	it("does not keep the file path", function()
		expect(pretty(JS_ERROR)).never.toContain(
			"LoadedCode.JestRoblox._Workspace.JestSnapshot.JestSnapshot.__tests__.snapshot.roblox.spec"
		)
		expect(prettyNoStr(JS_ERROR)).never.toContain(
			"LoadedCode.JestRoblox._Workspace.JestSnapshot.JestSnapshot.__tests__.snapshot.roblox.spec"
		)
	end)

	it("does not keep the line number", function()
		expect(pretty(JS_ERROR)).never.toContain("35")
		expect(prettyNoStr(JS_ERROR)).never.toContain("35")
	end)

	it("keeps the message intact", function()
		expect(pretty(JS_ERROR)).toContain("If at first you don't succeed, pray you're in a protected call")
		expect(prettyNoStr(JS_ERROR)).toContain("If at first you don't succeed, pray you're in a protected call")
	end)
end)

it("doesn't touch unrelated messages", function()
	expect(prettyNoStr(UNRELATED)).toEqual(prettyNoPlugin(UNRELATED))
end)
