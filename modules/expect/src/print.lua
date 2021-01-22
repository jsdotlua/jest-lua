--!nonstrict
-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/expect/src/print.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

local Workspace = script.Parent
local Modules = Workspace.Parent
local Packages = Modules.Parent.Packages

local Polyfills = require(Packages.LuauPolyfill)
local Number = Polyfills.Number

local JestMatcherUtils = require(Modules.JestMatcherUtils)
local EXPECTED_COLOR = JestMatcherUtils.EXPECTED_COLOR
local INVERTED_COLOR = JestMatcherUtils.INVERTED_COLOR
local RECEIVED_COLOR = JestMatcherUtils.RECEIVED_COLOR
local printReceived = JestMatcherUtils.printReceived
local stringify = JestMatcherUtils.stringify

type Array<T> = { T }

-- local printConstructorName

-- // Format substring but do not enclose in double quote marks.
-- // The replacement is compatible with pretty-format package.
local function printSubstring(val: string): string
	val = val:gsub("(\\)", "\\%1")
	val = val:gsub("(\")", "\\%1")
	return val
end

local function printReceivedStringContainExpectedSubstring(
	received: string,
	start: number,
	length: number -- // not end
): string
	return RECEIVED_COLOR('"' ..
		printSubstring(received:sub(1, start))) ..
		INVERTED_COLOR(printSubstring(received:sub(start + 1, start + 1 + length))) ..
		printSubstring(received:sub(start + 1 + length + 1, #received)) ..
		'"'
end

local function printReceivedStringContainExpectedResult(
	received: string,
	result
): string
	if result then
		return printReceivedStringContainExpectedSubstring(
			received,
			result.index,
			result[1].length)
	else
		return printReceived(received)
	end

end

-- // The serialized array is compatible with pretty-format package min option.
-- // However, items have default stringify depth (instead of depth - 1)
-- // so expected item looks consistent by itself and enclosed in the array.
local function printReceivedArrayContainExpectedItem(
	received: Array<any>,
	index: number
): string
	local receivedMap = {}
	for i, item in ipairs(received) do
		local stringified = stringify(item)
		if i == item then
			receivedMap[i] = INVERTED_COLOR(stringified)
		else
			receivedMap[i] = stringified
		end
	end

	return "{" .. table.concat(receivedMap, ", ") .. "}"
end

local function printCloseTo(
	receivedDiff: number,
	expectedDiff: number,
	precision: number,
	isNot: boolean
): string
	local receivedDiffString = stringify(receivedDiff)
	local expectedDiffString

	if receivedDiffString:find("e") then
		receivedDiffString = receivedDiffString:gsub("%+0", "+")
		receivedDiffString = receivedDiffString:gsub("%-0", "-")

		-- the following two lines serve as a translation of expected.toExponential(0)
		expectedDiffString = Number.toExponential(expectedDiff, 0)
	else
		if 0 <= precision and precision < 20 then
			local stringFormat = "%." .. precision + 1 .. "f"
			expectedDiffString = string.format(stringFormat, expectedDiff)
		else
			expectedDiffString = stringify(expectedDiff)
		end
	end

	if isNot then
		return string.format(
			"Expected precision:  %s  %s\n" ..
    		"Expected difference: %s< %s\n" ..
    		"Received difference: %s  %s",
    		"      ", stringify(precision),
    		"never ", EXPECTED_COLOR(expectedDiffString),
    		"      ", RECEIVED_COLOR(receivedDiffString)
    	)
	else
		return string.format(
			"Expected precision:  %s  %s\n" ..
    		"Expected difference: %s< %s\n" ..
    		"Received difference: %s  %s",
			"", stringify(precision),
			"", EXPECTED_COLOR(expectedDiffString),
			"", RECEIVED_COLOR(receivedDiffString)
		)
	end
end

-- deviation: omitting the printConstructorName functions since they're useless for us
-- local function printExpectedConstructorName(
-- 	label: string,
-- 	expected-- : Function
-- ): string
-- 	return printConstructorName(label, expected, false, true) .. "\n"
-- end

-- local function printExpectedConstructorNameNot(
-- 	label: string,
-- 	expected--: Function
-- ): string
-- 	return printConstructorName(label, expected, true, true) .. "\n"
-- end

-- local function printReceivedConstructorName(
-- 	label: string,
-- 	received--: Function
-- ): string
-- 	return printConstructorName(label, received, false, false) .. "\n"
-- end

-- ROBLOX TODO: (ADO-1258) Add in more advanced cases for this function when
-- we can provide more detailed function name information
-- // Do not call function if received is equal to expected.
-- local function printReceivedConstructorNameNot(
-- 	label: string,
-- 	received,--: Function
-- 	expected--: Function
-- ): string
-- 	return printConstructorName(label, received, false, false) .. "\n"
-- end

-- ROBLOX TODO: (ADO-1258) Add in more advanced cases for this function when
-- we can provide more detailed function name information
-- function printConstructorName(
-- 	label: string,
-- 	constructor,--: Function
-- 	isNot: boolean,
-- 	isExpected: boolean
-- ): string
-- 	return string.format("%s name is an empty string", label)
-- end

return {
	printReceivedStringContainExpectedSubstring = printReceivedStringContainExpectedSubstring,
	printReceivedStringContainExpectedResult = printReceivedStringContainExpectedResult,
	printReceivedArrayContainExpectedItem = printReceivedArrayContainExpectedItem,
	printCloseTo = printCloseTo,
	-- deviation: omitting the printConstructorName functions since they're useless for us
	-- printExpectedConstructorName = printExpectedConstructorName,
	-- printExpectedConstructorNameNot = printExpectedConstructorNameNot,
	-- printReceivedConstructorName = printReceivedConstructorName,
	-- printReceivedConstructorNameNot = printReceivedConstructorNameNot,
	printExpectedConstructorName = function() error("printExpectedConstructorName omitted") end,
	printExpectedConstructorNameNot = function() error("printExpectedConstructorNameNot omitted") end,
	printReceivedConstructorName = function() error("printReceivedConstructorName omitted") end,
	printReceivedConstructorNameNot = function() error("printReceivedConstructorNameNot omitted") end,
}