# jest-matcher-utils

Upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-matcher-utils

This package's exports are mainly used by `expect`'s `utils`.

---

### :pencil2: Notes
* We don't provide support for `bigint` types
* We don't provide a translation for the `chalk` library. This also means we omit certain tests that rely on comparing output that is colored differently.
* Changed type annotations in upstream that were `unknown` to `any` because Luau doesn't have support for an `unknown` type
* In many of the tests, there is differentiation between types such as `Array` and `Map`, however in Lua all of these are treated identically as `table`. The tests were translated to use the `table` type and some tests were left out if they became identical to other tests or were highly redundant.
* Luau does not yet have functionality to use generics in function signatures and functions so those type annotations are left out
