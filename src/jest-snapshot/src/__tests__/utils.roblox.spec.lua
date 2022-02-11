-- ROBLOX NOTE: no upstream

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local jestExpect = require(Packages.Dev.Expect)

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
				getParent(
					"/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__/snapshot.snap.lua",
					1
				)
			).toEqual("/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__")
		end)

		it("gets grandparent directory", function()
			jestExpect(
				getParent(
					"/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__/snapshot.snap.lua",
					2
				)
			).toEqual("/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__")
		end)
	end)
end
