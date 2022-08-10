-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = (JestGlobals.describe :: any) :: Function
local it = (JestGlobals.it :: any) :: Function

local getType = require(CurrentModule).getType
local isRobloxBuiltin = require(CurrentModule).isRobloxBuiltin

describe(".getType()", function()
	it("supports tables with a throwing __index metamethod", function()
		local testObj = {}
		setmetatable(testObj, {
			__index = function(self, key)
				error(("%q is not a valid member of BackBehavior"):format(tostring(key)), 2)
			end,
		})
		expect(getType(testObj)).toBe("table")
	end)

	it("supports builtin Roblox Datatypes", function()
		expect(getType(Vector3.new())).toBe("Vector3")
		expect(getType(Color3.new())).toBe("Color3")
		expect(getType(UDim2.new())).toBe("UDim2")
	end)
end)

describe(".isRobloxBuiltin()", function()
	it("returns true for builtin types", function()
		expect(isRobloxBuiltin(Vector3.new())).toBe(true)
		expect(isRobloxBuiltin(Color3.new())).toBe(true)
		expect(isRobloxBuiltin(UDim2.new())).toBe(true)
	end)

	it("returns false for non builtin types", function()
		expect(isRobloxBuiltin(1)).toBe(false)
		expect(isRobloxBuiltin({})).toBe(false)
		expect(isRobloxBuiltin(newproxy())).toBe(false)
	end)
end)

return {}
