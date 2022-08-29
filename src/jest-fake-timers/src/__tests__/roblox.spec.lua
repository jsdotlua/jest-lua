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

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local afterEach = JestGlobals.afterEach

local FakeTimers = require(CurrentModule)
local timers = FakeTimers.new()

afterEach(function()
	timers:useRealTimers()
end)

describe("FakeTimers", function()
	describe("construction", function()
		it("installs delay mock", function()
			jestExpect(timers.delayOverride).never.toBeNil()
		end)

		it("installs tick mock", function()
			jestExpect(timers.tickOverride).never.toBeNil()
		end)
	end)

	describe("runAllTimers", function()
		it("runs all timers in order", function()
			timers:useFakeTimers()

			local runOrder = {}
			local mock1 = jest.fn(function()
				table.insert(runOrder, "mock1")
			end)
			local mock2 = jest.fn(function()
				table.insert(runOrder, "mock2")
			end)
			local mock3 = jest.fn(function()
				table.insert(runOrder, "mock3")
			end)
			local mock4 = jest.fn(function()
				table.insert(runOrder, "mock4")
			end)
			local mock5 = jest.fn(function()
				table.insert(runOrder, "mock5")
			end)
			local mock6 = jest.fn(function()
				table.insert(runOrder, "mock6")
			end)

			timers.delayOverride(100, mock1)
			timers.delayOverride(0, mock2)
			timers.delayOverride(0, mock3)
			timers.delayOverride(200, mock4)
			timers.delayOverride(3, mock5)
			timers.delayOverride(4, mock6)
			timers:runAllTimers()
			jestExpect(timers.osOverride.clock()).toEqual(200)
			jestExpect(runOrder).toEqual({
				"mock2",
				"mock3",
				"mock5",
				"mock6",
				"mock1",
				"mock4",
			})
		end)

		it("warns when trying to advance timers while real timers are used", function()
			jestExpect(function()
				timers:runAllTimers()
			end).toThrow(
				"A function to advance timers was called but the timers API is not "
					.. "mocked with fake timers. Call `jest.useFakeTimers()` in this test."
			)
		end)

		it("does nothing when no timers have been scheduled", function()
			timers:useFakeTimers()

			jestExpect(timers.osOverride.clock()).toEqual(0)
			timers:runAllTimers()
		end)

		it("only runs a delay callback once (ever)", function()
			timers:useFakeTimers()

			local fn = jest.fn()
			timers.delayOverride(0, fn)
			jestExpect(fn).toHaveBeenCalledTimes(0)

			timers:runAllTimers()
			jestExpect(fn).toHaveBeenCalledTimes(1)

			timers:runAllTimers()
			jestExpect(fn).toHaveBeenCalledTimes(1)
		end)

		it("runs callbacks with arguments after the interval", function()
			timers:useFakeTimers()

			local fn = jest.fn()
			timers.delayOverride(0, function()
				fn("mockArg1", "mockArg2")
			end)

			timers:runAllTimers()
			jestExpect(fn).toHaveBeenCalledTimes(1)
			jestExpect(fn).toHaveBeenCalledWith("mockArg1", "mockArg2")
		end)
	end)

	describe("advanceTimersByTime", function()
		it("runs timers in order", function()
			timers:useFakeTimers()

			local runOrder = {}
			local mock1 = jest.fn(function()
				table.insert(runOrder, "mock1")
			end)
			local mock2 = jest.fn(function()
				table.insert(runOrder, "mock2")
			end)
			local mock3 = jest.fn(function()
				table.insert(runOrder, "mock3")
			end)
			local mock4 = jest.fn(function()
				table.insert(runOrder, "mock4")
			end)

			timers.delayOverride(100, mock1)
			timers.delayOverride(0, mock2)
			timers.delayOverride(0, mock3)
			timers.delayOverride(200, mock4)

			-- Move forward to t=50
			timers:advanceTimersByTime(50)
			jestExpect(timers.osOverride.clock()).toEqual(50)
			jestExpect(runOrder).toEqual({ "mock2", "mock3" })

			-- Move forward to t=60
			timers:advanceTimersByTime(10)
			jestExpect(timers.osOverride.clock()).toEqual(60)
			jestExpect(runOrder).toEqual({ "mock2", "mock3" })

			-- Move forward to t=100
			timers:advanceTimersByTime(40)
			jestExpect(timers.osOverride.clock()).toEqual(100)
			jestExpect(runOrder).toEqual({ "mock2", "mock3", "mock1" })

			-- Move forward to t=200
			timers:advanceTimersByTime(100)
			jestExpect(timers.osOverride.clock()).toEqual(200)
			jestExpect(runOrder).toEqual({ "mock2", "mock3", "mock1", "mock4" })
		end)

		it("does nothing when no timers have been scheduled", function()
			timers:useFakeTimers()
			timers:advanceTimersByTime(100)
		end)
	end)

	describe("advanceTimersToNextTimer", function()
		it("runs timers in order", function()
			timers:useFakeTimers()

			local runOrder = {}
			local mock1 = jest.fn(function()
				table.insert(runOrder, "mock1")
			end)
			local mock2 = jest.fn(function()
				table.insert(runOrder, "mock2")
			end)
			local mock3 = jest.fn(function()
				table.insert(runOrder, "mock3")
			end)
			local mock4 = jest.fn(function()
				table.insert(runOrder, "mock4")
			end)

			timers.delayOverride(100, mock1)
			timers.delayOverride(0, mock2)
			timers.delayOverride(0, mock3)
			timers.delayOverride(200, mock4)

			timers:advanceTimersToNextTimer()
			-- Move forward to t=0
			jestExpect(timers.osOverride.clock()).toEqual(0)
			jestExpect(runOrder).toEqual({ "mock2", "mock3" })

			timers:advanceTimersToNextTimer()
			-- Move forward to t=100
			jestExpect(timers.osOverride.clock()).toEqual(100)
			jestExpect(runOrder).toEqual({ "mock2", "mock3", "mock1" })

			timers:advanceTimersToNextTimer()
			-- Move forward to t=200
			jestExpect(timers.osOverride.clock()).toEqual(200)
			jestExpect(runOrder).toEqual({ "mock2", "mock3", "mock1", "mock4" })
		end)

		it("run correct amount of steps", function()
			timers:useFakeTimers()

			local runOrder = {}
			local mock1 = jest.fn(function()
				table.insert(runOrder, "mock1")
			end)
			local mock2 = jest.fn(function()
				table.insert(runOrder, "mock2")
			end)
			local mock3 = jest.fn(function()
				table.insert(runOrder, "mock3")
			end)
			local mock4 = jest.fn(function()
				table.insert(runOrder, "mock4")
			end)

			timers.delayOverride(100, mock1)
			timers.delayOverride(0, mock2)
			timers.delayOverride(0, mock3)
			timers.delayOverride(200, mock4)
			timers.delayOverride(400, mock4)
			timers.delayOverride(600, mock4)

			-- Move forward to t=100
			timers:advanceTimersToNextTimer(2)
			jestExpect(timers.osOverride.clock()).toEqual(100)
			jestExpect(runOrder).toEqual({ "mock2", "mock3", "mock1" })

			-- Move forward to t=600
			timers:advanceTimersToNextTimer(3)
			jestExpect(timers.osOverride.clock()).toEqual(600)
			jestExpect(runOrder).toEqual({
				"mock2",
				"mock3",
				"mock1",
				"mock4",
				"mock4",
				"mock4",
			})
		end)

		it("setTimeout inside setTimeout", function()
			timers:useFakeTimers()

			local runOrder = {}
			local mock1 = jest.fn(function()
				table.insert(runOrder, "mock1")
			end)
			local mock2 = jest.fn(function()
				table.insert(runOrder, "mock2")
			end)
			local mock3 = jest.fn(function()
				table.insert(runOrder, "mock3")
			end)
			local mock4 = jest.fn(function()
				table.insert(runOrder, "mock4")
			end)

			timers.delayOverride(0, mock1)
			timers.delayOverride(25, function()
				mock2()
				timers.delayOverride(50, mock3)
			end)
			timers.delayOverride(100, mock4)

			-- Move forward to t=75
			timers:advanceTimersToNextTimer(3)
			jestExpect(timers.osOverride.clock()).toEqual(75)
			jestExpect(runOrder).toEqual({ "mock1", "mock2", "mock3" })
		end)

		it("does nothing when no timers have been scheduled", function()
			timers:useFakeTimers()
			timers:advanceTimersToNextTimer()
		end)
	end)

	describe("reset", function()
		it("resets all pending timers", function()
			timers:useFakeTimers()

			local mock1 = jest.fn()
			timers.delayOverride(0, mock1)

			timers:reset()
			timers:runAllTimers()
			jestExpect(mock1).toHaveBeenCalledTimes(0)
		end)

		it("resets current advanceTimersByTime time cursor", function()
			timers:useFakeTimers()

			local mock1 = jest.fn()
			timers.delayOverride(100, mock1)
			timers:advanceTimersByTime(50)
			jestExpect(timers.osOverride.clock()).toEqual(50)

			timers:reset()
			jestExpect(timers.osOverride.clock()).toEqual(0)
			timers.delayOverride(100, mock1)

			timers:advanceTimersByTime(50)
			jestExpect(timers.osOverride.clock()).toEqual(50)
			jestExpect(mock1).toHaveBeenCalledTimes(0)
		end)
	end)

	describe("runOnlyPendingTimers", function()
		it("runs all timers in order", function()
			timers:useFakeTimers()

			local runOrder = {}
			local mock1 = jest.fn(function()
				table.insert(runOrder, "mock1")
			end)
			local mock2 = jest.fn(function()
				table.insert(runOrder, "mock2")
			end)
			local mock3 = jest.fn(function()
				table.insert(runOrder, "mock3")
			end)
			local mock4 = jest.fn(function()
				table.insert(runOrder, "mock4")
			end)
			local mock5 = jest.fn(function()
				table.insert(runOrder, "mock5")
			end)
			local mock6 = jest.fn(function()
				table.insert(runOrder, "mock6")
			end)

			timers.delayOverride(100, mock1)
			timers.delayOverride(0, mock2)
			timers.delayOverride(0, mock3)
			timers.delayOverride(200, mock4)
			timers.delayOverride(3, mock5)
			timers.delayOverride(4, mock6)
			timers:runOnlyPendingTimers()
			jestExpect(timers.osOverride.clock()).toEqual(200)
			jestExpect(runOrder).toEqual({
				"mock2",
				"mock3",
				"mock5",
				"mock6",
				"mock1",
				"mock4",
			})
		end)
	end)

	describe("useRealTimers, useFakeTimers", function()
		it("resets native timer APIs", function()
			local nativeDelay = timers.delayOverride.getMockImplementation()
			local nativeTick = timers.tickOverride.getMockImplementation()

			timers:useFakeTimers()
			local fakeDelay = timers.delayOverride.getMockImplementation()
			local fakeTick = timers.tickOverride.getMockImplementation()
			jestExpect(fakeDelay).never.toBe(nativeDelay)
			jestExpect(fakeTick).never.toBe(nativeTick)

			timers:useRealTimers()
			local realDelay = timers.delayOverride.getMockImplementation()
			local realTick = timers.tickOverride.getMockImplementation()
			jestExpect(realDelay).toBe(nativeDelay)
			jestExpect(realTick).toBe(nativeTick)
		end)
	end)

	describe("getTimerCount", function()
		it("returns the correct count", function()
			timers:useFakeTimers()

			timers.delayOverride(0, function() end)
			timers.delayOverride(0, function() end)
			timers.delayOverride(10, function() end)

			jestExpect(timers:getTimerCount()).toEqual(3)

			timers:advanceTimersByTime(5)

			jestExpect(timers:getTimerCount()).toEqual(1)

			timers:advanceTimersByTime(5)

			jestExpect(timers:getTimerCount()).toEqual(0)
		end)
	end)
end)

