-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/expect/src/__tests__/asymmetricMatchers.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

return (function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	type Function = (...any) -> ...any

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local expect = JestGlobals.expect
	local test = (JestGlobals.test :: any) :: Function

	local RegExp = require(Packages.RegExp)

	local AsymmetricMatchers = require(CurrentModule.asymmetricMatchers)
	local any = AsymmetricMatchers.any
	local anything = AsymmetricMatchers.anything
	local arrayContaining = AsymmetricMatchers.arrayContaining
	local arrayNotContaining = AsymmetricMatchers.arrayNotContaining
	local objectContaining = AsymmetricMatchers.objectContaining
	local objectNotContaining = AsymmetricMatchers.objectNotContaining
	local stringContaining = AsymmetricMatchers.stringContaining
	local stringNotContaining = AsymmetricMatchers.stringNotContaining
	local stringMatching = AsymmetricMatchers.stringMatching
	local stringNotMatching = AsymmetricMatchers.stringNotMatching

	-- ROBLOX deviation START: additional dependencies
	local RobloxShared = require(Packages.RobloxShared)
	local nodeUtils = RobloxShared.nodeUtils
	local JSON = nodeUtils.JSON
	-- ROBLOX deviation END

	test("Any.asymmetricMatch()", function()
		-- ROBLOX deviation START: no primitive constructors in lua, we just supply a primitive
		for _, test in
			{
				any("string"):asymmetricMatch("jest"),
				any("number"):asymmetricMatch(1),
				any("function"):asymmetricMatch(function() end),
				any("boolean"):asymmetricMatch(true),
				-- ROBLOX deviation: omitted BigInt and Symbol
				any("table"):asymmetricMatch({}),
				-- ROBLOX deviation: typeof(nil) is nil in Lua, not object, so test below is omitted
				-- any("table"):asymmetricMatch(nil),
			}
		do
			expect(test).toBe(true)
		end
		-- ROBLOX deviation END
	end)

	-- ROBLOX deviation START: custom test for the Any matcher with Lua prototypes
	test("Any.asymmetricMatch() with Lua prototypical classes", function()
		local ThingOne = {}
		ThingOne.__index = ThingOne
		function ThingOne.new()
			local self = {}
			setmetatable(self, ThingOne)
			return self
		end

		local ThingTwo = {}
		ThingTwo.__index = ThingTwo
		function ThingTwo.new()
			local self = {}
			setmetatable(self, ThingTwo)
			return self
		end

		local ChildThingOne = {}
		ChildThingOne.__index = ChildThingOne
		setmetatable(ChildThingOne, ThingOne)
		function ChildThingOne.new()
			local self = {}
			setmetatable(self, ChildThingOne)
			return self
		end

		local GrandchildThingOne = {}
		GrandchildThingOne.__index = GrandchildThingOne
		setmetatable(GrandchildThingOne, ChildThingOne)
		function GrandchildThingOne.new()
			local self = {}
			setmetatable(self, GrandchildThingOne)
			return self
		end

		expect(any(ThingOne):asymmetricMatch(ThingOne.new())).toBe(true)
		expect(any(ThingOne):asymmetricMatch(ThingTwo.new())).toBe(false)
		expect(any(ThingTwo):asymmetricMatch(ThingOne.new())).toBe(false)
		expect(any(ThingTwo):asymmetricMatch(ThingTwo.new())).toBe(true)

		expect(any(ChildThingOne):asymmetricMatch(ChildThingOne.new())).toBe(true)
		expect(any(ThingOne):asymmetricMatch(ChildThingOne.new())).toBe(true)
		expect(any(ThingTwo):asymmetricMatch(ChildThingOne.new())).toBe(false)
		expect(any(GrandchildThingOne):asymmetricMatch(ChildThingOne.new())).toBe(false)

		expect(any(ThingOne):asymmetricMatch(GrandchildThingOne.new())).toBe(true)
		expect(any(ChildThingOne):asymmetricMatch(GrandchildThingOne.new())).toBe(true)
		expect(any(ThingTwo):asymmetricMatch(GrandchildThingOne.new())).toBe(false)
	end)
	-- ROBLOX deviation END

	-- ROBLOX deviation start: ommiting because Lua doesn't have primitive wrapper classes
	-- test('Any.asymmetricMatch() on primitive wrapper classes', function()
	-- 	for _, test in ipairs({
	-- 		-- eslint-disable-next-line no-new-wrappers
	-- 		any("string"):asymmetricMatch(new String('jest')),
	-- 		-- eslint-disable-next-line no-new-wrappers
	-- 		any("number"):asymmetricMatch(new Number(1)),
	-- 		-- eslint-disable-next-line no-new-func
	-- 		any("function"):asymmetricMatch(new Function('() => {}')),
	-- 		-- eslint-disable-next-line no-new-wrappers
	-- 		any("boolean"):asymmetricMatch(new Boolean(true)),
	-- 		-- ROBLOX deviation: omitted BigInt and Symbol
	-- 	}) do
	-- 	expect(test).toBe(true);
	-- 	end
	-- end)
	-- ROBLOX deviation end

	test("Any.toAsymmetricMatcher()", function()
		expect(any("number"):toAsymmetricMatcher()).toBe("Any<number>")
	end)

	test("Any.toAsymmetricMatcher() with function", function()
		expect(any("function"):toAsymmetricMatcher()).toBe("Any<function>")
	end)

	test("Any throws when called with empty constructor", function()
		expect(function()
			any()
		end).toThrow()
	end)

	test("Anything matches any type", function()
		for _, test in
			ipairs({
				anything():asymmetricMatch("jest"),
				anything():asymmetricMatch(1),
				anything():asymmetricMatch(function() end),
				anything():asymmetricMatch(true),
				anything():asymmetricMatch({ x = 1 }),
				anything():asymmetricMatch({ 1, 2 }),
			})
		do
			expect(test).toBe(true)
		end
	end)

	-- ROBLOX deviation: no undefined
	test("Anything does not match nil", function()
		expect(anything():asymmetricMatch(nil)).toBe(false)
	end)

	test("Anything.toAsymmetricMatcher()", function()
		expect(anything():toAsymmetricMatcher()).toBe("Anything")
	end)

	test("ArrayContaining matches", function()
		for _, test in
			{
				arrayContaining({}):asymmetricMatch("jest"),
				arrayContaining({ "foo" }):asymmetricMatch({ "foo" }),
				arrayContaining({ "foo" }):asymmetricMatch({ "foo", "bar" }),
				arrayContaining({}):asymmetricMatch({}),
			}
		do
			expect(test).toEqual(true)
		end
	end)

	test("ArrayContaining does not match", function()
		expect(arrayContaining({ "foo" }):asymmetricMatch({ "bar" })).toBe(false)
	end)

	test("ArrayContaining throws for non-arrays", function()
		expect(function()
			arrayContaining("foo"):asymmetricMatch({})
		end).toThrow()
		-- ROBLOX deviation: additional test for non-arraylike tables
		expect(function()
			arrayContaining({ x = 1 }):asymmetricMatch({})
		end).toThrow()
	end)

	test("ArrayNotContaining matches", function()
		expect(arrayNotContaining({ "foo" }):asymmetricMatch({ "bar" })).toBe(true)
	end)

	test("ArrayNotContaining does not match", function()
		for _, test in
			{
				arrayNotContaining({}):asymmetricMatch("jest"),
				arrayNotContaining({ "foo" }):asymmetricMatch({ "foo" }),
				arrayNotContaining({ "foo" }):asymmetricMatch({ "foo", "bar" }),
				arrayNotContaining({}):asymmetricMatch({}),
			}
		do
			expect(test).toEqual(false)
		end
	end)

	test("ArrayNotContaining throws for non-arrays", function()
		expect(function()
			arrayNotContaining("foo"):asymmetricMatch({})
		end).toThrow()
		-- ROBLOX deviation START: additional test for non-arraylike tables
		expect(function()
			arrayNotContaining({ x = 1 }):asymmetricMatch({})
		end).toThrow()
		-- ROBLOX deviation END
	end)

	test("ObjectContaining matches", function()
		for _, test in
			ipairs({
				objectContaining({}):asymmetricMatch("jest"),
				objectContaining({ foo = "foo" }):asymmetricMatch({ foo = "foo", jest = "jest" }),
				-- ROBLOX deviation START: can't have nil values in table
				objectContaining({ foo = "undefined" }):asymmetricMatch({ foo = "undefined" }),
				-- ROBLOX deviation END
				objectContaining({ first = objectContaining({ second = {} }) }):asymmetricMatch({
					first = { second = {} },
				}),
				-- ROBLOX deviation start: skipping - Lua doesn't have buffer type
				-- objectContaining({foo = Buffer.from('foo')}):asymmetricMatch({
				-- 	foo = Buffer.from('foo'),
				-- 	jest = 'jest',
				-- }),
				-- ROBLOX deviation end
			})
		do
			expect(test).toEqual(true)
		end
	end)

	test("ObjectContaining does not match", function()
		for _, test in
			{
				objectContaining({ foo = "foo" }):asymmetricMatch({ bar = "bar" }),
				objectContaining({ foo = "foo" }):asymmetricMatch({ foo = "foox" }),
				-- ROBLOX deviation: can't have nil values in table
				objectContaining({ foo = "undefined" }):asymmetricMatch({}),
				objectContaining({
					answer = 42,
					foo = { bar = "baz", foobar = "qux" },
				}):asymmetricMatch({ foo = { bar = "baz" } }),
			}
		do
			expect(test).toEqual(false)
		end
	end)

	test("ObjectContaining matches defined properties", function()
		local definedPropertyObject = {}
		definedPropertyObject.foo = "bar"
		expect(objectContaining({ foo = "bar" }):asymmetricMatch(definedPropertyObject)).toBe(true)
	end)

	-- ROBLOX deviation: omitted prototype properties test, same as the others in Lua

	test("ObjectContaining throws for non-objects", function()
		expect(function()
			objectContaining(1337):asymmetricMatch()
		end).toThrow()
	end)

	test("ObjectContaining does not mutate the sample", function()
		local sample = { foo = { bar = {} } }
		local sample_json = JSON.stringify(sample)
		expect({ foo = { bar = {} } }).toEqual(objectContaining(sample))
		objectContaining(sample)

		expect(JSON.stringify(sample)).toEqual(sample_json)
	end)

	test("ObjectNotContaining matches", function()
		for _, test in
			{
				objectNotContaining({ foo = "foo" }):asymmetricMatch({ bar = "bar" }),
				objectNotContaining({ foo = "foo" }):asymmetricMatch({ foo = "foox" }),
				-- ROBLOX deviation: can't have nil values in table
				objectNotContaining({ foo = "undefined" }):asymmetricMatch({}),
				objectNotContaining({
					first = objectNotContaining({ second = {} }),
				}):asymmetricMatch({ first = { second = {} } }),
				objectNotContaining({ first = { second = {}, third = {} } }):asymmetricMatch({
					first = { second = {} },
				}),
				objectNotContaining({ first = { second = {} } }):asymmetricMatch({
					first = { second = {}, third = {} },
				}),
				objectNotContaining({ foo = "foo", jest = "jest" }):asymmetricMatch({
					foo = "foo",
				}),
			}
		do
			expect(test).toEqual(true)
		end
	end)

	test("ObjectNotContaining does not match", function()
		for _, test in
			ipairs({
				objectNotContaining({}):asymmetricMatch("jest"),
				objectNotContaining({ foo = "foo" }):asymmetricMatch({
					foo = "foo",
					jest = "jest",
				}),
				-- ROBLOX deviation: can't have nil values in table
				objectNotContaining({ foo = "undefined" }):asymmetricMatch({ foo = "undefined" }),
				objectNotContaining({ first = { second = {} } }):asymmetricMatch({
					first = { second = {} },
				}),
				objectNotContaining({
					first = objectContaining({ second = {} }),
				}):asymmetricMatch({ first = { second = {} } }),
				objectNotContaining({}):asymmetricMatch(nil),
				objectNotContaining({}):asymmetricMatch({}),
			})
		do
			expect(test).toBe(false)
		end
	end)

	test("ObjectNotContaining inverts ObjectContaining", function()
		for _, ref in
			{
				{ {}, nil },
				{ { foo = "foo" }, { foo = "foo", jest = "jest" } },
				{ { foo = "foo", jest = "jest" }, { foo = "foo" } },
				-- ROBLOX deviation: can't have nil values in table
				{ { foo = "undefined" }, { foo = "undefined" } },
				-- ROBLOX deviation: can't have nil values in table
				{ { foo = "undefined" }, {} },
				{ { first = { second = {} } }, { first = { second = {} } } },
				{ { first = objectContaining({ second = {} }) }, { first = { second = {} } } },
				{ { first = objectNotContaining({ second = {} }) }, { first = { second = {} } } },
				-- ROBLOX deviation: can't have nil values in table
				{ {}, { foo = "undefined" } },
			}
		do
			local sample, received = table.unpack(ref, 1, 2)
			expect(objectNotContaining(sample):asymmetricMatch(received)).toEqual(
				not objectContaining(sample):asymmetricMatch(received)
			)
		end
	end)

	test("ObjectNotContaining throws for non-objects", function()
		expect(function()
			objectNotContaining(1337):asymmetricMatch()
		end).toThrow()
	end)

	test("StringContaining matches string against string", function()
		expect(stringContaining("en*"):asymmetricMatch("queen*")).toBe(true)
		expect(stringContaining("en"):asymmetricMatch("queue")).toBe(false)
	end)

	test("StringContaining throws if expected value is not string", function()
		expect(function()
			stringContaining({ 1 }):asymmetricMatch("queen")
		end).toThrow()
	end)

	test("StringContaining returns false if received value is not string", function()
		expect(stringContaining("en*"):asymmetricMatch(1)).toBe(false)
	end)

	test("StringNotContaining matches string against string", function()
		expect(stringNotContaining("en*"):asymmetricMatch("queen*")).toBe(false)
		expect(stringNotContaining("en"):asymmetricMatch("queue")).toBe(true)
	end)

	test("StringNotContaining throws if expected value is not string", function()
		expect(function()
			stringNotContaining({ 1 }):asymmetricMatch("queen")
		end).toThrow()
	end)

	test("StringNotContaining returns true if received value is not string", function()
		expect(stringNotContaining("en*"):asymmetricMatch(1)).toBe(true)
	end)

	test("StringMatching matches string against regexp", function()
		expect(stringMatching(RegExp("en")):asymmetricMatch("queen")).toBe(true)
		expect(stringMatching(RegExp("en")):asymmetricMatch("queue")).toBe(false)
	end)

	-- ROBLOX deviation: Lua pattern test not included in upstream
	test("StringMatching matches string against pattern", function()
		expect(stringMatching("e+"):asymmetricMatch("queen")).toBe(true)
		expect(stringMatching("%s"):asymmetricMatch("queue")).toBe(false)
	end)

	test("StringMatching matches string against string", function()
		expect(stringMatching("en"):asymmetricMatch("queen")).toBe(true)
		expect(stringMatching("en"):asymmetricMatch("queue")).toBe(false)
	end)

	test("StringMatching throws if expected value is neither string nor regexp", function()
		expect(function()
			stringMatching({ 1 }):asymmetricMatch("queen")
		end).toThrow()
	end)

	test("StringMatching returns false if received value is not string", function()
		expect(stringMatching("en"):asymmetricMatch(1)).toBe(false)
	end)

	test("StringMatching returns false even if coerced non-string received value matches pattern", function()
		expect(stringMatching("nil"):asymmetricMatch(nil)).toBe(false)
	end)

	test("StringNotMatching matches string against regexp", function()
		expect(stringNotMatching(RegExp("en")):asymmetricMatch("queen")).toBe(false)
		expect(stringNotMatching(RegExp("en")):asymmetricMatch("queue")).toBe(true)
	end)

	-- ROBLOX deviation: Lua pattern test not included in upstream
	test("StringNotMatching matches string against pattern", function()
		expect(stringNotMatching("e+"):asymmetricMatch("queen")).toBe(false)
		expect(stringNotMatching("%s"):asymmetricMatch("queue")).toBe(true)
	end)

	test("StringNotMatching matches string against string", function()
		expect(stringNotMatching("en"):asymmetricMatch("queen")).toBe(false)
		expect(stringNotMatching("en"):asymmetricMatch("queue")).toBe(true)
	end)

	test("StringNotMatching throws if expected value is neither string nor regexp", function()
		expect(function()
			stringNotMatching({ 1 }):asymmetricMatch("queen")
		end).toThrow()
	end)

	test("StringNotMatching returns true if received value is not string", function()
		expect(stringNotMatching("en"):asymmetricMatch(1)).toBe(true)
	end)

	return {}
end)()
