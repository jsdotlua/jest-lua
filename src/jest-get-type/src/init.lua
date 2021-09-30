-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/jest-get-type/src/index.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

local Packages = script.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local instanceof = LuauPolyfill.instanceof
local RegExp
local Set = LuauPolyfill.Set

local function getType(value: any): string
	-- deviation: code omitted because lua has no primitive undefined type
	-- lua makes no distinction between null and undefined so we just return nil
	if value == nil then
		return 'nil'
	end
	if typeof(value) == 'boolean' then
		return 'boolean'
	end
	if typeof(value) == 'function' then
		return 'function'
	end
	if typeof(value) == 'number' then
		return 'number'
	end
	if typeof(value) == 'string' then
		return 'string'
	end
	if typeof(value) == 'DateTime' then
		return 'DateTime'
	end
	if typeof(value) == 'userdata' and tostring(value):match("Symbol%(.*%)") then
		return 'symbol'
	end
	if typeof(value) == "table" then
		local ok, hasRegExpShape = pcall(function() return typeof(value.test) == "function" and typeof(value.exec) == "function" end)
		if ok and hasRegExpShape then
			RegExp = require(Packages.RegExp)

			if instanceof(value, RegExp) then
				return 'regexp'
			end
		end
	end
	if instanceof(value, Error) then
		return 'error'
	end
	if instanceof(value, Set) then
		return 'set'
	end
	-- deviation: lua makes no distinction between tables, arrays, and objects
	-- we always return table here and consumers are expected to perform the check
	if typeof(value) == 'table' then
		return 'table'
	end
	-- deviation: Roblox Instance type
	-- https://developer.roblox.com/en-us/api-reference/class/Instance
	if typeof(value) == 'Instance' then
		return 'Instance'
	end
	-- deviation: Roblox builtin data types
	-- (call typeof(value) for the name of the builtin datatype)
	-- https://developer.roblox.com/en-us/api-reference/data-types
	if type(value) ~= typeof(value) then
		return 'builtin'
	end
	-- deviation: added luau types for userdata and thread
	if type(value) == 'userdata' then
		return 'userdata'
	end
	if typeof(value) == 'thread' then
		return 'thread'
	end
	-- deviation: code omitted because lua has no primitive bigint type
	-- deviation: code omitted because lua has no built-in Map types
	-- deviation: code omitted because lua makes no distinction between tables, arrays, and objects

	-- deviation: include the type in the error message
	error(string.format('value of unknown type: %s (%s)', typeof(value), tostring(value)))
end

local function isPrimitive(value: any): boolean
	-- deviation: explicitly define objects and functions as non primitives
	return typeof(value) ~= 'table' and typeof(value) ~= 'function'
end

return {
	getType = getType,
	isPrimitive = isPrimitive,
}
