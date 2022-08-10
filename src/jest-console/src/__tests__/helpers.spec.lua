-- ROBLOX note: no upstream

return (function()
	local CurrentModule = script.Parent
	local Packages = CurrentModule.Parent.Parent
	type Function = (...any) -> ...any

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local describe = (JestGlobals.describe :: any) :: Function
	local it = (JestGlobals.it :: any) :: Function

	local helpersModule = require(CurrentModule.Parent.helpers)
	local format = helpersModule.format
	local formatWithOptions = helpersModule.formatWithOptions

	describe("format", function()
		it("formats a string as expected", function()
			jestExpect(format("%s - 1 - %s - 2", "Hello", "World")).toBe("Hello - 1 - World - 2")
			jestExpect(format("%d%d", 1, 2)).toBe("12")
			jestExpect(format("hello")).toBe("hello")
		end)

		it("concats any extra args to the end of the string", function()
			jestExpect(format("%s - 1 - %s - 2", "Hello", "World", "Another one!")).toBe(
				"Hello - 1 - World - 2 Another one!"
			)
			jestExpect(format("Hello,", "world", "another", "one")).toBe("Hello, world another one")
		end)

		it("inspects complex values", function()
			jestExpect(format({ { "value" } })).toMatch("value")
			jestExpect(format({ "in table" }, "hello")).toMatch("hello")
		end)
	end)

	describe("formatWithOptions", function()
		it("accepts a depth option to enable printing deeper in nested tables", function()
			local nestedValue = { { { { { { { "value" } } } } } } }
			jestExpect(formatWithOptions({ depth = 2 }, nestedValue)).never.toMatch("value")
			jestExpect(formatWithOptions({ depth = 7 }, nestedValue)).toMatch("value")
		end)
	end)

	return {}
end)()
