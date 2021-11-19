---
id: jest-object
title: The Jest Object
---

The methods in the `jest` object help create mocks.

## Mock functions

### `jest.fn(implementation)`

Returns a new, unused [mock function](MockFunctionAPI.md). Optionally takes a mock implementation.

```lua
local mockFn = jest.fn()
mockFn()
expect(mockFn).toHaveBeenCalled()

-- With a mock implementation:
local returnsTrue = jest.fn(function() return true end)
print(returnsTrue()) -- true
```

:::info
`jest.fn()` returns both a callable table and a function. If a function is needed, pass in the second return value. See the [deviation](Deviations.md#jestfn) note.
:::

### `jest.clearAllMocks()`

Clears the `mock.calls` and `mock.instances` properties of all mocks. Equivalent to calling [`.mockClear()`](MockFunctionAPI.md#mockfnmockclear) on every mocked function.

This can be included in a `beforeEach()` block in your text fixture to clear out the state of all mocks before each test.

Returns the `jest` object for chaining.

### `jest.resetAllMocks()`

Resets the state of all mocks, but retains all the instances. Equivalent to calling [`.mockReset()`](MockFunctionAPI.md#mockfnmockreset) on every mocked function.

Returns the `jest` object for chaining.
