-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-circus/src/__tests__/circusItTodoTestError.test.ts
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

-- using jest-jasmine2's 'it' to test jest-circus's 'it'. Had to differentiate
-- the two with this alias.

local function aliasCircusIt()
	local it = require(script.Parent.Parent).it
	circusIt = it
end

aliasCircusIt()

describe("test/it.todo error throwing", function()
	it("todo throws error when given no arguments", function()
		expect(function()
			-- @ts-expect-error: Testing runtime errors here
			(circusIt.todo :: any)()
		end).toThrowError("Todo must be called with only a description.")
	end)

	it("todo throws error when given more than one argument", function()
		expect(function()
			(circusIt.todo :: any)("test1", function() end)
		end).toThrowError("Todo must be called with only a description.")
	end)

	it("todo throws error when given none string description", function()
		expect(function()
			-- @ts-expect-error: Testing runtime errors here
			(circusIt.todo :: any)(function() end)
		end).toThrowError("Todo must be called with only a description.")
	end)
end)
