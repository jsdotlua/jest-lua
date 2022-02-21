-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/tryRealpath.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

--[[
	ROBLOX deviation: not ported as it doesn't seems necessary in Lua

local CurrentModule = script.Parent
local Packages = CurrentModule.Parent
local exports = {}

local realpathSync = require(Packages["graceful-fs"]).realpathSync
local typesModule = require(Packages.JestTypes)
type Config_Path = typesModule.Config_Path
local function tryRealpath(path: Config_Path): Config_Path
		local ok, result, hasReturned = pcall(function()
			path = realpathSync:native(path)
		end)
		if not ok then
			local error_ = result
			if error_.code ~= "ENOENT" then
				error(error_)
			end
		end
		if hasReturned then
			return result
		end
	return path
end
exports.default = tryRealpath
return exports
]]
return {}
