# Jest Roblox Changelog

## Unreleased

## 3.3.0 (2022-04-26)
* :sparkles: `pretty-format`: Added `printInstanceDefaults` formatting option that toggles whether unmodified Instance properties are printed ([#341](https://github.com/Roblox/jest-roblox/pull/341))
* :sparkles: Added `snapshotFormat` configuration option ([#341](https://github.com/Roblox/jest-roblox/pull/341))
* :sparkles: Added support for a configurable engine frame time for fake timers ([#343](https://github.com/Roblox/jest-roblox/pull/343))

## 3.2.5 (2022-01-19)
* :bug: Fix error when obsolete snapshots and no file system access ([#334](https://github.com/Roblox/jest-roblox/pull/334))

## 3.2.4 (2022-01-13)
* :bug: Fix separateMessageFromStack not working when there is no stack available ([#332](https://github.com/Roblox/jest-roblox/pull/332))

## 3.2.3 (2022-01-12)
* :bug: Fix missing stacktraces when throwing bare strings ([#324](https://github.com/Roblox/jest-roblox/pull/324))
* :bug: Fix bad error message when test contains syntax error ([#326](https://github.com/Roblox/jest-roblox/pull/326))
* :bug: Fix setTimeout not mocked with useFakeTimers() ([#329](https://github.com/Roblox/jest-roblox/pull/329))

## 3.2.2 (2022-01-04)
* :bug: Fix debugging capabilities broken recently ([#325](https://github.com/Roblox/jest-roblox/pull/325))

## 3.2.1 (2022-12-08)
* :bug: Fix `loadmodule` environment table separation ([#320](https://github.com/Roblox/jest-roblox/pull/320))

## 3.2.0 (2022-12-06)
* :sparkles: Added `jest.mock` and `jest.unmock` ([#243](https://github.com/Roblox/jest-roblox/pull/243))
* :sparkles: Added `jest.requireActual`([#294](https://github.com/Roblox/jest-roblox/pull/294))
* :sparkles: Jest runner caches loaded module functions to improve runtime ([#317](https://github.com/Roblox/jest-roblox/pull/317))
* :bug: Fixes error when no config is provided ([#314](https://github.com/Roblox/jest-roblox/pull/314))
* :hammer_and_wrench: Realigned packages
  * `jest-runtime` ([#281](https://github.com/Roblox/jest-roblox/pull/281))
  * `jest-config` ([#297](https://github.com/Roblox/jest-roblox/pull/297))
  * `jest-core` ([#299](https://github.com/Roblox/jest-roblox/pull/299)) ([#304](https://github.com/Roblox/jest-roblox/pull/304))
  * `expect` ([#309](https://github.com/Roblox/jest-roblox/pull/299))

## 3.1.1 (2022-11-1)
* :bug: Fix `require` throwing on ModuleScripts that `return nil` and not throwing on ModuleScripts that return multiple values [#292](https://github.com/Roblox/jest-roblox/pull/292)

## 3.1.0 (2022-10-26)

* :bug: Fix typing for expect matchers [#271](https://github.com/Roblox/jest-roblox/pull/271)
* :sparkles: export additional `expectExtended` from `JestGlobals` to allow use of custom matchers [#271](https://github.com/Roblox/jest-roblox/pull/271)
* :sparkles: Added support for `expect.resolves` and `expect.rejects` [#262](https://github.com/Roblox/jest-roblox/pull/262)
* :sparkles: Remove the need for `return {}` for test files [#279](https://github.com/Roblox/jest-roblox/pull/279)

## 3.0.0 (2022-09-30)

* :sparkles: Added `expect.assertions(number)` and `expect.hasAssertions()` functions ([#256](https://github.com/Roblox/jest-roblox/pull/256))

## 3.0.0 rc 1 (2022-09-23)
* :rotating_light: `jest.resetSnapshotSerializer` removed ([#253](https://github.com/Roblox/jest-roblox/pull/253))
* :bug: Fix `PrettyFormatPluginError` not throwing on invalid plugins ([#250](https://github.com/Roblox/jest-roblox/pull/250))
* :bug: Fix `snapshotSerializers` config option not working ([#251](https://github.com/Roblox/jest-roblox/pull/251))
* :bug: Fix crash when no tests are discovered ([#252](https://github.com/Roblox/jest-roblox/pull/252))
* :bug: Fix `testPathIgnorePatterns` config option crashing ([#259](https://github.com/Roblox/jest-roblox/pull/259))

## 3.0.0 rc 0 (2022-09-09)

* :sparkles: Added `task.delay()` and `time()` as fake timers ([#242](https://github.com/Roblox/jest-roblox/pull/242))
* :bug: Fix test result message for failing test ([#237](https://github.com/Roblox/jest-roblox/pull/237))
* :bug: Fix `testNamePattern` config value ([#232](https://github.com/Roblox/jest-roblox/pull/232))
* :bug: Fix `.each` for template syntax ([#246](https://github.com/Roblox/jest-roblox/pull/246))
* :hammer_and_wrench: Update LuauPolyfill to [v1.0.0](https://github.com/Roblox/luau-polyfill/blob/v1.0.0/CHANGELOG.md#100) ([#237](https://github.com/Roblox/jest-roblox/pull/237))
* :hammer_and_wrench: Update Roact to [v17.0.1-rc.16](https://github.com/Roblox/roact-alignment/tree/v17.0.1-rc.16) ([#237](https://github.com/Roblox/jest-roblox/pull/237))
* :hammer_and_wrench: Explicitly license files ([#235](https://github.com/Roblox/jest-roblox/pull/235))

## 3.0.0 alpha 0 (2022-08-11)

* :sparkles: Port `jest-config` ([#203](https://github.com/Roblox/jest-roblox/pull/203))
* :sparkles: Port `jest-core` ([#203](https://github.com/Roblox/jest-roblox/pull/203))
* :sparkles: Port `jest-validate` ([#203](https://github.com/Roblox/jest-roblox/pull/203))
* :hammer_and_wrench: Adjust other modules to work with `jest-core` ([#203](https://github.com/Roblox/jest-roblox/pull/203))
* :hammer_and_wrench: Update LuauPolyfill to [v0.4.1](https://github.com/Roblox/luau-polyfill/blob/v0.4.1/CHANGELOG.md#041) ([#215](https://github.com/Roblox/jest-roblox/pull/215))
* :hammer_and_wrench: Update Roact to [v17.0.1-rc.13](https://github.com/Roblox/roact-alignment/tree/v17.0.1-rc.13) ([#215](https://github.com/Roblox/jest-roblox/pull/215))
* :hammer_and_wrench: Update Picomatch to [v0.3.0](https://github.com/Roblox/picomatch-lua/blob/v0.3.0/CHANGELOG.md#030) ([#215](https://github.com/Roblox/jest-roblox/pull/215))

## 2.5.0 alpha 0 (2022-06-30)
* :sparkles: Port `jest-runner` ([#197](https://github.com/Roblox/jest-roblox/pull/197))
* :sparkles: Port `jest-runtime` ([#178](https://github.com/Roblox/jest-roblox/pull/178))
* :sparkles: Create `jest-environment-luau`, based on `jest-environment-node` ([#197](https://github.com/Roblox/jest-roblox/pull/197))
* :hammer_and_wrench: Add integration test of ported libraries, using jest's runner to run tests. ([#197](https://github.com/Roblox/jest-roblox/pull/197))

## 2.4.1 (2022-05-20)
* :hammer_and_wrench: Disable `chalk-lua` when running in Studio environment
* :hammer_and_wrench: Extract `AssertionError` to `LuauPolyfill` ([#186](https://github.com/Roblox/jest-roblox/pull/185]))
* :bug: Fix custom throwing matchers failing when throwing strings ([#186](https://github.com/Roblox/jest-roblox/pull/186))
* :bug: Fix Jest reporters not reporting test failure to `TestService` ([#188](https://github.com/Roblox/jest-roblox/pull/188))

## 2.4.0 (2022-05-18)
* :sparkles: Added adapters for Jest reporters ([#179](https://github.com/Roblox/jest-roblox/pull/179))
  * Added ability to pipe together reporters
* :sparkles: Added ReactTestComponent serializer ([#174](https://github.com/Roblox/jest-roblox/pull/174))
* :sparkles: Added React element serializer ([#170](https://github.com/Roblox/jest-roblox/pull/170))
* :sparkles: Port `jest-reporters` ([#167](https://github.com/Roblox/jest-roblox/pull/167))
* :sparkles: Port `jest-console` ([#157](https://github.com/Roblox/jest-roblox/pull/157))
* :sparkles: Port `jest-test-result` ([#155](https://github.com/Roblox/jest-roblox/pull/155))
* :sparkles: Port `jest-types` ([#137](https://github.com/Roblox/jest-roblox/pull/137))
* :sparkles: Realigned package versions to v27.4.7 ([#135](https://github.com/Roblox/jest-roblox/pull/135))
* :sparkles: Port `jest-environment` ([#139](https://github.com/Roblox/jest-roblox/pull/139))
* :sparkles: Port `jest-each` ([#145](https://github.com/Roblox/jest-roblox/pull/145) [#158](https://github.com/Roblox/jest-roblox/pull/158))
  * Support array like tables
  * Support template like tables
* :sparkles: Port `jest-util` and `picomatch` ([#144](https://github.com/Roblox/jest-roblox/pull/144) [#154](https://github.com/Roblox/jest-roblox/pull/154))
* :bug: Clean up assertion errors warning ([#181](https://github.com/Roblox/jest-roblox/pull/181))
* :hammer_and_wrench: Apply `stylua` to the whole repo and enable check on CI ([#147](https://github.com/Roblox/jest-roblox/pull/147))

## 2.3.1 (2021-11-30)
* :bug: Fix error reporters not outputting captured errors when using non-default reporters ([#131](https://github.com/Roblox/jest-roblox/pull/131))

## 2.3.0 (2021-11-19)
* :sparkles: Added support for Roblox Instance objects ([#127](https://github.com/Roblox/jest-roblox/pull/127))
  * Added object serialization for Instances
  * Added `.toMatchInstance` matcher to match against Instances
  * `.toMatchSnapshot` now serializes and matches against Instances
* :hammer_and_wrench: `jest.fn()` additionally returns a forwarding function for tests that require a mock to be a function
* :hammer_and_wrench: Test reporter is now colorized and reports name of the failing test ([#126](https://github.com/Roblox/jest-roblox/pull/126))
* :bug: Fix for a bug with throwing matchers and the `Error` polyfill in `roact-alignment` ([#128](https://github.com/Roblox/jest-roblox/pull/128))

## 2.2.1 (2021-10-20)
* :bug: Check that thrown message is a string when matching against a thrown string ([#124](https://github.com/Roblox/jest-roblox/pull/124))

## 2.2.0 (2021-10-18)
* :sparkles: Introduced strong Luau typing ([#102](https://github.com/Roblox/jest-roblox/pull/102))
* :sparkles: Realigned package versions ([#102](https://github.com/Roblox/jest-roblox/pull/102))
  * `diff-sequences` realigned to v27.2.5
  * `jest` realigned to v27.2.5
  * `jest-diff` realigned to v27.2.5
  * `jest-fake-timers` realigned to v27.0.6
  * `jest-matcher-utils` realigned to v27.2.5
  * `jest-snapshot` realigned to v27.0.6
* :bug: Fix for `expect.any` not working with Roblox datatypes ([#119](https://github.com/Roblox/jest-roblox/pull/119))
* :bug: Lazy initialize `game:GetService` calls to avoid throwing in debugger ([#122](https://github.com/Roblox/jest-roblox/pull/122))
* :bug: Fix missing stacktrace entries in nested pcalls ([#121](https://github.com/Roblox/jest-roblox/pull/121))

## 2.1.4 (2021-09-30)
* :sparkles: Added support and better output for [Roblox datatypes](https://developer.roblox.com/en-us/api-reference/data-types) ([#117](https://github.com/Roblox/jest-roblox/pull/117))

## 2.1.3 (2021-09-22)
* :hammer_and_wrench: Bump `LuauPolyfill` to `0.2.5` to fix static analysis issues on `lua-apps`

## 2.1.2 (2021-09-16)
* :hammer_and_wrench: Bump `RegExp` to `0.1.3` and `LuauPolyfill` to `0.2.4` to remove test files from cached versions
* :hammer_and_wrench: Republish with rotriever `0.5.0-rc.4` to remove tests from rotriever cache 
* :hammer_and_wrench: Add typing for `RegExp`

## 2.1.1 (2021-09-03)
* :bug: Resolve dependency cycle in `JestSnapshot` and `Expect`

## 2.1.0 (2021-09-03)
* :sparkles: Changed project structure to use rotriever `0.5.0` workspaces ([#96](https://github.com/Roblox/jest-roblox/pull/96))
  * This allows downstream projects to pull individual `JestRoblox` packages as dependencies
  * For example, to pull the `JestDiff` package as a dependency:
  ```
  JestDiff = "github.com/roblox/jest-roblox@2.1.0"

  local JestDiff = require(Packages.JestDiff)
  ```
* :rotating_light: Due of the above change, `JestRoblox` is now used by pulling the `JestGlobals` package in your `rotriever.toml`:
  * Change your `rotriever.toml` dependency to
  ```diff
  + JestGlobals = "github.com/roblox/jest-roblox@2.1.0"
  - JestRoblox = "github.com/roblox/jest-roblox@2.0.1"
  ```
  * Now that the dependency is `JestGlobals`, you no longer need to get the `Globals` member of `JestRoblox`
  ```diff
  + local JestGlobals = require(Packages.JestGlobals)
  + local expect = JestGlobals.expect
  - local JestRoblox = require(Packages.JestRoblox).Globals
  - local expect = JestRoblox.expect
  ```
* :hammer_and_wrench: Support for named functions in error output ([#95](https://github.com/Roblox/jest-roblox/pull/95))
* :hammer_and_wrench: Support for `LuauPolyfill` `Set` object in matchers ([#101](https://github.com/Roblox/jest-roblox/pull/101))
* :hammer_and_wrench: Remove unhelpful lines in error stacktraces ([#105](https://github.com/Roblox/jest-roblox/pull/105))
* :bug: Fix for snapshot property matchers not working ([#93](https://github.com/Roblox/jest-roblox/pull/93))
* :bug: Fix snapshot path resolution for snapshot updates on windows ([#97](https://github.com/Roblox/jest-roblox/pull/97))
* :bug: Fix for `JestSnapshot` throwing in environments where `FileSystemService` does not exist ([#103](https://github.com/Roblox/jest-roblox/pull/103))
* :bug: Fix for snapshot names with special characters  ([#108](https://github.com/Roblox/jest-roblox/pull/108))

## 2.0.1 (2021-08-04)
* :bug: Fix for snapshot matchers not correctly throwing when the matcher fails ([#92](https://github.com/Roblox/jest-roblox/pull/92))

## 2.0.0 (2021-08-02)
* :sparkles: Added `JestSnapshot` functionality
  * Added `toMatchSnapshot` matcher
  * Added `toThrowErrorMatchingSnapshot` matcher
  * Added custom snapshot matchers and property matchers, refer to the "Snapshot Testing" section of the documentation for more info
  * Added `UPDATESNAPSHOT` flag for updating snapshots, the value can either be `all` (by default), or `new` to only add new snapshots, this can be enabled with an `--updateSnapshot` flag in Jest Roblox CLI
* :rotating_light: Removed colon syntax alias for initializing mock functions
* :hammer_and_wrench: `--fastFlags.overrides "UseDateTimeType3=true"` removed as it is no longer needed
* :bug: Fix issue with CoreScriptConverter and the Modules directory ([#79](https://github.com/Roblox/jest-roblox/pull/79))
* :bug: Fix for chalked strings throwing when used with string matchers ([#85](https://github.com/Roblox/jest-roblox/pull/85))
* :bug: `.toThrow` matchers now recognize `jest.fn` as callable ([#87](https://github.com/Roblox/jest-roblox/pull/87))

## 1.1.2 (2021-06-11)
* :bug: Fix for `JestSnapshot` so that the init file returns a value ([#71](https://github.com/Roblox/jest-roblox/pull/71))

## 1.1.1 (2021-06-07)
* :bug: Fix in `getType` for objects with a throwing `__index` metamethod ([#69](https://github.com/Roblox/jest-roblox/pull/69))

## 1.1.0 (2021-05-28)
* :sparkles: Added `toStrictEqual` matcher
* :rotating_light: Changed syntax for intializing mock functions from `jest:fn()` to `jest.fn()` (the colon syntax is left in for compatibility but will be removed in 2.0)
* :rotating_light: `RegExp` is pulled out from the LuauPolyfill repo into a separate LuauRegExp repo and lazily loaded ([#62](https://github.com/Roblox/jest-roblox/pull/62))
* :hammer_and_wrench: Added instantiating mock function instance with `mockFn.new()` ([#52](https://github.com/Roblox/jest-roblox/pull/52))
* :hammer_and_wrench: Changed the `ArrayContaining` asymmetric matcher to output curly braces instead of square brackets ([#55](https://github.com/Roblox/jest-roblox/pull/55))
* :hammer_and_wrench: Added proper output formatting for Roblox `Instance` types ([#64](https://github.com/Roblox/jest-roblox/pull/64))
* :bug: Bugfix in `SpyMatchers` where function calls with `nil` arguments would not be handled correctly ([#53](https://github.com/Roblox/jest-roblox/pull/53))

## 1.0.0 (2021-03-30)
* :sparkles: Added spyMatchers
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
* :sparkles: Added basic `JestMock` functionality
  * The `jest` object can be imported from `Globals` and has the following methods:
    * `.fn()`
    * `.clearAllMocks()`
    * `.resetAllMocks()`
    * `.restoreAllMocks()`
* :hammer_and_wrench: Added `Error` type to `JestGetType` ([#45](https://github.com/Roblox/jest-roblox/pull/45))
* :bug: Bugfix in `.toMatch` where strings go into the RegEx check ([#41](https://github.com/Roblox/jest-roblox/pull/41))
* :bug: Bugfix for `.toThrow` not matching `Error` object with same message ([#44](https://github.com/Roblox/jest-roblox/pull/44))

## 0.7.1 (2021-03-12)
* :sparkles: Added chalk-enabled error output ([#38](https://github.com/Roblox/jest-roblox/pull/38))
* :hammer_and_wrench: Added `userdata` and `thread` Luau types to `JestGetType` ([#39](https://github.com/Roblox/jest-roblox/pull/39))
* :bug: Fix for checking for an `asymmetricMatch` method for objects that override `__index` metamethod ([#39](https://github.com/Roblox/jest-roblox/pull/39))

## 0.7.0 (2021-03-02)
* :sparkles: Added `expect.extend()` ([#35](https://github.com/Roblox/jest-roblox/pull/35))
* :hammer_and_wrench: Added `RegExp` support to matchers ([#32](https://github.com/Roblox/jest-roblox/pull/32))
* :hammer_and_wrench: Added prototype information to matchers ([#34](https://github.com/Roblox/jest-roblox/pull/34))

## 0.6.0 (2021-02-22)
* :sparkles: Added `expect().toThrow()` ([#30](https://github.com/Roblox/jest-roblox/pull/30))

## 0.5.0 (2021-01-29)
* :sparkles: Initial release of Jest Roblox, TestEZ has been rebranded as of this release.
* :sparkles: Added `expect` aligned to [Jest's expect (26.5.3)](https://jestjs.io/docs/en/26.5/expect)
  * Requires an explicit `require` from [`JestRoblox.Globals`](https://jestjs.io/docs/en/26.5/api) to use
  * Refer to the Jest documentation on expect for usage documentation. Refer to the `README.md` in `src/Modules/expect` for details on deviations from upstream
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
  * Custom `asymmetricMatchers` for any objects with a `asymmetricMatch(self, other)` method
  * Negative variants of all the above matchers with the keyword `never`, i.e. `expect().never.toBe()` or `expect.never.stringContaining()`
  * TestEZ `expect` will be removed soon

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
