---
id: api
title: Globals
---
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api)

![Deviation](/img/deviation.svg)

At the top of your test files, require `JestGlobals` from the `Packages` directory created by `rotriever`.

Then, explicitly import any of the following members:

```lua
local JestGlobals = require(Packages.Dev.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local test = JestGlobals.test
```

## Methods

import TOCInline from "@theme/TOCInline";

<TOCInline toc={
	toc.filter((node) => node.level === 3)
}/>

---

## Reference

### `afterAll(fn, timeout)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#afterallfn-timeout)  ![Aligned](/img/aligned.svg)

Runs a function after all the tests in this file have completed. If the function returns a promise or is a generator, Jest Roblox waits for that promise to resolve before continuing.

Optionally, you can provide a `timeout` (in milliseconds) for specifying how long to wait before aborting. _Note: The default timeout is 5 seconds._

This is often useful if you want to clean up some global setup state that is shared across tests.

For example:

```lua
local globalDatabase = makeGlobalDatabase()

local function cleanUpDatabase(db)
	db:cleanUp()
end

afterAll(function()
	cleanUpDatabase(globalDatabase)
end)

test('can find things', function()
	return globalDatabase:find('thing', {}, function(results)
		expect(#results).toBeGreaterThan(0)
	end)
end)

test('can insert a thing', function()
	return globalDatabase:insert('thing', makeThing(), function(response)
		expect(response.success).toBeTruthy()
	end)
end)
```

Here the `afterAll` ensures that `cleanUpDatabase` is called after all tests run.

If `afterAll` is inside a `describe` block, it runs at the end of the describe block.

If you want to run some cleanup after every test instead of after all tests, use `afterEach` instead.

### `afterEach(fn, timeout)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#aftereachfn-timeout)  ![Aligned](/img/aligned.svg)

Runs a function after each one of the tests in this file completes. If the function returns a promise or is a generator, Jest Roblox waits for that promise to resolve before continuing.

Optionally, you can provide a `timeout` (in milliseconds) for specifying how long to wait before aborting. _Note: The default timeout is 5 seconds._

This is often useful if you want to clean up some temporary state that is created by each test.

For example:

```lua
local globalDatabase = makeGlobalDatabase()

local function cleanUpDatabase(db)
	db:cleanUp()
end

afterEach(function()
	cleanUpDatabase(globalDatabase)
end)

test('can find things', function()
	return globalDatabase:find('thing', {}, function(results)
		expect(#results).toBeGreaterThan(0)
	end)
end)

test('can insert a thing', function()
	return globalDatabase:insert('thing', makeThing(), function(response)
		expect(response.success).toBeTruthy()
	end)
end)
```

Here the `afterEach` ensures that `cleanUpDatabase` is called after each test runs.

If `afterEach` is inside a `describe` block, it only runs after the tests that are inside this describe block.

If you want to run some cleanup just once, after all of the tests run, use `afterAll` instead.

### `beforeAll(fn, timeout)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#beforeallfn-timeout)  ![Aligned](/img/aligned.svg)

Runs a function before any of the tests in this file run. If the function returns a promise or is a generator, Jest Roblox waits for that promise to resolve before running tests.

Optionally, you can provide a `timeout` (in milliseconds) for specifying how long to wait before aborting. _Note: The default timeout is 5 seconds._

This is often useful if you want to set up some global state that will be used by many tests.

For example:

```lua
local globalDatabase = makeGlobalDatabase()

beforeAll(function()
	-- Clears the database and adds some testing data.
	-- Jest Roblox will wait for this promise to resolve before running tests.
	return globalDatabase:clear()
		:then(function()
			return globalDatabase:insert({testData = 'foo'})
		end)
end)

-- Since we only set up the database once in this example, it's important
-- that our tests don't modify it.
test('can find things', function()
	return globalDatabase:find('thing', {}, function(results)
		expect(#results).toBeGreaterThan(0)
	end)
end)
```

