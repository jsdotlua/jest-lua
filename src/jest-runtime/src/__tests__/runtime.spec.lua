-- ROBLOX NOTE: no upstream

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent
	local JestRuntime = require(CurrentModule)
	type Jest = JestRuntime.Jest

	local runtime = JestRuntime.new()

	local requireOverride = function(scriptInstance: ModuleScript)
		return runtime:requireModuleOrMock(scriptInstance)
	end

	local jestGlobals = requireOverride(Packages.JestGlobals)
	local jestExpect = jestGlobals.expect
	-- not sure how to work this require overrides out for typechecker
	-- define Jest in JestGlobals package maybe and type the init table?
	local jest = (jestGlobals.jest :: any) :: Jest

	describe("JestRuntime", function()
		it("requireModuleOrMock loads a module and caches it", function()
			local LuauPolyfill1 = requireOverride(Packages.LuauPolyfill)
			local LuauPolyfill2 = requireOverride(Packages.LuauPolyfill)
			jestExpect(LuauPolyfill1).toBe(LuauPolyfill2)
		end)

		it("isolateModules returns a new module instance", function()
			local LuauPolyfill1 = requireOverride(Packages.LuauPolyfill)
			local LuauPolyfill2
			jest.isolateModules(function()
				LuauPolyfill2 = requireOverride(Packages.LuauPolyfill)
			end)
			local LuauPolyfill3 = requireOverride(Packages.LuauPolyfill)
			jestExpect(LuauPolyfill1).never.toBe(LuauPolyfill2)
			jestExpect(LuauPolyfill1).toBe(LuauPolyfill3)
			jestExpect(LuauPolyfill2).never.toBe(LuauPolyfill3)
		end)

		it("separate isolateModules calls return different module instances", function()
			local LuauPolyfill1
			local LuauPolyfill2
			jest.isolateModules(function()
				LuauPolyfill1 = requireOverride(Packages.LuauPolyfill)
			end)
			jest.isolateModules(function()
				LuauPolyfill2 = requireOverride(Packages.LuauPolyfill)
			end)
			jestExpect(LuauPolyfill1).never.toBe(LuauPolyfill2)
		end)
	end)
end
