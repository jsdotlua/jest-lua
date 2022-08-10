-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = (JestGlobals.describe :: any) :: Function
local it = (JestGlobals.it :: any) :: Function
local requireOrImportModule = require(SrcModule.requireOrImportModule)

describe("requireOrImportModule", function()
	it("should execute without error", function()
		jestExpect(requireOrImportModule).toBeDefined()
		jestExpect(requireOrImportModule).toEqual({})
	end)
end)

return {}
