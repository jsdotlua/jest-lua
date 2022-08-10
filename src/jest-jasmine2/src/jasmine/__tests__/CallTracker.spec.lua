-- ROBLOX upstream: https://github.com/jasmine/jasmine/blob/v3.6.0/spec/core/CallTrackerSpec.js
--[[
	Our usual upstream of jest v27.4.7 doesn't include any tests for the
	CallTracker file so we instead look to the source that the jest/jasmine2
	is based off of, jasmine
]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent.Parent

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = (JestGlobals.describe :: any) :: Function
local it = (JestGlobals.it :: any) :: Function
local itSKIP = JestGlobals.it.skip

local CallTracker = require(CurrentModule.CallTracker)

describe("CallTracker", function()
	it("tracks that it was called when executed", function()
		local callTracker = CallTracker.new()

		expect(callTracker:any()).toBe(false)

		expect(callTracker:track())

		expect(callTracker:any()).toBe(true)
	end)

	it("tracks that number of times that it is executed", function()
		local callTracker = CallTracker.new()

		expect(callTracker:count()).toEqual(0)

		callTracker:track()

		expect(callTracker:count()).toEqual(1)
	end)

	it("tracks the params from each execution", function()
		local callTracker = CallTracker.new()

		callTracker:track({ object = nil, args = {} })
		callTracker:track({ object = {}, args = { 0, "foo" } })

		expect(callTracker:argsFor(0)).toEqual({})

		expect(callTracker:argsFor(1)).toEqual({ 0, "foo" })
	end)

	it("returns any empty array when there was no call", function()
		local callTracker = CallTracker.new()

		expect(callTracker:argsFor(0)).toEqual({})
	end)

	it("allows access for the arguments for all calls", function()
		local callTracker = CallTracker.new()

		callTracker:track({ object = {}, args = {} })
		callTracker:track({ object = {}, args = { 0, "foo" } })

		expect(callTracker:allArgs()).toEqual({ {}, { 0, "foo" } })
	end)

	it("tracks the context and arguments for each call", function()
		local callTracker = CallTracker.new()

		callTracker:track({ object = {}, args = {} })
		callTracker:track({ object = {}, args = { 0, "foo" } })

		expect(callTracker:all()[1]).toEqual({ object = {}, args = {} })

		expect(callTracker:all()[2]).toEqual({ object = {}, args = { 0, "foo" } })
	end)

	it("simplifies access to the arguments for the last (most recent) call", function()
		local callTracker = CallTracker.new()

		callTracker:track()
		callTracker:track({ object = {}, args = { 0, "foo" } })

		expect(callTracker:mostRecent()).toEqual({
			object = {},
			args = { 0, "foo" },
		})
	end)

	it("returns a useful falsy value when there isn't a last (most recent) call", function()
		local callTracker = CallTracker.new()

		expect(callTracker:first()).toBe(nil)
	end)

	it("allows the tracking to be reset", function()
		local callTracker = CallTracker.new()

		callTracker:track()
		callTracker:track({ object = {}, args = { 0, "foo" } })
		callTracker:reset()

		expect(callTracker:any()).toBe(false)
		expect(callTracker:count()).toEqual(0)
		expect(callTracker:argsFor(0)).toEqual({})
		expect(callTracker:all()).toEqual({})
		expect(callTracker:mostRecent()).toBeFalsy()
	end)

	-- ROBLOX deviation: test skipped because jest's implementation of CallTracker
	-- omits the saveArgumentsByValue function
	itSKIP("allows object arguments to be shallow cloned", function()
		--[[
			var callTracker = new jasmineUnderTest.CallTracker();
			callTracker.saveArgumentsByValue();

			var objectArg = { foo: 'bar' },
				arrayArg = ['foo', 'bar'];

			callTracker.track({
				object: {},
				args: [objectArg, arrayArg, false, undefined, null, NaN, '', 0, 1.0]
			});

			expect(callTracker.mostRecent().args[0]).not.toBe(objectArg);
			expect(callTracker.mostRecent().args[0]).toEqual(objectArg);
			expect(callTracker.mostRecent().args[1]).not.toBe(arrayArg);
			expect(callTracker.mostRecent().args[1]).toEqual(arrayArg);
		]]
	end)

	-- ROBLOX deviation: test skipped because jest's implementation of CallTracker
	-- omits the saveArgumentsByValue function
	itSKIP("saves primitive arguments by value", function()
		--[[
			var callTracker = new jasmineUnderTest.CallTracker(),
				args = [undefined, null, false, '', /\s/, 0, 1.2, NaN];

			callTracker.saveArgumentsByValue();
			callTracker.track({ object: {}, args: args });

			expect(callTracker.mostRecent().args).toEqual(args);
		]]
	end)
end)

return {}
