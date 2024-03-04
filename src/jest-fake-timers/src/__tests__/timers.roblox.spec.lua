-- ROBLOX NOTE: no upstream
local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local setTimeout = LuauPolyfill.setTimeout
local setInterval = LuauPolyfill.setInterval

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local beforeEach = JestGlobals.beforeEach
local afterEach = JestGlobals.afterEach
local describe = JestGlobals.describe
local test = JestGlobals.test
local jest = JestGlobals.jest
local FRAME_TIME = 15

describe("timers", function()
	beforeEach(function()
		jest.useFakeTimers()
	end)
	afterEach(function()
		jest.useRealTimers()
	end)

	test("setTimeout - should not trigger", function()
		local triggered = false
		setTimeout(function()
			triggered = true
		end, 200)
		jest.advanceTimersByTime(199)
		expect(triggered).toBe(false)
	end)

	test("setTimeout - should trigger", function()
		local triggered = false
		setTimeout(function()
			triggered = true
		end, 200)
		jest.advanceTimersByTime(200)
		expect(triggered).toBe(true)
	end)

	test("setInterval - should not trigger", function()
		local triggered = 0
		setInterval(function()
			triggered += 1
		end, 200)
		jest.advanceTimersByTime(199)
		expect(triggered).toBe(0)
	end)

	test("setInterval - should trigger once", function()
		local triggered = 0
		setInterval(function()
			triggered += 1
		end, 200)
		jest.advanceTimersByTime(200)
		expect(triggered).toBe(1)
	end)

	test("setInterval - should trigger multiple times", function()
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

	test("task.delay - should trigger", function()
		local triggered = false
		task.delay(2, function()
			triggered = true
		end)
		jest.advanceTimersByTime(2000)
		expect(triggered).toBe(true)
	end)

	test("task.delay - should not trigger", function()
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

	test("task.cancel - timeout should be canceled and not trigger", function()
		local triggered = false
		local timeout = task.delay(2, function()
			triggered = true
		end)
		task.cancel(timeout)
		jest.advanceTimersByTime(2000)
		expect(triggered).toBe(false)
	end)

	test("task.cancel - one timeout should be canceled and not trigger", function()
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

	test("task.cancel - cancel after delayed task runs", function()
		local triggered = false
		local timeout = task.delay(2, function()
			triggered = true
		end)
		jest.advanceTimersByTime(2000)
		task.cancel(timeout)
		expect(triggered).toBe(true)
	end)
end)

describe("timers with configurable frame time", function()
	test("setTimeout - should trigger", function()
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
