-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local Packages = script.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local setTimeout = LuauPolyfill.setTimeout
type Map<T, U> = LuauPolyfill.Map<T, U>
type Array<T> = LuauPolyfill.Array<T>

--[[
	ROBLOX deviation: skipped lines 8-45
	original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L8-L45
]]

local jestTypesModule = require(Packages.JestTypes)
type Config_Path = jestTypesModule.Config_Path
-- ROBLOX deviation: Global_TestFrameworkGlobals not implemented yet
type Global_TestFrameworkGlobals = {}

--[[
	ROBLOX deviation: skipped lines 47-49
	original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L47-L49
]]

local moduleMockerModule = require(Packages.JestMock)
-- ROBLOX deviation: not implemented yet
-- type MockFunctionMetadata = moduleMockerModule.MockFunctionMetadata
type ModuleMocker = moduleMockerModule.ModuleMocker
-- ROBLOX deviation (addition): importing ModuleMocker class instead of injecting it via runTests
local ModuleMocker = moduleMockerModule.ModuleMocker

--[[
	ROBLOX deviation: skipped lines 51-59
	original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L51-L59
]]

local typesModule = require(script.types)

export type Context = typesModule.Context

-- ROBLOX deviation: adding mocked ResolveModuleConfig type until implemented
type ResolveModuleConfig = any

-- ROBLOX deviation START: additional dependencies
local _typesModule = require(script._types)
export type Jest = _typesModule.Jest
type MockFactory = _typesModule.MockFactory

local jestExpectModule = require(Packages.Expect)
type Expect = jestExpectModule.Expect
local JestFakeTimers = require(Packages.JestFakeTimers)
type FakeTimers = JestFakeTimers.FakeTimers
-- ROBLOX deviation END

type JestGlobals = {
	expect: any,
	expectExtended: any,
	jestSnapshot: {
		toMatchSnapshot: (...any) -> any,
		toThrowErrorMatchingSnapshot: (...any) -> any,
	},
}

type JestGlobalsWithJest = JestGlobals & {
	jest: Jest,
}

--[[
	ROBLOX deviation: skipped lines 74-92
	original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L74-L92
]]

type Module = any
type InitialModule = any
type ModuleRegistry = Map<ModuleScript, InitialModule | Module>

--[[
	ROBLOX deviation: skipped lines 97-175
	original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L97-L175
]]

-- TODO: Cross check order of conversion from original JS to Lua conversion here
export type Runtime = {
	-- ROBLOX TODO: not implemented yet
	setGlobalsForRuntime: (self: RuntimePrivate, globals: JestGlobals) -> (),
	getGlobalsFromEnvironment: (self: RuntimePrivate) -> JestGlobals,
	teardown: (self: RuntimePrivate) -> (),
	requireModuleOrMock: (self: RuntimePrivate, scriptInstance: ModuleScript) -> any,
	-- ROBLOX TODO: not implemented yet
	-- ROBLOX deviation START: using ModuleScript instead of Config_Path
	requireActual: <T>(self: RuntimePrivate, from: ModuleScript, moduleName: ModuleScript) -> T,
	requireMock: <T>(self: RuntimePrivate, from: ModuleScript, moduleName: ModuleScript) -> T,
	-- ROBLOX deviation END
	requireModule: (
		self: RuntimePrivate,
		-- ROBLOX deviation: accept ModuleScript instead of string
		from: ModuleScript,
		-- ROBLOX deviation: accept ModuleScript instead of string
		scriptInstance: ModuleScript?,
		options: any?,
		isRequireActual: boolean?,
		-- ROBLOX deviation START: added param to not require return from test files
		noModuleReturnRequired: boolean?
		-- ROBLOX deviation END
	) -> any,
	-- ROBLOX deviation: no default param <T = unknown>
	requireInternalModule: <T>(
		self: RuntimePrivate,
		-- ROBLOX deviation START: accept ModuleScript instead of string
		from: ModuleScript,
		to: ModuleScript?
		-- ROBLOX deviation END
	) -> T,
	isolateModules: (self: RuntimePrivate, fn: MockFactory) -> (),
	resetModules: (self: RuntimePrivate) -> (),
	clearAllMocks: (self: RuntimePrivate) -> (),
	setMock: (
		self: RuntimePrivate,
		from: ModuleScript,
		scriptInstance: ModuleScript,
		mockFactory: MockFactory,
		options: ({ virtual: boolean? })?
	) -> any,
	-- ROBLOX deviation START: not implemented yet
	-- _generateMock: (self: RuntimePrivate, from: Config_Path, scriptInstance: ModuleScript) -> unknown,
	-- ROBLOX TODO END
	restoreAllMocks: (self: RuntimePrivate) -> (),
	resetAllMocks: (self: RuntimePrivate) -> (),
	-- ROBLOX deviation START: accept ModuleScript instead of string
	_createJestObjectFor: (self: RuntimePrivate, from: ModuleScript) -> Jest,
	-- ROBLOX deviation END
}

