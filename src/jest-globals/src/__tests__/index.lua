-- ROBLOX NOTE: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-globals/src/__tests__/index.ts

return (function()
	local Packages = script.Parent.Parent.Parent

	type Function = (...any) -> ...any

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local expect = JestGlobals.expect
	local test = (JestGlobals.test :: any) :: Function

	test("throw when directly imported", function()
		expect(function()
			require(script.Parent.Parent.index)
		end).toThrowError(
			-- ROBLOX deviation STAT: aligned message to make sense for jest-roblox
			"Do not import `JestGlobals` outside of the Jest test environment"
			-- ROBLOX deviation END
		)
	end)

	return {}
end)()
