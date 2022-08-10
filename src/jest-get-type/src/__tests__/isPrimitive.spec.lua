-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-get-type/src/__tests__/isPrimitive.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

local Packages = script.Parent.Parent.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local isPrimitive = require(script.Parent.Parent).isPrimitive

describe(".isPrimitive()", function()
	it("returns true when given primitive value of: nil", function()
		expect(isPrimitive(nil)).toBe(true)
	end)

	-- ROBLOX deviation: test omitted because lua has no primitive undefined type

	it("returns true when given primitive value of: 100", function()
		expect(isPrimitive(100)).toBe(true)
	end)

	it("returns true when given primitive value of: 'hello world'", function()
		expect(isPrimitive("hello world")).toBe(true)
	end)

	it("returns true when given primitive value of: true", function()
		expect(isPrimitive(true)).toBe(true)
	end)

	-- ROBLOX deviation: test omitted because lua has no primitive symbol type

	it("returns true when given primitive value of: 0", function()
		expect(isPrimitive(0)).toBe(true)
	end)

	it("returns true when given primitive value of: -nan", function()
		expect(isPrimitive(0 / 0)).toBe(true)
	end)

	it("returns true when given primitive value of: inf", function()
		expect(isPrimitive(math.huge)).toBe(true)
	end)

	-- ROBLOX deviation: test omitted because lua has no primitive bigint type

	-- ROBLOX deviation: lua makes no distinction between tables, objects, and arrays
	it("returns false when given non primitive value of: {}", function()
		expect(isPrimitive({})).toBe(false)
	end)

	it("returns false when given non primitive value of: function() end", function()
		expect(isPrimitive(function() end)).toBe(false)
	end)

	-- ROBLOX deviation: added Roblox Instance as a non primitive
	it("returns false when given non primitive value of: Instance", function()
		expect(isPrimitive(Instance.new("Frame"))).toBe(false)
	end)

	-- ROBLOX deviation: test omitted because lua has no primitive symbol type
	-- ROBLOX deviation: test omitted because lua has no built-in RegExp, Map, Set or Date types
end)

return {}
