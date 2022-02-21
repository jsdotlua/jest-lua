-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/convertDescriptorToString.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

--[=[
 	ROBLOX deviation: not ported as it doesn't seems necessary in Lua

local CurrentModule = script.Parent
local Packages = CurrentModule.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local String = LuauPolyfill.String
local exports = {}

--[[ eslint-disable local/ban-types-eventually ]]

-- See: https://github.com/facebook/jest/pull/5154
--[[
	ROBLOX FIXME: add extends if supported:
	original code:
	export default function convertDescriptorToString<
	  T extends number | string | Function | undefined,
	>
]]
local function convertDescriptorToString<T>(descriptor: T): T | string
	if typeof(descriptor) == "string" or typeof(descriptor) == "number" or descriptor == nil then
		return descriptor
	end

	if typeof(descriptor) ~= "function" then
		error(Error.new("describe expects a class, function, number, or string."))
	end

	if descriptor.name ~= nil then
		return descriptor.name
	end

	-- Fallback for old browsers, pardon Flow
	local stringified = tostring(descriptor)
	local typeDescriptorMatch = stringified:match(
		error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /class|function/ ]]
	)
	local indexOfNameSpace =
		-- @ts-expect-error: typeDescriptorMatch exists
		typeDescriptorMatch.index + #typeDescriptorMatch[1]
	local indexOfNameAfterSpace = stringified:search(
		error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /\(|\{/ ]]
	)
	local name = stringified:sub(indexOfNameSpace, indexOfNameAfterSpace + 1)
	return String.trim(name)
end
exports.default = convertDescriptorToString
return exports
]=]

return {}
