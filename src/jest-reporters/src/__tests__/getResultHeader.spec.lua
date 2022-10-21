-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-reporters/src/__tests__/getResultHeader.test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local it = JestGlobals.it

local makeGlobalConfig = require(Packages.TestUtils).makeGlobalConfig
local testResultModule = require(Packages.JestTestResult)
type TestResult = testResultModule.TestResult

local getResultHeader = require(CurrentModule.getResultHeader).default

local endTime = 1577717671160
local testTime = 5500

-- ROBLOX deviation: variable used only in non-ported tests
-- local testResult = { testFilePath = "/foo" }

local testResultSlow = {
	-- ROBLOX deviation: numFailingTests should not be nil
	numFailingTests = 0,
	perfStats = { ["end"] = endTime, runtime = testTime, slow = true, start = endTime - testTime },
	testFilePath = "/foo",
}

local testResultFast = {
	-- ROBLOX deviation: numFailingTests should not be nil
	numFailingTests = 0,
	perfStats = { ["end"] = endTime, runtime = testTime, slow = false, start = endTime - testTime },
	testFilePath = "/foo",
}

local globalConfig = makeGlobalConfig()

-- ROBLOX deviation START: terminal-link not ported
-- it("should call `terminal-link` correctly", function()
-- 	getResultHeader(testResult, globalConfig)
-- 	expect(terminalLink).toBeCalledWith(
-- 		expect:stringContaining("foo"),
-- 		"file:///foo",
-- 		expect:objectContaining({ fallback = expect:any(Function) })
-- 	)
-- end)

-- itFOCUS("should render the terminal link", function()
-- 	local result = getResultHeader(testResult, globalConfig)
-- 	expect(result).toContain("wannabehyperlink")
-- end)
-- ROBLOX deviation END

it("should display test time for slow test", function()
	local result = getResultHeader((testResultSlow :: any) :: TestResult, globalConfig)
	expect(result).toContain(("%s s"):format(tostring(testTime / 1000)))
end)

it("should not display test time for fast test ", function()
	local result = getResultHeader((testResultFast :: any) :: TestResult, globalConfig)
	expect(result).never.toContain(("%s s"):format(tostring(testTime / 1000)))
end)