export type RuntimePrivate = Runtime & {
	--[[
		ROBLOX deviation: skipped lines 178-181
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L178-L181
	]]

	--[[
		ROBLOX deviation START: There's no actual Jest Environment so we are just
		mocking some values in here for now.
	]]
	_environment: {
		fakeTimersModern: FakeTimers,
	},
	-- ROBLOX deviation END
	-- ROBLOX deviation START: using ModuleScript instead of string
	_explicitShouldMock: Map<ModuleScript, boolean>,
	_explicitShouldMockModule: Map<ModuleScript, boolean>,
	-- ROBLOX deviation END
	-- ROBLOX deviation: no Legacy/Modern timers
	_fakeTimersImplementation: FakeTimers,
	_internalModuleRegistry: ModuleRegistry,

	--[[
		ROBLOX deviation: skipped lines 189-191
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L189-L191
	]]
	-- ROBLOX deviation START: using ModuleScript instead of string
	_mockFactories: Map<ModuleScript, () -> unknown>,
	-- ROBLOX deviation END
	--[[
		ROBLOX deviation: skipped lines 193-196
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L193-L196
	]]
	-- ROBLOX deviation START: using ModuleScript instead of string
	_mockRegistry: Map<ModuleScript, any>,
	_isolatedMockRegistry: Map<ModuleScript, any>?,
	-- ROBLOX deviation END
	-- ROBLOX TODO START: not implemented yet
	-- _moduleMockRegistry: Map<string, VMModule>,
	-- _moduleMockFactories: Map<string, () -> unknown>,
	-- ROBLOX TODO END
	_moduleMocker: ModuleMocker,
	_isolatedModuleRegistry: ModuleRegistry?,
	_moduleRegistry: ModuleRegistry,

	--[[
		ROBLOX deviation: skipped lines 204-208
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L204-L208
	]]
	_shouldAutoMock: boolean,
	_shouldMockModuleCache: Map<ModuleScript, boolean>,
	--[[
		ROBLOX deviation: skipped lines 211-222
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L211-L222
	]]
	_shouldUnmockTransitiveDependenciesCache: Map<ModuleScript, boolean>,
	-- ROBLOX deviation START: virtual mocks not supported
	_virtualMocks: Map<ModuleScript, boolean>,
	-- ROBLOX deviation END
	--[[
		ROBLOX deviation: skipped lines 224-225
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L224-L225
	]]

	jestGlobals: JestGlobals?,

	--[[
		ROBLOX deviation: skipped lines 228-229
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L228-L229
	]]
	isTornDown: boolean,

	-- ROBLOX deviation START: additional types
	_jestObject: Jest,
	_cleanupFns: Array<() -> ()>,
	_shouldMock: (
		self: RuntimePrivate,
		-- ROBLOX deviation: accept ModuleScript instead of string
		from: ModuleScript,
		scriptInstance: ModuleScript,
		explicitShouldMock: Map<ModuleScript, boolean>,
		options: ResolveModuleConfig
	) -> boolean,
	-- ROBLOX deviation END
}

type RuntimeStatic = RuntimePrivate & {
	new: () -> RuntimePrivate,
	__index: RuntimeStatic,
}

local Runtime = {} :: RuntimeStatic
Runtime.__index = Runtime
--[[
	ROBLOX deviation: skipped lines 326-418
	original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L326-L418
	static methods not implemented yet
]]

