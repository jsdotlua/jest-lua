-- ROBLOX upstream: https://github.com/facebook/jest/tree/v28.0.0/packages/jest-util/src/__tests__/errorWithStack.test.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local ErrorWithStack = require(CurrentModule.ErrorWithStack).default

local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

describe("ErrorWithStack", function()
	local message = "💩 something went wrong"
	local function callsite() end
	it("calls Error.captureStackTrace with given callsite when capture exists", function()
		local originalCaptureStackTrace = Error["captureStackTrace"]
		local captureStackTraceSpy = jest.fn()
		Error["captureStackTrace"] = captureStackTraceSpy
		-- jest.spyOn(Error, "captureStackTrace")
		local actual = ErrorWithStack.new(message, callsite)
		expect(actual).toBeInstanceOf(Error)
		expect(actual.message).toBe(message)
		expect(Error["captureStackTrace"]).toHaveBeenCalledWith(actual, callsite)

		Error["captureStackTrace"] = originalCaptureStackTrace
	end)
end)
