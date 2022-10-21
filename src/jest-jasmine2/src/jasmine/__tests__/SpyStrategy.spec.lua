--!nocheck
-- ROBLOX upstream: https://github.com/jasmine/jasmine/blob/v3.6.0/spec/core/SpyStrategySpec.js
--[[
	Our usual upstream of jest v27.4.7 doesn't include any tests for the
	SpyStrategy file so we instead look to the source that the jest/jasmine2
	is based off of, jasmine
]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local SpyStrategy = require(CurrentModule.SpyStrategy)
local createSpy = require(CurrentModule.createSpy)

local Promise = require(Packages.Dev.Promise)

describe("SpyStrategy", function()
	it("defaults its name to unknown", function()
		local spyStrategy = SpyStrategy.new()

		expect(spyStrategy.identity).toBe("unknown")
	end)

	it("takes a name", function()
		local spyStrategy = SpyStrategy.new({ name = "foo" })

		expect(spyStrategy.identity).toBe("foo")
	end)

	it("stubs an original function, if provided", function()
		local originalFn = createSpy("original")
		local spyStrategy = SpyStrategy.new({ fn = originalFn })

		spyStrategy:exec()

		expect(originalFn).never.toHaveBeenCalled()
	end)

	it("allows an original function to be called, passed through the params and returns it's value", function()
		local originalFn = createSpy("original").andAlso:returnValue(42)
		local spyStrategy = SpyStrategy.new({ fn = originalFn })

		spyStrategy:callThrough()
		local returnValue = spyStrategy:exec(1, { "foo" })

		expect(originalFn).toHaveBeenCalled()
		expect(originalFn.calls:mostRecent().args).toEqual({ 1, { "foo" } })
		expect(returnValue).toBe(42)
	end)

	it("can return a specified value when executed", function()
		local originalFn = createSpy("original")
		local spyStrategy = SpyStrategy.new({ fn = originalFn })
		local returnValue

		spyStrategy:returnValue(17)
		returnValue = spyStrategy:exec()

		expect(originalFn).never.toHaveBeenCalled()
		expect(returnValue).toBe(17)
	end)

	it("can return specified values in order specified when executed", function()
		local originalFn = createSpy("original")
		local spyStrategy = SpyStrategy.new({ fn = originalFn })

		spyStrategy:returnValues("value1", "value2", "value3")

		expect(spyStrategy:exec()).toBe("value1")
		expect(spyStrategy:exec()).toBe("value2")
		expect(spyStrategy:exec()).toBe("value3")
		expect(spyStrategy:exec()).toBe(nil)
		expect(originalFn).never.toHaveBeenCalled()
	end)

	it("allows an exception to be thrown when executed", function()
		local originalFn = createSpy("original")
		local spyStrategy = SpyStrategy.new({ fn = originalFn })

		spyStrategy:throwError("bar")

		expect(function()
			spyStrategy:exec()
		end).toThrow("bar")

		expect(originalFn).never.toHaveBeenCalled()
	end)

	-- ROBLOX NOTE: test  translation is identical to the one above
	it("allows a string to be thrown, wrapping it into an exception when executed", function()
		local originalFn = createSpy("original")
		local spyStrategy = SpyStrategy.new({ fn = originalFn })

		spyStrategy:throwError("bar")

		expect(function()
			spyStrategy:exec()
		end).toThrow("bar")

		expect(originalFn).never.toHaveBeenCalled()
	end)

	it("allows a non-Error to be thrown when executed", function()
		local originalFn = createSpy("original")
		local spyStrategy = SpyStrategy.new({ fn = originalFn })

		spyStrategy:throwError({ code = "ESRCH" })

		local ok, err = pcall(function()
			spyStrategy:exec()
		end)
		expect(ok).toBe(false)
		expect(err).toEqual({ code = "ESRCH" })

		expect(originalFn).never.toHaveBeenCalled()
	end)

	it("allows a fake function to be called instead", function()
		local originalFn = createSpy("original")
		local fakeFn = createSpy("fake").andAlso:returnValue(67)
		local spyStrategy = SpyStrategy.new({ fn = originalFn })
		local returnValue

		spyStrategy:callFake(fakeFn)
		returnValue = spyStrategy:exec()

		expect(originalFn).never.toHaveBeenCalled()
		expect(returnValue).toBe(67)
	end)

	it("allows a fake async function to be called instead", function()
		local originalFn = createSpy("original")
		local fakeFn = createSpy("fake").andAlso:callFake(function()
			return Promise.new(function(resolve, reject)
				resolve(67)
			end)
		end)

		local spyStrategy = SpyStrategy.new({ fn = originalFn })

		--[[
				deviation: we use a Promise library to model the functionality
				of the upstream test
				Library: (https://github.com/evaera/roblox-lua-promise)
			]]
		spyStrategy:callFake(fakeFn)
		spyStrategy
			:exec()
			:andThen(function(returnValue)
				expect(originalFn).never.toHaveBeenCalled()
				expect(fakeFn.calls:any()).toBe(true)
				expect(returnValue).toBe(67)
			end)
			:catch(function(err)
				error(err)
			end)
	end)

	--[[
			deviation: all tests under the #resolveTo and #rejectWith describe
			blocks are omitted because our upstream (jest) does not replicate
			the resolveTo and rejectWith functions of jasmine so we do not need
			to provide tests

			For the same reason as above, tests with customStrategies are omitted
		]]

	-- ROBLOX TODO: provide a translation of this test once we have a
	-- translation for the spyRegistry file (and therefore can use spyOn)
	it.skip("throws an error when a non-function is passed to callFake strategy", function()
		--[[
				var originalFn = jasmine.createSpy('original'),
			      spyStrategy = new jasmineUnderTest.SpyStrategy({ fn: originalFn });

				spyOn(jasmineUnderTest, 'isFunction_').and.returnValue(false);
				spyOn(jasmineUnderTest, 'isAsyncFunction_').and.returnValue(false);

				expect(function() {
					spyStrategy.callFake(function() {});
				}).toThrowError(/^Argument passed to callFake should be a function, got/);

				expect(function() {
					spyStrategy.callFake(function() {});
				}).toThrowError(/^Argument passed to callFake should be a function, got/);
			]]
	end)

	it("allows a return to plan stubbing after another strategy", function()
		local originalFn = createSpy("original")
		local fakeFn = createSpy("fake").andAlso:returnValue(67)
		local spyStrategy = SpyStrategy.new({ fn = originalFn })
		local returnValue

		spyStrategy:callFake(fakeFn)
		returnValue = spyStrategy:exec()

		expect(originalFn).never.toHaveBeenCalled()
		expect(returnValue).toBe(67)

		spyStrategy:stub()
		returnValue = spyStrategy:exec()

		expect(returnValue).toBe(nil)
	end)

	it("returns the spy after changing the strategy", function()
		local spy = {}
		local spyFn = createSpy("spyFn").andAlso:returnValue(spy)
		local spyStrategy = SpyStrategy.new({ getSpy = spyFn })

		expect(spyStrategy:callThrough()).toBe(spy)
		expect(spyStrategy:returnValue()).toBe(spy)
		expect(spyStrategy:throwError()).toBe(spy)
		expect(spyStrategy:callFake(function() end)).toBe(spy)
		expect(spyStrategy:stub()).toBe(spy)
	end)
end)
