-- ROBLOX upstream: no upstream
local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local RegExp = require(Packages.RegExp)
local eventHandler = require(CurrentModule.Parent.eventHandler).default

local typesModule = require(Packages.JestTypes)
type Circus_Event = typesModule.Circus_Event
type Circus_State = typesModule.Circus_State

describe("eventHandler", function()
	it("should not fail when called with testNamePattern", function()
		local event = ({ name = "setup", testNamePattern = "apattern" } :: any) :: Circus_Event
		local state = {} :: Circus_State
		expect(function()
			eventHandler(nil, event, state)
		end).never.toThrow()
	end)

	it("should add testNamePattern to the state", function()
		local pattern = "apattern"
		local event = ({ name = "setup", testNamePattern = pattern } :: any) :: Circus_Event
		local state = {} :: Circus_State
		eventHandler(nil, event, state)

		expect(state.testNamePattern).toBeDefined()
		expect(state.testNamePattern).toBeInstanceOf(RegExp)
		expect(state.testNamePattern).toEqual(RegExp(pattern, "i"))
	end)
end)
