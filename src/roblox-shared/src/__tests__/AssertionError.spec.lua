-- ROBLOX note: no upstream

return function()
	local CurrentModule = script.Parent
	local Packages = CurrentModule.Parent.Parent

	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Error = LuauPolyfill.Error

	local AssertionError = require(CurrentModule.Parent.AssertionError).AssertionError

	local jestExpect = require(Packages.Dev.Expect)

	describe("AssertionError", function()
		it("should be an instance of AssertionError", function()
			jestExpect(AssertionError.new({ message = "boom" })).toBeInstanceOf(AssertionError)
		end)

		it("should be an instance of Error", function()
			jestExpect(AssertionError.new({ message = "boom" })).toBeInstanceOf(Error)
		end)

		it("should tostring AssertionError", function()
			jestExpect(tostring(AssertionError.new({ message = "boom" }))).toEqual(
				"AssertionError [ERR_ASSERTION]: boom"
			)
		end)

		it('should construct "strictEqual" assertion message', function()
			jestExpect(tostring(AssertionError.new({
				operator = "strictEqual",
				expected = { foo = "foo" },
				actual = { foo = "foo1" },
			}))).toEqual([[
AssertionError [ERR_ASSERTION]: Expected "actual" to be reference-equal to "expected":
+ actual - expected

+ { foo: "foo1" }
- { foo: "foo" }]])
		end)

		it('should construct "deepStrictEqual" assertion message', function()
			jestExpect(tostring(AssertionError.new({
				operator = "deepStrictEqual",
				expected = { foo = "foo" },
				actual = { foo = "foo1" },
			}))).toEqual([[
AssertionError [ERR_ASSERTION]: Expected values to be strictly deep-equal:
+ actual - expected

+ { foo: "foo1" }
- { foo: "foo" }
             ^]])
		end)

		it('should construct "strictEqualObject" assertion message', function()
			jestExpect(tostring(AssertionError.new({
				operator = "strictEqualObject",
				expected = { foo = "foo" },
				actual = { foo = "foo1" },
			}))).toEqual([[AssertionError [ERR_ASSERTION]: { foo: "foo1" } strictEqualObject { foo: "foo" }]])
		end)

		it('should construct "deepEqual" assertion message', function()
			jestExpect(tostring(AssertionError.new({
				operator = "deepEqual",
				expected = { foo = "foo" },
				actual = { foo = "foo1" },
			}))).toEqual([[
AssertionError [ERR_ASSERTION]: Expected values to be loosely deep-equal:

{ foo: "foo1" }

should loosely deep-equal

{ foo: "foo" }]])
		end)

		it('should construct "notDeepStrictEqual" assertion message', function()
			local val = { foo = "foo" }

			jestExpect(tostring(AssertionError.new({
				operator = "notDeepStrictEqual",
				expected = val,
				actual = val,
			}))).toEqual([[
AssertionError [ERR_ASSERTION]: Expected "actual" not to be strictly deep-equal to:

{ foo: "foo" }]])
		end)

		it('should construct "notStrictEqual" assertion message', function()
			local val = { foo = "foo" }

			jestExpect(tostring(AssertionError.new({
				operator = "notStrictEqual",
				expected = val,
				actual = val,
			}))).toEqual([[
AssertionError [ERR_ASSERTION]: Expected "actual" not to be reference-equal to "expected":

{ foo: "foo" }]])
		end)

		it('should construct "notStrictEqualObject" assertion message', function()
			local val = { foo = "foo" }

			jestExpect(tostring(AssertionError.new({
				operator = "notStrictEqualObject",
				expected = val,
				actual = val,
			}))).toEqual([[AssertionError [ERR_ASSERTION]: { foo: "foo" } notStrictEqualObject { foo: "foo" }]])
		end)

		it('should construct "notDeepEqual" assertion message', function()
			local val = { foo = "foo" }

			jestExpect(tostring(AssertionError.new({
				operator = "notDeepEqual",
				expected = val,
				actual = val,
			}))).toEqual([[
AssertionError [ERR_ASSERTION]: Expected "actual" not to be loosely deep-equal to:

{ foo: "foo" }]])
		end)

		it('should construct "notIdentical" assertion message', function()
			jestExpect(tostring(AssertionError.new({
				operator = "notIdentical",
				expected = { foo = "foo" },
				actual = { foo = "foo" },
			}))).toEqual([[AssertionError [ERR_ASSERTION]: { foo: "foo" } notIdentical { foo: "foo" }]])
		end)

		it('should construct "notDeepEqualUnequal" assertion message', function()
			jestExpect(tostring(AssertionError.new({
				operator = "notDeepEqualUnequal",
				expected = { foo = "foo" },
				actual = { foo = "foo" },
			}))).toEqual([[AssertionError [ERR_ASSERTION]: { foo: "foo" } notDeepEqualUnequal { foo: "foo" }]])
		end)
	end)
end
