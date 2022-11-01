local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local it = JestGlobals.it

it("should not allow ModuleScripts returning zero values", function()
	expect(function()
		local _requireZero = (require(script.Parent["requireZero.roblox"]) :: any)
	end).toThrow("ModuleScripts must return exactly one value")
end)

it("should allow ModuleScripts returning nil", function()
	expect(function()
		require(script.Parent["requireNil.roblox"])
	end).never.toThrow()
end)

it("should allow ModuleScripts returning value", function()
	expect(function()
		require(script.Parent["requireOne.roblox"])
	end).never.toThrow()
end)

it("should not allow ModuleScripts returning two values", function()
	expect(function()
		require(script.Parent["requireTwo.roblox"])
	end).toThrow("ModuleScripts must return exactly one value")
end)
