-- ROBLOX NOTE: no upstream

return function()
	describe("Lua toThrowMatcher tests", function()
		local CurrentModule = script.Parent.Parent
		local Packages = CurrentModule.Parent

		local LuauPolyfill = require(Packages.LuauPolyfill)
		local Error = LuauPolyfill.Error
		local extends = LuauPolyfill.extends

		local alignedAnsiStyleSerializer = require(Packages.Dev.TestUtils).alignedAnsiStyleSerializer

		local jestExpect = require(CurrentModule)

		beforeAll(function()
			jestExpect.addSnapshotSerializer(alignedAnsiStyleSerializer)
		end)

		afterAll(function()
			jestExpect.resetSnapshotSerializers()
		end)

		local CustomError = extends(Error, "CustomError", function(self, message)
			self.message = message
			self.name = 'Error'
			self.stack = '  at jestExpect' ..
				' (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)'
		end)

		it("works well for single errors", function()
			jestExpect(function()
				error("I am erroring!")
			end).toThrow("I am erroring!")

			jestExpect(function()
				jestExpect(function()
					error("I am erroring!")
				end).toThrow("I am erroring?")
			end).toThrow()
		end)

		local function error1()
			error(Error(""))
		end

		local function error2()
			error("")
		end

		local function test1()
			error1()
		end

		local function test2()
			error2()
		end

		it("prints the stack trace for Lua Error error", function()
			jestExpect(function()
				jestExpect(function() test1() end).never.toThrow()
			end).toThrowErrorMatchingSnapshot()
		end)

		it("prints the stack trace for Lua string error", function()
			jestExpect(function()
				jestExpect(function() test2() end).never.toThrow()
			end).toThrowErrorMatchingSnapshot()
		end)

		it("prints the stack trace for Lua string error 2", function()
			jestExpect(function()
				jestExpect(function() test2() end).toThrow("wrong information")
			end).toThrowErrorMatchingSnapshot()
		end)

		it("matches Error", function()
			jestExpect(function() error(Error("error msg")) end).toThrow(Error("error msg"))
			jestExpect(function() error(CustomError("error msg")) end).toThrow(CustomError("error msg"))
			jestExpect(function() error(CustomError("error msg")) end).toThrow(Error("error msg"))
			-- this would match in upstream Jest even though it is somewhat nonsensical
			jestExpect(function() error(Error("error msg")) end).toThrow(CustomError("error msg"))
		end)

		it("matches empty Error", function()
			jestExpect(function() error(Error()) end).toThrow(Error())
		end)

		-- ROBLOX deviation: sanity check test case
		it("cleans stack trace and prints correct files", function()
			local function func2()
				-- this line should error
				return (nil :: any) + 1
			end

			-- 2 lines in stack trace
			jestExpect(function()
				jestExpect(function() func2() end).never.toThrow()
			end).toThrowErrorMatchingSnapshot()
		end)

		it("toThrow should fail if expected is a string and thrown message is a table", function()
			jestExpect(function()
				jestExpect(function()
					error({message = {key = "value"}})
				end).toThrow("string")
			end).toThrowErrorMatchingSnapshot()
		end)

		local jest = require(Packages.Dev.Jest)
		it("makes sure that jest.fn() is callable", function()
			local mock = jest.fn()
			jestExpect(mock).never.toThrow()
		end)
	end)
end