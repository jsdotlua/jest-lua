-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-test-result/src/__tests__/formatTestResults.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local formatTestResults = require(CurrentModule.formatTestResults).default

local types = require(CurrentModule.types)
type AggregatedResult = types.AggregatedResult

describe("formatTestResults", function()
	local assertion = {
		fullName = "TestedModule#aMethod when some condition is met returns true",
		status = "passed",
		title = "returns true",
	}

	-- ROBLOX deviation START - casted to any, TS should fail here
	local results: AggregatedResult = {
		testResults = {
			{
				numFailingTests = 0,
				perfStats = { end_ = 2, runtime = 1, slow = false, start = 1 }, -- @ts-expect-error
				testResults = { assertion },
			},
		},
	} :: any
	-- ROBLOX deviation END

	it("includes test full name", function()
		local result = formatTestResults(results, nil, nil)
		jestExpect(result.testResults[1].assertionResults[1].fullName).toEqual(assertion.fullName)
	end)
end)

return {}
