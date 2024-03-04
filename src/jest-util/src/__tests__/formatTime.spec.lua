-- ROBLOX upstream: https://github.com/facebook/jest/tree/v28.0.0/packages/jest-util/src/__tests__/formatTime.test.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local it = JestGlobals.it

local formatTime = require("../formatTime").default
it("defaults to milliseconds", function()
	expect(formatTime(42)).toBe("42 ms")
end)

it("formats seconds properly", function()
	expect(formatTime(42, 0)).toBe("42 s")
end)

it("formats milliseconds properly", function()
	expect(formatTime(42, -3)).toBe("42 ms")
end)

it("formats microseconds properly", function()
	expect(formatTime(42, -6)).toBe("42 μs")
end)

it("formats nanoseconds properly", function()
	expect(formatTime(42, -9)).toBe("42 ns")
end)

it("interprets lower than lowest powers as nanoseconds", function()
	expect(formatTime(42, -12)).toBe("42 ns")
end)

it("interprets higher than highest powers as seconds", function()
	expect(formatTime(42, 3)).toBe("42 s")
end)

it("interprets non-multiple-of-3 powers as next higher prefix", function()
	expect(formatTime(42, -4)).toBe("42 ms")
end)

it("formats the quantity properly when pad length is lower", function()
	expect(formatTime(42, -3, 1)).toBe("42 ms")
end)

it("formats the quantity properly when pad length is equal", function()
	expect(formatTime(42, -3, 2)).toBe("42 ms")
end)

it("left pads the quantity properly when pad length is higher", function()
	expect(formatTime(42, -3, 5)).toBe("   42 ms")
end)
