-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/pretty-format/src/collections.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

local CurrentModule = script.Parent

local Types = require(CurrentModule.Types)
type Config = Types.Config
type Refs = Types.Refs
type Printer = Types.Printer

-- ROBLOX deviation: deviates from upstream substantially since Lua only has tables
-- we only have two functions
-- `printTableEntries` for formatting key, value pairs and
-- `printListItems` for formatting arrays

-- ROBLOX deviation: printIteratorEntries is renamed to printTableEntries
-- /**
--  * Return entries (for example, of a map)
--  * with spacing, indentation, and comma
--  * without surrounding punctuation (for example, braces)
--  */
local function printTableEntries(
	t: any,
	config: Config,
	indentation: string,
	depth: number,
	refs: Refs,
	printer: Printer
): string
	local result = ""

	-- ROBLOX deviation: rewritten with a for ... pairs instead of an iterator
	local keys = {}
	for k, _ in pairs(t) do
		table.insert(keys, k)
	end

	local compareKeys = if typeof(config.compareKeys) == "function"
		then function(a, b)
			return config.compareKeys(a, b) < 0
		end
		else function(a, b)
			return type(a) .. tostring(a) < type(b) .. tostring(b)
		end

	table.sort(keys, compareKeys)

	if #keys > 0 then
		result = result .. config.spacingOuter

		local indentationNext = indentation .. config.indent

		for i = 1, #keys do
			local k = keys[i]
			local v = t[k]
			local name = printer(k, config, indentationNext, depth, refs)
			local value = printer(v, config, indentationNext, depth, refs)

			result = result .. indentationNext .. name .. ": " .. value

			if i < #keys then
				result = result .. "," .. config.spacingInner
			elseif not config.min then
				result = result .. ","
			end
		end

		result = result .. config.spacingOuter .. indentation
	end

	return result
end

-- /**
--  * Return items (for example, of an array)
--  * with spacing, indentation, and comma
--  * without surrounding punctuation (for example, brackets)
--  **/
local function printListItems(
	list: { [number]: any },
	config: Config,
	indentation: string,
	depth: number,
	refs: Refs,
	printer: Printer
): string
	local result = ""

	if #list > 0 then
		result = result .. config.spacingOuter

		local indentationNext = indentation .. config.indent

		for i = 1, #list do
			result ..= indentationNext

			if list[i] ~= nil then
				result ..= printer(list[i], config, indentationNext, depth, refs)
			end

			-- ROBLOX deviation: < #list instead of #list - 1 because of 1-indexing
			if i < #list then
				result = result .. "," .. config.spacingInner
			elseif not config.min then
				result = result .. ","
			end
		end

		result = result .. config.spacingOuter .. indentation
	end

	return result
end

return {
	printTableEntries = printTableEntries,
	printListItems = printListItems,
}
