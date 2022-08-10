-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local getParent = require(CurrentModule.utils).robloxGetParent

describe("getParent", function()
	it("works on Unix paths", function()
		jestExpect(
			getParent("/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__/snapshot.snap.lua")
		).toEqual("/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__/snapshot.snap.lua")
	end)

	it("works on Windows paths", function()
		jestExpect(
			getParent(
				"C:\\Users\\Raymond\\jest-roblox\\src\\Submodules\\expect\\src\\__tests__\\__snapshots__\\snapshot.snap.lua"
			)
		).toEqual(
			"C:\\Users\\Raymond\\jest-roblox\\src\\Submodules\\expect\\src\\__tests__\\__snapshots__\\snapshot.snap.lua"
		)
	end)

	it("gets parent directory", function()
		jestExpect(
			getParent("/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__/snapshot.snap.lua", 1)
		).toEqual("/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__")
	end)

	it("gets grandparent directory", function()
		jestExpect(
			getParent("/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__/snapshot.snap.lua", 2)
		).toEqual("/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__")
	end)
end)

return {}
