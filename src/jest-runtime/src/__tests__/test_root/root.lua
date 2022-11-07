-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/jest-runtime/src/__tests__/test_root/root.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]
local Packages = script.Parent.Parent.Parent.Parent
local JestGlobals = require(Packages.Dev.JestGlobals)
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
-- require(script.Parent.ExclusivelyManualMock)
require(script.Parent.ManuallyMocked)
-- require(script.Parent.ModuleWithSideEffects)
-- require(script.Parent.ModuleWithState)
require(script.Parent.RegularModule)
-- ROBLOX deviation END

exports.jest = jest

return exports
