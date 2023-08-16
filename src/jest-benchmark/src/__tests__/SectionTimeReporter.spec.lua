--!strict
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

local Packages = script:FindFirstAncestor("JestBenchmark").Parent
local JestGlobals = require(Packages.JestGlobals)
local it = JestGlobals.it
local expect = JestGlobals.expect
local jest = JestGlobals.jest
local beforeEach = JestGlobals.beforeEach
local afterEach = JestGlobals.afterEach

local sectionTimeReporterModule = require(script.Parent.Parent.reporters.SectionTimeReporter)
local initializeSectionTimeReporter = sectionTimeReporterModule.initializeSectionTimeReporter

beforeEach(function()
	jest.useFakeTimers()
end)

afterEach(function()
	jest.useRealTimers()
end)

it("should error when trying to call report", function()
	local Reporter = initializeSectionTimeReporter()

	Reporter.start("1")
	expect(function()
		Reporter.report(1)
	end).toThrow("Attempted to call SectionTimeReporter.report. This reporter handles reporting internally.")

	jest.advanceTimersByTime(1000)
	Reporter.stop()

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "SectionTime_1" })
	expect(sectionValues).toEqual({ 1 })
end)

it("should report a single value", function()
	local Reporter = initializeSectionTimeReporter()

	Reporter.start("1")
	jest.advanceTimersByTime(1000)
	Reporter.stop()

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "SectionTime_1" })
	expect(sectionValues).toEqual({ 1 })
end)

it("should report multiple values", function()
	local Reporter = initializeSectionTimeReporter()

	Reporter.start("1")
	jest.advanceTimersByTime(1000)
	Reporter.stop()

	Reporter.start("2")
	jest.advanceTimersByTime(1000)
	Reporter.stop()

	Reporter.start("3")
	jest.advanceTimersByTime(1000)
	Reporter.stop()

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "SectionTime_1", "SectionTime_2", "SectionTime_3" })
	expect(sectionValues).toEqual({ 1, 1, 1 })
end)

it("should allow nested reporting", function()
	local Reporter = initializeSectionTimeReporter()

	Reporter.start("total")
	Reporter.start("1")
	jest.advanceTimersByTime(1000)
	Reporter.stop()

	Reporter.start("2")
	jest.advanceTimersByTime(1000)
	Reporter.stop()
	Reporter.stop()

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "SectionTime_1", "SectionTime_2", "SectionTime_total" })
	expect(sectionValues).toEqual({ 1, 1, 2 })
end)
