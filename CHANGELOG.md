# Jest Roblox Changelog

## Prerelease Changes
* Added jest-snapshot functionality
  * Added `toMatchSnapshot` matcher
  * Added `UPDATESNAPSHOT` flag for updating snapshots
* Removed colon syntax alias for initializing mock functions

## 1.1.2 (2021-06-11)
* :bug: Fix for `jest-snapshot` so that the init file returns a value

## 1.1.1 (2021-06-07)
* :bug: Fix in `getType` for objects with a throwing `__index` metamethod

## 1.1.0 (2021-05-28)
* Added `toStrictEqual` matcher
* :bug: Bugfix in `SpyMatchers` where function calls with `nil` arguments would not be handled correctly
* Changed the `ArrayContaining` asymmetric matcher to output curly braces instead of square brackets
* Added instantiating mock function instance with `mockFn.new()`
* Changed syntax for intializing mock functions from `jest:fn()` to `jest.fn()` (the colon syntax is left in for compatibility but will be removed in 2.0)
* `RegExp` is pulled out from the LuauPolyfill repo into a separate LuauRegExp repo and lazily loaded
* Added proper output formatting for Roblox `Instance` types

## 1.0.0 (2021-03-30)
* Added spyMatchers
```
expect().lastCalledWith() also aliased as expect().toHaveBeenLastCalledWith()
expect().lastReturnedWith() also aliased as expect().toHaveLastReturnedWith()
expect().nthCalledWith() also aliased as expect().toHaveBeenNthCalledWith()
expect().nthReturnedWith() also aliased as expect().toHaveNthReturnedWith()
expect().toBeCalled() also aliased as expect().toHaveBeenCalled()
expect().toBeCalledTimes() also aliased as expect().toHaveBeenCalledTimes()
expect().toBeCalledWith() also aliased as expect().toHaveBeenCalledWith()
expect().toReturn() also aliased as expect().toHaveReturned()
expect().toReturnTimes() also aliased as expect().toHaveReturnedTimes()
expect().toReturnWith() also aliased as expect().toHaveReturnedWith()
```

* Added basic jest-mock functionality
  * The `jest` object can be imported from `Globals` and has the following methods:
    * `.fn()`
    * `.clearAllMocks()`
    * `.resetAllMocks()`
    * `.restoreAllMocks()`

* Added `Error` type to `jest-get-type`
* :bug: Bugfix in `.toMatch` where strings go into the RegEx check
* :bug: Bugfix for `.toThrow` not matching `Error` object with same message

