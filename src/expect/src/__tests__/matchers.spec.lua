--!nocheck
-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/expect/src/__tests__/matchers.test.js
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

return (function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	type Function = (...any) -> ...any

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local describe = (JestGlobals.describe :: any) :: Function
	local it = (JestGlobals.it :: any) :: Function
	local itSKIP = JestGlobals.it.skip
	local beforeAll = (JestGlobals.beforeAll :: any) :: Function
	local afterAll = (JestGlobals.afterAll :: any) :: Function

	local LuauPolyfill = require(Packages.LuauPolyfill)
	local extends = LuauPolyfill.extends
	local Number = LuauPolyfill.Number
	local Object = LuauPolyfill.Object
	local Set = LuauPolyfill.Set
	local Symbol = LuauPolyfill.Symbol

	local RegExp = require(Packages.RegExp)

	local alignedAnsiStyleSerializer = require(Packages.Dev.TestUtils).alignedAnsiStyleSerializer
	local stringify = require(Packages.JestMatcherUtils).stringify

	-- ROBLOX deviation: omitted Immutable, chalk imports

	local jestExpect = require(CurrentModule)

	-- ROBLOX deviation: chalk enabled by default

	-- ROBLOX deviation: omitted isBigIntDefined variable declaration

	beforeAll(function()
		jestExpect.addSnapshotSerializer(alignedAnsiStyleSerializer)
	end)

	afterAll(function()
		jestExpect.resetSnapshotSerializers()
	end)

	it("should throw if passed two arguments", function()
		jestExpect(function()
			jestExpect("foo", "bar")
		end).toThrow("Expect takes at most one argument")
	end)

	describe(".toBe()", function()
		it("does not throw", function()
			jestExpect("a").never.toBe("b")
			jestExpect("a").toBe("a")
			jestExpect(1).never.toBe(2)
			jestExpect(1).toBe(1)
			jestExpect(nil).toBe(nil)
			jestExpect(0 / 0).toBe(0 / 0)
			--[[
				ROBLOX deviation: skipped since BigInt doesn't exist in Luau
				original code:
				jestExpect(BigInt(1)).not.toBe(BigInt(2));
				jestExpect(BigInt(1)).not.toBe(1);
				jestExpect(BigInt(1)).toBe(BigInt(1));
			]]
		end)

		--[[
			ROBLOX deviation: omitted error test, test with +0 and -0, test with null and undefined

			ROBLOX deviation: the test with identical dates is omitted because two
			equal dates are treated as the same in lua:
			{DateTime.fromUniversalTime(2020, 2, 20), DateTime.fromUniversalTime(2020, 2, 20)},
		]]

		for _, testCase in
			ipairs({
				{ 1, 2 },
				{ true, false },
				{ function() end, function() end },
				{ {}, {} },
				{ { a = 1 }, { a = 1 } },
				{ { a = 1 }, { a = 5 } },
				{
					{ a = function() end, b = 2 },
					{ a = jestExpect.any("function"), b = 2 },
				},
				{ { a = false, b = 2 }, { b = 2 } },
				{ DateTime.fromUniversalTime(2020, 2, 21), DateTime.fromUniversalTime(2020, 2, 20) },
				{ "received", "expected" },
				{ Symbol.for_("received"), Symbol.for_("expected") },
				{ "abc", "cde" },
				{ "painless JavaScript testing", "delightful JavaScript testing" },
				{ "", "compare one-line string to empty string" },
				{ "with \ntrailing space", "without trailing space" },
				{ "four\n4\nline\nstring", "3\nline\nstring" },
				{ -math.huge, math.huge },
			})
		do
			local a = testCase[1]
			local b = testCase[2]
			it("fails for: " .. stringify(a) .. " and " .. stringify(b), function()
				jestExpect(function()
					jestExpect(a).toBe(b)
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		--[[
			ROBLOX deviation: skipped since BigInt doesn't exist in Luau
			original code:
			  [
			    [BigInt(1), BigInt(2)],
			    [{a: BigInt(1)}, {a: BigInt(1)}],
			  ].forEach(([a, b]) => {
			    it(`fails for: ${stringify(a)} and ${stringify(b)}`, () => {
			      expect(() => jestExpect(a).toBe(b)).toThrowError('toBe');
			    });
			  });
		]]

		for _, testCase in
			ipairs({
				false,
				1,
				"a",
				{},
			})
		do
			it("fails for " .. stringify(testCase) .. " with .never", function()
				jestExpect(function()
					jestExpect(testCase :: any).never.toBe(testCase :: any)
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		--[[
			ROBLOX deviation: skipped since BigInt doesn't exist in Luau
			original code:
			  [BigInt(1), BigInt('1')].forEach(v => {
			    it(`fails for '${stringify(v)}' with '.not'`, () => {
			      expect(() => jestExpect(v).not.toBe(v)).toThrowError('toBe');
			    });
			  });
		]]

		-- ROBLOX deviation: we can't test nil as part of the loop above because the for loop
		-- wouldn't iterate over a nil entry so we include the test separately
		it("fails for nil with .never", function()
			jestExpect(function()
				jestExpect(nil).never.toBe(nil)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("does not crash on circular references", function()
			local obj = {}
			obj.circular = obj

			jestExpect(function()
				jestExpect(obj).toBe({})
			end).toThrowErrorMatchingSnapshot()
		end)

		-- ROBLOX TODO: assertion error currently returns strings, not an object
		itSKIP("assertion error matcherResult property contains matcher name, expected and actual values", function()
			local actual = { a = 1 }
			local expected = { a = 2 }

			local ok, error_ = pcall(function()
				jestExpect(actual).toBe(expected)
			end)

			if not ok then
				jestExpect(error_.message).toEqual(jestExpect.objectContaining({
					actual = actual,
					expected = expected,
					name = "toBe",
				}))
			end
		end)
	end)

	--[[
		ROBLOX deviation: the toStrictEqual matcher in Jest adds three features beyond
		that of the toEqual matcher:
			1) Checking for undefined properties
			2) Checking array sparseness
			3) Type checking

		Of these, Jest-Roblox's version of the toStrictEqual matcher only
		applies type checking

		Thus, tests checking undefined properties and checking array sparseness
		are omitted
	]]
	describe(".toStrictEqual()", function()
		local TestClassA = {}
		TestClassA.__index = TestClassA
		setmetatable(TestClassA, {
			__tostring = function(self)
				return "TestClassObject"
			end,
		})
		function TestClassA.new(a, b)
			local self = {
				a = a,
				b = b,
			}
			return setmetatable(self, TestClassA)
		end

		local TestClassB = {}
		TestClassB.__index = TestClassB
		setmetatable(TestClassB, {
			__tostring = function(self)
				return "TestClassObject"
			end,
		})
		function TestClassB.new(a, b)
			local self = {
				a = a,
				b = b,
			}
			return setmetatable(self, TestClassB)
		end

		local TestClassC = extends(TestClassA, "Child", function(self, a, b)
			self.a = a
			self.b = b
		end)

		local TestClassD = extends(TestClassB, "Child", function(self, a, b)
			self.a = a
			self.b = b
		end)

		itSKIP("does not ignore keys with undefined values", function()
			jestExpect({
				a = nil,
				b = 2,
			}).never.toStrictEqual({ b = 2 })
		end)

		itSKIP("does not ignore keys with undefined values inside an array", function()
			jestExpect({ { a = nil } }).never.toStrictEqual({ {} })
		end)

		itSKIP("does not ignore keys with undefined values deep inside an object", function()
			jestExpect({ { a = { { a = nil } } } }).never.toStrictEqual({ { a = { {} } } })
		end)

		-- ROBLOX deviation START: skipped since Lua doesn't support holes in a table
		-- it('does not consider holes as undefined in sparse arrays', function()
		-- 	-- eslint-disable-next-line no-sparse-arrays
		-- 	jestExpect({, , , 1, , ,}).never.toStrictEqual({, , , 1, nil, ,});
		-- end)
		-- ROBLOX deviation END

		it("passes when comparing same type", function()
			jestExpect({
				test = TestClassA.new(1, 2),
			}).toStrictEqual({ test = TestClassA.new(1, 2) })
		end)

		it("matches the expected snapshot when it fails", function()
			jestExpect(function()
				jestExpect({
					test = 2,
				}).toStrictEqual({ test = TestClassA.new(1, 2) })
			end).toThrowErrorMatchingSnapshot()

			jestExpect(function()
				jestExpect({
					test = TestClassA.new(1, 2),
				}).never.toStrictEqual({ test = TestClassA.new(1, 2) })
			end).toThrowErrorMatchingSnapshot()
		end)

		it("displays substring diff", function()
			local expected = "Another caveat is that Jest will not typecheck your tests."
			local received =
				"Because TypeScript support in Babel is just transpilation, Jest will not type-check your tests as they run."
			jestExpect(function()
				jestExpect(received).toStrictEqual(expected)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("displays substring diff for multiple lines", function()
			local expected = table.concat({
				"    69 | ",
				"    70 | test('assert.doesNotThrow', () => {",
				"  > 71 |   assert.doesNotThrow(() => {",
				"       |          ^",
				"    72 |     throw Error('err!');",
				"    73 |   });",
				"    74 | });",
				"    at Object.doesNotThrow (__tests__/assertionError.test.js:71:10)",
			}, "\n")
			local received = table.concat({
				"    68 | ",
				"    69 | test('assert.doesNotThrow', () => {",
				"  > 70 |   assert.doesNotThrow(() => {",
				"       |          ^",
				"    71 |     throw Error('err!');",
				"    72 |   });",
				"    73 | });",
				"    at Object.doesNotThrow (__tests__/assertionError.test.js:70:10)",
			}, "\n")
			jestExpect(function()
				jestExpect(received).toStrictEqual(expected)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("does not pass for different types", function()
			jestExpect({
				test = TestClassA.new(1, 2),
			}).never.toStrictEqual({ test = TestClassB.new(1, 2) })
		end)

		it("does not simply compare constructor names", function()
			local c = TestClassC.new(1, 2)
			local d = TestClassD.new(1, 2)
			-- ROBLOX deviation: instead of comparing constructor name we compare tostring values
			jestExpect(tostring(c)).toEqual(tostring(d))
			jestExpect({ test = c }).never.toStrictEqual({ test = d })
		end)

		itSKIP("passes for matching sparse arrays", function()
			-- jestExpect({, 1}).toStrictEqual({, 1})
		end)

		itSKIP("does not pass when sparseness of arrays do not match", function()
			-- jestExpect({, 1}).never.toStrictEqual({nil, 1})
			-- jestExpect({nil, 1}).never.toStrictEqual({, 1})
			-- jestExpect({, , , 1}).never.toStrictEqual({, 1})
		end)

		itSKIP("does not pass when equally sparse arrays have different values", function()
			-- jestExpect({, 1}).never.toStrictEqual({, 2})
		end)

		--[[
			ROBLOX deviation: skipped as Lua doesn't support ArrayBuffer
			original code:
			it('does not pass when ArrayBuffers are not equal', () => {
			  expect(Uint8Array.from([1, 2]).buffer).not.toStrictEqual(
			    Uint8Array.from([0, 0]).buffer,
			  );
			  expect(Uint8Array.from([2, 1]).buffer).not.toStrictEqual(
			    Uint8Array.from([2, 2]).buffer,
			  );
			  expect(Uint8Array.from([]).buffer).not.toStrictEqual(
			    Uint8Array.from([1]).buffer,
			  );
			});

			it('passes for matching buffers', () => {
			  expect(Uint8Array.from([1]).buffer).toStrictEqual(
			    Uint8Array.from([1]).buffer,
			  );
			  expect(Uint8Array.from([]).buffer).toStrictEqual(
			    Uint8Array.from([]).buffer,
			  );
			  expect(Uint8Array.from([9, 3]).buffer).toStrictEqual(
			    Uint8Array.from([9, 3]).buffer,
			  );
			});
		]]
	end)

	--[[
			ROBLOX deviation: omitted test cases that become redundant in our Lua translation i.e.

			Number(0), 0
			String('abc'), 'abc'

			as well as any tests that involve Sets or Maps that become redundant with other
			tests since our translation for all kinds of data structures fall back to tables

			We change the Immutable types to be ordinary data
			types where applicable and omit the test entirely if it becomes
			redundant

			We also omitted Object getter and setter tests


	]]
	describe(".toEqual()", function()
		for _, testCase in
			ipairs({
				{ true, false },
				{ 1, 2 },
				{ 0, Number.MIN_SAFE_INTEGER },
				{ Number.MIN_SAFE_INTEGER, 0 },
				{ 0, 1 },
				{ { a = 1 }, { a = 2 } },
				{ { a = 5 }, { b = 6 } },
				{ Object.freeze({ foo = { bar = 1 } }), { foo = {} } },
				{ "banana", "apple" },
				{ "1\u{00A0}234,57\u{00A0}$", "1 234,57 $" },
				{
					'type TypeName<T> = T extends Function ? "function" : "object";',
					'type TypeName<T> = T extends Function\n? "function"\n: "object";',
				},
				{ { 1 }, { 2 } },
				{ { 1, 2 }, { 2, 1 } },
				{ {}, Set.new({}) },
				{ Set.new({ 1, 2 }), Set.new({}) },
				{ Set.new({ 1, 2 }), Set.new({ 1, 2, 3 }) },
				{ Set.new({ { 1 }, { 2 } }), Set.new({ { 1 }, { 2 }, { 3 } }) },
				{ Set.new({ { 1 }, { 2 } }), Set.new({ { 1 }, { 2 }, { 2 } }) },
				{
					Set.new({ Set.new({ 1 }), Set.new({ 2 }) }),
					Set.new({ Set.new({ 1 }), Set.new({ 3 }) }),
				},
				{ { 1, 2 }, {} },
				{ { 1, 2 }, { 1, 2, 3 } },
				{ { { 1 }, { 2 } }, { { 1 }, { 2 }, { 3 } } },
				{ { { 1 }, { 2 } }, { { 1 }, { 2 }, { 2 } } },
				{
					{ { 1 }, { 2 } },
					{ { 1 }, { 3 } },
				},
				{
					{ [1] = "one", [2] = "two" },
					{ [1] = "one" },
				},
				{ { a = 0 }, { b = 0 } },
				{ { v = 1 }, { v = 2 } },
				{ { [{ "v" }] = 1 }, { [{ "v" }] = 2 } },
				{
					{ [{ 1 }] = { [{ 1 }] = "one" } },
					{ [{ 1 }] = { [{ 1 }] = "two" } },
				},
				{
					{ ["1"] = { ["2"] = { a = 99 } } },
					{ ["1"] = { ["2"] = { a = 11 } } },
				},
				{ { 97, 98, 99 }, { 97, 98, 100 } },
				{ { a = 1, b = 2 }, jestExpect.objectContaining({ a = 2 }) },
				{ false, jestExpect.objectContaining({ a = 2 }) },
				{ { 1, 3 }, jestExpect.arrayContaining({ 1, 2 }) },
				{ 1, jestExpect.arrayContaining({ 1, 2 }) },
				{ "abd", jestExpect.stringContaining("bc") },
				{ "abd", jestExpect.stringMatching("bc") },
				{ nil, jestExpect.anything() },
				{ nil, jestExpect.any("function") },
				{
					"Eve",
					{
						asymmetricMatch = function(self, who)
							return who == "Alice" or who == "Bob"
						end,
					},
				},
				{
					{
						target = {
							nodeType = 1,
							value = "a",
						},
					},
					{
						target = {
							nodeType = 1,
							value = "b",
						},
					},
				},
				{
					{
						nodeName = "div",
						nodeType = 1,
					},
					{
						nodeName = "p",
						nodeType = 1,
					},
				},
				{
					{
						[Symbol.for_("foo")] = 1,
						[Symbol.for_("bar")] = 2,
					},
					{
						[Symbol.for_("foo")] = jestExpect.any("number"),
						[Symbol.for_("bar")] = 1,
					},
				},
				-- ROBLOX deviation START: no sparse arrays in Lua
				-- {
				-- 	-- eslint-disable-next-line no-sparse-arrays
				-- 	{, , 1, ,},
				-- 	-- eslint-disable-next-line no-sparse-arrays
				-- 	{, , 2, ,},
				-- },
				-- ROBLOX deviation END
				{
					Object.assign({}, { [4294967295] = 1 }),
					Object.assign({}, { [4294967295] = 2 }), -- issue 11056
				},
				{
					-- eslint-disable-next-line no-useless-computed-key
					Object.assign({}, { ["-0"] = 1 }),
					-- eslint-disable-next-line no-useless-computed-key
					Object.assign({}, { ["0"] = 1 }), -- issue 11056: also check (-0, 0)
				},
				{
					Object.assign({}, { a = 1 }),
					Object.assign({}, { b = 1 }), -- issue 11056: also check strings
				},
				{
					Object.assign({}, { [Symbol()] = 1 }),
					Object.assign({}, { [Symbol()] = 1 }), -- issue 11056: also check symbols
				},
			})
		do
			local a = testCase[1]
			local b = testCase[2]
			it("{pass: false} expect(" .. stringify(a) .. ").toEqual(" .. stringify(b) .. ")", function()
				jestExpect(function()
					jestExpect(a).toEqual(b)
				end).toThrowErrorMatchingSnapshot()
				jestExpect(a).never.toEqual(b)
			end)
		end

		--[[
			ROBLOX deviation: skipped since BigInt doesn't exist in Luau
			original code:
			[
			  [BigInt(1), BigInt(2)],
			  [BigInt(1), 1],
			].forEach(([a, b]) => {
			  test(`{pass: false} expect(${stringify(a)}).toEqual(${stringify(
			    b,
			  )})`, () => {
			    expect(() => jestExpect(a).toEqual(b)).toThrowError('toEqual');
			    jestExpect(a).not.toEqual(b);
			  });
			});
		]]

		for _, testCase in
			ipairs({
				{ true, true },
				{ 1, 1 },
				{ 0 / 0, 0 / 0 },
				{ 0, 0 },
				{ "abc", "abc" },
				{ { 1 }, { 1 } },
				{
					{ 1, 2 },
					{ 1, 2 },
				},
				{ {}, {} },
				{ { a = 99 }, { a = 99 } },
				{ Set.new({}), Set.new({}) },
				{ Set.new({ 1, 2 }), Set.new({ 1, 2 }) },
				{ Set.new({ 1, 2 }), Set.new({ 2, 1 }) },
				{
					Set.new({ Set.new({ { 1 } }), Set.new({ { 2 } }) }),
					Set.new({ Set.new({ { 2 } }), Set.new({ { 1 } }) }),
				},
				{
					Set.new({ { 1 }, { 2 }, { 3 }, { 3 } }),
					Set.new({ { 3 }, { 3 }, { 2 }, { 1 } }),
				},
				{
					Set.new({ { a = 1 }, { b = 2 } }),
					Set.new({ { b = 2 }, { a = 1 } }),
				},
				{
					{
						[1] = "one",
						[2] = "two",
					},
					{
						[1] = "one",
						[2] = "two",
					},
				},
				{
					{
						[1] = { "one" },
						[2] = { "two" },
					},
					{
						[2] = { "two" },
						[1] = { "one" },
					},
				},
				{
					{ [1] = { [2] = { a = 99 } } },
					{ [1] = { [2] = { a = 99 } } },
				},
				{ { 97, 98, 99 }, { 97, 98, 99 } },
				{ { a = 1, b = 2 }, jestExpect.objectContaining({ a = 1 }) },
				{ { 1, 2, 3 }, jestExpect.arrayContaining({ 2, 3 }) },
				{ "abcd", jestExpect.stringContaining("bc") },
				{ "abcd", jestExpect.stringMatching("bc") },
				{ true, jestExpect.anything() },
				{ function() end, jestExpect.any("function") },
				{
					{
						a = 1,
						b = function() end,
						c = true,
					},
					{
						a = 1,
						b = jestExpect.any("function"),
						c = jestExpect.anything(),
					},
				},
				{
					"Alice",
					{
						asymmetricMatch = function(self, who)
							return who == "Alice" or who == "Bob"
						end,
					},
				},
				{
					{
						nodeName = "div",
						nodeType = 1,
					},
					{
						nodeName = "div",
						nodeType = 1,
					},
				},
				--[[
				ROBLOX deviation: no sparse arrays in Lua
				original code:
				[
				  // eslint-disable-next-line no-sparse-arrays
				  [, , 1, ,],
				  // eslint-disable-next-line no-sparse-arrays
				  [, , 1, ,],
				],
				[
				  // eslint-disable-next-line no-sparse-arrays
				  [, , 1, , ,],
				  // eslint-disable-next-line no-sparse-arrays
				  [, , 1, undefined, ,], // same length but hole replaced by undefined
				],
			]]
			})
		do
			local a = testCase[1]
			local b = testCase[2]
			it("{pass: true} expect(" .. stringify(a) .. ").never.toEqual(" .. stringify(b) .. ")", function()
				jestExpect(a).toEqual(b)
				jestExpect(function()
					jestExpect(a).never.toEqual(b)
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		--[=[
			ROBLOX deviation: skipped since BigInt doesn't exist in Luau
			original code:
			[
			  [BigInt(1), BigInt(1)],
			  [BigInt(0), BigInt('0')],
			  [[BigInt(1)], [BigInt(1)]],
			  [
			    [BigInt(1), 2],
			    [BigInt(1), 2],
			  ],
			  [Immutable.List([BigInt(1)]), Immutable.List([BigInt(1)])],
			  [{a: BigInt(99)}, {a: BigInt(99)}],
			  [new Set([BigInt(1), BigInt(2)]), new Set([BigInt(1), BigInt(2)])],
			].forEach(([a, b]) => {
			  test(`{pass: true} expect(${stringify(a)}).not.toEqual(${stringify(
			    b,
			  )})`, () => {
			    jestExpect(a).toEqual(b);
			    expect(() => jestExpect(a).not.toEqual(b)).toThrowError('toEqual');
			  });
			});
		]=]

		-- ROBLOX TODO: assertion error currently returns strings, not an object
		itSKIP("assertion error matcherResult property contains matcher name, expected and actual values", function()
			local actual = { a = 1 }
			local expected = { a = 2 }
			local ok, error_ = pcall(function()
				jestExpect(actual).toEqual(expected)
			end)

			if not ok then
				jestExpect(error_.matcherResult).toEqual(jestExpect.objectContaining({
					actual = actual,
					expected = expected,
					name = "toEqual",
				}))
			end
		end)

		it("symbol based keys in arrays are processed correctly", function()
			local mySymbol = Symbol("test")
			local actual1 = {}
			actual1[mySymbol] = 3
			local actual2 = {}
			actual2[mySymbol] = 4
			local expected = {}
			expected[mySymbol] = 3

			jestExpect(actual1).toEqual(expected)
			jestExpect(actual2).never.toEqual(expected)
		end)

		-- ROBLOX deviation: test omitted because it's not applicable to Lua translation
		itSKIP("non-enumerable members should be skipped during equal", function()
			-- local actual = {
			-- 	x = 3,
			-- }
			-- Object.defineProperty(actual, 'test', {
			-- 	enumerable = false,
			-- 	value = 5,
			-- })
			-- expect(actual).toEqual({x = 3})
		end)

		-- ROBLOX deviation: test omitted because it's not applicable to Lua translation
		itSKIP("non-enumerable symbolic members should be skipped during equal", function()
			-- local actual = {
			-- 	x = 3,
			-- }
			-- local mySymbol = Symbol('test')
			-- Object.defineProperty(actual, mySymbol, {
			-- 	enumerable = false,
			-- 	value = 5,
			-- })
			-- expect(actual).toEqual({x = 3})
		end)

		describe("cyclic object equality", function()
			it("properties with the same circularity are equal", function()
				local a = {}
				a.x = a
				local b = {}
				b.x = b
				jestExpect(a).toEqual(b)
				jestExpect(b).toEqual(a)

				local c = {}
				c.x = a
				local d = {}
				d.x = b
				jestExpect(c).toEqual(d)
				jestExpect(d).toEqual(c)
			end)

			it("properties with different circularity are not equal", function()
				local a = {}
				a.x = { y = a }
				local b = {}
				local bx = {}
				b.x = bx
				bx.y = bx
				jestExpect(a).never.toEqual(b)
				jestExpect(b).never.toEqual(a)

				local c = {}
				c.x = a
				local d = {}
				d.x = b
				jestExpect(c).never.toEqual(d)
				jestExpect(d).never.toEqual(c)
			end)

			it("are not equal if circularity is not on the same property", function()
				local a = {}
				local b = {}
				a.a = a
				b.a = {}
				b.a.a = a
				jestExpect(a).never.toEqual(b)
				jestExpect(b).never.toEqual(a)

				local c = {}
				c.x = { x = c }
				local d = {}
				d.x = d
				jestExpect(c).never.toEqual(d)
				jestExpect(d).never.toEqual(c)
			end)
		end)
	end)

	-- ROBLOX deviation: major deviations to toBeInstanceOf, check README for more info
	describe(".toBeInstanceOf()", function()
		local A = {}
		A.__index = A
		setmetatable(A, {
			__tostring = function(self)
				return "A"
			end,
		})
		function A.new()
			local self = {}
			setmetatable(self, A)
			return self
		end

		local B = {}
		B.__index = B
		setmetatable(B, {
			__tostring = function(self)
				return "B"
			end,
		})
		function B.new()
			local self = {}
			setmetatable(self, B)
			return self
		end

		-- C extends B
		local C = extends(B, "C", function(self) end)

		-- D extends C
		local D = extends(C, "D", function(self) end)

		-- E extends D
		local E = extends(D, "E", function(self) end)

		it("throws if expected is not a table", function()
			jestExpect(function()
				jestExpect(A.new()).toBeInstanceOf(1)
			end).toThrow(
				"[1mMatcher error[22m: [32mexpected[39m value must be a prototype class\n\n"
					.. "Expected has type:  number\n"
					.. "Expected has value: [32m1[39m"
			)
		end)

		it("does not throw if received is not a table", function()
			jestExpect(function()
				jestExpect(1).toBeInstanceOf(A)
			end).toThrow(
				"[2mexpect([22m[31mreceived[39m[2m).[22mtoBeInstanceOf[2m([22m[32mexpected[39m[2m)[22m\n\n"
					.. "Expected constructor: [32mA[39m\n\n"
					.. "Received value has no prototype\n"
					.. "Received value: [31m1[39m"
			)
		end)

		it("does not throw if received does not have metatable", function()
			jestExpect(function()
				jestExpect({}).toBeInstanceOf(A)
			end).toThrow(
				"[2mexpect([22m[31mreceived[39m[2m).[22mtoBeInstanceOf[2m([22m[32mexpected[39m[2m)[22m\n\n"
					.. "Expected constructor: [32mA[39m\n\n"
					.. "Received value has no prototype\n"
					.. "Received value: [31m{}[39m"
			)

			jestExpect({}).never.toBeInstanceOf(A)
		end)

		it("passing A.new() and A", function()
			jestExpect(function()
				jestExpect(A.new()).never.toBeInstanceOf(A)
			end).toThrow(
				"[2mexpect([22m[31mreceived[39m[2m).[22mnever[2m.[22mtoBeInstanceOf[2m([22m[32mexpected[39m[2m)[22m\n\n"
					.. "Expected constructor: never [32mA[39m\n"
			)

			jestExpect(A.new()).toBeInstanceOf(A)
		end)

		it("passing C.new() and B", function()
			jestExpect(function()
				jestExpect(C.new()).never.toBeInstanceOf(B)
			end).toThrow(
				"[2mexpect([22m[31mreceived[39m[2m).[22mnever[2m.[22mtoBeInstanceOf[2m([22m[32mexpected[39m[2m)[22m\n\n"
					.. "Expected constructor: never [32mB[39m\n"
					.. "Received constructor:       [31mC[39m extends [32mB[39m"
			)

			jestExpect(C.new()).toBeInstanceOf(B)
		end)

		it("passing E.new() and B", function()
			jestExpect(function()
				jestExpect(E.new()).never.toBeInstanceOf(B)
			end).toThrow(
				"[2mexpect([22m[31mreceived[39m[2m).[22mnever[2m.[22mtoBeInstanceOf[2m([22m[32mexpected[39m[2m)[22m\n\n"
					.. "Expected constructor: never [32mB[39m\n"
					.. "Received constructor:       [31mE[39m extends … extends [32mB[39m"
			)

			jestExpect(E.new()).toBeInstanceOf(B)
		end)

		it("failing A.new() and B", function()
			jestExpect(function()
				jestExpect(A.new()).toBeInstanceOf(B)
			end).toThrow(
				"[2mexpect([22m[31mreceived[39m[2m).[22mtoBeInstanceOf[2m([22m[32mexpected[39m[2m)[22m\n\n"
					.. "Expected constructor: [32mB[39m\n"
					.. "Received constructor: [31mA[39m"
			)

			jestExpect(A.new()).never.toBeInstanceOf(B)
		end)
	end)

	describe(".toBeTruthy(), .toBeFalsy()", function()
		-- ROBLOX deviation: can't pass in nil as an argument because it's identical to no argument
		it("does not accept arguments", function()
			jestExpect(function()
				jestExpect(0).toBeTruthy(1)
			end).toThrowErrorMatchingSnapshot()

			jestExpect(function()
				jestExpect(0).never.toBeFalsy(1)
			end).toThrowErrorMatchingSnapshot()
		end)

		-- ROBLOX deviation: 0, '' and nan are falsy in JS but truthy in Lua so we will treat them as truthy
		for _, testCase in
			ipairs({
				{},
				true,
				1,
				"a",
				0.5,
				function() end,
				math.huge,
				0,
				"",
				0 / 0,
			})
		do
			it(string.format("%s is truthy", stringify(testCase)), function()
				jestExpect(testCase).toBeTruthy()
				jestExpect(testCase).never.toBeFalsy()

				jestExpect(function()
					jestExpect(testCase :: any).never.toBeTruthy()
				end).toThrowErrorMatchingSnapshot()

				jestExpect(function()
					jestExpect(testCase :: any).toBeFalsy()
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		it("nil is falsy", function()
			jestExpect(nil).toBeFalsy()
			jestExpect(nil).never.toBeTruthy()

			jestExpect(function()
				jestExpect(nil).toBeTruthy()
			end).toThrowErrorMatchingSnapshot()
			jestExpect(function()
				jestExpect(nil).never.toBeFalsy()
			end).toThrowErrorMatchingSnapshot()
		end)

		it("false is falsy", function()
			jestExpect(false).toBeFalsy()
			jestExpect(false).never.toBeTruthy()

			jestExpect(function()
				jestExpect(false).toBeTruthy()
			end).toThrowErrorMatchingSnapshot()
			jestExpect(function()
				jestExpect(false).never.toBeFalsy()
			end).toThrowErrorMatchingSnapshot()
		end)

		--[[
			ROBLOX deviation: skipped since BigInt doesn't exist in Luau
			original code:
			[BigInt(0)].forEach(v => {
			  test(`'${stringify(v)}' is falsy`, () => {
			    jestExpect(v).toBeFalsy();
			    jestExpect(v).not.toBeTruthy();

			    expect(() => jestExpect(v).toBeTruthy()).toThrowError('toBeTruthy');

			    expect(() => jestExpect(v).not.toBeFalsy()).toThrowError('toBeFalsy');
			  });
			});
		]]
	end)

	describe(".toBeNan()", function()
		it("{pass: true} expect(nan).toBeNan()", function()
			for index, testCase in
				ipairs({
					math.sqrt(-1),
					math.huge - math.huge,
					0 / 0,
				})
			do
				jestExpect(testCase).toBeNan()
				jestExpect(function()
					jestExpect(testCase :: any).never.toBeNan()
				end).toThrowErrorMatchingSnapshot()
			end
		end)

		it("throws", function()
			for index, testCase in
				ipairs({
					1,
					"",
					{},
					0.2,
					0,
					math.huge,
					-math.huge,
				})
			do
				jestExpect(function()
					jestExpect(testCase :: any).toBeNan()
				end).toThrowErrorMatchingSnapshot()
				jestExpect(testCase).never.toBeNan()
			end
		end)

		-- ROBLOX deviation: tests our alias
		it("aliased as toBeNaN()", function()
			jestExpect(0 / 0).toBeNaN()
		end)
	end)

	describe(".toBeNil()", function()
		for _, testCase in
			ipairs({
				{},
				true,
				1,
				"a",
				0.5,
				function() end,
				math.huge,
			})
		do
			it("fails for " .. stringify(testCase), function()
				jestExpect(testCase).never.toBeNil()

				jestExpect(function()
					jestExpect(testCase :: any).toBeNil()
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		it("fails for null with .not", function()
			jestExpect(function()
				jestExpect(nil).never.toBeNil()
			end).toThrowErrorMatchingSnapshot()
		end)

		it("pass for null", function()
			jestExpect(nil).toBeNil()
		end)

		-- ROBLOX deviation: tests our alias
		it("aliased as toBeNull()", function()
			jestExpect(nil).toBeNull()
		end)
	end)

	describe(".toBeDefined() .toBeUndefined()", function()
		for _, testCase in
			ipairs({
				{},
				true,
				1,
				"a",
				0.5,
				function() end,
				math.huge,
			})
		do
			it(stringify(testCase) .. " is defined", function()
				jestExpect(testCase).toBeDefined()

				jestExpect(function()
					jestExpect(testCase :: any).never.toBeDefined()
				end).toThrowErrorMatchingSnapshot()
				jestExpect(function()
					jestExpect(testCase :: any).toBeUndefined()
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		--[[
			ROBLOX deviation: skipped since BigInt doesn't exist in Luau
			original code:
			[BigInt(1)].forEach(v => {
				test(`'${stringify(v)}' is defined`, () => {
			    jestExpect(v).toBeDefined();
			    jestExpect(v).not.toBeUndefined();

			    expect(() => jestExpect(v).not.toBeDefined()).toThrowError('toBeDefined');

			    expect(() => jestExpect(v).toBeUndefined()).toThrowError('toBeUndefined');
			  });
			});
		]]

		it("nil is undefined", function()
			jestExpect(nil).toBeUndefined()
			jestExpect(nil).never.toBeDefined()

			jestExpect(function()
				jestExpect(nil).toBeDefined()
			end).toThrowErrorMatchingSnapshot()

			jestExpect(function()
				jestExpect(nil).never.toBeUndefined()
			end).toThrowErrorMatchingSnapshot()
		end)
	end)

	describe(".toBeGreaterThan(), .toBeLessThan(), " .. ".toBeGreaterThanOrEqual(), .toBeLessThanOrEqual()", function()
		for _, testCase in
			ipairs({
				{ 1, 2 },
				{ -math.huge, math.huge },
				{ Number.MIN_SAFE_INTEGER, Number.MAX_SAFE_INTEGER },
				{ 0x11, 0x22 },
				{ tonumber("11", 2), tonumber("111", 2) },
				{ tonumber("11", 8), tonumber("22", 8) },
				{ 0.1, 0.2 },
			})
		do
			local small = testCase[1]
			local big = testCase[2]
			it(string.format("{pass: true} expect(%s).toBeLessThan(%s)", small, big), function()
				jestExpect(small).toBeLessThan(big)
			end)

			it(string.format("{pass: false} expect(%s).toBeLessThan(%s)", big, small), function()
				jestExpect(big).never.toBeLessThan(small)
			end)

			it(string.format("{pass: true} expect(%s).toBeGreaterThan(%s)", big, small), function()
				jestExpect(big).toBeGreaterThan(small)
			end)

			it(string.format("{pass: false} expect(%s).toBeGreaterThan(%s)", small, big), function()
				jestExpect(small).never.toBeGreaterThan(big)
			end)

			it(string.format("{pass: true} expect(%s).toBeLessThanOrEqual(%s)", small, big), function()
				jestExpect(small).toBeLessThanOrEqual(big)
			end)

			it(string.format("{pass: false} expect(%s).toBeLessThanOrEqual(%s)", big, small), function()
				jestExpect(big).never.toBeLessThanOrEqual(small)
			end)

			it(string.format("{pass: true} expect(%s).toBeGreaterThanOrEqual(%s)", big, small), function()
				jestExpect(big).toBeGreaterThanOrEqual(small)
			end)

			it(string.format("{pass: false} expect(%s).toBeGreaterThanOrEqual(%s)", small, big), function()
				jestExpect(small).never.toBeGreaterThanOrEqual(big)
			end)

			it(string.format("throws: [%s, %s]", small, big), function()
				jestExpect(function()
					jestExpect(small).toBeGreaterThan(big)
				end).toThrowErrorMatchingSnapshot()

				jestExpect(function()
					jestExpect(small).never.toBeLessThan(big)
				end).toThrowErrorMatchingSnapshot()

				jestExpect(function()
					jestExpect(big).never.toBeGreaterThan(small)
				end).toThrowErrorMatchingSnapshot()

				jestExpect(function()
					jestExpect(big).toBeLessThan(small)
				end).toThrowErrorMatchingSnapshot()

				jestExpect(function()
					jestExpect(small).toBeGreaterThanOrEqual(big)
				end).toThrowErrorMatchingSnapshot()

				jestExpect(function()
					jestExpect(small).never.toBeLessThanOrEqual(big)
				end).toThrowErrorMatchingSnapshot()

				jestExpect(function()
					jestExpect(big).never.toBeGreaterThanOrEqual(small)
				end).toThrowErrorMatchingSnapshot()

				jestExpect(function()
					jestExpect(big).toBeLessThanOrEqual(small)
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		--[[
			ROBLOX deviation: skipped since BigInt doesn't exist in Luau
			original code lines 1278 - 1372
		]]
		for _, testCase in
			ipairs({
				{ 1, 1 },
				{ Number.MIN_SAFE_INTEGER, Number.MIN_SAFE_INTEGER },
				{ Number.MAX_SAFE_INTEGER, Number.MAX_SAFE_INTEGER },
				{ math.huge, math.huge },
				{ -math.huge, -math.huge },
			})
		do
			local n1 = testCase[1]
			local n2 = testCase[2]

			it(string.format("equal numbers: [%s, %s]", n1, n2), function()
				jestExpect(n1).toBeGreaterThanOrEqual(n2)
				jestExpect(n1).toBeLessThanOrEqual(n2)

				jestExpect(function()
					jestExpect(n1).never.toBeGreaterThanOrEqual(n2)
				end).toThrowErrorMatchingSnapshot()

				jestExpect(function()
					jestExpect(n1).never.toBeLessThanOrEqual(n2)
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		--[[
			ROBLOX deviation: skipped since BigInt doesn't exist in Luau
			original code lines 1395 - 1411
		]]
	end)

	describe(".toContain(), .toContainEqual()", function()
		--local typedArray = {0, 1}

		-- ROBLOX deviation: skipped test with custom iterator
		itSKIP("iterable", function()
			-- const iterable = {
			-- 	*[Symbol.iterator]() {
			-- 		yield 1;
			-- 		yield 2;
			-- 		yield 3;
			-- 	}
			-- }

			-- jestExpect(iterable).toContain(2);
			-- jestExpect(iterable).toContainEqual(2);
			-- expect(() => jestExpect(iterable).not.toContain(1)).toThrowError(
			-- 	'toContain',
			-- )
			-- expect(() => jestExpect(iterable).not.toContainEqual(1)).toThrowError(
			-- 	'toContainEqual',
			-- )
		end)

		for _, testCase in
			ipairs({
				{ { 1, 2, 3, 4 }, 1 },
				{ { "a", "b", "c", "d" }, "a" },
				{ { Symbol.for_("a") }, Symbol.for_("a") },
				{ "abcdef", "abc" },
				{ "11112111", "2" },
				{ Set.new({ "abc", "def" }), "abc" },
				{ { 0, 1 }, 1 },
			})
		do
			it(string.format("'%s' contains '%s'", stringify(testCase[1]), stringify(testCase[2])), function()
				jestExpect(testCase[1]).toContain(testCase[2])

				jestExpect(function()
					jestExpect(testCase[1]).never.toContain(testCase[2])
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		--[[
			ROBLOX deviation: skipped since BigInt doesn't exist in Luau
			original code lines 1461 - 1470
		]]

		for _, testCase in
			ipairs({
				{ { 1, 2, 3 }, 4 },
				{ { {}, {} }, {} },
			})
		do
			it(string.format("'%s' does not contain '%s'", stringify(testCase[1]), stringify(testCase[2])), function()
				jestExpect(testCase[1]).never.toContain(testCase[2])

				jestExpect(function()
					jestExpect(testCase[1]).toContain(testCase[2])
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		--[[
			ROBLOX deviation: skipped since BigInt doesn't exist in Luau
			original code lines 1487 - 1493
		]]

		it("error cases", function()
			jestExpect(function()
				jestExpect(nil).toContain(1)
			end).toThrowErrorMatchingSnapshot()
			jestExpect(function()
				jestExpect("-0").toContain(-0)
			end).toThrowErrorMatchingSnapshot()
			-- ROBLOX deviation START: Lua specific case for `nil`
			jestExpect(function()
				jestExpect("nil").toContain(nil)
			end).toThrowErrorMatchingSnapshot()
			-- ROBLOX deviation END
			jestExpect(function()
				jestExpect("null").toContain(nil)
			end).toThrowErrorMatchingSnapshot()
			jestExpect(function()
				jestExpect("undefined").toContain(nil)
			end).toThrowErrorMatchingSnapshot()
			jestExpect(function()
				jestExpect("false").toContain(false)
			end).toThrowErrorMatchingSnapshot()
			-- ROBLOX deviation START: skipped since BigInt doesn't exist in Luau
			-- jestExpect(function()
			-- 	return jestExpect('1').toContain(BigInt(1))
			-- end).toThrowError('toContain')
			-- ROBLOX deviation END
		end)

		for _, testCase in
			ipairs({
				{ { 1, 2, 3, 4 }, 1 },
				{ { "a", "b", "c", "d" }, "a" },
				{ { Symbol.for_("a") }, Symbol.for_("a") },
				{ { { a = "b" }, { a = "c" } }, { a = "b" } },
				{ Set.new({ 1, 2, 3, 4 }), 1 },
				{ { 0, 1 }, 1 },
				{ { { 1, 2 }, { 3, 4 } }, { 3, 4 } },
			})
		do
			it(
				string.format("'%s' contains a value equal to '%s'", stringify(testCase[1]), stringify(testCase[2])),
				function()
					jestExpect(testCase[1]).toContainEqual(testCase[2])

					jestExpect(function()
						jestExpect(testCase[1]).never.toContainEqual(testCase[2])
					end).toThrowErrorMatchingSnapshot()
				end
			)
		end

		for _, testCase in
			ipairs({
				{ { { a = "b" }, { a = "c" } }, { a = "d" } },
			})
		do
			it(
				string.format(
					"'%s' does not contain a value equal to '%s'",
					stringify(testCase[1]),
					stringify(testCase[2])
				),
				function()
					jestExpect(testCase[1]).never.toContainEqual(testCase[2])

					jestExpect(function()
						jestExpect(testCase[1]).toContainEqual(testCase[2])
					end).toThrowErrorMatchingSnapshot()
				end
			)
		end

		it("error cases for toContainEqual", function()
			jestExpect(function()
				jestExpect(nil).toContainEqual(1)
			end).toThrowErrorMatchingSnapshot()
		end)
	end)

	describe(".toBeCloseTo", function()
		for _, testCase in
			ipairs({
				{ 0, 0 },
				{ 0, 0.001 },
				{ 1.23, 1.229 },
				{ 1.23, 1.226 },
				{ 1.23, 1.225 },
				{ 1.23, 1.234 },
				{ math.huge, math.huge },
				{ -math.huge, -math.huge },
			})
		do
			local n1 = testCase[1]
			local n2 = testCase[2]
			it(string.format("{pass: true} expect(%s).toBeCloseTo(%s)", n1, n2), function()
				jestExpect(n1).toBeCloseTo(n2)

				jestExpect(function()
					jestExpect(n1).never.toBeCloseTo(n2)
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		for _, testCase in
			ipairs({
				{ 0, 0.01 },
				{ 1, 1.23 },
				{ 1.23, 1.2249999 },
				{ math.huge, -math.huge },
				{ math.huge, 1.23 },
				{ -math.huge, -1.23 },
			})
		do
			local n1 = testCase[1]
			local n2 = testCase[2]
			it(string.format("{pass: false} expect(%s).toBeCloseTo(%s)", n1, n2), function()
				jestExpect(n1).never.toBeCloseTo(n2)

				jestExpect(function()
					jestExpect(n1).toBeCloseTo(n2)
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		for _, testCase in
			ipairs({
				{ 0, 0.1, 0 },
				{ 0, 0.0001, 3 },
				{ 0, 0.000004, 5 },
				{ 2.0000002, 2, 5 },
			})
		do
			local n1 = testCase[1]
			local n2 = testCase[2]
			local p = testCase[3]
			it(string.format("{pass: true} expect(%s).toBeCloseTo(%s, %s)", n1, n2, p), function()
				jestExpect(n1).toBeCloseTo(n2, p)

				jestExpect(function()
					jestExpect(n1).never.toBeCloseTo(n2, p)
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		describe("throws: Matcher error", function()
			it("promise empty isNot false received", function()
				local precision = 3
				local expected = 0
				local received = ""

				jestExpect(function()
					jestExpect(received).toBeCloseTo(expected, precision)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("promise empty isNot true expected", function()
				local received = 0.1
				-- expected is undefined
				jestExpect(function()
					jestExpect(received).never.toBeCloseTo()
				end).toThrowErrorMatchingSnapshot()
			end)

			-- ROBLOX deviation: omitted promise rejects and resolve tests
		end)
	end)

	describe(".toMatch()", function()
		for _, testCase in
			ipairs({
				{ "foo", "foo" },
				{ "Foo bar", "[fF][oO][oO]" }, -- case insensitive match
				{ "Foo bar", RegExp("^Foo", "i") }, -- ROBLOX TODO: change to ^foo when "i" flag is working
			})
		do
			local n1 = testCase[1]
			local n2 = testCase[2]
			it(string.format("{pass: true} expect(%s).toMatch(%s)", n1, tostring(n2)), function()
				jestExpect(n1).toMatch(n2)
			end)
		end

		for _, testCase in
			ipairs({
				{ "bar", "foo" },
				{ "bar", RegExp("foo") },
			})
		do
			local n1 = testCase[1]
			local n2 = testCase[2]
			it(string.format("throws: [%s, %s]", n1, tostring(n2)), function()
				jestExpect(function()
					jestExpect(n1).toMatch(n2)
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		for _, testCase in
			ipairs({
				{ 1, "foo" },
				{ {}, "foo" },
				{ true, "foo" },
				{ RegExp("foo", "i"), "foo" },
				{ function() end, "foo" },
				{ nil, "foo" },
			})
		do
			local n1 = testCase[1]
			local n2 = testCase[2]
			it(
				string.format("throws if non String actual value passed: [%s, %s]", stringify(n1), stringify(n2)),
				function()
					jestExpect(function()
						jestExpect(n1).toMatch(n2)
					end).toThrowErrorMatchingSnapshot()
				end
			)
		end

		for _, testCase in
			ipairs({
				{ "foo", 1 },
				{ "foo", {} },
				{ "foo", true },
				{ "foo", function() end },
				{ "foo", nil },
			})
		do
			local n1 = testCase[1]
			local n2 = testCase[2]
			it(
				string.format(
					"throws if non String/RegExp expected value passed: [%s, %s]",
					stringify(n1),
					stringify(n2)
				),
				function()
					jestExpect(function()
						jestExpect(n1).toMatch(n2)
					end).toThrowErrorMatchingSnapshot()
				end
			)
		end

		-- ROBLOX deviation: we use toContain here as in our translation toMatch is
		-- used for patterns and toContain is used for explicit string matching
		it("escapes strings properly", function()
			jestExpect("this?: throws").toContain("this?: throws")
		end)

		it("does not maintain RegExp state between calls", function()
			local regex = RegExp("[fF]\\d+", "i") -- ROBLOX TODO: change to [f] when "i" flag is working

			jestExpect("f123").toMatch(regex)
			jestExpect("F456").toMatch(regex)
			-- ROBLOX deviation: omitted expect call for RegExp state
		end)

		it("tests regex logic", function()
			jestExpect("Cristopher").never.toMatch("Stop")
			jestExpect("Cristopher").toMatch("stop")
			jestExpect("Cristopher").never.toMatch(RegExp("Stop"))
			jestExpect("Cristopher").toMatch(RegExp("stop"))
		end)
	end)

	describe(".toHaveLength", function()
		-- ROBLOX deviation: {function() end, 0} is omitted, can't get the argument count of a function in Lua
		for _, testCase in
			ipairs({
				{ { 1, 2 }, 2 },
				{ {}, 0 },
				{ { "a", "b" }, 2 },
				{ "", 0 },
			})
		do
			local received = testCase[1]
			local length = testCase[2]
			local testname = string.format("{pass: true} expect(%s).toHaveLength(%s)", stringify(received), length)
			it(testname, function()
				jestExpect(received).toHaveLength(length)
				jestExpect(function()
					jestExpect(received).never.toHaveLength(length)
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		-- ROBLOX deviation: custom test to allow for Lua objects with a length value
		local obj = { length = 12 }
		it(string.format("{pass: false} expect(%s).toHaveLength(12)", stringify(obj)), function()
			jestExpect(obj).toHaveLength(12)
		end)

		-- ROBLOX deviation: omitted function test, no argument count of function in lua
		for _, testCase in
			ipairs({
				{ { 1, 2 }, 3 },
				{ {}, 1 },
				{ { "a", "b" }, 99 },
				{ "abc", 66 },
				{ "", 1 },
			})
		do
			local received = testCase[1]
			local length = testCase[2]
			local testname = string.format("{pass: false} expect(%s).toHaveLength(%s)", stringify(received), length)
			it(testname, function()
				jestExpect(received).never.toHaveLength(length)
				jestExpect(function()
					jestExpect(received).toHaveLength(length)
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		it("error cases", function()
			jestExpect(function()
				jestExpect({ a = 9 }).toHaveLength(1)
			end).toThrowErrorMatchingSnapshot()
			jestExpect(function()
				jestExpect(0).toHaveLength(1)
			end).toThrowErrorMatchingSnapshot()
			jestExpect(function()
				jestExpect(nil).never.toHaveLength(1)
			end).toThrowErrorMatchingSnapshot()
		end)

		describe("matcher error expected length", function()
			it("not number", function()
				local expected = "3"
				local received = "abc"
				jestExpect(function()
					jestExpect(received).never.toHaveLength(expected)
				end).toThrowErrorMatchingSnapshot()
			end)

			-- ROBLOX deviation: remove promise rejects/resolves in the following tests for now
			it("number inf", function()
				local expected = math.huge
				local received = "abc"
				jestExpect(function()
					jestExpect(received).toHaveLength(expected)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("number nan", function()
				local expected = 0 / 0
				local received = "abc"
				jestExpect(function()
					jestExpect(received).never.toHaveLength(expected)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("number float", function()
				local expected = 0.5
				local received = "abc"
				jestExpect(function()
					jestExpect(received).toHaveLength(expected)
				end).toThrowErrorMatchingSnapshot()
			end)

			it("number negative integer", function()
				local expected = -3
				local received = "abc"
				jestExpect(function()
					jestExpect(received).never.toHaveLength(expected)
				end).toThrowErrorMatchingSnapshot()
			end)
		end)
	end)

	describe(".toHaveProperty()", function()
		local pathDiff = { "children", 1 }

		local receivedDiffSingle = {
			children = { '"That cartoon"' },
			props = nil,
			type = "p",
		}

		local valueDiffSingle = '"That cat cartoon"'

		local receivedDiffMultiple = {
			children = {
				"Roses are red.\nViolets are blue.\nTesting with Jest is good for you.",
			},
			props = nil,
			type = "pre",
		}

		local valueDiffMultiple = "Roses are red, violets are blue.\nTesting with Jest\nIs good for you."

		for _, testCase in
			ipairs({
				{ { a = { b = { c = { d = 1 } } } }, "a.b.c.d", 1 },
				{ { a = { b = { c = { d = 1 } } } }, { "a", "b", "c", "d" }, 1 },
				{ { ["a.b.c.d"] = 1 }, { "a.b.c.d" }, 1 },
				{ { a = { b = { 1, 2, 3 } } }, { "a", "b", 2 }, 2 },
				{ { a = { b = { 1, 2, 3 } } }, { "a", "b", 2 }, jestExpect.any("number") },
				{ { a = 0 }, "a", 0 },
				{ { a = { b = false } }, "a.b", false },
				--[[
				ROBLOX deviation: we omit the following test case since it isn't behavior
				we can easily support and maintain consistency with in Lua. The test
				case also looks like it is slated for removal in upstream in the next
				major breaking change
				{{a = {}}, 'a.b', nil}
			]]
				{ { a = { b = { c = 5 } } }, "a.b", { c = 5 } },
				-- ROBLOX TODO: enable following tests
				{ { a = { b = { { c = { { d = 1 } } } } } }, "a.b[1].c[1].d", 1 },
				{ { a = { b = { { c = { d = { { e = 1 }, { f = 2 } } } } } } }, "a.b[1].c.d[2].f", 2 },
				{ { a = { b = { { { c = { { d = 1 } } } } } } }, "a.b[1][1].c[1].d", 1 },
				{ Object.assign({}, { property = 1 }), "property", 1 },
				-- ROBLOX deviation: len isn't a property of an object like it is in JS
				{ "", "len", jestExpect.any("function") },
			})
		do
			local obj = testCase[1]
			local keyPath = testCase[2]
			local value = testCase[3]

			it(
				string.format(
					"{pass: true} expect(%s).toHaveProperty(%s, %s)",
					stringify(obj),
					stringify(keyPath),
					stringify(value)
				),
				function()
					jestExpect(obj).toHaveProperty(keyPath, value)
					jestExpect(function()
						jestExpect(obj).never.toHaveProperty(keyPath, value)
					end).toThrowErrorMatchingSnapshot()
				end
			)
		end

		-- ROBLOX deviation: we omit two test cases where the property to check for
		-- is undefined in upstream and we do not support checking for nil in
		-- toHaveProperty
		for _, testCase in
			ipairs({
				{ { a = { b = { c = { d = 1 } } } }, "a.b.ttt.d", 1 },
				{ { a = { b = { c = { d = 1 } } } }, "a.b.c.d", 2 },
				{ { ["a.b.c.d"] = 1 }, "a.b.c.d", 2 },
				{ { ["a.b.c.d"] = 1 }, { "a.b.c.d" }, 2 },
				{ receivedDiffSingle, pathDiff, valueDiffSingle },
				{ receivedDiffMultiple, pathDiff, valueDiffMultiple },
				{ { a = { b = { c = { d = 1 } } } }, { "a", "b", "c", "d" }, 2 },
				{ { a = { b = { c = {} } } }, "a.b.c.d", 1 },
				{ { a = 1 }, "a.b.c.d", 5 },
				{ {}, "a", "test" },
				--{{a = {b = 3}}, 'a.b', nil},
				{ 1, "a.b.c", "test" },
				{ "abc", "a.b.c", { a = 5 } },
				{ { a = { b = { c = 5 } } }, "a.b", { c = 4 } },
				-- {{a = {}}, 'a.b', nil}
			})
		do
			local obj = testCase[1]
			local keyPath = testCase[2]
			local value = testCase[3]

			it(
				string.format(
					"{pass: false} expect(%s).toHaveProperty(%s, %s)",
					stringify(obj),
					stringify(keyPath),
					stringify(value)
				),
				function()
					jestExpect(function()
						jestExpect(obj).toHaveProperty(keyPath, value)
					end).toThrowErrorMatchingSnapshot()

					jestExpect(obj).never.toHaveProperty(keyPath, value)
				end
			)
		end

		for _, testCase in
			ipairs({
				{ { a = { b = { c = { d = 1 } } } }, "a.b.c.d" },
				{ { a = { b = { c = { d = 1 } } } }, { "a", "b", "c", "d" } },
				{ { ["a.b.c.d"] = 1 }, { "a.b.c.d" } },
				{ { a = { b = { 1, 2, 3 } } }, { "a", "b", 2 } },
				{ { a = 0 }, "a" },
				{ { a = { b = false } }, "a.b" },
			})
		do
			local obj = testCase[1]
			local keyPath = testCase[2]

			it(
				string.format("{pass: true} expect(%s).toHaveProperty(%s)", stringify(obj), stringify(keyPath)),
				function()
					jestExpect(obj).toHaveProperty(keyPath)
					jestExpect(function()
						jestExpect(obj).never.toHaveProperty(keyPath)
					end).toThrowErrorMatchingSnapshot()
				end
			)
		end

		--[[
			ROBLOX TODO: tests not ported yet
			original code:
			[
			  [{a: {b: {c: {}}}}, 'a.b.c.d'],
			  [{a: {b: {c: {}}}}, '.a.b.c'],
			  [{a: 1}, 'a.b.c.d'],
			  [{}, 'a'],
			  [1, 'a.b.c'],
			  ['abc', 'a.b.c'],
			  [false, 'key'],
			  [0, 'key'],
			  ['', 'key'],
			  [Symbol(), 'key'],
			  [Object.assign(Object.create(null), {key: 1}), 'not'],
			].forEach(([obj, keyPath]) => {
			  test(`{pass: false} expect(${stringify(
			    obj,
			  )}).toHaveProperty('${keyPath}')`, () => {
			    expect(() =>
			      jestExpect(obj).toHaveProperty(keyPath),
			    ).toThrowErrorMatchingSnapshot();
			    jestExpect(obj).not.toHaveProperty(keyPath);
			  });
			});
		]]

		for _, testCase in
			ipairs({
				{ nil, "a.b" },
				{ nil, "a" },
				{ { a = { b = {} } }, nil },
				{ { a = { b = {} } }, 1 },
				{ {}, {} },
			})
		do
			local obj = testCase[1]
			local keyPath = testCase[2]

			it(string.format("{error} expect(%s).toHaveProperty(%s)", stringify(obj), stringify(keyPath)), function()
				jestExpect(function()
					jestExpect(obj).toHaveProperty(keyPath)
				end).toThrowErrorMatchingSnapshot()
			end)
		end
	end)

	describe("toMatchObject()", function()
		local function testNotToMatchSnapshots(tuples, innerDescribePath)
			for index, testCase in ipairs(tuples) do
				local n1 = testCase[1]
				local n2 = testCase[2]

				it(string.format("{pass: true} expect(%s).toMatchObject(%s)", stringify(n1), stringify(n2)), function()
					jestExpect(n1).toMatchObject(n2)

					jestExpect(function()
						jestExpect(n1).never.toMatchObject(n2)
					end).toThrowErrorMatchingSnapshot()
				end)
			end
		end

		local function testToMatchSnapshots(tuples)
			for index, testCase in ipairs(tuples) do
				local n1 = testCase[1]
				local n2 = testCase[2]

				it(string.format("{pass: false} expect(%s).toMatchObject(%s)", stringify(n1), stringify(n2)), function()
					jestExpect(n1).never.toMatchObject(n2)

					jestExpect(function()
						jestExpect(n1).toMatchObject(n2)
					end).toThrowErrorMatchingSnapshot()
				end)
			end
		end

		describe("circular references", function()
			describe("simple circular references", function()
				local circularObjA1 = { a = "hello" }
				circularObjA1.ref = circularObjA1

				local circularObjB = { a = "world" }
				circularObjB.ref = circularObjB

				local circularObjA2 = { a = "hello" }
				circularObjA2.ref = circularObjA2

				local primitiveInsteadOfRef = {}
				primitiveInsteadOfRef.ref = "not a ref"

				testNotToMatchSnapshots({
					{ circularObjA1, {} },
					{ circularObjA2, circularObjA1 },
				})

				testToMatchSnapshots({
					{ {}, circularObjA1 },
					{ circularObjA1, circularObjB },
					{ primitiveInsteadOfRef, circularObjA1 },
				})
			end)

			describe("transitive circular references", function()
				local transitiveCircularObjA1 = { a = "hello" }
				transitiveCircularObjA1.nestedObj = { parentObj = transitiveCircularObjA1 }

				local transitiveCircularObjA2 = { a = "hello" }
				transitiveCircularObjA2.nestedObj = {
					parentObj = transitiveCircularObjA2,
				}

				local transitiveCircularObjB = { a = "world" }
				transitiveCircularObjB.nestedObj = {
					parentObj = transitiveCircularObjB,
				}

				local primitiveInsteadOfRef = {}
				primitiveInsteadOfRef.nestedObj = {
					parentObj = "not the parent ref",
				}

				testNotToMatchSnapshots({
					{ transitiveCircularObjA1, {} },
					{ transitiveCircularObjA2, transitiveCircularObjA1 },
				})

				testToMatchSnapshots({
					{ {}, transitiveCircularObjA1 },
					{ transitiveCircularObjB, transitiveCircularObjA1 },
					{ primitiveInsteadOfRef, transitiveCircularObjA1 },
				})
			end)
		end)

		testNotToMatchSnapshots({
			{ { a = "b", c = "d" }, { a = "b" } },
			{
				{ a = "b", c = "d" },
				{ a = "b", c = "d" },
			},
			{
				{ a = "b", t = { x = { r = "r" }, z = "z" } },
				{ a = "b", t = { z = "z" } },
			},
			{ { a = "b", t = { x = { r = "r" }, z = "z" } }, { t = { x = { r = "r" } } } },
			{ { a = { 3, 4, 5 }, b = "b" }, { a = { 3, 4, 5 } } },
			{ { a = { 3, 4, 5, "v" }, b = "b" }, { a = { 3, 4, 5, "v" } } },
			{ { a = 1, c = 2 }, { a = jestExpect.any("number") } },
			{ { a = { x = "x", y = "y" } }, { a = { x = jestExpect.any("string") } } },
			{ Set.new({ 1, 2 }), Set.new({ 1, 2 }) },
			{ Set.new({ 1, 2 }), Set.new({ 2, 1 }) },
			{
				{ a = DateTime.fromUniversalTime(2015, 11, 30), b = "b" },
				{
					a = DateTime.fromUniversalTime(2015, 11, 30),
				},
			},
			-- {{a = nil, b = 'b'}, {a = nil}}, -- funky test
			{ { a = "undefined", b = "b" }, { a = "undefined" } },
			{ { a = { { a = "a", b = "b" } } }, { a = { { a = "a" } } } },
			{
				{ 1, 2 },
				{ 1, 2 },
			},
			{ {}, {} },
			{
				{ a = "b", c = "d", [Symbol.for_("jest")] = "jest" },
				{ a = "b", [Symbol.for_("jest")] = "jest" },
			},
			{
				{ a = "b", c = "d", [Symbol.for_("jest")] = "jest" },
				{ a = "b", c = "d", [Symbol.for_("jest")] = "jest" },
			},
		}, "")

		testToMatchSnapshots({
			{ { a = "b", c = "d" }, { e = "b" } },
			{
				{ a = "b", c = "d" },
				{ a = "b!", c = "d" },
			},
			{ { a = "a", c = "d" }, { a = jestExpect.any("number") } },
			{
				{ a = "b", t = { x = { r = "r" }, z = "z" } },
				{ a = "b", t = { z = { 3 } } },
			},
			{ { a = "b", t = { x = { r = "r" }, z = "z" } }, { t = { l = { r = "r" } } } },
			{ { a = { 3, 4, 5 }, b = "b" }, { a = { 3, 4, 5, 6 } } },
			{ { a = { 3, 4, 5 }, b = "b" }, { a = { 3, 4 } } },
			{ { a = { 3, 4, "v" }, b = "b" }, { a = { "v" } } },
			{ { a = { 3, 4, 5 }, b = "b" }, { a = { b = 4 } } },
			{ { a = { 3, 4, 5 }, b = "b" }, { a = { b = jestExpect.any("string") } } },
			{
				{ 1, 2 },
				{ 1, 3 },
			},
			{ { 0 }, { -0 } },
			{ Set.new({ 1, 2 }), Set.new({ 2 }) },
		})

		for _, testCase in
			ipairs({
				{ nil, {} },
				{ 4, {} },
				{ "44", {} },
				{ true, {} },
				{ {}, nil },
				{ {}, 4 },
				{ {}, "some string" },
				{ {}, true },
			})
		do
			local n1 = testCase[1]
			local n2 = testCase[2]

			it(string.format("throws expect(%s).toMatchObject(%s)", stringify(n1), stringify(n2)), function()
				jestExpect(function()
					jestExpect(n1).toMatchObject(n2)
				end).toThrowErrorMatchingSnapshot()
			end)
		end

		it("does not match properties up in the prototype chain", function()
			local a = {}
			a.ref = a

			local b = {}
			setmetatable(b, { __index = a })
			b.other = "child"

			local matcher = { other = "child" }
			matcher.ref = matcher

			jestExpect(b).never.toMatchObject(matcher)

			jestExpect(function()
				jestExpect(b).toMatchObject(matcher)
			end).toThrowErrorMatchingSnapshot()
		end)
	end)

	return {}
end)()
