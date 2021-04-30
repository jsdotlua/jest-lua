local Workspace = script
local Modules = Workspace.Parent

local JestMock = require(Modules.JestMock)
local JestFakeTimers = require(Modules.JestFakeTimers)

local jest = JestMock.new()

local fakeTimers = JestFakeTimers.new()
-- ROBLOX TODO: uncomment and fix this for ADO-1461
-- local mock = JestMock.new()

-- return {
-- 	-- Mock functions
-- 	fn = function() return mock:fn() end,
--  clearAllMocks = function() return mock:clearAllMocks() end,
-- 	resetAllMocks = function() return mock:resetAllMocks() end,
--  _jestMock = mock,
-- 	-- Mock timers
-- 	useFakeTimers = function() return fakeTimers:useFakeTimers() end,
-- 	useRealTimers = function() return fakeTimers:useRealTimers() end,
-- 	runAllTicks = function() return fakeTimers:runAllTicks() end,
-- 	runAllTimers = function() return fakeTimers:runAllTimers() end,
-- 	advanceTimersByTime = function(msToRun) fakeTimers:advanceTimersByTime(msToRun) end,
-- 	runTimersToTime = function(msToRun) fakeTimers:advanceTimersByTime(msToRun) end,
-- 	runOnlyPendingTimers = function() fakeTimers:runOnlyPendingTimers() end,
-- 	advanceTimerstoNextTimer = function(steps) fakeTimers:advanceTimerstoNextTimer(steps) end,
-- 	clearAllTimers = function() fakeTimers:clearAllTimers() end,
-- 	getTimerCount = function() fakeTimers:getTimerCount() end,
-- 	setSystemTime = function(now) fakeTimers:setSystemTime(now) end,
-- 	getRealSystemTime = function() fakeTimers:getRealSystemTime() end,
--  testEnv = fakeTimers.testEnv,
--  _fakeTimers = fakeTimers
-- }

-- ROBLOX TODO: putting require override here for now
-- ROBLOX TODO: ADO-1475
-- ROBLOX upstream: https://github.com/Roblox/roact-alignment/blob/master/modules/roblox-jest/src/Module/init.lua#L36
local requiredModules: { [ModuleScript]: any } = {}
local requireOverride = function(scriptInstance: ModuleScript): any
	-- This is crucial! We need to have an early out here so that we don't
	-- override requires of ourself; this would result in the module cache
	-- deviating into a bunch of separate ones.
	--
	-- TODO: This is a little janky, so we should find a way to do this that's a
	-- little more robust. We may want to apply it to anything in RobloxJest?
	if scriptInstance == script or scriptInstance == script.Parent then
		return require(scriptInstance)
	end

	-- If already loaded and cached, return cached module. This should behave
	-- similarly to normal `require` behavior
	if requiredModules[scriptInstance] ~= nil then
		return requiredModules[scriptInstance]
	end

	local moduleResult

	-- Narrowing this type here lets us appease the type checker while still
	-- counting on types for the rest of this file
	local loadmodule: (ModuleScript) -> (any, string) = debug["loadmodule"]
	local moduleFunction, errorMessage = loadmodule(scriptInstance)
	assert(moduleFunction ~= nil, errorMessage)

	getfenv(moduleFunction).require = requireOverride
	getfenv(moduleFunction).delay = fakeTimers.delayOverride
	getfenv(moduleFunction).tick = fakeTimers.tickOverride
	getfenv(moduleFunction).DateTime = fakeTimers.dateTimeOverride
	getfenv(moduleFunction).os = fakeTimers.osOverride
	moduleResult = moduleFunction()

	if moduleResult == nil then
		error(string.format(
			"[Module Error]: %s did not return a valid result\n" ..
			"\tModuleScripts must return a non-nil value",
			tostring(scriptInstance)
		))
	end

	-- Load normally into the require cache
	requiredModules[scriptInstance] = moduleResult

	return moduleResult
end

return {
	jest = jest,
	_fakeTimers = fakeTimers,
	testEnv = {
		delay = fakeTimers.delayOverride,
		tick = fakeTimers.tickOverride,
		DateTime = fakeTimers.dateTimeOverride,
		os = fakeTimers.osOverride,
		-- require = requireOverride,
	}
}