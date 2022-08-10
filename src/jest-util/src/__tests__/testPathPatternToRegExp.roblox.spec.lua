-- ROBLOX NOTE: no upstream

return (function()
	local CurrentModule = script.Parent
	local SrcModule = CurrentModule.Parent
	local Packages = SrcModule.Parent

	type Function = (...any) -> ...any

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local describe = (JestGlobals.describe :: any) :: Function
	local it = (JestGlobals.it :: any) :: Function

	local testPathPatternToRegExp = require(SrcModule.testPathPatternToRegExp)

	describe("testPathPatternToRegExp", function()
		it("should execute without error", function()
			jestExpect(testPathPatternToRegExp).toBeDefined()
			jestExpect(typeof(testPathPatternToRegExp.default)).toEqual("function")
		end)
	end)

	return {}
end)()
