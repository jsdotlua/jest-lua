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
--!strict
-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
type Object = LuauPolyfill.Object

local exports = require("..")
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jest = JestGlobals.jest
local expect = JestGlobals.expect
local it = JestGlobals.it
local describe = JestGlobals.describe
local beforeEach = JestGlobals.beforeEach

local globalMocker
beforeEach(function()
	globalMocker = exports.GlobalMocker.new()
end)

it("MOCKABLE_GLOBALS has correct structure", function()
	expect(exports.MOCKABLE_GLOBALS).toEqual(expect.any("table"))
	local function checkStructureOf(partOfTable: Object)
		for name, value in partOfTable do
			expect(name).toEqual(expect.any("string"))
			if typeof(value) == "table" then
				-- Empty table here allow users to index this library in
				-- `globalEnv`, but don't let them do anything else. To ensure
				-- errors are raised from use of *libraries* with no mocks,
				-- rather than attempts to mock specific *functions*, disallow
				-- empty tables from being present in this structure.
				expect((next(value))).never.toBeNil()
				checkStructureOf(value)
			else
				expect(value).toEqual(expect.any("function"))
			end
		end
	end
	checkStructureOf(exports.MOCKABLE_GLOBALS)
end)

it("globalEnv is provided in the environment", function()
	expect(jest.globalEnv).toEqual(expect.any("table"))
	expect(globalMocker:isMockGlobalLibrary(jest.globalEnv)).toBe(true)
end)

-- To show a full list of which MOCKABLE_GLOBALS aren't yet covered by
-- globalEnv, this test is structured as a set of dynamically generated it()
-- blocks. Each it() block is responsible for checking the existence of one
-- of the globalEnv members. The effect of this is to make clear in the unit
-- test output when certain mocks aren't present, labelled clearly with
-- their qualified name and expected type, even if multiple things are
-- missing at once.
describe("globalEnv implements all MOCKABLE_GLOBALS", function()
	local function test(mockableGlobals: Object, globalPath: { string })
		for name, mockableGlobal in mockableGlobals do
			local nestedPath = table.clone(globalPath)
			table.insert(nestedPath, name)
			local qualifiedName = table.concat(nestedPath, ".")

			if typeof(mockableGlobal) == "function" then
				it(`unmocked function: {qualifiedName}`, function()
					local target = jest.globalEnv :: Object
					for _, pathPart in nestedPath do
						target = target[pathPart]
					end
					expect(target).toEqual(expect.any("function"))
				end)
			elseif typeof(mockableGlobal) == "table" then
				it(`mockable library: {qualifiedName}`, function()
					local target = jest.globalEnv :: Object
					for _, pathPart in nestedPath do
						target = target[pathPart]
					end
					expect(globalMocker:isMockGlobalLibrary(target)).toBe(true)
				end)
				test(mockableGlobal, nestedPath)
			end
		end
	end
	test(exports.MOCKABLE_GLOBALS, {})
end)

it("globalEnv errors when indexing non-mocked globals", function()
	expect(function()
		local _ = (jest.globalEnv :: any).notreal
	end).toThrow("Jest does not yet support mocking the notreal global")
	expect(function()
		local _ = (jest.globalEnv :: any).math.notreal
	end).toThrow("Jest does not yet support mocking the math.notreal global")
end)