Here the `beforeAll` ensures that the database is set up before tests run. If setup was synchronous, you could do this without `beforeAll`. The key is that Jest will wait for a promise to resolve, so you can have asynchronous setup as well.

If `beforeAll` is inside a `describe` block, it runs at the beginning of the describe block.

If you want to run something before every test instead of before any test runs, use `beforeEach` instead.

### `beforeEach(fn, timeout)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#beforeeachfn-timeout)  ![Aligned](/img/aligned.svg)

Runs a function before each of the tests in this file runs. If the function returns a promise or is a generator, Jest Roblox waits for that promise to resolve before running the test.

Optionally, you can provide a `timeout` (in milliseconds) for specifying how long to wait before aborting. _Note: The default timeout is 5 seconds._

This is often useful if you want to reset some global state that will be used by many tests.

For example:

```lua
local globalDatabase = makeGlobalDatabase()

beforeEach(function()
	-- Clears the database and adds some testing data.
	-- Jest Roblox will wait for this promise to resolve before running tests.
	return globalDatabase:clear()
		:then(function()
			return globalDatabase:insert({testData = 'foo'})
		end)
end)

test('can find things', function()
	return globalDatabase:find('thing', {}, function(results)
		expect(#results).toBeGreaterThan(0)
	end)
end)

test('can insert a thing', function()
	return globalDatabase:insert('thing', makeThing(), function(response)
		expect(response.success).toBeTruthy()
	end)
end)
```

Here the `beforeEach` ensures that the database is reset for each test.

If `beforeEach` is inside a `describe` block, it runs for each test in the describe block.

If you only need to run some setup code once, before any tests run, use `beforeAll` instead.

### `describe(name, fn)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#describename-fn)  ![Aligned](/img/aligned.svg)

`describe(name, fn)` creates a block that groups together several related tests. For example, if you have a `myBeverage` object that is supposed to be delicious but not sour, you could test it with:

```lua
local myBeverage = {
	delicious = true,
	sour = false
}

describe('my beverage', function()
	test('is delicious', function()
		expect(myBeverage.delicious).toBeTruthy()
	end)

	test('is not sour', function()
		expect(myBeverage.sour).toBeFalsy()
	end)
end)
```

This isn't required - you can write the `test` blocks directly at the top level. But this can be handy if you prefer your tests to be organized into groups.

You can also nest `describe` blocks if you have a hierarchy of tests:
```lua
describe('binaryStringToNumber', function()
	describe('given an invalid binary string', function()
		test('composed of non-numbers throws', function()
			expect(function()
				binaryStringToNumber('abc')
			end).toThrow()
		end)

		test('with extra whitespace throws', function()
			expect(function()
				binaryStringToNumber('  100')
			end).toThrow()
		end)
	end)

	describe('given a valid binary string', function()
		test('returns the correct number', function()
			expect(binaryStringToNumber('100')).toBe(4)
		end
	end)
end)
```

### `describe.each(table)(name, fn, timeout)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#describeeachtablename-fn-timeout)  ![API Change](/img/apichange.svg)

Use `describe.each` if you keep duplicating the same test suites with different data. `describe.each` allows you to write the test suite once and pass data in.

`describe.each` is available with two APIs:

#### 1. `describe.each(table)(name, fn, timeout)`

- `table`: `array` of arrays with the arguments that are passed into the `fn` for each row.
  - _Note_ If you pass in a 1D array of primitives, internally it will be mapped to a table i.e. `{1, 2, 3} -> {{1}, {2}, {3}}`
- `name`: `string` the title of the test suite.
- `fn`: `function` the suite of tests to be ran, this is the function that will receive the parameters in each row as function arguments.
- Optionally, you can provide a `timeout` (in milliseconds) for specifying how long to wait for each row before aborting. _Note: The default timeout is 5 seconds._

Example:

```lua
describe.each({
	{1, 1, 2},
	{1, 2, 3},
	{2, 1, 3},
})('.add($a, $b)', function(a, b, expected)
	test('returns $expected', function()
		expect(a + b).toBe(expected)
	end)

	test('returned value not be greater than $expected', function()
		expect(a + b).never.toBeGreaterThan(expected)
	end)

	test('returned value not be less than $expected', function()
		expect(a + b).never.toBeLessThan(expected)
	end)
end)
```

```lua
describe.each({
	{a = 1, b = 1, expected = 2},
	{a = 1, b = 2, expected = 3},
	{a = 2, b = 1, expected = 3},
})('.add($a, $b)', function(ref)
	local a, b, expected = ref.a, ref.b, ref.expected

	test('returns $expected', function()
		expect(a + b).toBe(expected)
	end)

	test('returned value not be greater than $expected', function()
		expect(a + b).never.toBeGreaterThan(expected)
	end)

	test('returned value not be less than $expected', function()
		expect(a + b).never.toBeLessThan(expected)
	end)
end)
```

#### 2. `describe.each(...args)(name, fn, timeout)`
![API Change](/img/apichange.svg)

- `...args`
  - First argument is a string with headings separated by `|`, or a table with a single element containing that.
  - One or more arguments of arrays with the arguments that are passed into the `fn`.
- `name`: `String` the title of the test suite
- `fn`: `Function` the suite of tests to be ran, this is the function that will receive the test data object.
- Optionally, you can provide a `timeout` (in milliseconds) for specifying how long to wait for each row before aborting. _Note: The default timeout is 5 seconds._

Example:

```lua
describe.each('a | b | expected',
	{1, 1, 2},
	{1, 2, 3},
	{2, 1, 3}
)('.add($a, $b)', function(ref)
	local a, b, expected = ref.a, ref.b, ref.expected

	test('returns $expected', function()
		expect(a + b).toBe(expected)
	end)

	test('returned value not be greater than $expected', function()
		expect(a + b).never.toBeGreaterThan(expected)
	end)

	test('returned value not be less than $expected', function()
		expect(a + b).never.toBeLessThan(expected)
	end)
end)
```

### `describe.only(name, fn)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#describeonlyname-fn)  ![Aligned](/img/aligned.svg)

Also under the alias: `fdescribe(name, fn)`

You can use `describe.only` if you want to run only one describe block:

```lua
describe.only('my beverage', function()
	test('is delicious', function()
		expect(myBeverage.delicious).toBeTruthy()
	end)

	test('is not sour', function()
		expect(myBeverage.sour).toBeFalsy()
	end)
end)

describe('my other beverage', function()
	-- ... will be skipped
end)
```

### `describe.only.each(table)(name, fn)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#describeonlyeachtablename-fn)  ![API Change](/img/apichange.svg)

Also under the aliases: `fdescribe.each(table)(name, fn)` and `` fdescribe.each`table`(name, fn) ``

Use `describe.only.each` if you want to only run specific tests suites of data driven tests.

`describe.only.each` is available with two APIs:

#### `describe.only.each(table)(name, fn)`

```lua
describe.only.each({
	{1, 1, 2},
	{1, 2, 3},
	{2, 1, 3},
})('.add($a, $b)', function(a, b, expected)
	test('will be ran', function()
		expect(a + b).toBe(expected)
	end)
end)

test('will not be ran', function()
	expect(1 / 0).toBe(math.huge)
end)
```

#### `describe.only.each(...args)(name, fn)`
![API Change](/img/apichange.svg)

```lua
describe.only.each({'a | b | expected'},
	{1, 1, 2},
	{1, 2, 3},
	{2, 1, 3}
)('returns $expected when $a is added $b', function(ref)
	local a, b, expected = ref.a, ref.b, ref.expected

	test('will be ran', function()
		expect(a + b).toBe(expected)
	end)
end)

test('will not be ran', function()
	expect(1 / 0).toBe(math.huge)
end)
```

### `describe.skip(name, fn)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#describeskipname-fn)  ![Aligned](/img/aligned.svg)

Also under the alias: `xdescribe(name, fn)`