describe("DateTime", function()
	describe("construction", function()
		it("installs DateTime mock", function()
			jestExpect(timers.dateTimeOverride).never.toBeNil()
			jestExpect(timers.dateTimeOverride.now()).never.toBeNil()
		end)

		it("DateTime constructors pass through", function()
			timers:useFakeTimers()

			jestExpect(timers.dateTimeOverride.now()).never.toBeNil()
			jestExpect(timers.dateTimeOverride.fromUnixTimestamp()).never.toBeNil()
			jestExpect(timers.dateTimeOverride.fromUnixTimestampMillis()).never.toBeNil()
			jestExpect(timers.dateTimeOverride.fromUniversalTime()).never.toBeNil()
			jestExpect(timers.dateTimeOverride.fromLocalTime()).never.toBeNil()
			jestExpect(timers.dateTimeOverride.fromIsoDate("2020-01-02T10:30:45Z")).never.toBeNil()
		end)
	end)

	it("affected by timers", function()
		timers:useFakeTimers()

		local time_ = timers.dateTimeOverride.now().UnixTimestamp
		timers:advanceTimersByTime(100)
		jestExpect(timers.dateTimeOverride.now().UnixTimestamp).toEqual(time_ + 100)
	end)

	describe("setSystemTime", function()
		it("UnixTimestamp", function()
			timers:useFakeTimers()

			timers:setSystemTime(0)
			jestExpect(timers.dateTimeOverride.now()).toEqual(timers.dateTimeOverride.fromUnixTimestamp(0))
		end)

		it("DateTime object", function()
			timers:useFakeTimers()

			timers:setSystemTime(timers.dateTimeOverride.fromUniversalTime(1971))
			jestExpect(timers.dateTimeOverride.now()).toEqual(timers.dateTimeOverride.fromUniversalTime(1971))
		end)
	end)

	describe("getRealSystemTime", function()
		it("returns real system time", function()
			timers:useFakeTimers()

			timers:setSystemTime(0)
			jestExpect(timers.dateTimeOverride.now()).never.toEqual(timers:getRealSystemTime())
		end)
	end)

	describe("useRealTimers, useFakeTimers", function()
		it("resets native timer APIs", function()
			local nativeDateTime = timers.dateTimeOverride.now.getMockImplementation()

			timers:useFakeTimers()
			local fakeDateTime = timers.dateTimeOverride.now.getMockImplementation()
			jestExpect(fakeDateTime).never.toBe(nativeDateTime)

			timers:useRealTimers()
			local realDateTime = timers.dateTimeOverride.now.getMockImplementation()
			jestExpect(realDateTime).toBe(nativeDateTime)
		end)
	end)

	describe("reset", function()
		it("resets system time", function()
			timers:useFakeTimers()

			timers:setSystemTime(0)
			local fakeTime = timers.dateTimeOverride.now()
			jestExpect(timers.dateTimeOverride.now()).toEqual(fakeTime)

			timers:reset()
			jestExpect(timers.dateTimeOverride.now()).never.toEqual(fakeTime)
		end)
	end)
end)

