-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/requireOrImportModule.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent
local Packages = CurrentModule.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local _Boolean = LuauPolyfill.Boolean
local _Error = LuauPolyfill.Error
type Promise<T> = LuauPolyfill.Promise<T>

local Promise = require(Packages.Promise)

local exports = {}

-- local isAbsolute = require(Packages.path).isAbsolute
-- local pathToFileURL = require(Packages.url).pathToFileURL
local typesModule = require(Packages.JestTypes)
type Config_Path = typesModule.Config_Path
local _interopRequireDefault = require(script.Parent.interopRequireDefault).default
local function requireOrImportModule<T>(_filePath: Config_Path, _applyInteropRequireDefault: boolean?): Promise<T>
	warn("requireOrImportModule is not implemented yet")
	return Promise.resolve(nil)
	-- if applyInteropRequireDefault == nil then
	-- 	applyInteropRequireDefault = true
	-- end
	-- return Promise.resolve():andThen(function()
	-- 	if not isAbsolute(filePath) and filePath[1] == "." then
	-- 		error(Error.new(('Jest: requireOrImportModule path must be absolute, was "%s"'):format(filePath)))
	-- 	end

	-- 	local ok, result, hasReturned = xpcall(function()
	-- 		local requiredModule = require(filePath)
	-- 		if not Boolean.toJSBoolean(applyInteropRequireDefault) then
	-- 			return requiredModule
	-- 		end
	-- 		return interopRequireDefault(requiredModule).default, true
	-- 	end, function(error_)
	-- 		if error_.code == "ERR_REQUIRE_ESM" then
	-- 			local ok, result, hasReturned = xpcall(function()
	-- 				local moduleUrl = pathToFileURL(filePath) -- node `import()` supports URL, but TypeScript doesn't know that
	-- 				local importedModule = (
	-- 					error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: Import ]] --[[ import ]]
	-- 				)(moduleUrl.href):expect()
	-- 				if not Boolean.toJSBoolean(applyInteropRequireDefault) then
	-- 					return importedModule
	-- 				end
	-- 				if not Boolean.toJSBoolean(importedModule.default) then
	-- 					error(
	-- 						Error.new(
	-- 							("Jest: Failed to load ESM at %s - did you use a default export?"):format(filePath)
	-- 						)
	-- 					)
	-- 				end
	-- 				return importedModule.default, true
	-- 			end, function(innerError: any)
	-- 				if innerError.message == "Not supported" then
	-- 					error(
	-- 						Error.new(
	-- 							(
	-- 								"Jest: Your version of Node does not support dynamic import - please enable it or use a .cjs file extension for file %s"
	-- 							):format(filePath)
	-- 						)
	-- 					)
	-- 				end
	-- 				error(innerError)
	-- 			end)
	-- 			if hasReturned then
	-- 				return result
	-- 			end
	-- 		else
	-- 			error(error_)
	-- 		end
	-- 	end)
	-- 	if hasReturned then
	-- 		return result
	-- 	end
	-- end)
end
exports.default = requireOrImportModule
return exports