-- ROBLOX deviation: no arguments for constructor
function Runtime.new(): RuntimePrivate
	local self = (setmetatable({}, Runtime) :: any) :: RuntimePrivate

	self.isTornDown = false

	--[[
		ROBLOX deviation: skipped lines 241-244
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L241-L244
	]]

	--[[
		ROBLOX deviation START: There's no actual Jest Environment so we are just
		mocking some values in here for now.
	]]
	self._environment = {
		fakeTimersModern = JestFakeTimers.new(),
	}
	-- ROBLOX deviation END
	self._explicitShouldMock = Map.new()
	self._explicitShouldMockModule = Map.new()
	self._internalModuleRegistry = Map.new()

	--[[
		ROBLOX deviation: skipped lines 249-250
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L249-L250
	]]
	self._mockFactories = Map.new()
	self._mockRegistry = Map.new()
	--[[
		ROBLOX deviation: skipped lines 253-258
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L253-L258
	]]
	-- ROBLOX deviation START: instantiate the module mocker here
	-- instead of being passed in as an arg from runTest
	self._moduleMocker = ModuleMocker.new()
	-- ROBLOX deviation END
	self._isolatedModuleRegistry = nil
	self._isolatedMockRegistry = nil
	self._moduleRegistry = Map.new()

	--[[
		ROBLOX deviation: skipped lines 263-268
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L263-L268
	]]
	-- ROBLOX deviation START: automock not supported
	self._shouldAutoMock = false
	-- ROBLOX deviation END
	--[[
		ROBLOX deviation: skipped lines 270-272
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L270-L272
	]]
	self._virtualMocks = Map.new()
	--[[
		ROBLOX deviation: skipped lines 274-277
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L274-L277
	]]
	self._shouldMockModuleCache = Map.new()
	--[[
		ROBLOX deviation: skipped lines 278-280
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L278-L280
	]]
	self._shouldUnmockTransitiveDependenciesCache = Map.new()

	-- ROBLOX deviation: no Legacy/Modern timers
	self._fakeTimersImplementation = self._environment.fakeTimersModern

	--[[
		ROBLOX deviation: skipped lines 287-323
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L287-L323
	]]

	--[[
		ROBLOX deviation START: normally a jest object gets created for each
		test file and inserted into a cache, an instance gets injected into each
		test module. Currently this implementation is global across all tests.
	]]
	local filename = script
	self._jestObject = self:_createJestObjectFor(filename)
	-- ROBLOX deviation END

	--[[
		ROBLOX deviation START: added to hold references to all the clean up
		functions from loaded modules. Is used in Runtime.teardown
	]]
	self._cleanupFns = {}
	-- ROBLOX deviation END

	return self
end

--[[
	ROBLOX deviation: skipped lines 420-744
	original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L420-L744
]]

function Runtime:requireModule(
	-- ROBLOX deviation START: using ModuleScript instead of string
	from: ModuleScript,
	_moduleName: ModuleScript?,
	-- ROBLOX deviation END
	options: any?,
	isRequireActual: boolean?,
	-- ROBLOX deviation START: added param to not require return from test files
	noModuleReturnRequired: boolean?
	-- ROBLOX deviation END
): any
	-- ROBLOX deviation START
	local moduleName = if _moduleName == nil then from else _moduleName
	-- ROBLOX deviation END

	local isInternal = if typeof(options) == "table" and options.isInternalModule ~= nil
		then options.isInternalModule
		else false
	--[[
		ROBLOX deviation: skipped lines 753-802
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L753-L802
	]]
	local moduleRegistry: ModuleRegistry

	-- ROBLOX deviation: skipped isInternal check
	if isInternal then
		moduleRegistry = self._internalModuleRegistry
	elseif self._isolatedModuleRegistry ~= nil then
		moduleRegistry = self._isolatedModuleRegistry
	else
		moduleRegistry = self._moduleRegistry
	end

	local module = moduleRegistry:get(moduleName)
	if module then
		return module
	end

	-- ROBLOX deviation START: Roblox require override functionality here
	local moduleResult

	-- Narrowing this type here lets us appease the type checker while still
	-- counting on types for the rest of this file
	local loadmodule: (ModuleScript) -> (any, string, () -> any) = debug["loadmodule"]
	local moduleFunction, errorMessage, cleanupFn = loadmodule(moduleName)
	assert(moduleFunction ~= nil, errorMessage)

	if cleanupFn ~= nil then
		table.insert(self._cleanupFns, cleanupFn)
	end

	getfenv(moduleFunction).require = function(scriptInstance: ModuleScript)
		return self:requireModuleOrMock(scriptInstance)
	end
	getfenv(moduleFunction).delay = self._fakeTimersImplementation.delayOverride
	getfenv(moduleFunction).tick = self._fakeTimersImplementation.tickOverride
	getfenv(moduleFunction).time = self._fakeTimersImplementation.timeOverride
	getfenv(moduleFunction).DateTime = self._fakeTimersImplementation.dateTimeOverride
	getfenv(moduleFunction).os = self._fakeTimersImplementation.osOverride
	getfenv(moduleFunction).task = self._fakeTimersImplementation.taskOverride

	moduleResult = table.pack(moduleFunction())
	if moduleResult.n ~= 1 and noModuleReturnRequired ~= true then
		error(
			string.format(
				"[Module Error]: %s did not return a valid result\n" .. "\tModuleScripts must return exactly one value",
				tostring(moduleName)
			)
		)
	end
	moduleResult = moduleResult[1]
	-- ROBLOX deviation END

	-- ROBLOX deviation START: added check to not store in moduleRegistry if moduleResult is nil
	-- moduleRegistry:set(moduleName, moduleResult)
	if moduleResult ~= nil then
		moduleRegistry:set(moduleName, moduleResult)
	end
	-- ROBLOX deviation END
	return moduleResult
