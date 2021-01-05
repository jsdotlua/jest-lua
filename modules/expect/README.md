# expect

Status: :hammer: In Progress

Source: https://github.com/facebook/jest/tree/v26.5.3/packages/expect

Version: v26.5.3

---

### :pencil2: Notes
* :warning: Since `not` is a reserved keyword in Lua, we use `never`.
* :warning: The `StringMatching` matcher accepts Lua string patterns instead of a `RegExp` to be more Lua-native.
* Currently the testing file `jasmineUtils.spec.lua` does not actually mirror upstream but instead just takes the logic for some tests and runs them (since we don't have the matchers code translated yet)
* The `Any` matcher is used to match *any* instance of a type or object. Since we don't have constructors for primitive types, we opt for a slightly different interface that allows us to capture the same behavior.
```javascript
any(Number).asymmetricMatch(1) // true
any(Number).toAsymmetricMatcher() // "Any<Number>"
```
```lua
any(100):asymmetricMatch(1) -- true
any(100):toAsymmetricMatcher() -- "Any<number>"
```
* :warning: isError returns true for string and table types since we don't have a designated error type in Lua and these two types are what can be used to trigger an error
* The implementation of iterableEquality is not currently particularly useful since this equality only seems to make sense for upstream types such as Sets or Maps or types with custom Iterator Symbols

### :x: Excluded
```
```

### :package: [Dependencies]()
| Package | Version | Status | Notes |
| - | - | - | - |
