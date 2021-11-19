---
id: deviations
title: Deviations
---

The Jest Roblox alignment effort aims to map as closely to Jest's API as possible, but there are a few places where language deviations require us to omit functionality or deviate our approach. Deviations are also sometimes made to maintain Lua-nativity. Any user-facing deviations are documented here.

## Expect

### `.never`
Since `not` is a reserved keyword in Lua, Jest Roblox uses `never` to test the opposite of a matcher.

### `expect.extend(matchers)`
The first argument that a custom matcher takes in `expect.extend(matchers)` always needs to be a `self`, which is assigned the `matcherContext`. It can be left empty with a `_` if the `matcherContext` is not needed. See the [Custom Matchers API doc](expect#custom-matchers-api) for more information.

```lua
expect.extend({
	yourMatcher = function(self, y, z)
		return {
			pass = true,
			message = function() return '' end
		}
	end
})
```

### `expect.any(typename | prototype)`
Lua doesn't have constructors for primitive types, so `expect.any` accepts either a typename string (e.g. `"number"`, `"boolean"`) or a table representing a prototype class.
- If a typename string is passed in, it checks that the received value has the `typeof()` value as the expected string
- If a table is passed in, it checks that the received value in is an instance (or a derived instance) of the expected table, using the [`instanceof` method in LuauPolyfill](https://github.com/Roblox/luau-polyfill/blob/main/src/instanceof.lua)

### `expect.stringMatching(string | regexp)`
`expect.stringMatching(string | regexp)` can either accept a [Lua string pattern](https://developer.roblox.com/en-us/articles/string-patterns-reference) or a [LuauRegExp RegExp object](expect#regexp).

### `.toHaveLength(number)`
`.toHaveLength(number)` uses the Lua `#` operator to check the length of the received value. Since `#` is only well defined for non-sparse array-like tables and strings it will return 0 for tables with key-value pairs. It also checks the `.length` property of the table instead if it has one.

`.toHaveLength` **cannot** be used to check the argument count of a function.

### `.toBeFalsy()`
`.toBeFalsy()` checks for Lua falsy values, which are only `false` and `nil`. That means that unlike in Javscript, `expect(0).toBeFalsy()` **does not** pass. Consequently, `.toBeTruthy()` matches anything that isn't `false` or `nil`.

### `.toBeNil()`
When doing `nil` checking, use of `.toBeNil()` and `.never.toBeNil()` is encouraged to maintain Lua syntax. The following methods are identical but provided for the sake of completeness:
- `.toBeUndefined()` is identical to `.toBeNil()`
- `.toBeDefined()` is identical to `.never.toBeNil()`
- `.toBeNull()` is an alias of `.toBeNil()`

### `.toBeInstanceOf(prototype)`
`.toBeInstanceOf(prototype)` uses the [`instanceof` method in LuauPolyfill](https://github.com/Roblox/luau-polyfill/blob/main/src/instanceof.lua) to check that a value is an instance (or a derived instance) of a prototype class.

### `.toMatchInstance(table)`
`.toMatchInstance` is custom matcher unique to Jest Roblox that allows for matching a Roblox Instance against a table of properties.

### `.toStrictEqual()`
`toStrictEqual()` performs a `toEqual` comparison with an additional type/class check based on metatable inheritance. Our `toStrictEqual` does not check for array sparseness or for `undefined` values like the matcher does in Javascript's Jest.

### `.toThrow(error?)`
`.toThrow(error?)` can also accept custom Error objects provided by LuauPolyfill.

## Mock Functions

### `jest.fn()`
`jest.fn()` returns two values. The first return value is the mock object, which is a callable table and _can_ be treated as a mock function if the tested code accepts a callable table as being interchangeable with a function.

For cases where the tested code requires a function, pass in the second return value of `jest.fn()`, which is a forwarding function that calls the mock.
```lua
local mock, mockFn = jest.fn()
mockFn()
expect(mock).toHaveBeenCalled()
```

Note that this remains backward compatible with Jest tests translated from JavaScript, since the second argument will be dropped if not explicitly assigned.

### `mockFn.new`
Our translation of `new mockFn()` in Javascript is `mockFn.new()`

So for the following code pattern in Javascript:
```javascript
const mockFn = jest.fn()
const instance1 = new mockFn()
```
We would write it in Lua as:
```lua
local mockFn = jest.fn()
local instance1 = mockFn.new()
```