-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/clearLine.ts

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

-- ROBLOX FIXME START: added types and objects that do not exist in Luau
type NodeJS_WriteStream = any
-- ROBLOX FIXME END

local function clearLine(stream: NodeJS_WriteStream): ()
	if Boolean.toJSBoolean(stream.isTTY) then
		stream:write("\x1b[999D\x1b[K")
	end
end
exports.default = clearLine

return exports
