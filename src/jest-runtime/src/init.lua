-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

type unknown = any

local Packages = script.Parent

local typesModule = require(script.types)
export type Jest = typesModule.Jest
type MockFactory = typesModule.MockFactory

local jestSnapshot = require(Packages.JestSnapshot)
local jestExpect = require(Packages.Expect)
type Expect = jestExpect.Expect
local JestFakeTimers = require(Packages.JestFakeTimers)
type FakeTimers = JestFakeTimers.FakeTimers

local LuauPolyfill = require(Packages.LuauPolyfill)
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local setTimeout = LuauPolyfill.setTimeout
type Map<T, U> = LuauPolyfill.Map<T, U>
type Array<T> = LuauPolyfill.Array<T>

local moduleMockerModule = require(Packages.JestMock)
local ModuleMocker = moduleMockerModule.ModuleMocker
type ModuleMocker = moduleMockerModule.ModuleMocker

local jestTypesModule = require(Packages.JestTypes)
type Config_Path = jestTypesModule.Config_Path
-- ROBLOX TODO: not implemented yet
-- type Global_TestFrameworkGlobals = jestTypesModule.Global_TestFrameworkGlobals

type JestGlobals = {
	expect: any,
	jestSnapshot: {
		toMatchSnapshot: (...any) -> any,
		toThrowErrorMatchingSnapshot: (...any) -> any,
	},
}

type JestGlobalsWithJest = JestGlobals & {
	jest: Jest,
}

export type Runtime = {
	jestGlobals: JestGlobals?,
	-- ROBLOX TODO: not implemented yet
	-- setGlobalsForRuntime: (self: Runtime, globals: JestGlobals) -> (),
	getGlobalsFromEnvironment: (self: Runtime) -> JestGlobals,
	-- ROBLOX TODO: not implemented yet
	-- teardown: (self: Runtime) -> (),
	requireModuleOrMock: (self: Runtime, scriptInstance: ModuleScript) -> any,
	-- ROBLOX TODO: not implemented yet
	-- requireMock: (self: Runtime, from: Config_Path, scriptInstance: ModuleScript) -> any,
	requireModule: (
		self: Runtime,
		from: string,
		scriptInstance: ModuleScript,
		options: any?,
		isRequireActual: boolean
	) -> any,
	isolateModules: (self: Runtime, fn: MockFactory) -> (),
	clearAllMocks: (self: Runtime) -> (),
	resetAllMocks: (self: Runtime) -> (),
	restoreAllMocks: (self: Runtime) -> (),
	-- ROBLOX TODO START: not implemented yet
	-- setMock: (
	-- 	self: Runtime,
	-- 	from: string,
	-- 	scriptInstance: ModuleScript,
	-- 	mockFactory: MockFactory,
	-- 	options: ({ virtual: boolean? })?
	-- ) -> any,
	-- _generateMock: (self: Runtime, from: Config_Path, scriptInstance: ModuleScript) -> unknown,
	-- ROBLOX TODO END
	_createJestObjectFor: (self: Runtime, from: Config_Path) -> Jest,
}

type RuntimePrivate = Runtime & {
	_moduleMocker: ModuleMocker,
	_fakeTimersImplementation: FakeTimers,
	_environment: {
		fakeTimersModern: boolean,
	},
	_jestObject: Jest,
	_cleanupFns: Array<() -> ()>,
	-- ROBLOX TODO START: not implemented yet
	-- _explicitShouldMock: Map<ModuleScript, boolean>,
	-- _mockMetaDataCache: Map<string, unknown>,
	-- _mockFactories: Map<ModuleScript, any>,
	-- ROBLOX TODO END
	_moduleRegistry: Map<ModuleScript, any>,
	-- ROBLOX TODO: not implemented yet
	-- _mockRegistry: Map<ModuleScript, any>,
	_isolatedModuleRegistry: Map<ModuleScript, any>?,
	_isolatedMockRegistry: Map<ModuleScript, any>?,
	-- ROBLOX TODO: not implemented yet
	-- _shouldAutoMock: boolean,
	_shouldMock: (
		from: string,
		scriptInstance: ModuleScript,
		explicitShouldMock: Map<ModuleScript, boolean>,
		options: any --[[ ResolveModuleConfig ]]
	) -> boolean,
}

