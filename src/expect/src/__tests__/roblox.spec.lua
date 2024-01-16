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

local LuauPolyfill = require(Packages.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local Error = LuauPolyfill.Error

local Promise = require(Packages.Promise)

local RobloxShared = require(Packages.RobloxShared)
local pruneDeps = RobloxShared.pruneDeps

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
		expect(pruneDeps(assertionsErrors[1].error.stack)).toMatchSnapshot()
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
		expect(pruneDeps(assertionsErrors[1].error.stack)).toMatchSnapshot()
	end)
end)

describe("rejects", function()
	it("passes when rejects in setTimeout", function()
		expect(Promise.resolve():andThen(function()
				return Promise.new(function(resolve, reject)
					setTimeout(function()
						reject(Error.new("kaboom"))
					end, 100)
				end)
			end)).rejects
			.toThrow(Error.new("kaboom"))
			:expect()
	end)

	it("passes when errors in delayed Promise", function()
		expect(Promise.resolve():andThen(function()
				error(Error.new("kaboom"))
				return Promise.delay(0.1):andThen(function()
					error(Error.new("kaboom"))
				end)
			end)).rejects
			.toThrow(Error.new("kaboom"))
			:expect()
	end)

	it("passes when rejects immediately", function()
		expect(Promise.reject(Error.new("kaboom"))).rejects.toThrow():expect()
	end)

	it("passes when returns rejected in delayed Promise", function()
		expect(Promise.delay(0.1):andThen(function()
				return Promise.reject(Error.new("kaboom"))
			end)).rejects
			.toThrow(Error.new("kaboom"))
			:expect()
	end)
end)
