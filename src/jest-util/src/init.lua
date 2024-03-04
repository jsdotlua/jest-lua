-- ROBLOX upstream: https://github.com/facebook/jest/tree/v28.0.0/packages/jest-util/src/index.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local Object = LuauPolyfill.Object

local exports = {}

exports.clearLine = require("./clearLine").default
exports.createDirectory = require("./createDirectory").default
local ErrorWithStackModule = require("./ErrorWithStack")
exports.ErrorWithStack = ErrorWithStackModule.default
export type ErrorWithStack = ErrorWithStackModule.ErrorWithStack
-- ROBLOX deviation: need to execute the module explicitly
exports.installCommonGlobals = require("./installCommonGlobals")().default
-- ROBLOX deviation not ported as it doesn't seem necessary in Lua
-- exports.interopRequireDefault = require("./interopRequireDefault").default
exports.isInteractive = require("./isInteractive").default
exports.isPromise = require("./isPromise").default
exports.setGlobal = require("./setGlobal").default
exports.deepCyclicCopy = require("./deepCyclicCopy").default
exports.convertDescriptorToString = require("./convertDescriptorToString").default
local specialCharsModule = require("./specialChars")
Object.assign(exports, specialCharsModule)
exports.specialChars = specialCharsModule
-- ROBLOX deviation START: additional assignments for Lua type inferrence to work
exports.ARROW = specialCharsModule.ARROW
exports.ICONS = specialCharsModule.ICONS
exports.CLEAR = specialCharsModule.CLEAR
-- ROBLOX deviation END
-- ROBLOX deviation: not ported as it doesn't seem necessary in Lua
-- exports.replacePathSepForGlob = require("./replacePathSepForGlob").default
exports.testPathPatternToRegExp = require("./testPathPatternToRegExp").default
exports.globsToMatcher = require("./globsToMatcher").default
local preRunMessageModule = require("./preRunMessage")
exports.preRunMessage = preRunMessageModule
-- ROBLOX deviation START: additional assignments for Lua type inferrence to work
exports.print = preRunMessageModule.print
exports.remove = preRunMessageModule.remove
-- ROBLOX deviation END
exports.pluralize = require("./pluralize").default
exports.formatTime = require("./formatTime").default
-- ROBLOX deviation START: not ported as it doesn't seem necessary in Lua
-- exports.tryRealpath = require("./tryRealpath").default
-- exports.requireOrImportModule = require("./requireOrImportModule").default
-- ROBLOX deviation END
return exports
