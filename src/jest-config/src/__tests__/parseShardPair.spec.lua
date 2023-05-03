-- ROBLOX upstream: https://github.com/facebook/jest/blob/v29.1.2-1-g2662f4708e/packages/jest-config/src/__tests__/parseShardPair.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]
local Packages = script.Parent.Parent.Parent
local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local it = JestGlobals.it
local parseShardPair = require(script.Parent.Parent.parseShardPair).parseShardPair
it("raises an exception if shard has wrong format", function()
	expect(function()
		return parseShardPair("mumble")
	end).toThrow("string in the format of <n>/<m>")
end)
it("raises an exception if shard pair has to many items", function()
	expect(function()
		return parseShardPair("1/2/3")
	end).toThrow("string in the format of <n>/<m>")
end)
it("raises an exception if shard has floating points", function()
	expect(function()
		return parseShardPair("1.0/1")
	end).toThrow("string in the format of <n>/<m>")
end)
it("raises an exception if first item in shard pair is no number", function()
	expect(function()
		return parseShardPair("a/1")
	end).toThrow("string in the format of <n>/<m>")
end)
it("raises an exception if second item in shard pair is no number", function()
	expect(function()
		return parseShardPair("1/a")
	end).toThrow("string in the format of <n>/<m>")
end)
it("raises an exception if shard contains negative number", function()
	expect(function()
		return parseShardPair("1/-1")
	end).toThrow("string in the format of <n>/<m>")
end)
it("raises an exception if shard is zero-indexed", function()
	expect(function()
		return parseShardPair("0/1")
	end).toThrow("requires 1-based values, received 0")
end)
it("raises an exception if shard index is larger than shard count", function()
	expect(function()
		return parseShardPair("2/1")
	end).toThrow("requires <n> to be lower or equal than <m>")
end)
it("allows valid shard format", function()
	expect(function()
		return parseShardPair("1/2")
	end).never.toThrow()
end)

return {}
