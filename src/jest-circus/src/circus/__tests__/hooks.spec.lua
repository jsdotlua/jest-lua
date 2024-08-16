-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-circus/src/__tests__/hooks.test.ts
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
local it = JestGlobals.it

-- ROBLOX deviation: these tests require loadmodule
local loadModuleEnabled = pcall((debug :: any).loadmodule, Instance.new("ModuleScript"))
if not loadModuleEnabled then
	it = it.skip :: any
end

it("beforeEach is executed before each test in current/child describe blocks", function()
	local stdout = runTest([[
			describe("describe", function()
				beforeEach(function()
					return console.log("> describe beforeEach")
				end)
				test("one", function() end)
				test("two", function() end)
				describe("2nd level describe", function()
					beforeEach(function()
						return console.log("> 2nd level describe beforeEach")
					end)
					test("2nd level test", function() end)

					describe("3rd level describe", function()
						test("3rd level test", function() end)
						test("3rd level test#2", function() end)
					end)
				end)
			end)

			describe("2nd describe", function()
				beforeEach(function()
					console.log("> 2nd describe beforeEach that throws")
					error(Error.new("alabama"))
				end)
				test("2nd describe test", function() end)
			end)
  	]]).stdout
	expect(stdout).toMatchSnapshot()
end)

it("multiple before each hooks in one describe are executed in the right order", function()
	local stdout = runTest([[
			describe("describe 1", function()
				beforeEach(function()
					console.log("before each 1")
				end)
				beforeEach(function()
					console.log("before each 2")
				end)

				describe("2nd level describe", function()
					test("test", function() end)
				end)
			end)
  	]]).stdout
	expect(stdout).toMatchSnapshot()
end)

it("beforeAll is exectued correctly", function()
	local stdout = runTest([[
			describe("describe 1", function()
				beforeAll(function()
					return console.log("> beforeAll 1")
				end)
				test("test 1", function()
					return console.log("> test 1")
				end)

				describe("2nd level describe", function()
					beforeAll(function()
						return console.log("> beforeAll 2")
					end)
					test("test 2", function()
						return console.log("> test 2")
					end)
					test("test 3", function()
						return console.log("> test 3")
					end)
				end)
			end)
  	]]).stdout
	expect(stdout).toMatchSnapshot()
end)