end

-- ROBLOX deviation: no default param <T = unknown>
function Runtime:requireInternalModule<T>(
	-- ROBLOX deviation START: accept ModuleScript instead of string
	from: ModuleScript,
	to: ModuleScript?
	-- ROBLOX deviation END
): T
	-- ROBLOX deviation START: `to` not handled yet
	-- if Boolean.toJSBoolean(to) then
	-- 		local require_ = (if nativeModule.createRequire ~= nil
	-- 				then nativeModule.createRequire
	-- 				else nativeModule.createRequireFromPath)(from)
	-- 		if Boolean.toJSBoolean(INTERNAL_MODULE_REQUIRE_OUTSIDE_OPTIMIZED_MODULES:has(to)) then
	-- 				return require_(to)
	-- 		end
	-- 		local outsideJestVmPath = decodePossibleOutsideJestVmPath(to)
	-- 		if Boolean.toJSBoolean(outsideJestVmPath) then
	-- 				return require_(outsideJestVmPath)
	-- 		end
	-- end
	-- ROBLOX deviation END
	return self:requireModule(from, to, {
		isInternalModule = true,
		-- supportsDynamicImport = esmIsAvailable,
		-- supportsExportNamespaceFrom = false,
		-- supportsStaticESM = false,
		-- supportsTopLevelAwait = false,
	})
end

function Runtime:requireActual<T>(from: ModuleScript, moduleName: ModuleScript): T
	return self:requireModule(from, moduleName, nil, true)
