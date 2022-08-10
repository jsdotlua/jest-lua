-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local interopRequireDefault = require(SrcModule.interopRequireDefault)

describe("interopRequireDefault", function()
	it("should execute without error", function()
		jestExpect(interopRequireDefault).toBeDefined()
		jestExpect(interopRequireDefault).toEqual({})
	end)
end)

return {}
