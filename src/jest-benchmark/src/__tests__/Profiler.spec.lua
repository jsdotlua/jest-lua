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

local profilerModule = require(script.Parent.Parent.Profiler)
local initializeProfiler = profilerModule.initializeProfiler

local reporterModule = require(script.Parent.Parent.reporters.Reporter)
local initializeReporter = reporterModule.initializeReporter

local utils = require(script.Parent.utils)
local sum = utils.sum
local average = utils.average

it("should profile with a single section", function()
	local testPrint = jest.fn()
	local averageReporter = initializeReporter("average", average)
	local sumReporter = initializeReporter("sum", sum)
	local Profiler = initializeProfiler({ averageReporter, sumReporter }, testPrint)

	Profiler.start("1")

	for i = 1, 6 do
		sumReporter.report(i)
		averageReporter.report(i)
	end

	Profiler.stop()
	Profiler.finish()

	expect(testPrint).toHaveBeenCalledWith("average_1", 3.5)
	expect(testPrint).toHaveBeenCalledWith("sum_1", 21)
end)

it("should profile with multiple sections", function()
	local testPrint = jest.fn()
	local averageReporter = initializeReporter("average", average)
	local sumReporter = initializeReporter("sum", sum)
	local Profiler = initializeProfiler({ averageReporter, sumReporter }, testPrint)

	Profiler.start("1")

	for i = 1, 6 do
		sumReporter.report(i)
		averageReporter.report(i)
	end

	Profiler.stop()

	Profiler.start("2")

	for i = 7, 12 do
		sumReporter.report(i)
		averageReporter.report(i)
	end

	Profiler.stop()

	Profiler.start("3")

	for i = 13, 18 do
		sumReporter.report(i)
		averageReporter.report(i)
	end

	Profiler.stop()
	Profiler.finish()

	expect(testPrint).toHaveBeenCalledWith("average_1", 3.5)
	expect(testPrint).toHaveBeenCalledWith("average_2", 9.5)
	expect(testPrint).toHaveBeenCalledWith("average_3", 15.5)
	expect(testPrint).toHaveBeenCalledWith("sum_1", 21)
	expect(testPrint).toHaveBeenCalledWith("sum_2", 57)
	expect(testPrint).toHaveBeenCalledWith("sum_3", 93)
end)

it("should profile with nested sections", function()
	local testPrint = jest.fn()
	local averageReporter = initializeReporter("average", average)
	local sumReporter = initializeReporter("sum", sum)
	local Profiler = initializeProfiler({ averageReporter, sumReporter }, testPrint)

	Profiler.start("total")

	Profiler.start("1")
	for i = 1, 6 do
		sumReporter.report(i)
		averageReporter.report(i)
	end
	Profiler.stop()

	Profiler.start("2")

	for i = 7, 12 do
		sumReporter.report(i)
		averageReporter.report(i)
	end
	Profiler.stop()

	Profiler.stop()
	Profiler.finish()

	expect(testPrint).toHaveBeenCalledWith("average_1", 3.5)
	expect(testPrint).toHaveBeenCalledWith("average_2", 9.5)
	expect(testPrint).toHaveBeenCalledWith("average_total", 6.5)
	expect(testPrint).toHaveBeenCalledWith("sum_1", 21)
	expect(testPrint).toHaveBeenCalledWith("sum_2", 57)
	expect(testPrint).toHaveBeenCalledWith("sum_total", 78)
end)

it("should error when Profile.stop is called without calling Profile.start", function()
	local testPrint = jest.fn()
	local averageReporter = initializeReporter("average", average)
	local Profiler = initializeProfiler({ averageReporter }, testPrint)
	expect(function()
		Profiler.stop()
	end).toThrow("Profiler.stop() called without a corresponding Profiler.start()")
end)

it("should error when Profile.finish is called with open Profile sections calls", function()
	local testPrint = jest.fn()
	local averageReporter = initializeReporter("average", average)
	local Profiler = initializeProfiler({ averageReporter }, testPrint)
	Profiler.start("1")
	expect(function()
		Profiler.finish()
	end).toThrow("Profiling finished without closing all Profiler.start() sections with a Profiler.stop() call")
end)

it("should error if no reporters are passed to profiler", function()
	local testPrint = jest.fn()
	expect(function()
		initializeProfiler({}, testPrint)
	end).toThrow("Profiler must be initialized with at least one Reporter")
end)

it("should accept prefix argument", function()
	local testPrint = jest.fn()
	local averageReporter = initializeReporter("average", average)
	local sumReporter = initializeReporter("sum", sum)
	local Profiler = initializeProfiler({ averageReporter, sumReporter }, testPrint, "profiler")

	Profiler.start("1")

	for i = 1, 6 do
		sumReporter.report(i)
		averageReporter.report(i)
	end

	Profiler.stop()
	Profiler.finish()

	expect(testPrint).toHaveBeenCalledWith("profiler_average_1", 3.5)
	expect(testPrint).toHaveBeenCalledWith("profiler_sum_1", 21)
end)
