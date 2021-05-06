---
id: using-matchers
title: Using Matchers
---

Jest Roblox uses "matchers" to let you test values in different ways. This document will introduce some commonly used matchers. For the full list, see the [`expect` API doc](expect).

## Common Matchers

The simplest way to test a value is with exact equality.

```lua
it('two plus two is four', function()
	expect(2 + 2).toBe(4)
end)
```

In this code, `expect(2 + 2)` returns an "expectation" object. You typically won't do much with these expectation objects except call matchers on them. In this code, `.toBe(4)` is the matcher. When Jest Roblox runs, it tracks all the failing matchers so that it can print out nice error messages for you.

`toBe` tests exact equality. If you want to check the value of an object, use `toEqual` instead:

```lua
it('object assignment', function()
	local data = { one = 1 }
	data['two'] = 2
	expect(data).toEqual({one = 1, two = 2})
end)
```

`toEqual` recursively checks every field of a table.

You can also test for the opposite of a matcher:

```lua
it('adding positive numbers is not zero', function()
	expect(1 + 2).never.toBe(0)
end)
```

## Truthiness

In tests, you sometimes need to distinguish between `nil`, and `false`, but you sometimes do not want to treat these differently. Jest Roblox contains helpers that let you be explicit about what you want.

- `toBeNil` matches only `nil`
- `toBeTruthy` matches anything that an `if` statement treats as `true` (anything but `false` and `nil`)
- `toBeFalsy` matches anything that an `if` statement treats as `false` (`false` and `nil`)

The following are identical to the ones above but are provided for the sake of completeness:
- `toBeUndefined` is identical to `toBeNil`
- `toBeNull` is an alias of `toBeNil`
- `toBeDefined` is identical to `never.toBeNil`

For example:

```lua
it('nil', function()
	local n = nil
	expect(n).toBeNil()
	expect(n).never.toBeTruthy()
	expect(n).toBeFalsy()
end)

it('false', function()
	local z = false
	expect(z).never.toBeNull()
	expect(z).never.toBeTruthy()
	expect(z).toBeFalsy()
end)
```

You should use the matcher that most precisely corresponds to what you want your code to be doing.

## Numbers

Most ways of comparing numbers have matcher equivalents.

```lua
it('two plus two', function()
	local value = 2 + 2
	expect(value).toBeGreaterThan(3)
	expect(value).toBeGreaterThanOrEqual(3.5)
	expect(value).toBeLessThan(5)
	expect(value).toBeLessThanOrEqual(4.5)

	-- toBe and toEqual are equivalent for numbers
	expect(value).toBe(4)
	expect(value).toEqual(4)
end)
```

For floating point equality, use `toBeCloseTo` instead of `toEqual`, because you don't want a test to depend on a tiny rounding error.

```lua
it('adding floating point numbers', function()
	local value = 0.1 + 0.2
	expect(value).toBeCloseTo(0.3)
end)
```

## Strings

You can check strings against [Lua string patterns](https://developer.roblox.com/en-us/articles/string-patterns-reference) with `toMatch`:

```lua
it('there is no I in team', function()
	expect('team').not.toMatch('I')
end)

it('but there is a "stop" in Christoph', function()
	expect('Christoph').toMatch('stop')
end)
```

You can also check strings against a regular expression using [`RegExp` from LuauRegExp](expect#regexp):

```lua
it('Christoph ends in "oph"', function()
	expect('Christoph').toMatch(RegExp('oph$'))
end)
```

You can check if a string contains an exact substring using `toContain`:
```lua
it('there is a "stop" in Christoph', function()
	expect('Christoph').toContain('stop')
end)
```

## Tables

You can check if an array contains a particular item using `toContain` or that a string contains a particular substring:

```lua
local shoppingList = {
	'diapers',
	'kleenex',
	'trash bags',
	'paper towels',
	'beer',
}

it('the shopping list has beer on it', function()
	expect(shoppingList).toContain('beer')
end)
```

`toContain` performs a shallow equality so if you need to check that a specific table exists within the array, use `.toContainEqual`.
```lua
local shoppingList = {
	{'milk', 4},
	{'bananas', 10},
	{'beer', 1},
}

it('the shopping list contains {"beer", 1}', function()
	expect(shoppingList).toContainEqual({'beer', 1})
end)
```

You can also check that a table is equal to another table by using `toEqual`. This recursively compares all properties of the tables.

```lua
local inventory = {
	lacroix = {
		pamplemousse = 3,
		passionfruit = 10,
	},
	beer = {
		budweiser = 3,
	}
}

it('the inventory matches', function()
	expect(inventory.lacroix).toEqual({
		lacroix = {
			pamplemousse = 3,
			passionfruit = 10,
		},
		beer = {
			budweiser = 3,
		}
	})
end)
```

Lastly, you can check that a table has a property and value by using `.toHaveProperty`.
```lua
it('the inventory has 3 budweisers', function()
	expect(inventory).toHaveProperty('beer.budweiser', 3)
end)

it('the inventory does not have guinness', function()
	expect(inventory).never.toHaveProperty('beer.guinness')
end)
```

## Exceptions

If you want to test whether a particular function throws an error when it's called, use `toThrow`.

```lua
function thisFunctionErrors()
	error('oh no')
end

it('the function errors', function()
	expect(thisFunctionErrors).toThrow()

	-- You can also use the exact error message or a RegExp using the LuauRegExp library
	expect(thisFunctionErrors).toThrow('oh no')
	expect(thisFunctionErrors).toThrow(RegExp('no'))
end)
```

## And More

This is just a taste. For a complete list of matchers, check out the [reference docs](expect).
