--!strict
-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/jest-get-type/src/index.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

local JestGetType = {}

function JestGetType.getType(value: any): string
	-- deviation: code omitted because lua has no primitive undefined type
	-- lua makes no distinction between null and undefined so we just return nil
	if value == nil then
		return 'nil'
	-- deviation: lua makes no distinction between tables, arrays, and objects
	-- we always return table here and consumers are expected to perform the check
	elseif type(value) == 'table' then
		return 'table'
	elseif type(value) == 'boolean' then
		return 'boolean'
	elseif type(value) == 'function' then
		return 'function'
	elseif type(value) == 'number' then
		return 'number'
	elseif type(value) == 'string' then
		return 'string'
	-- deviation: code omitted because lua has no primitive bigint type
	-- deviation: code omitted because lua has no built-in RegExp, Map, Set or Date types
	-- deviation: code omitted because lua makes no distinction between tables, arrays, and objects
	-- deviation: code omitted because lua has no primitive symbol type
	end

	error(string.format('value of unknown type: %s', tostring(value)))
end

function JestGetType.isPrimitive(value: any): boolean
	-- deviation: explicitly define objects and functions as non primitives
	return type(value) ~= 'table' and type(value) ~= 'function'
end

return JestGetType