describe("os", function()
	describe("construction", function()
		it("installs os mock", function()
			jestExpect(os).never.toBeNil()
			jestExpect(timers.osOverride.time).never.toBeNil()
			jestExpect(timers.osOverride.clock).never.toBeNil()
		end)

		it("os methods pass through", function()
			timers:useFakeTimers()

			jestExpect(timers.osOverride.difftime(2, 1)).toBe(1)
			jestExpect(timers.osOverride.date).never.toBeNil()
		end)
	end)

	describe("timers.osOverride.time", function()
		it("returns correct value", function()
			timers:useFakeTimers()

			timers:setSystemTime(1586982482)
			jestExpect(timers.osOverride.time()).toBe(1586982482)
		end)

		it("returns correct value when passing in table", function()
			timers:useFakeTimers()

			timers:setSystemTime(100)
			jestExpect(timers.osOverride.time({
				year = 1970,
				month = 1,
				day = 1,
				hour = 0,
				min = 0,
				sec = 0,
			})).toBe(100)
		end)

		it("affected by timers", function()
			timers:useFakeTimers()

			local time_ = timers.osOverride.time()
			timers:advanceTimersByTime(100)
			jestExpect(timers.osOverride.time()).toBe(time_ + 100)
		end)
	end)

	describe("timers.osOverride.clock", function()
		it("affected by timers", function()
			timers:useFakeTimers()

			jestExpect(timers.osOverride.clock()).toBe(0)
			timers:advanceTimersByTime(100)
			jestExpect(timers.osOverride.clock()).toBe(100)
		end)
	end)

	describe("useRealTimers, useFakeTimers", function()
		it("resets native timer APIs", function()
			local nativeOsTime = timers.osOverride.time.getMockImplementation()
			local nativeOsClock = timers.osOverride.clock.getMockImplementation()

			timers:useFakeTimers()
			local fakeOsTime = timers.osOverride.time.getMockImplementation()
			local fakeOsClock = timers.osOverride.clock.getMockImplementation()
			jestExpect(fakeOsTime).never.toBe(nativeOsTime)
			jestExpect(fakeOsClock).never.toBe(nativeOsClock)

			timers:useRealTimers()
			local realOsTime = timers.osOverride.time.getMockImplementation()
			local realOsClock = timers.osOverride.clock.getMockImplementation()
			jestExpect(realOsTime).toBe(nativeOsTime)
			jestExpect(realOsClock).toBe(nativeOsClock)
		end)
	end)

	describe("reset", function()
		it("resets system time", function()
			timers:useFakeTimers()

			timers:setSystemTime(0)
			local fakeTime = timers.osOverride.time()
			jestExpect(timers.osOverride.time()).toEqual(fakeTime)

			timers:reset()
			jestExpect(timers.osOverride.time()).never.toEqual(fakeTime)
		end)
	end)
end)

