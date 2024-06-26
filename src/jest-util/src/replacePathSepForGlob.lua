-- ROBLOX upstream: https://github.com/facebook/jest/tree/v28.0.0/packages/jest-util/src/replacePathSepForGlob.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

--[=[
	ROBLOX deviation: not ported as it doesn't seem necessary in Lua

local exports = {}

local typesModule = require("@pkg/@jsdotlua/jest-types")
type Config_Glob = typesModule.Config_Glob
type Config_Path = typesModule.Config_Path

local function replacePathSepForGlob(path: Config_Path): Config_Glob
	return path:replace(
		error("not implemented"), --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /\\(?![{}()+?.^$])/g ]]
		"/"
	)
end
exports.default = replacePathSepForGlob
return exports
]=]

return {}
