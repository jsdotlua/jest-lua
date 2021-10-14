# jest-get-type

Status: :heavy_check_mark: Ported

Source: https://github.com/facebook/jest/tree/v27.2.5/packages/jest-get-type

Version: v26.3.0

---

### :pencil2: Notes
* Lua makes no distinction between tables, objects, and arrays. We always return `table` at this level and consumers are expected to check at a higher level.
* Lua makes no distinction between `null` and `undefined` so we only return `nil`.
* Lua lacks the following primitives: `bigint`, `symbol`.
* Lua lacks the following built-in types: `RegExp`, `Map`, `Set`, `Date`.
* `JestGetType` deviates and exposes an `isRobloxBuiltin` method to check whether a value is a Roblox builtin type

Types supported:

* Lua Primitives - `nil`, `table`, `number`, `string`, `function`, `boolean`, `userdata`, `thread`
* [Luau Polyfill](https://github.com/Roblox/luau-polyfill) types - `symbol`, [`regexp`](https://github.com/Roblox/luau-regexp), `error`, `set`
* Roblox datatypes - `DateTime`, and other [`builtin`](https://developer.roblox.com/en-us/api-reference/data-types) types

### :x: Excluded
```
```

### :package: [Dependencies](https://github.com/facebook/jest/blob/v27.2.5/packages/jest-get-type/package.json)
| Package | Version | Status | Notes |
| - | - | - | - |
