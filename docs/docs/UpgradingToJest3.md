---
id: upgrading-to-jest3
title: From v2.x to v3.x
---

Upgrading Jest Roblox from v2.x or TestEZ to v3.x? This guide aims to help refactoring your configuration and tests.

## Migration

### Setup

First, update your `rotriever.toml` to use Jest Roblox v3.0. You'll also need to require the `Jest` package in addition to the `JestGlobals` package. The `Jest` package contains `runCLI`, which is the main entrypoint into Jest Roblox in v3.0.

```yaml title="rotriever.toml"
[dev_dependencies]
Jest = "github.com/roblox/jest-roblox@3.0.0"
JestGlobals = "github.com/roblox/jest-roblox@3.0.0"
```

Update your `spec.lua`. Instead of using `TestEZ.TestBootStrap:run`, the main entrypoint is now `Jest.runCLI`. A basic bootstrap script can look like the following:
```lua title="spec.lua"
local YourProject = script.Parent.YourProject
local runCLI = require(YourProject.Packages.Dev.Jest).runCLI

local processServiceExists, ProcessService = pcall(function()
	return game:GetService("ProcessService")
end)

local status, result = runCLI(YourProject.Source, {
	verbose = false,
	ci = false
}, { YourProject.Source }):awaitStatus()

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

The first argument is the root directory of your project and the third argument is a list of projects (directories with a `jest.config.lua`) with tests for Jest Roblox to discover. For a simple mono-package project, these should just point to your source directory. For detailed information, see [runCLI Options](cli).

### Configuration

Because Jest Roblox now expects that projects have a configuration file, create a `jest.config.lua` in your source directory. A simple configuration file can just specify the paths to tests for Jest Roblox to discover. For more configuration options, see [Configuring Jest](configuration).

```lua title="jest.config.lua"
return {
	testMatch = { "**/*.spec" },
}
```

:::warning
Currently, Jest Roblox will error if no configuration file is found.
:::

### Updating Tests
Jest Roblox v3.0 no longer relies on test files returning a callback. However, because ModuleScripts are required to return a value, you can return an empty table.
A simple test file in v2.x may look like the following:
```lua title="test.spec.lua"
return function()
	local Workspace = script.Parent.Parent
	local Packages = Workspace.Parent.Packages

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local expect = JestGlobals.expect

	it("1 does not equal 2", function()
		expect(1).toBe(2)
	end)
end
```

This test should now look like this:

```lua title="test.spec.lua"
local Workspace = script.Parent.Parent
local Packages = Workspace.Parent.Packages

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local it = JestGlobals.it

it("1 does not equal 2", function()
	expect(1).toBe(2)
end)
```

There are a couple interesting differences:
* Jest Roblox v3.0 no longer relies on test files returning a callback so the test file does not need to be wrapped in a callback function.

:::tip
Jest Roblox v2.x required that all test modules return a function with test contents. In Jest Roblox v3.0.0 - v3.1.1, test modules no longer relied on a wrapping function, but still expected a non-nil return.

As of Jest Roblox v3.1.1, test modules are treated specially and are no longer expected to return any value.
:::

* In addition to `expect`, `it` is also imported from `JestGlobals`. Unlike TestEZ or Jest Roblox v2.x, no values are magically injected into the environment. 

:::warning
Any value you need must be explicitly imported from `JestGlobals`, including common ones like `describe` or `it`. Jest Roblox **will** error if these values are not imported. To see a full list of values exported in `JestGlobals`, see [Globals](api).
:::

### Running Tests
Jest Roblox v3.0 also requires the fast flag `EnableLoadModule`. Add `--fastFlags.overrides EnableLoadModule=true` to your `roblox-cli run` command.

```bash
roblox-cli run --load.model default.project.json --run spec.lua --fastFlags.allOnLuau  --fastFlags.overrides EnableLoadModule=true
```

## Notable Differences

### FOCUS and SKIP
Instead of `FOCUS`, `SKIP` in v2.x, v3.0 uses the `.only` and `.skip` operator. These behave differently from their equivalents in v2.x due to the changes in the test runner.

In v3.0, the test runner discovers and runs every test file independently so each test file is considered a test suite. This is different from the test runner in v2.x, which first discovers every test and generates a test plan before running everything as a single suite.

This means that the `.only` and `.skip` operator **only** affect the test file that they are in, not the entire test run (i.e. marking a test as `.only` will run only that test in that file, but will still run every test in every other file).

:::tip
You may use test filtering configuration options or `runCLI` options to run only specific test files or specific tests.

For example, given this test:
```lua title="peanutButter.spec.lua"
test('the data is peanut butter', function()
    -- ...
end)
```

To run only that test file, use the `testMatch` configuration option. Set `testMatch = { "**/peanutButter.spec" }` in either `runCLI` or your `jest.config.lua`. You can then use `test.only` to run only that test.

To run only tests with a specific name, you may pass the `testNamePattern` into `runCLI`. For example, to run only this test, you can pass `testNamePattern = "the data is peanut butter"` into `runCLI`.

See [Configuring Jest](configuration) or [runCLI Options](cli) for other options to filter test runs.
:::

### Setup
Some v2.x tests use the test callbacks to set up an environment (Roact components for example) and pass state into a test file. In v3.0, test files are run separately in their own environment so state cannot be shared or passed around to a test file.

Every test file must set up its own state or imported from a file explicitly with a `require`. This may make some setup more verbose or cumbersome, but makes dependencies much more explicit and improves readability and makes tests much easier to debug.

However, some setup can be shared across test files sharing a configuration with the [`setupFilesAfterEnv`](configuration#setupfilesafterenv-arraymodulescript) option. This is useful for adding custom matchers or custom serializers, or for calling setup and teardown hooks that need to be shared across tests.
