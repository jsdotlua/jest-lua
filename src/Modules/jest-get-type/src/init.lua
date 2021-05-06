-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/jest-get-type/src/index.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

local Packages = script.Parent.Parent.Parent

local Polyfill = require(Packages.LuauPolyfill)
local Error = Polyfill.Error
local instanceof = Polyfill.instanceof
local RegExp
local Set = Polyfill.Set

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
	if typeof(value) == "table" and typeof(value.test) == "function" and typeof(value.exec) == "function" then
		RegExp = require(Packages.LuauRegExp)

		if instanceof(value, RegExp) then
			return 'regexp'
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
	-- deviation: added luau types for userdata and thread
	if typeof(value) == 'userdata' then
		return 'userdata'
	end
	if typeof(value) == 'thread' then
		return 'thread'
	end
	-- deviation: code omitted because lua has no primitive bigint type
	-- deviation: code omitted because lua has no built-in Map types
	-- deviation: code omitted because lua makes no distinction between tables, arrays, and objects

	error(string.format('value of unknown type: %s', tostring(value)))
end

local function isPrimitive(value: any): boolean
	-- deviation: explicitly define objects and functions as non primitives
	return typeof(value) ~= 'table' and typeof(value) ~= 'function'
end

return {
	getType = getType,
	isPrimitive = isPrimitive,
}