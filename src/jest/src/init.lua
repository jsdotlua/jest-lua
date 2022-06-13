-- ROBLOX NOTE: no upstream

local CurrentModule = script
local Packages = CurrentModule.Parent

local Runtime = require(Packages.JestRuntime)

local runtime = Runtime.new()
-- ROBLOX TODO: remove when we don't need to manually inject fake timers into tests
local fakeTimers = runtime._jestObject.jestTimers

local jest = {
	testEnv = {
		delay = fakeTimers.delayOverride,
		tick = fakeTimers.tickOverride,
		DateTime = fakeTimers.dateTimeOverride,
		os = fakeTimers.osOverride,
		require = function(scriptInstance: ModuleScript)
			return runtime:requireModuleOrMock(scriptInstance)
		end,
	},
	runtime = runtime,
}

return jest
