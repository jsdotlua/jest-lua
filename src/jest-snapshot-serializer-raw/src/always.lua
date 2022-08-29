-- ROBLOX upstream: https://github.com/ikatyang/jest-snapshot-serializer-raw/blob/v1.2.0/src/always.ts
--[[
	MIT License

	Copyright (c) Ika <ikatyang@gmail.com> (https://github.com/ikatyang)
]]
local exports = {}

local function test(
	value: any
): boolean --[[ ROBLOX FIXME: change to TSTypePredicate equivalent if supported ]] --[[ value is string ]]
	return typeof(value) == "string"
end
exports.test = test

local function print(value: string): string
	return value
end
exports.print = print

return exports
