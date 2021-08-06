local CurrentModule = script.Parent.Parent
local Modules = CurrentModule.Parent

local jestExpect = require(Modules.Expect)

local splitPath = require(CurrentModule.utils).robloxSplitPath

return function()
	describe("splitPath", function()
		it("works on Unix paths", function()
			jestExpect(splitPath(
				"/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__/snapshot.snap.lua"
			)).toEqual(
				{
					"Users",
					"rng",
					"jest-roblox",
					"src",
					"Submodules",
					"expect",
					"src",
					"__tests__",
					"__snapshots__",
					"snapshot.snap.lua"
				}
			)
		end)

		it("works on Windows paths", function()
			jestExpect(splitPath(
				"C:\\Users\\Raymond\\jest-roblox\\src\\Submodules\\expect\\src\\__tests__\\__snapshots__\\snapshot.snap.lua"
			)).toEqual(
				{
					"C:",
					"Users",
					"Raymond",
					"jest-roblox",
					"src",
					"Submodules",
					"expect",
					"src",
					"__tests__",
					"__snapshots__",
					"snapshot.snap.lua"
				}
			)
		end)

		it("gets parent directory", function()
			jestExpect(splitPath(
				"/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__/snapshot.snap.lua", 1
			)).toEqual(
				{
					"Users",
					"rng",
					"jest-roblox",
					"src",
					"Submodules",
					"expect",
					"src",
					"__tests__",
					"__snapshots__"
				}
			)
		end)

		it("gets grandparent directory", function()
			jestExpect(splitPath(
				"/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__/snapshot.snap.lua", 2
			)).toEqual(
				{
					"Users",
					"rng",
					"jest-roblox",
					"src",
					"Submodules",
					"expect",
					"src",
					"__tests__"
				}
			)
		end)
	end)
end