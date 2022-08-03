--!nocheck
-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)

local describe = JestGlobals.describe
local it = JestGlobals.it
local jestExpect = JestGlobals.expect

describe("tmp test 2", function()
	it("pass empty test", function() end)

	it("pass expectation", function()
		jestExpect(1).toEqual(1)
	end)

	it("should wait for promise to resolve", function(_ctx, done)
		task.delay(0.2, function()
			done()
		end)
	end)
end)

return {}
