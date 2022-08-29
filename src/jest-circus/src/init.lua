-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-circus/index.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]
local circusModule = require(script.circus)

local exports = circusModule

export type Event = circusModule.Event
export type State = circusModule.State

-- ROBLOX deviation: exporting runner alongside the main entry point
local runner = require(script.runner);
(exports :: any).runner = runner

return exports :: typeof(circusModule) & { runner: typeof(runner) }
