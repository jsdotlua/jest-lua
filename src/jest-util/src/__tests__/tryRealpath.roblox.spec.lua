-- ROBLOX NOTE: no upstream

return function()
	local CurrentModule = script.Parent
	local SrcModule = CurrentModule.Parent
	local Packages = SrcModule.Parent

	local jestExpect = require(Packages.Dev.Expect)

	local tryRealpath = require(SrcModule.tryRealpath)

	describe("tryRealpath", function()
		it("should execute without error", function()
			jestExpect(tryRealpath).toBeDefined()
			jestExpect(tryRealpath).toEqual({})
		end)
	end)
end
