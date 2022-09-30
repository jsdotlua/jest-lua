<h1 align="center">Jest Roblox</h1>
<div align="center">
	<a href="https://github.com/Roblox/jest-roblox/actions?query=workflow%3ACI">
		<img src="https://github.com/Roblox/jest-roblox/workflows/CI/badge.svg" alt="GitHub Actions Build Status" />
	</a>
	<a href="https://roblox.github.io/jest-roblox/">
			<img src="https://img.shields.io/badge/docs-website-green.svg" alt="Documentation" />
	</a>
	<a href='https://coveralls.io/github/Roblox/jest-roblox'>
		<img src='https://coveralls.io/repos/github/Roblox/jest-roblox/badge.svg?t=4czPqO&kill_cache=1' alt='Coverage Status' />
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
JestGlobals = "github.com/roblox/jest-roblox@2.2.0"
```

Then, require anything you need from `JestGlobals`:
```
local JestGlobals = require(Packages.JestGlobals)
local expect = JestGlobals.expect
```

---

## Inspiration and Prior Work
Jest Roblox is a Roblox port of the open source JavaScript testing framework [Jest](https://github.com/facebook/jest). Modules in the `modules` directory are  aligned to [v27.4.7](https://github.com/facebook/jest/tree/v27.4.7) of Jest.

---

## Contributing
Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for information.

## License
Jest Roblox is available under the Apache 2.0 license. See [LICENSE](LICENSE) for details.
