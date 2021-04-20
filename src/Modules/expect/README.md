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
    * `toMatch` matches Lua string patterns or a LuauPolyfill `RegExp` whereas `toContain` matches exact substrings
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
    * `StringMatching` accepts Lua string patterns or a LuauPolyfill `RegExp`
    * :warning: Although Jest has use cases where `toHaveProperty` is used to detect the existence of a property as `undefined`, we should never try to use `toHaveProperty` with `nil` as the property to check for
    * `toStrictEqual` does not check for array sparseness or `undefined` properties like in Javascript. Its only difference from `toEqual` is that it also applies a Lua type/class check based on the Lua prototypical metatable inheritance pattern
* :warning: isError returns `true` for string and table types since we don't have a designated error type in Lua and these two types are what can be used to trigger an error
* The throwing matchers (e.g. `toThrow()`) will print out stack traces for ALL types (except `nil`) that are thrown whereas in Javascript the stack trace is only printed if you error with an Error type. In other words, executing a `toThrow` matcher on something like `throw ''` in Javascript will not end up printing the stack trace but doing so with `error("")` will print the stack trace for our Lua equivalent.
* :warning: When writing custom matchers with `expect.extend()`, a first argument `self` is needed to receive the `matcherContext`. It can be left empty with `_` if the `matcherContext` is not be needed.
* :warning: Currently, the spyMatchers have undefined behavior when used with jest-mock and function calls with `nil` arguments, this should be fixed by ADO-1395 (the matchers may work incidentally but there are no guarantees)

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