-- ROBLOX NOTE: no upstream

return function()
	local CurrentModule = script.Parent
	local SrcModule = CurrentModule.Parent
	local Packages = SrcModule.Parent

	local jestExpect = require(Packages.Dev.Expect)

	local replacePathSepForGlob = require(SrcModule.replacePathSepForGlob)

	describe("replacePathSepForGlob", function()
		it("should execute without error", function()
			jestExpect(replacePathSepForGlob).toBeDefined()
			jestExpect(replacePathSepForGlob).toEqual({})
		end)
	end)
end