end
-- ROBLOX deviation START: using module script instead of string moduleName
function Runtime:requireMock<T>(from: ModuleScript, moduleName: ModuleScript): T
	local moduleID = moduleName
	-- ROBLOX deviation END
	if
		-- ROBLOX deviation END: simplify for better type inference
		-- if typeof(self._isolatedMockRegistry) == "table" and self._isolatedMockRegistry.has
		-- 	then self._isolatedMockRegistry:has(moduleID)
		-- 	else nil
		self._isolatedMockRegistry ~= nil and self._isolatedMockRegistry:has(moduleID)
		-- ROBLOX deviation END
	then
		-- ROBLOX deviation START: this is guaranteed to not be nil as we set a registry above
		-- return self._isolatedMockRegistry:get(moduleID)
		return self._isolatedMockRegistry:get(moduleID) :: any
		-- ROBLOX deviation END
	elseif self._mockRegistry:has(moduleID) then
		-- ROBLOX deviation START: this is guaranteed to not be nil as we set a registry above
		-- return self._mockRegistry:get(moduleID)
		return self._mockRegistry:get(moduleID) :: any
		-- ROBLOX deviation END
	end
	-- ROBLOX deviation START: simplify because `self._isolatedMockRegistry` is either nil or a map object
	-- local mockRegistry = Boolean.toJSBoolean(self._isolatedMockRegistry) and self._isolatedMockRegistry
	-- 	or self._mockRegistry
	local mockRegistry: Map<ModuleScript, any> = self._isolatedMockRegistry or self._mockRegistry
	-- ROBLOX deviation END
	if self._mockFactories:has(moduleID) then
		-- has check above makes this ok
		local module = (self._mockFactories:get(moduleID) :: any)()
		mockRegistry:set(moduleID, module)
		return module :: T
	end
	-- ROBLOX TODO START
	error("manual mocks not implemented yet")
	-- local manualMockOrStub = self._resolver:getMockModule(from, moduleName)
	-- local ref = self._resolver:getMockModule(from, moduleName)
	-- local modulePath = Boolean.toJSBoolean(ref) and ref
	-- 	or self:_resolveModule(from, moduleName, { conditions = self.cjsConditions })
	-- local isManualMock = if Boolean.toJSBoolean(manualMockOrStub)
	-- 	then not Boolean.toJSBoolean(self._resolver:resolveStubModuleName(from, moduleName))
	-- 	else manualMockOrStub
	-- if not Boolean.toJSBoolean(isManualMock) then
	-- 	-- If the actual module file has a __mocks__ dir sitting immediately next
	-- 	-- to it, look to see if there is a manual mock for this file.
	-- 	--
	-- 	-- subDir1/my_module.js
	-- 	-- subDir1/__mocks__/my_module.js
	-- 	-- subDir2/my_module.js
	-- 	-- subDir2/__mocks__/my_module.js
	-- 	--
	-- 	-- Where some other module does a relative require into each of the
	-- 	-- respective subDir{1,2} directories and expects a manual mock
	-- 	-- corresponding to that particular my_module.js file.
	-- 	-- ROBLOX deviation START: using moduleScript instead of path
	-- 	-- local moduleDir = path:dirname(modulePath)
	-- 	-- local moduleFileName = path:basename(modulePath)
	-- 	-- local potentialManualMock = Array.join(path, moduleDir, "__mocks__", moduleFileName) --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 	local potentialManualMock = moduleName
	-- 	-- ROBLOX deviation END
	-- 	-- ROBLOX deviation START: checking for truthiness of ModuleScript since we don't have access to filesystem
	-- 	if Boolean.toJSBoolean(potentialManualMock) then
	-- 		-- ROBLOX deviation END
	-- 		isManualMock = true
	-- 		modulePath = potentialManualMock
	-- 	end
	-- end
	-- if isManualMock then
	-- 	local localModule: InitialModule = {
	-- 		children = {},
	-- 		exports = {},
	-- 		filename = modulePath,
	-- 		id = modulePath,
	-- 		loaded = false,
	-- 		-- ROBLOX deviation START: using ModuleScript, NodeJS `path` not available
	-- 		path = modulePath,
	-- 		-- ROBLOX deviation END
	-- 	}
	-- 	self:_loadModule(localModule, from, moduleName, modulePath, nil, mockRegistry)
	-- 	mockRegistry:set(moduleID, localModule.exports)
	-- else
	-- 	-- Look for a real module to generate an automock from
	-- 	-- ROBLOX deviation START: automock not supported
	-- 	-- mockRegistry:set(moduleID, self:_generateMock(from, moduleName))
	-- 	error("automock not supported")
	-- 	-- ROBLOX deviation END
	-- end
	-- -- ROBLOX deviation START: this is guaranteed to not be nil as we set a registry above
	-- -- return mockRegistry:get(moduleID)
	-- return mockRegistry:get(moduleID) :: any
	-- -- ROBLOX deviation END
	-- ROBLOX TODO END
end
--[[
	ROBLOX deviation: skipped lines 961-997
	original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#961-L997
]]

function Runtime:requireModuleOrMock(moduleName: ModuleScript)
	local from = moduleName

	if moduleName == script or moduleName == script.Parent then
		-- ROBLOX NOTE: Need to cast require because analyze cannot figure out scriptInstance path
		return (require :: any)(moduleName)
	end

	-- ROBLOX deviation START: we need to make sure LuauPolyfill is only loaded once
	if moduleName.Name == "LuauPolyfill" then
		return (require :: any)(moduleName)
	end
	-- ROBLOX deviation END

	if moduleName.Name == "JestGlobals" then
		--[[
			ROBLOX deviation START: We don't have to worry about two different
			module systems so I'm leaving out getGlobalsForCjs + getGlobalsForEsm
		]]
		local globals = self:getGlobalsFromEnvironment()
		return Object.assign({}, globals, {
			jest = self._jestObject,
		}) :: JestGlobalsWithJest
		-- ROBLOX deviation END
	end

	local ok, result = pcall(function()
		local shouldMock = self:_shouldMock(from, moduleName, self._explicitShouldMock, {
			conditions = nil,
		})
		if shouldMock then
			-- error("mocking is not implemented in JestRuntime yet")
			return self:requireMock(from, moduleName)
		else
			return self:requireModule(from, moduleName)
		end
	end)
	if not ok then
		error(result)
	end
	return result
