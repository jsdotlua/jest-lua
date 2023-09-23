# Jest Roblox Docs

The Jest Roblox API is similar to [the API used by JavaScript Jest.](https://jestjs.io/docs/27.x/api)

# Usage

Jest Roblox doesn't inject any global variables. Every jest functionality needs to be imported from `JestGlobals`. For example:

```lua
local JestGlobals = require(Packages.Dev.JestGlobals)

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local test = JestGlobals.test
```

The above code is equivalent to JavaScript's:

```js
import {describe, expect, test} from '@jest/globals'.
```

# [Methods](https://jestjs.io/docs/27.x/api#methods)

## [Expect](https://jestjs.io/docs/27.x/expect)

There are two variations of `expect` in `jest-roblox`:
#### `expect`
This is strictly typed and is used with built in Jest matchers. For example:

```lua
-- ... JestGlobals, test defined prior to this
local expect = JestGlobals.expect


test('some test', function()
  local foo;

  expect(1).toBe(1) -- toBe is a built-in Jest matcher
  expect(foo).toBeDefined() -- toBeDefined is a built-in Jest matcher
end)
```

#### `expectExtended`

This is loosely typed and is meant to be used with custom matchers. For example:

```lua
-- ... JestGlobals, test defined prior to this
local expectExtended = JestGlobals.expectExtended

-- extending expect to support our custom matcher `toBeEmptyString`
expectExtended.extend({
    toBeEmptyString = function(self, received: unknown, expected: unknown, options: OptionsReceived?)
        -- dummy implementation
        local pass = received == ""
        local message = if pass
            then ("%s is an empty string"):format(received)
            else ("%s is an NOT empty string"):format(received)
        return { actual = received, message = message, pass = pass }
    end,
})
test("some test", function()
    local foo

    expectExtended(foo).toBeEmptyString() -- toBeEmptyString is a custom Jest matcher
end)
```
In this case, since we are using a custom matcher `toBeEmptyString()`, if we had used the normal `expect` from `JestGlobals.expect`, then `roblox-analyze` would have thrown errors because of type issues.

> **Note**
In converted code (ie. code converted by the JS to Lua tool), we often import `expectExtended` and assign it to a variable `expect` in order to reduce the amount of deviations in the file. We also mark this import as a deviation. Here's an example of such a situation:
```lua
-- ... JestGlobals, test defined prior to this
-- ROBLOX deviation START: importing expectExtended to avoid analyze errors for additional matchers
local expect = JestGlobals.expectExtended
-- ROBLOX deviation END

test('some test', function()
  local foo;

-- in this case, we get to preserve the originally converted code which uses `expect` by simply assigning `expectExtended` to `expect`
  expect(foo).toBeEmptyString()
end)
test('another test', function()
  local bar = "fizz";

-- in this case, we get to preserve the originally converted code which uses `expect` by simply assigning `expectExtended` to `expect`
  expect(bar).toBeEmptyString()
end)
```

**Using both `expect` and `expectExtended`**
In a manually written file where there are both tests that use both built-in and custom matchers, it may not be possible to simply re-assign `expectExtended` to a variable named `expect` since this would mean losing type safety for built-in matchers.

In such a case, we opt for having two imports and using either `expect` or `expectExtended` depending on whether we are using built-in matchers or custom matchers.

Example:
```lua
-- ... JestGlobals, test defined prior to this
local expect = JestGlobals.expect
local expectExtended = JestGlobals.expectExtended

test('test using built-in matcher - uses expect', function()
  local foo;

  expect(foo).toBe(nil)
end)
test('test using custom matcher - uses expectExtended', function()
  local bar = "fizz";

  expectExtended(bar).toBeEmptyString()
end)
```

This way, we can preserve the type-safety that comes with `expect` for built-in matchers and take advantage of the flexibility and extensibility that `expectExtended` provides when using custom matchers.

**TL;DR - When to use `expect` vs `expectExtended`**
- When writing your own tests, if you are using built-in Jest matchers, then you should use `expect`.
- If you are using custom matchers, you should use `expectExtended`

### Supported

> **Note:** `.not` is renamed to `.never` to avoid collision with Lua reserved key word. `expect` and `expectExtended` can also be swapped out with each other in the below examples. The differences between the two has been covered above.

- `expect(value)`
- `expect.extend(matchers)`
- `expect.anything()`
- `expect.any(constructor)`
- `expect.nothing()`

- `expect.never`
- `expect.arrayContaining`
- `expect.arrayNotContaining` - **deviation: equivalent to `expect.not.arrayContaining`**
- `expect.objectContaining`
- `expect.objectNotContaining` - **deviation: equivalent to `expect.not.objectContaining`**
- `expect.stringContaining`
- `expect.stringNotContaining` - **deviation: equivalent to `expect.not.stringContaining`**
- `expect.stringMatching`
- `expect.stringNotMatching` - **deviation: equivalent to `expect.not.stringMatching`**
- `expect.addSnapshotSerializer`
- `expect.getState`
- `expect.setState`
- `.never` - **deviation: used in place of `.not`**
- `.toBe(value)`
- `.toBeCloseTo(number, numDigits?)`
- `.toBeDefined()`
- `.toBeFalsy()`
- `.toBeGreaterThan(number)`
- `.toBeGreaterThanOrEqual(number)`
- `.toBeInstanceOf`
- `.toBeLessThan(number)`
- `.toBeLessThanOrEqual(number)`
- `.toBeNan()` - Alias for `.toBeNaN`
- `.toBeNaN()`
- `.toBeNil()`
- `.toBeNull()` - Alias for `.toBeNil`
- `.toBeTruthy()`
- `.toBeUndefined()` - Alias for `.toBeNil`
- `.toContain(item)`
- `.toContainEqual(item)`
- `.toEqual(value)`
- `.toHaveLength(number)`
- `.toHaveProperty(keyPath, value?)`
- `.toMatch(regexp | string)`
- `.toMatchInstance(instance)` - **deviation: Roblox only (matches on Roblox `Instance`)**
- `.toMatchObject(object)`
- `.toMatchSnapshot(propertyMatchers?, hint?)`
- `.toStrictEqual(value)`
- `.toBeCalled()`
- `.toBeCalledTimes(number)`
- `.toBeCalledWith(nthCall, arg1, arg2, ...)`
- `.toHaveBeenCalled()`
- `.toHaveBeenCalledTimes(number)`
- `.toHaveBeenCalledWith(arg1, arg2, ...)`
- `.toHaveBeenLastCalledWith(arg1, arg2, ...)`
- `.toHaveBeenNthCalledWithtoHaveBeenNthCalledWith(nthCall, arg1, arg2, ...)`
- `.toHaveLastReturnedWith(value)`
- `.toHaveNthReturnedWith(nthCall, value)`
- `.toHaveReturned()`
- `.toHaveReturnedTimes(number)`
- `.toHaveReturnedWith(value)`
- `.toReturn()`
- `.toReturnTimes(number)`
- `.toReturnWith(value)`
- `.toThrow()`
- `.toThrowError(error)`
- `.toThrowErrorMatchingSnapshot(hint?)`

### Not supported

- ~~`expect.closeTo(number, numDigits?) `~~
- ~~`expect.hasAssertions()`~~
- ~~`.resolves`~~
- ~~`.rejects`~~
- ~~`.toMatchInlineSnapshot(propertyMatchers?, inlineSnapshot)`~~
- ~~`.toThrowErrorMatchingInlineSnapshot(inlineSnapshot)`~~
- ~~`expect.assertions(number)`~~

## [Each](https://jestjs.io/docs/27.x/api#describeeachtablename-fn-timeout)

Tagged templates are not available in Lua. As an alternative, a headings string must be used with a list of arrays containing the same amount of items as headings.
Eg:

```lua
each({
  { 0, 1, 1 },
  { 1, 1, 2 }
})("returns $expected when given $a and $b",
    function(ref)
        local a: number, b: number, expected = ref.a, ref.b, ref.expected
        jestExpect(a + b).toBe(expected)
    end
)
```

## [Concurrent](https://jestjs.io/docs/27.x/api#testconcurrentname-fn-timeout)

Concurrent methods are **NOT** supported ATM:

- `test.concurrent(name, fn, timeout)`
- `test.concurrent.each(table)(name, fn, timeout)`
- `test.concurrent.only.each(table)(name, fn)`
- `test.concurrent.skip.each(table)(name, fn)`

## [Async tests](https://jestjs.io/docs/27.x/api#testname-fn-timeout)

Adjusted note:

> Note: If a promise is returned from test, Jest will wait for the promise to resolve before letting the test complete. Jest will also wait if you provide a **2nd** argument to the test function, usually called done. This could be handy when you want to test callbacks. See how to test async code [here](https://jestjs.io/docs/27.x/asynchronous#callbacks).

# [The Jest Object](https://jestjs.io/docs/27.x/jest-object)

## Methods

### [Mock modules](https://jestjs.io/docs/27.x/jest-object#mock-modules)

#### Supported

- `jest.resetModules()`
- `jest.isolateModules(fn)`
- `jest.mock(moduleName, factory, options)`
- `jest.unmock(moduleName)`
- `jest.requireActual(moduleName)`

#### Not supported

- ~~`jest.disableAutomock()`~~
- ~~`jest.enableAutomock()`~~
- ~~`jest.createMockFromModule(moduleName)`~~
- ~~`jest.doMock(moduleName, factory, options)`~~
- ~~`jest.dontMock(moduleName)`~~
- ~~`jest.setMock(moduleName, moduleExports)`~~
- ~~`jest.requireMock(moduleName)`~~

### Mock timers

#### Supported

- `jest.useFakeTimers()`
- `jest.useRealTimers()`
- `jest.runAllTimers()`
- `jest.runOnlyPendingTimers()`
- `jest.clearAllTimers()`
- `jest.advanceTimersByTime(msToRun: number)`
- `jest.advanceTimersToNextTimer(steps: number?)`
- `jest.getTimerCount()`
- `jest.setSystemTime(now: (number | DateTime)?)`
- `jest.getRealSystemTime()`

#### Not supported

- ~~`jest.runAllTicks()`~~
- ~~`jest.runAllImmediates()`~~

### [Mock functions](https://jestjs.io/docs/27.x/mock-function-api)

#### Supported

- `mockFn.getMockName()`
- `mockFn.mock.calls `
- `mockFn.mock.results`
- `mockFn.mock.instances`
- `mockFn.mock.lastCall`
- `mockFn.mockClear()`
- `mockFn.mockReset()`
- `mockFn.mockRestore()`
- `mockFn.mockImplementation(fn)`
- `mockFn.mockImplementationOnce(fn)`
- `mockFn.mockName(value)`
- `mockFn.mockReturnThis()`
- `mockFn.mockReturnValue(value) `
- `mockFn.mockReturnValueOnce(value)`

#### Not supported

- ~~`jest.isMockFunction(fn)`~~ - **Note** this can be easily added
- ~~`jest.spyOn(object, methodName)`~~ - **Note** `spyOn` is a feature that we need and have created a workarounds for now
- ~~`jest.spyOn(object, methodName, accessType?)`~~
- ~~`jest.mocked<T>(item: T, deep = false)`~~
- ~~`mockFn.mockResolvedValue(value)`~~
- ~~`mockFn.mockResolvedValueOnce(value)`~~
- ~~`mockFn.mockRejectedValue(value)`~~
- ~~`mockFn.mockRejectedValueOnce(value)`~~
- ~~`jest.MockedFunction`~~-
- ~~`jest.MockedClass`~~

### Misc

#### Supported

- ~~`jest.setTimeout(timeout)`~~

#### Not supported

- ~~`jest.retryTimes()`~~

## [Configuring Jest](https://jestjs.io/docs/27.x/configuration)

Configuration only available via project's `jest.config.lua` file. This file needs to be placed in the `src` directory (or directly in `Workspace` (see `WorkspaceStatic` directory mapping in `jest.project.json`))

```lua
-- Sync object
local config = {
    verbose = true,
}

return config

-- Or async function
return Promise.resolve():andThen(function()
    return {
        verbose = true,
    }
end)
```

## Options

These correspond to JS Jest options

### Supported

> **deviation: type** means that the option's type deviates from the original upstream types

- `clearMocks` [boolean]
- `displayName` [string, object]

- `projects` [array<Instance>] **deviation: type**

- `restoreMocks` [boolean]
- `rootDir` [Instance] **deviation: type**
- `roots` [array<Instance>] **deviation: type**

- `setupFiles` [array<ModuleScript>] **deviation: type**
- `setupFilesAfterEnv` [array<ModuleScript>] **deviation: type**
- `slowTestThreshold` [number]
- `snapshotSerializers` [array<ModuleScript>] **deviation: type**

- `testFailureExitCode` [number]
- `testMatch` [array<string>]
- `testPathIgnorePatterns` [array<string>]
- `testRegex` [string | array<string>]
- `testTimeout` [number]

- `verbose` [boolean]

### To be supported

- `globalSetup` [string] **Not supported YET**
- `globalTeardown` [string] **Not supported YET**

### Not supported

ref: https://jestjs.io/docs/27.x/configuration#options

- ~~`automock` [boolean]~~
- ~~`bail` [number | boolean]~~
- ~~`cacheDirectory` [string]~~
- ~~`collectCoverage` [boolean]~~
- ~~`collectCoverageFrom` [array]~~
- ~~`coverageDirectory` [string]~~
- ~~`coveragePathIgnorePatterns` [array<string>]~~
- ~~`coverageProvider` [string]~~
- ~~`coverageReporters` [array<string | [string, options]>]~~
- ~~`coverageThreshold` [object]~~
- ~~`dependencyExtractor` [string]~~
- ~~`errorOnDeprecated` [boolean]~~
- ~~`extensionsToTreatAsEsm` [array<string>]~~
- ~~`extraGlobals` [array<string>]~~
- ~~`forceCoverageMatch` [array<string>]~~
- ~~`globals` [object]~~
- ~~`haste` [object]~~
- ~~`injectGlobals` [boolean]~~
- ~~`maxConcurrency` [number]~~
- ~~`maxWorkers` [number | string]~~
- ~~`moduleDirectories` [array<string>]~~
- ~~`moduleFileExtensions` [array<string>]~~
- ~~`moduleNameMapper` [object<string, string | array<string>>]~~
- ~~`modulePathIgnorePatterns` [array<string>]~~
- ~~`modulePaths` [array<string>]~~
- ~~`notify` [boolean]~~
- ~~`notifyMode` [string]~~
- ~~`preset` [string]~~
- ~~`prettierPath` [string]~~
- ~~`reporters` [array<moduleName | [moduleName, options]>]~~
- ~~`resetMocks` [boolean]~~
- ~~`resetModules` [boolean]~~
- ~~`resolver` [string]~~
- ~~`runner` [string]~~
- ~~`snapshotFormat` [object]~~
- ~~`snapshotResolver` [string]~~
- ~~`testEnvironment` [string]~~
- ~~`testEnvironmentOptions` [Object]~~
- ~~`testResultsProcessor` [string]~~
- ~~`testRunner` [string]~~
- ~~`testSequencer` [string]~~
- ~~`testURL` [string]~~
- `timers` [string] **NOTE: not sure about this**
- ~~`transform` [object<string, pathToTransformer | [pathToTransformer, object]>]~~
- ~~`transformIgnorePatterns` [array<string>]~~
- ~~`unmockedModulePathPatterns` [array<string>]~~
- ~~`watchPathIgnorePatterns` [array<string>]~~
- ~~`watchPlugins` [array<string | [string, Object]>]~~
- ~~`watchman` [boolean]~~

## [Jest CLI options](https://jestjs.io/docs/27.x/cli)

**TBD**

## [Environment variables](https://jestjs.io/docs/27.x/environment-variables)

## [Code transformation](https://jestjs.io/docs/27.x/code-transformation)

# Docs

## [Getting started](https://jestjs.io/docs/27.x/getting-started)

## [Using Matchers](https://jestjs.io/docs/27.x/using-matchers)

Should be the same taking into account [not supported matchers](#expect)

## [Testing Asynchronous Code](https://jestjs.io/docs/27.x/asynchronous)

### [Promises](https://jestjs.io/docs/27.x/asynchronous#promises)

Tests can return a [Promise](https://github.com/evaera/roblox-lua-promise) and Jest Roblox will wait for the promise to resolve.

> **Note:** It is also worth noting that tests can ONLY return either a `Promise` or `nil`.

### [Callbacks](https://jestjs.io/docs/27.x/asynchronous#callbacks)

Jest Roblox supports `done` callback as a second param to the test function
eg.

```lua
test("the data is peanut butter", function(_ctx, done)
  function callback(error_, data)
    if error_
      done(error_);
      return
    end
    xpcall(function()
      expect(data).toBe('peanut butter');
      done();
    end, function(err)
      done(err)
    end)
  end

  fetchData(callback)
end);
```

### [.resolves / .rejects](https://jestjs.io/docs/27.x/asynchronous#resolves--rejects)

**NOT SUPPORTED YET**

## [Setup and Teardown](https://jestjs.io/docs/27.x/setup-teardown)

**TODO**

## [Mock functions](https://jestjs.io/docs/27.x/mock-functions)

## [Jest Platform](https://jestjs.io/docs/27.x/jest-platform)
