-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/__tests__/formatTime.test.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local jestExpect = require(Packages.Dev.JestGlobals).expect

	local formatTime = require(script.Parent.Parent.formatTime).default
	it("defaults to milliseconds", function()
		jestExpect(formatTime(42)).toBe("42 ms")
	end)

	it("formats seconds properly", function()
		jestExpect(formatTime(42, 0)).toBe("42 s")
	end)

	it("formats milliseconds properly", function()
		jestExpect(formatTime(42, -3)).toBe("42 ms")
	end)

	it("formats microseconds properly", function()
		jestExpect(formatTime(42, -6)).toBe("42 μs")
	end)

	it("formats nanoseconds properly", function()
		jestExpect(formatTime(42, -9)).toBe("42 ns")
	end)

	it("interprets lower than lowest powers as nanoseconds", function()
		jestExpect(formatTime(42, -12)).toBe("42 ns")
	end)

	it("interprets higher than highest powers as seconds", function()
		jestExpect(formatTime(42, 3)).toBe("42 s")
	end)

	it("interprets non-multiple-of-3 powers as next higher prefix", function()
		jestExpect(formatTime(42, -4)).toBe("42 ms")
	end)

	it("formats the quantity properly when pad length is lower", function()
		jestExpect(formatTime(42, -3, 1)).toBe("42 ms")
	end)

	it("formats the quantity properly when pad length is equal", function()
		jestExpect(formatTime(42, -3, 2)).toBe("42 ms")
	end)

	it("left pads the quantity properly when pad length is higher", function()
		jestExpect(formatTime(42, -3, 5)).toBe("   42 ms")
	end)
end
