---
id: expect
title: Expect
---

When you're writing tests, you often need to check that values meet certain conditions. `expect` gives you access to a number of "matchers" that let you validate different things.

### RegExp
To use regular expressions in matchers that support it, you need to add [LuauRegExp](https://github.com/Roblox/luau-regexp) as a dependency in your `rotriever.toml` and require it in your code.
```yaml title="rotriever.toml"
[dev_dependencies]
RegExp = "github.com/roblox/luau-regexp@0.1.3"
```

```lua
local RegExp = require(Packages.RegExp)
```

### Error
LuauPolyfill also provides an extensible `Error` class that can be used with throwing matchers.

```lua
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
```

To create a custom `Error`, require `extends` from LuauPolyfill and call it on the `Error` class.
```lua
local extends = LuauPolyfill.extends

local OhNoError = extends(Error, 'OhNoError', function(self, message)
	self.message = message
	self.name = 'OhNoError'
end)

local function thisFunctionErrors()
	error(OhNoError('oh no'))
end
```

## Methods

import TOCInline from "@theme/TOCInline";

<TOCInline toc={
	toc[toc.length - 1].children
}/>

---

## Reference

### `expect(value)`

The `expect` function is used every time you want to test a value. You will rarely call `expect` by itself. Instead, you will use `expect` along with a "matcher" function to assert something about value.

It's easier to understand this with an example. Let's say you have a method `bestLaCroixFlavor()` which is supposed to return the string `'grapefruit'`. Here's how you would test that:

```lua
it('the best flavor is grapefruit', function()
	expect(bestLaCroixFlavor()).toBe('grapefruit')
end)
```

In this case, `toBe` is the matcher function. There are a lot of different matcher functions, documented below, to help you test different things.

The argument to `expect` should be the value that your code produces, and any argument to the matcher should be the correct value. If you mix them up, your tests will still work, but the error messages on failing tests will look strange.

### `expect.extend(matchers)`

You can use `expect.extend` to add your own matchers to Jest Roblox. For example, let's say that you're testing a number utility library and you're frequently asserting that numbers appear within particular ranges of other numbers. You could abstract that into a `toBeWithinRange` matcher:

```lua
expect.extend({
	toBeWithinRange = function(self, received, floor, ceiling)
		local pass = received >= floor and received <= ceiling
		if pass then
			message = function()
				string.format(
					'expected %s not to be within range %s - %s',
					tostring(actual), tostring(floor), tostring(ceiling)
				)
			end
		else
			message = function()
				return string.format(
					'expected %s to be within range %s - %s',
					tostring(actual), tostring(floor), tostring(ceiling)
				)
			end
		end
		return {message = message, pass = pass}
	end
})

it('numeric ranges', function()
	expect(100).toBeWithinRange(90, 110)
	expect(101).never.toBeWithinRange(0, 100)
	expect({apples = 6, bananas = 3}).toEqual({
		apples = expect.toBeWithinRange(1, 10),
		bananas = expect.never.toBeWithinRange(11, 20),
	})
)
end)
```

#### Custom Matchers API

Matchers should return a table with two keys. `pass` indicates whether there was a match or not, and `message` provides a function with no arguments that return an error message in case of failure. Thus, when `pass` is false, `message` should return the error message for when `expect(x).yourMatcher()` fails. And when `pass` is true, `message` should return the error message for when `expect(x).never.yourMatcher()` fails.

Matchers are called with the argument passed to `expect(x)` followed by the arguments passed to `.yourMatcher(y, z)`.

```lua
expect.extend({
	yourMatcher = function(_, y, z)
		return {
			pass = true,
			message = function() return '' end
		}
	end
})
```
Note that the first argument of a custom matcher always needs to be a `self` but it can be a `_` if the `matcherContext` does not need to be referenced.

These helper functions and properties can be found on `self` inside a custom matcher:

#### `self.isNever`

A boolean to let you know this matcher was called with the negated `.never` modifier allowing you to display a clear and correct matcher hint.

#### `self.equals(a, b)`

This is a deep-equality function that will return `true` if two objects have the same values (recursively).

#### `self.utils`

There are a number of helpful tools exposed on `self.utils` primarily consisting of the exports from [`jest-matcher-utils`](https://github.com/Roblox/jest-roblox/blob/master/src/jest-matcher-utils/src/init.lua).

The most useful ones are `matcherHint`, `printExpected` and `printReceived` to format the error messages nicely. For example, take a look at this implementation for the `toBe` matcher:

```lua
expect.extend({
	toBe = function(self, received, expected)
		local options = {
			comment = 'shallow equality',
			isNot = self.isNot,
			promise = self.promise,
		}

		local pass = received == expected
		local message
		if pass then
			message = function()
				return self.utils.matcherHint('toBe', nil, nil, options) ..
					'\n\n' ..
					string.format('Expected: never %s\n', self.utils.printExpected(expected)) ..
					string.format('Received: %s', self.utils.printReceived(expected))
			end
		else
			message = function()
				return self.utils.matcherHint('toBe', nil, nil, options) ..
					'\n\n' ..
					string.format('Expected: %s\n', self.utils.printExpected(expected)) ..
					string.format('Received: %s', self.utils.printReceived(expected))
			end
		end

		return {actual = received, pass = pass message = message}
	end
})
```

This will print something like this:

```bash
expect(received).toBe(expected)

Expected: "banana"
Received: "apple"
```

When an assertion fails, the error message should give as much signal as necessary to the user so they can resolve their issue quickly. You should craft a precise failure message to make sure users of your custom assertions have a good developer experience.

#### Custom snapshot matchers

To use snapshot testing inside of your custom matcher you can import `jestSnapshot` and use it from within your matcher.

Here's a snapshot matcher that trims a string to store for a given length, `.toMatchTrimmedSnapshot(length)`:

```lua
local JestRoblox = require(Packages.JestRoblox).Globals
local toMatchSnapshot = JestRoblox.jestSnapshot.toMatchSnapshot

expect.extend({
	toMatchTrimmedSnapshot = function(self, received, length)
		return toMatchSnapshot(
			self,
			string.sub(received, 1, length),
			'toMatchTrimmedSnapshot'
		)
	end
})

it('stores only 10 characters', function()
	expect('extra long string oh my gerd').toMatchTrimmedSnapshot(10)
end)

-- Stored snapshot will look like:
-- exports["another package custom snapshot matcher: toMatchTrimmedSnapshot 1"] = [=[
-- "extra long"]=]
```

### `expect.anything()`

`expect.anything()` matches anything but `nil`. You can use it inside `toEqual` or `toBeCalledWith` instead of a literal value. For example, if you want to check that a mock function is called with a non-nil argument:

```lua
it('mock calls its argument with a non-nil argument', function()
	local mock = jest.fn()
	mock('a')
	expect(mock).toBeCalledWith(expect.anything())
end)
```

### `expect.any(typename | prototype)`

`expect.any(typename)` matches anything that has the given type. `expect.any(prototype)` matches anything that is an instance (or a derived instance) of the given prototype class. You can use it inside `toEqual` or `toBeCalledWith` instead of a literal value. For example:

```lua
local function identity(a)
	return a
end

it('identity calls its callback with CustomClass', function()
	local mock = jest.fn()
	identity(CustomClass.new())
	expect(mock).toBeCalledWith(expect.any(CustomClass))
end)
```

In addition to Lua prototype classes, it also supports Roblox types like [`DateTime`](https://developer.roblox.com/en-us/api-reference/datatype/DateTime), Luau types like `thread`, `RegExp` from the LuauRegExp library, and LuauPolyfill types like `Symbol`, `Set`, `Error` etc.

### `expect.arrayContaining(array)`

`expect.arrayContaining(array)` matches a received array which contains all of the elements in the expected array. That is, the expected array is a **subset** of the received array. Therefore, it matches a received array which contains elements that are **not** in the expected array.

You can use it instead of a literal value:

- in `toEqual`
- to match a property in `objectContaining` or `toMatchObject`

```lua
describe('arrayContaining', function()
	local expected = {'Alice', 'Bob'}
	it('matches even if received contains additional elements', function()
		expect({'Alice', 'Bob', 'Eve'}).toEqual(expect.arrayContaining(expected))
	end)
	it('does not match if received does not contain expected elements', function()
		expect({'Bob', 'Eve'}).never.toEqual(expect.arrayContaining(expected))
	end)
end)
```

```lua
describe('Beware of a misunderstanding! A sequence of dice rolls', function()
	local expected = {1, 2, 3, 4, 5, 6}
	it('matches even with an unexpected number 7', function()
		expect({4, 1, 6, 7, 3, 5, 2, 5, 4, 6}).toEqual(
			expect.arrayContaining(expected)
		)
	end)
	it('does not match without an expected number 2', function()
		expect({4, 1, 6, 7, 3, 5, 7, 5, 4, 6}).never.toEqual(
			expect.arrayContaining(expected)
		)
	end)
end)
```

### `expect.never.arrayContaining(array)`

`expect.never.arrayContaining(array)` matches a received array which does not contain all of the elements in the expected array. That is, the expected array **is not a subset** of the received array.

It is the inverse of `expect.arrayContaining`.

```lua
describe('never.arrayContaining', function()
	local expected = {'Samantha'}

	it('matches if the actual array does not contain the expected elements', function()
		expect({'Alice', 'Bob', 'Eve'}).toEqual(
			expect.never.arrayContaining(expected),
		)
	end)
end)
```

### `expect.never.objectContaining(table)`

`expect.never.objectContaining(table)` matches any received table that does not recursively match the expected properties. That is, the expected table **is not a subset** of the received table. Therefore, it matches a received table which contains properties that are **not** in the expected table.

It is the inverse of `expect.objectContaining`.

```lua
describe('never.objectContaining', function()
	local expected = {foo = 'bar'}

	it('matches if the actual object does not contain expected key: value pairs', function()
		expect({bar = 'baz'}).toEqual(expect.never.objectContaining(expected))
	end)
end)
```

### `expect.never.stringContaining(string)`

`expect.never.stringContaining(string)` matches the received value if it is not a string or if it is a string that does not contain the exact expected string.

It is the inverse of `expect.stringContaining`.

```lua
describe('never.stringContaining', function()
	local expected = 'Hello world!'

	it('matches if the received value does not contain the expected substring', function()
		expect('How are you?').toEqual(expect.never.stringContaining(expected))
	end)
end)
```

### `expect.never.stringMatching(string | regexp)`

`expect.never.stringMatching(string | regexp)` matches the received value if it is not a string or if it is a string that does not match the expected [Lua string pattern](https://developer.roblox.com/en-us/articles/string-patterns-reference) or [regular expression](#regexp).

It is the inverse of `expect.stringMatching`.

```lua
describe('never.stringMatching', function()
	local expected = 'Hello world!'

	it('matches if the received value does not match the expected regex', function()
		expect('How are you?').toEqual(expect.never.stringMatching(expected))
	end)
end)
```

### `expect.objectContaining(table)`

`expect.objectContaining(table)` matches any received table that recursively matches the expected properties. That is, the expected table is a **subset** of the received table. Therefore, it matches a received table which contains properties that **are present** in the expected table.

Instead of literal property values in the expected table, you can use matchers, `expect.anything()`, and so on.

For example:

```lua
it('received contains a number x and a number y', function()
	local received = {x = 10, y = 20, z = 30}
	expect(received).toEqual(
		expect.objectContaining({
			x = expect.any('number'),
			y = expect.any('number'),
		})
	)
end)
```

### `expect.stringContaining(string)`

`expect.stringContaining(string)` matches the received value if it is a string that contains the exact expected string.

### `expect.stringMatching(string | regexp)`

`expect.stringMatching(string | regexp)` matches the received value if it is a string that matches the expected [Lua string pattern](https://developer.roblox.com/en-us/articles/string-patterns-reference) or [regular expression](#regexp).

You can use it instead of a literal value:

- in `toEqual`
- to match an element in `arrayContaining`
- to match a property in `objectContaining` or `toMatchObject`

This example also shows how you can nest multiple asymmetric matchers, with `expect.stringMatching` inside the `expect.arrayContaining`.

```lua
describe('stringMatching in arrayContaining', function()
	local expected = {
		expect.stringMatching(RegExp('^Alic')),
		expect.stringMatching(RegExp('^[BR]ob'),
	}
	it('matches even if received contains additional elements', function()
		expect({'Alicia', 'Roberto', 'Evelina'}).toEqual(
			expect.arrayContaining(expected)
		)
	end)
	it('does not match if received does not contain expected elements', function()
		expect({'Roberto', 'Evelina'}).never.toEqual(
			expect.arrayContaining(expected)
		)
	end)
end)
```

### `expect.addSnapshotSerializer(serializer)`

You can call `expect.addSnapshotSerializer` in a `beforeAll()` to add a module that formats application-specific data structures.

Call `expect.resetSnapshotSerializers` in an `afterAll()` block to ensure that the serializer is specific to this test file and doesn't affect other tests being run.

```lua
beforeAll(
	expect.addSnapshotSerializer(serializer)
)

afterAll(
	expect.resetSnapshotSerializers()
)

-- affects expect(value).toMatchSnapshot() assertions in the test file
```

### `expect.resetSnapshotSerializers()`

Clears the list of custom snapshot serializers.

If custom snapshot serializers are used, this should be included in an `afterAll()` block to reset the list of custom snapshot serializers before the next test file is run.

### `.never`

If you know how to test something, `.never` lets you test its opposite. For example, this code tests that the best La Croix flavor is not coconut:

```lua
it('the best flavor is not coconut', function()
	expect(bestLaCroixFlavor()).never.toBe('coconut')
end)
```

### `.toBe(value)`

Use `.toBe` to compare primitive values or to check referential identity of tables. It calls [Luau Polyfill's `Object.is`](https://github.com/Roblox/luau-polyfill/blob/main/src/Object/is.lua) to compare values, which mostly behaves like the `==` operator.

For example, this code will validate some properties of the `can` object:

```lua
local can = {
	name = 'pamplemousse',
	ounces = 12,
}

describe('the can', function()
	it('has 12 ounces', function()
		expect(can.ounces).toBe(12)
	end)

	it('has a sophisticated name', function()
		expect(can.name).toBe('pamplemousse')
	end)
end)
```

Don't use `.toBe` with floating-point numbers. For example, due to rounding, in Lua, `0.2 + 0.1` is not strictly equal to `0.3`. If you have floating point numbers, try `.toBeCloseTo` instead.

Although the `.toBe` matcher **checks** referential identity, it **reports** a deep comparison of values if the assertion fails. If differences between properties do not help you to understand why a test fails, especially if the report is large, then you might move the comparison into the `expect` function. For example, to assert whether or not elements are the same instance:

- rewrite `expect(received).toBe(expected)` as `expect(received == expected).toBe(true)`
- rewrite `expect(received).never.toBe(expected)` as `expect(received == expected).toBe(false)`

### `.toHaveBeenCalled()`

Also under the alias: `.toBeCalled()`

Use `.toHaveBeenCalled` to ensure that a mock function got called.

For example, let's say you have a `drinkAllExceptOctopus(drink, flavour)` function that takes a `drink` function and applies it to all available beverages. You might want to check that `drink` gets called for `'lemon'`, but not for `'octopus'`, because `'octopus'` flavour is really weird and why would anything be octopus-flavoured? You can do that with this test suite:

```lua
local function drinkAllExceptOctopus(callback, flavour)
	if flavour ~= 'octopus' then
		callback(flavour)
	end
end

describe('drinkAllExceptOctopus', function()
	it('drinks something lemon-flavoured', function()
		local drink = jest.fn()
		drinkAllExceptOctopus(drink, 'lemon')
		expect(drink).toHaveBeenCalled()
	end)

	it('does not drink something octopus-flavoured', function()
		local drink = jest.fn()
		drinkAllExceptOctopus(drink, 'octopus')
		expect(drink).never.toHaveBeenCalled()
	end)
end)
```

### `.toHaveBeenCalledTimes(number)`

Also under the alias: `.toBeCalledTimes(number)`

Use `.toHaveBeenCalledTimes` to ensure that a mock function got called exact number of times.

For example, let's say you have a `drinkEach(drink, table)` function that takes a `drink` function and applies it to array of passed beverages. You might want to check that drink function was called exact number of times. You can do that with this test suite:

```lua
it('drinkEach drinks each drink', function()
	local drink = jest.fn()
	drinkEach(drink, {'lemon', 'octopus'})
	expect(drink).toHaveBeenCalledTimes(2)
end)
```

### `.toHaveBeenCalledWith(arg1, arg2, ...)`

Also under the alias: `.toBeCalledWith()`

Use `.toHaveBeenCalledWith` to ensure that a mock function was called with specific arguments.

For example, let's say that you can register a beverage with a `register` function, and `applyToAll(f)` should apply the function `f` to all registered beverages. To make sure this works, you could write:

```lua
it('registration applies correctly to orange La Croix', function()
	local beverage = LaCroix.new('orange')
	register(beverage)
	local f = jest.fn()
	applyToAll(f)
	expect(f).toHaveBeenCalledWith(beverage)
end)
```

### `.toHaveBeenLastCalledWith(arg1, arg2, ...)`

Also under the alias: `.lastCalledWith(arg1, arg2, ...)`

If you have a mock function, you can use `.toHaveBeenLastCalledWith` to test what arguments it was most recently called with. For example, let's say you have a `applyToAllFlavors(f)` function that applies `f` to a bunch of flavors, and you want to ensure that when you call it, the last flavor it operates on is `'mango'`. You can write:

```lua
it('applying to all flavors does mango last', function()
	local drink = jest.fn()
	applyToAllFlavors(drink)
	expect(drink).toHaveBeenLastCalledWith('mango')
end)
```

### `.toHaveBeenNthCalledWith(nthCall, arg1, arg2, ....)`

Also under the alias: `.nthCalledWith(nthCall, arg1, arg2, ...)`

If you have a mock function, you can use `.toHaveBeenNthCalledWith` to test what arguments it was nth called with. For example, let's say you have a `drinkEach(drink, Array<flavor>)` function that applies `f` to a bunch of flavors, and you want to ensure that when you call it, the first flavor it operates on is `'lemon'` and the second one is `'octopus'`. You can write:

```lua
it('drinkEach drinks each drink', function()
	local drink = jest.fn()
	drinkEach(drink, {'lemon', 'octopus'})
	expect(drink).toHaveBeenNthCalledWith(1, 'lemon')
	expect(drink).toHaveBeenNthCalledWith(2, 'octopus')
end)
```

Note: the nth argument must be positive integer starting from 1.

### `.toHaveReturned()`

Also under the alias: `.toReturn()`

If you have a mock function, you can use `.toHaveReturned` to test that the mock function successfully returned (i.e., did not throw an error) at least one time. For example, let's say you have a mock `drink` that returns `true`. You can write:

```lua
it('drinks returns', function()
	local drink = jest.fn(function() return true end)

	drink()

	expect(drink).toHaveReturned()
end
```

### `.toHaveReturnedTimes(number)`

Also under the alias: `.toReturnTimes(number)`

Use `.toHaveReturnedTimes` to ensure that a mock function returned successfully (i.e., did not throw an error) an exact number of times. Any calls to the mock function that throw an error are not counted toward the number of times the function returned.

For example, let's say you have a mock `drink` that returns `true`. You can write:

```lua
it('drink returns twice', function()
	local drink = jest.fn(function() return true end)

	drink()
	drink()

	expect(drink).toHaveReturnedTimes(2)
end
```

### `.toHaveReturnedWith(value)`

Also under the alias: `.toReturnWith(value)`

Use `.toHaveReturnedWith` to ensure that a mock function returned a specific value.

For example, let's say you have a mock `drink` that returns the name of the beverage that was consumed. You can write:

```lua
it('drink returns La Croix', function()
	local beverage = {name = 'La Croix'}
	local drink = jest.fn(function(beverage) return beverage.name end)

	drink(beverage)

	expect(drink).toHaveReturnedWith('La Croix')
end)
```

### `.toHaveLastReturnedWith(value)`

Also under the alias: `.lastReturnedWith(value)`

Use `.toHaveLastReturnedWith` to test the specific value that a mock function last returned. If the last call to the mock function threw an error, then this matcher will fail no matter what value you provided as the expected return value.

For example, let's say you have a mock `drink` that returns the name of the beverage that was consumed. You can write:

```lua
it('drink returns La Croix (Orange) last', function()
	local beverage1 = {name = 'La Croix (Lemon)'}
	local beverage2 = {name = 'La Croix (Orange)'}
	local drink = jest.fn(function(beverage) return beverage.name end)

	drink(beverage1)
	drink(beverage2)

	expect(drink).toHaveLastReturnedWith('La Croix (Orange)')
end)
```

### `.toHaveNthReturnedWith(nthCall, value)`

Also under the alias: `.nthReturnedWith(nthCall, value)`

Use `.toHaveNthReturnedWith` to test the specific value that a mock function returned for the nth call. If the nth call to the mock function threw an error, then this matcher will fail no matter what value you provided as the expected return value.

For example, let's say you have a mock `drink` that returns the name of the beverage that was consumed. You can write:

```lua
it('drink returns expected nth calls', () => {
	local beverage1 = {name = 'La Croix (Lemon)'}
	local beverage2 = {name = 'La Croix (Orange)'}
	local drink = jest.fn(function(beverage) return beverage.name end)

	drink(beverage1)
	drink(beverage2)

	expect(drink).toHaveNthReturnedWith(1, 'La Croix (Lemon)')
	expect(drink).toHaveNthReturnedWith(2, 'La Croix (Orange)')
end
```

Note: the nth argument must be positive integer starting from 1.

### `.toHaveLength(number)`

Use `.toHaveLength` to check that an (array-like) table or string has a certain length. It calls the `#` operator and since `#` is only well defined for non-sparse array-like tables and strings it will return 0 for tables with key-value pairs. It checks the `.length` property of the table instead if it has one.

This is especially useful for checking arrays or strings size.

```lua
expect({1, 2, 3}).toHaveLength(3)
expect('abc').toHaveLength(3)
expect('').never.toHaveLength(5)
```

### `.toHaveProperty(keyPath, value?)`

Use `.toHaveProperty` to check if property at provided reference `keyPath` exists for an object. For checking deeply nested properties in an object you may use dot notation or an array containing the `keyPath` for deep references.

You can provide an optional `value` argument to compare the received property value (recursively for all properties of tables, also known as deep equality, like the `toEqual` matcher).

The following example contains a `houseForSale` object with nested properties. We are using `toHaveProperty` to check for the existence and values of various properties in the object.

```lua
-- Object containing house features to be tested
local houseForSale = {
	bath = true,
	bedrooms = 4,
	kitchen = {
		amenities = {'oven', 'stove', 'washer'},
		area = 20,
		wallColor = 'white',
		'nice.oven' = true,
	},
	'ceiling.height' = 2,
}

it('this house has my desired features', function()
	-- Example Referencing
	expect(houseForSale).toHaveProperty('bath')
	expect(houseForSale).toHaveProperty('bedrooms', 4)

	expect(houseForSale).never.toHaveProperty('pool')

	-- Deep referencing using dot notation
	expect(houseForSale).toHaveProperty('kitchen.area', 20)
	expect(houseForSale).toHaveProperty('kitchen.amenities', {
		'oven',
		'stove',
		'washer',
	})

	expect(houseForSale).never.toHaveProperty('kitchen.open')

	-- Deep referencing using an array containing the keyPath
	expect(houseForSale).toHaveProperty({'kitchen', 'area'}, 20)
	expect(houseForSale).toHaveProperty(
		{'kitchen', 'amenities'},
		{'oven', 'stove', 'washer'},
	)
	expect(houseForSale).toHaveProperty({'kitchen', 'amenities', 1}, 'oven')
	expect(houseForSale).toHaveProperty({'kitchen', 'nice.oven'})
	expect(houseForSale).never.toHaveProperty({'kitchen', 'open'})

	-- Referencing keys with dot in the key itself
	expect(houseForSale).toHaveProperty({'ceiling.height'}, 'tall')
end)
```

### `.toBeCloseTo(number, numDigits?)`

Use `toBeCloseTo` to compare floating point numbers for approximate equality.

The optional `numDigits` argument limits the number of digits to check **after** the decimal point. For the default value `2`, the test criterion is `math.abs(expected - received) < 0.005` (that is, `10 ** -2 / 2`).

Intuitive equality comparisons often fail, because arithmetic on decimal (base 10) values often have rounding errors in limited precision binary (base 2) representation. For example, this test fails:

```lua
it('adding works sanely with decimals', function()
	expect(0.2 + 0.1).toBe(0.3) -- Fails!
end)
```

It fails because in Lua, `0.2 + 0.1` is actually `0.30000000000000004`.

For example, this test passes with a precision of 5 digits:

```lua
it('adding works sanely with decimals', function()
	expect(0.2 + 0.1).toBeCloseTo(0.3, 5)
end)
```

### `.toBeDefined()`

Use `.toBeDefined` to check that a variable is not `nil`. For example, if you want to check that a function `fetchNewFlavorIdea()` returns _something_, you can write:

```lua
it('there is a new flavor idea', function()
	expect(fetchNewFlavorIdea()).toBeDefined()
end)
```

:::note
`.toBeDefined` is functionally identical to `.never.toBeNil()` and usage of the latter is preferred.
:::

### `.toBeFalsy()`

Use `.toBeFalsy` when you don't care what a value is and you want to ensure a value is false in a boolean context. For example, let's say you have some application code that looks like:

```lua
drinkSomeLaCroix()
if not getErrors() then
	drinkMoreLaCroix()
end
```

You may not care what `getErrors` returns, specifically - it might return `false` or `nil`, and your code would still work. So if you want to test there are no errors after drinking some La Croix, you could write:

```lua
it('drinking La Croix does not lead to errors', function()
	drinkSomeLaCroix()
	expect(getErrors()).toBeFalsy()
end)
```

In Lua, there are two falsy values: `false` and `nil`. Everything else is truthy.

### `.toBeGreaterThan(number)`

Use `toBeGreaterThan` to compare `received > expected` for number values. For example, test that `ouncesPerCan()` returns a value of more than 10 ounces:

```lua
it('ounces per can is more than 10', function()
	expect(ouncesPerCan()).toBeGreaterThan(10)
end)
```

### `.toBeGreaterThanOrEqual(number)`

Use `toBeGreaterThanOrEqual` to compare `received >= expected` for number or big integer values. For example, test that `ouncesPerCan()` returns a value of at least 12 ounces:

```lua
it('ounces per can is at least 12', function()
	expect(ouncesPerCan()).toBeGreaterThanOrEqual(12)
end)
```

### `.toBeLessThan(number)`

Use `toBeLessThan` to compare `received < expected` for number or big integer values. For example, test that `ouncesPerCan()` returns a value of less than 20 ounces:

```lua
it('ounces per can is less than 20', function()
	expect(ouncesPerCan()).toBeLessThan(20)
end)
```

### `.toBeLessThanOrEqual(number)`

Use `toBeLessThanOrEqual` to compare `received <= expected` for number or big integer values. For example, test that `ouncesPerCan()` returns a value of at most 12 ounces:

```lua
it('ounces per can is at most 12', function()
	expect(ouncesPerCan()).toBeLessThanOrEqual(12)
end)
```

### `.toBeInstanceOf(prototype)`

Use `.toBeInstanceOf(prototype)` to check that a value is an instance (or a derived instance) of a prototype class. This matcher uses the [`instanceof` method in LuauPolyfill](https://github.com/Roblox/luau-polyfill/blob/main/src/instanceof.lua) underneath.

:::tip
Setting the `__tostring` metamethod will result in nicer error outputs.
:::

```lua
local A = {}
A.__index = A
setmetatable(A, {
	__tostring = function(self) return 'A' end
})
function A.new()
	local self = {}
	setmetatable(self, A)
	return self
end

local B = {}
B.__index = B
setmetatable(B, {
	__tostring = function(self) return 'B' end
})
function B.new()
	local self = {}
	setmetatable(self, B)
	return self
end

local C = extends(B, 'C', function(self) end)

expect(A.new()).toBeInstanceOf(A)
expect(B.new()).never.toBeInstanceOf(A)
expect(C.new()).toBeInstanceOf(B)
```

### `.toBeNil()`

Also under the alias: `.toBeNull()`

`.toBeNil()` is the same as `.toBe(nil)` but the error messages are a bit nicer. So use `.toBeNil()` when you want to check that something is `nil`.

```lua
local function bloop()
	return nil
end

it('bloop returns nil', function()
	expect(bloop()).toBeNil()
end)
```

### `.toBeTruthy()`

Use `.toBeTruthy` when you don't care what a value is and you want to ensure a value is true in a boolean context. For example, let's say you have some application code that looks like:

```lua
drinkSomeLaCroix()
if thirstInfo() then
	drinkMoreLaCroix()
end
```

You may not care what `thirstInfo` returns, specifically - it might return `true` or a complex object, and your code would still work. So if you want to test that `thirstInfo` will be truthy after drinking some La Croix, you could write:

```lua
it('drinking La Croix leads to having thirst info', function()
	drinkSomeLaCroix()
	expect(thirstInfo()).toBeTruthy()
end)
```

In Lua, there are two falsy values: `false` and `nil`. Everything else is truthy.

### `.toBeUndefined()`

Use `.toBeUndefined()` to check that a variable is `nil`.

:::note
`.toBeUndefined` is functionally identical to `.toBeNil()` and usage of the latter is preferred.
:::

### `.toBeNan()`

Also under the alias: `.toBeNaN()`

Use `.toBeNan` when checking a value is `nan`.

```lua
it('passes when value is nan', function()
	expect(0/0).toBeNan()
	expect(1).never.toBeNan()
end)
```

### `.toContain(item)`

Use `.toContain` when you want to check that an item is in an array. For testing the items in the array, this uses `table.find`, which does a strict equality check.

`.toContain` can also check whether a string is a substring of another string. This uses `string.find` with `plain = true` so magic characters are ignored.

For example, if `getAllFlavors()` returns an array of flavors and you want to be sure that `lime` is in there, you can write:

```lua
it('the flavor list contains lime', function()
	expect(getAllFlavors()).toContain('lime')
end)
```

### `.toContainEqual(item)`

Use `.toContainEqual` when you want to check that an item with a specific structure and values is contained in an array. For testing the items in the array, this matcher recursively checks the equality of all fields, rather than checking for table identity.

```lua
describe('my beverage', function()
	it('is delicious and not sour', function()
		local myBeverage = {delicious = true, sour = false}
		expect(myBeverages()).toContainEqual(myBeverage)
	end)
end)
```

### `.toEqual(value)`

Use `.toEqual` to compare recursively all properties of tables (also known as "deep" equality). It calls [Luau Polyfill's `Object.is`](https://github.com/Roblox/luau-polyfill/blob/main/src/Object/is.lua) to compare primitive values, which mostly behaves like the `==` operator.

For example, `.toEqual` and `.toBe` behave differently in this test suite, so all the tests pass:

```lua
local can1 = {
	flavor = 'grapefruit',
	ounces = 12,
}
local can2 = {
	flavor = 'grapefruit',
	ounces = 12,
}

describe('the La Croix cans on my desk', function()
	it('have all the same properties', function()
		expect(can1).toEqual(can2)
	end)
	it('are not the exact same can', function()
		expect(can1).never.toBe(can2)
	end)
end)
```

> Note: `.toEqual` won't perform a _deep equality_ check for two errors. Only the `message` property of an Error is considered for equality. It is recommended to use the `.toThrow` matcher for testing against errors.

If differences between properties do not help you to understand why a test fails, especially if the report is large, then you might move the comparison into the `expect` function. For example, use `equals` method of `Buffer` class to assert whether or not buffers contain the same content:

- rewrite `expect(received).toEqual(expected)` as `expect(received.equals(expected)).toBe(true)`
- rewrite `expect(received).never.toEqual(expected)` as `expect(received.equals(expected)).toBe(false)`

### `.toMatch(string | regexp)`

Use `.toMatch` to check that a string matches a [Lua string pattern](https://developer.roblox.com/en-us/articles/string-patterns-reference).

For example, you might not know what exactly `essayOnTheBestFlavor()` returns, but you know it's a really long string, and the substring `grapefruit` should be in there somewhere. You can test this with:

```lua
describe('an essay on the best flavor', function()
	it('mentions grapefruit', function()
		expect(essayOnTheBestFlavor()).toMatch('grapefruit')
	end)
end)
```

This matcher also accepts a [regular expression](#regexp).

```lua
describe('an essay on the best flavor', function()
	it('mentions grapefruit or orange', function()
		expect(essayOnTheBestFlavor()).toMatch(RegExp('grapefruit|orange'))
	end)
end)
```

### `.toMatchObject(table)`

Use `.toMatchObject` to check that a table matches a subset of the properties of an expected table. It will match received tables with properties that are **not** in the expected table.

You can also pass an array of tables, in which case the method will return true only if each table in the received array matches (in the `toMatchObject` sense described above) the corresponding object in the expected array. This is useful if you want to check that two arrays match in their number of elements, as opposed to `arrayContaining`, which allows for extra elements in the received array.

You can match properties against values or against matchers.

```lua
local houseForSale = {
	bath = true,
	bedrooms = 4,
	kitchen = {
		amenities = {'oven', 'stove', 'washer'},
		area = 20,
		wallColor = 'white',
	},
}
local desiredHouse = {
	bath = true,
	kitchen = {
		amenities = {'oven', 'stove', 'washer'},
		wallColor = expect.stringMatching(RegExp('white|yellow')),
	},
}

it('the house has my desired features', function()
	expect(houseForSale).toMatchObject(desiredHouse)
end)
```

```lua
describe('toMatchObject applied to arrays', function()
	it('the number of elements must match exactly', function()
		expect({{foo: 'bar'}, {baz: 1}}).toMatchObject({{foo: 'bar'}, {baz: 1}})
	})

	it('.toMatchObject is called for each elements, so extra object properties are okay', function()
		expect({{foo: 'bar'}, {baz: 1, extra: 'quux'}}).toMatchObject({
			{foo: 'bar'},
			{baz: 1},
		})
	end)
end)
```

### `.toMatchSnapshot(propertyMatchers?, hint?)`

This ensures that a value matches the most recent snapshot. Check out [the Snapshot Testing guide](snapshot-testing) for more information.

You can provide an optional `propertyMatchers` table argument, which has asymmetric matchers as values of a subset of expected properties, **if** the received value will be a **table**. It is like `toMatchObject` with flexible criteria for a subset of properties, followed by a snapshot test as exact criteria for the rest of the properties.

You can provide an optional `hint` string argument that is appended to the test name. Although Jest always appends a number at the end of a snapshot name, short descriptive hints might be more useful than numbers to differentiate **multiple** snapshots in a **single** `it` or `test` block. Jest sorts snapshots by name in the corresponding `.snap` file.

### `.toStrictEqual(value)`

Use `.toStrictEqual` to test that objects have the same types.

Difference from `.toEqual`:
- Lua tables that follow metatable inheritance patterns will also be checked for type equality

```lua
local LaCroix = {}
LaCroix.__index = LaCroix
function LaCroix.new(flavor)
	return setmetatable({
		flavor = flavor
	}, LaCroix)
end

describe('the La Croix cans on my desk', function()
	it('the La Croix cans on my desk are not semantically the same', function()
		jestExpect(LaCroix.new('lemon')).toEqual({flavor = 'lemon'})
		jestExpect(LaCroix.new('lemon')).never.toStrictEqual({flavor = 'lemon'})
	end)
end)
```

### `.toThrow(error?)`

Also under the alias: `.toThrowError(error?)`

Use `.toThrow` to test that a function throws when it is called. For example, if we want to test that `drinkFlavor('octopus')` throws, because octopus flavor is too disgusting to drink, we could write:

```lua
it('throws on octopus', function()
	expect(function()
		drinkFlavor('octopus')
	end).toThrow()
end)
```

> Note: You must wrap the code in a function, otherwise the error will not be caught and the assertion will fail.

You can provide an optional argument to test that a specific error is thrown:

- [regular expression](#regexp): error message **matches** the pattern
- string: error message **includes** the substring

`.toThrow` can also handle custom Error objects provided by LuauPolyfill:

- [error object](#error): error message is **equal to** the message property of the object
- [error class](#error): error object is **instance of** class

For example, let's say that `drinkFlavor` is coded like this:

```lua
local Error = LuauPolyfill.Error
local extends = LuauPolyfill.extends

local DisgustingFlavorError = extends(Error, 'DisgustingFlavorError', function(self, message)
	self.message = message
	self.name = 'DisgustingFlavorError'
end)

local function drinkFlavor(flavor)
	if flavor == 'octopus' then
		error(DisgustingFlavorError('yuck, octopus flavor'))
	end
	-- Do some other stuff
end
```

We could test this error gets thrown in several ways:

```lua
it('throws on octopus', function()
	local function drinkOctopus()
		drinkFlavor('octopus')
	end

	-- Test that the error message says "yuck" somewhere: these are equivalent
	expect(drinkOctopus).toThrowError(RegExp('yuck'))
	expect(drinkOctopus).toThrowError('yuck')

	-- Test the exact error message
	expect(drinkOctopus).toThrowError(RegExp('^yuck, octopus flavor$'))
	expect(drinkOctopus).toThrowError(Error('yuck, octopus flavor'))

	-- Test that we get a DisgustingFlavorError
	expect(drinkOctopus).toThrowError(DisgustingFlavorError)
end)
```

### `.toThrowErrorMatchingSnapshot(hint?)`

Use `.toThrowErrorMatchingSnapshot` to test that a function throws an error matching the most recent snapshot when it is called.

You can provide an optional `hint` string argument that is appended to the test name. Although Jest always appends a number at the end of a snapshot name, short descriptive hints might be more useful than numbers to differentiate **multiple** snapshots in a **single** `it` or `test` block. Jest sorts snapshots by name in the corresponding `.snap` file.

:::tip
You can throw and match against a native Lua string error, but it is recommended to pass in an [error object](expect#error) for cleaner snapshots.
:::

For example, let's say you have a `drinkFlavor` function that throws whenever the flavor is `'octopus'`, and is coded like this:

```lua
local function drinkFlavor(flavor)
	if flavor == 'octopus' then
		error(Error('yuck, octopus flavor'))
	end
	-- Do some other stuff
end
```

The test for this function will look this way:

```lua
it('throws on octopus', function()
	local function drinkOctopus()
		drinkFlavor('octopus')
	end

	expect(drinkOctopus).toThrowErrorMatchingSnapshot()
end)
```

And it will generate the following snapshot:

```lua
exports["drinking flavors throws on octopus 1"] = [=[
yuck, octopus flavor]=]
```
