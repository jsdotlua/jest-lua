--!nonstrict
-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/expect/src/__tests__/asymmetricMatchers.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]
local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
-- ROBLOX deviation START: not used
-- local Object = LuauPolyfill.Object
-- local Symbol = LuauPolyfill.Symbol
-- local Promise = require(Packages.Promise)
-- ROBLOX deviation END
local JestGlobals = require(Packages.Dev.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
-- ROBLOX deviation START: not used
-- local jest = JestGlobals.jest
-- ROBLOX deviation END
local test = JestGlobals.test

-- ROBLOX deviation START: add RegExp
local RegExp = require(Packages.RegExp)
-- ROBLOX deviation END
-- ROBLOX deviation START: jestExpect
-- local jestExpect = require(script.Parent.Parent).default
local jestExpect = require(script.Parent.Parent)
-- ROBLOX deviation END
local asymmetricMatchersModule = require(script.Parent.Parent.asymmetricMatchers)
local any = asymmetricMatchersModule.any
local anything = asymmetricMatchersModule.anything
local arrayContaining = asymmetricMatchersModule.arrayContaining
local arrayNotContaining = asymmetricMatchersModule.arrayNotContaining
local closeTo = asymmetricMatchersModule.closeTo
local notCloseTo = asymmetricMatchersModule.notCloseTo
local nothing = asymmetricMatchersModule.nothing
local objectContaining = asymmetricMatchersModule.objectContaining
local objectNotContaining = asymmetricMatchersModule.objectNotContaining
local stringContaining = asymmetricMatchersModule.stringContaining
local stringNotContaining = asymmetricMatchersModule.stringNotContaining
local stringMatching = asymmetricMatchersModule.stringMatching
local stringNotMatching = asymmetricMatchersModule.stringNotMatching

-- ROBLOX deviation START: additional dependencies
local RobloxShared = require(Packages.RobloxShared)
local JSON = RobloxShared.nodeUtils.JSON
-- ROBLOX deviation END
test("Any.asymmetricMatch()", function()
	type Thing = {}
	type Thing_statics = { new: () -> Thing }
	local Thing = {} :: Thing & Thing_statics;
	(Thing :: any).__index = Thing
	function Thing.new(): Thing
		local self = setmetatable({}, Thing)
		return (self :: any) :: Thing
	end
	Array.forEach({
		-- ROBLOX deviation START: no primitive constructors in lua, we just supply a primitive
		-- any(String):asymmetricMatch("jest"),
		-- any(Number):asymmetricMatch(1),
		-- any(Function):asymmetricMatch(function() end),
		-- any(Boolean):asymmetricMatch(true),
		-- any(BigInt):asymmetricMatch(1),
		-- any(Symbol):asymmetricMatch(Symbol()),
		-- any(Object):asymmetricMatch({}),
		-- any(Object):asymmetricMatch(nil),
		-- any(Array):asymmetricMatch({}),
		-- any(Thing):asymmetricMatch(Thing.new()),
		any("string"):asymmetricMatch("jest"),
		any("number"):asymmetricMatch(1),
		any("function"):asymmetricMatch(function() end),
		any("boolean"):asymmetricMatch(true),
		any("table"):asymmetricMatch({}),
		-- ROBLOX deviation END
	}, function(test)
		jestExpect(test).toBe(true)
	end)
end)
-- ROBLOX deviation START: add custom test for the Any matcher with Lua prototypes
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

test("Any.asymmetricMatch() on primitive wrapper classes", function()
	Array.forEach({
		-- ROBLOX deviation START: ommiting because Lua doesn't have primitive wrapper classes
		-- -- eslint-disable-next-line no-new-wrappers
		-- any(String):asymmetricMatch(String.new("jest")),
		-- -- eslint-disable-next-line no-new-wrappers
		-- any(Number):asymmetricMatch(Number.new(1)),
		-- -- eslint-disable-next-line no-new-func
		-- any(Function):asymmetricMatch(Function.new("() => {}")),
		-- -- eslint-disable-next-line no-new-wrappers
		-- any(Boolean):asymmetricMatch(Boolean.new(true)),
		-- any(BigInt):asymmetricMatch(Object(1)),
		-- any(Symbol):asymmetricMatch(Object(Symbol())),
		-- ROBLOX deviation END
	}, function(test)
		jestExpect(test).toBe(true)
	end)
end)

test("Any.toAsymmetricMatcher()", function()
	-- ROBLOX deviation START: no primitive constructors in lua, we just supply a primitive
	-- jestExpect(any(Number):toAsymmetricMatcher()).toBe("Any<Number>")
	jestExpect(any("function"):toAsymmetricMatcher()).toBe("Any<function>")
	-- ROBLOX deviation END
end)
-- ROBLOX deviation START: not supported
-- test("Any.toAsymmetricMatcher() with function name", function()
-- 	Array.forEach({
-- 		{ "someFunc", function() end },
-- 		{ "$someFunc", function() end },
-- 		{
-- 			"$someFunc2",
-- 			(function()
-- 				local function _someFunc2 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $someFunc2 ]]() end
-- 				Object.defineProperty(
-- 					_someFunc2, --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $someFunc2 ]]
-- 					"name",
-- 					{ value = "" }
-- 				)
-- 				return _someFunc2 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $someFunc2 ]]
-- 			end)(),
-- 		},
-- 		{
-- 			"$someAsyncFunc",
-- 			(function()
-- 				local function _someAsyncFunc --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $someAsyncFunc ]]()
-- 					return Promise.resolve(nil)
-- 				end
-- 				Object.defineProperty(
-- 					_someAsyncFunc, --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $someAsyncFunc ]]
-- 					"name",
-- 					{ value = "" }
-- 				)
-- 				return _someAsyncFunc --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $someAsyncFunc ]]
-- 			end)(),
-- 		},
-- 		{
-- 			"$someGeneratorFunc",
-- 			(function()
-- 				local function _someGeneratorFunc --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $someGeneratorFunc ]]() end
-- 				Object.defineProperty(
-- 					_someGeneratorFunc, --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $someGeneratorFunc ]]
-- 					"name",
-- 					{ value = "" }
-- 				)
-- 				return _someGeneratorFunc --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $someGeneratorFunc ]]
-- 			end)(),
-- 		},
-- 		{
-- 			"$someFuncWithFakeToString",
-- 			(function()
-- 				local function _someFuncWithFakeToString --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $someFuncWithFakeToString ]]() end
-- 				_someFuncWithFakeToString --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $someFuncWithFakeToString ]].toString =
-- 					function(_self: any)
-- 						return "Fake to string"
-- 					end
-- 				return _someFuncWithFakeToString --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $someFuncWithFakeToString ]]
-- 			end)(),
-- 		},
-- 	}, function(ref0)
-- 		local name, fn = table.unpack(ref0, 1, 2)
-- 		jestExpect(any(fn):toAsymmetricMatcher()).toBe(("Any<%s>"):format(tostring(name)))
-- 	end)
-- end)
-- ROBLOX deviation END
test("Any throws when called with empty constructor", function()
	jestExpect(function()
		return any()
	end).toThrow()
end)