end

function Runtime:isolateModules(fn: () -> ()): ()
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

function Runtime:resetModules(): ()
	if self._isolatedModuleRegistry then
		self._isolatedModuleRegistry:clear()
	end
	if self._isolatedMockRegistry then
		self._isolatedMockRegistry:clear()
	end
	self._isolatedModuleRegistry = nil
	self._isolatedMockRegistry = nil
	-- ROBLOX TODO: not implemented yet
	self._mockRegistry:clear()
	self._moduleRegistry:clear()
	--[[
		ROBLOX deviation: skipped lines 1068-1089
		original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L1068-L1089
	]]
end

--[[
	ROBLOX deviation: skipped lines 1092-1137
	original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L1092-L1137
]]
function Runtime:setMock(
	from: ModuleScript,
	moduleName: ModuleScript,
	mockFactory: () -> unknown,
	options: { virtual: boolean? }?
): ()
	if Boolean.toJSBoolean(if typeof(options) == "table" then options.virtual else nil) then
		-- ROBLOX deviation START: using module script instead of string moduleName
		-- local mockPath = self._resolver:getModulePath(from, moduleName)
		-- self._virtualMocks:set(mockPath, true)
		error("virtual mocks not supported")
		-- ROBLOX deviation END
	end
	-- ROBLOX deviation START: using module script instead of string moduleName
	local moduleID = moduleName
	-- ROBLOX deviation END
	self._explicitShouldMock:set(moduleID, true)
	self._mockFactories:set(moduleID, mockFactory)
end
--[[
	ROBLOX deviation: skipped lines 1160-1179
	original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L1160-L1179
]]

function Runtime:restoreAllMocks(): ()
	self._moduleMocker:restoreAllMocks()
end

function Runtime:resetAllMocks(): ()
	self._moduleMocker:resetAllMocks()
end

function Runtime:clearAllMocks(): ()
	self._moduleMocker:clearAllMocks()
end

function Runtime:teardown(): ()
	self:restoreAllMocks()
	self:resetAllMocks()
	self:resetModules()

	self._internalModuleRegistry:clear()
	-- ROBLOX TODO START: not implemented yet
	-- self._mainModule = nil;
	self._mockFactories:clear()
	-- self._moduleMockFactories:clear();
	-- self._mockMetaDataCache:clear();
	self._shouldMockModuleCache:clear()
	self._shouldUnmockTransitiveDependenciesCache:clear()
	-- ROBLOX TODO END
	self._explicitShouldMock:clear()
	self._explicitShouldMockModule:clear()
	-- ROBLOX TODO START: not implemented yet
	-- self._transitiveShouldMock:clear();
	-- self._virtualMocks:clear();
	-- self._virtualModuleMocks:clear();
	-- self._cacheFS:clear();
	-- self._unmockList = nil;

	-- self._sourceMapRegistry:clear();

	-- self._fileTransforms:clear();
	-- self._fileTransformsMutex:clear();
	-- self.jestObjectCaches:clear();

	-- self._v8CoverageResult = {};
	-- self._v8CoverageInstrumenter = nil;
	-- self._moduleImplementation = nil;
	-- ROBLOX TODO END

	-- ROBLOX deviation START: additional cleanup logic for modules loaded with debug.loadmodule
	for _, cleanup in ipairs(self._cleanupFns) do
		cleanup()
	end
	-- ROBLOX deviation END

	self.isTornDown = true
end

--[[
	ROBLOX deviation: skipped lines 1226-1684
	original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L1226-L1684
]]

