-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-each/src/__tests__/array.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]

local Packages = script.Parent.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Number = LuauPolyfill.Number
local NaN = Number.NaN
type Array<T> = LuauPolyfill.Array<T>
type Object = LuauPolyfill.Object
type Function = (...any) -> ...any

local NIL = require(script.Parent.Parent.nilPlaceholder)

local HttpService = game:GetService("HttpService")

local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local pretty = require(Packages.PrettyFormat).default
local each = require(script.Parent.Parent).default()

local function noop() end
local expectFunction = expect.any("function")

-- ROBLOX deviation: added types to parameters
local function get(object: Object, lensPath: Array<string>)
	-- ROBLOX deviation START: set source for metatable mock functions
	if
		#lensPath == 1
		and object._mockFns
		and Array.includes({ "describe", "fdescribe", "fit", "it", "test", "xdescribe", "xit", "xtest" }, lensPath[1])
	then
		object = object._mockFns
	end
	-- ROBLOX deviation END

	return Array.reduce(lensPath, function(acc, key)
		return acc[key]
	end, object)
end

local function getGlobalTestMocks()
	--[[
			ROBLOX deviation START: keep metatable mocks, to be able to make assertions in tests
			otherwise they would contain the self parameter
		]]
	local _mockFns = {
		describe = jest.fn(),
		fdescribe = jest.fn(),
		fit = jest.fn(),
		it = jest.fn(),
		test = jest.fn(),
		xdescribe = jest.fn(),
		xit = jest.fn(),
		xtest = jest.fn(),
	}

	local globals: any = {
		describe = setmetatable({}, {
			__call = function(_self, ...)
				return _mockFns.describe(...)
			end,
		}),
		fdescribe = setmetatable({}, {
			__call = function(_self, ...)
				return _mockFns.fdescribe(...)
			end,
		}),
		fit = setmetatable({}, {
			__call = function(_self, ...)
				return _mockFns.fit(...)
			end,
		}),
		it = setmetatable({}, {
			__call = function(_self, ...)
				return _mockFns.it(...)
			end,
		}),
		test = setmetatable({}, {
			__call = function(_self, ...)
				return _mockFns.test(...)
			end,
		}),
		xdescribe = setmetatable({}, {
			__call = function(_self, ...)
				return _mockFns.xdescribe(...)
			end,
		}),
		xit = setmetatable({}, {
			__call = function(_self, ...)
				return _mockFns.xit(...)
			end,
		}),
		xtest = setmetatable({}, {
			__call = function(_self, ...)
				return _mockFns.xtest(...)
			end,
		}),
	}
	-- ROBLOX deviation END

	globals.test.only = jest.fn()
	globals.test.skip = jest.fn()
	-- ROBLOX deviation START: concurrent is not supported
	-- globals.test.concurrent = jest.fn()
	-- globals.test.concurrent.only = jest.fn()
	-- globals.test.concurrent.skip = jest.fn()
	-- ROBLOX deviation END
	globals.it.only = jest.fn()
	globals.it.skip = jest.fn()
	globals.describe.only = jest.fn()
	globals.describe.skip = jest.fn()

	-- ROBLOX deviation START: Support TestEZ methods
	globals.testFOCUS = jest.fn()
	globals.testSKIP = jest.fn()
	globals.itFOCUS = jest.fn()
	globals.itSKIP = jest.fn()
	globals.describeFOCUS = jest.fn()
	globals.describeSKIP = jest.fn()
	-- ROBLOX deviation END

	-- ROBLOX deviation: return metatable mock functions
	globals._mockFns = _mockFns
	return globals
end

