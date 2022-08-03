-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-config/src/__tests__/Defaults.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]

return function()
	local Packages = script.Parent.Parent.Parent
	local jestExpect = require(Packages.Dev.JestGlobals).expect

	local validatePattern = require(script.Parent.Parent.validatePattern).default

	describe("validate pattern function", function()
		it("without passed args returns true", function()
			local isValid = validatePattern()
			jestExpect(isValid).toBeTruthy()
		end)

		it("returns true for empty pattern", function()
			local isValid = validatePattern("")
			jestExpect(isValid).toBeTruthy()
		end)

		it("returns true for valid pattern", function()
			local isValid = validatePattern("abc+")
			jestExpect(isValid).toBeTruthy()
		end)

		it("returns false for invalid pattern", function()
			local isValid = validatePattern("\\")
			jestExpect(isValid).toBeFalsy()
		end)
	end)
end