local Runtime = {}
Runtime.__index = Runtime

function Runtime.new(): Runtime
	local self = setmetatable(({} :: any) :: RuntimePrivate, Runtime)

	self.jestGlobals = nil
	self._fakeTimersImplementation = JestFakeTimers.new()

	-- ROBLOX DEVIATION start: There's no actual Jest Environment so we are just
	-- mocking some values in here for now.
	self._environment = {
		fakeTimersModern = true,
	}
	-- ROBLOX DEVIATION end

	-- ROBLOX DEVIATION start: instantiate the module mocker here
	-- instead of being passed in as an arg from runTest
	self._moduleMocker = ModuleMocker.new()
	-- ROBLOX DEVIATION end

	-- ROBLOX DEVIATION start: normally a jest object gets created for each
	-- test file and inserted into a cache, an instance gets injected into each
	-- test module. Currently this implementation is global across all tests.
	self._jestObject = self:_createJestObjectFor("global")
	-- ROBLOX DEVIATION end

	-- ROBLOX DEVIATION start: added to hold references to all the clean up
	-- functions from loaded modules. Will be used in Runtime.teardown
	self._cleanupFns = {}
	-- ROBLOX DEVIATION end

	-- ROBLOX TODO START: not implemented yet
	-- self._explicitShouldMock = Map.new()
	-- self._mockMetaDataCache = Map.new()
	-- self._mockFactories = Map.new()
	-- self._mockRegistry = Map.new()
	-- ROBLOX TODO END
	self._moduleRegistry = Map.new()
	self._isolatedModuleRegistry = nil
	-- ROBLOX TODO START: not implemented yet
	-- self._isolatedMockRegistry = nil
	-- self._shouldAutoMock = true
	-- ROBLOX TODO END

	return (self :: any) :: Runtime
end

-- ROBLOX NOTE: Need to figure out where to plug in teardown
-- ROBLOX TODO START: not implemented yet
-- function Runtime:teardown(): ()
-- 	self.restoreAllMocks()
-- 	self.resetAllMocks()
-- 	self.resetModules()

-- 	-- ROBLOX DEVIATION start: call all the cleanup functions returned from loadmodule
-- 	for _, fn in ipairs(self.cleanupFns) do
-- 		fn()
-- 	end
-- 	-- ROBLOX DEVIATION end

-- 	self._explicitShouldMock:clear()
-- 	self._mockMetaDataCache:clear()
-- 	self._mockFactories:clear()
-- 	self._mockRegistry:clear()
-- 	self._moduleRegistry:clear()
-- 	self._isolatedModuleRegistry = nil
-- 	self._isolatedMockRegistry = nil
-- end

-- ROBLOX NOTE: Used in jestAdapter + jestAdapterInit in real jest
-- function Runtime:setGlobalsForRuntime(globals: JestGlobals): ()
-- 	self.jestGlobals = globals
-- end
-- ROBLOX TODO END

function Runtime:getGlobalsFromEnvironment(): JestGlobals
	if self.jestGlobals then
		return table.clone(self.jestGlobals)
	end

	return {
		expect = jestExpect,
		jestSnapshot = {
			toMatchSnapshot = jestSnapshot.toMatchSnapshot,
			toThrowErrorMatchingSnapshot = jestSnapshot.toThrowErrorMatchingSnapshot,
		},
	}
end

function Runtime:requireModuleOrMock(scriptInstance: ModuleScript)
	local from = ""

	if scriptInstance == script or scriptInstance == script.Parent then
		-- ROBLOX NOTE: Need to cast require because analyze cannot figure out
		-- scriptInstance path
		return (require :: any)(scriptInstance)
	end

	if scriptInstance.Name == "JestGlobals" then
		-- ROBLOX DEVIATION start: We don't have to worry about two different
		-- module systems so I'm leaving out getGlobalsForCjs + getGlobalsForEsm
		local globals = self:getGlobalsFromEnvironment()
		return Object.assign(globals, {
			jest = self._jestObject,
		}) :: JestGlobalsWithJest
		-- ROBLOX DEVIATION end
	end

	--[[ ROBLOX COMMENT: try-catch block conversion ]]
	local ok, result = xpcall(function()
		if self:_shouldMock(from, scriptInstance, self._explicitShouldMock, {
			conditions = nil,
		}) then
			error("mocking is not implemented in JestRuntime yet")
			-- return self:requireMock(from, scriptInstance)
		else
			return self:requireModule(from, scriptInstance)
		end
	end, function(e: unknown)
		error(e)
	end)
	if ok and result ~= nil then
		return result
	end

	-- for typechecker
	return {}