describe("jest-each", function()
	Array.forEach({
		{ "test" },
		-- ROBLOX deviation START: concurrent is not supported
		-- { "test", "concurrent" },
		-- { "test", "concurrent", "only" },
		-- { "test", "concurrent", "skip" },
		-- ROBLOX deviation END
		{ "test", "only" },
		{ "it" },
		{ "fit" },
		{ "it", "only" },
		{ "describe" },
		{ "fdescribe" },
		{ "describe", "only" },
		-- ROBLOX deviation START: support TestEZ methods
		{ "testFOCUS" },
		{ "itFOCUS" },
		{ "describeFOCUS" },
		-- ROBLOX deviation END
	}, function(keyPath)
		describe((".%s"):format(Array.join(keyPath, ".")), function()
			it("throws an error when not called with an array", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)(nil :: any)
				-- ROBLOX deviation START: couldn't infer type automatically
				local testFunction = (get(eachObject, keyPath) :: any) :: Function
				-- ROBLOX deviation END

				testFunction("expected string", noop)
				-- ROBLOX deviation START: couldn't infer type automatically
				local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
				-- ROBLOX deviation END
				expect(function()
					return globalMock.mock.calls[1][2](globalMock.mock.calls[1])
				end).toThrowErrorMatchingSnapshot()
			end)

			it("throws an error when called with an empty array", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)({})
				-- ROBLOX deviation START: couldn't infer type automatically
				local testFunction = (get(eachObject, keyPath) :: any) :: Function
				-- ROBLOX deviation END

				testFunction("expected string", noop)
				-- ROBLOX deviation START: couldn't infer type automatically
				local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
				-- ROBLOX deviation END

				expect(function()
					return globalMock.mock.calls[1][2](globalMock.mock.calls[1])
				end).toThrowErrorMatchingSnapshot()
			end)

			it("calls global with given title", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)({ {} })
				-- ROBLOX deviation START: couldn't infer type automatically
				local testFunction = (get(eachObject, keyPath) :: any) :: Function
				-- ROBLOX deviation END
				testFunction("expected string", noop)
				-- ROBLOX deviation END

				-- ROBLOX deviation START: couldn't infer type automatically
				local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
				-- ROBLOX deviation END
				expect(globalMock).toHaveBeenCalledTimes(1)
				expect(globalMock).toHaveBeenCalledWith("expected string", expectFunction, nil)
			end)

			it("calls global with given title when multiple tests cases exist", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)({ {}, {} })
				-- ROBLOX deviation START: couldn't infer type automatically
				local testFunction = (get(eachObject, keyPath) :: any) :: Function
				-- ROBLOX deviation END
				testFunction("expected string", noop)

				-- ROBLOX deviation START: couldn't infer type automatically
				local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
				-- ROBLOX deviation END
				expect(globalMock).toHaveBeenCalledTimes(2)
				expect(globalMock).toHaveBeenCalledWith("expected string", expectFunction, nil)
				expect(globalMock).toHaveBeenCalledWith("expected string", expectFunction, nil)
			end)

			it("calls global with title containing param values when using printf format", function()
				local globalTestMocks = getGlobalTestMocks()
				-- ROBLOX deviation: using NIL instead of nil to represent null/undefined
				local eachObject = each.withGlobal(globalTestMocks)({
					{
						"hello",
						1 :: any,
						NIL :: any,
						NIL :: any,
						1.2 :: any,
						{ foo = "bar" } :: any,
						function() end :: any,
						{} :: any,
						math.huge :: any,
						NaN :: any,
					},
					{
						"world",
						1 :: any,
						NIL :: any,
						NIL :: any,
						1.2 :: any,
						{ baz = "qux" } :: any,
						function() end :: any,
						{} :: any,
						math.huge :: any,
						NaN :: any,
					},
				})
				-- ROBLOX deviation START: couldn't infer type automatically
				local testFunction = (get(eachObject, keyPath) :: any) :: Function
				-- ROBLOX deviation END
				testFunction("expected string: %% %%s %s %d %s %s %d %j %s %j %d %d %#", noop)

				-- ROBLOX deviation START: couldn't infer type automatically
				local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
				-- ROBLOX deviation END
				expect(globalMock).toHaveBeenCalledTimes(2)
				-- ROBLOX deviation: stringified values representation differs with JS
				expect(globalMock).toHaveBeenCalledWith(
					("expected string: %% %%s hello 1 nil nil 1.2 %s Function [] inf nan 1"):format(
						HttpService:JSONEncode({ foo = "bar" })
					),
					expectFunction,
					nil
				)
				-- ROBLOX deviation: stringified values representation differs with JS
				expect(globalMock).toHaveBeenCalledWith(
					("expected string: %% %%s world 1 nil nil 1.2 %s Function [] inf nan 2"):format(
						HttpService:JSONEncode({ baz = "qux" })
					),
					expectFunction,
					nil
				)
			end)

			it("does not call global test with title containing more param values than sprintf placeholders", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)({
					{ "hello" :: any, 1, 2, 3, 4, 5 },
					{ "world" :: any, 1, 2, 3, 4, 5 },
				})
				-- ROBLOX deviation START: couldn't infer type automatically
				local testFunction = (get(eachObject, keyPath) :: any) :: Function
				-- ROBLOX deviation END
				testFunction("expected string: %s", noop)

				-- ROBLOX deviation START: couldn't infer type automatically
				local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
				-- ROBLOX deviation END
				expect(globalMock).toHaveBeenCalledTimes(2)
				expect(globalMock).toHaveBeenCalledWith("expected string: hello", expectFunction, nil)
				expect(globalMock).toHaveBeenCalledWith("expected string: world", expectFunction, nil)
			end)

			it("calls global test title with %p placeholder injected at the correct positions", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)({
					{ "string1", "pretty1", "string2", "pretty2" },
					{ "string1", "pretty1", "string2", "pretty2" },
				})
				-- ROBLOX deviation START: couldn't infer type automatically
				local testFunction = (get(eachObject, keyPath) :: any) :: Function
				-- ROBLOX deviation END
				testFunction("expected string: %s %p %s %p", noop)

				-- ROBLOX deviation START: couldn't infer type automatically
				local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
				-- ROBLOX deviation END
				expect(globalMock).toHaveBeenCalledTimes(2)
				expect(globalMock).toHaveBeenCalledWith(
					("expected string: string1 %s string2 %s"):format(pretty("pretty1"), pretty("pretty2")),
					expectFunction,
					nil
				)
				expect(globalMock).toHaveBeenCalledWith(
					("expected string: string1 %s string2 %s"):format(pretty("pretty1"), pretty("pretty2")),
					expectFunction,
					nil
				)
			end)

			it(
				"does not calls global test title with %p placeholder when no data is supplied at given position",
				function()
					local globalTestMocks = getGlobalTestMocks()
					local eachObject = each.withGlobal(globalTestMocks)({
						{ "string1", "pretty1", "string2" },
						{ "string1", "pretty1", "string2" },
					})
					-- ROBLOX deviation START: couldn't infer type automatically
					local testFunction = (get(eachObject, keyPath) :: any) :: Function
					-- ROBLOX deviation END
					testFunction("expected string: %s %p %s %p", noop)

					-- ROBLOX deviation START: couldn't infer type automatically
					local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
					-- ROBLOX deviation END
					expect(globalMock).toHaveBeenCalledTimes(2)
					expect(globalMock).toHaveBeenCalledWith(
						("expected string: string1 %s string2 %s"):format(pretty("pretty1"), "%p"),
						expectFunction,
						nil
					)
					expect(globalMock).toHaveBeenCalledWith(
						("expected string: string1 %s string2 %s"):format(pretty("pretty1"), "%p"),
						expectFunction,
						nil
					)
				end
			)

			it(
				"calls global with cb function containing all parameters of each test case when given 1d array",
				function()
					local globalTestMocks = getGlobalTestMocks()
					local testCallBack = jest.fn()
					local eachObject = each.withGlobal(globalTestMocks)({
						"hello",
						"world",
					})
					-- ROBLOX deviation START: couldn't infer type automatically
					local testFunction = (get(eachObject, keyPath) :: any) :: Function
					-- ROBLOX deviation END
					testFunction("expected string", testCallBack)

					-- ROBLOX deviation START: couldn't infer type automatically
					local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
					-- ROBLOX deviation END
					globalMock.mock.calls[1][2](globalMock.mock.calls[1])
					expect(testCallBack).toHaveBeenCalledTimes(1)
					expect(testCallBack).toHaveBeenCalledWith("hello")

					globalMock.mock.calls[2][2](globalMock.mock.calls[2])
					expect(testCallBack).toHaveBeenCalledTimes(2)
					expect(testCallBack).toHaveBeenCalledWith("world")
				end
			)

			it("calls global with cb function containing all parameters of each test case 2d array", function()
				local globalTestMocks = getGlobalTestMocks()
				local testCallBack = jest.fn()
				local eachObject = each.withGlobal(globalTestMocks)({
					{ "hello", "world" },
					{ "joe", "bloggs" },
				})
				-- ROBLOX deviation START: couldn't infer type automatically
				local testFunction = (get(eachObject, keyPath) :: any) :: Function
				-- ROBLOX deviation END
				testFunction("expected string", testCallBack)

				-- ROBLOX deviation START: couldn't infer type automatically
				local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
				-- ROBLOX deviation END
				globalMock.mock.calls[1][2](globalMock.mock.calls[1])
				expect(testCallBack).toHaveBeenCalledTimes(1)
				expect(testCallBack).toHaveBeenCalledWith("hello", "world")

				globalMock.mock.calls[2][2](globalMock.mock.calls[2])
				expect(testCallBack).toHaveBeenCalledTimes(2)
				expect(testCallBack).toHaveBeenCalledWith("joe", "bloggs")
			end)

			it("calls global with given timeout", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)({ { "hello" } })

				-- ROBLOX deviation START: couldn't infer type automatically
				local testFunction = (get(eachObject, keyPath) :: any) :: Function
				-- ROBLOX deviation END
				testFunction("some test", noop, 10000)
				-- ROBLOX deviation START: couldn't infer type automatically
				local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
				-- ROBLOX deviation END
				expect(globalMock).toHaveBeenCalledWith("some test", expect.any("function"), 10000)
			end)

			it("calls global with title containing object property when using $variable", function()
				local globalTestMocks = getGlobalTestMocks()
				-- ROBLOX deviation: using NIL instead of nil to represent null/undefined
				local eachObject = each.withGlobal(globalTestMocks)({
					{
						a = "hello",
						b = 1,
						c = NIL,
						d = NIL,
						e = 1.2,
						f = { key = "foo" },
						g = function() end,
						h = {},
						i = math.huge,
						j = NaN,
					},
					{
						a = "world",
						b = 1,
						c = NIL,
						d = NIL,
						e = 1.2,
						f = { key = "bar" },
						g = function() end,
						h = {},
						i = math.huge,
						j = NaN,
					},
				})
				-- ROBLOX deviation START: couldn't infer type automatically
				local testFunction = (get(eachObject, keyPath) :: any) :: Function
				-- ROBLOX deviation END
				testFunction("expected string: %% %%s $a $b $c $d $e $f $f.key $g $h $i $j $#", noop)

				-- ROBLOX deviation START: couldn't infer type automatically
				local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
				-- ROBLOX deviation END
				expect(globalMock).toHaveBeenCalledTimes(2)
				-- ROBLOX deviation: stringified values representation differs with JS
				expect(globalMock).toHaveBeenCalledWith(
					'expected string: % %s hello 1 nil nil 1.2 {"key": "foo"} foo [Function g] {} inf nan 1',
					expectFunction,
					nil
				)
				-- ROBLOX deviation: stringified values representation differs with JS
				expect(globalMock).toHaveBeenCalledWith(
					'expected string: % %s world 1 nil nil 1.2 {"key": "bar"} bar [Function g] {} inf nan 2',
					expectFunction,
					nil
				)
			end)

			it("calls global with title containing param values when using both % placeholder and $variable", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)({
					{ a = "hello", b = 1 },
					{ a = "world", b = 1 },
				})
				-- ROBLOX deviation START: couldn't infer type automatically
				local testFunction = (get(eachObject, keyPath) :: any) :: Function
				-- ROBLOX deviation END
				testFunction("expected string: %p %# $a $b $#", noop)

				-- ROBLOX deviation START: couldn't infer type automatically
				local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
				-- ROBLOX deviation END
				expect(globalMock).toHaveBeenCalledTimes(2)
				expect(globalMock).toHaveBeenCalledWith(
					'expected string: {"a": "hello", "b": 1} 1 $a $b $#',
					expectFunction,
					nil
				)
				expect(globalMock).toHaveBeenCalledWith(
					'expected string: {"a": "world", "b": 1} 2 $a $b $#',
					expectFunction,
					nil
				)
			end)
		end)
	end)
	describe("done callback", function()
		-- ROBLOX TODO: should be bound in jestCircus (itEACH?)
		-- it.each({
		-- 	{ { "test" } },
		-- 	{ { "test", "only" } },
		-- 	{ { "test", "concurrent" } },
		-- 	{ { "test", "concurrent", "only" } },
		-- 	{ { "it" } },
		-- 	{ { "fit" } },
		-- 	{ { "it", "only" } },
		-- })("calls %O with done when cb function has more args than params of given test row", function(keyPath)
		-- 	local globalTestMocks = getGlobalTestMocks()
		-- 	local eachObject = each.withGlobal(globalTestMocks)({ { "hello" } })

		-- 	local testFunction = get(eachObject, keyPath)
		-- 	testFunction("expected string", function(hello, done)
		-- 		expect(hello).toBe("hello")
		-- 		expect(done).toBe("DONE")
		-- 	end)
		-- 	get(globalTestMocks, keyPath).mock.calls[1][2](get(globalTestMocks, keyPath).mock.calls[1], "DONE")
		-- end)

		-- it.each({ { { "describe" } }, { { "fdescribe" } }, { { "describe", "only" } } })(
		-- 	"does not call %O with done when test function has more args than params of given test row",
		-- 	function(keyPath)
		-- 		local globalTestMocks = getGlobalTestMocks()
		-- 		local eachObject = each.withGlobal(globalTestMocks)({ { "hello" } })

		-- 		local testFunction = get(eachObject, keyPath)
		-- 		testFunction("expected string", function(hello, done)
		-- 			expect(hello).toBe("hello")
		-- 			expect(arguments.length).toBe(1)
		-- 			expect(done).toBe(nil)
		-- 		end)
		-- 		get(globalTestMocks, keyPath).mock.calls[1][2](get(globalTestMocks, keyPath).mock.calls[1], "DONE")
		-- 	end
		-- )
	end)

	Array.forEach({
		{ "xtest" },
		{ "test", "skip" },
		-- ROBLOX deviation: concurrent is not available
		-- { "test", "concurrent", "skip" },
		{ "xit" },
		{ "it", "skip" },
		{ "xdescribe" },
		{ "describe", "skip" },
		{ "testSKIP" },
		{ "itSKIP" },
		{ "describeSKIP" },
	}, function(keyPath)
		describe((".%s"):format(Array.join(keyPath, ".")), function()
			it("calls global with given title", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)({ {} })
				-- ROBLOX deviation START: couldn't infer type automatically
				local testFunction = (get(eachObject, keyPath) :: any) :: Function
				-- ROBLOX deviation END
				testFunction("expected string", noop)

				-- ROBLOX deviation START: couldn't infer type automatically
				local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
				-- ROBLOX deviation END
				expect(globalMock).toHaveBeenCalledTimes(1)
				expect(globalMock).toHaveBeenCalledWith("expected string", expectFunction, nil)
			end)

			it("calls global with given title when multiple tests cases exist", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)({ {}, {} })
				-- ROBLOX deviation START: couldn't infer type automatically
				local testFunction = (get(eachObject, keyPath) :: any) :: Function
				-- ROBLOX deviation END
				testFunction("expected string", noop)

				-- ROBLOX deviation START: couldn't infer type automatically
				local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
				-- ROBLOX deviation END
				expect(globalMock).toHaveBeenCalledTimes(2)
				expect(globalMock).toHaveBeenCalledWith("expected string", expectFunction, nil)
			end)

			it("calls global with title containing param values when using sprintf format", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)({
					{ "hello", 1 :: any },
					{ "world", 2 :: any },
				})
				-- ROBLOX deviation START: couldn't infer type automatically
				local testFunction = (get(eachObject, keyPath) :: any) :: Function
				-- ROBLOX deviation END
				testFunction("expected string: %s %s", function() end)

				-- ROBLOX deviation START: couldn't infer type automatically
				local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
				-- ROBLOX deviation END
				expect(globalMock).toHaveBeenCalledTimes(2)
				expect(globalMock).toHaveBeenCalledWith("expected string: hello 1", expectFunction, nil)
				expect(globalMock).toHaveBeenCalledWith("expected string: world 2", expectFunction, nil)
			end)

			it("calls global with title with placeholder values correctly interpolated", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)({
					{ "hello", "%d", 10 :: any, "%s", { foo = "bar" } :: any },
					{ "world", "%i", 1991 :: any, "%p", { foo = "bar" } :: any },
					{ "joe", "%d %d", 10 :: any, "%%s", { foo = "bar" } :: any },
				})
				-- ROBLOX deviation START: couldn't infer type automatically
				local testFunction = (get(eachObject, keyPath) :: any) :: Function
				-- ROBLOX deviation END
				testFunction("expected string: %s %s %d %s %p", function() end)

				-- ROBLOX deviation START: couldn't infer type automatically
				local globalMock = (get(globalTestMocks, keyPath) :: any) :: typeof(jest.fn())
				-- ROBLOX deviation END
				expect(globalMock).toHaveBeenCalledTimes(3)
				expect(globalMock).toHaveBeenCalledWith(
					'expected string: hello %d 10 %s {"foo": "bar"}',
					expectFunction,
					nil
				)
				expect(globalMock).toHaveBeenCalledWith(
					'expected string: world %i 1991 %p {"foo": "bar"}',
					expectFunction,
					nil
				)
				expect(globalMock).toHaveBeenCalledWith(
					'expected string: joe %d %d 10 %%s {"foo": "bar"}',
					expectFunction,
					nil
				)
			end)
		end)
	end)
end)

return {}
