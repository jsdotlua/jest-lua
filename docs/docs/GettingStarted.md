---
id: getting-started
title: Getting Started
slug: /
---

The Jest Roblox API is similar to [the API used by JavaScript Jest.](https://jest-archive-august-2023.netlify.app/docs/27.x/api)

Jest Lua currently requires [`run-in-roblox`](https://github.com/rojo-rbx/run-in-roblox) to run from the command line. It can also be run directly inside of Roblox Studio. See issue [#2](https://github.com/jsdotlua/jest-lua/issues/2) for more.

Add the `JestGlobals` and `Jest` packages to your `dev-dependencies` in your `wally.toml`.

```yaml title="wally.toml"
[dev-dependencies]
Jest = "jsdotlua/jest@3.6.1-rc.2"
JestGlobals = "jsdotlua/jest-globals@3.6.1-rc.2"
```

Run `wally install` to install Jest Lua.

Create a `default.project.json` to set up your project structure and include the `Packages` directory created by `wally`.

```json title="default.project.json"
{
	"name": "YourProject",
	"tree": {
		"$className": "Folder",
		"Packages": {
			"$path": "Packages",
			"Project": {
				"$path": "src"
			}
		}
	}
}
```

Create a `run-tests.lua` to point the test runner to the correct directory with your tests. This is the entrypoint for Jest Lua. For more information, see [runCLI Options](cli).

```lua title="run-tests.lua"
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local runCLI = require("@DevPackages/Jest").runCLI

local processServiceExists, ProcessService = pcall(function()
	return game:GetService("ProcessService")
end)

local status, result = runCLI(ReplicatedStorage.Packages.Project, {
	verbose = false,
	ci = false
}, { ReplicatedStorage.Packages.Project }):awaitStatus()

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

Inside `src`, create a basic [configuration](configuration) file.

```lua title="jest.config.lua"
return {
	testMatch = { "**/*.spec" }
}
```

Let's get started by writing a test for a hypothetical function that adds two numbers. First, create a `sum.lua` under your `src` directory.

```lua title="sum.lua"
return function(a, b)
	return a + b
end
```

Then, create a `__tests__` directory under your `src` directory and create a `sum.spec.lua` in it. This will contain our actual test:

```lua title="sum.spec.lua"
local JestGlobals = require("@DevPackages/JestGlobals")

local it = JestGlobals.it
local expect = JestGlobals.expect

local sum = require("@Project/Sum")

it('adds 1 + 2 to equal 3', function()
	expect(sum(1, 2)).toBe(3)
end)
```

:::caution
Any functionality needed _must_ be explicitly required from `JestGlobals`, see [Globals](api).
:::

Before you can run your tests, you need to enable the `debug.loadmodule` API. To do this, you must enable the `FFlagEnableLoadModule` flag. See issue [#3](https://github.com/jsdotlua/jest-lua/issues/3) for more.

```json title="ClientAppSettings.json"
{
	"FFlagEnableLoadModule": true
}
```

Finally, run your project using Roblox Studio or `run-in-roblox` to run the tests and your tests should pass!

```bash
run-in-roblox --place test-place.rbxl --script scripts/run-tests.lua
```

**You just successfully wrote your first test using Jest Lua!**

This test used `expect` and `toBe` to test that two values were exactly identical. To learn about other things that Jest Lua can test, see [Using Matchers](using-matchers).
