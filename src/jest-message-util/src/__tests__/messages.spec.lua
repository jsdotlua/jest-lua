-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-message-util/src/__tests__/messages.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]

local Packages = script.Parent.Parent.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- ROBLOX deviation START: not used
-- local readFileSync = require(Packages["graceful-fs"]).readFileSync
-- local slash = require(Packages.slash)
-- local tempy = require(Packages.tempy)
-- ROBLOX deviation END

local CurentModule = require(script.Parent.Parent)
local formatExecError = CurentModule.formatExecError
-- ROBLOX deviation START: not used
-- local formatResultsErrors = CurentModule.formatResultsErrors
-- local formatStackTrace = CurentModule.formatStackTrace
-- ROBLOX deviation END

--[[
		ROBLOX deviation: skipped lines 14-80
		original code: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-message-util/src/__tests__/messages.test.ts#L14-L80
	]]

beforeEach(function()
	jest.clearAllMocks()
end)

--[[
		ROBLOX deviation: skipped lines 86-109
		original code: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-message-util/src/__tests__/messages.test.ts#L86-L109
	]]

it(".formatExecError()", function()
	local message = formatExecError(
		{ message = "Whoops!", stack = "" },
		{ rootDir = "" :: any, testMatch = {} },
		{ noStackTrace = false },
		"path_test"
	)
	expect(message).toMatchSnapshot()
end)

--[[
		ROBLOX deviation: skipped lines 130-366
		original code: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-message-util/src/__tests__/messages.test.ts#L130-L366
	]]
