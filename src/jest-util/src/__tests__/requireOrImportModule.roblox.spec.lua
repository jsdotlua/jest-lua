-- ROBLOX NOTE: no upstream

return function()
	local CurrentModule = script.Parent
	local SrcModule = CurrentModule.Parent
	local Packages = SrcModule.Parent

	local jestExpect = require(Packages.Dev.Expect)

	local requireOrImportModule = require(SrcModule.requireOrImportModule)

	describe("requireOrImportModule", function()
		it("should execute without error", function()
			jestExpect(requireOrImportModule).toBeDefined()
			jestExpect(requireOrImportModule).toEqual({})
		end)
	end)
end
