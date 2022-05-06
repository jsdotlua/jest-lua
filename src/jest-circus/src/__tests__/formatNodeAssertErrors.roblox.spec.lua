-- ROBLOX NOTE: no upstream

return function()
	local CurrentModule = script.Parent
	local SrcModule = CurrentModule.Parent
	local Packages = SrcModule.Parent

	local typesModule = require(Packages.JestTypes)
	type Circus_TestEntry = typesModule.Circus_TestEntry

	local AssertionError = require(Packages.RobloxShared).AssertionError

	local jestExpect = require(Packages.Expect)

	local formatNodeAssertErrors = require(SrcModule.formatNodeAssertErrors).default

	describe("formatNodeAssertErrors", function()
		it("should format AssertionError with message", function()
			local assertionError = AssertionError.new({ message = "kaboom" })
			local test: Circus_TestEntry = {
				type = "test",
				asyncError = nil,
				errors = { assertionError },
				fn = function() end,
				invocations = 0,
				mode = nil,
				name = "test name",
				parent = {} :: any,
				seenDone = false,
			}
			formatNodeAssertErrors(nil, {
				name = "test_done",
				test = test,
			}, { expand = false } :: any)
			jestExpect(test.errors).toMatchSnapshot()
		end)

		local firstVal = { foo = "foo" }
		local secondVal = { foo = "fooBar" }
		local cases = {
			{
				operator = "strictEqual",
				expected = firstVal,
				actual = secondVal,
			},
			{
				operator = "deepStrictEqual",
				expected = firstVal,
				actual = secondVal,
			},
			{
				operator = "strictEqualObject",
				expected = firstVal,
				actual = secondVal,
			},
			{
				operator = "deepEqual",
				expected = firstVal,
				actual = secondVal,
			},
			{
				operator = "notDeepStrictEqual",
				expected = firstVal,
				actual = firstVal,
			},
			{
				operator = "notStrictEqual",
				expected = firstVal,
				actual = firstVal,
			},
			{
				operator = "notStrictEqualObject",
				expected = firstVal,
				actual = firstVal,
			},
			{
				operator = "notDeepEqual",
				expected = firstVal,
				actual = firstVal,
			},
			{
				operator = "notIdentical",
				expected = firstVal,
				actual = firstVal,
			},
			{
				operator = "notDeepEqualUnequal",
				expected = firstVal,
				actual = firstVal,
			},
		}

		for _, case in ipairs(cases) do
			it("should format AssertionError with operator: " .. case.operator, function()
				local assertionError = AssertionError.new(case)
				local test: Circus_TestEntry = {
					type = "test",
					asyncError = nil,
					errors = { assertionError },
					fn = function() end,
					invocations = 0,
					mode = nil,
					name = "test name",
					parent = {} :: any,
					seenDone = false,
				}
				formatNodeAssertErrors(nil, {
					name = "test_done",
					test = test,
				}, { expand = false } :: any)
				jestExpect(test.errors).toMatchSnapshot()
			end)
		end
	end)
end
