---
id: jest-object
title: The Jest Object
---
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object)

The methods in the `jest` object help create mocks and let you control Jest Roblox's overall behavior.

![Deviation](/img/deviation.svg)

It must be imported explicitly from `JestGlobals`.
```lua
local jest = require(Packages.Dev.JestGlobals).jest
```

## Methods

import TOCInline from "@theme/TOCInline";

<TOCInline toc={toc.slice(1)}/>

## Mock Modules

### `jest.mock(module, factory)`
[![Jest](/img/jestjs.svg)](https://jestjs.io/docs/jest-object#jestmockmodulename-factory-options)  ![API Change](/img/apichange.svg)

Mocks a module with an mocked version when it is being required.　The second argument must be used to specify the value of the mocked module.
```lua title="mockedModule.lua"
return {}
```
```lua title="__tests__/testMockedModule.spec.lua"
beforeEach(function()
	jest.resetModules()
	jest.mock(Workspace.mockedModule, function()
		return {
			default = jest.fn(function() return 42 end),
			foo = jest.fn(function() return 43 end)
		}
	end)
end)

local mockedModule

it("mockedModule should be mocked", function()
	mockedModule = require(Workspace.mockedModule)
	expect(mockedModule.default()).toBe(42)
	expect(mockedModule.foo()).toBe(43)
end)
```

Modules that are mocked with `jest.mock` are mocked only for the file that calls `jest.mock`. Another file that imports the module will get the original implementation even if it runs after the test file that mocks the module.

Returns the `jest` object for chaining.

### `jest.unmock(module)`
[![Jest](/img/jestjs.svg)](https://jestjs.io/docs/jest-object#jestunmockmodulename)  ![API Change](/img/apichange.svg)

Indicates that the module system should never return a mocked version of the specified module from `require()` (e.g. that it should always return the real module).

Returns the `jest` object for chaining.
```lua title="__tests__/testMockedModule.spec.lua"
it("mockedModule should not be mocked", function()
	jest.unmock(Workspace.mockedModule)
	mockedModule = require(Workspace.mockedModule)
	expect(mockedModule).toEqual({})
end)
```

### `jest.requireActual(module)`
[![Jest](/img/jestjs.svg)](https://jestjs.io/docs/jest-object#jestrequireactualmodulename)  ![API Change](/img/apichange.svg)

Returns the actual module instead of a mock, bypassing all checks on whether the module should receive a mock implementation or not.

```lua title="__tests__/testMockedModule.spec.lua"
it("mockedModule also should not be mocked", function()
	mockedModule = jest.requireActual(Workspace.mockedModule)
	expect(mockedModule).toEqual({})
end)
```

### `jest.isolateModules(fn)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestisolatemodulesfn)  ![Aligned](/img/aligned.svg)

`jest.isolateModules(fn)` creates a sandbox registry for the modules that are loaded inside the callback function. This is useful to isolate specific modules for every test so that local module state doesn't conflict between tests.

```lua
local myModule
jest.isolateModules(function()
	myModule = require(Workspace.MyModule)
end)

local otherCopyOfMyModule = require(Workspace.MyModule)
```

### `jest.resetModules()`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestresetmodules)  ![Aligned](/img/aligned.svg)

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
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestfnimplementation)  ![Deviation](/img/deviation.svg)

Returns a new, unused [mock function](mock-function-api). Optionally takes a mock implementation.

`jest.fn()` returns a callable table as the first return value and a function as the second return value. See the [deviation](deviations#jestfn) note.

```lua
local mockFn = jest.fn()
mockFn()
expect(mockFn).toHaveBeenCalled()

-- With a mock implementation:
local returnsTrue = jest.fn(function() return true end)
print(returnsTrue()) -- true
```

### `jest.spyOn(object, methodName)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/28.x/jest-object#jestspyonobject-methodname)  ![Aligned](/img/aligned.svg)

Creates a mock function similar to `jest.fn` but also tracks calls to `object[methodName]`. Returns a Jest [mock function](MockFunctionAPI.md).

_Note: By default, `jest.spyOn` also calls the **spied** method. This is different behavior from most other test libraries. If you want to overwrite the original function, you can use `jest.spyOn(object, methodName):mockImplementation(function() ... end)` or `object[methodName] = jest.fn(function ... end)`_

Example:

```lua
local video = {
	play = function()
		return true
	end
}

return video
```

Example test:

```lua
local video = require(Workspace.video);

test("plays video", function()
  local spy = jest.spyOn(video, "play")
  local isPlaying = video.play()

  expect(spy).toHaveBeenCalled()
  expect(isPlaying).toBe(true)

  spy:mockRestore()
end)
```

:::info
The `jest.spyOn(object, methodName, accessType?)` variant is not currently supported in jest-roblox.
:::

### `jest.clearAllMocks()`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestclearallmocks)  ![Aligned](/img/aligned.svg)

Clears the `mock.calls`, `mock.instances` and `mock.results` properties of all mocks. Equivalent to calling [`.mockClear()`](mock-function-api#mockfnmockclear) on every mocked function.

This can be included in a `beforeEach()` block in your text fixture to clear out the state of all mocks before each test.

Returns the `jest` object for chaining.

### `jest.resetAllMocks()`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestresetallmocks)  ![Aligned](/img/aligned.svg)

Resets the state of all mocks. Equivalent to calling [`.mockReset()`](mock-function-api#mockfnmockreset) on every mocked function.

Returns the `jest` object for chaining.

<!-- ### `jest.restoreAllMocks()`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestrestoreallmocks)  ![Aligned](/img/aligned.svg)

TODO: need spyOn

Restores all mocks back to their original value. Equivalent to calling [`.mockRestore()`](mock-function-api#mockfnmockrestore) on every mocked function. Beware that `jest.restoreAllMocks()` only works when the mock was created with `jest.spyOn`; other mocks will require you to manually restore them. -->

## Mock Timers

### `jest.useFakeTimers()`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestusefaketimersimplementation-modern--legacy)  ![Deviation](/img/deviation.svg)

Instructs Jest Roblox to use fake versions of the standard Lua and Roblox timer functions.
The following timers are mocked:
* `delay`
* `tick`
* `time`
* `os`
    * `os.time`
	* `os.clock`
* `task.delay`
    * `task.delay`
	* `task.cancel`
	* `task.wait`
* `DateTime`

Returns the `jest` object for chaining.

### `jest.useRealTimers()`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestuserealtimers)  ![Aligned](/img/aligned.svg)

Instructs Jest Roblox to use the real versions of the standard timer functions.

Returns the `jest` object for chaining.

### `jest.runAllTimers()`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestrunalltimers)  ![Deviation](/img/deviation.svg)

Exhausts the **macro**-task queue (i.e., all tasks queued by `delay`).

When this API is called, all pending macro-tasks will be executed. If those tasks themselves schedule new tasks, those will be continually exhausted until there are no more tasks remaining in the queue.

This is often useful for synchronously executing `delay`s during a test in order to synchronously assert about some behavior that would only happen after the `delay` callbacks executed. See the [Timer mocks](timer-mocks) doc for more information.

### `jest.advanceTimersByTime(msToRun)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestadvancetimersbytimemstorun)  ![Aligned](/img/aligned.svg)

Executes only the macro task queue (i.e., all tasks queued by `delay`).

When this API is called, all timers are advanced by `msToRun` milliseconds. All pending "macro-tasks" that have been queued, and would be executed within this time frame will be executed. Additionally, if those macro-tasks schedule new macro-tasks that would be executed within the same time frame, those will be executed until there are no more macro-tasks remaining in the queue, that should be run within `msToRun` milliseconds.

### `jest.runOnlyPendingTimers()`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestrunonlypendingtimers)  ![Aligned](/img/aligned.svg)

Executes only the macro-tasks that are currently pending (i.e., all tasks queued by `delay`). If any of the currently pending macro-tasks schedule new macro-tasks, those new tasks will not be executed by this call.

This is useful for scenarios such as one where the module being tested schedules a `delay()` whose callback schedules another `delay()` recursively (meaning the scheduling never stops). In these scenarios, it's useful to be able to run forward in time by a single step at a time.

### `jest.advanceTimersToNextTimer(steps)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestadvancetimerstonexttimersteps)  ![Aligned](/img/aligned.svg)

Advances all timers by the needed seconds so that only the next timeouts/intervals will run.

Optionally, you can provide `steps`, so it will run `steps` amount of next timeouts/intervals.

### `jest.clearAllTimers()`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestclearalltimers)  ![Aligned](/img/aligned.svg)

Removes any pending timers from the timer system.

This means, if any timers have been scheduled (but have not yet executed), they will be cleared and will never have the opportunity to execute in the future.

### `jest.getTimerCount()`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestgettimercount)  ![Aligned](/img/aligned.svg)

Returns the number of fake timers still left to run.

### `jest.setSystemTime(now?: number | DateTime)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestsetsystemtimenow-number--date)  ![Aligned](/img/aligned.svg)

Set the current system time used by fake timers. Simulates a user changing the system clock while your program is running. It affects the current time but it does not in itself cause e.g. timers to fire; they will fire exactly as they would have done without the call to `jest.setSystemTime()`.

### `jest.getRealSystemTime()`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/jest-object#jestgetrealsystemtime)  ![Aligned](/img/aligned.svg)

When mocking time, `DateTime.now()` will also be mocked. If you for some reason need access to the real current time, you can invoke this function.

### `jest.setEngineFrameTime(frameTimeMs)`
![Roblox only](/img/roblox-only.svg)

`jest.setEngineFrameTime` sets the frame time, in milliseconds, by which all advance timer methods process timers. `frameTimeMs` must be a value greater than or equal to 0; by default, `frameTimeMs` is set to `0` (i.e. continuous time).

### `jest.getEngineFrameTime()`
![Roblox only](/img/roblox-only.svg)

`jest.getEngineFrameTime` gets the frame time by which timers are processed.

## Mock Globals

### `jest.globalEnv`
![Roblox only](/img/roblox-only.svg)

`jest.globalEnv` represents the function environment table of the current test.

You can use it with [`jest.spyOn()`](#jestspyonobject-methodname) in place of an
object, to mock the implementation of a function such as `print()` which lives
in the environment table.

You can also index into `globalEnv` to represent global libraries, such as
`jest.globalEnv.math`, which allows you to mock the implementation of library
functions such as `math.random()`.

Finally, functions from the original function environment are available as
members of `globalEnv`, for example, the original implementation of `print()`
(bypassing any current mocks) can be called via `jest.globalEnv.print()`.

:::warning

Jest Roblox does not support mocking all globals - only a few are whitelisted.
If you try to mock a global which is not whitelisted, you will see an error
message that looks similar to this:

```
Jest does not yet support mocking the require global.
```

Most notably, Jest Roblox does not support mocking these globals:

- `game:GetService()` and other Instance methods (an API for this is being investigated)
- the `require()` function (use [`jest.mock()`](jest-object) instead)
- task scheduling functions (use [Timer Mocks](timer-mocks) instead)

:::
