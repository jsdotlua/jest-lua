-- ROBLOX NOTE: no upstream
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
local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent
local JestGlobals = require(Packages.Dev.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

describe("assertions & hasAssertions", function()
	it("assertions", function()
		expect.assertions(3)

		expect(1).toBe(1)
		expect(1).toBe(1)
		expect(1).toBe(1)

		local assertionsErrors = expect.extractExpectedAssertionsErrors()

		expect(#assertionsErrors).toBe(0)
	end)

	it("assertions fails", function()
		expect.assertions(4)
		expect(1).toBe(1)
		expect(1).toBe(1)
		expect(1).toBe(1)

		local assertionsErrors = expect.extractExpectedAssertionsErrors()

		expect(#assertionsErrors).toBe(1)

		expect(assertionsErrors[1].error.message).toMatchSnapshot()
		expect(assertionsErrors[1].error.stack).toMatchSnapshot()
	end)

	it("hasAssertions works", function()
		expect.hasAssertions()
		expect(1).toBe(1)
		expect(1).toBe(1)
		expect(1).toBe(1)

		local assertionsErrors = expect.extractExpectedAssertionsErrors()

		expect(#assertionsErrors).toBe(0)
	end)

	it("hasAssertions fails", function()
		expect.hasAssertions()

		local assertionsErrors = expect.extractExpectedAssertionsErrors()

		expect(#assertionsErrors).toBe(1)

		expect(assertionsErrors[1].error.message).toMatchSnapshot()
		expect(assertionsErrors[1].error.stack).toMatchSnapshot()
	end)
end)

return {}