describe("tick", function()
	it("returns UNIX time", function()
		timers:useFakeTimers()

		timers:setSystemTime(100)
		jestExpect(timers.tickOverride()).toBe(100)
	end)

	it("affected by timers", function()
		timers:useFakeTimers()

		timers:setSystemTime(0)
		timers:advanceTimersByTime(100)

		jestExpect(timers.tickOverride()).toBe(100)
	end)
end)

it("spies", function()
	timers:useFakeTimers()

	local mock1 = jest.fn()
	local mock2 = jest.fn()
	local mock3 = jest.fn()

	jestExpect(timers.delayOverride).never.toHaveBeenCalled()

	timers.delayOverride(0, mock1)
	timers.delayOverride(25, function()
		mock2()
		timers.delayOverride(50, mock3)
		timers.tickOverride()
		timers.dateTimeOverride.now()
	end)

	jestExpect(timers.delayOverride).toHaveBeenCalledTimes(2)
	jestExpect(timers.tickOverride).never.toHaveBeenCalled()
	jestExpect(timers.dateTimeOverride.now).never.toHaveBeenCalled()

	timers:runAllTimers()
	jestExpect(timers.delayOverride).toHaveBeenCalledTimes(3)
	jestExpect(timers.tickOverride).toHaveBeenCalledTimes(1)
	jestExpect(timers.delayOverride).toHaveBeenLastCalledWith(50, mock3)
	jestExpect(timers.dateTimeOverride.now).toHaveBeenCalledTimes(1)
end)

