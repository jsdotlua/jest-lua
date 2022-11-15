-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-core/src/__tests__/TestScheduler.test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]
local Packages = script.Parent.Parent.Parent
local Promise = require(Packages.Promise)
local JestGlobals = require(Packages.Dev.JestGlobals)
-- ROBLOX deviation START: not used
-- local beforeEach = JestGlobals.beforeEach
-- ROBLOX deviation END
local expect = JestGlobals.expect
-- ROBLOX deviation START: not used
-- local jest = JestGlobals.jest
-- ROBLOX deviation END
local test = JestGlobals.test
local SummaryReporter = require(Packages.JestReporters).SummaryReporter
-- ROBLOX deviation START: not used
-- local makeProjectConfig = require(Packages["@jest"]["test-utils"]).makeProjectConfig
-- ROBLOX deviation END
local createTestScheduler = require(script.Parent.Parent.TestScheduler).createTestScheduler
-- ROBLOX deviation START: not used
-- local testSchedulerHelper = require(script.Parent.Parent.testSchedulerHelper)
-- jest.mock("@jest/reporters")
-- local mockSerialRunner = { isSerial = true, runTests = jest.fn() }
-- jest.mock("jest-runner-serial", function()
-- 	return jest.fn(function()
-- 		return mockSerialRunner
-- 	end)
-- end, { virtual = true })
-- local mockParallelRunner = { runTests = jest.fn() }
-- jest.mock("jest-runner-parallel", function()
-- 	return jest.fn(function()
-- 		return mockParallelRunner
-- 	end)
-- end, { virtual = true })
-- local spyShouldRunInBand = jest.spyOn(testSchedulerHelper, "shouldRunInBand")
-- beforeEach(function()
-- 	mockSerialRunner.runTests:mockClear()
-- 	mockParallelRunner.runTests:mockClear()
-- 	spyShouldRunInBand:mockClear()
-- end)
-- ROBLOX deviation END
test("config for reporters supports `default`", function()
	return Promise.resolve():andThen(function()
		-- ROBLOX deviation START: upstream test file is JS so it doesn't check for types
		-- local undefinedReportersScheduler = createTestScheduler({ reporters = nil }, {}):expect()
		-- local numberOfReporters = undefinedReportersScheduler._dispatcher._reporters.length
		-- local stringDefaultReportersScheduler = createTestScheduler({ reporters = { "default" } }, {}):expect()
		-- expect(stringDefaultReportersScheduler._dispatcher._reporters.length).toBe(numberOfReporters)
		-- local defaultReportersScheduler = createTestScheduler({ reporters = { { "default", {} } } }, {}):expect()
		-- expect(defaultReportersScheduler._dispatcher._reporters.length).toBe(numberOfReporters)
		-- local emptyReportersScheduler = createTestScheduler({ reporters = {} }, {}):expect()
		-- expect(emptyReportersScheduler._dispatcher._reporters.length).toBe(0)
		local undefinedReportersScheduler = createTestScheduler({ reporters = nil } :: any, {} :: any, nil :: any):expect()
		local numberOfReporters = #(undefinedReportersScheduler :: any)._dispatcher._reporters
		local stringDefaultReportersScheduler = createTestScheduler(
			{ reporters = { "default" } } :: any,
			{} :: any,
			nil :: any
		):expect()
		expect(#(stringDefaultReportersScheduler :: any)._dispatcher._reporters).toBe(numberOfReporters)
		local defaultReportersScheduler = createTestScheduler(
			{ reporters = { { "default" :: any, {} } } } :: any,
			{} :: any,
			nil :: any
		):expect()
		expect(#(defaultReportersScheduler :: any)._dispatcher._reporters).toBe(numberOfReporters)
		-- ROBLOX deviation END
	end)
end)
test(".addReporter() .removeReporter()", function()
	return Promise.resolve():andThen(function()
		-- ROBLOX deviation START: upstream test file is JS so it doesn't check for types
		-- local scheduler = createTestScheduler({}, {}):expect()
		local scheduler = createTestScheduler({} :: any, {} :: any, nil :: any):expect()
		-- ROBLOX deviation END
		local reporter = SummaryReporter.new()
		scheduler:addReporter(reporter)
		-- ROBLOX deviation START: upstream test file is JS so it doesn't check for types
		-- expect(scheduler._dispatcher._reporters).toContain(reporter)
		expect((scheduler :: any)._dispatcher._reporters).toContain(reporter)
		-- ROBLOX deviation END
		scheduler:removeReporter(SummaryReporter)
		-- ROBLOX deviation START: upstream test file is JS so it doesn't check for types. Also using never instead of not
		-- expect(scheduler._dispatcher._reporters)["not"].toContain(reporter)
		expect((scheduler :: any)._dispatcher._reporters).never.toContain(reporter)
		-- ROBLOX deviation END
	end)
end)
-- ROBLOX deviation START: skipped as passing custom runner is not supported yet
-- test("schedule tests run in parallel per default", function()
-- 	return Promise.resolve():andThen(function()
-- 		local scheduler = createTestScheduler({}, {}):expect()
-- 		local test = {
-- 			context = {
-- 				config = makeProjectConfig({
-- 					moduleFileExtensions = { ".js" },
-- 					runner = "jest-runner-parallel",
-- 					transform = {},
-- 				}),
-- 				hasteFS = {
-- 					matchFiles = jest.fn(function()
-- 						return {}
-- 					end),
-- 				},
-- 			},
-- 			path = "./test/path.js",
-- 		}
-- 		local tests = { test, test }
-- 		scheduler:scheduleTests(tests, { isInterrupted = jest.fn() }):expect()
-- 		expect(mockParallelRunner.runTests).toHaveBeenCalled()
-- 		expect(mockParallelRunner.runTests.mock.calls[
-- 			1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		][
-- 			6 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		].serial).toBeFalsy()
-- 	end)
-- end)
test.skip("schedule tests run in parallel per default", function() end)
-- ROBLOX deviation END
-- ROBLOX deviation START: skipped as passing custom runner is not supported yet
-- test("schedule tests run in serial if the runner flags them", function()
-- 	return Promise.resolve():andThen(function()
-- 		local scheduler = createTestScheduler({}, {}):expect()
-- 		local test = {
-- 			context = {
-- 				config = makeProjectConfig({
-- 					moduleFileExtensions = { ".js" },
-- 					runner = "jest-runner-serial",
-- 					transform = {},
-- 				}),
-- 				hasteFS = {
-- 					matchFiles = jest.fn(function()
-- 						return {}
-- 					end),
-- 				},
-- 			},
-- 			path = "./test/path.js",
-- 		}
-- 		local tests = { test, test }
-- 		scheduler:scheduleTests(tests, { isInterrupted = jest.fn() }):expect()
-- 		expect(mockSerialRunner.runTests).toHaveBeenCalled()
-- 		expect(mockSerialRunner.runTests.mock.calls[
-- 			1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		][
-- 			6 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		].serial).toBeTruthy()
-- 	end)
-- end)
test.skip("schedule tests run in serial if the runner flags them", function() end)
-- ROBLOX deviation END
-- ROBLOX deviation START: skipped as passing custom runner is not supported yet
-- test("should bail after `n` failures", function()
-- 	return Promise.resolve():andThen(function()
-- 		local scheduler = createTestScheduler({ bail = 2 }, {}):expect()
-- 		local test = {
-- 			context = {
-- 				config = makeProjectConfig({
-- 					moduleFileExtensions = { ".js" },
-- 					rootDir = "./",
-- 					runner = "jest-runner-serial",
-- 					transform = {},
-- 				}),
-- 				hasteFS = {
-- 					matchFiles = jest.fn(function()
-- 						return {}
-- 					end),
-- 				},
-- 			},
-- 			path = "./test/path.js",
-- 		}
-- 		local tests = { test }
-- 		local setState = jest.fn()
-- 		scheduler
-- 			:scheduleTests(tests, {
-- 				isInterrupted = jest.fn(),
-- 				isWatchMode = function()
-- 					return true
-- 				end,
-- 				setState = setState,
-- 			})
-- 			:expect()
-- 		mockSerialRunner.runTests.mock.calls[
-- 			1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		]
-- 			[
-- 				4 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			](
-- 				mockSerialRunner.runTests.mock.calls[
-- 					1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 				],
-- 				test,
-- 				{ numFailingTests = 2, snapshot = {}, testResults = { {} } }
-- 			)
-- 			:expect()
-- 		expect(setState).toBeCalledWith({ interrupted = true })
-- 	end)
-- end)
test.skip("should bail after `n` failures", function() end)
-- ROBLOX deviation END
-- ROBLOX deviation START: skipped as passing custom runner is not supported yet
-- test("should not bail if less than `n` failures", function()
-- 	return Promise.resolve():andThen(function()
-- 		local scheduler = createTestScheduler({ bail = 2 }, {}):expect()
-- 		local test = {
-- 			context = {
-- 				config = makeProjectConfig({
-- 					moduleFileExtensions = { ".js" },
-- 					rootDir = "./",
-- 					runner = "jest-runner-serial",
-- 					transform = {},
-- 				}),
-- 				hasteFS = {
-- 					matchFiles = jest.fn(function()
-- 						return {}
-- 					end),
-- 				},
-- 			},
-- 			path = "./test/path.js",
-- 		}
-- 		local tests = { test }
-- 		local setState = jest.fn()
-- 		scheduler
-- 			:scheduleTests(tests, {
-- 				isInterrupted = jest.fn(),
-- 				isWatchMode = function()
-- 					return true
-- 				end,
-- 				setState = setState,
-- 			})
-- 			:expect()
-- 		mockSerialRunner.runTests.mock.calls[
-- 			1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		]
-- 			[
-- 				4 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			](
-- 				mockSerialRunner.runTests.mock.calls[
-- 					1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 				],
-- 				test,
-- 				{ numFailingTests = 1, snapshot = {}, testResults = { {} } }
-- 			)
-- 			:expect()
-- 		expect(setState)["not"].toBeCalled()
-- 	end)
-- end)
test.skip("should not bail if less than `n` failures", function() end)
-- ROBLOX deviation END
-- ROBLOX deviation START: skipped as passing custom runner is not supported yet
-- test("should set runInBand to run in serial", function()
-- 	return Promise.resolve():andThen(function()
-- 		local scheduler = createTestScheduler({}, {}):expect()
-- 		local test = {
-- 			context = {
-- 				config = makeProjectConfig({
-- 					moduleFileExtensions = { ".js" },
-- 					runner = "jest-runner-parallel",
-- 					transform = {},
-- 				}),
-- 				hasteFS = {
-- 					matchFiles = jest.fn(function()
-- 						return {}
-- 					end),
-- 				},
-- 			},
-- 			path = "./test/path.js",
-- 		}
-- 		local tests = { test, test }
-- 		spyShouldRunInBand:mockReturnValue(true)
-- 		scheduler:scheduleTests(tests, { isInterrupted = jest.fn() }):expect()
-- 		expect(spyShouldRunInBand).toHaveBeenCalled()
-- 		expect(mockParallelRunner.runTests).toHaveBeenCalled()
-- 		expect(mockParallelRunner.runTests.mock.calls[
-- 			1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		][
-- 			6 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		].serial).toBeTruthy()
-- 	end)
-- end)
test.skip("should set runInBand to run in serial", function() end)
-- ROBLOX deviation END
-- ROBLOX deviation START: skipped as passing custom runner is not supported yet
-- test("should set runInBand to not run in serial", function()
-- 	return Promise.resolve():andThen(function()
-- 		local scheduler = createTestScheduler({}, {}):expect()
-- 		local test = {
-- 			context = {
-- 				config = makeProjectConfig({
-- 					moduleFileExtensions = { ".js" },
-- 					runner = "jest-runner-parallel",
-- 					transform = {},
-- 				}),
-- 				hasteFS = {
-- 					matchFiles = jest.fn(function()
-- 						return {}
-- 					end),
-- 				},
-- 			},
-- 			path = "./test/path.js",
-- 		}
-- 		local tests = { test, test }
-- 		spyShouldRunInBand:mockReturnValue(false)
-- 		scheduler:scheduleTests(tests, { isInterrupted = jest.fn() }):expect()
-- 		expect(spyShouldRunInBand).toHaveBeenCalled()
-- 		expect(mockParallelRunner.runTests).toHaveBeenCalled()
-- 		expect(mockParallelRunner.runTests.mock.calls[
-- 			1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		][
-- 			6 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 		].serial).toBeFalsy()
-- 	end)
-- end)
test.skip("should set runInBand to not run in serial", function() end)
-- ROBLOX deviation END
