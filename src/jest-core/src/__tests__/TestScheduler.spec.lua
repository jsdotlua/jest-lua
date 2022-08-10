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

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local it = (JestGlobals.it :: any) :: Function
local itSKIP = JestGlobals.it.skip
local jestExpect = JestGlobals.expect

local SummaryReporter = require(Packages.JestReporters).SummaryReporter
-- ROBLOX deviation START: not used
-- local makeProjectConfig = require(Packages.Dev.TestUtils).makeProjectConfig
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
-- local originalShouldRunInBand = testSchedulerHelper.shouldRunInBand
-- local spyShouldRunInBand = jest.fn(originalShouldRunInBand)
-- testSchedulerHelper.shouldRunInBand = spyShouldRunInBand
-- local spyShouldRunInBand = jest.spyOn(testSchedulerHelper, "shouldRunInBand")
-- beforeEach(function()
-- 	mockSerialRunner.runTests:mockClear()
-- 	mockParallelRunner.runTests:mockClear()
-- 	spyShouldRunInBand:mockClear()
-- end)
-- ROBLOX deviation END

it("config for reporters supports `default`", function()
	return Promise.resolve()
		:andThen(function()
			-- ROBLOX deviation START: upstream test file is JS so it doesn't check for types
			local undefinedReportersScheduler =
				createTestScheduler(
					{ reporters = nil } :: any,
					{} :: any,
					nil :: any
				):expect()
			local numberOfReporters = #(undefinedReportersScheduler :: any)._dispatcher._reporters
			local stringDefaultReportersScheduler = createTestScheduler(
				{ reporters = { "default" } } :: any,
				{} :: any,
				nil :: any
			):expect()
			jestExpect(#(stringDefaultReportersScheduler :: any)._dispatcher._reporters).toBe(numberOfReporters)
			local defaultReportersScheduler = createTestScheduler(
				{ reporters = { { "default" :: any, {} } } } :: any,
				{} :: any,
				nil :: any
			):expect()
			jestExpect(#(defaultReportersScheduler :: any)._dispatcher._reporters).toBe(numberOfReporters)
			-- ROBLOX deviation END
			-- ROBLOX deviation START: not supported
			-- local emptyReportersScheduler =
			-- 	createTestScheduler(
			-- 		{ reporters = {} } :: any,
			-- 		{} :: any,
			-- 		nil :: any
			-- 	):expect()
			-- jestExpect(#(emptyReportersScheduler :: any)._dispatcher._reporters).toBe(0)
			-- ROBLOX deviation END
		end)
		:expect()
end)

it(".addReporter() .removeReporter()", function()
	return Promise.resolve()
		:andThen(function()
			-- ROBLOX deviation START: upstream test file is JS so it doesn't check for types
			local scheduler = createTestScheduler({} :: any, {} :: any, nil :: any):expect()
			local reporter = SummaryReporter.new()
			scheduler:addReporter(reporter)
			jestExpect((scheduler :: any)._dispatcher._reporters).toContain(reporter)
			scheduler:removeReporter(SummaryReporter)
			jestExpect((scheduler :: any)._dispatcher._reporters).never.toContain(reporter)
			-- ROBLOX deviation END
		end)
		:expect()
end)

-- ROBLOX deviation START: skipped as passing custom runner is not supported yet
itSKIP("schedule tests run in parallel per default", function()
	-- return Promise.resolve()
	-- 	:andThen(function()
	-- 		local scheduler = createTestScheduler({}, {}):expect()
	-- 		local test = {
	-- 			context = {
	-- 				config = makeProjectConfig({
	-- 					moduleFileExtensions = { ".js" },
	-- 					runner = "jest-runner-parallel",
	-- 					transform = {},
	-- 				}),
	-- 				hasteFS = { matchFiles = jest.fn(function()
	-- 					return {}
	-- 				end) },
	-- 			},
	-- 			path = "./test/path.js",
	-- 		}
	-- 		local tests = { test, test }
	-- 		scheduler:scheduleTests(tests, { isInterrupted = jest.fn() }):expect()
	-- 		jestExpect(mockParallelRunner.runTests).toHaveBeenCalled()
	-- 		jestExpect(mockParallelRunner.runTests.mock.calls[1][6].serial).toBeFalsy()
	-- 	end)
	-- 	:expect()
end)

itSKIP("schedule tests run in serial if the runner flags them", function()
	-- return Promise.resolve()
	-- 	:andThen(function()
	-- 		local scheduler = createTestScheduler({}, {}):expect()
	-- 		local test = {
	-- 			context = {
	-- 				config = makeProjectConfig({
	-- 					moduleFileExtensions = { ".js" },
	-- 					runner = "jest-runner-serial",
	-- 					transform = {},
	-- 				}),
	-- 				-- hasteFS = { matchFiles = jest.fn(function()
	-- 				-- 	return {}
	-- 				-- end) },
	-- 			},
	-- 			path = "./test/path.js",
	-- 		}
	-- 		local tests = { test, test }
	-- 		scheduler:scheduleTests(tests, { isInterrupted = jest.fn() }):expect()
	-- 		jestExpect(mockSerialRunner.runTests).toHaveBeenCalled()
	-- 		jestExpect(mockSerialRunner.runTests.mock.calls[1][6].serial).toBeTruthy()
	-- 	end)
	-- 	:expect()
end)

itSKIP("should bail after `n` failures", function()
	-- return Promise.resolve()
	-- 	:andThen(function()
	-- 		local scheduler = createTestScheduler({ bail = 2 }, {}):expect()
	-- 		local test = {
	-- 			context = {
	-- 				config = makeProjectConfig({
	-- 					moduleFileExtensions = { ".js" },
	-- 					rootDir = "./",
	-- 					runner = "jest-runner-serial",
	-- 					transform = {},
	-- 				}),
	-- 				hasteFS = { matchFiles = jest.fn(function()
	-- 					return {}
	-- 				end) },
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
	-- 		mockSerialRunner.runTests.mock.calls[1]
	-- 			[4](
	-- 				mockSerialRunner.runTests.mock.calls[1],
	-- 				test,
	-- 				{ numFailingTests = 2, snapshot = {}, testResults = { {} } }
	-- 			)
	-- 			:expect()
	-- 		jestExpect(setState).toBeCalledWith({ interrupted = true })
	-- 	end)
	-- 	:expect()
end)

itSKIP("should not bail if less than `n` failures", function()
	-- return Promise.resolve()
	-- 	:andThen(function()
	-- 		local scheduler = createTestScheduler({ bail = 2 }, {}):expect()
	-- 		local test = {
	-- 			context = {
	-- 				config = makeProjectConfig({
	-- 					moduleFileExtensions = { ".js" },
	-- 					rootDir = "./",
	-- 					runner = "jest-runner-serial",
	-- 					transform = {},
	-- 				}),
	-- 				hasteFS = { matchFiles = jest.fn(function()
	-- 					return {}
	-- 				end) },
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
	-- 		mockSerialRunner.runTests.mock.calls[1]
	-- 			[4](
	-- 				mockSerialRunner.runTests.mock.calls[1],
	-- 				test,
	-- 				{ numFailingTests = 1, snapshot = {}, testResults = { {} } }
	-- 			)
	-- 			:expect()
	-- 		jestExpect(setState)["not"].toBeCalled()
	-- 	end)
	-- 	:expect()
end)

itSKIP("should set runInBand to run in serial", function()
	-- return Promise.resolve()
	-- 	:andThen(function()
	-- 		local scheduler = createTestScheduler({}, {}):expect()
	-- 		local test = {
	-- 			context = {
	-- 				config = makeProjectConfig({
	-- 					moduleFileExtensions = { ".js" },
	-- 					runner = "jest-runner-parallel",
	-- 					transform = {},
	-- 				}),
	-- 				hasteFS = { matchFiles = jest.fn(function()
	-- 					return {}
	-- 				end) },
	-- 			},
	-- 			path = "./test/path.js",
	-- 		}
	-- 		local tests = { test, test }
	-- 		spyShouldRunInBand:mockReturnValue(true)
	-- 		scheduler:scheduleTests(tests, { isInterrupted = jest.fn() }):expect()
	-- 		jestExpect(spyShouldRunInBand).toHaveBeenCalled()
	-- 		jestExpect(mockParallelRunner.runTests).toHaveBeenCalled()
	-- 		jestExpect(mockParallelRunner.runTests.mock.calls[1][6].serial).toBeTruthy()
	-- 	end)
	-- 	:expect()
end)

itSKIP("should set runInBand to not run in serial", function()
	-- return Promise.resolve()
	-- 	:andThen(function()
	-- 		local scheduler = createTestScheduler({}, {}):expect()
	-- 		local test = {
	-- 			context = {
	-- 				config = makeProjectConfig({
	-- 					moduleFileExtensions = { ".js" },
	-- 					runner = "jest-runner-parallel",
	-- 					transform = {},
	-- 				}),
	-- 				hasteFS = { matchFiles = jest.fn(function()
	-- 					return {}
	-- 				end) },
	-- 			},
	-- 			path = "./test/path.js",
	-- 		}
	-- 		local tests = { test, test }
	-- 		spyShouldRunInBand:mockReturnValue(false)
	-- 		scheduler:scheduleTests(tests, { isInterrupted = jest.fn() }):expect()
	-- 		jestExpect(spyShouldRunInBand).toHaveBeenCalled()
	-- 		jestExpect(mockParallelRunner.runTests).toHaveBeenCalled()
	-- 		jestExpect(mockParallelRunner.runTests.mock.calls[1][6].serial).toBeFalsy()
	-- 	end)
	-- 	:expect()
end)
-- ROBLOX deviation END

return {}
