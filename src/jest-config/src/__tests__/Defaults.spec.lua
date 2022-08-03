-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-config/src/__tests__/Defaults.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

return function()
	local Packages = script.Parent.Parent.Parent
	local jestExpect = require(Packages.Dev.JestGlobals).expect

	local defaults = require(script.Parent.Parent).defaults

	it("get configuration defaults", function()
		jestExpect(defaults).toBeDefined()
	end)
end
