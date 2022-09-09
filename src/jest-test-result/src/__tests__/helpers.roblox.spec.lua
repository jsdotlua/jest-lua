--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]
-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local makeEmptyAggregatedTestResult = require(CurrentModule.helpers).makeEmptyAggregatedTestResult
local buildFailureTestResult = require(CurrentModule.helpers).buildFailureTestResult
local createEmptyTestResult = require(CurrentModule.helpers).createEmptyTestResult
local addResult = require(CurrentModule.helpers).addResult

describe("helpers", function()
	it("creates an empty AggregatedTestResult", function()
		local emptyAggregatedTestResult = {
			numFailedTestSuites = 0,
			numFailedTests = 0,
			numPassedTestSuites = 0,
			numPassedTests = 0,
			numPendingTestSuites = 0,
			numPendingTests = 0,
			numRuntimeErrorTestSuites = 0,
			numTodoTests = 0,
			numTotalTestSuites = 0,
			numTotalTests = 0,
			openHandles = {},
			snapshot = {
				added = 0,
				didUpdate = false,
				failure = false,
				filesAdded = 0,
				filesRemoved = 0,
				filesRemovedList = {},
				filesUnmatched = 0,
				filesUpdated = 0,
				matched = 0,
				total = 0,
				unchecked = 0,
				uncheckedKeysByFile = {},
				unmatched = 0,
				updated = 0,
			},
			startTime = 0,
			success = true,
			testResults = {},
			wasInterrupted = false,
		}
		local result = makeEmptyAggregatedTestResult()
		expect(result).toEqual(emptyAggregatedTestResult)
	end)

	it("creates a failure TestResult", function()
		local testError = {
			code = "testCode",
			message = "testMessage",
			stack = nil,
			type = "testType",
		}

		local failureTestResult = {
			console = nil,
			displayName = nil,
			failureMessage = nil,
			leaks = false,
			numFailingTests = 0,
			numPassingTests = 0,
			numPendingTests = 0,
			numTodoTests = 0,
			openHandles = {},
			perfStats = { ["end"] = 0, runtime = 0, slow = false, start = 0 },
			skipped = false,
			snapshot = {
				added = 0,
				fileDeleted = false,
				matched = 0,
				unchecked = 0,
				uncheckedKeys = {},
				unmatched = 0,
				updated = 0,
			},
			testExecError = testError,
			testFilePath = "testPath",
			testResults = {},
		}

		local result = buildFailureTestResult("testPath", testError)
		expect(result).toEqual(failureTestResult)
	end)

	it("creates an empty TestResult", function()
		local emptyTestResult = {
			leaks = false,
			numFailingTests = 0,
			numPassingTests = 0,
			numPendingTests = 0,
			numTodoTests = 0,
			openHandles = {},
			perfStats = { ["end"] = 0, runtime = 0, slow = false, start = 0 },
			skipped = false,
			snapshot = {
				added = 0,
				fileDeleted = false,
				matched = 0,
				unchecked = 0,
				uncheckedKeys = {},
				unmatched = 0,
				updated = 0,
			},
			testFilePath = "",
			testResults = {},
		}

		local result = createEmptyTestResult()
		expect(result).toEqual(emptyTestResult)
	end)

	it("adds a TestResult to an AggregatedResult", function()
		local test1 = createEmptyTestResult()
		test1.numPassingTests = 1

		local test2 = createEmptyTestResult()
		test2.numPassingTests = 1

		local aggregatedTestResult = makeEmptyAggregatedTestResult()

		addResult(aggregatedTestResult, test1)
		expect(aggregatedTestResult.numPassedTests).toEqual(1)

		addResult(aggregatedTestResult, test2)
		expect(aggregatedTestResult.numPassedTests).toEqual(2)
	end)
end)

return {}
