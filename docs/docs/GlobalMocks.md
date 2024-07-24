---
id: global-mocks
title: Global Mocks
---

<img alt='Roblox only' src='img/roblox-only.svg'/>

It can be desirable to track how an implementation interacts with Luau globals.
For example, you might want to test that a certain message is printed to the
console, or you might want to take control of the random number generator to get
a deterministic, predictable sequence of numbers.

It isn't normally easy to mock these functions in the global Luau environment,
but Jest can replace their implementations for you, giving you a familiar
interface as if you're mocking any other regular function.

:::warning

Jest Roblox does not support mocking all globals - only a few are whitelisted.
If you try to mock a global which is not whitelisted, you will see an error
message that looks similar to this:

```
Jest does not yet support mocking the require global.
```

Most notably, Jest Roblox does not support mocking these globals:

- `game:GetService()` and other Instance methods (an API for this is being investigated)
- the `require()` function (use [`jest.mock()`](jest-object) instead)
- task scheduling functions (use [Timer Mocks](timer-mocks) instead)

:::

## Mock a Global Function

In the following example, we mock the global `print()` function so that our test
can see what's being printed. This is done as if you're spying on a table using
`jest.spyOn()`, except you use `jest.globalEnv` as the table.

```lua title="limerick.lua"
return function()
	print("There once was a print() in a test")
	print("It would cause the maintainers unrest")
	print("Printing all 'round the clock")
	print("Beyond what they could mock")
	print("Until globalEnv landed in Jest!")
end
```

```lua title="__tests__/limerick.spec.lua"
local jest = JestGlobals.jest

test('mentions print() in the first line', function()
	local limerick = require(Workspace.limerick)

	local mockPrint = jest.spyOn(jest.globalEnv, "print")
	mockPrint.mockImplementationOnce(function(firstLine: string, ...: string)
		expect(firstLine).toEqual(expect.stringContaining("print()"))
	end)

	limerick()
end)
```

## Mocking Globals in Libraries

You can mock functions in libraries like `math` by indexing into
`jest.globalEnv` with the name of the library. The following example shows how
to mock `math.random()` to return a predictable number.

```lua title="diceRoll.lua"
return function()
	return "You rolled a " .. math.random(1, 6)
end
```

```lua title="__tests__/diceRoll.spec.lua"
local jest = JestGlobals.jest

test('correctly formats returned message', function()
	local diceRoll = require(Workspace.diceRoll)

	local mockRandom = jest.spyOn(jest.globalEnv.math, "random")
	mockRandom.mockImplementationOnce(function(_min: number?, _max: number?)
		return 5
	end)

	expect(diceRoll()).toBe("You rolled a 5")
end)
```

## Use Original Implementation

You can use the original (non-mocked) variant of the global function at any
time. Original implementations are available by indexing into `globalEnv` with
the name of the function you need access to.

```lua
local mockRandom = jest.spyOn(jest.globalEnv.math, "random")
mockRandom.mockImplementation(function(_min: number?, _max: number?)
	return 5
end)

-- will always be 5
local mocked = math.random()
-- will be some random number between 0 and 1
local unmocked = jest.globalEnv.math.random()
```