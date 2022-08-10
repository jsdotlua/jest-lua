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

	local replacePathSepForGlob = require(SrcModule.replacePathSepForGlob)

	describe("replacePathSepForGlob", function()
		it("should execute without error", function()
			jestExpect(replacePathSepForGlob).toBeDefined()
			jestExpect(replacePathSepForGlob).toEqual({})
		end)
	end)

	return {}
end)()