You can use `describe.skip` if you do not want to run the tests of a particular `describe` block:

```lua
describe('my beverage', function()
	test('is delicious', function()
		expect(myBeverage.delicious).toBeTruthy()
	end)

	test('is not sour', function()
		expect(myBeverage.sour).toBeFalsy()
	end)
end)

describe.skip('my other beverage', function()
	-- ... will be skipped
end)
```

Using `describe.skip` is often a cleaner alternative to temporarily commenting out a chunk of tests. Beware that the `describe` block will still run. If you have some setup that also should be skipped, do it in a `beforeAll` or `beforeEach` block.

### `describe.skip.each(table)(name, fn)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#describeskipeachtablename-fn)  ![API Change](/img/apichange.svg)

Also under the aliases: `xdescribe.each(table)(name, fn)` and `xdescribe.each(...args)(name, fn)`

Use `describe.skip.each` if you want to stop running a suite of data driven tests.

`describe.skip.each` is available with two APIs:

#### `describe.skip.each(table)(name, fn)`

```lua
describe.skip.each({
	{1, 1, 2},
	{1, 2, 3},
	{2, 1, 3},
})('.add($a, $b)', function(a, b, expected)
	test('will not be ran', function()
		expect(a + b).toBe(expected)
	end)
end)

test('will be ran', function()
	expect(1 / 0).toBe(math.huge)
end)
```

#### `describe.skip.each(...args)(name, fn)`
![API Change](/img/apichange.svg)

```lua
describe.skip.each({'a | b | expected'},
	{1, 1, 2},
	{1, 2, 3},
	{2, 1, 3}
)('returns $expected when $a is added $b', function(ref)
	local a, b, expected = ref.a, ref.b, ref.expected

	test('will not be ran', function()
		expect(a + b).toBe(expected)
	end)
end)

test('will be ran', function()
	expect(1 / 0).toBe(math.huge)
end)
```

### `test(name, fn, timeout)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#testname-fn-timeout)  ![API Change](/img/apichange.svg)

Also under the alias: `it(name, fn, timeout)`

All you need in a test file is the `test` method which runs a test. For example, let's say there's a function `inchesOfRain()` that should be zero. Your whole test could be:

```lua
test('did not rain', function()
	expect(inchesOfRain()).toBe(0)
end)
```

The first argument is the test name; the second argument is a function that contains the expectations to test. The third argument (optional) is `timeout` (in milliseconds) for specifying how long to wait before aborting. _Note: The default timeout is 5 seconds._

:::note
If a **promise is returned** from `test`, Jest Roblox will wait for the promise to resolve before letting the test complete.
![API Change](/img/apichange.svg)

