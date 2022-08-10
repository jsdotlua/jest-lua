-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local tryRealpath = require(SrcModule.tryRealpath)

describe("tryRealpath", function()
	it("should execute without error", function()
		jestExpect(tryRealpath).toBeDefined()
		jestExpect(tryRealpath).toEqual({})
	end)
end)

return {}
