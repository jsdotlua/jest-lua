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

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll
local afterAll = JestGlobals.afterAll

local JestConfig = require("@pkg/@jsdotlua/jest-config")

local JestRuntime = require("../init")
-- ROBLOX TODO: using RuntimePrivate type until better approach is found
type JestRuntime = JestRuntime.Runtime
type Jest = JestRuntime.Jest

local _runtime: JestRuntime?

local function getRuntime(): JestRuntime
	assert(_runtime)
	return _runtime
end

local requireOverride = function(scriptInstance: ModuleScript)
	return getRuntime():requireModuleOrMock(scriptInstance)
end

beforeAll(function()
	_runtime = JestRuntime.new(JestConfig.projectDefaults)
end)

afterAll(function()
	getRuntime():teardown()
	_runtime = nil
end)

describe("JestRuntime", function()
	it("requireModuleOrMock loads a module and caches it", function()
		local testFile1 = requireOverride(script.Parent.runtimeTestFile)
		local testFile2 = requireOverride(script.Parent.runtimeTestFile)
		expect(testFile1).toBe(testFile2)
	end)

	it("isolateModules returns a new module instance", function()
		local testFile1 = requireOverride(script.Parent.runtimeTestFile)
		local testFile2
		getRuntime():isolateModules(function()
			testFile2 = requireOverride(script.Parent.runtimeTestFile)
		end)
		local LuauPolyfill3 = requireOverride(script.Parent.runtimeTestFile)
		expect(testFile1).never.toBe(testFile2)
		expect(testFile1).toBe(LuauPolyfill3)
		expect(testFile2).never.toBe(LuauPolyfill3)
	end)

	it("separate isolateModules calls return different module instances", function()
		local testFile1
		local testFile2
		getRuntime():isolateModules(function()
			testFile1 = requireOverride(script.Parent.runtimeTestFile)
		end)
		getRuntime():isolateModules(function()
			testFile2 = requireOverride(script.Parent.runtimeTestFile)
		end)
		expect(testFile1).never.toBe(testFile2)
	end)
end)
