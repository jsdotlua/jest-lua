-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/testPathPatternToRegExp.ts

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
local exports = {}

-- ROBLOX FIXME: local typesModule = require(Packages["@jest"].types)
local typesModule = {}
type Config = typesModule.Config -- Because we serialize/deserialize globalConfig when we spawn workers,
-- we can't pass regular expression. Using this shared function on both sides
-- will ensure that we produce consistent regexp for testPathPattern.
error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: ArrowFunctionExpression ]] --[[ (testPathPattern: Config.GlobalConfig['testPathPattern']): RegExp => new RegExp(testPathPattern, 'i') ]]
exports.default = error("not implemented")
return exports
]=]
return {}
