# expect

Status: :hammer: In Progress

Source: https://github.com/facebook/jest/tree/v26.5.3/packages/expect

Version: v26.5.3

---

### :pencil2: Notes
* :warning: Since `not` is a reserved keyword in Lua, we use `never`.
* :warning: The `StringMatching` matcher accepts Lua string patterns instead of a `RegExp` to be more Lua-native.
* Currently the testing file `jasmineUtils.spec.lua` does not actually mirror upstream but instead just takes the logic for some tests and runs them (since we don't have the matchers code translated yet)
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
* :warning: isError returns true for string and table types since we don't have a designated error type in Lua and these two types are what can be used to trigger an error
* The implementation of iterableEquality is not currently particularly useful since this equality only seems to make sense for upstream types such as Sets or Maps or types with custom Iterator Symbols

### :x: Excluded
```
```

### :package: [Dependencies]()
| Package | Version | Status | Notes |
| - | - | - | - |
