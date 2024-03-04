-- ROBLOX upstream: no upstream
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local RegExp = require("@pkg/luau-regexp")
local eventHandler = require("../eventHandler").default

local typesModule = require("@pkg/@jsdotlua/jest-types")
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
