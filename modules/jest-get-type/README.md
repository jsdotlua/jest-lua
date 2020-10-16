# jest-get-type

Status: :heavy_check_mark: Ported

Source: https://github.com/facebook/jest/tree/v26.5.3/packages/jest-get-type

Version: v26.3.0

---

### :pencil2: Notes
* Lua makes no distinction between tables, objects, and arrays. We always return `table` at this level and consumers are expected to check at a higher level.
* Lua makes no distinction between `null` and `undefined` so we only return `nil`.
* Lua lacks the following primitives: `bigint`, `symbol`.
* Lua lacks the following built-in types: `RegExp`, `Map`, `Set`, `Date`.