---
id: jest-object
title: The Jest Object
---
<p><a href='https://jestjs.io/docs/27.x/jest-object' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a></p>

The methods in the `jest` object help create mocks and let you control Jest Roblox's overall behavior.

<img alt='deviation' src='img/deviation.svg'/>

It must be imported explicitly from `JestGlobals`.
```lua
local jest = require(Packages.Dev.JestGlobals).jest
```

## Methods

import TOCInline from "@theme/TOCInline";

<TOCInline toc={toc.slice(1)}/>

## Mock Modules

### `jest.isolateModules(fn)`
<a href='https://jestjs.io/docs/27.x/jest-object#jestisolatemodulesfn' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

`jest.isolateModules(fn)` creates a sandbox registry for the modules that are loaded inside the callback function. This is useful to isolate specific modules for every test so that local module state doesn't conflict between tests.

```lua
local myModule
jest.isolateModules(function()
	myModule = require(Workspace.MyModule)
end)

local otherCopyOfMyModule = require(Workspace.MyModule)
```

### `jest.resetModules()`
<a href='https://jestjs.io/docs/27.x/jest-object#jestresetmodules' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Resets the module registry - the cache of all required modules. This is useful to isolate modules where local state might conflict between tests.

Example:

```lua
local sum1 = require(Workspace.sum)
jest.resetModules()
local sum2 = require(Workspace.sum)
expect(sum1).never.toBe(sum2)
-- Both sum modules are separate "instances" of the sum module.
```

Example in a test:

```lua
beforeEach(function()
	jest.resetModules()
end)

test('works', function()
	local sum = require(Workspace.sum)
end)

test('works too', function()
	local sum = require(Workspace.sum)
	-- sum is a different copy of the sum module from the previous test.
end)
```

Returns the `jest` object for chaining.

## Mock Functions

### `jest.fn(implementation)`
<a href='https://jestjs.io/docs/27.x/jest-object#jestfnimplementation' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Deviation' src='img/deviation.svg'/>

Returns a new, unused [mock function](mock-function-apimd). Optionally takes a mock implementation.

`jest.fn()` returns a callable table as the first return value and a function as the second return value. See the [deviation](deviations#jestfn) note.

```lua
local mockFn = jest.fn()
mockFn()
expect(mockFn).toHaveBeenCalled()

-- With a mock implementation:
local returnsTrue = jest.fn(function() return true end)
print(returnsTrue()) -- true
```

### `jest.clearAllMocks()`
<a href='https://jestjs.io/docs/27.x/jest-object#jestclearallmocks' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Clears the `mock.calls`, `mock.instances` and `mock.results` properties of all mocks. Equivalent to calling [`.mockClear()`](mock-function-api#mockfnmockclear) on every mocked function.

This can be included in a `beforeEach()` block in your text fixture to clear out the state of all mocks before each test.

Returns the `jest` object for chaining.

### `jest.resetAllMocks()`
<a href='https://jestjs.io/docs/27.x/jest-object#jestresetallmocks' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Resets the state of all mocks. Equivalent to calling [`.mockReset()`](mock-function-api#mockfnmockreset) on every mocked function.

Returns the `jest` object for chaining.

<!-- ### `jest.restoreAllMocks()`
<a href='https://jestjs.io/docs/27.x/jest-object#jestrestoreallmocks' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

TODO: need spyOn

Restores all mocks back to their original value. Equivalent to calling [`.mockRestore()`](mock-function-api#mockfnmockrestore) on every mocked function. Beware that `jest.restoreAllMocks()` only works when the mock was created with `jest.spyOn`; other mocks will require you to manually restore them. -->

## Mock Timers

### `jest.useFakeTimers()`
<a href='https://jestjs.io/docs/27.x/jest-object#jestusefaketimersimplementation-modern--legacy' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Deviation' src='img/deviation.svg'/>

Instructs Jest Roblox to use fake versions of the standard Lua and Roblox timer functions (`delay`, `tick`, `os.time`, `os.clock`, `task.delay` as well as `DateTime`).

Returns the `jest` object for chaining.

### `jest.useRealTimers()`
<a href='https://jestjs.io/docs/27.x/jest-object#jestuserealtimers' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Instructs Jest Roblox to use the real versions of the standard timer functions.

Returns the `jest` object for chaining.

### `jest.runAllTimers()`
<a href='https://jestjs.io/docs/27.x/jest-object#jestrunalltimers' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Deviation' src='img/deviation.svg'/>

Exhausts the **macro**-task queue (i.e., all tasks queued by `delay`).

When this API is called, all pending macro-tasks will be executed. If those tasks themselves schedule new tasks, those will be continually exhausted until there are no more tasks remaining in the queue.

This is often useful for synchronously executing `delay`s during a test in order to synchronously assert about some behavior that would only happen after the `delay` callbacks executed. See the [Timer mocks](timer-mocks) doc for more information.

### `jest.advanceTimersByTime(secsToRun)`
<a href='https://jestjs.io/docs/27.x/jest-object#jestadvancetimersbytimemstorun' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='API change' src='img/apichange.svg'/>

Executes only the macro task queue (i.e., all tasks queued by `delay`).

When this API is called, all timers are advanced by `secsToRun` seconds. All pending "macro-tasks" that have been queued, and would be executed within this time frame will be executed. Additionally, if those macro-tasks schedule new macro-tasks that would be executed within the same time frame, those will be executed until there are no more macro-tasks remaining in the queue, that should be run within `secsToRun` seconds.

### `jest.runOnlyPendingTimers()`
<a href='https://jestjs.io/docs/27.x/jest-object#jestrunonlypendingtimers' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Executes only the macro-tasks that are currently pending (i.e., all tasks queued by `delay`). If any of the currently pending macro-tasks schedule new macro-tasks, those new tasks will not be executed by this call.

This is useful for scenarios such as one where the module being tested schedules a `delay()` whose callback schedules another `delay()` recursively (meaning the scheduling never stops). In these scenarios, it's useful to be able to run forward in time by a single step at a time.

### `jest.advanceTimersToNextTimer(steps)`
<a href='https://jestjs.io/docs/27.x/jest-object#jestadvancetimerstonexttimersteps' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Advances all timers by the needed seconds so that only the next timeouts/intervals will run.

Optionally, you can provide `steps`, so it will run `steps` amount of next timeouts/intervals.

### `jest.clearAllTimers()`
<a href='https://jestjs.io/docs/27.x/jest-object#jestclearalltimers' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Removes any pending timers from the timer system.

This means, if any timers have been scheduled (but have not yet executed), they will be cleared and will never have the opportunity to execute in the future.

### `jest.getTimerCount()`
<a href='https://jestjs.io/docs/27.x/jest-object#jestgettimercount' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Returns the number of fake timers still left to run.

### `jest.setSystemTime(now?: number | DateTime)`
<a href='https://jestjs.io/docs/27.x/jest-object#jestsetsystemtimenow-number--date' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Set the current system time used by fake timers. Simulates a user changing the system clock while your program is running. It affects the current time but it does not in itself cause e.g. timers to fire; they will fire exactly as they would have done without the call to `jest.setSystemTime()`.

### `jest.getRealSystemTime()`
<a href='https://jestjs.io/docs/27.x/jest-object#jestgetrealsystemtime' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

When mocking time, `DateTime.now()` will also be mocked. If you for some reason need access to the real current time, you can invoke this function.