test("Anything matches any type", function()
	Array.forEach({
		anything():asymmetricMatch("jest"),
		anything():asymmetricMatch(1),
		anything():asymmetricMatch(function() end),
		anything():asymmetricMatch(true),
		anything():asymmetricMatch({}),
		anything():asymmetricMatch({}),
	}, function(test)
		jestExpect(test).toBe(true)
	end)
end)

test("Anything does not match null and undefined", function()
	Array.forEach({ anything():asymmetricMatch(nil), anything():asymmetricMatch(nil) }, function(test)
		jestExpect(test).toBe(false)
	end)
end)
test("Anything.toAsymmetricMatcher()", function()
	jestExpect(anything():toAsymmetricMatcher()).toBe("Anything")
end)

test("Nothing matches match null and undefined", function()
	Array.forEach({ nothing():asymmetricMatch(nil), nothing():asymmetricMatch(nil) }, function(test)
		jestExpect(test).toBe(true)
	end)
end)
test("Nothing does not match any other type", function()
	Array.forEach({
		nothing():asymmetricMatch("jest"),
		nothing():asymmetricMatch(1),
		nothing():asymmetricMatch(function() end),
		nothing():asymmetricMatch(true),
		nothing():asymmetricMatch({}),
		nothing():asymmetricMatch({}),
	}, function(test)
		jestExpect(test).toBe(false)
	end)
end)
test("Anything.toAsymmetricMatcher()", function()
	jestExpect(nothing():toAsymmetricMatcher()).toBe("Nothing")
end)