function Runtime:_shouldMock(
	-- ROBLOX deviation: accept ModuleScript instead of string
	from: ModuleScript,
	moduleName: ModuleScript,
	explicitShouldMock: Map<ModuleScript, boolean>,
	options: ResolveModuleConfig
): boolean
	-- ROBLOX deviation START: using module script instead of string moduleName & key is moduleId since path is not available
	local moduleID = moduleName
	-- local key = from + path.delimiter + moduleID
	local key = moduleID
	-- ROBLOX deviation END

	if explicitShouldMock:has(moduleID) then
		-- guaranteed by `has` above
		return explicitShouldMock:get(moduleID) :: boolean
	end
	if
		not self._shouldAutoMock
		-- ROBLOX deviation START: isCoreModule is not available in luau - nodeJS specific
		-- or self._resolver:isCoreModule(moduleName)
		-- ROBLOX deviation END
		or self._shouldUnmockTransitiveDependenciesCache:get(key)
	then
		return false
	end
	if self._shouldMockModuleCache:has(moduleID) then
		-- guaranteed by `has` above
		return self._shouldMockModuleCache:get(moduleID) :: boolean
	end

	-- local modulePath
	-- do --[[ ROBLOX COMMENT: try-catch block conversion ]]
	-- 	local ok, result, hasReturned = xpcall(function()
	-- 		modulePath = self:_resolveModule(from, moduleName, options)
	-- 	end, function(e: unknown)
	-- 		local manualMock = self._resolver:getMockModule(from, moduleName)
	-- 		if Boolean.toJSBoolean(manualMock) then
	-- 			self._shouldMockModuleCache:set(moduleID, true)
	-- 			return true
	-- 		end
	-- 		error(e)
	-- 	end)
	-- 	if hasReturned then
	-- 		return result
	-- 	end
	-- end
	-- if
	-- 	Boolean.toJSBoolean(
	-- 		if Boolean.toJSBoolean(self._unmockList) then self._unmockList:test(modulePath) else self._unmockList
	-- 	)
	-- then
	-- 	self._shouldMockModuleCache:set(moduleID, false)
	-- 	return false
	-- end
	-- transitive unmocking for package managers that store flat packages (npm3)
	-- local currentModuleID = self._resolver:getModuleID(self._virtualMocks, from, nil, options)
	-- if
	-- 	Boolean.toJSBoolean(self._transitiveShouldMock:get(currentModuleID) == false or (function()
	-- 		local ref = Array.includes(from, NODE_MODULES) --[[ ROBLOX CHECK: check if 'from' is an Array ]]
	-- 		local ref = if Boolean.toJSBoolean(ref)
	-- 			then
	-- 				Array.includes(modulePath, NODE_MODULES) --[[ ROBLOX CHECK: check if 'modulePath' is an Array ]]
	-- 			else ref
	-- 		return if Boolean.toJSBoolean(ref)
	-- 			then (function()
	-- 				local ref = if Boolean.toJSBoolean(self._unmockList)
	-- 					then self._unmockList:test(from)
	-- 					else self._unmockList
	-- 				return Boolean.toJSBoolean(ref) and ref
	-- 					or explicitShouldMock:get(currentModuleID) == false
	-- 			end)()
	-- 			else ref
	-- 	end)())
	-- then
	-- 	self._transitiveShouldMock:set(moduleID, false)
	-- 	self._shouldUnmockTransitiveDependenciesCache:set(key, true)
	-- 	return false
	-- end
	-- self._shouldMockModuleCache:set(moduleID, true)
	return true
end

--[[
	ROBLOX deviation: skipped lines 1757-1813
	original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L1757-L1813
]]

