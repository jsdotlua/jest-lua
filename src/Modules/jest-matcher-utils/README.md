# jest-matcher-utils

Status: :heavy_check_mark: Ported

Source: https://github.com/facebook/jest/tree/v26.5.3/packages/jest-matcher-utils

Version: v26.5.2

---

### :pencil2: Notes
* We don't provide support for `bigint` types
* We don't provide a translation for the `chalk` library. This also means we omit certain tests that rely on comparing output that is colored differently.
* Changed type annotations in upstream that were `unknown` to `any` because Luau doesn't have support for an `unknown` type
* In many of the tests, there is differentiation between types such as `Array` and `Map`, however in Lua all of these are treated identically as `table`. The tests were translated to use the `table` type and some tests were left out if they became identical to other tests or were highly redundant.
* Luau does not yet have functionality to use generics in function signatures and functions so those type annotations are left out

### :x: Excluded
```
```

### :package: [Dependencies](https://github.com/facebook/jest/blob/v26.5.3/packages/jest-matcher-utils/package.json)
| Package | Version | Status | Notes |
| - | - | - | - |
| chalk | 4.0.0 | :heavy_check_mark: Ported | [Lua-Chalk](https://github.com/Roblox/lua-chalk) |
| jest-diff | 26.5.2 | :heavy_check_mark: Ported | |
| jest-get-type | 26.3.0 | :heavy_check_mark: Ported | |
| pretty-format | 26.5.2 | :heavy_check_mark: Ported | Mostly complete, need plugins |