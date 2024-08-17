-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-circus/src/__tests__/afterAll.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local runTest = require("../__mocks__/testUtils").runTest

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local it = JestGlobals.it

-- ROBLOX deviation: these tests require loadmodule
local loadModuleEnabled = pcall((debug :: any).loadmodule, Instance.new("ModuleScript"))
if not loadModuleEnabled then
	it = it.skip :: any
end

it("tests are not marked done until their parent afterAll runs", function()
	local stdout = runTest([[
			describe("describe", function()
				afterAll(function() end)
				test("one", function() end)
				test("two", function() end)
				describe("2nd level describe", function()
					afterAll(function() end)
					test("2nd level test", function() end)

					describe("3rd level describe", function()
						test("3rd level test", function() end)
						test("3rd level test#2", function() end)
					end)
				end)
			end)

			describe("2nd describe", function()
				afterAll(function()
					error(Error.new("alabama"))
				end)
				test("2nd describe test", function() end)
			end)
			]]).stdout
	expect(stdout).toMatchSnapshot()
end)

it("describe block cannot have hooks and no tests", function()
	local result = runTest([[
			describe("describe", function()
				afterEach(function() end)
				beforeEach(function() end)
				afterAll(function() end)
				beforeAll(function() end)
			end)
  		]])
	expect(result.stdout).toMatchSnapshot()
end)

it("describe block _can_ have hooks if a child describe block has tests", function()
	local result = runTest([[
			describe("describe", function()
				afterEach(function()
					return console.log("> afterEach")
				end)
				beforeEach(function()
					return console.log("> beforeEach")
				end)
				afterAll(function()
					return console.log("> afterAll")
				end)
				beforeAll(function()
					return console.log("> beforeAll")
				end)
				describe("child describe", function()
					test("my test", function()
						return console.log("> my test")
					end)
				end)
			end)
		]])
	expect(result.stdout).toMatchSnapshot()
end)

it("describe block hooks must not run if describe block is skipped", function()
	local result = runTest([[
			describe.skip("describe", function()
				afterAll(function()
					return console.log("> afterAll")
				end)
				beforeAll(function()
					return console.log("> beforeAll")
				end)
				test("my test", function()
					return console.log("> my test")
				end)
			end)
		]])
	expect(result.stdout).toMatchSnapshot()
end)

it("child tests marked with todo should not run if describe block is skipped", function()
	local result = runTest([[
			describe.skip("describe", function()
				afterAll(function()
					return console.log("> afterAll")
				end)
				beforeAll(function()
					return console.log("> beforeAll")
				end)
				test.todo("my test")
			end)
		]])
	expect(result.stdout).toMatchSnapshot()
end)

it("child tests marked with only should not run if describe block is skipped", function()
	local result = runTest([[
			describe.skip("describe", function()
				afterAll(function()
					return console.log("> afterAll")
				end)
				beforeAll(function()
					return console.log("> beforeAll")
				end)
				test.only("my test", function()
					return console.log("> my test")
				end)
			end)
		]])
	expect(result.stdout).toMatchSnapshot()
end)
