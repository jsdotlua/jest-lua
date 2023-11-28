-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.1.0/packages/jest-circus/src/__tests__/circusItFailingTestError.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local typesModule = require(Packages.JestTypes)

type Global_It = typesModule.Global_It
local circusIt: Global_It
local circusTest: Global_It

-- using jest-jasmine2's 'it' to test jest-circus's 'it'. Had to differentiate
-- the two with this alias.

local function aliasCircusIt()
	local ref = require(script.Parent.Parent)
	local it, test = ref.it, ref.test
	circusIt = it
	circusTest = test
end
aliasCircusIt()

describe("test/it.failing error throwing", function()
	it("it doesn't throw an error with valid arguments", function()
		expect(function()
			(circusIt :: any).failing("test1", function() end)
		end).never.toThrowError()
	end)

	it("it throws error with missing callback function", function()
		expect(function()
			(circusIt :: any).failing("test2")
		end).toThrowError(
			"Missing second argument. It must be a callback function. Perhaps you want to use `test.todo` for a test placeholder."
		)
	end)

	it("it throws an error when first argument isn't valid", function()
		expect(function()
			(circusIt :: any).failing(function() end)
		end).toThrowError(
			"Invalid first argument, [Function anonymous]. It must be a named function, number, or string."
		)
	end)

	it("it throws an error when callback function is not a function", function()
		expect(function()
			(circusIt :: any).failing("test4", "test4b")
		end).toThrowError("Invalid second argument, test4b. It must be a callback function.")
	end)

	it("test throws error with missing callback function", function()
		expect(function()
			(circusTest :: any).failing("test5")
		end).toThrowError(
			"Missing second argument. It must be a callback function. Perhaps you want to use `test.todo` for a test placeholder."
		)
	end)

	it("test throws an error when first argument isn't a string", function()
		expect(function()
			(circusTest :: any).failing(function() end)
		end).toThrowError(
			"Invalid first argument, [Function anonymous]. It must be a named function, number, or string."
		)
	end)
	it("test throws an error when callback function is not a function", function()
		expect(function()
			(circusTest :: any).failing("test7", "test8b")
		end).toThrowError("Invalid second argument, test8b. It must be a callback function.")
	end)
end)
