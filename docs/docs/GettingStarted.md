---
id: getting-started
title: Getting Started
slug: /
---

Jest Roblox is a work in progress! You may need to refer to the [TestEZ API doc](testez) or the actual [TestEZ documentation](https://roblox.github.io/testez). You may also want to refer to the [Jest documentation](https://jestjs.io/docs/en/26.5/getting-started.html).

Jest Roblox requires `rojo` and `roblox-cli` to run from the command line.

Add this package to your `dev_dependencies` in your `rotriever.toml`.
```yaml title="rotriever.toml"
[dev_dependencies]
JestRoblox = "github.com/roblox/jest-roblox@1.0.0"
```

Run `rotrieve install` to install Jest Roblox.

Create a `default.project.json` to set up your rojo project structure and include the `Packages` directory created by `rotriever`.
```json title="default.project.json"
{
	"name": "YourProject",
	"tree": {
		"$className": "Folder",
		"Source": {
			"$path": "src"
		},
		"Packages": {
			"$path": "Packages"
		}
	}
}
```

Create a `spec.lua` to point the test runner to the correct directory with your tests.
```lua title="spec.lua"
local JestRoblox = require(script.Parent.YourProject.Packages.Dev.JestRoblox)

JestRoblox.TestBootstrap:run(
	{ script.Parent.YourProject.Source },
	JestRoblox.Reporters.TextReporter
)
```

Let's get started by writing a test for a hypothetical function that adds two numbers. First, create a `sum.lua` under your `src` directory.
```lua title="sum.lua"
return function(a, b)
	return a + b
end
```

Then, create a `__tests__` directory under your `src` directory and create a `sum.spec.lua` in it. This will contain our actual test:
```lua title="sum.spec.lua"
return function()
	local Workspace = script.Parent.Parent
	local Packages = Workspace.Parent.Packages.Dev

	local JestRoblox = require(Packages.JestRoblox).Globals
	local expect = JestRoblox.expect

	local sum = require(Workspace.sum)

	it('adds 1 + 2 to equal 3', function()
		expect(sum(1, 2)).toBe(3)
	end)
end
```

Finally, build your rojo project and run it using `roblox-cli` to run the tests and your tests should pass!
```bash
rojo build default.project.json --output model.rbxmx
roblox-cli run --load.model model.rbxmx --run spec.lua
```

**You just successfully wrote your first test using Jest Roblox!**

This test used `expect` and `toBe` to test that two values were exactly identical. To learn about other things that Jest Roblox can test, see [Using Matchers](using-matchers).