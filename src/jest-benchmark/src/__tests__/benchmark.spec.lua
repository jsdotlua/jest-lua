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
local beforeEach = JestGlobals.beforeEach
local afterEach = JestGlobals.afterEach
local jest = JestGlobals.jest
local sum = require(script.Parent.utils).sum
local benchmark
local capturedConnectFn

local initializeReporter
local CustomReporters
local MetricLogger
local testPrint

beforeEach(function()
	jest.resetModules()
	jest.mock(script.Parent.Parent.testModule :: any, function()
		return function(_testName: string, testFn, _timeout)
			testFn()
		end
	end)
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
	benchmark = require(script.Parent.Parent.benchmark).benchmark
	jest.useFakeTimers()

	initializeReporter = require(script.Parent.Parent.reporters.Reporter).initializeReporter

	--[[
		In regular use, you should not need to re-require these after resetModules().
		In this test, we need to re-require benchmark to mock test, which resets the module state
		for CustomReporters and MetricLogger
	]]
	CustomReporters = require(script.Parent.Parent.CustomReporters)
	MetricLogger = require(script.Parent.Parent.MetricLogger)

	CustomReporters.useCustomReporters({ sum = initializeReporter("sum", sum) })
	testPrint = jest.fn()
	MetricLogger.useCustomMetricLogger(testPrint)
end)

afterEach(function()
	jest.useRealTimers()
	CustomReporters.useDefaultReporters()
	MetricLogger.useDefaultMetricLogger()
end)

it("should run a benchmark", function()
	benchmark("test", function(Profiler, reporters)
		Profiler.start("1")
		for i = 1, 6 do
			reporters.sum.report(i)
		end
		capturedConnectFn(20)
		jest.advanceTimersByTime(1000)
		Profiler.stop()

		Profiler.start("2")
		for i = 7, 12 do
			reporters.sum.report(i)
		end
		capturedConnectFn(40)
		jest.advanceTimersByTime(1000)
		Profiler.stop()
	end)

	expect(testPrint).toHaveBeenCalledWith("test_sum_1", 21)
	expect(testPrint).toHaveBeenCalledWith("test_sum_2", 57)
	expect(testPrint).toHaveBeenCalledWith("test_sum_total", 78)

	expect(testPrint).toHaveBeenCalledWith("test_FPS_1", 1 / 20)
	expect(testPrint).toHaveBeenCalledWith("test_FPS_2", 1 / 40)
	expect(testPrint).toHaveBeenCalledWith("test_FPS_total", 1 / 30)

	expect(testPrint).toHaveBeenCalledWith("test_SectionTime_1", 1)
	expect(testPrint).toHaveBeenCalledWith("test_SectionTime_2", 1)
	expect(testPrint).toHaveBeenCalledWith("test_SectionTime_total", 2)
end)
