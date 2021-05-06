---
id: mock-functions
title: Mock Functions
---

Mock functions allow you to test the links between code by erasing the actual implementation of a function, capturing calls to the function (and the parameters passed in those calls), capturing instances of constructor functions when instantiated with `new`, and allowing test-time configuration of return values.

## Using a mock function

Let's imagine we're testing an implementation of a function `forEach`, which invokes a callback for each item in a supplied array.

```lua
local function forEach(items, callback)
	for _, val in ipairs(items) do
		callback(val)
	end
end
```

To test this function, we can use a mock function, and inspect the mock's state to ensure the callback is invoked as expected.

```lua
local mockCallback = jest.fn()
forEach({0, 1}, mockCallback)

-- The mock function is called twice
expect(#mockCallback.mock.calls).toBe(2)

-- The first argument of the first call to the function was 0
expect(mockCallback.mock.calls[1][1]).toBe(0)

-- The first argument of the second call to the function was 1
expect(mockCallback.mock.calls[2][1]).toBe(1)
```

## `.mock` property

All mock functions have this special `.mock` property, which is where data about how the function has been called and what the function returned is kept. The `.mock` property also tracks the value of `self` for each call, so it is possible to inspect this as well:

```lua
local myMock = jest.fn()

local a = myMock.new()
local b = myMock.new()

expect(myMock.mock.instances[1]).toBe(a)
expect(myMock.mock.instances[2]).toBe(b)
```

These mock members are very useful in tests to assert how these functions get called, instantiated, or what they returned:

```lua
-- The function was called exactly once
expect(#someMockFunction.mock.calls).toBe(1)

-- The first arg of the first call to the function was 'first arg'
expect(someMockFunction.mock.calls[1][1]).toBe('first arg')

-- The second arg of the first call to the function was 'second arg'
expect(someMockFunction.mock.calls[1][3]).toBe('second arg')

-- The return value of the first call to the function was 'return value'
expect(someMockFunction.mock.results[1].value).toBe('return value')

-- This function was instantiated exactly twice
expect(#someMockFunction.mock.instances).toBe(2)
```

## Mock Return Values

Mock functions can also be used to inject test values into your code during a test:

```lua
local myMock = jest.fn()
print(myMock()) -- > nil

myMock.mockReturnValueOnce(10).mockReturnValueOnce('x').mockReturnValue(true)

print(myMock()) -- > 10
print(myMock()) -- > 'x'
print(myMock()) -- > true
print(myMock()) -- > true
```

Mock functions are also very effective in code that uses a functional continuation-passing style. Code written in this style helps avoid the need for complicated stubs that recreate the behavior of the real component they're standing in for, in favor of injecting values directly into the test right before they're used.

```lua
local filterTestFn = jest.fn()

-- Make the mock return `true` for the first call,
-- and `false` for the second call
filterTestFn.mockReturnValueOnce(true).mockReturnValueOnce(false)

local result = {}

for _, num in ipairs({11, 12}) do
	if filterTestFn(num) then
		table.insert(result, num)
	end
end

print(result) -- > {11}
print(filterTestFn.mock.calls) -- > {{11}, {12}}
```

Most real-world examples actually involve getting ahold of a mock function on a dependent component and configuring that, but the technique is the same. In these cases, try to avoid the temptation to implement logic inside of any function that's not directly being tested.

## Mock Implementations

Still, there are cases where it's useful to go beyond the ability to specify return values and full-on replace the implementation of a mock function. This can be done with `jest.fn` or the `mockImplementationOnce` method on mock functions.

```lua
local myMockFn = jest.fn(function(cb) return cb(nil, true) end)

myMockFn(function(err, val) print(val) end) -- > true
```

When you need to recreate a complex behavior of a mock function such that multiple function calls produce different results, use the `mockImplementationOnce` method:

```lua
local myMockFn = jest.fn()
	.mockImplementationOnce(function(cb) return cb(nil, true) end)
	.mockImplementationOnce(function(cb) return cb(nil, false) end)

myMockFn(function(err, val) print(val) end) -- > true
myMockFn(function(err, val) print(val) end) -- > false
```

When the mocked function runs out of implementations defined with `mockImplementationOnce`, it will execute the default implementation set with `jest.fn` (if it is defined):

```lua
local myMockFn = jest.fn(function() return 'default' end)
	.mockImplementationOnce(function() return 'first call' end)
	.mockImplementationOnce(function() return 'second call' end)

print(myMockFn()) -- > 'first call'
print(myMockFn()) -- > 'second call'
print(myMockFn()) -- > 'default'
print(myMockFn()) -- > 'default
```

For cases where we have methods that are typically chained (and thus always need to return `this`), we have an API for this in the form of a `.mockReturnThis()` function that also sits on all mocks:

```lua
local myObj = {
	myMethod = jest.fn().mockReturnThis(),
}
```

## Mock Names

You can optionally provide a name for your mock functions, which will be displayed instead of "jest.fn()" in the test error output. Use this if you want to be able to quickly identify the mock function reporting an error in your test output.

```lua
local myMockFn = jest.fn()
	.mockReturnValue('default')
	.mockName('onlyReturnsDefault')
```

## Custom Matchers

Finally, in order to make it less demanding to assert how mock functions have been called, we've added some custom matcher functions for you:

```lua
-- The mock function was called at least once
expect(mockFunc).toHaveBeenCalled()

-- The mock function was called at least once with the specified args
expect(mockFunc).toHaveBeenCalledWith(arg1, arg2)

-- The last call to the mock function was called with the specified args
expect(mockFunc).toHaveBeenLastCalledWith(arg1, arg2)
```

These matchers are sugar for common forms of inspecting the `.mock` property. You can always do this manually yourself if that's more to your taste or if you need to do something more specific:

```lua
-- The mock function was called at least once
expect(#mockFunc.mock.calls).toBeGreaterThan(0)

-- The mock function was called at least once with the specified args
expect(mockFunc.mock.calls).toContainEqual({arg1, arg2})

-- The last call to the mock function was called with the specified args
expect(mockFunc.mock.calls[#mockFunc.mock.calls]).toEqual({
	arg1,
	arg2,
})

-- The first arg of the last call to the mock function was `42`
-- (note that there is no sugar helper for this specific of an assertion)
expect(mockFunc.mock.calls[#mockFunc.mock.calls][1]).toBe(42)
```

For a complete list of matchers, check out the [reference docs](ExpectAPI.md).