-- ROBLOX NOTE: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-globals/src/__tests__/index.ts

return (function()
	type Function = (...any) -> ...any

	local JestGlobals = require(script.Parent.Parent)
	local expect = JestGlobals.expect
	local test = JestGlobals.test

	test("throw when directly imported", function()
		expect(function()
			require(script.Parent.Parent.index)
		end).toThrowError(
			-- ROBLOX deviation START: aligned message to make sense for jest-roblox
			"Do not import `JestGlobals` outside of the Jest test environment"
			-- ROBLOX deviation END
		)
	end)

	return {}
end)()
