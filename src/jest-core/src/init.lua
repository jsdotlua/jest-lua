-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-core/src/jest.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local exports = {}

exports.SearchSource = require("./SearchSource").default
exports.createTestScheduler = require("./TestScheduler").createTestScheduler
exports.TestWatcher = require("./TestWatcher").default
exports.runCLI = require("./cli").runCLI
-- ROBLOX deviation START: not needed
-- exports.getVersion = require("./version").default
-- ROBLOX deviation END
return exports
