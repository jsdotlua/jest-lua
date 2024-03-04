-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/jest-runtime/src/__tests__/test_root/root.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jest = JestGlobals.jest

local exports = {}
-- ROBLOX deviation START: using ModuleScript instead of path
-- require("ExclusivelyManualMock")
-- require_("ManuallyMocked")
-- require_("ModuleWithSideEffects")
-- require_("ModuleWithState")
-- require_("RegularModule") -- We only care about the static analysis, not about the runtime.
-- local function lazyRequire()
-- 	require_("image!not_really_a_module")
-- 	require_("cat.png")
-- 	require_("dog.png")
-- end
-- exports.lazyRequire = lazyRequire
-- require("./ExclusivelyManualMock")
require("./ManuallyMocked")
-- require("./ModuleWithSideEffects")
-- require("./ModuleWithState")
require("./RegularModule")
-- ROBLOX deviation END

exports.jest = jest

return exports
