-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/interopRequireDefault.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent
local Packages = CurrentModule.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local exports = {}

-- copied from https://github.com/babel/babel/blob/56044c7851d583d498f919e9546caddf8f80a72f/packages/babel-helpers/src/helpers.js#L558-L562
-- eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
local function interopRequireDefault(obj: any): any
	return if Boolean.toJSBoolean(if Boolean.toJSBoolean(obj) then obj.__esModule else obj)
		then obj
		else { default = obj }
end
exports.default = interopRequireDefault
return exports
