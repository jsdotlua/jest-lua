---
id: getting-started
title: Getting Started
slug: /
---

The Jest Lua API is similar to [the API used by JavaScript Jest.](https://jestjs.io/docs/27.x/api)

Jest Lua currently requires [`run-in-roblox`](https://github.com/rojo-rbx/run-in-roblox) to run from the command line. It can also be run directly inside of Roblox Studio. See issue [#2](https://github.com/jsdotlua/jest-lua/issues/2) for more.

:::tip
Checkout the [example game](https://github.com/jsdotlua/jest-lua/tree/main/example-project) to see a full setup of Jest-Lua for a Roblox Library.
:::

Add the `JestGlobals` and `Jest` packages to your `dev-dependencies` in your `wally.toml`.

```yaml title="wally.toml"
[dev-dependencies]
Jest = "jsdotlua/jest@3.6.1-rc.2"
JestGlobals = "jsdotlua/jest-globals@3.6.1-rc.2"
```

Run `wally install` to install Jest Lua.

Create a `default.project.json` to set up your project structure and include the `Packages` and `DevPackages` directories created by `wally`.

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
		},
		"DevPackages": {
			"$path": "DevPackages"
		}
	}
}
```

Create a `run-tests.lua` to point the test runner to the correct directory with your tests. This is the entrypoint for Jest Lua. For more information, see [runCLI Options](cli).

```lua title="run-tests.lua"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Jest = require("@DevPackages/Jest")

local runCLIOptions = {
	verbose = false,
	ci = false,
}

local projects = {
	Packages.Project,
}

Jest.runCLI(script, runCLIOptions, projects):await()

return nil
```

Inside `src`, create a basic [configuration](configuration) file.

```lua title="jest.config.lua"
return {
	testMatch = {
		"**/__tests__/*.(spec|test)",
	},
	testPathIgnorePatterns = {
		"Packages",
		"DevPackages",
	},
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

To manage FastFlags for Studio, it is recommended that you use [Roblox Studio Mod Manager](https://github.com/MaximumADHD/Roblox-Studio-Mod-Manager) to set the `FFlagEnableLoadModule` FFlag to true. Or, you can edit your `ClientAppSettings.json` yourself.

```json title="ClientAppSettings.json"
{
	"FFlagEnableLoadModule": true
}
```

Finally, run your project using Roblox Studio or use [run-in-roblox](https://github.com/rojo-rbx/run-in-roblox) to run the tests and your tests should pass!

```bash
run-in-roblox --place test-place.rbxl --script scripts/run-tests.lua
```

**You just successfully wrote your first test using Jest Lua!**

This test used `expect` and `toBe` to test that two values were exactly identical. To learn about other things that Jest Lua can test, see [Using Matchers](using-matchers).
