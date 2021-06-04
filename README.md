<h1 align="center">Jest Roblox</h1>
<div align="center">
	<a href="https://github.com/Roblox/jest-roblox/actions?query=workflow%3ACI">
		<img src="https://github.com/Roblox/jest-roblox/workflows/CI/badge.svg" alt="GitHub Actions Build Status" />
	</a>
	<a href="https://roblox.github.io/jest-roblox/">
			<img src="https://img.shields.io/badge/docs-website-green.svg" alt="Documentation" />
	</a>
	<a href='https://coveralls.io/github/Roblox/jest-roblox'>
		<img src='https://coveralls.io/repos/github/Roblox/jest-roblox/badge.svg?t=4czPqO' alt='Coverage Status' />
	</a>
</div>

<div align="center">
	Lovely Lua Testing
</div>

<div>&nbsp;</div>

Jest Roblox can run within Roblox itself, as well as inside roblox-cli for testing on CI systems.

We use Jest Roblox at Roblox for testing our apps, in-game core scripts, built-in Roblox Studio plugins, as well as libraries like [Roact Navigation](https://github.com/Roblox/roact-navigation).

---

Add this package to your `dev_dependencies` in your `rotriever.toml`, for example:
```
JestRoblox = "github.com/roblox/jest-roblox@1.0.0"
```

Then, require anything you need from `JestRoblox.Globals`:
```
local JestRoblox = require(Packages.JestRoblox)
local expect = JestRoblox.Globals.expect
```

---

## Inspiration and Prior Work
Jest Roblox is a Roblox port of the open source JavaScript testing framework [Jest](https://github.com/facebook/jest). Modules in the `modules` directory are  aligned to [v26.5.3](https://github.com/facebook/jest/tree/v26.5.3) of Jest, but the current public API is compatible with TestEZ [v0.4.0](https://github.com/Roblox/testez/tree/v0.4.0) while we complete our alignment.

It is also an evolution of an older test framework used at Roblox, [TestEZ](https://github.com/Roblox/TestEZ). It is currently forked from [commit d983722](https://github.com/Roblox/testez/tree/d983722fb085141db3a7e80a37b30b03a69e6e55) of TestEZ. As such, the `expect` syntax is based on Chai, a JavaScript assertion library commonly used with Mocha, but it will soon be modified to align to Jest's `expect` syntax.

---

## Contributing
Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for information.

## License
Jest Roblox is available under the Apache 2.0 license. See [LICENSE](LICENSE) for details.
