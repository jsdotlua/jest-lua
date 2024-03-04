-- ROBLOX upstream: https://github.com/ikatyang/jest-snapshot-serializer-raw/blob/v1.2.0/src/index.ts
--[[
	MIT License

	Copyright (c) Ika <ikatyang@gmail.com> (https://github.com/ikatyang)
]]

local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local Symbol = LuauPolyfill.Symbol

local always = require("./always")

local exports = {}

local RAW = Symbol.for_("jest-snapshot-serializer-raw")

export type Wrapper = { [any]: string }
local function wrap(value: string): Wrapper
	return { [RAW] = value }
end
exports.wrap = wrap

local function test(
	value: any
): boolean --[[ ROBLOX FIXME: change to TSTypePredicate equivalent if supported ]] --[[ value is Wrapper ]]
	return typeof(value) == "table" and always.test(value[RAW])
end
exports.test = test

local function print(value: Wrapper): string
	return always.print(value[RAW])
end
exports.print = print

exports.default = wrap

return exports
