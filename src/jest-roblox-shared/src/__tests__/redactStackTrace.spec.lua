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

local redactStackTrace = require("../redactStackTrace")

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local it = JestGlobals.it

local REAL_STACK_TRACE = "LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.errorParsing.roblox.spec:51\n"
	.. "LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:2046 function _execModule\n"
	.. "LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1414 function _loadModule\n"
	.. "LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1260\n"
	.. "LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1259 function requireModule\n"
	.. "LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.legacy-code-todo-rewrite.jestAdapter:114"

local REAL_STACK_TRACE_ALT = "LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:555 function _getError\n"
	.. "LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:443 function makeRunResult\n"
	.. "LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.errorParsing.roblox.spec:56\n"
	.. "LoadedCode.JestRoblox._Workspace.JestEach.JestEach.bind:170\n"
	.. "LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:369"

local LUA_STYLE_ERROR =
	"LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:555: Something bad happened!"

it("should handle nil", function()
	expect(function()
		expect(redactStackTrace(nil)).toBeNil()
	end).never.toThrow()
end)

it("should redact a stack trace on its own", function()
	expect(redactStackTrace(REAL_STACK_TRACE)).never.toEqual(REAL_STACK_TRACE)
end)

it("should redact a stack trace embedded in a message", function()
	local stack = "I am a message " .. REAL_STACK_TRACE .. "\nI am a message"
	expect(redactStackTrace(stack)).never.toEqual(stack)
end)

it("should leave non-stack-frame lines unchanged", function()
	local stack = "This is the front " .. REAL_STACK_TRACE .. "\nThis is the back"

	local redacted = redactStackTrace(stack)
	expect(redacted).toContain("This is the front")
	expect(redacted).toContain("This is the back")
end)

it("should not vary length or content between stack traces", function()
	expect(redactStackTrace(REAL_STACK_TRACE)).toEqual(redactStackTrace(REAL_STACK_TRACE_ALT))
end)

it("stack traces should stay the same in snapshots", function()
	expect(redactStackTrace(REAL_STACK_TRACE)).toMatchSnapshot()
	expect(redactStackTrace(REAL_STACK_TRACE_ALT)).toMatchSnapshot()
end)

it("does not add trailing newlines", function()
	expect(redactStackTrace(REAL_STACK_TRACE)).never.toMatch("\n$")
end)

it("preserves trailing newlines", function()
	expect(redactStackTrace(REAL_STACK_TRACE) :: any .. "\n").toMatch("\n$")
end)

it("supports Lua-style errors", function()
	expect(redactStackTrace(LUA_STYLE_ERROR)).never.toEqual(LUA_STYLE_ERROR)
end)