test("ArrayContaining matches", function()
	Array.forEach({
		arrayContaining({}):asymmetricMatch("jest"),
		arrayContaining({ "foo" }):asymmetricMatch({ "foo" }),
		arrayContaining({ "foo" }):asymmetricMatch({ "foo", "bar" }),
		arrayContaining({}):asymmetricMatch({}),
	}, function(test)
		jestExpect(test).toEqual(true)
	end)
end)

test("ArrayContaining does not match", function()
	jestExpect(arrayContaining({ "foo" }):asymmetricMatch({ "bar" })).toBe(false)
end)

test("ArrayContaining throws for non-arrays", function()
	jestExpect(function()
		arrayContaining("foo"):asymmetricMatch({})
	end).toThrow()
end)

test("ArrayNotContaining matches", function()
	jestExpect(arrayNotContaining({ "foo" }):asymmetricMatch({ "bar" })).toBe(true)
end)

test("ArrayNotContaining does not match", function()
	Array.forEach({
		arrayNotContaining({}):asymmetricMatch("jest"),
		arrayNotContaining({ "foo" }):asymmetricMatch({ "foo" }),
		arrayNotContaining({ "foo" }):asymmetricMatch({ "foo", "bar" }),
		arrayNotContaining({}):asymmetricMatch({}),
	}, function(test)
		jestExpect(test).toEqual(false)
	end)
end)

test("ArrayNotContaining throws for non-arrays", function()
	jestExpect(function()
		arrayNotContaining("foo"):asymmetricMatch({})
	end).toThrow()
	-- ROBLOX deviation START: additional test for non-arraylike tables
	expect(function()
		arrayNotContaining({ x = 1 }):asymmetricMatch({})
	end).toThrow()
	-- ROBLOX deviation END
end)

test("ObjectContaining matches", function()
	Array.forEach({
		objectContaining({}):asymmetricMatch("jest"),
		objectContaining({ foo = "foo" }):asymmetricMatch({ foo = "foo", jest = "jest" }),
		objectContaining({ foo = nil }):asymmetricMatch({ foo = nil }),
		objectContaining({ first = objectContaining({ second = {} }) }):asymmetricMatch({
			first = { second = {} },
		}),
		-- ROBLOX deviation START: Lua doesn't have buffer type
		-- objectContaining({
		-- 	foo = Array.from(Buffer, "foo"),--[[ ROBLOX CHECK: check if 'Buffer' is an Array ]]
		-- }):asymmetricMatch({
		-- 	foo = Array.from(Buffer, "foo"),--[[ ROBLOX CHECK: check if 'Buffer' is an Array ]]
		-- 	jest = "jest",
		-- }),
		-- ROBLOX deviation END
	}, function(test)
		jestExpect(test).toEqual(true)
	end)
end)

test("ObjectContaining does not match", function()
	Array.forEach({
		objectContaining({ foo = "foo" }):asymmetricMatch({ bar = "bar" }),
		objectContaining({ foo = "foo" }):asymmetricMatch({ foo = "foox" }),
		-- ROBLOX deviation START: can't have nil values in table
		-- objectContaining({ foo = nil }):asymmetricMatch({}),
		objectContaining({ foo = "undefined" }):asymmetricMatch({}),
		-- ROBLOX deviation END
		objectContaining({ answer = 42, foo = { bar = "baz", foobar = "qux" } }):asymmetricMatch({
			foo = { bar = "baz" },
		}),
	}, function(test)
		jestExpect(test).toEqual(false)
	end)
end)

