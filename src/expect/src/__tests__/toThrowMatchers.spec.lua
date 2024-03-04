-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/expect/src/__tests__/toThrowMatchers.test.ts

-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local test = JestGlobals.test
local beforeAll = JestGlobals.beforeAll
local jestExpect = require("..")

local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local Error = LuauPolyfill.Error
local extends = LuauPolyfill.extends

local Promise = require("@pkg/@jsdotlua/promise")
local RegExp = require("@pkg/luau-regexp")

local alignedAnsiStyleSerializer = require("@pkg/@jsdotlua/test-utils").alignedAnsiStyleSerializer

-- deviation: this utility function is used to reduce the depth of function expressions
-- to work around full-moon stack overflow issues
local function createFn(fn, ...)
	local args = table.pack(...)
	return function()
		fn(table.unpack(args, 1, args.n))
	end
end

beforeAll(function()
	expect.addSnapshotSerializer(alignedAnsiStyleSerializer)
end)

local CustomError = extends(Error, "CustomError", function(self, message)
	self.message = message
	self.name = "Error"
	self.stack = "  at jestExpect" .. " (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)"
end)

local matchers = { "toThrowError", "toThrow" }

for _, toThrow in matchers do
	local prefix = toThrow .. " "
	-- describe(toThrow, function()
	local Err = extends(CustomError, "Err", function(self, message)
		self.name = "Error"
		self.message = message
		self.stack = "  at jestExpect" .. " (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)"
	end)
	local Err2 = extends(CustomError, "Err2", function(self, message)
		self.name = "Error"
		self.message = message
		self.stack = "  at jestExpect" .. " (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)"
	end)

	it(prefix .. "to throw or not to throw", function()
		jestExpect(function()
			error(CustomError("apple"))
		end)[toThrow]()
		jestExpect(function() end).never[toThrow]()
	end)

	describe(prefix .. "substring", function()
		it("passes", function()
			jestExpect(function()
				error(CustomError("apple"))
			end)[toThrow]("apple")
			jestExpect(function()
				error(CustomError("banana"))
			end).never[toThrow]("apple")
			jestExpect(function() end).never[toThrow]("apple")
		end)

		it("did not throw at all", function()
			expect(function()
				jestExpect(function() end)[toThrow]("apple")
			end).toThrowErrorMatchingSnapshot()
		end)

		it("threw, but message did not match (error)", function()
			expect(function()
				jestExpect(function()
					error(CustomError("apple"))
				end)[toThrow]("banana")
			end).toThrowErrorMatchingSnapshot()
		end)

		it("threw, but message did not match (non-error falsey)", function()
			expect(function()
				jestExpect(function()
					error("")
				end)[toThrow]("Server Error")
			end).toThrowErrorMatchingSnapshot()
		end)

		it("properly escapes strings when matching against errors", function()
			jestExpect(function()
				error(Error('"this"? throws.'))
			end)[toThrow]('"this"? throws.')
		end)

		it("threw, but message should not match (error)", function()
			expect(function()
				jestExpect(function()
					error(CustomError("Invalid array length"))
				end).never[toThrow]("array")
			end).toThrowErrorMatchingSnapshot()
		end)

		it("threw, but message should not match (non-error truthy)", function()
			expect(function()
				jestExpect(function()
					error("Internal Server Error")
				end).never[toThrow]("Server Error")
			end).toThrowErrorMatchingSnapshot()
		end)
	end)

	describe(prefix .. "regexp", function()
		it("passes", function()
			jestExpect(function()
				error(CustomError("apple"))
			end)[toThrow](RegExp("apple"))
			jestExpect(function()
				error(CustomError("banana"))
			end).never[toThrow](RegExp("apple"))
			jestExpect(function() end).never[toThrow](RegExp("apple"))
		end)

		it("did not throw at all", function()
			expect(function()
				jestExpect(function() end)[toThrow](RegExp("apple"))
			end).toThrowErrorMatchingSnapshot()
		end)

		it("threw, but message did not match (error)", function()
			expect(function()
				jestExpect(function()
					error(CustomError("apple"))
				end)[toThrow](RegExp("banana"))
			end).toThrowErrorMatchingSnapshot()
		end)

		-- ROBLOX deviation: The following test prints "0" instead of 0
		-- because the error string that's reported by lua when you do
		-- error(0) is indistinguishable from error("0")
		-- similar deviations hold for other tests that error integers
		it("threw, but message did not match (non-error falsey)", function()
			expect(function()
				jestExpect(function()
					error(0)
				end)[toThrow](RegExp("^[123456789]\\d*"))
			end).toThrowErrorMatchingSnapshot()
		end)

		it("threw, but message should not match (error)", function()
			expect(function()
				jestExpect(function()
					error(CustomError("Invalid array length"))
				end).never[toThrow](RegExp(" array "))
			end).toThrowErrorMatchingSnapshot()
		end)

		-- ROBLOX deviation: the following test prints "404" instead of 404 in
		-- the output for the same reason as above
		it("threw, but message should not match (non-error truthy)", function()
			expect(function()
				jestExpect(function()
					error(404)
				end).never[toThrow](RegExp("^[123456789]\\d*"))
			end).toThrowErrorMatchingSnapshot()
		end)
	end)

	describe(prefix .. "error class", function()
		local SubErr = extends(Err, "SubErr", function(self, message)
			self.message = message
			self.name = "SubErr"
			self.stack = "  at jestExpect" .. " (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)"
		end)
		local SubSubErr = extends(SubErr, "SubSubErr", function(self, message)
			self.message = message
			self.name = "SubSubErr"
			self.stack = "  at jestExpect" .. " (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)"
		end)

		it("passes", function()
			jestExpect(function()
				error(Err())
			end)[toThrow](Err)
			jestExpect(function()
				error(Err())
			end)[toThrow](CustomError)
			jestExpect(function()
				error(Err())
			end).never[toThrow](Err2)
			jestExpect(function() end).never[toThrow](Err)
		end)

		it("did not throw at all", function()
			expect(function()
				jestExpect(function() end)[toThrow](Err)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("threw, but class did not match (error)", function()
			expect(function()
				jestExpect(function()
					error(Err("apple"))
				end)[toThrow](Err2)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("threw, but class did not match (non-error falsey)", function()
			expect(function()
				jestExpect(function()
					error(nil)
				end)[toThrow](Err2)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("threw, but class should not match (error)", function()
			expect(function()
				jestExpect(function()
					error(Err("apple"))
				end).never[toThrow](Err)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("threw, but class should not match (error subclass)", function()
			expect(function()
				jestExpect(function()
					error(SubErr("apple"))
				end).never[toThrow](Err)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("threw, but class should not match (error subsubclass)", function()
			expect(function()
				jestExpect(function()
					error(SubSubErr("apple"))
				end).never[toThrow](Err)
			end).toThrowErrorMatchingSnapshot()
		end)
	end)

	describe(prefix .. "error-message", function()
		local ErrorMessage = {}

		function ErrorMessage.new(_, message)
			local self = {
				message = message,
			}
			return setmetatable(self, ErrorMessage)
		end

		setmetatable(ErrorMessage, {
			__call = ErrorMessage.new,
		})

		local expected = ErrorMessage("apple")

		describe("pass", function()
			it("isNot false", function()
				jestExpect(function()
					error(ErrorMessage("apple"))
				end)[toThrow](expected)
			end)

			it("isNot true", function()
				jestExpect(function()
					error(ErrorMessage("banana"))
				end).never[toThrow](expected)
			end)
		end)

		describe("fail", function()
			it("isNot false", function()
				expect(function()
					jestExpect(function()
						error(ErrorMessage("banana"))
					end)[toThrow](expected)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("isNot true", function()
				local message = "Invalid array length"
				expect(function()
					jestExpect(function()
						error(ErrorMessage(message))
					end).never[toThrow]({ message = message })
				end).toThrowErrorMatchingSnapshot()
			end)

			it("multiline diff highlight incorrect expected space", function()
				local a = "There is no route defined for key Settings. \nMust be one of: 'Home'"
				local b = "There is no route defined for key Settings.\nMust be one of: 'Home'"
				expect(function()
					jestExpect(function()
						error(ErrorMessage(b))
					end)[toThrow]({ message = a })
				end).toThrowErrorMatchingSnapshot()
			end)
		end)
	end)

	local asymmetricPrefix = prefix .. "asymmetric "
	-- describe("asymmetric", function()
	describe(asymmetricPrefix .. "any-Class", function()
		describe("pass", function()
			it("isNot false", function()
				jestExpect(function()
					error(Err("apple"))
				end)[toThrow](expect.any(Err))
			end)

			it("isNot true", function()
				jestExpect(function()
					error(Err("apple"))
				end).never[toThrow](expect.any(Err2))
			end)
		end)

		describe("fail", function()
			it("isNot false", function()
				expect(function()
					jestExpect(function()
						error(Err("apple"))
					end)[toThrow](expect.any(Err2))
				end).toThrowErrorMatchingSnapshot()
			end)

			it("isNot true", function()
				expect(function()
					jestExpect(function()
						error(Err("apple"))
					end).never[toThrow](expect.any(Err))
				end).toThrowErrorMatchingSnapshot()
			end)
		end)
	end)

	describe(asymmetricPrefix .. "anything", function()
		describe("pass", function()
			it("isNot false", function()
				jestExpect(function()
					error(CustomError("apple"))
				end)[toThrow](expect.anything())
			end)

			-- ROBLOX deviation: skipped test because we have no undefined
			-- type and nil does not match expect.anything()
			it.skip("isNot true", function()
				-- jestExpect(function() end).never[toThrow](expect.anything())
				-- jestExpect(function()
				-- 	error(nil)
				-- end).never[toThrow](expect.anything())
			end)
		end)

		describe("fail", function()
			-- We have to skip this for now since we are now
			-- returning an Error with a stack trace for all
			-- objects so that would not throw an error for
			-- expect.anything()
			it.skip("isNot false", function()
				expect(function()
					jestExpect(function()
						error(nil)
					end)[toThrow](expect.anything())
				end).toThrowErrorMatchingSnapshot()
			end)

			it("isNot true", function()
				expect(function()
					jestExpect(function()
						error(CustomError("apple"))
					end).never[toThrow](expect.anything())
				end).toThrowErrorMatchingSnapshot()
			end)
		end)
	end)

	describe(asymmetricPrefix .. "no-symbol", function()
		-- Test serialization of asymmetric matcher which has no property:
		-- this.$$typeof = Symbol.for('jest.asymmetricMatcher')

		local matchError = {
			asymmetricMatch = function(self, received)
				return received ~= nil and received.name == "Error"
			end,
		}

		local matchNotError = {
			asymmetricMatch = function(self, received)
				return received ~= nil and received.name ~= "Error"
			end,
		}

		describe("pass", function()
			it("isNot false", function()
				jestExpect(function()
					error(CustomError("apple"))
				end)[toThrow](matchError)
			end)

			it("isNot true", function()
				jestExpect(function()
					error(CustomError("apple"))
				end).never[toThrow](matchNotError)
			end)
		end)

		describe("fail", function()
			it("isNot false", function()
				expect(function()
					jestExpect(function()
						error(CustomError("apple"))
					end)[toThrow](matchNotError)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("isNot true", function()
				expect(function()
					jestExpect(function()
						error(CustomError("apple"))
					end).never[toThrow](matchError)
				end).toThrowErrorMatchingSnapshot()
			end)
		end)
	end)

	describe(asymmetricPrefix .. "objectContaining", function()
		local matchError = expect.objectContaining({
			name = "Error",
		})
		local matchNotError = expect.objectContaining({
			name = "NotError",
		})

		describe("pass", function()
			it("isNot false", function()
				jestExpect(createFn(error, CustomError("apple")))[toThrow](matchError)
			end)

			it("isNot true", function()
				jestExpect(createFn(error, CustomError("apple"))).never[toThrow](matchNotError)
			end)
		end)

		describe("fail", function()
			it("isNot false", function()
				expect(function()
					jestExpect(createFn(error, CustomError("apple")))[toThrow](matchNotError)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("isNot true", function()
				expect(function()
					jestExpect(createFn(error, CustomError("apple"))).never[toThrow](matchError)
				end).toThrowErrorMatchingSnapshot()
			end)
		end)
	end)
	-- end)

	local promisePrefix = prefix .. "promise/async throws if Error-like object is returned "
	-- describe("promise/async throws if Error-like object is returned", function()
	local function asyncFn(shouldThrow: boolean?, resolve: boolean?)
		local err
		if shouldThrow then
			err = Err.new("async apple")
		end
		if resolve then
			-- ROBLOX deviation START: remove :expect() call to better align with JS behaviour
			-- return Promise.resolve(err or "apple"):expect()
			return Promise.resolve(err or "apple")
			-- ROBLOX deviation END
		else
			-- ROBLOX deviation START: remove :expect() call to better align with JS behaviour
			-- return Promise.reject(err or "apple"):expect()
			return Promise.reject(err or "apple")
			-- ROBLOX deviation END
		end
	end

	local function expectAsyncFn(shouldThrow, resolve)
		return jestExpect(asyncFn(shouldThrow, resolve))
	end

	local function expectAsyncFnRejects(shouldThrow, resolve)
		return expectAsyncFn(shouldThrow, resolve).rejects
	end

	local function expectAsyncFnResolves(shouldThrow, resolve)
		return expectAsyncFn(shouldThrow, resolve).resolves
	end

	local function passesTest()
		expect.assertions(24)
		jestExpect(Promise.reject(Error.new())).rejects[toThrow]():expect()

		expectAsyncFnRejects(true)[toThrow]():expect()
		expectAsyncFnRejects(true)[toThrow](Err):expect()
		expectAsyncFnRejects(true)[toThrow](Error):expect()
		expectAsyncFnRejects(true)[toThrow]("apple"):expect()
		expectAsyncFnRejects(true)[toThrow](RegExp("app")):expect()

		expectAsyncFnRejects(true).never[toThrow](Err2):expect()
		expectAsyncFnRejects(true).never[toThrow]("banana"):expect()
		expectAsyncFnRejects(true).never[toThrow](RegExp("banana")):expect()

		expectAsyncFnResolves(true, true)[toThrow]():expect()

		expectAsyncFnResolves(false, true).never[toThrow]():expect()
		expectAsyncFnResolves(false, true).never[toThrow](Error):expect()
		expectAsyncFnResolves(false, true).never[toThrow]("apple"):expect()
		expectAsyncFnResolves(false, true).never[toThrow](RegExp("apple")):expect()
		expectAsyncFnResolves(false, true).never[toThrow]("banana"):expect()
		expectAsyncFnResolves(false, true).never[toThrow](RegExp("banana")):expect()
		expectAsyncFnRejects().never[toThrow]():expect()
		expectAsyncFnRejects().never[toThrow](Error):expect()
		expectAsyncFnRejects().never[toThrow]("apple"):expect()
		expectAsyncFnRejects().never[toThrow](RegExp("apple")):expect()
		expectAsyncFnRejects().never[toThrow]("banana"):expect()
		expectAsyncFnRejects().never[toThrow](RegExp("banana")):expect()
		-- Works with nested functions inside promises
		local function throwError()
			error(Error.new())
		end
		jestExpect(Promise.reject(throwError)).rejects[toThrow]():expect()
		local function noop() end
		jestExpect(Promise.reject(noop)).rejects.never[toThrow]():expect()
	end
	test(promisePrefix .. "passes", Promise.promisify(passesTest))
	local function didNotThrowAtAll()
		return expect(expectAsyncFnRejects()[toThrow]()).rejects.toThrowErrorMatchingSnapshot()
	end
	test(promisePrefix .. "did not throw at all", Promise.promisify(didNotThrowAtAll))
	local function threwButClassDidNotMatch()
		expect(expectAsyncFnRejects(true)[toThrow](Err2)).rejects.toThrowErrorMatchingSnapshot():expect()
	end
	test(promisePrefix .. "threw, but class did not match", Promise.promisify(threwButClassDidNotMatch))
	local function threwButShouldNotHave()
		expect(expectAsyncFnRejects(true).never[toThrow]()).rejects.toThrowErrorMatchingSnapshot():expect()
	end
	test(promisePrefix .. "threw, but should not have", Promise.promisify(threwButShouldNotHave))
	-- end)

	describe(prefix .. "expected is undefined", function()
		it("threw, but should not have (non-error falsey)", function()
			expect(function()
				jestExpect(createFn(error, nil)).never[toThrow]()
			end).toThrowErrorMatchingSnapshot()
		end)
	end)

	it(prefix .. "invalid arguments", function()
		expect(function()
			jestExpect(function() end).never[toThrow](111)
		end).toThrowErrorMatchingSnapshot()
	end)

	it(prefix .. "invalid actual", function()
		expect(function()
			jestExpect("a string")[toThrow]()
		end).toThrowErrorMatchingSnapshot()
	end)
	-- end)
end
