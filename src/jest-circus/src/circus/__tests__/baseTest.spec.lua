-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-circus/src/__tests__/baseTest.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent.Parent
local runTest = require(script.Parent.Parent.__mocks__.testUtils).runTest

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local test = JestGlobals.test

test("simple test", function()
	local stdout = runTest([[
			describe("describe", function()
				beforeEach(function() end)
				afterEach(function() end)
				test("one", function() end)
				test("two", function() end)
			end)
	]]).stdout
	expect(stdout).toMatchSnapshot()
end)
-- ROBLOX deviation START: see if we can make this work later
-- test("function descriptors", function()
test.skip("function descriptors", function()
	-- ROBLOX deviation END
	local stdout = runTest([[
		describe(function describer() end, function()
			test(class One {}, function() end);
		end)
  	]]).stdout
	expect(stdout).toMatchSnapshot()
end)
test("failures", function()
	local stdout = runTest([[
			describe("describe", function()
				beforeEach(function() end)
				afterEach(function()
					error(Error.new("banana"))
				end)
				test("one", function()
					error(Error.new("kentucky"))
				end)
				test("two", function() end)
			end)
  		]]).stdout
	expect(stdout).toMatchSnapshot()
end)
