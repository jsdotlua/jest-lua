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

local utils = require(script.Parent.utils)
local average = utils.average

local capturedConnectFn
local initializeHeartbeatReporter

beforeEach(function()
	jest.resetModules()

	jest.mock(script.Parent.Parent.heartbeatModule :: any, function()
		return {
			Connect = function(_self, connectFn)
				capturedConnectFn = connectFn
				return {
					Disconnect = function(_self) end,
				}
			end,
		}
	end)
	local HeartbeatReporterModule = require(script.Parent.Parent.reporters.HeartbeatReporter)
	initializeHeartbeatReporter = HeartbeatReporterModule.initializeHeartbeatReporter
end)

it("should error when trying to call report", function()
	local Reporter = initializeHeartbeatReporter("average", average)

	Reporter.start("1")
	expect(function()
		Reporter.report(1)
	end).toThrow("Attempted to call averageReporter.report. This reporter handles reporting internally.")
end)

it("should report a single value", function()
	local Reporter = initializeHeartbeatReporter("average", average)

	Reporter.start("1")
	capturedConnectFn(0.01)
	capturedConnectFn(0.02)
	capturedConnectFn(0.03)
	Reporter.stop()

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "average_1" })
	expect(sectionValues[1]).toBeCloseTo(0.02)
end)

it("should report multiple values", function()
	local Reporter = initializeHeartbeatReporter("average", average)

	Reporter.start("1")
	capturedConnectFn(0.01)
	capturedConnectFn(0.02)
	capturedConnectFn(0.03)
	Reporter.stop()

	Reporter.start("2")
	capturedConnectFn(0.04)
	capturedConnectFn(0.05)
	capturedConnectFn(0.06)
	Reporter.stop()

	Reporter.start("3")
	capturedConnectFn(0.07)
	capturedConnectFn(0.08)
	capturedConnectFn(0.09)
	Reporter.stop()

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "average_1", "average_2", "average_3" })
	expect(sectionValues[1]).toBeCloseTo(0.02)
	expect(sectionValues[2]).toBeCloseTo(0.05)
	expect(sectionValues[3]).toBeCloseTo(0.08)
end)

it("should allow nested reporting", function()
	local Reporter = initializeHeartbeatReporter("average", average)

	Reporter.start("total")
	Reporter.start("1")
	capturedConnectFn(0.01)
	capturedConnectFn(0.02)
	capturedConnectFn(0.03)
	Reporter.stop()

	Reporter.start("2")
	capturedConnectFn(0.04)
	capturedConnectFn(0.05)
	capturedConnectFn(0.06)
	Reporter.stop()
	Reporter.stop()

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "average_1", "average_2", "average_total" })
	expect(sectionValues[1]).toBeCloseTo(0.02)
	expect(sectionValues[2]).toBeCloseTo(0.05)
	expect(sectionValues[3]).toBeCloseTo(0.035)
end)

it("should not report heartbeats that occur outside of a reporting section", function()
	local Reporter = initializeHeartbeatReporter("average", average)

	Reporter.start("1")
	capturedConnectFn(0.02)
	Reporter.stop()

	-- Should not be reported
	capturedConnectFn(0.04)

	Reporter.start("2")
	capturedConnectFn(0.06)
	Reporter.stop()

	-- Should not be reported
	capturedConnectFn(0.04)

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "average_1", "average_2" })
	expect(sectionValues[1]).toBeCloseTo(0.02)
	expect(sectionValues[2]).toBeCloseTo(0.06)
end)

it("should allow sections without a heartbeat reported", function()
	local Reporter = initializeHeartbeatReporter("average", average)

	Reporter.start("1")
	Reporter.stop()

	Reporter.start("2")
	capturedConnectFn(0.06)
	Reporter.stop()

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "average_1", "average_2" })
	expect(sectionValues[1]).toBeCloseTo(0)
	expect(sectionValues[2]).toBeCloseTo(0.06)
end)