test("ObjectContaining matches defined properties", function()
	local definedPropertyObject = {}
	-- ROBLOX deviation START: not implemented
	-- Object.defineProperty(definedPropertyObject, "foo", {
	-- 	get = function()
	-- 		return "bar"
	-- 	end,
	-- })
	definedPropertyObject.foo = "bar"
	-- ROBLOX deviation END
	jestExpect(objectContaining({ foo = "bar" }):asymmetricMatch(definedPropertyObject)).toBe(true)
end)
-- ROBLOX deviation START: omitted prototype properties test, same as the others in Lua
-- test("ObjectContaining matches prototype properties", function()
-- 	local prototypeObject = { foo = "bar" }
-- 	local obj
-- 	if Boolean.toJSBoolean(Object.create) then
-- 		obj = Object.create(prototypeObject)
-- 	else
-- 		local function Foo() end
-- 		Foo.prototype = prototypeObject
-- 		Foo.prototype.constructor = Foo
-- 		obj = Foo.new()
-- 	end
-- 	jestExpect(objectContaining({ foo = "bar" }):asymmetricMatch(obj)).toBe(true)
-- end)
-- ROBLOX deviation END
test("ObjectContaining throws for non-objects", function()
	jestExpect(function()
		return objectContaining(1337):asymmetricMatch()
	end).toThrow()
end)

test("ObjectContaining does not mutate the sample", function()
	local sample = { foo = { bar = {} } }
	local sample_json = JSON.stringify(sample)
	expect({ foo = { bar = {} } }).toEqual(expect.objectContaining(sample))
	expect(JSON.stringify(sample)).toEqual(sample_json)
end)

test("ObjectNotContaining matches", function()
	Array.forEach({
		objectNotContaining({ foo = "foo" }):asymmetricMatch({ bar = "bar" }),
		objectNotContaining({ foo = "foo" }):asymmetricMatch({ foo = "foox" }),
		-- ROBLOX deviation START: can't have nil values in table
		-- objectNotContaining({ foo = nil }):asymmetricMatch({}),
		objectNotContaining({ foo = "undefined" }):asymmetricMatch({}),
		-- ROBLOX deviation END
		objectNotContaining({ first = objectNotContaining({ second = {} }) }):asymmetricMatch({
			first = { second = {} },
		}),
		objectNotContaining({ first = { second = {}, third = {} } }):asymmetricMatch({
			first = { second = {} },
		}),
		objectNotContaining({ first = { second = {} } }):asymmetricMatch({
			first = { second = {}, third = {} },
		}),
		objectNotContaining({ foo = "foo", jest = "jest" }):asymmetricMatch({ foo = "foo" }),
	}, function(test)
		jestExpect(test).toEqual(true)
	end)
end)

test("ObjectNotContaining does not match", function()
	Array.forEach({
		objectNotContaining({}):asymmetricMatch("jest"),
		objectNotContaining({ foo = "foo" }):asymmetricMatch({ foo = "foo", jest = "jest" }),
		-- ROBLOX deviation START: can't have nil values in table
		-- objectNotContaining({ foo = nil }):asymmetricMatch({ foo = nil }),
		objectNotContaining({ foo = "undefined" }):asymmetricMatch({ foo = "undefined" }),
		-- ROBLOX deviation END
		objectNotContaining({ first = { second = {} } }):asymmetricMatch({
			first = { second = {} },
		}),
		objectNotContaining({ first = objectContaining({ second = {} }) }):asymmetricMatch({
			first = { second = {} },
		}),
		objectNotContaining({}):asymmetricMatch(nil),
		objectNotContaining({}):asymmetricMatch({}),
	}, function(test)
		jestExpect(test).toEqual(false)
	end)
end)

test("ObjectNotContaining inverts ObjectContaining", function()
	Array.forEach({
		{ {}, nil },
		{ { foo = "foo" }, { foo = "foo", jest = "jest" } },
		{ { foo = "foo", jest = "jest" }, { foo = "foo" } },
		-- ROBLOX deviation START: can't have nil values in table
		-- { { foo = nil }, { foo = nil } },
		-- { { foo = nil }, {} },
		{ { foo = "undefined" }, { foo = "undefined" } },
		{ { foo = "undefined" }, {} },
		-- ROBLOX deviation END
		{ { first = { second = {} } }, { first = { second = {} } } },
		{ { first = objectContaining({ second = {} }) }, { first = { second = {} } } },
		{ { first = objectNotContaining({ second = {} }) }, { first = { second = {} } } },
		-- ROBLOX deviation START: can't have nil values in table
		-- { {}, { foo = nil } },
		{ {}, { foo = "undefined" } },
		-- ROBLOX deviation END
	}, function(ref0)
		local sample, received = table.unpack(ref0, 1, 2)
		jestExpect(objectNotContaining(sample):asymmetricMatch(received)).toEqual(
			not Boolean.toJSBoolean(objectContaining(sample):asymmetricMatch(received))
		)
	end)
end)

