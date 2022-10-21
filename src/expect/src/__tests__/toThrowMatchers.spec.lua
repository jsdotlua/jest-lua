-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/expect/src/__tests__/toThrowMatchers.test.ts

-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local test = JestGlobals.test
local beforeAll = JestGlobals.beforeAll
local jestExpect = require(script.Parent.Parent)

local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local extends = LuauPolyfill.extends

local Promise = require(Packages.Promise)
local RegExp = require(Packages.RegExp)

local alignedAnsiStyleSerializer = require(Packages.Dev.TestUtils).alignedAnsiStyleSerializer

beforeAll(function()
	expect.addSnapshotSerializer(alignedAnsiStyleSerializer)
end)

local CustomError = extends(Error, "CustomError", function(self, message)
	self.message = message
	self.name = "Error"
	self.stack = "  at expect" .. " (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)"
end)

local matchers = { "toThrowError", "toThrow" }

for _, toThrow in ipairs(matchers) do
	describe(toThrow, function()
		local Err = extends(CustomError, "Err", function(self, message)
			self.name = "Error"
			self.message = message
			self.stack = "  at expect" .. " (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)"
		end)
		local Err2 = extends(CustomError, "Err2", function(self, message)
			self.name = "Error"
			self.message = message
			self.stack = "  at expect" .. " (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)"
		end)

		it("to throw or not to throw", function()
			expect(function()
				error(CustomError("apple"))
			end)[toThrow]()
			expect(function() end).never[toThrow]()
		end)

		describe("substring", function()
			it("passes", function()
				expect(function()
					error(CustomError("apple"))
				end)[toThrow]("apple")
				expect(function()
					error(CustomError("banana"))
				end).never[toThrow]("apple")
			end)

			it("did not throw at all", function()
				expect(function()
					expect(function() end)[toThrow]("apple")
				end).toThrowErrorMatchingSnapshot()
			end)

			it("threw, but message did not match (error)", function()
				expect(function()
					expect(function()
						error(CustomError("apple"))
					end)[toThrow]("banana")
				end).toThrowErrorMatchingSnapshot()
			end)

			it("threw, but message did not match (non-error falsey)", function()
				expect(function()
					expect(function()
						error("")
					end)[toThrow]("Server Error")
				end).toThrowErrorMatchingSnapshot()
			end)

			it("properly escapes strings when matching against errors", function()
				expect(function()
					error(Error('"this"? throws.'))
				end)[toThrow]('"this"? throws.')
			end)

			it("threw, but message should not match (error)", function()
				expect(function()
					expect(function()
						error(CustomError("Invalid array length"))
					end).never[toThrow]("array")
				end).toThrowErrorMatchingSnapshot()
			end)

			it("threw, but message should not match (non-error truthy)", function()
				expect(function()
					expect(function()
						error("Internal Server Error")
					end).never[toThrow]("Server Error")
				end).toThrowErrorMatchingSnapshot()
			end)
		end)

		describe("regexp", function()
			it("passes", function()
				expect(function()
					error(CustomError("apple"))
				end)[toThrow](RegExp("apple"))
				expect(function()
					error(CustomError("banana"))
				end).never[toThrow](RegExp("apple"))
				expect(function() end).never[toThrow](RegExp("apple"))
			end)

			it("did not throw at all", function()
				expect(function()
					expect(function() end)[toThrow](RegExp("apple"))
				end).toThrowErrorMatchingSnapshot()
			end)

			it("threw, but message did not match (error)", function()
				expect(function()
					expect(function()
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
					expect(function()
						error(0)
					end)[toThrow](RegExp("^[123456789]\\d*"))
				end).toThrowErrorMatchingSnapshot()
			end)

			it("threw, but message should not match (error)", function()
				expect(function()
					expect(function()
						error(CustomError("Invalid array length"))
					end).never[toThrow](RegExp(" array "))
				end).toThrowErrorMatchingSnapshot()
			end)

			-- ROBLOX deviation: the following test prints "404" instead of 404 in
			-- the output for the same reason as above
			it("threw, but message should not match (non-error truthy)", function()
				expect(function()
					expect(function()
						error(404)
					end).never[toThrow](RegExp("^[123456789]\\d*"))
				end).toThrowErrorMatchingSnapshot()
			end)
		end)

		describe("error class", function()
			local SubErr = extends(Err, "SubErr", function(self, message)
				self.message = message
				self.name = "SubErr"
				self.stack = "  at expect" .. " (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)"
			end)
			local SubSubErr = extends(SubErr, "SubSubErr", function(self, message)
				self.message = message
				self.name = "SubSubErr"
				self.stack = "  at expect" .. " (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)"
			end)

			it("passes", function()
				expect(function()
					error(Err())
				end)[toThrow](Err)
				expect(function()
					error(Err())
				end)[toThrow](CustomError)
				expect(function()
					error(Err())
				end).never[toThrow](Err2)
				expect(function() end).never[toThrow](Err)
			end)

			it("did not throw at all", function()
				expect(function()
					-- FIXME in REVIEW: upstream writes 'expect' but the intention must have been to write expect
					expect(function() end)[toThrow](Err)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("threw, but class did not match (error)", function()
				expect(function()
					expect(function()
						error(Err("apple"))
					end)[toThrow](Err2)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("threw, but class did not match (non-error falsey)", function()
				expect(function()
					expect(function()
						error(nil)
					end)[toThrow](Err2)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("threw, but class should not match (error)", function()
				expect(function()
					expect(function()
						error(Err("apple"))
					end).never[toThrow](Err)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("threw, but class should not match (error subclass)", function()
				expect(function()
					expect(function()
						error(SubErr("apple"))
					end).never[toThrow](Err)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("threw, but class should not match (error subsubclass)", function()
				expect(function()
					expect(function()
						error(SubSubErr("apple"))
					end).never[toThrow](Err)
				end).toThrowErrorMatchingSnapshot()
			end)
		end)

		describe("error-message", function()
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
					expect(function()
						error(ErrorMessage("apple"))
					end)[toThrow](expected)
				end)

				it("isNot true", function()
					expect(function()
						error(ErrorMessage("banana"))
					end).never[toThrow](expected)
				end)
			end)

			describe("fail", function()
				it("isNot false", function()
					expect(function()
						expect(function()
							error(ErrorMessage("banana"))
						end)[toThrow](expected)
					end).toThrowErrorMatchingSnapshot()
				end)

				it("isNot true", function()
					local message = "Invalid array length"
					expect(function()
						expect(function()
							error(ErrorMessage(message))
						end).never[toThrow]({ message = message })
					end).toThrowErrorMatchingSnapshot()
				end)

				it("multiline diff highlight incorrect expected space", function()
					local a = "There is no route defined for key Settings. \nMust be one of: 'Home'"
					local b = "There is no route defined for key Settings.\nMust be one of: 'Home'"
					expect(function()
						expect(function()
							error(ErrorMessage(b))
						end)[toThrow]({ message = a })
					end).toThrowErrorMatchingSnapshot()
				end)
			end)
		end)

		describe("asymmetric", function()
			describe("any-Class", function()
				describe("pass", function()
					it("isNot false", function()
						expect(function()
							error(Err("apple"))
						end)[toThrow](expect.any(Err))
					end)

					it("isNot true", function()
						expect(function()
							error(Err("apple"))
						end).never[toThrow](expect.any(Err2))
					end)
				end)

				describe("fail", function()
					it("isNot false", function()
						expect(function()
							expect(function()
								error(Err("apple"))
							end)[toThrow](expect.any(Err2))
						end).toThrowErrorMatchingSnapshot()
					end)

					it("isNot true", function()
						expect(function()
							expect(function()
								error(Err("apple"))
							end).never[toThrow](expect.any(Err))
						end).toThrowErrorMatchingSnapshot()
					end)
				end)
			end)

			describe("anything", function()
				describe("pass", function()
					it("isNot false", function()
						expect(function()
							error(CustomError("apple"))
						end)[toThrow](expect.anything())
					end)

					-- ROBLOX deviation: skipped test because we have no undefined
					-- type and nil does not match expect.anything()
					it.skip("isNot true", function()
						-- expect(function() end).never[toThrow](expect.anything())
						-- expect(function()
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
							expect(function()
								error(nil)
							end)[toThrow](expect.anything())
						end).toThrowErrorMatchingSnapshot()
					end)

					it("isNot true", function()
						expect(function()
							expect(function()
								error(CustomError("apple"))
							end).never[toThrow](expect.anything())
						end).toThrowErrorMatchingSnapshot()
					end)
				end)
			end)

			describe("no-symbol", function()
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
						expect(function()
							error(CustomError("apple"))
						end)[toThrow](matchError)
					end)

					it("isNot true", function()
						expect(function()
							error(CustomError("apple"))
						end).never[toThrow](matchNotError)
					end)
				end)

				describe("fail", function()
					it("isNot false", function()
						expect(function()
							expect(function()
								error(CustomError("apple"))
							end)[toThrow](matchNotError)
						end).toThrowErrorMatchingSnapshot()
					end)

					it("isNot true", function()
						expect(function()
							expect(function()
								error(CustomError("apple"))
							end).never[toThrow](matchError)
						end).toThrowErrorMatchingSnapshot()
					end)
				end)
			end)

			describe("objectContaining", function()
				local matchError = expect.objectContaining({
					name = "Error",
				})
				local matchNotError = expect.objectContaining({
					name = "NotError",
				})

				describe("pass", function()
					it("isNot false", function()
						expect(function()
							error(CustomError("apple"))
						end)[toThrow](matchError)
					end)

					it("isNot true", function()
						expect(function()
							error(CustomError("apple"))
						end).never[toThrow](matchNotError)
					end)
				end)

				describe("fail", function()
					it("isNot false", function()
						expect(function()
							expect(function()
								error(CustomError("apple"))
							end)[toThrow](matchNotError)
						end).toThrowErrorMatchingSnapshot()
					end)

					it("isNot true", function()
						expect(function()
							expect(function()
								error(CustomError("apple"))
							end).never[toThrow](matchError)
						end).toThrowErrorMatchingSnapshot()
					end)
				end)
			end)
		end)

		describe("promise/async throws if Error-like object is returned", function()
			local function asyncFn(shouldThrow: boolean?, resolve: boolean?)
				return Promise.resolve():andThen(function()
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
				end)
			end
			test("passes", function()
				return Promise.resolve():andThen(function()
					expect.assertions(24)
					jestExpect(Promise.reject(Error.new())).rejects[toThrow]():expect()

					jestExpect(asyncFn(true)).rejects[toThrow]():expect()
					jestExpect(asyncFn(true)).rejects[toThrow](Err):expect()
					jestExpect(asyncFn(true)).rejects[toThrow](Error):expect()
					jestExpect(asyncFn(true)).rejects[toThrow]("apple"):expect()
					jestExpect(asyncFn(true)).rejects[toThrow](RegExp("app")):expect()

					jestExpect(asyncFn(true)).rejects.never[toThrow](Err2):expect()
					jestExpect(asyncFn(true)).rejects.never[toThrow]("banana"):expect()
					jestExpect(asyncFn(true)).rejects.never[toThrow](RegExp("banana")):expect()

					jestExpect(asyncFn(true, true)).resolves[toThrow]():expect()

					jestExpect(asyncFn(false, true)).resolves.never[toThrow]():expect()
					jestExpect(asyncFn(false, true)).resolves.never[toThrow](Error):expect()
					jestExpect(asyncFn(false, true)).resolves.never[toThrow]("apple"):expect()
					jestExpect(asyncFn(false, true)).resolves.never[toThrow](RegExp("apple")):expect()
					jestExpect(asyncFn(false, true)).resolves.never[toThrow]("banana"):expect()
					jestExpect(asyncFn(false, true)).resolves.never[toThrow](RegExp("banana")):expect()
					jestExpect(asyncFn()).rejects.never[toThrow]():expect()
					jestExpect(asyncFn()).rejects.never[toThrow](Error):expect()
					jestExpect(asyncFn()).rejects.never[toThrow]("apple"):expect()
					jestExpect(asyncFn()).rejects.never[toThrow](RegExp("apple")):expect()
					jestExpect(asyncFn()).rejects.never[toThrow]("banana"):expect()
					jestExpect(asyncFn()).rejects.never[toThrow](RegExp("banana")):expect()
					-- Works with nested functions inside promises
					jestExpect(Promise.reject(function()
							error(Error.new())
						end)).rejects
						[toThrow]()
						:expect()
					jestExpect(Promise.reject(function() end)).rejects.never[toThrow]():expect()
				end)
			end)
			test("did not throw at all", function()
				return Promise.resolve():andThen(function()
					return expect(jestExpect(asyncFn()).rejects[toThrow]()).rejects.toThrowErrorMatchingSnapshot()
				end)
			end)
			test("threw, but class did not match", function()
				return Promise.resolve():andThen(function()
					expect(jestExpect(asyncFn(true)).rejects[toThrow](Err2)).rejects
						.toThrowErrorMatchingSnapshot()
						:expect()
				end)
			end)
			test("threw, but should not have", function()
				return Promise.resolve():andThen(function()
					expect(jestExpect(asyncFn(true)).rejects.never[toThrow]()).rejects
						.toThrowErrorMatchingSnapshot()
						:expect()
				end)
			end)
		end)

		describe("expected is undefined", function()
			it("threw, but should not have (non-error falsey)", function()
				expect(function()
					expect(function()
						error(nil)
					end).never[toThrow]()
				end).toThrowErrorMatchingSnapshot()
			end)
		end)

		it("invalid arguments", function()
			expect(function()
				expect(function() end).never[toThrow](111)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("invalid actual", function()
			expect(function()
				expect("a string")[toThrow]()
			end).toThrowErrorMatchingSnapshot()
		end)
	end)
end
