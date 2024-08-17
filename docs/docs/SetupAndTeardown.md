---
id: setup-teardown
title: Setup and Teardown
---
[![Jest](/img/jestjs.svg)](https://jest-archive-august-2023.netlify.app/docs/27.x/setup-teardown)

Often while writing tests you have some setup work that needs to happen before tests run, and you have some finishing work that needs to happen after tests run. Jest Lua provides helper functions to handle this.

## Repeating Setup

If you have some work you need to do repeatedly for many tests, you can use `beforeEach` and `afterEach` hooks.

For example, let's say that several tests interact with a database of cities. You have a method `initializeCityDatabase()` that must be called before each of these tests, and a method `clearCityDatabase()` that must be called after each of these tests. You can do this with:
```lua
beforeEach(function()
	initializeCityDatabase()
end)

afterEach(function()
	clearCityDatabase()
end)

test('city database has Vienna', function()
	expect(isCity('Vienna')).toBeTruthy()
end)

test('city database has San Juan', function()
	expect(isCity('San Juan')).toBeTruthy()
end)
```

`beforeEach` and `afterEach` can handle asynchronous code in the same ways that [tests can handle asynchronous code](asynchronous) - they can either take a `done` parameter or return a promise. For example, if `initializeCityDatabase()` returned a promise that resolved when the database was initialized, we would want to return that promise:
```lua
beforeEach(function()
	return initializeCityDatabase()
end)
```

## One-Time Setup

In some cases, you only need to do setup once, at the beginning of a file. This can be especially bothersome when the setup is asynchronous, so you can't do it inline. Jest provides `beforeAll` and `afterAll` hooks to handle this situation.

For example, if both `initializeCityDatabase()` and `clearCityDatabase()` returned promises, and the city database could be reused between tests, we could change our test code to:
```lua
beforeAll(function()
	return initializeCityDatabase()
end)

afterAll(function()
	return clearCityDatabase()
end)

test('city database has Vienna', function()
	expect(isCity('Vienna')).toBeTruthy()
end)

test('city database has San Juan', function()
	expect(isCity('San Juan')).toBeTruthy()
end)
```

## Scoping

By default, the `beforeAll` and `afterAll` blocks apply to every test in a file. You can also group tests together using a `describe` block. When they are inside a `describe` block, the `beforeAll` and `afterAll` blocks only apply to the tests within that `describe` block.

For example, let's say we had not just a city database, but also a food database. We could do different setup for different tests:
```lua
-- Applies to all tests in this file
beforeEach(function()
	return initializeCityDatabase()
end)

test('city database has Vienna', function()
	expect(isCity('Vienna')).toBeTruthy()
end)

test('city database has San Juan', function()
	expect(isCity('San Juan')).toBeTruthy()
end)

describe('matching cities to foods', function()
	-- Applies only to tests in this describe block
	beforeEach(function()
		return initializeFoodDatabase()
	end)

	test('Vienna <3 veal', function()
		expect(isValidCityFoodPair('Vienna', 'Wiener Schnitzel')).toBe(true)
	end)
	test('San Juan <3 plantains', function()
		expect(isValidCityFoodPair('San Juan', 'Mofongo')).toBe(true)
	end)
end)
```

Note that the top-level `beforeEach` is executed before the `beforeEach` inside the `describe` block. It may help to illustrate the order of execution of all hooks.

```lua
beforeAll(function() print('1 - beforeAll') end)
afterAll(function() print('1 - afterAll') end)
beforeEach(function() print('1 - beforeEach') end)
afterEach(function() print('1 - afterEach') end)

test('', function()
	print('1 - test')
end)

describe('Scoped / Nested block', function()
	beforeAll(function() print('2 - beforeAll') end)
	afterAll(function() print('2 - afterAll') end)
	beforeEach(function() print('2 - beforeEach') end)
	afterEach(function() print('2 - afterEach') end)

	test('', function()
		print('2 - test')
	end)
end)

-- 1 - beforeAll
-- 1 - beforeEach
-- 1 - test
-- 1 - afterEach
-- 2 - beforeAll
-- 1 - beforeEach
-- 2 - beforeEach
-- 2 - test
-- 2 - afterEach
-- 1 - afterEach
-- 2 - afterAll
-- 1 - afterAll
```

## Order of Execution
Jest Lua executes all describe handlers in a test file _before_ it executes any of the actual tests. This is another reason to do setup and teardown inside `before*` and `after*` handlers rather than inside the `describe` blocks. Once the `describe` blocks are complete, by default Jest Lua runs all the tests serially in the order they were encountered in the collection phase, waiting for each to finish and be tidied up before moving on.

```lua
describe('describe outer', function()
	print('describe outer-a')

	describe('describe inner 1', function()
		print('describe inner 1')

		test('test 1', function()
			print('test 1')
		end)
	end)

	print('describe outer-b')

	test('test 2', function()
		print('test 2')
	end)

	describe('describe inner 2', function()
		print('describe inner 2')

		test('test 3', function()
			print('test 3')
		end)
	end)

	print('describe outer-c')
end)

-- describe outer-a
-- describe inner 1
-- describe outer-b
-- describe inner 2
-- describe outer-c
-- test 1
-- test 2
-- test 3
```

Just like the `describe` and `test` blocks Jest Lua calls the `before*` and `after*` hooks in the order of declaration. Note that the `after*` hooks of the enclosing scope are called first. For example, here is how you can set up and tear down resources which depend on each other:
```lua
beforeEach(function() print('connection setup') end)
beforeEach(function() print('database setup') end)

afterEach(function() print('database teardown') end)
afterEach(function() print('connection teardown') end)

test('test 1', function()
	print('test 1')
end)

describe('extra', function()
	beforeEach(function() print('extra database setup') end)

	afterEach(function() print('extra database teardown') end)

	test('test 2', function()
		print('test 2')
	end)
end)

-- connection setup
-- database setup
-- test 1
-- database teardown
-- connection teardown

-- connection setup
-- database setup
-- extra database setup
-- test 2
-- extra database teardown
-- database teardown
-- connection teardown
```

## General Advice

If a test is failing, one of the first things to check should be whether the test is failing when it's the only test that runs. To run only one test with Jest Lua, temporarily change that `test` command to a `test.only`:
```lua
test.only('this will be the only test that runs', function()
	expect(true).toBe(false)
end)

test('this test will not run', function()
	expect('A').toBe('A')
end)
```

If you have a test that often fails when it's run as part of a larger suite, but doesn't fail when you run it alone, it's a good bet that something from a different test is interfering with this one. You can often fix this by clearing some shared state with `beforeEach`. If you're not sure whether some shared state is being modified, you can also try a `beforeEach` that logs data.