end

-- ROBLOX TODO START: not implemented yet
-- function Runtime:requireMock(from: Config_Path, scriptInstance: ModuleScript): any
-- 	from = ""

-- 	if self._isolatedMockRegistry ~= nil and self._isolateMockRegistry:has(scriptInstance) then
-- 		return self._isolatedMockRegistry:get(scriptInstance)
-- 	elseif self._mockRegistry:has(scriptInstance) then
-- 		return self._mockRegistry:get(scriptInstance)
-- 	end

-- 	local mockRegistry = (self._isolateMockRegistry or self._mockRegistry) :: Map<ModuleScript, any>

-- 	if self._mockFactories:has(scriptInstance) then
-- 		local module = self._mockFactories:get(scriptInstance)
-- 		mockRegistry:set(scriptInstance, module)
-- 		return module
-- 	end

-- 	-- ROBLOX DEVIATION start: mock modules / files are not currently supported
-- 	-- bunch of commented out code here
-- 	-- ROBLOX DEVIATION end

-- 	mockRegistry:set(scriptInstance, self:_generateMock(from, scriptInstance))
-- 	return mockRegistry:get(scriptInstance)
-- end
-- ROBLOX TODO END

function Runtime:requireModule(from: string, scriptInstance: ModuleScript, options: any?, isRequireActual: boolean): any
	local moduleRegistry

	if self._isolatedModuleRegistry ~= nil then
		moduleRegistry = self._isolatedModuleRegistry
	else
		moduleRegistry = self._moduleRegistry
	end

	if moduleRegistry:has(scriptInstance) then
		return moduleRegistry:get(scriptInstance)
	end

	-- ROBLOX DEVIATION start: Roblox require override functionality here
	local moduleResult

	-- Narrowing this type here lets us appease the type checker while still
	-- counting on types for the rest of this file
	local loadmodule: (ModuleScript) -> (any, string, () -> any) = debug["loadmodule"]
	local moduleFunction, errorMessage, cleanupFn = loadmodule(scriptInstance)
	assert(moduleFunction ~= nil, errorMessage)

	if cleanupFn ~= nil then
		table.insert(self._cleanupFns, cleanupFn)
	end

	getfenv(moduleFunction).require = function(scriptInstance: ModuleScript)
		return self:requireModuleOrMock(scriptInstance)
	end
	getfenv(moduleFunction).delay = self._fakeTimersImplementation.delayOverride
	getfenv(moduleFunction).tick = self._fakeTimersImplementation.tickOverride
	getfenv(moduleFunction).DateTime = self._fakeTimersImplementation.dateTimeOverride
	getfenv(moduleFunction).os = self._fakeTimersImplementation.osOverride

	moduleResult = moduleFunction()
	if moduleResult == nil then
		error(
			string.format(
				"[Module Error]: %s did not return a valid result\n" .. "\tModuleScripts must return a non-nil value",
				tostring(scriptInstance)
			)
		)
	end
	-- ROBLOX DEVIATION end

	moduleRegistry:set(scriptInstance, moduleResult)
	return moduleResult
end

function Runtime.isolateModules(self: RuntimePrivate, fn: () -> ()): ()
	if self._isolatedModuleRegistry ~= nil or self._isolatedMockRegistry ~= nil then
		error("isolateModules cannot be nested inside another isolateModules.")
	end
	self._isolatedModuleRegistry = Map.new()
	self._isolatedMockRegistry = Map.new()

	local ok, result, hasReturned = pcall(function()
		fn()
	end)

	-- might be cleared within the callback
	if self._isolatedModuleRegistry then
		self._isolatedModuleRegistry:clear()
	end
	if self._isolatedMockRegistry then
		self._isolatedMockRegistry:clear()
	end
	self._isolatedModuleRegistry = nil
	self._isolatedMockRegistry = nil

	if hasReturned then
		return result
	end
	if not ok then
		error(result)
	end