Jest Roblox will also wait if you **provide a second argument to the test function**, usually called `done`. This could be handy when you want to test callbacks. See how to test async code [here](asynchronous#callbacks).
:::

For example, let's say `fetchBeverageList()` returns a promise that is supposed to resolve to a list that has `lemon` in it. You can test this with:

```lua
test('has lemon in it', function()
	return fetchBeverageList():then(function(list)
		expect(list).toContain('lemon')
	end)
end)
```

Even though the call to `test` will return right away, the test doesn't complete until the promise resolves as well.

### `test.each(table)(name, fn, timeout)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#testeachtablename-fn-timeout)  ![API Change](/img/apichange.svg)

Also under the alias: `it.each(table)(name, fn)` and `it.each(...args)(name, fn)`

Use `test.each` if you keep duplicating the same test with different data. `test.each` allows you to write the test once and pass data in.

`test.each` is available with two APIs:

#### 1. `test.each(table)(name, fn, timeout)`

- `table`: `array` of arrays with the arguments that are passed into the `fn` for each row.
  - _Note_ If you pass in a 1D array of primitives, internally it will be mapped to a table i.e. `{1, 2, 3} -> {{1}, {2}, {3}}`
- `name`: `string` the title of the test suite.
- `fn`: `function` the suite of tests to be ran, this is the function that will receive the parameters in each row as function arguments.
- Optionally, you can provide a `timeout` (in milliseconds) for specifying how long to wait for each row before aborting. _Note: The default timeout is 5 seconds._

Example:
```lua
test.each({
	{1, 1, 2},
	{1, 2, 3},
	{2, 1, 3},
})('.add($a, $b)', function(a, b, expected)
	expect(a + b).toBe(expected)
end)
```

```lua
test.each({
	{a = 1, b = 1, expected = 2},
	{a = 1, b = 2, expected = 3},
	{a = 2, b = 1, expected = 3},
})('.add($a, $b)', function(ref)
	local a, b, expected = ref.a, ref.b, ref.expected
	expect(a + b).toBe(expected)
end)
```

#### 2. `test.each(...args)(name, fn, timeout)`
![API Change](/img/apichange.svg)

- `...args`
  - First argument is a string with headings separated by `|`, or a table with a single element containing that.
  - One or more arguments of arrays with the arguments that are passed into the `fn`.
- `name`: `String` the title of the test suite
- `fn`: `Function` the suite of tests to be ran, this is the function that will receive the test data object.
- Optionally, you can provide a `timeout` (in milliseconds) for specifying how long to wait for each row before aborting. _Note: The default timeout is 5 seconds._

Example:

```lua
test.each('a | b | expected',
	{1, 1, 2},
	{1, 2, 3},
	{2, 1, 3}
)('returns $expected when $a is added $b', function(ref)
	local a, b, expected = ref.a, ref.b, ref.expected
	expect(a + b).toBe(expected)
end)
```

### `test.failing(name, fn, timeout)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/next/api#testfailingname-fn-timeout)  ![Aligned](/img/aligned.svg)

Also under the alias: `it.failing(name, fn, timeout)`

:::

Use `test.failing` when you are writing a test and expecting it to fail. These tests will behave the other way normal tests do. If `failing` test will throw any errors then it will pass. If it does not throw it will fail.

:::tip

You can use this type of tests i.e. when writing code in a BDD way. In that case the tests will not show up as failing until they pass. Then you can just remove the `failing` modifier to make them pass.

It can also be a nice way to contribute failing tests to a project, even if you don't know how to fix the bug.

:::

Example:

```lua
test.failing('it is not equal', function()
  expect(5).toBe(6) -- this test will pass
end)

test.failing('it is equal', function()
  expect(10).toBe(10) -- this test will fail
end)
```

### `test.only.failing(name, fn, timeout)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/next/api#testonlyfailingname-fn-timeout)  ![Aligned](/img/aligned.svg)

Also under the aliases: `it.only.failing(name, fn, timeout)`

:::

Use `test.only.failing` if you want to only run a specific failing test.

### `test.skip.failing(name, fn, timeout)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/next/api#testskipfailingname-fn-timeout)  ![Aligned](/img/aligned.svg)

Also under the aliases: `it.skip.failing(name, fn, timeout)`

:::

Use `test.skip.failing` if you want to skip running a specific failing test.

### `test.only(name, fn, timeout)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#testonlyname-fn-timeout)  ![Aligned](/img/aligned.svg)

Also under the aliases: `it.only(name, fn, timeout)`, and `fit(name, fn, timeout)`

When you are debugging a large test file, you will often only want to run a subset of tests. You can use `.only` to specify which tests are the only ones you want to run in that test file.

Optionally, you can provide a `timeout` (in milliseconds) for specifying how long to wait before aborting. _Note: The default timeout is 5 seconds._

For example, let's say you had these tests:

```lua
test.only('it is raining', function()
	expect(inchesOfRain()).toBeGreaterThan(0)
end)

test('it is not snowing', function()
  expect(inchesOfSnow()).toBe(0)
end)
```

Only the "it is raining" test will run in that test file, since it is run with `test.only`.

Usually you wouldn't check code using `test.only` into source control - you would use it for debugging, and remove it once you have fixed the broken tests.

### `test.only.each(table)(name, fn)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#testonlyeachtablename-fn-1)  ![API Change](/img/apichange.svg)

Also under the aliases: `it.only.each(table)(name, fn)`, `fit.each(table)(name, fn)`, `` it.only.each`table`(name, fn) `` and `` fit.each`table`(name, fn) ``

Use `test.only.each` if you want to only run specific tests with different test data.

`test.only.each` is available with two APIs:

#### `test.only.each(table)(name, fn)`

```lua
test.only.each({
	{1, 1, 2},
	{1, 2, 3},
	{2, 1, 3},
})('will be ran', function(a, b, expected)
	expect(a + b).toBe(expected)
end)

test('will not be ran', function()
	expect(1 / 0).toBe(math.huge)
end)
```

#### `test.only.each(...args)(name, fn)`
![API Change](/img/apichange.svg)

```lua
test.only.each({'a | b | expected'},
	{1, 1, 2},
	{1, 2, 3},
	{2, 1, 3}
)('will be ran', function(ref)
	local a, b, expected = ref.a, ref.b, ref.expected
	expect(a + b).toBe(expected)
end)

test('will not be ran', function()
	expect(1 / 0).toBe(math.huge)
end)
```

### `test.skip(name, fn)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#testskipname-fn)  ![Aligned](/img/aligned.svg)

Also under the aliases: `it.skip(name, fn)`, `xit(name, fn)`, and `xtest(name, fn)`

When you are maintaining a large codebase, you may sometimes find a test that is temporarily broken for some reason. If you want to skip running this test, but you don't want to delete this code, you can use `test.skip` to specify some tests to skip.

For example, let's say you had these tests:

```lua
test('it is raining', function()
	expect(inchesOfRain()).toBeGreaterThan(0)
end)

test.skip('it is not snowing', function()
	expect(inchesOfSnow()).toBe(0)
end)
```

Only the "it is raining" test will run, since the other test is run with `test.skip`.

You could comment the test out, but it's often a bit nicer to use `test.skip` because it will maintain indentation and syntax highlighting.

### `test.skip.each(table)(name, fn)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#testskipeachtablename-fn)  ![API Change](/img/apichange.svg)

Also under the aliases: `it.skip.each(table)(name, fn)`, `xit.each(table)(name, fn)`, `xtest.each(table)(name, fn)`, `` it.skip.each`table`(name, fn) ``, `xit.each(..args)(name, fn) `` and `xtest.each(...args)(name, fn)`

Use `test.skip.each` if you want to stop running a collection of data driven tests.

`test.skip.each` is available with two APIs:

#### `test.skip.each(table)(name, fn)`

```lua
test.skip.each({
	{1, 1, 2},
	{1, 2, 3},
	{2, 1, 3},
})('will not be ran', function(a, b, expected)
	expect(a + b).toBe(expected)
end)

test('will be ran', function()
	expect(1 / 0).toBe(math.huge)
end)
```

#### `test.skip.each(...args)(name, fn)`
![API Change](/img/apichange.svg)

```lua
test.skip.each({'a | b | expected'},
	{1, 1, 2},
	{1, 2, 3},
	{2, 1, 3}
)('will not be ran', function(ref)
	local a, b, expected = ref.a, ref.b, ref.expected
	expect(a + b).toBe(expected)
end)

test('will be ran', function()
	expect(1 / 0).toBe(math.huge)
end)
```

### `test.todo(name)`
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/api#testtodoname)  ![Aligned](/img/aligned.svg)

Also under the alias: `it.todo(name)`

Use `test.todo` when you are planning on writing tests. These tests will be highlighted in the summary output at the end so you know how many tests you still need todo.

:::tip
If you supply a test callback function then the `test.todo` will throw an error. If you have already implemented the test and it is broken and you do not want it to run, then use `test.skip` instead.
:::

#### API

- `name`: `string` the title of the test plan.

Example:

```lua
local function add(a, b)
	return a + b
end

test.todo('add should be associative')
```
