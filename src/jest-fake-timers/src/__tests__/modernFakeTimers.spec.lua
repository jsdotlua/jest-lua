-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-fake-timers/src/__tests__/modernFakeTimers.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local LuauPolyfill = require(Packages.LuauPolyfill)
	local setTimeout = LuauPolyfill.setTimeout
	local clearTimeout = LuauPolyfill.clearTimeout

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	local jest = JestGlobals.jest

	afterEach(function()
		jest.useRealTimers()
	end)

	-- ROBLOX TODO: the mocked delay and tick aren't in the environment of polyfilled functions
	-- unskip and fix when we can figure this out
	describeSKIP("FakeTimers", function()
		describe("construction", function()
			it("installs delay mock", function()
				jestExpect(setTimeout).never.toBeNil()
			end)

			it("installs clearTimeout mock", function()
				jestExpect(clearTimeout).never.toBeNil()
			end)
		end)

		-- ROBLOX deviation: omitted runAllTicks, not implemented

		describe("runAllTimers", function()
			it("runs all ticks, in order", function()
				jest.useFakeTimers()

				local runOrder = {}
				local mock1 = jest.fn(function()
					table.insert(runOrder, "mock1")
				end)
				local mock2 = jest.fn(function()
					table.insert(runOrder, "mock2")
				end)
				local mock3 = jest.fn(function()
					table.insert(runOrder, "mock3")
				end)
				local mock4 = jest.fn(function()
					table.insert(runOrder, "mock4")
				end)
				local mock5 = jest.fn(function()
					table.insert(runOrder, "mock5")
				end)
				local mock6 = jest.fn(function()
					table.insert(runOrder, "mock6")
				end)

				setTimeout(mock1, 100)
				setTimeout(mock2, 0 / 0)
				setTimeout(mock3, 0)
				setTimeout(mock4, 200)
				setTimeout(mock5, math.huge)
				setTimeout(mock6, -math.huge)

				jest.runAllTimers()
				jestExpect(runOrder).toEqual({
					"mock2",
					"mock3",
					"mock5",
					"mock6",
					"mock1",
					"mock4",
				})
			end)
		end)
	end)
end
