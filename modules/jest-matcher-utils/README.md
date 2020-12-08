# jest-matcher-utils

Status: :hammer: In Progress

Source: https://github.com/facebook/jest/tree/v26.5.3/packages/jest-matcher-utils

Version: v26.5.3

---

### :pencil2: Notes
* Changed type annotations in upstream that were `unknown` to `any` because Luau doesn't have support for an `unknown` type
* In many of the tests, there is differentiation between types such as `Array` and `Map`, however in Lua all of these are treated identically as `table`. The tests were translated to use the `table` type and some tests were left out if they became identical to other tests or were highly redundant.
* Luau does not yet have functionality to use generics in function signatures and functions so those type annotations are left out

### :x: Excluded

