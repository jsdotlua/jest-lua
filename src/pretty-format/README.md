# pretty-format

Upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/pretty-format

Stringify any Luau value
* Supports Luau builtins and Roblox Instances.
* Can be extended with user defined plugins.

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
* `getConfig` is rewritten to avoid ternary operators.
loop is rewritten with a `for` loop instead of an `iterator.next()`.
* `Collections.lua` deviates from upstream substantially since Lua only has tables. We only have two functions: `printTableEntries` for formatting key, value pairs and `printListItems` for formatting arrays.
