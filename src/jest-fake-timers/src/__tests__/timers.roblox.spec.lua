-- ROBLOX NOTE: no upstream
local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local setInterval = LuauPolyfill.setInterval

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local beforeEach = JestGlobals.beforeEach
local afterEach = JestGlobals.afterEach
local describe = JestGlobals.describe
local test = JestGlobals.test
local jest = JestGlobals.jest
local FRAME_TIME = 15

describe("setTimeout", function()
	beforeEach(function()
		jest.useFakeTimers()
	end)

	afterEach(function()
		jest.useRealTimers()
	end)

	test("should not trigger", function()
		local triggered = false
		setTimeout(function()
			triggered = true
		end, 200)
		jest.advanceTimersByTime(199)
		expect(triggered).toBe(false)
	end)

	test("should trigger", function()
		local triggered = false
		setTimeout(function()
			triggered = true
		end, 200)
		jest.advanceTimersByTime(200)
		expect(triggered).toBe(true)
	end)

	test("should trigger with a configurable frame time", function()
		jest.useFakeTimers()
		jest.setEngineFrameTime(FRAME_TIME)
		local triggered = false
		setTimeout(function()
			triggered = true
		end, 10)
		jest.advanceTimersByTime(0)
		expect(triggered).toBe(true)
	end)
end)

describe("setInterval", function()
	beforeEach(function()
		jest.useFakeTimers()
	end)

	afterEach(function()
		jest.useRealTimers()
	end)

	test("should not trigger", function()
		local triggered = 0
		setInterval(function()
			triggered += 1
		end, 200)
		jest.advanceTimersByTime(199)
		expect(triggered).toBe(0)
	end)

	test("should trigger once", function()
		local triggered = 0
		setInterval(function()
			triggered += 1
		end, 200)
		jest.advanceTimersByTime(200)
		expect(triggered).toBe(1)
	end)

	test("should trigger multiple times", function()
		local triggered = 0
		setInterval(function()
			triggered += 1
		end, 200)
		jest.advanceTimersByTime(100)
		expect(triggered).toBe(0)

		jest.advanceTimersByTime(99)
		expect(triggered).toBe(0)

		jest.advanceTimersByTime(1)
		expect(triggered).toBe(1)

		jest.advanceTimersByTime(100)
		expect(triggered).toBe(1)

		jest.advanceTimersByTime(100)
		expect(triggered).toBe(2)

		jest.advanceTimersByTime(199)
		expect(triggered).toBe(2)

		jest.advanceTimersByTime(1)
		expect(triggered).toBe(3)
	end)
end)

describe("task.delay", function()
	beforeEach(function()
		jest.useFakeTimers()
	end)

	afterEach(function()
		jest.useRealTimers()
	end)

	test("should trigger", function()
		local triggered = false
		task.delay(2, function()
			triggered = true
		end)
		jest.advanceTimersByTime(2000)
		expect(triggered).toBe(true)
	end)

	test("should not trigger", function()
		local triggered = false
		task.delay(2, function()
			triggered = true
		end)
		jest.advanceTimersByTime(1999)
		expect(triggered).toBe(false)
	end)

	test("should not timeout", function()
		local triggered = false
		task.delay(10, function()
			triggered = true
		end)
		jest.advanceTimersByTime(10000)
		expect(triggered).toBe(true)
	end, 1000)
end)

describe("task.cancel", function()
	beforeEach(function()
		jest.useFakeTimers()
	end)

	afterEach(function()
		jest.useRealTimers()
	end)

	test("timeout should be canceled and not trigger", function()
		local triggered = false
		local timeout = task.delay(2, function()
			triggered = true
		end)
		task.cancel(timeout)
		jest.advanceTimersByTime(2000)
		expect(triggered).toBe(false)
	end)

	test("one timeout should be canceled and not trigger", function()
		local triggered1 = false
		local triggered2 = false
		local timeout1 = task.delay(2, function()
			triggered1 = true
		end)
		local _timeout2 = task.delay(2, function()
			triggered2 = true
		end)

		task.cancel(timeout1)
		jest.advanceTimersByTime(2000)
		expect(triggered1).toBe(false)
		expect(triggered2).toBe(true)
	end)

	test("cancel after delayed task runs", function()
		local triggered = false
		local timeout = task.delay(2, function()
			triggered = true
		end)
		jest.advanceTimersByTime(2000)
		task.cancel(timeout)
		expect(triggered).toBe(true)
	end)
end)

describe("task.wait", function()
	beforeEach(function()
		jest.useFakeTimers()
	end)

	afterEach(function()
		jest.useRealTimers()
	end)

	test("should wait for the specified time", function()
		local elapsed = 0
		coroutine.wrap(function()
			elapsed = task.wait(2)
		end)()
		jest.advanceTimersByTime(2000)
		expect(elapsed).toBe(2)
	end)

	test("should not proceed before the specified time", function()
		local elapsed = 0
		coroutine.wrap(function()
			elapsed = task.wait(2)
		end)()
		jest.advanceTimersByTime(1999)
		expect(elapsed).toBe(0)
	end)

	test("should default to frame time if no time is specified", function()
		local elapsed = 0
		coroutine.wrap(function()
			elapsed = task.wait()
		end)()
		jest.advanceTimersByTime(1000 / 60)
		expect(elapsed).toBeCloseTo(1 / 60, 0.001)
	end)

	test("multiple waits should accumulate correctly", function()
		local elapsed1, elapsed2 = 0, 0
		coroutine.wrap(function()
			elapsed1 = task.wait(1)
			elapsed2 = task.wait(2)
		end)()
		jest.advanceTimersByTime(1000)
		expect(elapsed1).toBe(1)
		expect(elapsed2).toBe(0)
		jest.advanceTimersByTime(2000)
		expect(elapsed1).toBe(1)
		expect(elapsed2).toBe(2)
	end)
end)
