---
id: cli
title: runCLI Options
---
<p><a href='https://jestjs.io/docs/27.x/cli' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a></p> <img alt='Deviation' src='img/deviation.svg'/>

The `Jest` packages exports `runCLI`, which is the main entrypoint to run Jest Lua tests. In your entrypoint script, import `runCLI` from the `Jest` package. A basic entrypoint script can look like the following:
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

The first argument to `runCLI` is the root directory of your project, the second argument is a list of [options](#options), and the third argument is a list of projects (directories with a `jest.config.lua`) for Jest Lua to discover.

## Options

import TOCInline from "@theme/TOCInline";

<TOCInline toc={
	toc.filter((node) => node.level === 3)
}/>

## Reference

### `ci` \[boolean]
<a href='https://jestjs.io/docs/27.x/cli#--ci' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

When this option is provided, Jest Lua will assume it is running in a CI environment. This changes the behavior when a new snapshot is encountered. Instead of the regular behavior of storing a new snapshot automatically, it will fail the test and require Jest Lua to be run with `updateSnapshot`.

### `clearMocks` \[boolean]
<a href='https://jestjs.io/docs/27.x/cli#--clearmocks' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Automatically clear mock calls, instances, contexts and results before every test. Equivalent to calling [`jest.clearAllMocks()`](jest-object#jestclearallmocks) before each test. This does not remove any mock implementation that may have been provided.

### `debug` \[boolean]
<a href='https://jestjs.io/docs/27.x/cli#--debug' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Print debugging info about your Jest config.

### `expand` \[boolean]
<a href='https://jestjs.io/docs/27.x/cli#--expand' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Use this flag to show full diffs and errors instead of a patch.

### `json` \[boolean]
<a href='https://jestjs.io/docs/27.x/cli#--json' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Prints the test results in JSON. This mode will send all other test output and user messages to stderr.

### `listTests` \[boolean]
<a href='https://jestjs.io/docs/27.x/cli#--listtests' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Lists all test files that Jest Lua will run given the arguments, and exits.

### `noStackTrace` \[boolean]
<a href='https://jestjs.io/docs/27.x/cli#--nostacktrace' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Disables stack trace in test results output.

### `passWithNoTests` \[boolean]
<a href='https://jestjs.io/docs/27.x/cli#--passwithnotests' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Allows the test suite to pass when no files are found.

### `resetMocks` \[boolean]
<a href='https://jestjs.io/docs/27.x/cli#--resetmocks' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Automatically reset mock state before every test. Equivalent to calling [`jest.resetAllMocks()`](jest-object#jestresetallmocks) before each test. This will lead to any mocks having their fake implementations removed but does not restore their initial implementation.

<!-- ### `restoreMocks` \[boolean]

Automatically restore mock state and implementation before every test. Equivalent to calling [`jest.restoreAllMocks()`](JestObjectAPI.md#jestrestoreallmocks) before each test. This will lead to any mocks having their fake implementations removed and restores their initial implementation. -->

### `showConfig` \[boolean]
<a href='https://jestjs.io/docs/27.x/cli#--showconfig' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Print your Jest config and then exits.

### `testMatch` \[array&lt;string&gt;]
<a href='https://jestjs.io/docs/27.x/cli#--testmatch-glob1--globn' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='API change' src='img/apichange.svg'/>

The glob patterns Jest uses to detect test files. Please refer to the [`testMatch` configuration](configuration#testmatch-arraystring) for details.

### `testNamePattern` \[regex]
<a href='https://jestjs.io/docs/27.x/cli#--testnamepatternregex' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Run only tests with a name that matches the regex. For example, suppose you want to run only tests related to authorization which will have names like "GET /api/posts with auth", then you can use `testNamePattern = "auth"`.

:::tip

The regex is matched against the full name, which is a combination of the test name and all its surrounding describe blocks.

:::

### `testPathIgnorePatterns` \[array&lt;regex&gt;]
<a href='https://jestjs.io/docs/27.x/cli#--testpathignorepatternsregexarray' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='API change' src='img/apichange.svg'/>

An array of regexp pattern strings that are tested against all tests paths before executing the test. Contrary to `testPathPattern`, it will only run those tests with a path that does not match with the provided regexp expressions.

### `testPathPattern` \[regex]
<a href='https://jestjs.io/docs/27.x/cli#--testpathpatternregex' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

A regexp pattern string that is matched against all tests paths before executing the test.

### `testTimeout` \[number>]
<a href='https://jestjs.io/docs/27.x/cli#--testtimeoutnumber' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Default timeout of a test in milliseconds. Default value: 5000.

### `updateSnapshot` \[boolean]
<a href='https://jestjs.io/docs/27.x/cli#--updatesnapshot' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Use this flag to re-record every snapshot that fails during this test run. Can be used together with a test suite pattern or with `testNamePattern` to re-record snapshots.

### `verbose` \[boolean]
<a href='https://jestjs.io/docs/27.x/cli#--verbose' target="_blank"><img alt='Jest' src='img/jestjs.svg'/></a>  <img alt='Aligned' src='img/aligned.svg'/>

Display individual test results with the test suite hierarchy.