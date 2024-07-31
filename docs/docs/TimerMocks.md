---
id: timer-mocks
title: Timer Mocks
---
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/timer-mocks)

![Deviation](/img/deviation.svg)

The Lua and Roblox native timer functions (i.e., `delay()`, `tick()`, `os.time()`, `os.clock()`) are less than ideal for a testing environment since they depend on real time to elapse. Jest Roblox can swap out timers with functions that allow you to control the passage of time. [Great Scott!](https://www.youtube.com/watch?v=QZoJ2Pt27BY)

:::info

Also see [Fake Timers API](jest-object#fake-timers) documentation.

:::

## Enable Fake Timers

In the following example we enable fake timers by calling `jest.useFakeTimers()`. This is replacing the original implementation of `task.delay()` and other timer functions. Timers can be restored to their normal behavior with `jest.useRealTimers()`.

```lua title="timerGame.lua"
return function(callback)
	print('Ready....go!')
	task.delay(1, function()
		print("Time's up -- stop!")
		if callback do
			callback()
		end
	end)
end
```

```lua title="__tests__/timerGame-test.spec.lua"
local jest = JestGlobals.jest

jest.useFakeTimers()

test('waits 1 second before ending the game', function()
	local timerGame = require(Workspace.timerGame)
	timerGame()
end)
```

## Run All Timers

Another test we might want to write for this module is one that asserts that the callback is called after 1 second. To do this, we're going to use Jest's timer control APIs to fast-forward time right in the middle of the test:

```lua
jest.useFakeTimers()

test('calls the callback after 1 second', function()
	local timerGame = require(Workspace.timerGame)
	local callback = jest.fn()

	timerGame(callback)

	-- At this point in time, the callback should not have been called yet
	expect(callback).never.toBeCalled()

	-- Fast-forward until all timers have been executed
	jest.runAllTimers()

	-- Now our callback should have been called!
	expect(callback).toBeCalled()
	expect(callback).toHaveBeenCalledTimes(1)
end)
```

## Run Pending Timers

There are also scenarios where you might have a recursive timer – that is a timer that sets a new timer in its own callback. For these, running all the timers would be an endless loop.

If that is your case, using `jest.runOnlyPendingTimers()` will solve the problem:
```lua title="infiniteTimerGame.lua"
local function infiniteTimerGame(callback)
	print('Ready....go!')

	task.delay(1, function()
		print("Time's up! 10 seconds before the next game starts...");
		if callback then
			callback()
		end

		task.delay(10, function()
			infiniteTimerGame(callback)
		end)
	end)
end
```
```lua title="__tests__/infiniteTimerGame-test.spec.lua"
jest.useFakeTimers()

describe('infiniteTimerGame', function()
	test('schedules a 10-second timer after 1 second', function()
		local infiniteTimerGame = require(Workspace.infiniteTimerGame)
		local callback = jest.fn()

		infiniteTimerGame(callback)
		-- At this point in time, there should have been a single call to
		-- setTimeout to schedule the end of the game in 1 second.

		-- Fast forward and exhaust only currently pending timers
		-- (but not any new timers that get created during that process)
		jest.runOnlyPendingTimers()

		-- At this point, our 1-second timer should have fired its callback
		expect(callback).toBeCalled()

		-- And it should have created a new timer to start the game over in
		-- 10 seconds
	end)
end)
```

## Advance Timers by Time
![Deviation](/img/deviation.svg)

Another possibility is use `jest.advanceTimersByTime(secsToRun)`. When this API is called, all timers are advanced by `secsToRun` seconds. All pending "macro-tasks" that have been queued, and would be executed during this time frame, will be executed. Additionally, if those macro-tasks schedule new macro-tasks that would be executed within the same time frame, those will be executed until there are no more macro-tasks remaining in the queue that should be run within `secsToRun` seconds.

```lua title="timerGame.lua"
return function(callback)
	print('Ready....go!')
	task.delay(1, function()
		print("Time's up -- stop!")
		if callback do
			callback()
		end
	end)
end
```

```lua title="__tests__/timerGame-test.spec.lua"
jest.useFakeTimers()

test('calls the callback after 1 second via advanceTimersByTime', function()
	local timerGame = require(Workspace.timerGame)
	local callback = jest.fn()

	timerGame(callback)

	-- At this point in time, the callback should not have been called yet
	expect(callback).never.toBeCalled()

	-- Fast-forward until all timers have been executed
	jest.advanceTimersByTime(1)

	-- Now our callback should have been called!
	expect(callback).toBeCalled()
	expect(callback).toHaveBeenCalledTimes(1)
end)
```

Lastly, it may occasionally be useful in some tests to be able to clear all of the pending timers. For this, we have `jest.clearAllTimers()`.

## Setting Engine Frame Time
![Roblox only](/img/roblox-only.svg)

By default, Jest Roblox processes fake timers in continuous time. However, because the Roblox engine processes timers only once per frame, this may not accurately reflect engine behavior.

To more closely mock engine behavior, Jest Roblox allows you to configure an engine frame time, which ensures that timers are queued and run more similarly to how the engine [task scheduler](https://create.roblox.com/docs/optimization/microprofiler/task-scheduler) queues and runs timers. `jest.advanceTimersByTime()` will behave like an equivalent `task.wait()`, particularly at micro time-scales.

Roblox currently runs at a 60 frames a second, which can be configured with `jest.setEngineFrameTime(1000/60)`.

```lua title="timerGame.lua"
return function(callback)
	print('Ready....go!')
	task.delay(0.01, function()
		print("Time's up -- stop!")
		if callback do
			callback()
		end
	end)
end
```

```lua title="__tests__/timerGame-test.spec.lua"
jest.useFakeTimers()

test('calls the callback after advanceTimersByTime advances by 1 frame', function()
	local timerGame = require(Workspace.timerGame)
	local callback = jest.fn()

	-- frameTime is set in milliseconds
	jest.setEngineFrameTime(1000/60)

	timerGame(callback)

	-- At this point in time, the callback should not have been called yet
	expect(callback).never.toBeCalled()

	-- Timer is advanced by about 16ms, since a 0 second timer is processed in the next frame
	jest.advanceTimersByTime(0)

	-- Now our callback should have been called!
	expect(callback).toBeCalled()
	expect(callback).toHaveBeenCalledTimes(1)
end)
```