end

function Runtime:clearAllMocks(): ()
	self._moduleMocker.clearAllMocks()
end

function Runtime:resetAllMocks(): ()
	self._moduleMocker.resetAllMocks()
end

function Runtime:restoreAllMocks(): ()
	self._moduleMocker.restoreAllMocks()
end

-- ROBLOX TODO START: not implemented yet
-- function Runtime:setMock(
-- 	from: string,
-- 	scriptInstance: ModuleScript,
-- 	mockFactory: () -> unknown,
-- 	options: ({ virtual: boolean? })?
-- ): ()
-- 	-- ROBLOX DEVIATION start: not sure what a virtual mock is at this point so leaving it out
-- 	-- if options ~= nil and options.virtual = true then
-- 	-- 	self._virtualMocks.set(moduleName, true)
-- 	-- end
-- 	-- ROBLOX DEVIATION end
-- 	self._explicitShouldMock:set(scriptInstance, true)
-- 	self._mockFactories:set(scriptInstance, mockFactory)
-- end
-- ROBLOX TODO END

function Runtime:_shouldMock(
	from: string,
	scriptInstance: ModuleScript,
	explicitShouldMock: Map<ModuleScript, boolean>,
	options: any --[[ ResolveModuleConfig ]]
): boolean
	-- if explicitShouldMock:has(scriptInstance) then
	-- 	return explicitShouldMock:get(scriptInstance) :: boolean
	-- end
	-- ROBLOX DEVIATION: bunch of code would be here if I hadn't ripped it out
	return false
end

-- ROBLOX TODO START: not implemented yet
-- function Runtime:_generateMock(from: Config_Path, scriptInstance: ModuleScript): any
-- 	-- get module from cache or require
-- 	return {}
-- end
-- ROBLOX TODO END

