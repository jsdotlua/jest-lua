-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/expect/src/__tests__/asymmetricMatchers.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local RegExp = require(Packages.RegExp)

	local HttpService = game:GetService("HttpService")

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

	it("Any.asymmetricMatch()", function()
		-- ROBLOX deviation: no primitive constructors in lua, we just supply a primitive
		for _, test in ipairs(
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
		) do
			expect(test).to.equal(true)
		end
	end)

	-- ROBLOX deviation: custom test for the Any matcher with Lua prototypes
	it("Any.asymmetricMatch() with Lua prototypical classes", function()
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

		expect(any(ThingOne):asymmetricMatch(ThingOne.new())).to.equal(true)
		expect(any(ThingOne):asymmetricMatch(ThingTwo.new())).to.equal(false)
		expect(any(ThingTwo):asymmetricMatch(ThingOne.new())).to.equal(false)
		expect(any(ThingTwo):asymmetricMatch(ThingTwo.new())).to.equal(true)

		expect(any(ChildThingOne):asymmetricMatch(ChildThingOne.new())).to.equal(true)
		expect(any(ThingOne):asymmetricMatch(ChildThingOne.new())).to.equal(true)
		expect(any(ThingTwo):asymmetricMatch(ChildThingOne.new())).to.equal(false)
		expect(any(GrandchildThingOne):asymmetricMatch(ChildThingOne.new())).to.equal(false)

		expect(any(ThingOne):asymmetricMatch(GrandchildThingOne.new())).to.equal(true)
		expect(any(ChildThingOne):asymmetricMatch(GrandchildThingOne.new())).to.equal(true)
		expect(any(ThingTwo):asymmetricMatch(GrandchildThingOne.new())).to.equal(false)
	end)

	-- ROBLOX deviation start: ommiting because Lua doesn't have primitive wrapper classes
	-- it('Any.asymmetricMatch() on primitive wrapper classes', function()
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
	-- 		expect(test).toBe(true);
	-- 	end
	-- end)
	-- ROBLOX deviation end

	it("Any.toAsymmetricMatcher()", function()
		expect(any("number"):toAsymmetricMatcher()).to.equal("Any<number>")
	end)

	it('Any.toAsymmetricMatcher() with function', function()
		expect(any("function"):toAsymmetricMatcher()).to.equal('Any<function>')
	end)

	it("Any throws when called with empty constructor", function()
		expect(function() any() end).to.throw()
	end)

	it("Anything matches any type", function()
		for _, test in ipairs(
			{
				anything():asymmetricMatch("jest"),
				anything():asymmetricMatch(1),
				anything():asymmetricMatch(function() end),
				anything():asymmetricMatch(true),
				anything():asymmetricMatch({x = 1}),
				anything():asymmetricMatch({1, 2}),
			}
		) do
			expect(test).to.equal(true)
		end
	end)

	-- ROBLOX deviation: no undefined
	it("Anything does not match nil", function()
		expect(anything():asymmetricMatch(nil)).to.equal(false)
	end)

	it("Anything.toAsymmetricMatcher()", function()
		expect(anything():toAsymmetricMatcher()).to.equal("Anything")
	end)

	it("ArrayContaining matches", function()
		for _, test in ipairs(
			{
				arrayContaining({}):asymmetricMatch("jest"),
				arrayContaining({"foo"}):asymmetricMatch({"foo"}),
				arrayContaining({"foo"}):asymmetricMatch({"foo", "bar"}),
				arrayContaining({}):asymmetricMatch({}),
			}
		) do
			expect(test).to.equal(true)
		end
	end)

	it("ArrayContaining does not match", function()
		expect(arrayContaining({"foo"}):asymmetricMatch({"bar"})).to.equal(false)
	end)

	it("ArrayContaining throws for non-arrays", function()
		expect(function()
			arrayContaining('foo'):asymmetricMatch({})
		end).to.throw()
		-- ROBLOX deviation: additional test for non-arraylike tables
		expect(function()
			arrayContaining({x = 1}):asymmetricMatch({})
		end).to.throw()
	end)

	it("ArrayNotContaining matches", function()
		expect(arrayNotContaining({"foo"}):asymmetricMatch({"bar"})).to.equal(true)
	end)

	it("ArrayNotContaining does not match", function()
		for _, test in ipairs(
			{
				arrayNotContaining({}):asymmetricMatch("jest"),
				arrayNotContaining({"foo"}):asymmetricMatch({"foo"}),
				arrayNotContaining({"foo"}):asymmetricMatch({"foo", "bar"}),
				arrayNotContaining({}):asymmetricMatch({}),
			}
		) do
			expect(test).to.equal(false)
		end
	end)

	it("ArrayNotContaining throws for non-arrays", function()
		expect(function()
			arrayNotContaining('foo'):asymmetricMatch({})
		end).to.throw()
		-- ROBLOX deviation: additional test for non-arraylike tables
		expect(function()
			arrayNotContaining({x = 1}):asymmetricMatch({})
		end).to.throw()
	end)

	it("ObjectContaining matches", function()
		for _, test in ipairs(
			{
				objectContaining({}):asymmetricMatch("jest"),
				objectContaining({foo = "foo"}):asymmetricMatch({foo = "foo", jest = "jest"}),
				-- ROBLOX deviation: can't have nil values in table
				objectContaining({foo = "undefined"}):asymmetricMatch({foo = "undefined"}),
				objectContaining({first = objectContaining({second = {}})}):asymmetricMatch({
					first = {second = {}},
				}),
				-- ROBLOX deviation start: skipping - Lua doesn't have buffer type
				-- objectContaining({foo = Buffer.from('foo')}):asymmetricMatch({
				-- 	foo = Buffer.from('foo'),
				-- 	jest = 'jest',
				-- }),
				-- ROBLOX deviation end
			}
		) do
			expect(test).to.equal(true)
		end
	end)

	it("ObjectContaining does not match", function()
		for _, test in ipairs(
			{
				objectContaining({foo = "foo"}):asymmetricMatch({bar = "bar"}),
				objectContaining({foo = "foo"}):asymmetricMatch({foo = "foox"}),
				-- ROBLOX deviation: can't have nil values in table
				objectContaining({foo = "undefined"}):asymmetricMatch({}),
				objectContaining({
					answer = 42,
					foo = {bar = 'baz', foobar = 'qux'},
				  }):asymmetricMatch({foo = {bar = 'baz'}}),
			}
		) do
			expect(test).to.equal(false)
		end
	end)

	it("ObjectContaining matches defined properties", function()
		local definedPropertyObject = {}
		definedPropertyObject.foo = "bar"
		expect(
			objectContaining({foo = "bar"}):asymmetricMatch(definedPropertyObject)
		).to.equal(true)
	end)

	-- ROBLOX deviation: omitted prototype properties test, same as the others in Lua

	it("ObjectContaining throws for non-objects", function()
		expect(function()
			objectContaining(1337):asymmetricMatch()
		end).to.throw()
	end)

	it('ObjectContaining does not mutate the sample', function()
		local sample = {foo = {bar = {}}};
		local sample_json = HttpService:JSONEncode(sample);
		-- ROBLOX deviation: skipping expect
		-- expect({foo = {bar = {}}}).toEqual(objectContaining(sample));
		objectContaining(sample)

		expect(HttpService:JSONEncode(sample)).to.equal(sample_json);
	end);

	it('ObjectNotContaining matches', function()
		for _, test in
			ipairs({
				objectNotContaining({ foo = 'foo' }):asymmetricMatch({ bar = 'bar' }),
				objectNotContaining({ foo = 'foo' }):asymmetricMatch({ foo = 'foox' }),
				-- ROBLOX deviation: can't have nil values in table
				objectNotContaining({ foo = 'undefined' }):asymmetricMatch({}),
				objectNotContaining({
					first = objectNotContaining({ second = {} }),
				}):asymmetricMatch({ first = { second = {} } }),
				objectNotContaining({ first = { second = {}, third = {} } }):asymmetricMatch({
					first = { second = {} },
				}),
				objectNotContaining({ first = { second = {} } }):asymmetricMatch({
					first = { second = {}, third = {} },
				}),
				objectNotContaining({ foo = 'foo', jest = 'jest' }):asymmetricMatch({
					foo = 'foo',
				}),
			})
		do
			expect(test).to.equal(true)
		end
	end)

	it("ObjectNotContaining does not match", function()
		for _, test in ipairs(
			{
				objectNotContaining({}):asymmetricMatch('jest'),
				objectNotContaining({foo = "foo"}):asymmetricMatch({
					foo = "foo",
					jest = "jest"
				}),
				-- ROBLOX deviation: can't have nil values in table
				objectNotContaining({foo = "undefined"}):asymmetricMatch({foo = "undefined"}),
				objectNotContaining({first = {second = {}}}):asymmetricMatch({
					first = {second = {}},
				}),
				objectNotContaining({
					first = objectContaining({second = {}}),
				}):asymmetricMatch({first = {second = {}}}),
				objectNotContaining({}):asymmetricMatch(nil),
    			objectNotContaining({}):asymmetricMatch({}),
			}
		) do
			expect(test).to.equal(false)
		end
	end)

	it("ObjectNotContaining inverts ObjectContaining", function()
		for _, ref in
			ipairs({
				{ {}, nil },
				{ { foo = 'foo' }, { foo = 'foo', jest = 'jest' } },
				{ { foo = 'foo', jest = 'jest' }, { foo = 'foo' } },
				-- ROBLOX deviation: can't have nil values in table
				{ { foo = 'undefined' }, { foo = 'undefined' } },
				-- ROBLOX deviation: can't have nil values in table
				{ { foo = 'undefined' }, {} },
				{ { first = { second = {} } }, { first = { second = {} } } },
				{ { first = objectContaining({ second = {} }) }, { first = { second = {} } } },
				{ { first = objectNotContaining({ second = {} }) }, { first = { second = {} } } },
				-- ROBLOX deviation: can't have nil values in table
				{ {}, { foo = 'undefined' } },
			})
		do
			local sample, received = table.unpack(ref, 1, 2)
			expect(objectNotContaining(sample):asymmetricMatch(received)).to.equal(
				not objectContaining(sample):asymmetricMatch(received)
			)
		end
	end)

	it("ObjectNotContaining throws for non-objects", function()
		expect(function()
			objectNotContaining(1337):asymmetricMatch()
		end).to.throw()
	end)

	it("StringContaining matches string against string", function()
		expect(stringContaining("en*"):asymmetricMatch("queen*")).to.equal(true)
		expect(stringContaining("en"):asymmetricMatch("queue")).to.equal(false)
	end)

	it("StringContaining throws if expected value is not string", function()
		expect(function()
			stringContaining({1}):asymmetricMatch("queen")
		end).to.throw()
	end)

	it("StringContaining returns false if received value is not string", function()
		expect(stringContaining("en*"):asymmetricMatch(1)).to.equal(false)
	end)

	it("StringNotContaining matches string against string", function()
		expect(stringNotContaining("en*"):asymmetricMatch("queen*")).to.equal(false)
		expect(stringNotContaining("en"):asymmetricMatch("queue")).to.equal(true)
	end)

	it("StringNotContaining throws if expected value is not string", function()
		expect(function()
			stringNotContaining({1}):asymmetricMatch("queen")
		end).to.throw()
	end)

	it("StringNotContaining returns true if received value is not string", function()
		expect(stringNotContaining("en*"):asymmetricMatch(1)).to.equal(true)
	end)

	it('StringMatching matches string against regexp', function()
		expect(stringMatching(RegExp("en")):asymmetricMatch('queen')).to.equal(true)
		expect(stringMatching(RegExp("en")):asymmetricMatch('queue')).to.equal(false)
	end)

	-- ROBLOX deviation: Lua pattern test not included in upstream
	it("StringMatching matches string against pattern", function()
		expect(stringMatching("e+"):asymmetricMatch("queen")).to.equal(true)
		expect(stringMatching("%s"):asymmetricMatch("queue")).to.equal(false)
	end)

	it("StringMatching matches string against string", function()
		expect(stringMatching("en"):asymmetricMatch("queen")).to.equal(true)
		expect(stringMatching("en"):asymmetricMatch("queue")).to.equal(false)
	end)

	it("StringMatching throws if expected value is neither string nor regexp", function()
		expect(function()
			stringMatching({1}):asymmetricMatch("queen")
		end).to.throw()
	end)

	it("StringMatching returns false if received value is not string", function()
		expect(stringMatching("en"):asymmetricMatch(1)).to.equal(false)
	end)

	it("StringMatching returns false even if coerced non-string received value matches pattern", function()
		expect(stringMatching("nil"):asymmetricMatch(nil)).to.equal(false)
	end)

	it('StringNotMatching matches string against regexp', function()
		expect(stringNotMatching(RegExp("en")):asymmetricMatch('queen')).to.equal(false)
		expect(stringNotMatching(RegExp("en")):asymmetricMatch('queue')).to.equal(true)
	end)

	-- ROBLOX deviation: Lua pattern test not included in upstream
	it("StringNotMatching matches string against pattern", function()
		expect(stringNotMatching("e+"):asymmetricMatch("queen")).to.equal(false)
		expect(stringNotMatching("%s"):asymmetricMatch("queue")).to.equal(true)
	end)

	it("StringNotMatching matches string against string", function()
		expect(stringNotMatching("en"):asymmetricMatch("queen")).to.equal(false)
		expect(stringNotMatching("en"):asymmetricMatch("queue")).to.equal(true)
	end)

	it("StringNotMatching throws if expected value is neither string nor regexp", function()
		expect(function()
			stringNotMatching({1}):asymmetricMatch("queen")
		end).to.throw()
	end)

	it("StringNotMatching returns true if received value is not string", function()
		expect(stringNotMatching("en"):asymmetricMatch(1)).to.equal(true)
	end)
end
