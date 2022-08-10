--!nocheck
-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/expect/src/__tests__/extend.test.ts

-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

-- ROBLOX deviation: use `unknown` type until Luau starts to support it
type unknown = any

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local it = (JestGlobals.it :: any) :: Function
local beforeAll = (JestGlobals.beforeAll :: any) :: Function
local afterAll = (JestGlobals.afterAll :: any) :: Function

local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
local Symbol = LuauPolyfill.Symbol

local alignedAnsiStyleSerializer = require(Packages.Dev.TestUtils).alignedAnsiStyleSerializer

local matcherUtils = require(Packages.JestMatcherUtils)

local iterableEquality = require(CurrentModule.utils).iterableEquality
local subsetEquality = require(CurrentModule.utils).subsetEquality

local equals = require(CurrentModule.jasmineUtils).equals

local jestExpect = require(CurrentModule)

beforeAll(function()
	jestExpect.addSnapshotSerializer(alignedAnsiStyleSerializer)
end)

afterAll(function()
	jestExpect.resetSnapshotSerializers()
end)

jestExpect.extend({
	toBeDivisibleBy = function(self, actual: number, expected: number)
		local pass = actual % expected == 0
		local message = if pass
			then function()
				return string.format("expected %s not to be divisible by %s", tostring(actual), tostring(expected))
			end
			else function()
				return string.format("expected %s to be divisible by %s", tostring(actual), tostring(expected))
			end

		return { message = message, pass = pass }
	end,
	toBeSymbol = function(_self, actual, expected)
		local pass = actual == expected
		local message = function()
			return string.format("expected %s to be Symbol %s", tostring(actual), tostring(expected))
		end

		return { message = message, pass = pass }
	end,
	toBeWithinRange = function(_self, actual: number, floor: number, ceiling: number)
		local pass
		if type(actual) ~= "number" or type(floor) ~= "number" or type(ceiling) ~= "number" then
			pass = false
		else
			pass = actual >= floor and actual <= ceiling
		end
		local message = if pass
			then function()
				return string.format(
					"expected %s not to be within range %s - %s",
					tostring(actual),
					tostring(floor),
					tostring(ceiling)
				)
			end
			else function()
				return string.format(
					"expected %s to be within range %s - %s",
					tostring(actual),
					tostring(floor),
					tostring(ceiling)
				)
			end

		return { message = message, pass = pass }
	end,
})

it("is available globally when matcher is unary", function()
	jestExpect(15).toBeDivisibleBy(5)
	jestExpect(15).toBeDivisibleBy(3)
	jestExpect(15).never.toBeDivisibleBy(6)

	jestExpect(function()
		jestExpect(15).toBeDivisibleBy(2)
	end).toThrowErrorMatchingSnapshot()
end)

it("is available globally when matcher is variadic", function()
	jestExpect(15).toBeWithinRange(10, 20)
	jestExpect(15).never.toBeWithinRange(6)

	jestExpect(function()
		jestExpect(15).toBeWithinRange(1, 3)
	end).toThrowErrorMatchingSnapshot()
end)

-- ROBLOX TODO: ADO-1475
it("exposes matcherUtils in context", function()
	jestExpect.extend({
		_shouldNotError = function(self, _actual, _expected)
			local pass = self.equals(
				self.utils,
				Object.assign(matcherUtils, {
					iterableEquality = iterableEquality,
					subsetEquality = subsetEquality,
				})
			)
			local message
			if pass then
				message = function()
					return "expected this.utils to be defined in an extend call"
				end
			else
				message = function()
					return "expected this.utils not to be defined in an extend call"
				end
			end

			return { message = message, pass = pass }
		end,
	})

	jestExpect()._shouldNotError()
end)

it("is ok if there is no message specified", function()
	jestExpect.extend({
		toFailWithoutMessage = function(_, _expected)
			return { pass = false }
		end,
	})

	jestExpect(function()
		jestExpect(true).toFailWithoutMessage()
	end).toThrowErrorMatchingSnapshot()
end)

-- ROBLOX TODO: ADO-1475
it("exposes an equality function to custom matchers", function()
	-- jestExpect and expect share the same global state
	-- expect.assertions(3)
	jestExpect.extend({
		toBeOne = function(self)
			jestExpect(self.equals).toBe(equals)
			return { pass = not not self.equals(1, 1) }
		end,
	})

	jestExpect(function()
		jestExpect().toBeOne()
	end).never.toThrow()
end)

it("defines asymmetric unary matchers", function()
	jestExpect(function()
		jestExpect({ value = 2 }).toEqual({ value = jestExpect.toBeDivisibleBy(2) })
	end).never.toThrow()
	jestExpect(function()
		jestExpect({ value = 3 }).toEqual({ value = jestExpect.toBeDivisibleBy(2) })
	end).toThrowErrorMatchingSnapshot()
end)

it("defines asymmetric unary matchers that can be prefixed by never", function()
	jestExpect(function()
		jestExpect({ value = 2 }).toEqual({ value = jestExpect.never.toBeDivisibleBy(2) })
	end).toThrowErrorMatchingSnapshot()
	jestExpect(function()
		jestExpect({ value = 3 }).toEqual({ value = jestExpect.never.toBeDivisibleBy(2) })
	end).never.toThrow()
end)

it("defines asymmetric variadic matchers", function()
	jestExpect(function()
		jestExpect({ value = 2 }).toEqual({ value = jestExpect.toBeWithinRange(1, 3) })
	end).never.toThrow()
	jestExpect(function()
		jestExpect({ value = 3 }).toEqual({ value = jestExpect.toBeWithinRange(4, 11) })
	end).toThrowErrorMatchingSnapshot()
end)

it("defines asymmetric variadic matchers that can be prefixed by never", function()
	jestExpect(function()
		jestExpect({ value = 2 }).toEqual({
			value = jestExpect.never.toBeWithinRange(1, 3),
		})
	end).toThrowErrorMatchingSnapshot()
	jestExpect(function()
		jestExpect({ value = 3 }).toEqual({
			value = jestExpect.never.toBeWithinRange(5, 7),
		})
	end).never.toThrow()
end)

it("prints the Symbol into the error message", function()
	local foo = Symbol("foo")
	local bar = Symbol("bar")

	jestExpect(function()
		jestExpect({ a = foo }).toEqual({
			a = jestExpect.toBeSymbol(bar),
		})
	end).toThrowErrorMatchingSnapshot()
end)

it("allows overriding existing extension", function()
	jestExpect.extend({
		toAllowOverridingExistingMatcher = function(_self, _expected: unknown)
			return { pass = _expected == "bar" }
		end,
	})
	jestExpect("foo").never.toAllowOverridingExistingMatcher()
	jestExpect.extend({
		toAllowOverridingExistingMatcher = function(_self, _expected: unknown)
			return { pass = _expected == "foo" }
		end,
	})
	jestExpect("foo").toAllowOverridingExistingMatcher()
end)

-- ROBLOX deviation START: lua specific test to handle asymmetric unary matcher with a table argument
it("works for asymmetric unary matchers with a table argument", function()
	local input = { 1, 2, 3 }
	jestExpect.extend({
		unaryShouldNotError = function(_self, _actual, sample)
			local pass = sample == input
			return { pass = pass }
		end,
	})
	jestExpect(function()
		jestExpect({ value = 0 }).toEqual({ value = jestExpect.unaryShouldNotError(input) })
	end).never.toThrow()
end)
-- ROBLOX deviation END

return {}
