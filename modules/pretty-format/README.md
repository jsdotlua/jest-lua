# pretty-format

Status: :hammer: In Progress

Source: https://github.com/facebook/jest/tree/v26.5.3/packages/pretty-format

Version: v26.5.2

---

### :pencil2: Notes
* :warning: Our `prettyFormat` doesn't distinguish between `Tables`, `Arrays`, `Objects`, etc. and prints out all Lua table-like types as `Table`.
    * For example, an empty array is printed as `Table {}` and an array with values is printed as `Table {1, 2, 3,}`.
    * `printComplexValue` is reduced to just arrays and tables.
* :x: Color formatting isn't supported so all related methods are omitted.
* :hammer: Built-in plugins for `prettyFormat` are not implemented yet.
* `prettyFormat` formats Roblox `DateTime` objects as a replacement for JS `Date`.
* Formats using the Lua native string representations of primitives like `nil`, `nan` and `inf` over the JS `null`, `NaN` and `Infinity`. The tests are modified accordingly.
* Formatting for any Javascript specific types in are omitted, `Symbol`, named `Function`, `Error`, `Date`, `BigInt`, etc.
* All functions are anonymous in Lua.
* `getConfig` is rewritten to avoid ternary operators.
loop is rewritten with a `for` loop instead of an `iterator.next()`.
* `Collections.lua` deviates from upstream substantially since Lua only has tables. We only have two functions: `printTableEntries` for formatting key, value pairs and `printListItems` for formatting arrays.

### :x: Excluded
```
perf
src/plugins/ConvertAnsi.ts
src/__tests__/ConvertAnsi.test.ts
```

### :package: [Dependencies](https://github.com/facebook/jest/blob/v26.5.3/packages/pretty-format/package.json)
| Package | Version | Status | Notes |
| - | - | - | - |
| `@jest/types` | 26.5.2 | :x: Will not port | External type definitions are not a priority |
| `ansi-regex` | 5.0.0 | :x: Will not port | Console output styling is not a priority |
| `ansi-styles` | 4.0.0 | :x: Will not port | See above |
| `react-is` | see roact-alignment | :heavy_check_mark: Ported | Imported from roact-alignment |