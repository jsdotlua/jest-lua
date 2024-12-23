<img src="https://raw.githubusercontent.com/jsdotlua/branding/main/Logo.png" align="right" height="128"/>

# Jest Lua

<h3>Delightful Lua Testing.</h3>

[![Tests](https://github.com/jsdotlua/jest-lua/actions/workflows/test.yml/badge.svg)](https://github.com/jsdotlua/jest-lua/actions/workflows/test.yml)
[![Docs](https://img.shields.io/badge/docs-website-green.svg)](https://jsdotlua.github.io/jest-lua/)

---

Jest Lua can currently only run inside of Roblox. Help is wanted to get it running in other Lua environments, such as [Lune](https://lune.gitbook.io/lune/) or [Luvit](https://luvit.io/). See issue [#2](https://github.com/jsdotlua/jest-lua/issues/2).

Roblox uses Jest Lua internally for testing their apps, in-game core scripts, built-in Roblox Studio plugins, as well as libraries like [Roact Navigation](https://github.com/Roblox/roact-navigation). This library should be considered battle-tested and ready for production use.

---

# Installation

Add this package to your `dev-dependencies` in your `wally.toml`, for example:

```toml
JestGlobals = "jsdotlua/jest-globals@3.10.0"
```

Then, require anything you need from `JestGlobals`:

```lua
local JestGlobals = require("@Packages/JestGlobals")
local expect = JestGlobals.expect
```

## Inspiration and Prior Work

Jest Lua is a Lua port of the open source JavaScript testing framework [Jest](https://github.com/facebook/jest). Modules in the `modules` directory are aligned to [v27.4.7](https://github.com/facebook/jest/tree/v27.4.7) of Jest.

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for information.

## License

Jest Lua is available under the MIT license. See [LICENSE](LICENSE) for details.
