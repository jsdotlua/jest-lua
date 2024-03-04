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

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local it = JestGlobals.it
local expect = JestGlobals.expect

local reporterModule = require("../reporters/Reporter")
local initializeReporter = reporterModule.initializeReporter
local utils = require("./utils")
local average = utils.average

it("should report a single value", function()
	local Reporter = initializeReporter("average", average)

	Reporter.start("1")
	for i = 1, 6 do
		Reporter.report(i)
	end
	Reporter.stop()

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "average_1" })
	expect(sectionValues).toEqual({ 3.5 })
end)

it("should report multiple values", function()
	local Reporter = initializeReporter("average", average)

	Reporter.start("1")
	for i = 1, 6 do
		Reporter.report(i)
	end
	Reporter.stop()

	Reporter.start("2")
	for i = 7, 12 do
		Reporter.report(i)
	end
	Reporter.stop()

	Reporter.start("3")
	for i = 13, 18 do
		Reporter.report(i)
	end
	Reporter.stop()

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "average_1", "average_2", "average_3" })
	expect(sectionValues).toEqual({ 3.5, 9.5, 15.5 })
end)

it("should allow nested reporting", function()
	local Reporter = initializeReporter("average", average)

	Reporter.start("total")
	Reporter.start("1")
	for i = 1, 6 do
		Reporter.report(i)
	end
	Reporter.stop()

	Reporter.start("2")
	for i = 7, 12 do
		Reporter.report(i)
	end
	Reporter.stop()
	Reporter.stop()

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "average_1", "average_2", "average_total" })
	expect(sectionValues).toEqual({ 3.5, 9.5, 6.5 })
end)

it("should error when reporting values before calling Reporter.start()", function()
	local Reporter = initializeReporter("average", average)
	expect(function()
		Reporter.report(1)
	end).toThrow("Began reporting values before calling Reporter.start")
end)

it("should error when calling stop without first calling start", function()
	local Reporter = initializeReporter("average", average)

	expect(function()
		Reporter.stop()
	end).toThrow("Reporter.stop() called without a corresponding Reporter.start()")
end)

it("should error when calling stop more times than start", function()
	local Reporter = initializeReporter("average", average)
	Reporter.start("1")
	Reporter.report(1)
	Reporter.stop()

	expect(function()
		Reporter.stop()
	end).toThrow("Reporter.stop() called without a corresponding Reporter.start()")
end)

it("should handle no values being reported", function()
	local Reporter = initializeReporter("average", average)
	Reporter.start("1")
	Reporter.stop()
	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "average_1" })
	expect(sectionValues).toEqual({ 0 })
end)

it("should allow sections with no values reported", function()
	local Reporter = initializeReporter("average", average)
	Reporter.start("1")
	Reporter.report(1)
	Reporter.stop()
	Reporter.start("2")
	Reporter.stop()
	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "average_1", "average_2" })
	expect(sectionValues).toEqual({ 1, 0 })
end)

it("should allow nested sections with no values reported", function()
	local Reporter = initializeReporter("average", average)
	Reporter.start("total")
	Reporter.start("1")
	Reporter.stop()

	Reporter.start("2")
	for i = 1, 6 do
		Reporter.report(i)
	end
	Reporter.stop()
	Reporter.stop()

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "average_1", "average_2", "average_total" })
	expect(sectionValues).toEqual({ 0, 3.5, 3.5 })
end)

it("should error when calling finish before terminating all sections", function()
	local Reporter = initializeReporter("average", average)
	Reporter.start("1")

	expect(function()
		Reporter.finish()
	end).toThrow("Reporting finished without closing all Reporter.start() sections with a Reporter.stop() call")
end)
