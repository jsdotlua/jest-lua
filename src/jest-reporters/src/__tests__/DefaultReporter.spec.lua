-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-reporters/src/__tests__/DefaultReporter.test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jest = JestGlobals.jest
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local ModuleMocker = require("@pkg/@jsdotlua/jest-mock").ModuleMocker
local moduleMocker = ModuleMocker.new()

local DefaultReporter = require("../DefaultReporter").default
local Writeable = require("@pkg/@jsdotlua/jest-roblox-shared").Writeable

local aggregatedResults = {}
local options = {}
local testCase = { context = { config = { rootDir = "/" } }, duration = 0, path = "/foo" }
local testResult = {
	snapshot = {
		added = 0,
		fileDeleted = true,
		matched = 1,
		unchecked = 0,
		unmatched = 0,
		updated = 0,
	},
	testFilePath = "/foo",
	testResults = {},
}

local stdoutWrite = moduleMocker:fn()
local stderrWrite = moduleMocker:fn()

local process = {
	env = {
		IS_INTERACTIVE = true,
	},
	stdout = Writeable.new({
		write = function(data)
			stdoutWrite(data)
		end,
	}),
	stderr = Writeable.new({
		write = function(data)
			stderrWrite(data)
		end,
	}),
}

beforeEach(function()
	jest.useFakeTimers()
	stdoutWrite:mockClear()
	stderrWrite:mockClear()
end)

-- ROBLOX deviation START: removed afterEach since we aren't overriding node globals

it("normal output, everything goes to stdout", function()
	local reporter = DefaultReporter.new({ rootDir = "", useStderr = false }, process)
	reporter:onRunStart(aggregatedResults, options)
	reporter:onTestStart(testCase)
	reporter:onTestResult(testCase, testResult, aggregatedResults)
	reporter:onRunComplete()
	jest.runAllTimers()
	expect(stdoutWrite).toHaveBeenCalled()
end)

it("when using stderr as output, no stdout call is made", function()
	local reporter = DefaultReporter.new({ rootDir = "", useStderr = true }, process)
	reporter:onRunStart(aggregatedResults, options)
	reporter:onTestStart(testCase)
	reporter:onTestResult(testCase, testResult, aggregatedResults)
	reporter:onRunComplete()
	jest.runAllTimers()
	expect(stdoutWrite).never.toHaveBeenCalled()
end)
