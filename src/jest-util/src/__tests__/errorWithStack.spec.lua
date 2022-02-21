-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/__tests__/errorWithStack.test.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent
	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Error = LuauPolyfill.Error
	local ErrorWithStack = require(CurrentModule.ErrorWithStack).default

	local jest = require(Packages.Dev.Jest)
	local jestExpect = require(Packages.Expect)

	describe("ErrorWithStack", function()
		local message = "💩 something went wrong"
		local function callsite() end
		it("calls Error.captureStackTrace with given callsite when capture exists", function()
			local originalCaptureStackTrace = Error["captureStackTrace"]
			local captureStackTraceSpy = jest.fn()
			Error["captureStackTrace"] = captureStackTraceSpy
			-- jest.spyOn(Error, "captureStackTrace")
			local actual = ErrorWithStack.new(message, callsite)
			jestExpect(actual).toBeInstanceOf(Error)
			jestExpect(actual.message).toBe(message)
			jestExpect(Error["captureStackTrace"]).toHaveBeenCalledWith(actual, callsite)

			Error["captureStackTrace"] = originalCaptureStackTrace
		end)
	end)
end
