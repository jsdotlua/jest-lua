--[[
	ROBLOX NOTE: no upstream
	based on: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-environment-node/src/index.ts
]]

local Packages = script.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
type Object = LuauPolyfill.Object
local Promise = require(Packages.Promise)
type Promise<T> = LuauPolyfill.Promise<T>

type Context = Object

local JestEnvironmentModule = require(Packages.JestEnvironment)
type JestEnvironment = JestEnvironmentModule.JestEnvironment

local JestFakeTimers = require(Packages.JestFakeTimers)

local typesModule = require(Packages.JestTypes)
type Config_ProjectConfig = typesModule.Config_ProjectConfig
type Global_Global = typesModule.Global_Global

local FakeTimersModule = require(Packages.JestFakeTimers)
type FakeTimers = FakeTimersModule.FakeTimers

local jestMockModule = require(Packages.JestMock)
type ModuleMocker = jestMockModule.ModuleMocker

-- ROBLOX NOTE: redefine props and methods to have proper `self` typing
type JestEnvironmentLuau = {
	new: (config: Config_ProjectConfig) -> JestEnvironmentLuau,
	global: Global_Global,
	-- ROBLOX deviation START: no modern/legacy timers
	-- fakeTimers: LegacyFakeTimers<Timer> | nil,
	-- fakeTimersModern: ModernFakeTimers | nil,
	fakeTimers: FakeTimers | nil,
	-- ROBLOX deviation END
	moduleMocker: ModuleMocker | nil,
	getVmContext: (self: JestEnvironmentLuau) -> (Context | nil),
	setup: (self: JestEnvironmentLuau) -> Promise<nil>,
	teardown: (self: JestEnvironmentLuau) -> Promise<nil>,
	context: any,
}

local JestEnvironmentLuau = {} :: JestEnvironmentLuau;
(JestEnvironmentLuau :: any).__index = JestEnvironmentLuau

function JestEnvironmentLuau.new(config: Config_ProjectConfig): JestEnvironmentLuau
	local self = setmetatable({}, JestEnvironmentLuau)

	self.context = {}
	local global = Object.assign(self.context, config.testEnvironmentOptions)
	self.global = global
	global.global = global

	self.fakeTimers = JestFakeTimers.new()

	return (self :: any) :: JestEnvironmentLuau
end

function JestEnvironmentLuau:getVmContext()
	return self.context
end

function JestEnvironmentLuau:setup()
	return Promise.resolve()
end

function JestEnvironmentLuau:teardown()
	return Promise.resolve():andThen(function()
		if self.fakeTimers ~= nil then
			self.fakeTimers:dispose()
		end
		self.context = {}
		self.fakeTimers = nil
	end)
end

return JestEnvironmentLuau
