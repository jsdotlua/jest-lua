# expect

Status: :hammer: In Progress

Source: https://github.com/facebook/jest/tree/v26.5.3/packages/expect

Version: v26.5.3

---

### :pencil2: Notes
* :warning: Since `not` is a reserved keyword in Lua, we use `never`.
* :warning: Several changes to matchers are made to maintain Lua-nativity. Corresponding changes are made to tests.
    * `toBeInstanceOf` can be used to check that the received value is an instance (or a derived instance) of the expected value, where the expected value is a prototype class. The matcher will error if either the received or expected value isn't an object.
    * `toBeDefined` is omitted and `toBeUndefined` check for `nil` since there is no `undefined` in Lua.
    * `toBeFalsy` and `toBeTruthy` checks for Lua falsy and truthy values, not JS ones
    * `toHaveLength` checks using the Lua length operator by default, but instead checks for a `length` property if the object has one
        * :warning: Length is only well defined for (non-sparse) array-like tables since the Lua `#` operator returns 0 for tables with key-value pairs
    * `toHaveLength` does not accept functions, can't get the argument count of a function in Lua
    * `toMatch` matches Lua string patterns instead of a `RegExp` whereas `toContain` matches exact substrings
    * `toStrictEqual` is omitted, there is no strict equality in Lua
    * The `Any` matcher is used to match *any* instance of a type or object given a constructor function. Lua doesn't have constructors for primitive types. Our deviation for this matcher therefore accepts either a typename string (e.g. "number", "boolean") or a table representing a prototype class, and will error otherwise.
        * If a typename string is passed in, the type is compared against the string.
        * If a table is passed in, it checks that the object passed in is an instance (or a derived instance) of the provided prototype class.
    ```lua
    any("number"):asymmetricMatch(1) -- true
    any("number"):toAsymmetricMatcher() -- "Any<number>"

    any(ClassA):asymmetricMatch(ClassA.new()) -- true
    any(ClassA):asymmetricMatch(ClassB.new()) -- false
    any(ClassA):asymmetricMatch(ChildOfClassA.new()) -- true
    ```
    * `StringMatching` accepts Lua string patterns instead of a `RegExp`
    * :warning: Although Jest has use cases where `toHaveProperty` is used to detect the existence of a property as `undefined`, we should never try to use `toHaveProperty` with `nil` as the property to check for
* Currently the testing file `jasmineUtils.spec.lua` does not actually mirror upstream but instead just takes the logic for some tests and runs them (since we don't have the matchers code translated yet)
* :warning: isError returns `true` for string and table types since we don't have a designated error type in Lua and these two types are what can be used to trigger an error
* The `printConstructorName` functions are omitted from `print`.
* The implementation of iterableEquality is not currently particularly useful since this equality only seems to make sense for upstream types such as Sets or Maps or types with custom Iterator Symbols

### :x: Excluded
```
```

### :package: [Dependencies](https://github.com/facebook/jest/blob/v26.5.3/packages/expect/package.json)
| Package | Version | Status | Notes |
| - | - | - | - |
| `@jest/types` | 26.5.2 | :x: Will not port | External type definitions are not a priority |
| `ansi-styles` | 4.0.0 | :x: Will not port | Console output styling is not a priority |
| `jest-get-type` | 26.3.0 | :heavy_check_mark: Ported | |
| `jest-matcher-utils` | 26.5.2 | :heavy_check_mark: Ported | |
| `jest-message-util` | 26.5.2 | :hammer: In Progress | Used for filtering stacktraces, low priority |
| `jest-regex-util` | 26.0.0 | :x: Will not port | No need for regex libraries |