-- ROBLOX deviation START: accept ModuleScript instead of string
function Runtime:_createJestObjectFor(_from: ModuleScript): Jest
	-- ROBLOX deviation END
	-- ROBLOX deviation START: hoisted declarations
	local setMockFactory
	-- ROBLOX deviation END
	-- ROBLOX deviation: from not used
	-- from = from or ""
	local jestObject = {} :: Jest

	-- ROBLOX TODO START: not implemented yet
	-- local function disableAutomock(): Jest
	-- 	self._shouldAutoMock = false
	-- 	return jestObject
	-- end

	-- local function enableAutomock(): Jest
	-- 	self._shouldAutoMock = true
	-- 	return jestObject
	-- end
	-- ROBLOX TODO END

	local function unmock(moduleName: ModuleScript)
		-- ROBLOX deviation START: using module script instead of string moduleName
		local moduleID = moduleName
		-- ROBLOX deviation END
		self._explicitShouldMock:set(moduleID, false)
		return jestObject
	end
	local function mock(moduleName: ModuleScript, mockFactory: MockFactory, options: any): Jest
		if mockFactory ~= nil then
			setMockFactory(moduleName, mockFactory, options)
		end
		self._explicitShouldMock:set(moduleName, true)
		return jestObject
	end

	function setMockFactory(moduleName: ModuleScript, mockFactory: MockFactory, options: { virtual: boolean? }?): Jest
		self:setMock(_from, moduleName, mockFactory, options)
		return jestObject
	end
	-- ROBLOX TODO START: not implemented yet
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
		return jestObject
	end

	local function resetAllMocks(): Jest
		self:resetAllMocks()
		return jestObject
	end

	local function restoreAllMocks(): Jest
		self:restoreAllMocks()
		return jestObject
	end

	local function _getFakeTimers(): FakeTimers
		return self._fakeTimersImplementation
	end

	local function useFakeTimers(): Jest
		self._fakeTimersImplementation:useFakeTimers()
		return jestObject
	end

	local function useRealTimers(): Jest
		_getFakeTimers():useRealTimers()
		return jestObject
	end

	local function resetModules(): Jest
		self:resetModules()
		return jestObject
	end

	local function isolateModules(fn: () -> ()): Jest
		self:isolateModules(fn)
		return jestObject
	end

	local fn = function(implementation: any)
		return self._moduleMocker:fn(implementation)
	end
	-- ROBLOX TODO: not implemented yet
	-- local spyOn = self._moduleMocker.spyOn:bind(self._moduleMocker)

	Object.assign(jestObject, {
		advanceTimersByTime = function(msToRun: number)
			_getFakeTimers():advanceTimersByTime(msToRun)
		end,
		advanceTimersToNextTimer = function(steps: number?)
			_getFakeTimers():advanceTimersToNextTimer(steps)
		end,
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
		-- enableAutomock = enableAutomock,
		-- ROBLOX TODO END
		dontMock = unmock,
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
		mock = mock,
		-- mocked = mocked,
		-- ROBLOX TODO END
		-- ROBLOX deviation START: no builtin bind support in luau
		-- requireActual = self.requireActual:bind(self, from),
		requireMock = function(__self, __from, moduleName)
			return self.requireMock(__self, __from, moduleName)
		end,
		-- ROBLOX deviation END

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
		-- ROBLOX TODO: remove when we don't need to manually inject fake timers into tests
		jestTimers = _getFakeTimers(),

		-- ROBLOX deviation START: using module script instead of string moduleName & virtual mocks not supported
		setMock = function(moduleName: ModuleScript, mock: unknown)
			return setMockFactory(moduleName, function()
				return mock
			end)
		end,
		-- ROBLOX deviation END

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
		unmock = unmock,
		-- unstable_mockModule = mockModule,
		-- ROBOX TODO END
		useFakeTimers = useFakeTimers,
		useRealTimers = useRealTimers,
	})

	return jestObject :: Jest
end

--[[
	ROBLOX deviation: skipped lines 2029-2124
	original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L2029-L2124
]]

function Runtime:getGlobalsFromEnvironment(): JestGlobals
	if self.jestGlobals then
		return table.clone(self.jestGlobals)
	end

	local jestSnapshot = self:requireModuleOrMock(Packages.JestSnapshot)
	local jestExpect = self:requireModuleOrMock(Packages.Expect)

	return {
		--[[
			ROBLOX deviation: skipped for now
			* afterAll
			* afterEach
			* beforeAll
			* beforeEach
			* describe
		]]
		expect = jestExpect,
		expectExtended = jestExpect,
		--[[
			ROBLOX deviation: skipped for now
			* fdescribe
			* fit
			* it
			* test
			* xdescribe
			* xit
			* xtest
		]]
		jestSnapshot = {
			toMatchSnapshot = jestSnapshot.toMatchSnapshot,
			toThrowErrorMatchingSnapshot = jestSnapshot.toThrowErrorMatchingSnapshot,
		},
	}
end

--[[
	ROBLOX deviation: skipped lines 2148-2158
	original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L2148-L2158
]]

function Runtime:setGlobalsForRuntime(globals: JestGlobals): ()
	self.jestGlobals = globals
end

--[[
	ROBLOX deviation: skipped lines 2165-2183
	original code: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-runtime/src/index.ts#L2165-L2183
]]

return Runtime
