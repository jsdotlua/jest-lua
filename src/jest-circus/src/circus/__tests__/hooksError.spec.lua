-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-circus/src/__tests__/hooksError.test.ts
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
	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Symbol = LuauPolyfill.Symbol

	local jestExpect = require(Packages.Dev.JestGlobals).expect

	local JestTypesModule = require(Packages.JestTypes)
	type Circus_HookType = JestTypesModule.Circus_HookType
	local circus = require(script.Parent.Parent).default

	-- ROBLOX deviation START: using for in loops instead of desribe.each and test.each
	for _, fn in ipairs({ "beforeEach", "beforeAll", "afterEach", "afterAll" }) do
		describe(("%s hooks error throwing"):format(fn), function()
			for _, v in
				ipairs({
					-- ROBLOX FIXME Luau: roblox-cli doesn't allow for mixed arrays
					{ "String" } :: any,
					{ 1 },
					{ {} },
					-- ROBLOX deviation: skipped because there is no distinction between empty object and empty array in Lua
					-- { {} },
					{ Symbol("hello") },
					{ true },
					{ nil },
					-- ROBLOX deviation: skipped because there is no distinction between null and undefined in Lua
					-- { nil },
				})
			do
				local el = v[1]
				it(
					("%s throws an error when %s is provided as a first argument to it"):format(fn, tostring(el)),
					function()
						jestExpect(function()
							circus[fn](el)
						end).toThrowError("Invalid first argument. It must be a callback function.")
					end
				)
			end
		end)
	end
	-- ROBLOX deviation END
end
