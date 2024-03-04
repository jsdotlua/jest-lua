-- ROBLOX upstream: https://github.com/facebook/jest/tree/v28.0.0/packages/jest-util/src/__tests__/isPromise.test.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local Promise = require("@pkg/@jsdotlua/promise")
local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local Symbol = LuauPolyfill.Symbol
local isPromise = require("../isPromise").default

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

describe("foo", function()
	describe("not a Promise: ", function()
		it("nil", function()
			expect(isPromise(nil)).toBe(false)
		end)

		-- ROBLOX FIXME: have to cast first Array element to `any` to avoid type narrowing issue
		for _, value in ipairs({ true :: any, 42, "1337", Symbol(), {} }) do
			it(tostring(value), function()
				expect(isPromise(value)).toBe(false)
			end)
		end
	end)

	it("a resolved Promise", function()
		expect(isPromise(Promise.resolve(42))).toBe(true)
	end)

	it("a rejected Promise", function()
		expect(isPromise(Promise.reject():catch(function() end))).toBe(true)
	end)
end)
