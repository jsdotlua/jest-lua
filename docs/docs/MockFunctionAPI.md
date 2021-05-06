---
id: mock-function-api
title: Mock Functions
---

Mock functions are also known as "spies", because they let you spy on the behavior of a function that is a direct (or indirect) collaborator of the module you're trying to test, rather than only testing the output. You can create a mock function with `jest.fn()`. If no implementation is given, the mock function will return `nil` when invoked.

## Methods

import TOCInline from "@theme/TOCInline";

<TOCInline toc={
	toc[toc.length - 1].children
}/>

---

## Reference

### `mockFn.getMockName()`

Returns the mock name string set by calling `mockFn.mockName(value)`.

### `mockFn.mock.calls`

An array containing the call arguments of all calls that have been made to this mock function. Each item in the array is an array of arguments that were passed during the call.

For example: A mock function `f` that has been called twice, with the arguments `f('arg1', 'arg2')`, and then with the arguments `f('arg3', 'arg4')`, would have a `mock.calls` array that looks like this:

```lua
{
	{'arg1', 'arg2'},
	{'arg3', 'arg4'},
}
```

### `mockFn.mock.results`

An array containing the results of all calls that have been made to this mock function. Each entry in this array is an object containing a `type` property, and a `value` property. `type` will be one of the following:

- `'return'` - Indicates that the call completed by returning normally.
<!-- - `'throw'` - Indicates that the call completed by throwing a value. -->
- `'incomplete'` - Indicates that the call has not yet completed. This occurs if you test the result from within the mock function itself, or from within a function that was called by the mock.

The `value` property contains the value that was thrown or returned. `value` is nil when `type == 'incomplete'`.

For example: A mock function `f` that has been called two times, returning `'result1'`, and then returning `'result2'`, would have a `mock.results` array that looks like this:

```lua
{
	{
		type = 'return',
		value = 'result1',
	},
	{
		type = 'return',
		value = 'result2',
	},
};
```

### `mockFn.mock.instances`

An array that contains all the object instances that have been instantiated from this mock function.

For example: A mock function that has been instantiated twice would have the following `mock.instances` array:

```lua
local mockFn = jest.fn()

local a = mockFn.new()
local b = mockFn.new()

mockFn.mock.instances[1] == a
mockFn.mock.instances[2] == b
```

### `mockFn.mockClear()`

Resets all information stored in the [`mockFn.mock.calls`](#mockfnmockcalls) and [`mockFn.mock.instances`](#mockfnmockinstances) arrays.

Often this is useful when you want to clean up a mock's usage data between two assertions.

Beware that `mockClear` will replace `mockFn.mock`, not just [`mockFn.mock.calls`](#mockfnmockcalls) and [`mockFn.mock.instances`](#mockfnmockinstances). You should, therefore, avoid assigning `mockFn.mock` to other variables, temporary or not, to make sure you don't access stale data.

### `mockFn.mockReset()`

Does everything that [`mockFn.mockClear()`](#mockfnmockclear) does, and also removes any mocked return values or implementations.

This is useful when you want to completely reset a _mock_ back to its initial state. (Note that resetting a _spy_ will result in a function with no return value).

Beware that `mockReset` will replace `mockFn.mock`, not just [`mockFn.mock.calls`](#mockfnmockcalls) and [`mockFn.mock.instances`](#mockfnmockinstances). You should, therefore, avoid assigning `mockFn.mock` to other variables, temporary or not, to make sure you don't access stale data.

### `mockFn.mockImplementation(fn)`

Accepts a function that should be used as the implementation of the mock. The mock itself will still record all calls that go into and instances that come from itself – the only difference is that the implementation will also be executed when the mock is called.

_Note: `jest.fn(implementation)` is a shorthand for `jest.fn().mockImplementation(implementation)`._

For example:

```lua
local mockFn = jest.fn().mockImplementation(function(scalar) return 42 + scalar end)
-- or: jest.fn(function(scalar) return 42 + scalar end)

local a = mockFn(0)
local b = mockFn(1)

a == 42 == true
b == 43 == true

mockFn.mock.calls[1][1] == 0 -- true
mockFn.mock.calls[2][1] == 1 -- true
```

:::caution
Mocks should be lightweight and easy to maintain and/or refactor, so users should favor `mockReturnValue` over `mockImplementation` or `mockImplementationOnce` instead where possible.
:::

### `mockFn.mockImplementationOnce(fn)`

Accepts a function that will be used as an implementation of the mock for one call to the mocked function. Can be chained so that multiple function calls produce different results.

```lua
local myMockFn = jest.fn()
	.mockImplementationOnce(function(cb) return cb(nil, true) end)
	.mockImplementationOnce(function(cb) return cb(nil, false) end)

myMockFn(function(err, val) print(val) end) -- true
myMockFn(function(err, val) print(val) end) -- false
```

When the mocked function runs out of implementations defined with mockImplementationOnce, it will execute the default implementation set with `jest.fn(function() return defaultValue end)` or `.mockImplementation(function() return defaultValue end)` if they were called:

```lua
local myMockFn = jest.fn(function() return 'default' end)
	.mockImplementationOnce(function() return 'first call' end)
	.mockImplementationOnce(function() return 'second call' end)

print(myMockFn()) -- > 'first call'
print(myMockFn()) -- > 'second call'
print(myMockFn()) -- > 'default'
print(myMockFn()) -- > 'default
```

### `mockFn.mockName(value)`

Accepts a string to use in test result output in place of "jest.fn()" to indicate which mock function is being referenced.

For example:

```lua
local mockFn = jest.fn().mockName('mockedFunction')
-- mockFn()
expect(mockFn).toHaveBeenCalled()
```

Will result in this error:

```
expect(mockedFunction).toHaveBeenCalled()

Expected number of calls: >= 1
Received number of calls:    0
```

### `mockFn.mockReturnThis()`

Sets the implementation of `mockFn` to return itself whenenever the mock function is called.

### `mockFn.mockReturnValue(value)`

Accepts a value that will be returned whenever the mock function is called.

```lua
local mock = jest.fn()
mock.mockReturnValue(42)
mock() -- 42
mock.mockReturnValue(43)
mock() -- 43
```

### `mockFn.mockReturnValueOnce(value)`

Accepts a value that will be returned for one call to the mock function. Can be chained so that successive calls to the mock function return different values. When there are no more `mockReturnValueOnce` values to use, calls will return a value specified by `mockReturnValue`.

```lua
local myMockFn = jest.fn()
	.mockReturnValue('default')
	.mockReturnValueOnce('first call')
	.mockReturnValueOnce('second call')

print(myMockFn()) -- > 'first call'
print(myMockFn()) -- > 'second call'
print(myMockFn()) -- > 'default'
print(myMockFn()) -- > 'default
```
