--!nocheck
-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-each/src/__tests__/template.test.ts
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
local Symbol = LuauPolyfill.Symbol

local NIL = require(script.Parent.Parent.nilPlaceholder)

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local jestExpect = JestGlobals.expect
local describe = (JestGlobals.describe :: any) :: Function
local it = (JestGlobals.it :: any) :: Function

local each = require(script.Parent.Parent).default()
local function noop() end

local expectFunction = jestExpect.any("function")

local function get(object, lensPath)
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
		-- { "test", "concurrent" },
		-- { "test", "concurrent", "only" },
		-- { "test", "concurrent", "skip" },
		{ "test", "only" },
		{ "it" },
		{ "fit" },
		{ "it", "only" },
		{ "describe" },
		{ "fdescribe" },
		{ "describe", "only" },
		-- ROBLOX deviation: support TestEZ functions
		{ "testFOCUS" },
		{ "itFOCUS" },
		{ "describeFOCUS" },
	}, function(keyPath)
		describe((".%s"):format(Array.join(keyPath, ".")), function()
			it("throws error when there are additional words in first column heading", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a is the left | b | expected", { 1, 1, 2 })
				local testFunction = get(eachObject, keyPath)
				local testCallBack = jest.fn()
				testFunction("this will blow up :(", testCallBack)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(function()
					return globalMock.mock.calls[1][2](globalMock.mock.calls[1])
				end).toThrowErrorMatchingSnapshot()
				jestExpect(testCallBack).never.toHaveBeenCalled()
			end)

			it("does not throw error when there are multibyte characters in first column headings", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("ʅ(ツ)ʃ  | b | expected", { 1, 1, 2 })
				local testFunction = get(eachObject, keyPath)
				local testCallBack = jest.fn()
				testFunction("accept multibyte characters", testCallBack)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(function()
					return globalMock.mock.calls[1][2](globalMock.mock.calls[1])
				end).never.toThrowError()
				jestExpect(testCallBack).toHaveBeenCalledWith({
					b = 1,
					expected = 2,
					["\u{285}(\u{30C4})\u{283}"] = 1,
				})
			end)

			it("throws error when there are additional words in second column heading", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a | b is the right | expected", { 1, 1, 2 })
				local testFunction = get(eachObject, keyPath)
				local testCallBack = jest.fn()
				testFunction("this will blow up :(", testCallBack)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(function()
					return globalMock.mock.calls[1][2](globalMock.mock.calls[1])
				end).toThrowErrorMatchingSnapshot()
				jestExpect(testCallBack).never.toHaveBeenCalled()
			end)

			it("does not throw error when there are multibyte characters in second column headings", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a | ☝(ʕ⊙ḕ⊙ʔ)☝ | expected", { 1, 1, 2 })
				local testFunction = get(eachObject, keyPath)
				local testCallBack = jest.fn()
				testFunction("accept multibyte characters", testCallBack)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(function()
					return globalMock.mock.calls[1][2](globalMock.mock.calls[1])
				end).never.toThrowError()
				jestExpect(testCallBack).toHaveBeenCalledWith({
					a = 1,
					expected = 2,
					["\u{261D}(\u{295}\u{2299}\u{1E15}\u{2299}\u{294})\u{261D}"] = 1,
				})
			end)

			it("throws error when there are additional words in last column heading", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a | b | expected value", { 1, 1, 2 })
				local testFunction = get(eachObject, keyPath)
				local testCallBack = jest.fn()
				testFunction("this will blow up :(", testCallBack)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(function()
					return globalMock.mock.calls[1][2](globalMock.mock.calls[1])
				end).toThrowErrorMatchingSnapshot()
				jestExpect(testCallBack).never.toHaveBeenCalled()
			end)

			it("does not throw error when there are multibyte characters in last column headings", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a | b | (๑ఠ‿ఠ๑)＜expected", { 1, 1, 2 })

				local testFunction = get(eachObject, keyPath)
				local testCallBack = jest.fn()
				testFunction("accept multibyte characters", testCallBack)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(function()
					return globalMock.mock.calls[1][2](globalMock.mock.calls[1])
				end).never.toThrowError()
				jestExpect(testCallBack).toHaveBeenCalledWith({
					["(\u{E51}\u{C20}\u{203F}\u{C20}\u{E51})\u{FF1C}expected"] = 2,
					a = 1,
					b = 1,
				})
			end)

			it("does not throw error when there is additional words in template after heading row", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)(
					[[

							a    | b    | expected
							foo
							bar
						]],
					{ 1, 1, 2 }
				)
				local testFunction = get(eachObject, keyPath)
				local testCallBack = jest.fn()
				testFunction("test title", testCallBack)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(globalMock).toHaveBeenCalledTimes(1)
				jestExpect(globalMock).toHaveBeenCalledWith("test title", expectFunction, nil)
			end)

			it("does not throw error when there is only one column", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a", { 1 })
				local testFunction = get(eachObject, keyPath)
				local testCallBack = jest.fn()
				testFunction("test title", testCallBack)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(globalMock).toHaveBeenCalledTimes(1)
				jestExpect(globalMock).toHaveBeenCalledWith("test title", expectFunction, nil)
			end)

			it(
				"does not throw error when there is only one column with additional words in template after heading",
				function()
					local globalTestMocks = getGlobalTestMocks()
					local eachObject = each.withGlobal(globalTestMocks)(
						[[

								a
								hello world
							]],
						{ 1 }
					)
					local testFunction = get(eachObject, keyPath)
					local testCallBack = jest.fn()
					testFunction("test title $a", testCallBack)
					local globalMock = get(globalTestMocks, keyPath)
					jestExpect(globalMock).toHaveBeenCalledTimes(1)
					jestExpect(globalMock).toHaveBeenCalledWith("test title 1", expectFunction, nil)
				end
			)

			it("throws error when there are no arguments for given headings", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a | b | expected")
				local testFunction = get(eachObject, keyPath)
				local testCallBack = jest.fn()
				testFunction("this will blow up :(", testCallBack)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(function()
					return globalMock.mock.calls[1][2](globalMock.mock.calls[1])
				end).toThrowErrorMatchingSnapshot()
				jestExpect(testCallBack).never.toHaveBeenCalled()
			end)

			it("throws error when there are fewer arguments than headings when given one row", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a | b | expected", { 0, 1 })
				local testFunction = get(eachObject, keyPath)
				local testCallBack = jest.fn()
				testFunction("this will blow up :(", testCallBack)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(function()
					return globalMock.mock.calls[1][2](globalMock.mock.calls[1])
				end).toThrowErrorMatchingSnapshot()
				jestExpect(testCallBack).never.toHaveBeenCalled()
			end)

			it("throws error when there are fewer arguments than headings over multiple rows", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a    | b    | expected", { 0, 1, 1 }, { 1, 1 })
				local testFunction = get(eachObject, keyPath)
				local testCallBack = jest.fn()
				testFunction("this will blow up :(", testCallBack)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(function()
					return globalMock.mock.calls[1][2](globalMock.mock.calls[1])
				end).toThrowErrorMatchingSnapshot()
				jestExpect(testCallBack).never.toHaveBeenCalled()
			end)

			it("throws an error when called with an empty string", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("   ")
				local testFunction = get(eachObject, keyPath)
				local testCallBack = jest.fn()
				testFunction("this will blow up :(", testCallBack)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(function()
					return globalMock.mock.calls[1][2](globalMock.mock.calls[1])
				end).toThrowErrorMatchingSnapshot()
				jestExpect(testCallBack).never.toHaveBeenCalled()
			end)

			it("calls global with given title", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a | b | expected", { 0, 1, 1 })
				local testFunction = get(eachObject, keyPath)
				testFunction("expected string", noop)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(globalMock).toHaveBeenCalledTimes(1)
				jestExpect(globalMock).toHaveBeenCalledWith("expected string", expectFunction, nil)
			end)

			it("calls global with given title when multiple tests cases exist", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a | b | expected", { 0, 1, 1 }, { 1, 1, 2 })
				local testFunction = get(eachObject, keyPath)
				testFunction("expected string", noop)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(globalMock).toHaveBeenCalledTimes(2)
				jestExpect(globalMock).toHaveBeenCalledWith("expected string", expectFunction, nil)
				jestExpect(globalMock).toHaveBeenCalledWith("expected string", expectFunction, nil)
			end)

			it("calls global with title containing param values when using $variable format", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a | b | expected", { 0, 1, 1 }, { 1, 1, 2 })
				local testFunction = get(eachObject, keyPath)
				testFunction("expected string: a=$a, b=$b, expected=$expected index=$#", noop)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(globalMock).toHaveBeenCalledTimes(2)
				-- ROBLOX deviation START: index starts at 1
				jestExpect(globalMock).toHaveBeenCalledWith(
					"expected string: a=0, b=1, expected=1 index=1",
					expectFunction,
					nil
				)
				jestExpect(globalMock).toHaveBeenCalledWith(
					"expected string: a=1, b=1, expected=2 index=2",
					expectFunction,
					nil
				)
				-- ROBLOX deviation END
			end)

			it("calls global with title containing $key in multiple positions", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a | b | expected", { 0, 1, 1 }, { 1, 1, 2 })
				local testFunction = get(eachObject, keyPath)
				testFunction("add($a, $b) expected string: a=$a, b=$b, expected=$expected index=$#", noop)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(globalMock).toHaveBeenCalledTimes(2)
				-- ROBLOX deviation START: index starts at 1
				jestExpect(globalMock).toHaveBeenCalledWith(
					"add(0, 1) expected string: a=0, b=1, expected=1 index=1",
					expectFunction,
					nil
				)
				jestExpect(globalMock).toHaveBeenCalledWith(
					"add(1, 1) expected string: a=1, b=1, expected=2 index=2",
					expectFunction,
					nil
				)
				-- ROBLOX deviation END
			end)

			it("calls global with title containing $key.path", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a", {
					{
						foo = {
							bar = "baz",
						},
					},
				})
				local testFunction = get(eachObject, keyPath)
				testFunction("interpolates object keyPath to value: $a.foo.bar", noop)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(globalMock).toHaveBeenCalledTimes(1)
				jestExpect(globalMock).toHaveBeenCalledWith(
					"interpolates object keyPath to value: baz",
					expectFunction,
					nil
				)
			end)

			it("calls global with title containing last seen object when $key.path is invalid", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a", {
					{
						foo = {
							bar = "baz",
						},
					},
				})
				local testFunction = get(eachObject, keyPath)
				testFunction("interpolates object keyPath to value: $a.foo.qux", noop)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(globalMock).toHaveBeenCalledTimes(1)
				jestExpect(globalMock).toHaveBeenCalledWith(
					'interpolates object keyPath to value: {"bar": "baz"}',
					expectFunction,
					nil
				)
			end)

			it("calls global with cb function with object built from table headings and values", function()
				local globalTestMocks = getGlobalTestMocks()
				local testCallBack = jest.fn()
				local eachObject = each.withGlobal(globalTestMocks)("a | b | expected", { 0, 1, 1 }, { 1, 1, 2 })
				local testFunction = get(eachObject, keyPath)
				testFunction("expected string", testCallBack)
				local globalMock = get(globalTestMocks, keyPath)
				globalMock.mock.calls[1][2](globalMock.mock.calls[1])
				jestExpect(testCallBack).toHaveBeenCalledTimes(1)
				jestExpect(testCallBack).toHaveBeenCalledWith({ a = 0, b = 1, expected = 1 })
				globalMock.mock.calls[2][2](globalMock.mock.calls[2])
				jestExpect(testCallBack).toHaveBeenCalledTimes(2)
				jestExpect(testCallBack).toHaveBeenCalledWith({ a = 1, b = 1, expected = 2 })
			end)

			it("calls global with given timeout", function()
				local globalTestMocks = getGlobalTestMocks()
				local eachObject = each.withGlobal(globalTestMocks)("a | b | expected", { 0, 1, 1 })
				local testFunction = get(eachObject, keyPath)
				testFunction("some test", noop, 10000)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(globalMock).toHaveBeenCalledWith("some test", jestExpect.any("function"), 10000)
			end)

			it("formats primitive values using .toString()", function()
				local globalTestMocks = getGlobalTestMocks()
				local number_ = 1
				local string_ = "hello"
				local boolean_ = true
				local symbol_ = Symbol("world")
				local nullValue = NIL
				local undefinedValue = NIL
				local eachObject = each.withGlobal(globalTestMocks)(
					"number | string | boolean | symbol | nullValue | undefinedValue",
					{ number_, string_, boolean_, symbol_, nullValue, undefinedValue }
				)
				local testFunction = get(eachObject, keyPath)
				testFunction(
					"number: $number | string: $string | boolean: $boolean | symbol: $symbol | null: $nullValue | undefined: $undefinedValue",
					noop
				)
				local globalMock = get(globalTestMocks, keyPath)
				jestExpect(globalMock).toHaveBeenCalledWith(
					"number: 1 | string: hello | boolean: true | symbol: Symbol(world) | null: nil | undefined: nil",
					jestExpect.any("function"),
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
		-- 	{ { "test", "concurrent", "only" } },
		-- 	{ { "it" } },
		-- 	{ { "fit" } },
		-- 	{ { "it", "only" } },
		-- })("calls %O with done when cb function has more args than params of given test row", function(keyPath)
		-- 	local globalTestMocks = getGlobalTestMocks()
		-- 	local eachObject = each.withGlobal(globalTestMocks)([[

		-- 		a    | b    | expected
		-- 		${0} | ${1} | ${1}
		-- 	]])
		-- 	local testFunction = get(eachObject, keyPath)
		-- 	testFunction("expected string", function(ref, done)
		-- 		local a, b, expected = ref.a, ref.b, ref.expected
		-- 		jestExpect(a).toBe(0)
		-- 		jestExpect(b).toBe(1)
		-- 		jestExpect(expected).toBe(1)
		-- 		jestExpect(done).toBe("DONE")
		-- 	end)
		-- 	get(globalTestMocks, keyPath).mock.calls[1][2](get(globalTestMocks, keyPath).mock.calls[1], "DONE")
		-- end)
		-- it.each({ { { "describe" } }, { { "fdescribe" } }, { { "describe", "only" } } })(
		-- 	"does not call %O with done when test function has more args than params of given test row",
		-- 	function(keyPath)
		-- 		local globalTestMocks = getGlobalTestMocks()
		-- 		local eachObject = each.withGlobal(globalTestMocks)([[

		-- 			a    | b    | expected
		-- 			${0} | ${1} | ${1}
		-- 		]])
		-- 		local testFunction = get(eachObject, keyPath)
		-- 		testFunction("expected string", function(...)
		-- 			local ref, done = ...
		-- 			local a, b, expected = ref.a, ref.b, ref.expected
		-- 			jestExpect(a).toBe(0)
		-- 			jestExpect(b).toBe(1)
		-- 			jestExpect(expected).toBe(1)
		-- 			jestExpect(done).toBe(nil)
		-- 			jestExpect(#{ ... }).toBe(1)
		-- 		end)
		-- 		get(globalTestMocks, keyPath).mock.calls[1][2](get(globalTestMocks, keyPath).mock.calls[1], "DONE")
		-- 	end
		-- )
	end)

	Array.forEach({
		{ "xtest" },
		{ "test", "skip" },
		-- { "test", "concurrent" },
		-- { "test", "concurrent", "skip" },
		{ "xit" },
		{ "it", "skip" },
		{ "xdescribe" },
		{ "describe", "skip" },
		-- ROBLOX deviation: support TestEZ methods
		{ "testSKIP" },
		{ "itSKIP" },
		{ "describeSKIP" },
	}, function(keyPath)
		describe(
			(".%s"):format(
				Array.join(keyPath, ".") --[[ ROBLOX CHECK: check if 'keyPath' is an Array ]]
			),
			function()
				it("calls global with given title", function()
					local globalTestMocks = getGlobalTestMocks()
					local eachObject = each.withGlobal(globalTestMocks)("a | b | expected", { 0, 1, 1 })
					local testFunction = get(eachObject, keyPath)
					testFunction("expected string", noop)
					local globalMock = get(globalTestMocks, keyPath)
					jestExpect(globalMock).toHaveBeenCalledTimes(1)
					jestExpect(globalMock).toHaveBeenCalledWith("expected string", expectFunction, nil)
				end)

				it("calls global with given title when multiple tests cases exist", function()
					local globalTestMocks = getGlobalTestMocks()
					local eachObject = each.withGlobal(globalTestMocks)("a | b | expected", { 0, 1, 1 }, { 1, 1, 2 })
					local testFunction = get(eachObject, keyPath)
					testFunction("expected string", noop)
					local globalMock = get(globalTestMocks, keyPath)
					jestExpect(globalMock).toHaveBeenCalledTimes(2)
					jestExpect(globalMock).toHaveBeenCalledWith("expected string", expectFunction, nil)
					jestExpect(globalMock).toHaveBeenCalledWith("expected string", expectFunction, nil)
				end)
				it("calls global with title containing param values when using $variable format", function()
					local globalTestMocks = getGlobalTestMocks()
					local eachObject = each.withGlobal(globalTestMocks)("a | b | expected", { 0, 1, 1 }, { 1, 1, 2 })
					local testFunction = get(eachObject, keyPath)
					testFunction("expected string: a=$a, b=$b, expected=$expected index=$#", noop)
					local globalMock = get(globalTestMocks, keyPath)
					jestExpect(globalMock).toHaveBeenCalledTimes(2)
					-- ROBLOX deviation START: index starts at 1
					jestExpect(globalMock).toHaveBeenCalledWith(
						"expected string: a=0, b=1, expected=1 index=1",
						expectFunction,
						nil
					)
					jestExpect(globalMock).toHaveBeenCalledWith(
						"expected string: a=1, b=1, expected=2 index=2",
						expectFunction,
						nil
					)
					-- ROBLOX deviation END
				end)
			end
		)
	end)
end)

return {}
