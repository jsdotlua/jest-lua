-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local requireOrImportModule = require(SrcModule.requireOrImportModule)

describe("requireOrImportModule", function()
	it("should execute without error", function()
		jestExpect(requireOrImportModule).toBeDefined()
		jestExpect(requireOrImportModule).toEqual({})
	end)
end)

return {}
