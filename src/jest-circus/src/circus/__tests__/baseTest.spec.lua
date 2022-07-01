-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-circus/src/__tests__/baseTest.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

return function()
	local CurrentModule = script.Parent
	local SrcModule = CurrentModule.Parent
	local Packages = SrcModule.Parent.Parent
	local wrap = require(Packages.Dev.JestSnapshotSerializerRaw).default
	local runTest = require(script.Parent.Parent.__mocks__.testUtils).runTest

	local jestExpect = require(Packages.Dev.JestGlobals).expect

	it("simple test", function()
		local stdout = runTest([[
			describe("describe", function()
				beforeEach(function() end)
				afterEach(function() end)
				test("one", function() end)
				test("two", function() end)
			end)
		]]).stdout
		jestExpect(wrap(stdout)).toMatchSnapshot()
	end)

	it("failures", function()
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
		jestExpect(wrap(stdout)).toMatchSnapshot()
	end)
end
