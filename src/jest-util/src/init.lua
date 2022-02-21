-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/index.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local exports = {}

exports.clearLine = require(script.clearLine).default
exports.createDirectory = require(script.createDirectory).default
local ErrorWithStackModule = require(script.ErrorWithStack)
exports.ErrorWithStack = ErrorWithStackModule.default
export type ErrorWithStack = ErrorWithStackModule.ErrorWithStack
exports.installCommonGlobals = require(script.installCommonGlobals).default
exports.interopRequireDefault = require(script.interopRequireDefault).default
exports.isInteractive = require(script.isInteractive).default
exports.isPromise = require(script.isPromise).default
exports.setGlobal = require(script.setGlobal).default
exports.deepCyclicCopy = require(script.deepCyclicCopy).default
-- ROBLOX deviation: not ported as it doesn't seems necessary in Lua
-- exports.convertDescriptorToString = require(script.convertDescriptorToString).default
exports.specialChars = require(script.specialChars)
-- ROBLOX deviation: not ported as it doesn't seems necessary in Lua
-- exports.replacePathSepForGlob = require(script.replacePathSepForGlob).default
-- ROBLOX deviation: not ported as it doesn't seems necessary in Lua
-- exports.testPathPatternToRegExp = require(script.testPathPatternToRegExp).default
exports.globsToMatcher = require(script.globsToMatcher).default
exports.preRunMessage = require(script.preRunMessage)
exports.pluralize = require(script.pluralize).default
exports.formatTime = require(script.formatTime).default
-- ROBLOX deviation: not ported as it doesn't seems necessary in Lua
-- exports.tryRealpath = require(script.tryRealpath).default
exports.requireOrImportModule = require(script.requireOrImportModule).default
return exports
