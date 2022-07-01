--!nocheck
-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)

local describe = JestGlobals.describe
local it = JestGlobals.it
local jestExpect = JestGlobals.expect

--[[
	ROBLOX FIXME Luau:
	describe and it are an intersection of callable table with additional props.
	Luau doesn't recognise that as a callable object.
	Eg types for `describe`:

		export type DescribeBase = typeof(setmetatable({} :: { each: Each<BlockFn> }, {
			__call = function(_, blockName: BlockName, blockFn: BlockFn): () end,
		}))
		export type Describe = DescribeBase & { only: DescribeBase, skip: DescribeBase }
]]
describe("tmp test", function()
	it("pass empty test", function() end)

	it("pass expectation", function()
		jestExpect(1).toEqual(1)
	end)

	it("should wait for promise to resolve", function(_, done)
		task.delay(2, function()
			done()
		end)
	end)
end)

return {}