test("ObjectNotContaining throws for non-objects", function()
	jestExpect(function()
		return objectNotContaining(1337):asymmetricMatch()
	end).toThrow()
end)

test("StringContaining matches string against string", function()
	jestExpect(stringContaining("en*"):asymmetricMatch("queen*")).toBe(true)
	jestExpect(stringContaining("en"):asymmetricMatch("queue")).toBe(false)
end)

test("StringContaining throws if expected value is not string", function()
	jestExpect(function()
		stringContaining({ 1 }):asymmetricMatch("queen")
	end).toThrow()
end)

test("StringContaining returns false if received value is not string", function()
	jestExpect(stringContaining("en*"):asymmetricMatch(1)).toBe(false)
end)

test("StringNotContaining matches string against string", function()
	jestExpect(stringNotContaining("en*"):asymmetricMatch("queen*")).toBe(false)
	jestExpect(stringNotContaining("en"):asymmetricMatch("queue")).toBe(true)
end)

test("StringNotContaining throws if expected value is not string", function()
	jestExpect(function()
		stringNotContaining({ 1 }):asymmetricMatch("queen")
	end).toThrow()
end)

test("StringNotContaining returns true if received value is not string", function()
	jestExpect(stringNotContaining("en*"):asymmetricMatch(1)).toBe(true)
end)

test("StringMatching matches string against regexp", function()
	-- ROBLOX deviation START: not implemented - RegExpLiteral
	-- jestExpect(stringMatching(
	-- 	error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /en/ ]]
	-- ):asymmetricMatch("queen")).toBe(true)
	-- jestExpect(stringMatching(
	-- 	error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /en/ ]]
	-- ):asymmetricMatch("queue")).toBe(false)
	jestExpect(stringMatching(RegExp("en")):asymmetricMatch("queen")).toBe(true)
	jestExpect(stringMatching(RegExp("en")):asymmetricMatch("queue")).toBe(false)
	-- ROBLOX deviation END
end)

test("StringMatching matches string against string", function()
	jestExpect(stringMatching("en"):asymmetricMatch("queen")).toBe(true)
	jestExpect(stringMatching("en"):asymmetricMatch("queue")).toBe(false)
end)

test("StringMatching throws if expected value is neither string nor regexp", function()
	jestExpect(function()
		stringMatching({ 1 }):asymmetricMatch("queen")
	end).toThrow()
end)

test("StringMatching returns false if received value is not string", function()
	jestExpect(stringMatching("en"):asymmetricMatch(1)).toBe(false)
end)
test("StringMatching returns false even if coerced non-string received value matches pattern", function()
	jestExpect(stringMatching("null"):asymmetricMatch(nil)).toBe(false)
end)

test("StringNotMatching matches string against regexp", function()
	-- ROBLOX deviation START: not implemented - RegExpLiteral
	-- jestExpect(stringNotMatching(
	-- 	error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /en/ ]]
	-- ):asymmetricMatch("queen")).toBe(false)
	-- jestExpect(stringNotMatching(
	-- 	error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /en/ ]]
	-- ):asymmetricMatch("queue")).toBe(true)
	jestExpect(stringNotMatching(RegExp("en")):asymmetricMatch("queen")).toBe(false)
	jestExpect(stringNotMatching(RegExp("en")):asymmetricMatch("queue")).toBe(true)
	-- ROBLOX deviation END
end)

test("StringNotMatching matches string against string", function()
	jestExpect(stringNotMatching("en"):asymmetricMatch("queen")).toBe(false)
	jestExpect(stringNotMatching("en"):asymmetricMatch("queue")).toBe(true)
end)

