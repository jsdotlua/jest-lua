-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/createDirectory.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent
local Packages = CurrentModule.Parent
local exports = {}

-- ROBLOX deviation: using FileSystemService instead of fs
local getFileSystemService = require(CurrentModule.getFileSystemService)
local typesModule = require(Packages.JestTypes)
type Config_Path = typesModule.Config_Path

local function createDirectory(path: Config_Path): ()
	local _FileSystemService = getFileSystemService()

	local ok, result, hasReturned = pcall(function()
		-- fs:mkdirSync(path, { recursive = true })
	end)
	if not ok then
		local e = result
		if e.code ~= "EEXIST" then
			error(e)
		end
	end
	if hasReturned then
		return result
	end
end
exports.default = createDirectory
return exports
