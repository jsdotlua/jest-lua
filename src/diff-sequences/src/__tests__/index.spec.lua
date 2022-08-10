-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/diff-sequences/src/__tests__/index.test.ts
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

	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Number = LuauPolyfill.Number
	local Object = LuauPolyfill.Object
	local Array = LuauPolyfill.Array
	local Error = LuauPolyfill.Error
	type Array<T> = LuauPolyfill.Array<T>

	type Function = (...any) -> ...any

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local describe = (JestGlobals.describe :: any) :: Function
	local it = (JestGlobals.it :: any) :: Function
	local itSKIP = JestGlobals.it.skip

	local diff = require(CurrentModule)

	-- ROBLOX deviation: lua does not allow string indexing, so we convert string inputs to arrays
	local function stringToArray(s: string): Array<any>
		local t = {}
		for first, last in utf8.graphemes(s) do
			table.insert(t, s:sub(first, last))
		end
		return t
	end

	describe("invalid arg", function()
		local isCommon = function()
			return false
		end
		local foundSubsequence = function()
			return {}
		end

		describe("length", function()
			it("is not a number", function()
				jestExpect(function()
					-- ROBLOX deviation: overriding type checking on purpose
					diff("0" :: any, 0, isCommon, foundSubsequence)
				end).toThrow("aLength")
			end)
			it("Infinity is not a safe integer", function()
				jestExpect(function()
					diff(math.huge, 0, isCommon, foundSubsequence)
				end).toThrow("aLength")
			end)
			itSKIP("Not a Number is not a safe integer", function()
				jestExpect(function()
					diff(Number.NaN, 0, isCommon, foundSubsequence)
				end).toThrow("aLength")
			end)

			it("MAX_SAFE_INTEGER + 1 is not a safe integer", function()
				jestExpect(function()
					diff(0, Number.MAX_SAFE_INTEGER + 1, isCommon, foundSubsequence)
				end).toThrow("bLength")
			end)
			it("MIN_SAFE_INTEGER - 1 is not a safe integer", function()
				jestExpect(function()
					diff(0, Number.MIN_SAFE_INTEGER - 1, isCommon, foundSubsequence)
				end).toThrow("bLength")
			end)
			it("is a negative integer", function()
				jestExpect(function()
					diff(0, -1, isCommon, foundSubsequence)
				end).toThrow("bLength")
			end)
		end)

		describe("callback", function()
			it("nil is not a function", function()
				jestExpect(function()
					-- ROBLOX deviation: overriding type checking on purpose
					diff(0, 0, nil :: any, foundSubsequence)
				end).toThrow("isCommon")
			end)

			-- ROBLOX note: this actually tests a separate parameter than the above test
			it("undefined is not a function", function()
				jestExpect(function()
					-- ROBLOX deviation: overriding type checking on purpose
					diff(0, 0, isCommon, nil :: any)
				end).toThrow("foundSubsequence")
			end)
		end)
	end)

	-- Return length of longest common subsequence according to Object.is method.
	local function countCommonObjectIs(a, b)
		local n = 0
		diff(#a, #b, function(aIndex, bIndex)
			return Object.is(a[aIndex + 1], b[bIndex + 1])
		end, function(nCommon)
			n = n + nCommon
		end)
		return n
	end

	-- Return length of longest common subsequence according to === operator.
	local function countCommonStrictEquality(a, b)
		local n = 0
		diff(#a, #b, function(aIndex, bIndex)
			return a[aIndex + 1] == b[bIndex + 1]
		end, function(nCommon)
			n = n + nCommon
		end)
		return n
	end

	describe("input callback encapsulates comparison", function()
		describe("zero and negative zero", function()
			local a = { 0 }
			local b = { -0 }

			it("are not common according to Object.is method", function()
				jestExpect(countCommonObjectIs(a, b)).toEqual(0)
			end)
			it("are not common according to == method", function()
				jestExpect(countCommonStrictEquality(a, b)).toEqual(1)
			end)
		end)
	end)

	describe("Not a number", function()
		-- input callback encapsulates identical sequences
		local a = { Number.NaN }

		it("is common according to Object.is method", function()
			jestExpect(countCommonObjectIs(a, a)).toEqual(1)
		end)
		it("is not common according to === operator", function()
			jestExpect(countCommonStrictEquality(a, a)).toEqual(0)
		end)
	end)

	local function assertMin(name: string, val: number, min: number)
		if val < min then
			error(string.format("%s value %s is less than min %s", name, tostring(val), tostring(min)))
		end
	end

	local function assertMax(name: string, val: number, max: number)
		if max < val then
			error(string.format("%s value %s is less than max %s", name, tostring(val), tostring(max)))
		end
	end

	local function assertEnd(name: string, val: number, end_: number)
		if end_ <= val then
			error(string.format("%s value %s is not less than end %s", name, tostring(val), tostring(end_)))
		end
	end

	local function assertCommonItems(
		a_: Array<any> | string,
		b_: Array<any> | string,
		nCommon: number,
		aCommon: number,
		bCommon: number
	)
		-- ROBLOX deviation: lua does not allow string indexing, so we convert string inputs to arrays
		local a = if type(a_) == "string" then stringToArray(a_) else a_
		local b = if type(b_) == "string" then stringToArray(b_) else b_

		while nCommon ~= 0 do
			if a[aCommon + 1] ~= b[bCommon + 1] then
				error(
					string.format(
						"output item is not common for aCommon=%s and bCommon=%s",
						tostring(aCommon),
						tostring(bCommon)
					)
				)
			end
			nCommon = nCommon - 1
			aCommon = aCommon + 1
			bCommon = bCommon + 1
		end
	end

	-- Given lengths of sequences and input function to compare items at indexes,
	-- return number of differences according to baseline greedy forward algorithm.
	local function countDifferences(aLength: number, bLength: number, isCommon): number
		local dMax = aLength + bLength
		local aIndexes = { -1 } -- initialize for aLast + 1 in loop when d = 0

		for d = 0, dMax do
			local aIndexPrev1 = 0 -- that is, not yet set

			local iF = 0
			local kF = -d
			while iF <= d do
				local aFirst = (iF == 0 or (iF ~= d and aIndexPrev1 < aIndexes[iF + 1])) and aIndexes[iF + 1]
					or aIndexPrev1 + 1

				-- To get last point of path segment, move along diagonal of common items.
				local aLast = aFirst
				local bLast = aFirst - kF
				while aLast + 1 < aLength and bLast + 1 < bLength and isCommon(aLast + 1, bLast + 1) do
					aLast += 1
					bLast += 1
				end

				aIndexPrev1 = aIndexes[iF + 1]
				aIndexes[iF + 1] = aLast

				if aLast == aLength - 1 and bLast == bLength - 1 then
					return d
				end
				iF += 1
				kF += 2
			end
		end
		error(Error.new("countDifferences did not return a number"))
	end

	-- Return array of items in a longest common subsequence of array-like objects.
	local function findCommonItems(a_: Array<any> | string, b_: Array<any> | string): Array<any>
		-- ROBLOX deviation: lua does not allow string indexing, so we convert string inputs to arrays
		local a = if type(a_) == "string" then stringToArray(a_) else a_
		local b = if type(b_) == "string" then stringToArray(b_) else b_

		local aLength = #a
		local bLength = #b
		local isCommon = function(aIndex: number, bIndex: number)
			assertMin("input aIndex", aIndex, 0)
			assertEnd("input aIndex", aIndex, aLength)
			assertMin("input bIndex", bIndex, 0)
			assertEnd("input bIndex", bIndex, bLength)
			return a[aIndex + 1] == b[bIndex + 1]
		end

		local array: Array<any> = {}
		diff(aLength, bLength, isCommon, function(nCommon, aCommon, bCommon)
			assertMin("output nCommon", nCommon, 1)
			assertMin("output aCommon", aCommon, 0)
			assertMax("output aCommon + nCommon", aCommon + nCommon, aLength)
			assertMin("output bCommon", bCommon, 0)
			assertMax("output bCommon + nCommon", bCommon + nCommon, bLength)
			assertCommonItems(a, b, nCommon, aCommon, bCommon)
			while nCommon ~= 0 do
				table.insert(array, a[aCommon + 1])
				nCommon -= 1
				aCommon += 1
			end
		end)

		local nDifferences = countDifferences(aLength, bLength, isCommon)
		jestExpect(aLength + bLength - 2 * #array).toBe(nDifferences)

		return array
	end

	-- Assert that array-like objects have the expected common items.
	local function expectCommonItems(a: Array<any> | string, b: Array<any> | string, expected: Array<any>): ()
		-- ROBLOX deviation: lua does not allow string indexing, so we convert string inputs to arrays
		if type(a) == "string" then
			a = stringToArray(a)
		end
		if type(b) == "string" then
			b = stringToArray(b)
		end
		if type(expected) == "string" then
			expected = stringToArray(expected)
		end

		jestExpect(findCommonItems(a, b)).toEqual(expected)

		if #a ~= #b then
			-- If sequences a and b have different lengths,
			-- then if you swap sequences in your callback functions,
			-- this package finds the same items.
			jestExpect(findCommonItems(b, a)).toEqual(expected)
		end
	end

	describe("input callback encapsulates sequences", function()
		-- Example sequences in “edit graph” analogy from
		-- An O(ND) Difference Algorithm and Its Variations by Eugene W. Myers
		local a = { "a", "b", "c", "a", "b", "b", "a" }
		local b = { "c", "b", "a", "b", "a", "c" }

		-- Because a and b have more than one longest common subsequence,
		-- expected value might change if implementation changes.
		-- For example, Myers paper shows: ['c', 'a', 'b', 'a']
		local expected = { "c", "b", "b", "a" }

		it("arrays of strings", function()
			expectCommonItems(a, b, expected)
		end)
		it("string and array of strings", function()
			expectCommonItems(table.concat(a, ""), b, expected)
		end)
		it("strings", function()
			expectCommonItems(table.concat(a, ""), table.concat(b, ""), expected)
		end)
	end)

	describe("no common items", function()
		-- default export does not call findSubsequences nor divide
		describe("negative zero is equivalent to zero for length", function()
			local function countItemsNegativeZero(aLength, bLength)
				local n = 0
				diff(aLength, bLength, function()
					error("input function should not have been called")
				end, function(nCommon)
					n = n + nCommon
				end)
				return n
			end

			it("of a", function()
				jestExpect(countItemsNegativeZero(-0, 1)).toEqual(0)
			end)
			it("of b", function()
				jestExpect(countItemsNegativeZero(1, -0)).toEqual(0)
			end)
			it("of a and b", function()
				jestExpect(countItemsNegativeZero(-0, -0)).toEqual(0)
			end)
		end)

		it("a empty and b empty", function()
			local a = {}
			local b = {}
			local expected = {}
			expectCommonItems(a, b, expected)
		end)
		it("a empty and b non-empty", function()
			local a = {}
			local b = { false }
			local expected = {}
			expectCommonItems(a, b, expected)
		end)
		it("a non-empty and b empty", function()
			local a = { false, true }
			local b = {}
			local expected = {}
			expectCommonItems(a, b, expected)
		end)

		describe("a non-empty and b non-empty", function()
			it("baDeltaLength 0 even", function()
				-- findSubsequences not transposed because graph is square
				-- reverse path overlaps on first iteration with d === 1
				-- last segment cannot have a prev segment
				local a = { false }
				local b = { true }
				local expected = {}
				expectCommonItems(a, b, expected)
			end)
			it("baDeltaLength 1 odd", function()
				-- findSubsequences transposed because graph has landscape orientation
				-- forward path overlaps on first iteration with d === 2
				-- last segment has a prev segment because unroll a half iteration
				local a = { 0, 1 }
				local b = { "0" }
				local expected = {}
				expectCommonItems(a, b, expected)
			end)
			it("baDeltaLength 2 even", function()
				-- findSubsequences transposed because graph has landscape orientation
				-- reverse path overlaps with d === 3
				-- last segment has a prev segment
				local a = { 0, 1, 2, 3 }
				local b = { "0", "1" }
				local expected = {}
				expectCommonItems(a, b, expected)
			end)
			it("baDeltaLength 7 odd", function()
				-- findSubsequences not transposed because graph has portrait orientation
				-- forward path overlaps with d === 7
				-- last segment has a prev segment
				local a = { "0", "1", "2" }
				local b = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
				local expected = {}
				expectCommonItems(a, b, expected)
			end)
		end)
	end)

	describe("only common items", function()
		-- input callback encapsulates identical sequences
		-- default export trims common items from the start
		-- default export does not call findSubsequences nor divide
		it("length 1", function()
			local a = { false }
			expectCommonItems(a, a, a)
		end)
		it("length 2", function()
			local a = { false, true }
			expectCommonItems(a, a, a)
		end)
	end)

	describe("all common items outside", function()
		local common1 = "common1"
		local common2 = "common2"
		local common3 = "common3"

		it("preceding changes", function()
			local a = { common1 }
			local b = { common1, "insert1", "insert2" }
			local expected = { common1 }
			expectCommonItems(a, b, expected)
		end)
		it("following change", function()
			local a = { "delete1", common1, common2 }
			local b = { common1, common2 }
			local expected = { common1, common2 }
			expectCommonItems(a, b, expected)
		end)
		it("preceding and following changes in one sequence", function()
			local a = { common1, common2, "delete1", "delete2", common3 }
			local b = { common1, common2, common3 }
			local expected = { common1, common2, common3 }
			expectCommonItems(a, b, expected)
		end)
	end)

	describe("some common items inside and outside", function()
		local common1 = "common1"
		local common2 = "common2"

		it("preceding changes adjacent to common in both sequences", function()
			-- default export trims common item from the start
			-- baDeltaLength 0 even
			-- common item follows last (only) reverse segment when d === 1
			local a = { common1, common2, "delete1_lastR" }
			local b = { common1, "insert1", common2 }
			local expected = { common1, common2 }
			expectCommonItems(a, b, expected)
		end)
		it("following changes adjacent to common in both sequences", function()
			-- default export trims common item from the end
			-- baDeltaLength 1 odd
			-- common item follows prev (but not last) forward segment when d === 2
			local a = { common1, "delete1", common2 }
			local b = { "insert1_prevF", common1, "insert2_lastF", common2 }
			local expected = { common1, common2 }
			expectCommonItems(a, b, expected)
		end)
	end)

	describe("all common items inside non-recursive", function()
		-- The index intervals preceding and following the middle change
		-- contain only changes, therefore they cannot contain any common items.
		local common1 = "common1"
		local common2 = "common2"
		local common3 = "common3"

		it("move from start to end relative to change", function()
			-- baDeltaLength 0 even
			-- common items follow last (only) reverse segment when d === 1
			local a = { common1, common2, "delete1" }
			local b = { "insert1", common1, common2 }
			local expected = { common1, common2 }
			expectCommonItems(a, b, expected)
		end)
		it("move from start to end relative to common", function()
			-- baDeltaLength 0 even
			-- common items follow last (only) reverse segment when d === 1
			local a = { common1, common2, common3 }
			local b = { common3, common1, common2 }
			-- common3 is delete from a and insert from b
			local expected = { common1, common2 }
			expectCommonItems(a, b, expected)
		end)
		it("move from start to end relative to change and common", function()
			-- baDeltaLength 0 even
			-- common items follow last reverse segment when d === 3
			local a = { common1, common2, "delete1_lastR", common3, "delete2" }
			local b = { "insert1", common3, "insert2", common1, common2 }
			-- common3 is delete from a and insert from b
			local expected = { common1, common2 }
			expectCommonItems(a, b, expected)
		end)
		it("reverse relative to change", function()
			-- baDeltaLength 0 even
			-- common item follows last reverse segment when d === 4
			local a = { common1, "delete1", common2, "delete2", common3 }
			local b = { common3, "insert1_lastR", common2, "insert2", common1 }

			-- Because a and b have more than one longest common subsequence,
			-- expected value might change if implementation changes.
			-- common1 and common2 are delete from a and insert from b
			local expected = { common3 }
			expectCommonItems(a, b, expected)
		end)

		it("preceding middle", function()
			-- baDeltaLength 1 odd
			-- common items follow prev and last forward segments when d === 3
			local a = { "delete1", common1, common2, common3, "delete2" }
			local b = {
				"insert1_prevF",
				common1,
				"insert2_lastF",
				common2,
				common3,
				"insert3",
			}
			local expected = { common1, common2, common3 }
			expectCommonItems(a, b, expected)
		end)
		it("following middle", function()
			-- baDeltaLength 2 even
			-- common items follow prev and last reverse segments when d === 4
			local a = { "delete1", "delete2", common1, common2, common3, "delete3" }
			local b = {
				"insert1",
				"insert2",
				common1,
				common2,
				"insert3_lastR",
				common3,
				"insert4_prevR",
				"insert5",
			}
			local expected = { common1, common2, common3 }
			expectCommonItems(a, b, expected)
		end)
	end)

	describe("all common items inside recursive", function()
		-- Because a and b have only one longest common subsequence,
		-- expected value cannot change if implementation changes.
		local common1 = "common1"
		local common2 = "common2"
		local common3 = "common3"
		local common4 = "common4"
		local common5 = "common5"
		local common6 = "common6"

		it("prev reverse at depth 1 and preceding at depth 2", function()
			-- depth 1 common item follows prev reverse segment when d === 3
			-- depth 2 preceding common items follow prev and last forward segments when d === 2
			local a = {
				"delete1_depth2_preceding_prevF",
				common1,
				common2,
				common3,
				"delete2_depth1_prevR",
				"delete3",
			}
			local b = {
				common1,
				"insert1_depth2_preceding_lastF",
				common2,
				"insert2",
				"insert3_depth1_lastR",
				common3,
			}
			local expected = { common1, common2, common3 }
			expectCommonItems(a, b, expected)
		end)
		it("last forward at depth 1 and following at depth 2", function()
			-- depth 1 common item follows last forward segment when d === 5
			-- depth 2 following common items follow prev and last reverse segments when d === 2
			local a = {
				"delete1",
				"delete2",
				common1,
				"delete3",
				common2,
				"delete4_depth2_following_lastR",
				common3,
			}
			local b = {
				"insert1",
				"insert2",
				"insert3_depth1_lastF",
				common1,
				"insert4",
				common2,
				common3,
				"insert5_depth2_following_prevR",
			}
			local expected = { common1, common2, common3 }
			expectCommonItems(a, b, expected)
		end)
		it("preceding at depth 2 and both at depth 3 of following", function()
			-- depth 1 transposed from landscape to portrait so swap args
			-- depth 1 common items do not follow prev nor last forward segment when d === 8
			-- depth 2 preceding common item follows prev forward segment when d === 4
			-- depth 2 following transposed again so unswap swapped args
			-- depth 2 following common items do not follow prev nor last foward segment when d === 4
			-- depth 3 preceding common item follows last forward segment when d === 2
			-- depth 3 following rransposed again so swap args again
			-- depth 3 following common item follows last forward segment when d === 2
			local a = {
				"delete1_depth2_preceding_prevF",
				common1,
				"delete2_depth2_preceding_middle",
				"delete3",
				"delete4",
				"delete5_depth1_middle",
				common2,
				"delete6",
				"delete7",
				"delete8_depth3_following_lastF",
				common3,
			}
			local b = {
				"insert1",
				"insert2",
				common1,
				"insert3",
				"insert4",
				"insert5_depth3_preceding_lastF",
				common2,
				"insert6_depth2_following_middle",
				common3,
				"insert7",
			}
			local expected = { common1, common2, common3 }
			expectCommonItems(a, b, expected)
		end)

		it("interleaved single change", function()
			-- depth 1 common items follow prev and last forward segment when d === 4
			-- depth 2 preceding common items follow prev and last forward segment when d === 2
			-- depth 2 following common items follow prev and last forward segment when d === 2
			local a = { common1, common2, common3, common4, common5, common6 }
			local b = {
				"insert1_depth_2_preceding_prevF",
				common1,
				"insert2_depth2_preceding_lastF",
				common2,
				"insert3_depth1_prevF",
				common3,
				"insert4_depth1_lastF",
				common4,
				"insert5_depth2_following_prevF",
				common5,
				"insert6_depth2_following_lastF",
				common6,
				"insert7",
			}
			local expected = { common1, common2, common3, common4, common5, common6 }
			expectCommonItems(a, b, expected)
		end)
		it("interleaved double changes", function()
			-- depth 1 common item follows prev reverse segment when d === 7
			-- depth 2 preceding transposed from landscape to portrait so swap args
			-- depth 2 preceding common item follows last forward segment when d === 4
			-- depth 3 preceding transposed again so unswap swapped args
			-- depth 3 preceding preceding common item follows last forward segment when d === 2
			-- depth 2 following common item follows prev reverse segment when d === 3
			-- depth 3 following preceding transposed
			-- depth 3 following preceding common item follows last forward segment when d === 2
			local a = {
				"delete1",
				common1,
				"delete2_depth2_preceding_lastF",
				common2,
				"delete3_depth3_preceding_following_lastF",
				common3,
				"delete4",
				common4,
				"delete5_depth3_following_preceding_lastF",
				common5,
				"delete6",
				common6,
				"delete7",
			}
			local b = {
				"insert1_depth3_preceding_preceding_lastF",
				common1,
				"insert2",
				common2,
				"insert3",
				common3,
				"insert4_depth1_middle",
				common4,
				"insert5_depth1_prevR",
				common5,
				"insert6",
				common6,
				"insert7_depth2_following_prevR",
			}
			local expected = { common1, common2, common3, common4, common5, common6 }
			expectCommonItems(a, b, expected)
		end)

		it("optimization decreases iMaxF", function()
			-- iMaxF 3 initially because aLength
			-- iMaxF 1 at d === 4
			-- depth 1 common items do not follow prev nor last forward segment when d === 5
			-- depth 2 preceding common item follows last forward segment when d === 3
			-- depth 3 preceding preceding common item follows last (only) reverse segment when d === 1
			local a = { common1, "delete1_depth3_lastR", common2 }
			local b = {
				"insert1",
				common1,
				"insert2_depth2_lastF",
				common2,
				"insert3",
				"insert4",
				"insert5",
				"insert6",
				"insert7",
				"insert8",
				"insert9",
			}
			local expected = { common1, common2 }
			expectCommonItems(a, b, expected)
		end)
		it("optimization decreases iMaxR", function()
			-- iMaxF 3 initially because aLength
			-- iMaxR 0 at d === 2
			-- depth 1 common items do not follow prev nor last forward segment when d === 5
			-- depth 2 following common items follow prev reverse segment when d === 2
			local a = { common1, common2 }
			local b = {
				"insert1",
				"insert2",
				"insert3",
				"insert4",
				"insert5_depth1_middle",
				"insert6",
				"insert7",
				"insert8_depth2_middle",
				common1,
				common2,
				"insert9_depth2_prevR",
			}
			local expected = { common1, common2 }
			expectCommonItems(a, b, expected)
		end)
	end)

	local function assertCommonSubstring(a: string, b: string, nCommon: number, aCommon: number, bCommon: number)
		local aSubstring = Array.slice(a, aCommon + 1, aCommon + nCommon + 1)
		local bSubstring = Array.slice(b, bCommon + 1, bCommon + nCommon + 1)
		if table.concat(aSubstring, "") ~= table.concat(bSubstring, "") then
			error(
				Error.new(
					string.format(
						"output substrings %s and %s are not common for nCommon=%d aCommon=%d bCommon =%d",
						aSubstring,
						bSubstring,
						nCommon,
						aCommon,
						bCommon
					)
				)
			)
		end
	end

	local function findCommonSubstrings(a: any, b: any): Array<string>
		local array = {}
		-- ROBLOX deviation: manually translate string to char array
		a = stringToArray(a)
		b = stringToArray(b)

		diff(#a, #b, function(aIndex: number, bIndex: number): boolean
			assertMin("input aIndex", aIndex, 0)
			assertEnd("input aIndex", aIndex, #a)
			assertMin("input bIndex", bIndex, 0)
			assertEnd("input bIndex", bIndex, #b)
			return a[aIndex + 1] == b[bIndex + 1]
		end, function(nCommon: number, aCommon: number, bCommon: number): ()
			assertMin("output nCommon", nCommon, 1)
			assertMin("output aCommon", aCommon, 0)
			assertMax("output aCommon + nCommon", aCommon + nCommon, #a)
			assertMin("output bCommon", bCommon, 0)
			assertMax("output bCommon + nCommon", bCommon + nCommon, #b)
			assertCommonSubstring(a, b, nCommon, aCommon, bCommon)
			table.insert(array, Array.slice(a, aCommon + 1, aCommon + nCommon + 1))
		end)
		local retval = {}
		for _, v in ipairs(array) do
			if type(v) == "table" then
				table.insert(retval, table.concat(v, ""))
			else
				table.insert(retval, v)
			end
		end
		return retval
	end

	describe("common substrings", function()
		-- Find changed and unchanged substrings within adjacent changed lines
		-- in expected and received values after a test fails in Jest.
		it("progress", function()
			-- Confirm expected progress. If change is correct, then update test.
			-- A property value changes from an object to an array of objects.
			local a = table.concat({
				'"sorting": Object {',
				'"ascending": true,',
			}, "\n")
			local b = table.concat({
				'"sorting": Array [',
				"Object {",
				'"descending": false,',
			}, "\n")
			local expected = { '"sorting": ', 'Object {\n"', 'scending": ', "e," }
			local abCommonSubstrings = findCommonSubstrings(a, b)
			local baCommonSubstrings = findCommonSubstrings(b, a)
			jestExpect(abCommonSubstrings).toEqual(baCommonSubstrings)
			jestExpect(abCommonSubstrings).toEqual(expected)
		end)
		it("regression", function()
			-- Prevent unexpected regression. If change is incorrect, then fix code.
			-- Internationalization fails for a text node.
			-- English translation and French quotation by Antoine de Saint Exupéry:
			local a =
				"It seems that perfection is attained not when there is nothing more to add, but when there is nothing more to remove."
			local b =
				"Il semble que la perfection soit atteinte non quand il n'y a plus rien à ajouter, mais quand il n'y a plus rien à retrancher."
			local abCommonSubstrings = findCommonSubstrings(a, b)
			local baCommonSubstrings = findCommonSubstrings(b, a)
			jestExpect(abCommonSubstrings).toEqual(baCommonSubstrings)
			jestExpect(abCommonSubstrings).toMatchSnapshot()
		end)
		it("wrapping", function()
			local a = table.concat({
				"When engineers are provided with ready-to-use tools, they end up writing more",
				"tests, which in turn results in more stable code bases.",
			}, "\n")
			local b = table.concat({
				"When engineers have ready-to-use tools, they write more tests, which results in",
				"more stable and healthy code bases.",
			}, "\n")
			local abCommonSubstrings = findCommonSubstrings(a, b)
			local baCommonSubstrings = findCommonSubstrings(b, a)
			jestExpect(abCommonSubstrings).toEqual(baCommonSubstrings)
			jestExpect(abCommonSubstrings).toMatchSnapshot()
		end)
	end)

	return {}
end)()
