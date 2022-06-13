-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-reporters/src/__tests__/SummaryReporter.test.js
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
	local Array = LuauPolyfill.Array
	local Object = LuauPolyfill.Object
	local Set = LuauPolyfill.Set

	local jestExpect = require(Packages.Dev.JestGlobals).expect
	local Writeable = require(Packages.RobloxShared).Writeable

	local SummaryReporter

	local process = {
		env = {},
		stderr = Writeable.new(),
	}

	local env = Object.assign({}, process.env)
	local originalDateTime
	local write = process.stderr.write
	local globalConfig = { rootDir = "root", watch = false }
	local results = {}

	local function requireReporter()
		SummaryReporter = require(CurrentModule.SummaryReporter).default
	end

	beforeEach(function()
		process.env.npm_lifecycle_event = "test"
		process.env.npm_lifecycle_script = "jest"

		process.stderr = Writeable.new({
			write = function(result: string)
				table.insert(results, result .. "\n")
			end,
		})

		local utilsModule = require(CurrentModule.utils)
		local actual = getfenv(utilsModule.getSummary)
		originalDateTime = actual.DateTime
		actual.DateTime = {
			now = function()
				return ({
					UnixTimestampMillis = 10,
				} :: any) :: DateTime
			end,
		}
		setfenv(utilsModule.getSummary, actual)
	end)

	afterEach(function()
		results = {}
		process.env = env
		process.stderr.write = write
		local utilsModule = require(CurrentModule.utils)
		local actual = getfenv(utilsModule.getSummary)
		actual.DateTime = originalDateTime
		setfenv(utilsModule.getSummary, actual)
	end)

	it("snapshots needs update with npm test", function()
		local aggregatedResults = {
			numFailedTestSuites = 1,
			numFailedTests = 1,
			numPassedTestSuites = 0,
			numTotalTestSuites = 1,
			numTotalTests = 1,
			snapshot = { filesUnmatched = 1, total = 2, uncheckedKeysByFile = {}, unmatched = 2 },
			startTime = 0,
			testResults = {},
		}
		process.env.npm_config_user_agent = "npm"
		requireReporter()
		local testReporter = SummaryReporter.new(globalConfig, process)
		testReporter:onRunComplete(Set.new(), aggregatedResults)
		local result = Array.join(results, "")
		jestExpect(result).toMatchSnapshot()
	end)

	it("snapshots needs update with yarn test", function()
		local aggregatedResults = {
			numFailedTestSuites = 1,
			numFailedTests = 1,
			numPassedTestSuites = 0,
			numTotalTestSuites = 1,
			numTotalTests = 1,
			snapshot = {
				filesRemovedList = {},
				filesUnmatched = 1,
				total = 2,
				uncheckedKeysByFile = {},
				unmatched = 2,
			},
			startTime = 0,
			testResults = {},
		}
		process.env.npm_config_user_agent = "yarn"
		requireReporter()
		local testReporter = SummaryReporter.new(globalConfig, process)
		testReporter:onRunComplete(Set.new(), aggregatedResults)
		local result = Array.join(results, "")
		jestExpect(result).toMatchSnapshot()
	end)

	it("snapshots all have results (no update)", function()
		local aggregatedResults = {
			numFailedTestSuites = 1,
			numFailedTests = 1,
			numPassedTestSuites = 0,
			numTotalTestSuites = 1,
			numTotalTests = 1,
			snapshot = {
				added = 1,
				didUpdate = false,
				filesAdded = 1,
				filesRemoved = 1,
				filesRemovedList = {},
				filesUnmatched = 1,
				filesUpdated = 1,
				matched = 2,
				total = 2,
				unchecked = 1,
				uncheckedKeysByFile = {
					{ filePath = "path/to/suite_one", keys = { "unchecked snapshot 1" } },
				},
				unmatched = 1,
				updated = 1,
			},
			startTime = 0,
			testResults = {},
		}
		requireReporter()
		local testReporter = SummaryReporter.new(globalConfig, process)
		testReporter:onRunComplete(Set.new(), aggregatedResults)
		local result = Array.join(results, ""):gsub("\\", "/")
		jestExpect(result).toMatchSnapshot()
	end)

	it("snapshots all have results (after update)", function()
		local aggregatedResults = {
			numFailedTestSuites = 1,
			numFailedTests = 1,
			numPassedTestSuites = 0,
			numTotalTestSuites = 1,
			numTotalTests = 1,
			snapshot = {
				added = 1,
				didUpdate = true,
				filesAdded = 1,
				filesRemoved = 1,
				filesRemovedList = {},
				filesUnmatched = 1,
				filesUpdated = 1,
				matched = 2,
				total = 2,
				unchecked = 1,
				uncheckedKeysByFile = {
					{ filePath = "path/to/suite_one", keys = { "unchecked snapshot 1" } },
				},
				unmatched = 1,
				updated = 1,
			},
			startTime = 0,
			testResults = {},
		}
		requireReporter()
		local testReporter = SummaryReporter.new(globalConfig, process)
		testReporter:onRunComplete(Set.new(), aggregatedResults)
		local result = Array.join(results, ""):gsub("\\", "/")
		jestExpect(result).toMatchSnapshot()
	end)
end