test("StringNotMatching throws if expected value is neither string nor regexp", function()
	jestExpect(function()
		stringNotMatching({ 1 }):asymmetricMatch("queen")
	end).toThrow()
end)

test("StringNotMatching returns true if received value is not string", function()
	jestExpect(stringNotMatching("en"):asymmetricMatch(1)).toBe(true)
end)

describe("closeTo", function()
	Array.forEach({
		{ 0, 0 },
		{ 0, 0.001 },
		{ 1.23, 1.229 },
		{ 1.23, 1.226 },
		{ 1.23, 1.225 },
		{ 1.23, 1.234 },
		{ math.huge, math.huge },
		{ -math.huge, -math.huge },
	}, function(ref0)
		local expected, received = table.unpack(ref0, 1, 2)

		test(("%s closeTo %s return true"):format(tostring(expected), tostring(received)), function()
			jestExpect(closeTo(expected):asymmetricMatch(received)).toBe(true)
		end)

		test(("%s notCloseTo %s return false"):format(tostring(expected), tostring(received)), function()
			jestExpect(notCloseTo(expected):asymmetricMatch(received)).toBe(false)
		end)
	end)

	Array.forEach({
		{ 0, 0.01 },
		{ 1, 1.23 },
		{ 1.23, 1.2249999 },
		{ math.huge, -math.huge },
		{ math.huge, 1.23 },
		{ -math.huge, -1.23 },
	}, function(ref0)
		local expected, received = table.unpack(ref0, 1, 2)

		test(("%s closeTo %s return false"):format(tostring(expected), tostring(received)), function()
			jestExpect(closeTo(expected):asymmetricMatch(received)).toBe(false)
		end)

		test(("%s notCloseTo %s return true"):format(tostring(expected), tostring(received)), function()
			jestExpect(notCloseTo(expected):asymmetricMatch(received)).toBe(true)
		end)
	end)

	Array.forEach({ { 0, 0.1, 0 }, { 0, 0.0001, 3 }, { 0, 0.000004, 5 }, { 2.0000002, 2, 5 } }, function(ref0)
		local expected, received, precision = table.unpack(ref0, 1, 3)

		test(
			("%s closeTo %s with precision %s return true"):format(
				tostring(expected),
				tostring(received),
				tostring(precision)
			),
			function()
				jestExpect(closeTo(expected, precision):asymmetricMatch(received)).toBe(true)
			end
		)

		test(
			("%s notCloseTo %s with precision %s return false"):format(
				tostring(expected),
				tostring(received),
				tostring(precision)
			),
			function()
				jestExpect(notCloseTo(expected, precision):asymmetricMatch(received)).toBe(false)
			end
		)
	end)

	Array.forEach({ { 3.141592e-7, 3e-7, 8 }, { 56789, 51234, -4 } }, function(ref0)
		local expected, received, precision = table.unpack(ref0, 1, 3)

		test(
			("%s closeTo %s with precision %s return false"):format(
				tostring(expected),
				tostring(received),
				tostring(precision)
			),
			function()
				jestExpect(closeTo(expected, precision):asymmetricMatch(received)).toBe(false)
			end
		)

		test(
			("%s notCloseTo %s with precision %s return true"):format(
				tostring(expected),
				tostring(received),
				tostring(precision)
			),
			function()
				jestExpect(notCloseTo(expected, precision):asymmetricMatch(received)).toBe(true)
			end
		)
	end)

	test("closeTo throw if expected is not number", function()
		jestExpect(function()
			closeTo("a")
		end).toThrow()
	end)

	test("notCloseTo throw if expected is not number", function()
		jestExpect(function()
			notCloseTo("a")
		end).toThrow()
	end)

	test("closeTo throw if precision is not number", function()
		jestExpect(function()
			closeTo(1, "a")
		end).toThrow()
	end)

	test("notCloseTo throw if precision is not number", function()
		jestExpect(function()
			notCloseTo(1, "a")
		end).toThrow()
	end)

	test("closeTo return false if received is not number", function()
		jestExpect(closeTo(1):asymmetricMatch("a")).toBe(false)
	end)

	test("notCloseTo return false if received is not number", function()
		jestExpect(notCloseTo(1):asymmetricMatch("a")).toBe(false)
	end)
end)
