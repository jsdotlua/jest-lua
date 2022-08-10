-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local replacePathSepForGlob = require(SrcModule.replacePathSepForGlob)

describe("replacePathSepForGlob", function()
	it("should execute without error", function()
		jestExpect(replacePathSepForGlob).toBeDefined()
		jestExpect(replacePathSepForGlob).toEqual({})
	end)
end)

return {}
