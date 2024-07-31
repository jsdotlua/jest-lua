---
id: asynchronous
title: Testing Asynchronous Code
---
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/asynchronous)

It's common in Lua for code to run asynchronously. When you have code that runs asynchronously, Jest Roblox needs to know when the code it is testing has completed, before it can move on to another test. Jest Roblox has several ways to handle this.

## Promises

Return a [promise](https://github.com/evaera/roblox-lua-promise) from your test, and Jest Roblox will wait for that promise to resolve. If the promise is rejected, the test will fail.

For example, let's say that `fetchData` returns a promise that is supposed to resolve to the string `'peanut butter'`. We could test it with:

:::note
Tests can **ONLY** return either a `Promise` or `nil`.
:::

```lua
test('the data is peanut butter', function()
	return Promise.resolve()
		:andThen(function()
			local data = fetchData()
			expect(data).toBe('peanut butter')
		end)
end)
```

## Callbacks

If you don't use promises, you can use callbacks. For example, let's say that `fetchData`, instead of returning a promise, expects a callback, i.e. fetches some data and calls `callback(error, data)` when it is complete. You want to test that this returned data is the string `'peanut butter'`.

By default, Jest Roblox tests complete once they reach the end of their execution. That means this test will _not_ work as intended:

```lua
-- Don't do this!
test('the data is peanut butter', function()
	local function callback(error_, data)
		if error_ then
			error(error_)
		end
		expect(data).toBe('peanut butter')
	end

	fetchData(callback)
end)
```

The problem is that the test will complete as soon as `fetchData` completes, before ever calling the callback.

There is an alternate form of `test` that fixes this. Instead of putting the test in a function with an empty argument, use a single argument called `done`, which is passed as a second parameter to the `test` function. Jest Roblox will wait until the `done` callback is called before finishing the test.

```lua
test('the data is peanut butter', function(_, done)
	local function callback(error_, data)
		if error_ then
			done(error_)
			return
		end
		xpcall(function()
			expect(data).toBe('peanut butter')
			done()
		end, function(err)
			done(err)
		end)
	end

	fetchData(callback)
end)
```

If `done()` is never called, the test will fail (with timeout error), which is what you want to happen.

If the `expect` statement fails, it throws an error and `done()` is not called. If we want to see in the test log why it failed, we have to wrap `expect` in a `xpcall` block and pass the error in the error handler to `done`. Otherwise, we end up with an opaque timeout error that doesn't show what value was received by `expect(data)`.

:::danger
`done()` should not be mixed with Promises in your tests.
:::