describe("recursive timer", function()
	it("runAllTimers", function()
		timers:useFakeTimers()

		local loop = 5

		local loopFn = function() end
		loopFn = function()
			if loop > 0 then
				loop = loop - 1
				timers.delayOverride(10, loopFn)
			end
		end

		timers.delayOverride(0, loopFn)
		jestExpect(timers.delayOverride).toHaveBeenCalledTimes(1)

		timers:runAllTimers()
		jestExpect(timers.delayOverride).toHaveBeenCalledTimes(6)
	end)

	it("runOnlyPendingTimers", function()
		timers:useFakeTimers()

		local loopFn = function() end
		loopFn = function()
			timers.delayOverride(10, loopFn)
		end

		local mockFn = jest.fn()

		timers.delayOverride(0, loopFn)
		timers.delayOverride(0, mockFn)
		timers.delayOverride(100, mockFn)
		jestExpect(timers.delayOverride).toHaveBeenCalledTimes(3)
		jestExpect(timers:getTimerCount()).toBe(3)
		jestExpect(mockFn).toHaveBeenCalledTimes(0)
		jestExpect(timers.osOverride.clock()).toBe(0)

		timers:runOnlyPendingTimers()
		jestExpect(timers.delayOverride).toHaveBeenCalledTimes(4)
		jestExpect(timers:getTimerCount()).toBe(1)
		jestExpect(mockFn).toHaveBeenCalledTimes(2)
		jestExpect(timers.osOverride.clock()).toBe(100)

		timers:runOnlyPendingTimers()
		jestExpect(timers.delayOverride).toHaveBeenCalledTimes(5)
		jestExpect(timers:getTimerCount()).toBe(1)
		jestExpect(mockFn).toHaveBeenCalledTimes(2)
		jestExpect(timers.osOverride.clock()).toBe(100)
	end)

	it("advanceTimersByTime", function()
		timers:useFakeTimers()

		local runOrder = {}
		local loopFn = function() end
		loopFn = function()
			table.insert(runOrder, timers.osOverride.clock())
			timers.delayOverride(10, loopFn)
		end

		timers.delayOverride(0, loopFn)
		timers.delayOverride(51, function()
			table.insert(runOrder, timers.osOverride.clock())
		end)
		jestExpect(timers.delayOverride).toHaveBeenCalledTimes(2)

		timers:advanceTimersByTime(1)
		jestExpect(runOrder).toEqual({ 0 })
		jestExpect(timers:getTimerCount()).toBe(2)

		timers:advanceTimersByTime(10)
		jestExpect(runOrder).toEqual({ 0, 10 })

		timers:advanceTimersByTime(20)
		jestExpect(runOrder).toEqual({ 0, 10, 20, 30 })
		jestExpect(timers.osOverride.clock()).toBe(31)

		timers:advanceTimersByTime(24)
		jestExpect(runOrder).toEqual({ 0, 10, 20, 30, 40, 50, 51 })
		jestExpect(timers.osOverride.clock()).toBe(55)
	end)

	it("advanceTimersToNextTimer", function()
		timers:useFakeTimers()

		local runOrder = {}
		local loopFn = function() end
		loopFn = function()
			table.insert(runOrder, timers.osOverride.clock())
			timers.delayOverride(10, loopFn)
		end

		timers.delayOverride(0, loopFn)
		timers.delayOverride(0, function()
			table.insert(runOrder, timers.osOverride.clock())
		end)

		timers:advanceTimersToNextTimer()
		jestExpect(runOrder).toEqual({ 0, 0 })

		timers:advanceTimersToNextTimer(2)
		jestExpect(runOrder).toEqual({ 0, 0, 10, 20 })
	end)
end)

