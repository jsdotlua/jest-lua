-- ROBLOX NOTE: no upstream

return function()
	local CurrentModule = script.Parent
	local SrcModule = CurrentModule.Parent
	local Packages = SrcModule.Parent

	local jestExpect = require(Packages.Dev.JestGlobals).expect

	local testPathPatternToRegExp = require(SrcModule.testPathPatternToRegExp)

	describe("testPathPatternToRegExp", function()
		it("should execute without error", function()
			jestExpect(testPathPatternToRegExp).toBeDefined()
			jestExpect(testPathPatternToRegExp).toEqual({})
		end)
	end)
end
