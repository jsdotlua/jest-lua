---
id: getting-started
title: Getting Started
slug: /
---

The Jest Roblox API is similar to [the API used by JavaScript Jest.](https://jest-archive-august-2023.netlify.app/docs/27.x/api)

Jest Roblox requires `roblox-cli` to run from the command line.

Add the `JestGlobals` and `Jest` package to your `dev_dependencies` in your `rotriever.toml`.
```yaml title="rotriever.toml"
[dev_dependencies]
Jest = "github.com/Roblox/jest-roblox@3.0.0"
JestGlobals = "github.com/Roblox/jest-roblox@3.0.0"
```

Run `rotrieve install` to install Jest Roblox.

Create a `default.project.json` to set up your project structure and include the `Packages` directory created by `rotriever`.
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

Create a `spec.lua` to point the test runner to the correct directory with your tests. This is the entrypoint for Jest Roblox. For more information, see [runCLI Options](cli).
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
local Workspace = script.Parent.Parent
local Packages = Workspace.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local it = JestGlobals.it
local expect = JestGlobals.expect

local sum = require(Workspace.sum)

it('adds 1 + 2 to equal 3', function()
	expect(sum(1, 2)).toBe(3)
end)
```

:::caution
Any functionality needed _must_ be explicitly required from `JestGlobals`, see [Globals](api).
:::

Finally, run your project using `roblox-cli` to run the tests and your tests should pass!
```bash
roblox-cli run --load.model default.project.json --run spec.lua --fastFlags.overrides EnableLoadModule=true
```

**You just successfully wrote your first test using Jest Roblox!**

This test used `expect` and `toBe` to test that two values were exactly identical. To learn about other things that Jest Roblox can test, see [Using Matchers](using-matchers).
