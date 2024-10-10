---
id: cli
title: runCLI Options
---
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli)

![Deviation](/img/deviation.svg)

The `Jest` packages exports `runCLI`, which is the main entrypoint to run Jest Roblox tests. In your entrypoint script, import `runCLI` from the `Jest` package. A basic entrypoint script can look like the following:
```lua title="spec.lua"
local Packages = script.Parent.YourProject.Packages
local runCLI = require(Packages.Dev.Jest).runCLI

local processServiceExists, ProcessService = pcall(function()
	return game:GetService("ProcessService")
end)

local status, result = runCLI(Packages.Project, {
	verbose = false,
	ci = false
}, { Packages.Project }):awaitStatus()

if status == "Rejected" then
	print(result)
end

if status == "Resolved" and result.results.numFailedTestSuites == 0 and result.results.numFailedTests == 0 then
	if processServiceExists then
		ProcessService:ExitAsync(0)
	end
end

if processServiceExists then
	ProcessService:ExitAsync(1)
end

return nil
```

The first argument to `runCLI` is the root directory of your project, the second argument is a list of [options](#options), and the third argument is a list of projects (directories with a `jest.config.lua`) for Jest Roblox to discover.

## Options

import TOCInline from "@theme/TOCInline";

<TOCInline toc={
	toc.filter((node) => node.level === 3)
}/>

## Reference

### `ci` \[boolean]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--ci)  ![Aligned](/img/aligned.svg)

When this option is provided, Jest Roblox will assume it is running in a CI environment. This changes the behavior when a new snapshot is encountered. Instead of the regular behavior of storing a new snapshot automatically, it will fail the test and require Jest Roblox to be run with `updateSnapshot`.

### `clearMocks` \[boolean]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--clearmocks)  ![Aligned](/img/aligned.svg)

Automatically clear mock calls, instances, contexts and results before every test. Equivalent to calling [`jest.clearAllMocks()`](jest-object#jestclearallmocks) before each test. This does not remove any mock implementation that may have been provided.

### `debug` \[boolean]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--debug)  ![Aligned](/img/aligned.svg)

Print debugging info about your Jest config.

### `expand` \[boolean]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--expand)  ![Aligned](/img/aligned.svg)

Use this flag to show full diffs and errors instead of a patch.

### `json` \[boolean]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--json)  ![Aligned](/img/aligned.svg)

Prints the test results in JSON. This mode will send all other test output and user messages to stderr.

### `listTests` \[boolean]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--listtests)  ![Aligned](/img/aligned.svg)

Lists all test files that Jest Roblox will run given the arguments, and exits.

### `noStackTrace` \[boolean]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--nostacktrace)  ![Aligned](/img/aligned.svg)

Disables stack trace in test results output.

### `oldFunctionSpying` \[boolean]
![Roblox only](/img/roblox-only.svg)

Changes how [`jest.spyOn()`](jest-object#jestspyonobject-methodname) overwrites
methods in the spied object, making it behave like older versions of Jest.

* When `oldFunctionSpying = true`, it will overwrite the spied method with a
  *mock object*. (old behaviour)
* When `oldFunctionSpying = false`, it will overwrite the spied method with a
  *regular Lua function*. (new behaviour)

Regardless of the value of `oldFunctionSpying`, the `spyOn()` function will
always return a mock object.

```lua
-- when `oldFunctionSpying = false` (old behaviour)

local guineaPig = {
	foo = function() end
}

local mockObj = jest.spyOn(guineaPig, "foo")
mockObj.mockReturnValue(25)

print(typeof(guineaPig.foo)) --> table
print(typeof(mockObj)) --> table
print(guineaPig.foo == mockObj) --> true
```

```lua
-- when `oldFunctionSpying = true` (new behaviour)

local guineaPig = {
	foo = function() end
}

local mockObj = jest.spyOn(guineaPig, "foo")

print(typeof(guineaPig.foo)) --> function
print(typeof(mockObj)) --> table
print(guineaPig.foo == mockObj) --> false
```

### `passWithNoTests` \[boolean]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--passwithnotests)  ![Aligned](/img/aligned.svg)

Allows the test suite to pass when no files are found.

### `resetMocks` \[boolean]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--resetmocks)  ![Aligned](/img/aligned.svg)

Automatically reset mock state before every test. Equivalent to calling [`jest.resetAllMocks()`](jest-object#jestresetallmocks) before each test. This will lead to any mocks having their fake implementations removed but does not restore their initial implementation.

<!-- ### `restoreMocks` \[boolean]

Automatically restore mock state and implementation before every test. Equivalent to calling [`jest.restoreAllMocks()`](JestObjectAPI.md#jestrestoreallmocks) before each test. This will lead to any mocks having their fake implementations removed and restores their initial implementation. -->

### `showConfig` \[boolean]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--showconfig)  ![Aligned](/img/aligned.svg)

Print your Jest config and then exits.

### `testMatch` \[array&lt;string&gt;]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--testmatch-glob1--globn)  ![API Change](/img/apichange.svg)

The glob patterns Jest uses to detect test files. Please refer to the [`testMatch` configuration](configuration#testmatch-arraystring) for details.

### `testNamePattern` \[regex]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--testnamepatternregex)  ![Aligned](/img/aligned.svg)

Run only tests with a name that matches the regex. For example, suppose you want to run only tests related to authorization which will have names like "GET /api/posts with auth", then you can use `testNamePattern = "auth"`.

:::tip

The regex is matched against the full name, which is a combination of the test name and all its surrounding describe blocks.

:::

### `testPathIgnorePatterns` \[array&lt;regex&gt;]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--testpathignorepatternsregexarray)  ![API Change](/img/apichange.svg)

An array of regexp pattern strings that are tested against all tests paths before executing the test. Contrary to `testPathPattern`, it will only run those tests with a path that does not match with the provided regexp expressions.

### `testPathPattern` \[regex]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--testpathpatternregex)  ![Aligned](/img/aligned.svg)

A regexp pattern string that is matched against all tests paths before executing the test.

### `testTimeout` \[number>]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--testtimeoutnumber)  ![Aligned](/img/aligned.svg)

Default timeout of a test in milliseconds. Default value: 5000.

### `updateSnapshot` \[boolean]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--updatesnapshot)  ![Aligned](/img/aligned.svg)

Use this flag to re-record every snapshot that fails during this test run. Can be used together with a test suite pattern or with `testNamePattern` to re-record snapshots.

### `verbose` \[boolean]
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/cli#--verbose)  ![Aligned](/img/aligned.svg)

Display individual test results with the test suite hierarchy.
