-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local jestModule = require(CurrentModule)

describe("Jest", function()
	describe("re-exports JestCore", function()
		it("SearchSource", function()
			expect(jestModule.SearchSource).toBeDefined()
		end)

		it("TestWatcher", function()
			expect(jestModule.TestWatcher).toBeDefined()
		end)

		it("createTestScheduler", function()
			expect(jestModule.createTestScheduler).toBeDefined()
		end)

		-- ROBLOX NOTE: not ported
		it.skip("getVersion", function()
			-- expect(jestModule.getVersion).toBeDefined()
		end)

		it("runCLI", function()
			expect(jestModule.runCLI).toBeDefined()
		end)
	end)
end)

return {}
