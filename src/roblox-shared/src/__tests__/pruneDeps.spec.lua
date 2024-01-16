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

local pruneDeps = require(CurrentModule.Parent.pruneDeps)

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local it = JestGlobals.it

it("should handle nil", function()
	expect(function()
		expect(pruneDeps(nil)).toBeNil()
	end).never.toThrow()
end)

it("should keep stack frames within this package", function()
	local stack = [=[
		LoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.someModule:123
		LoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.otherModule:456
	]=]
	expect(pruneDeps(stack)).toEqual(stack)
end)

it("should keep stack frames within the workspace", function()
	local stack = [=[
		LoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.someModule:123
		LoadedCode.JestRoblox._Workspace.JestSnapshot.JestSnapshot.snapshotModule:456
		LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circusModule:789
	]=]
	expect(pruneDeps(stack)).toEqual(stack)
end)

it("should remove stack frames from dependencies", function()
	local stack = [=[
		LoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.someModule:123
		LoadedCode.JestRoblox._Index.Collections.Collections.Array.map:50
		LoadedCode.JestRoblox._Workspace.JestSnapshot.JestSnapshot.snapshotModule:456
		LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circusModule:789
		LoadedCode.JestRoblox._Index.Promise.Promise:172 function runExecutor
		LoadedCode.JestRoblox._Index.Promise.Promise:299
	]=]
	expect(pruneDeps(stack)).toEqual([=[
		LoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.someModule:123
		LoadedCode.JestRoblox._Workspace.JestSnapshot.JestSnapshot.snapshotModule:456
		LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circusModule:789
	]=])
end)

it("should leave non-stack-frame lines unchanged", function()
	local message = [=[
		This is an error message!

		LoadedCode.JestRoblox._Index.React.React.createElement:123
		LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circusModule:789
	]=]

	expect(pruneDeps(message)).toEqual([=[
		This is an error message!

		LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circusModule:789
	]=])
end)
