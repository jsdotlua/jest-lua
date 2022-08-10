-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/__tests__/installCommonGlobals.test.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

type Jest_Mock = any

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local jestExpect = JestGlobals.expect
local describe = (JestGlobals.describe :: any) :: Function
local it = (JestGlobals.it :: any) :: Function
local beforeEach = (JestGlobals.beforeEach :: any) :: Function

-- local vmModule = require(Packages.vm)
-- local createContext = vmModule.createContext
-- local runInContext = vmModule.runInContext
local installCommonGlobals: typeof({} :: any --[[ ROBLOX TODO: Unhandled node for type: TSImportType ]] --[[ import('../installCommonGlobals').default ]])
local fake: Jest_Mock
local function getGlobal(): typeof(_G)
	--[[
			ROBLOX deviation:
			original code:
			return runInContext('this', createContext());
		]]
	return Object.assign({}, _G)
end
describe("installCommonGlobals", function()
	beforeEach(function()
		fake = jest.fn() -- @ts-expect-error
		_G.DTRACE_NET_SERVER_CONNECTION = fake
		installCommonGlobals = require(script.Parent.Parent.installCommonGlobals)().default
	end)

	it("returns the passed object", function()
		local myGlobal = getGlobal()
		jestExpect(installCommonGlobals(myGlobal, {})).toBe(myGlobal)
	end)

	it("turns a V8 global object into a Node global object", function()
		local myGlobal = installCommonGlobals(getGlobal(), {})
		jestExpect(myGlobal.process).toBeDefined()
		jestExpect(myGlobal.DTRACE_NET_SERVER_CONNECTION).toBeDefined()
		jestExpect(myGlobal.DTRACE_NET_SERVER_CONNECTION).never.toBe(fake)
		myGlobal:DTRACE_NET_SERVER_CONNECTION()
		jestExpect(#fake.mock.calls).toBe(1)
	end)
end)

return {}