function Runtime:_createJestObjectFor(from: Config_Path): Jest
	from = from or ""
	local jestObject = {}

	-- ROBLOX TODO START: not implemented yet
	-- local function disableAutomock(): Jest
	-- 	self._shouldAutoMock = false
	-- 	return jestObject :: Jest
	-- end

	-- local function enableAutomock(): Jest
	-- 	self._shouldAutoMock = true
	-- 	return jestObject :: Jest
	-- end

	-- local function setMockFactory(
	-- 	scriptInstance: ModuleScript,
	-- 	mockFactory: MockFactory,
	-- 	options: { virtual: boolean? }?
	-- ): Jest
	-- 	self:setMock(from, scriptInstance, mockFactory, options)
	-- 	return jestObject :: Jest
	-- end

	-- local function mock(scriptInstance: ModuleScript, mockFactory: MockFactory, options: any): Jest
	-- 	if mockFactory ~= nil then
	-- 		return setMockFactory(scriptInstance, mockFactory, options)
	-- 	end
	-- 	-- local moduleID = self._resolver:getModuleID(
	-- 	-- 	self._virtualMocks,
	-- 	-- 	from,
	-- 	-- 	moduleName,
	-- 	-- 	{ conditions = self.cjsConditions }
	-- 	-- )
	-- 	self._explicitShouldMock:set(scriptInstance, true)
	-- 	return jestObject :: Jest
	-- end

	-- local mockModule: any --[[ ROBLOX TODO: Unhandled node for type: TSIndexedAccessType ]] --[[ Jest['unstable_mockModule'] ]]
	-- function mockModule(moduleName, mockFactory, options)
	-- 	if typeof(mockFactory) ~= "function" then
	-- 		error(Error.new("`unstable_mockModule` must be passed a mock factory"))
	-- 	end
	-- 	self:setModuleMock(from, moduleName, mockFactory, options)
	-- 	return jestObject
	-- end
	-- ROBLOX TODO END

	local function clearAllMocks(): Jest
		self:clearAllMocks()
		return jestObject :: Jest
	end

	local function resetAllMocks(): Jest
		self:resetAllMocks()
		return jestObject :: Jest
	end

	local function restoreAllMocks(): Jest
		self:restoreAllMocks()
		return jestObject :: Jest
	end

	local function _getFakeTimers(): FakeTimers
		return self._fakeTimersImplementation
	end

	local function useFakeTimers(): Jest
		self._fakeTimersImplementation:useFakeTimers()
		return jestObject :: Jest
	end

	local function useRealTimers(): Jest
		_getFakeTimers():useRealTimers()
		return jestObject :: Jest
	end

	local function resetModules(): Jest
		self:resetModules()
		return jestObject :: Jest
	end

	local function isolateModules(fn: () -> ()): Jest
		self:isolateModules(fn)
		return jestObject :: Jest
	end

	local fn = function(implementation: any): ModuleMocker
		return self._moduleMocker:fn(implementation)
	end
	-- ROBLOX TODO: not implemented yet
	-- local spyOn = self._moduleMocker.spyOn:bind(self._moduleMocker)

	Object.assign(jestObject, {
		-- ROBLOX TODO START: not implemented yet
		-- autoMockOff = disableAutomock,
		-- autoMockOn = enableAutomock,
		-- ROBLOX TODO END
		clearAllMocks = clearAllMocks,
		clearAllTimers = function()
			return _getFakeTimers():clearAllTimers()
		end,
		-- ROBLOX TODO START: not implemented yet
		-- createMockFromModule = function(moduleName: string)
		-- 	return self:_generateMock(from, moduleName)
		-- end,
		-- disableAutomock = disableAutomock,
		-- doMock = mock,
		-- dontMock = unmock,
		-- enableAutomock = enableAutomock,
		-- ROBLOX TODO END
		fn = fn,
		-- ROBLOX TODO START: not implemented yet
		-- genMockFromModule = function(scriptInstance: ModuleScript)
		-- 	return self:_generateMock(from, scriptInstance)
		-- end,
		-- ROBLOX TODO END
		getRealSystemTime = function()
			local fakeTimers = _getFakeTimers()
			if fakeTimers == self._environment.fakeTimersModern then
				return fakeTimers:getRealSystemTime()
			else
				error("getRealSystemTime is not available when not using modern timers")
			end
		end,
		getTimerCount = function()
			return _getFakeTimers():getTimerCount()
		end,
		-- ROBLOX TODO: not implemented yet
		-- isMockFunction = self._moduleMocker.isMockFunction,
		isolateModules = isolateModules,
		-- ROBLOX TODO START: not implemented yet
		-- mock = mock,
		-- mocked = mocked,
		-- requireActual = self.requireActual:bind(self, from),
		-- requireMock = self.requireMock:bind(self, from),
		-- ROBLOX TODO END
		resetAllMocks = resetAllMocks,
		resetModules = resetModules,
		restoreAllMocks = restoreAllMocks,
		-- ROBLOX TODO: not implemented yet
		-- retryTimes = retryTimes,
		runAllTicks = function()
			return _getFakeTimers():runAllTicks()
		end,
		runAllTimers = function()
			return _getFakeTimers():runAllTimers()
		end,
		runOnlyPendingTimers = function()
			return _getFakeTimers():runOnlyPendingTimers()
		end,
		-- ROBLOX TODO START: not implemented yet
		-- setMock = function(scriptInstance: ModuleScript, mock: unknown)
		-- 	return setMockFactory(scriptInstance, function()
		-- 		return mock
		-- 	end)
		-- end,
		-- ROBLOX TODO END
		setSystemTime = function(now: (number | DateTime)?)
			local fakeTimers = _getFakeTimers()
			if fakeTimers == self._environment.fakeTimersModern then
				fakeTimers:setSystemTime(now)
			else
				error("setSystemTime is not available when not using modern timers")
			end
		end,
		setTimeout = setTimeout,
		-- ROBLOX TODO START: not implemented yet
		-- spyOn = spyOn,
		-- unmock = unmock,
		-- unstable_mockModule = mockModule,
		-- ROBOX TODO END
		useFakeTimers = useFakeTimers,
		useRealTimers = useRealTimers,
	})

	return jestObject :: Jest
end
-- ROBLOX DEVIATION end

return Runtime
