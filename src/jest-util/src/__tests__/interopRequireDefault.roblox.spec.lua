-- ROBLOX NOTE: no upstream

return function()
	local CurrentModule = script.Parent
	local SrcModule = CurrentModule.Parent
	local Packages = SrcModule.Parent

	local jestExpect = require(Packages.Dev.Expect)

	local interopRequireDefault = require(SrcModule.interopRequireDefault)

	describe("interopRequireDefault", function()
		it("should execute without error", function()
			jestExpect(interopRequireDefault).toBeDefined()
			jestExpect(interopRequireDefault).toEqual({})
		end)
	end)
end