## 0.7.1 (2021-03-12)
* Added chalk-enabled error output
* Fix for checking for an `asymmetricMatch` method for objects that override `__index` metamethod ([#39](https://github.com/Roblox/jest-roblox/pull/39))
* Added `userdata` and `thread` Luau types to `jestGetType`

## 0.7.0 (2021-03-02)
* Added `expect.extend()`
* Added `RegExp` support to matchers
* Added prototype information to matchers

## 0.6.0 (2021-02-22)
* Added `expect().toThrow()`

## 0.5.0 (2021-01-29)
* Initial release of Jest Roblox. TestEZ has been rebranded as of this release.
* Added `expect` aligned to [Jest's expect (26.5.3)](https://jestjs.io/docs/en/26.5/expect).
  * Requires an explicit `require` from [`JestRoblox.Globals`](https://jestjs.io/docs/en/26.5/api) to use.
  * Refer to the Jest documentation on expect for usage documentation. Refer to the `README.md` in `src/Modules/expect` for details on deviations from upstream.
  * `expect` matchers added:
  ```
  expect().toBe()
  expect().toBeCloseTo()
  expect().toBeDefined()
  expect().toBeFalsy()
  expect().toBeGreaterThan()
  expect().toBeGreaterThanOrEqual()
  expect().toBeInstanceOf()
  expect().toBeLessThan()
  expect().toBeLessThanOrEqual()
  expect().toBeNan() (aliased as toBeNaN)
  expect().toBeNil() (aliased as toBeNull)
  expect().toBeTruthy()
  expect().toBeUndefined()
  expect().toContain()
  expect().toContainEqual()
  expect().toEqual()
  expect().toHaveLength()
  expect().toHaveProperty()
  expect().toMatch()
  expect().toMatchObject()
  ```
  * `asymmetricMatchers` added:
  ```
  expect.any()
  expect.anything()
  expect.arrayContaining()
  expect.arrayNotContaining()
  expect.objectContaining()
  expect.objectNotContaining()
  expect.stringContaining()
  expect.stringNotContaining()
  expect.stringMatching()
  expect.stringNotMatching()
  ```
  * Custom `asymmetricMatchers` for any objects with a `asymmetricMatch(self, other)` method.
  * Negative variants of all the above matchers with the keyword `never`, i.e. `expect().never.toBe()` or `expect.never.stringContaining()`.
  * TestEZ `expect` will be removed soon.

---

## TestEZ Changelog

## 0.4.1 (2020-10-30)
* `afterEach` blocks now run their code after `it` blocks fail or error

## 0.4.0 (2020-10-02)
* Added `expect.extend` which allows projects to register their own, opinionated expectations that integrates into `expect`. ([#142](https://github.com/Roblox/testez/pull/142))
  * Modeled after [jest's implementation](https://jestjs.io/docs/en/expect#expectextendmatchers).
  * Matchers are functions that should return an object with with two keys, boolean `pass` and a string `message`
  * Like `context`, matchers introduced via `expect.extend` will be present on all nodes below the node that introduces the matchers.
  * Limitations:
    * `expect.extend` cannot be called from within `describe` blocks
    * Custom matcher names cannot overwrite pre-existing matchers, including default matchers and matchers introduces from previous `expect.extend` calls.
* Change the way errors are collected to call tostring on them before further processing.
  * Luau allows non-string errors, but not concatenating non-strings or passing non-strings to `debug.traceback` as a message, so TestRunner needs to do that step. This is a temporary fix as the better solution would be to retain the error in object form for as long as possible to give the reporter more to work with.
  * This also makes a slight change to what's in the traceback to eliminate the unnecessary line mentioning the error collection function.
* Fix debugging of tests in Studio

## 0.3.3 (2020-09-25)
* Remove the lifecycle hooks from the session tree. This prevents the `[?]` spam from the reporter not recognizing these nodes.

## 0.3.2 (2020-08-10)
* Some cleanup of the TestEZ CLI internals
* Added the ability to pass in a string to expect.to.throw. This will search the error message for a matching substring and report a failure if it's not there.

## 0.3.1 (2020-06-22)
* Further simplify `beforeAll` handling.
  * `beforeAll` now runs on entering the block, rather than on the first `it` encountered after entering the block. The major difference for the moment is that a `beforeAll` will now run even if there are no `it` blocks under it, which is now consistent with how `afterAll` worked.
  * `beforeAll` and `afterAll` now report errors by creating a dummy node in the results to contain the error. Previously, errors in `afterAll` were not reported.
  * A failure in a `beforeAll` block will now halt all further test execution within its enclosing `describe` block except for any remaining `beforeAll` blocks and any `afterAll` blocks. Multiple `beforeAll` or `afterAll` blocks within one `describe` block should not count on running in any specific order. `afterAll` blocks should account for the possibility of a partially setup state when cleaning up.
* Add a context object visible from lifecycle hooks and `it` blocks. This is a write-once store for whatever you need to communicate between hooks and tests. It can be ignored until you need it.
  * In particular, you can usually just use upvalues to comminucate between hooks and tests, but that won't work if your hooks are in a separate file (e.g. `init.spec.lua`).
  * Also, this provides a cleaner alternative to extraEnvironment for passing along helper functions to large numbers of tests as the context can be scoped to particular directories as needed.

## 0.3.0 (2020-06-12)
* Remove the `try` node type.
  * Remove the `step` alias for `it` since that's meant for use with `try`.
* Remove the `include` global function.
* Remove `HACK_NO_XPCALL`. With recent changes to the definition of xpcall, this is no longer necessary. Since people are still using it, it will now print out a warning asking them to delete that call instead.
* Major changes to the internals of test planning.
  * The major visible change is that `describe` and `it` blocks with duplicate descriptions will now not overwrite the earlier copies of those nodes.
  * Duplicate `it` nodes within one `describe` will raise an error.
  * TestPlanBuilder was removed from the API.
* Fixed a bug with how `beforeAll` and `afterAll` handled nested nodes.
* Implemented alphabetical sorting of the entire test tree which provides deterministic tests execution order regardless of platform, architecture or tool used to load tests.
* Fixed interactions with roblox-cli in TestEZ CLI.

## 0.2.0 (2020-03-04)
* Added support for init.spec.lua. Code in this file is treated as belonging to the directory's node in the test tree. This allows for lifecycle hooks to be attached to all files in a directory.
* Added TestEZ CLI, a Rust tool that bundles TestEZ and Lemur, and can run tests via Lemur or Roblox-CLI ([#61](https://github.com/Roblox/testez/pull/61))

## 0.1.1 (2020-01-23)
* Added beforeAll, beforeEach, afterEach, afterAll lifecycle hooks for testing
	* The setup and teardown behavior of these hooks attempt to reach feature parity with [jest](https://jestjs.io/docs/en/setup-teardown).


## 0.1.0 (2019-11-01)
* Initial release.
