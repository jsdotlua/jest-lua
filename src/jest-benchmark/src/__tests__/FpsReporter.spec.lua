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

local capturedConnectFn
local initializeFpsReporter

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
	local FpsReporterModule = require(script.Parent.Parent.reporters.FpsReporter)
	initializeFpsReporter = FpsReporterModule.initializeFpsReporter
end)

it("should error when trying to call report", function()
	local Reporter = initializeFpsReporter()

	Reporter.start("1")
	expect(function()
		Reporter.report(1)
	end).toThrow("Attempted to call FPSReporter.report. This reporter handles reporting internally.")
end)

it("should report a single value", function()
	local Reporter = initializeFpsReporter()

	Reporter.start("1")
	-- 30 FPS
	capturedConnectFn(0.032)
	capturedConnectFn(0.034)
	capturedConnectFn(0.034)
	Reporter.stop()

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "FPS_1" })
	expect(sectionValues[1]).toBeCloseTo(30)
end)

it("should report multiple values", function()
	local Reporter = initializeFpsReporter()

	Reporter.start("1")
	-- 60 FPS
	capturedConnectFn(0.016)
	capturedConnectFn(0.017)
	capturedConnectFn(0.017)
	Reporter.stop()

	Reporter.start("2")
	-- 60 FPS
	capturedConnectFn(0.016)
	capturedConnectFn(0.017)
	capturedConnectFn(0.017)
	Reporter.stop()

	Reporter.start("3")
	-- 30 FPS
	capturedConnectFn(0.032)
	capturedConnectFn(0.034)
	capturedConnectFn(0.034)
	Reporter.stop()

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "FPS_1", "FPS_2", "FPS_3" })
	expect(sectionValues[1]).toBeCloseTo(60)
	expect(sectionValues[2]).toBeCloseTo(60)
	expect(sectionValues[3]).toBeCloseTo(30)
end)

it("should allow nested reporting", function()
	local Reporter = initializeFpsReporter()

	Reporter.start("total")
	-- 40 FPS total

	Reporter.start("1")
	-- 60 FPS
	capturedConnectFn(0.016)
	capturedConnectFn(0.017)
	capturedConnectFn(0.017)
	Reporter.stop()

	Reporter.start("2")
	-- 30 FPS
	capturedConnectFn(0.032)
	capturedConnectFn(0.034)
	capturedConnectFn(0.034)
	Reporter.stop()
	Reporter.stop()

	local sectionNames, sectionValues = Reporter.finish()
	expect(sectionNames).toEqual({ "FPS_1", "FPS_2", "FPS_total" })
	expect(sectionValues[1]).toBeCloseTo(60)
	expect(sectionValues[2]).toBeCloseTo(30)
	expect(sectionValues[3]).toBeCloseTo(40)
end)
