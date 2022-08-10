-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/__tests__/isPromise.test.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

return (function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent
	local Promise = require(Packages.Promise)
	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Symbol = LuauPolyfill.Symbol
	local isPromise = require(CurrentModule.isPromise).default

	type Function = (...any) -> ...any

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local describe = (JestGlobals.describe :: any) :: Function
	local it = (JestGlobals.it :: any) :: Function

	describe("foo", function()
		describe("not a Promise: ", function()
			it("nil", function()
				jestExpect(isPromise(nil)).toBe(false)
			end)

			-- ROBLOX FIXME: have to cast first Array element to `any` to avoid type narrowing issue
			for _, value in ipairs({ true :: any, 42, "1337", Symbol(), {} }) do
				it(tostring(value), function()
					jestExpect(isPromise(value)).toBe(false)
				end)
			end
		end)

		it("a resolved Promise", function()
			jestExpect(isPromise(Promise.resolve(42))).toBe(true)
		end)

		it("a rejected Promise", function()
			jestExpect(isPromise(Promise.reject():catch(function() end))).toBe(true)
		end)
	end)

	return {}
end)()
