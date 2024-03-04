--!nonstrict
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
local jest = JestGlobals.jest
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local afterEach = JestGlobals.afterEach

local FakeTimers = require("../init")
local timers = FakeTimers.new()
local FRAME_TIME = 15

afterEach(function()
	timers:useRealTimers()
end)

describe("FakeTimers", function()
	describe("construction", function()
		it("installs delay mock", function()
			expect(timers.delayOverride).never.toBeNil()
		end)

		it("installs tick mock", function()
			expect(timers.tickOverride).never.toBeNil()
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
			expect(timers.osOverride.clock()).toEqual(200)
			expect(runOrder).toEqual({
				"mock2",
				"mock3",
				"mock5",
				"mock6",
				"mock1",
				"mock4",
			})
		end)

		it("preserves insertion order for timers with the same timeout", function()
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

			timers.delayOverride(0, mock2)
			timers.delayOverride(10, mock3)
			timers.delayOverride(10, mock5)
			timers.delayOverride(10, mock6)
			timers.delayOverride(20, mock1)
			timers.delayOverride(20, mock4)

			timers:runAllTimers()
			expect(runOrder).toEqual({
				"mock2",
				"mock3",
				"mock5",
				"mock6",
				"mock1",
				"mock4",
			})
		end)

		it("warns when trying to advance timers while real timers are used", function()
			expect(function()
				timers:runAllTimers()
			end).toThrow(
				"A function to advance timers was called but the timers API is not "
					.. "mocked with fake timers. Call `jest.useFakeTimers()` in this test."
			)
		end)

		it("does nothing when no timers have been scheduled", function()
			timers:useFakeTimers()

			expect(timers.osOverride.clock()).toEqual(0)
			timers:runAllTimers()
		end)

		it("only runs a delay callback once (ever)", function()
			timers:useFakeTimers()

			local fn = jest.fn()
			timers.delayOverride(0, fn)
			expect(fn).toHaveBeenCalledTimes(0)

			timers:runAllTimers()
			expect(fn).toHaveBeenCalledTimes(1)

			timers:runAllTimers()
			expect(fn).toHaveBeenCalledTimes(1)
		end)

		it("runs callbacks with arguments after the interval", function()
			timers:useFakeTimers()

			local fn = jest.fn()
			timers.delayOverride(0, function()
				fn("mockArg1", "mockArg2")
			end)

			timers:runAllTimers()
			expect(fn).toHaveBeenCalledTimes(1)
			expect(fn).toHaveBeenCalledWith("mockArg1", "mockArg2")
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

			timers.delayOverride(100 / 1000, mock1)
			timers.delayOverride(0, mock2)
			timers.delayOverride(0, mock3)
			timers.delayOverride(200 / 1000, mock4)

			-- Move forward to t=50
			timers:advanceTimersByTime(50)
			expect(timers.osOverride.clock()).toEqual(50 / 1000)
			expect(runOrder).toEqual({ "mock2", "mock3" })

			-- Move forward to t=60
			timers:advanceTimersByTime(10)
			expect(timers.osOverride.clock()).toEqual(60 / 1000)
			expect(runOrder).toEqual({ "mock2", "mock3" })

			-- Move forward to t=100
			timers:advanceTimersByTime(40)
			expect(timers.osOverride.clock()).toEqual(100 / 1000)
			expect(runOrder).toEqual({ "mock2", "mock3", "mock1" })

			-- Move forward to t=200
			timers:advanceTimersByTime(100)
			expect(timers.osOverride.clock()).toEqual(200 / 1000)
			expect(runOrder).toEqual({ "mock2", "mock3", "mock1", "mock4" })
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
			expect(timers.osOverride.clock()).toEqual(0)
			expect(runOrder).toEqual({ "mock2", "mock3" })

			timers:advanceTimersToNextTimer()
			-- Move forward to t=100
			expect(timers.osOverride.clock()).toEqual(100)
			expect(runOrder).toEqual({ "mock2", "mock3", "mock1" })

			timers:advanceTimersToNextTimer()
			-- Move forward to t=200
			expect(timers.osOverride.clock()).toEqual(200)
			expect(runOrder).toEqual({ "mock2", "mock3", "mock1", "mock4" })
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
			expect(timers.osOverride.clock()).toEqual(100)
			expect(runOrder).toEqual({ "mock2", "mock3", "mock1" })

			-- Move forward to t=600
			timers:advanceTimersToNextTimer(3)
			expect(timers.osOverride.clock()).toEqual(600)
			expect(runOrder).toEqual({
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
			expect(timers.osOverride.clock()).toEqual(75)
			expect(runOrder).toEqual({ "mock1", "mock2", "mock3" })
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
			expect(mock1).toHaveBeenCalledTimes(0)
		end)

		it("resets current advanceTimersByTime time cursor", function()
			timers:useFakeTimers()

			local mock1 = jest.fn()
			timers.delayOverride(100, mock1)
			timers:advanceTimersByTime(50)
			expect(timers.osOverride.clock()).toEqual(50 / 1000)

			timers:reset()
			expect(timers.osOverride.clock()).toEqual(0)
			timers.delayOverride(100, mock1)

			timers:advanceTimersByTime(50)
			expect(timers.osOverride.clock()).toEqual(50 / 1000)
			expect(mock1).toHaveBeenCalledTimes(0)
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
			expect(timers.osOverride.clock()).toEqual(200)
			expect(runOrder).toEqual({
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
			local nativeTime = timers.timeOverride.getMockImplementation()

			timers:useFakeTimers()
			local fakeDelay = timers.delayOverride.getMockImplementation()
			local fakeTick = timers.tickOverride.getMockImplementation()
			local fakeTime = timers.timeOverride.getMockImplementation()
			expect(fakeDelay).never.toBe(nativeDelay)
			expect(fakeTick).never.toBe(nativeTick)
			expect(fakeTime).never.toBe(nativeTime)

			timers:useRealTimers()
			local realDelay = timers.delayOverride.getMockImplementation()
			local realTick = timers.tickOverride.getMockImplementation()
			local realTime = timers.timeOverride.getMockImplementation()
			expect(realDelay).toBe(nativeDelay)
			expect(realTick).toBe(nativeTick)
			expect(realTime).toBe(nativeTime)
		end)
	end)

	describe("getTimerCount", function()
		it("returns the correct count", function()
			timers:useFakeTimers()

			timers.delayOverride(0, function() end)
			timers.delayOverride(0, function() end)
			timers.delayOverride(10 / 1000, function() end)

			expect(timers:getTimerCount()).toEqual(3)

			timers:advanceTimersByTime(5)

			expect(timers:getTimerCount()).toEqual(1)

			timers:advanceTimersByTime(5)

			expect(timers:getTimerCount()).toEqual(0)
		end)
	end)
end)

describe("FakeTimers with frame time", function()
	describe("construction", function()
		it("gets and sets frame time", function()
			timers:useFakeTimers()
			timers:setEngineFrameTime(FRAME_TIME)
			expect(timers:getEngineFrameTime()).toEqual(FRAME_TIME)
		end)
	end)

	describe("advanceTimersByTime", function()
		it("advanceTimersByTime below frame time", function()
			timers:useFakeTimers()
			timers:setEngineFrameTime(FRAME_TIME)

			expect(timers.osOverride.clock()).toBe(0)
			timers:advanceTimersByTime(0)
			-- Advances by at least one frame
			expect(timers.osOverride.clock()).toBe(FRAME_TIME / 1000)

			timers:advanceTimersByTime(FRAME_TIME - 5)
			expect(timers.osOverride.clock()).toBe((FRAME_TIME * 2) / 1000)
		end)

		it("correctly sets delays below frame time", function()
			timers:useFakeTimers()
			timers:setEngineFrameTime(FRAME_TIME)

			local callback = jest.fn()
			timers.delayOverride(0, callback)
			timers.delayOverride(0, callback)
			timers.delayOverride((FRAME_TIME - 5) / 1000, callback)
			expect(callback).toHaveBeenCalledTimes(0)

			timers:advanceTimersByTime(0)
			expect(timers.osOverride.clock()).toBe(FRAME_TIME / 1000)
			expect(callback).toHaveBeenCalledTimes(3)
		end)

		it("recursive delay(0)", function()
			timers:useFakeTimers()
			timers:setEngineFrameTime(FRAME_TIME)

			local loopFn = function() end
			loopFn = jest.fn(function()
				timers.delayOverride(0, loopFn)
			end)
			timers.delayOverride(0, loopFn)

			timers:advanceTimersByTime(0)
			-- The minimum amount of time needed to complete a 0 second timer is 1 frame
			expect(loopFn).toHaveBeenCalledTimes(1)
			expect(timers.osOverride.clock()).toBe(FRAME_TIME / 1000)

			-- Advance by just under the frame time for 10 frames to advance by 10 frames
			timers:advanceTimersByTime((FRAME_TIME * 10) - 1)
			expect(loopFn).toHaveBeenCalledTimes(11)
			expect(timers.osOverride.clock()).toBe((FRAME_TIME * 11) / 1000)
		end)

		it("advances time by the minimum multiple of frame time greater than the timeout", function()
			timers:useFakeTimers()
			timers:setEngineFrameTime(FRAME_TIME)

			local callback = jest.fn()
			timers.delayOverride(0, callback)
			timers:advanceTimersByTime(0)
			expect(callback).toHaveBeenCalled()

			expect(timers.osOverride.clock()).toEqual(FRAME_TIME / 1000)
		end)

		it("advances time by the minimum multiple of frame time greater than the timeout", function()
			timers:useFakeTimers()
			timers:setEngineFrameTime(FRAME_TIME)

			local callback1 = jest.fn()
			local callback2 = jest.fn()
			timers.delayOverride(0.01, callback1)
			timers.delayOverride(0, callback2)
			timers:advanceTimersByTime(0)
			expect(callback2).toHaveBeenCalled()
			expect(callback1).toHaveBeenCalled()

			expect(timers.osOverride.clock()).toEqual(FRAME_TIME / 1000)
		end)

		it("does nothing when no timers have been scheduled", function()
			timers:useFakeTimers()
			timers:setEngineFrameTime(FRAME_TIME)
			timers:advanceTimersByTime(100)

			expect(timers.osOverride.clock()).toEqual(FRAME_TIME * 7 / 1000)
		end)
	end)

	describe("advanceTimersToNextTimer", function()
		it("runs timers in order", function()
			timers:useFakeTimers()
			timers:setEngineFrameTime(FRAME_TIME)

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

			timers.delayOverride(0.012, mock1)
			timers.delayOverride(0, mock2)
			timers.delayOverride(0.01, mock3)

			timers:advanceTimersToNextTimer()
			-- Move forward to first frame after t=0
			local targetTime = FRAME_TIME
			expect(timers.osOverride.clock()).toEqual(targetTime / 1000)
			expect(runOrder).toEqual({ "mock2", "mock3", "mock1" })
		end)

		it("run correct amount of steps", function()
			timers:useFakeTimers()
			timers:setEngineFrameTime(FRAME_TIME)

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

			timers.delayOverride(0.01, mock1)
			timers.delayOverride(0, mock2)
			timers.delayOverride(0, mock3)
			timers.delayOverride(200, mock4)

			-- We expect to advance two steps, so we move forward to first frame after t=200
			-- because mock1, mock2, and mock3 all fire in the same frame / step
			timers:advanceTimersToNextTimer(2)
			local targetTime = math.floor((200 * 1000 / FRAME_TIME) + 1) * FRAME_TIME
			expect(timers.osOverride.clock()).toEqual(targetTime / 1000)
			expect(runOrder).toEqual({ "mock2", "mock3", "mock1", "mock4" })
		end)
	end)
end)

describe("DateTime", function()
	describe("construction", function()
		it("installs DateTime mock", function()
			expect(timers.dateTimeOverride).never.toBeNil()
			expect(timers.dateTimeOverride.now()).never.toBeNil()
		end)

		it("DateTime constructors pass through", function()
			timers:useFakeTimers()

			expect(timers.dateTimeOverride.now()).never.toBeNil()
			expect(timers.dateTimeOverride.fromUnixTimestamp()).never.toBeNil()
			expect(timers.dateTimeOverride.fromUnixTimestampMillis()).never.toBeNil()
			expect(timers.dateTimeOverride.fromUniversalTime()).never.toBeNil()
			expect(timers.dateTimeOverride.fromLocalTime()).never.toBeNil()
			expect(timers.dateTimeOverride.fromIsoDate("2020-01-02T10:30:45Z")).never.toBeNil()
		end)
	end)

	it("affected by timers", function()
		timers:useFakeTimers()

		local time_ = timers.dateTimeOverride.now().UnixTimestamp
		-- advanceTimersByTime is in ms, while system time is in s
		timers:advanceTimersByTime(1000)
		expect(timers.dateTimeOverride.now().UnixTimestamp).toEqual(time_ + 1000 / 1000)
	end)

	describe("setSystemTime", function()
		it("UnixTimestamp", function()
			timers:useFakeTimers()

			timers:setSystemTime(0)
			expect(timers.dateTimeOverride.now()).toEqual(timers.dateTimeOverride.fromUnixTimestamp(0))
		end)

		it("DateTime object", function()
			timers:useFakeTimers()

			timers:setSystemTime(timers.dateTimeOverride.fromUniversalTime(1971))
			expect(timers.dateTimeOverride.now()).toEqual(timers.dateTimeOverride.fromUniversalTime(1971))
		end)
	end)

	describe("getRealSystemTime", function()
		it("returns real system time", function()
			timers:useFakeTimers()

			timers:setSystemTime(0)
			expect(timers.dateTimeOverride.now()).never.toEqual(timers:getRealSystemTime())
		end)
	end)

	describe("useRealTimers, useFakeTimers", function()
		it("resets native timer APIs", function()
			local nativeDateTime = timers.dateTimeOverride.now.getMockImplementation()

			timers:useFakeTimers()
			local fakeDateTime = timers.dateTimeOverride.now.getMockImplementation()
			expect(fakeDateTime).never.toBe(nativeDateTime)

			timers:useRealTimers()
			local realDateTime = timers.dateTimeOverride.now.getMockImplementation()
			expect(realDateTime).toBe(nativeDateTime)
		end)
	end)

	describe("reset", function()
		it("resets system time", function()
			timers:useFakeTimers()

			timers:setSystemTime(0)
			local fakeTime = timers.dateTimeOverride.now()
			expect(timers.dateTimeOverride.now()).toEqual(fakeTime)

			timers:reset()
			expect(timers.dateTimeOverride.now()).never.toEqual(fakeTime)
		end)
	end)
end)

describe("os", function()
	describe("construction", function()
		it("installs os mock", function()
			expect(os).never.toBeNil()
			expect(timers.osOverride.time).never.toBeNil()
			expect(timers.osOverride.clock).never.toBeNil()
		end)

		it("os methods pass through", function()
			timers:useFakeTimers()

			expect(timers.osOverride.difftime(2, 1)).toBe(1)
			expect(timers.osOverride.date).never.toBeNil()
		end)
	end)

	describe("timers.osOverride.time", function()
		it("returns correct value", function()
			timers:useFakeTimers()

			timers:setSystemTime(1586982482)
			expect(timers.osOverride.time()).toBe(1586982482)
		end)

		it("returns correct value when passing in table", function()
			timers:useFakeTimers()

			timers:setSystemTime(100)
			expect(timers.osOverride.time({
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
			-- advanceTimersByTime is in ms, while system time is in s
			timers:advanceTimersByTime(1000)
			expect(timers.osOverride.time()).toBe(time_ + 1)
		end)
	end)

	describe("timers.osOverride.clock", function()
		it("affected by timers", function()
			timers:useFakeTimers()

			expect(timers.osOverride.clock()).toBe(0)
			timers:advanceTimersByTime(100)
			expect(timers.osOverride.clock()).toBe(100 / 1000)
		end)
	end)

	describe("useRealTimers, useFakeTimers", function()
		it("resets native timer APIs", function()
			local nativeOsTime = timers.osOverride.time.getMockImplementation()
			local nativeOsClock = timers.osOverride.clock.getMockImplementation()

			timers:useFakeTimers()
			local fakeOsTime = timers.osOverride.time.getMockImplementation()
			local fakeOsClock = timers.osOverride.clock.getMockImplementation()
			expect(fakeOsTime).never.toBe(nativeOsTime)
			expect(fakeOsClock).never.toBe(nativeOsClock)

			timers:useRealTimers()
			local realOsTime = timers.osOverride.time.getMockImplementation()
			local realOsClock = timers.osOverride.clock.getMockImplementation()
			expect(realOsTime).toBe(nativeOsTime)
			expect(realOsClock).toBe(nativeOsClock)
		end)
	end)

	describe("reset", function()
		it("resets system time", function()
			timers:useFakeTimers()

			timers:setSystemTime(0)
			local fakeTime = timers.osOverride.time()
			expect(timers.osOverride.time()).toEqual(fakeTime)

			timers:reset()
			expect(timers.osOverride.time()).never.toEqual(fakeTime)
		end)
	end)
end)

describe("tick", function()
	it("returns UNIX time", function()
		timers:useFakeTimers()

		timers:setSystemTime(100)
		expect(timers.tickOverride()).toBe(100)
	end)

	it("affected by timers", function()
		timers:useFakeTimers()

		timers:setSystemTime(0)
		timers:advanceTimersByTime(1000)

		-- ticks are in s, while advanceTimersByTime is in ms
		expect(timers.tickOverride()).toBe(1)
	end)
end)

describe("time", function()
	it("installs time mock", function()
		expect(time).never.toBeNil()
	end)

	it("affected by timers", function()
		timers:useFakeTimers()

		expect(timers.timeOverride()).toBe(0)
		timers:advanceTimersByTime(100)
		expect(timers.timeOverride()).toBe(100 / 1000)
	end)
end)

describe("task", function()
	describe("construction", function()
		it("installs task mock", function()
			expect(task).never.toBeNil()
			expect(timers.taskOverride.delay).never.toBeNil()
		end)

		it("task methods pass through", function()
			timers:useFakeTimers()

			expect(timers.taskOverride.spawn).never.toBeNil()
			expect(timers.taskOverride.defer).never.toBeNil()
			expect(timers.taskOverride.wait).never.toBeNil()
		end)
	end)

	describe("timers.taskOverride.delay", function()
		it("calls callback with args", function()
			timers:useFakeTimers()

			local runOrder = {}
			local tableInsert = function(str)
				table.insert(runOrder, str)
			end
			local mock1 = jest.fn(tableInsert)
			local mock2 = jest.fn(tableInsert)
			local mock3 = jest.fn(tableInsert)
			local mock4 = jest.fn(tableInsert)
			local mock5 = jest.fn(tableInsert)
			local mock6 = jest.fn(tableInsert)

			timers.taskOverride.delay(100, mock1, "mock1")
			timers.taskOverride.delay(0, mock2, "mock2")
			timers.taskOverride.delay(0, mock3, "mock3")
			timers.taskOverride.delay(200, mock4, "mock4")
			timers.taskOverride.delay(3, mock5, "mock5")
			timers.taskOverride.delay(4, mock6, "mock6")
			timers:runAllTimers()
			expect(timers.osOverride.clock()).toEqual(200)
			expect(runOrder).toEqual({
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
			local nativeTaskDelay = timers.taskOverride.delay.getMockImplementation()
			local nativeTaskCancel = timers.taskOverride.cancel.getMockImplementation()

			timers:useFakeTimers()
			local fakeTaskDelay = timers.taskOverride.delay.getMockImplementation()
			local fakeTaskCancel = timers.taskOverride.cancel.getMockImplementation()
			expect(fakeTaskDelay).never.toBe(nativeTaskDelay)
			expect(fakeTaskCancel).never.toBe(nativeTaskCancel)

			timers:useRealTimers()
			local realTaskDelay = timers.taskOverride.delay.getMockImplementation()
			local realTaskCancel = timers.taskOverride.cancel.getMockImplementation()
			expect(realTaskDelay).toBe(nativeTaskDelay)
			expect(realTaskCancel).toBe(nativeTaskCancel)
		end)
	end)
end)

it("spies", function()
	timers:useFakeTimers()

	local mock1 = jest.fn()
	local mock2 = jest.fn()
	local mock3 = jest.fn()

	expect(timers.delayOverride).never.toHaveBeenCalled()
	expect(timers.taskOverride.delay).never.toHaveBeenCalled()

	timers.delayOverride(0, mock1)
	timers.taskOverride.delay(0, mock1)
	timers.delayOverride(25, function()
		mock2()
		timers.delayOverride(50, mock3)
		timers.tickOverride()
		timers.dateTimeOverride.now()
	end)

	expect(timers.delayOverride).toHaveBeenCalledTimes(2)
	expect(timers.taskOverride.delay).toHaveBeenCalledTimes(1)
	expect(timers.tickOverride).never.toHaveBeenCalled()
	expect(timers.dateTimeOverride.now).never.toHaveBeenCalled()

	timers:runAllTimers()
	expect(timers.delayOverride).toHaveBeenCalledTimes(3)
	expect(timers.tickOverride).toHaveBeenCalledTimes(1)
	expect(timers.delayOverride).toHaveBeenLastCalledWith(50, mock3)
	expect(timers.dateTimeOverride.now).toHaveBeenCalledTimes(1)
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
		expect(timers.delayOverride).toHaveBeenCalledTimes(1)

		timers:runAllTimers()
		expect(timers.delayOverride).toHaveBeenCalledTimes(6)
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
		expect(timers.delayOverride).toHaveBeenCalledTimes(3)
		expect(timers:getTimerCount()).toBe(3)
		expect(mockFn).toHaveBeenCalledTimes(0)
		expect(timers.osOverride.clock()).toBe(0)

		timers:runOnlyPendingTimers()
		expect(timers.delayOverride).toHaveBeenCalledTimes(4)
		expect(timers:getTimerCount()).toBe(1)
		expect(mockFn).toHaveBeenCalledTimes(2)
		expect(timers.osOverride.clock()).toBe(100)

		timers:runOnlyPendingTimers()
		expect(timers.delayOverride).toHaveBeenCalledTimes(5)
		expect(timers:getTimerCount()).toBe(1)
		expect(mockFn).toHaveBeenCalledTimes(2)
		expect(timers.osOverride.clock()).toBe(100)
	end)

	it("advanceTimersByTime", function()
		timers:useFakeTimers()

		local runOrder = {}
		local loopFn = function() end
		loopFn = function()
			table.insert(runOrder, timers.osOverride.clock() * 1000)
			timers.delayOverride(10 / 1000, loopFn)
		end

		timers.delayOverride(0, loopFn)
		timers.delayOverride(51 / 1000, function()
			table.insert(runOrder, timers.osOverride.clock() * 1000)
		end)
		expect(timers.delayOverride).toHaveBeenCalledTimes(2)

		timers:advanceTimersByTime(1)
		expect(runOrder).toEqual({ 0 })
		expect(timers:getTimerCount()).toBe(2)

		timers:advanceTimersByTime(10)
		expect(runOrder).toEqual({ 0, 10 })

		timers:advanceTimersByTime(20)
		expect(runOrder).toEqual({ 0, 10, 20, 30 })
		expect(timers.osOverride.clock()).toBe(31 / 1000)

		timers:advanceTimersByTime(24)
		expect(runOrder).toEqual({ 0, 10, 20, 30, 40, 50, 51 })
		expect(timers.osOverride.clock()).toBe(55 / 1000)
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
		expect(runOrder).toEqual({ 0, 0 })

		timers:advanceTimersToNextTimer(2)
		expect(runOrder).toEqual({ 0, 0, 10, 20 })
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
		expect(runOrder).toEqual({ 0, 100 })
		expect(timers.osOverride.clock()).toBe(100)

		timers:runAllTimers()
		expect(runOrder).toEqual({ 0, 100, 10 })
		expect(timers.osOverride.clock()).toBe(100)
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
		expect(runOrder).toEqual({ 0, 10, 100 })
		expect(timers.osOverride.clock()).toBe(100)
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
		expect(runOrder).toEqual({ 0, 100 })
		expect(timers.osOverride.clock()).toBe(100)

		timers:runOnlyPendingTimers()
		expect(runOrder).toEqual({ 0, 100, 10 })
		expect(timers.osOverride.clock()).toBe(100)
	end)
end)
