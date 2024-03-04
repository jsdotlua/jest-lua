-- ROBLOX upstream: https://github.com/facebook/jest/tree/v28.0.0/packages/jest-util/src/preRunMessage.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local exports = {}

local chalk = require("@pkg/@jsdotlua/chalk")
local clearLine = require("./clearLine").default
local isInteractive = require("./isInteractive").default

local RobloxShared = require("@pkg/@jsdotlua/jest-roblox-shared")
type Writeable = RobloxShared.Writeable

local function print(stream: Writeable): ()
	if isInteractive then
		stream:write(chalk.bold.dim("Determining test suites to run..."))
	end
end
exports.print = print

local function remove(stream: Writeable): ()
	if isInteractive then
		clearLine(stream)
	end
end
exports.remove = remove

return exports
