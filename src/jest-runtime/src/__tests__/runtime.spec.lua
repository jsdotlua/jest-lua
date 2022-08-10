-- ROBLOX NOTE: no upstream

return (function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	type Function = (...any) -> ...any

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local describe = (JestGlobals.describe :: any) :: Function
	local it = (JestGlobals.it :: any) :: Function
	local beforeAll = (JestGlobals.beforeAll :: any) :: Function
	local afterAll = (JestGlobals.afterAll :: any) :: Function

	local JestRuntime = require(CurrentModule)
	-- ROBLOX TODO: using RuntimePrivate type until better approach is found
	type JestRuntime = JestRuntime.RuntimePrivate
	type Jest = JestRuntime.Jest

	local _runtime: JestRuntime?

	local function getRuntime(): JestRuntime
		assert(_runtime)
		return _runtime
	end

	local requireOverride = function(scriptInstance: ModuleScript)
		return getRuntime():requireModuleOrMock(scriptInstance)
	end

	beforeAll(function()
		_runtime = JestRuntime.new()
	end)

	afterAll(function()
		getRuntime():teardown()
		_runtime = nil
	end)

	describe("JestRuntime", function()
		it("requireModuleOrMock loads a module and caches it", function()
			local testFile1 = requireOverride(script.Parent.runtimeTestFile)
			local testFile2 = requireOverride(script.Parent.runtimeTestFile)
			jestExpect(testFile1).toBe(testFile2)
		end)

		it("isolateModules returns a new module instance", function()
			local testFile1 = requireOverride(script.Parent.runtimeTestFile)
			local testFile2
			getRuntime():isolateModules(function()
				testFile2 = requireOverride(script.Parent.runtimeTestFile)
			end)
			local LuauPolyfill3 = requireOverride(script.Parent.runtimeTestFile)
			jestExpect(testFile1).never.toBe(testFile2)
			jestExpect(testFile1).toBe(LuauPolyfill3)
			jestExpect(testFile2).never.toBe(LuauPolyfill3)
		end)

		it("separate isolateModules calls return different module instances", function()
			local testFile1
			local testFile2
			getRuntime():isolateModules(function()
				testFile1 = requireOverride(script.Parent.runtimeTestFile)
			end)
			getRuntime():isolateModules(function()
				testFile2 = requireOverride(script.Parent.runtimeTestFile)
			end)
			jestExpect(testFile1).never.toBe(testFile2)
		end)
	end)

	return {}
end)()