describe("internal timer never goes backwards", function()
	it("runAllTimers", function()
		timers:useFakeTimers()

		local runOrder = {}
		timers.delayOverride(0, function()
			table.insert(runOrder, 0)
			timers.delayOverride(10, function()
				table.insert(runOrder, 10)
			end)
		end)
		timers.delayOverride(100, function()
			table.insert(runOrder, 100)
		end)

		timers:runOnlyPendingTimers()
		jestExpect(runOrder).toEqual({ 0, 100 })
		jestExpect(timers.osOverride.clock()).toBe(100)

		timers:runAllTimers()
		jestExpect(runOrder).toEqual({ 0, 100, 10 })
		jestExpect(timers.osOverride.clock()).toBe(100)
	end)

	it("run timers in order", function()
		timers:useFakeTimers()

		local runOrder = {}
		timers.delayOverride(0, function()
			table.insert(runOrder, 0)
			timers.delayOverride(10, function()
				table.insert(runOrder, 10)
			end)
		end)
		timers.delayOverride(100, function()
			table.insert(runOrder, 100)
		end)

		timers:runAllTimers()
		jestExpect(runOrder).toEqual({ 0, 10, 100 })
		jestExpect(timers.osOverride.clock()).toBe(100)
	end)

	it("runOnlyPendingTimers", function()
		timers:useFakeTimers()

		local runOrder = {}
		timers.delayOverride(0, function()
			table.insert(runOrder, 0)
			timers.delayOverride(10, function()
				table.insert(runOrder, 10)
			end)
		end)
		timers.delayOverride(100, function()
			table.insert(runOrder, 100)
		end)

		timers:runOnlyPendingTimers()
		jestExpect(runOrder).toEqual({ 0, 100 })
		jestExpect(timers.osOverride.clock()).toBe(100)

		timers:runOnlyPendingTimers()
		jestExpect(runOrder).toEqual({ 0, 100, 10 })
		jestExpect(timers.osOverride.clock()).toBe(100)
	end)
end)

return {}
