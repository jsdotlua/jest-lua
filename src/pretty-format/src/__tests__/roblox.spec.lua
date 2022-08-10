-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local it = JestGlobals.it

local prettyFormat = require(CurrentModule).default

it("userdata", function()
	local testObject = newproxy()

	jestExpect(prettyFormat(testObject)).toContain("userdata: 0x")
end)

it("Instance", function()
	local testObject = Instance.new("Frame")

	jestExpect(prettyFormat(testObject)).toEqual("Frame")
end)

it("Builtin Datatypes", function()
	jestExpect(prettyFormat(Color3.new(1, 1, 1))).toEqual("Color3(1, 1, 1)")
	jestExpect(prettyFormat(UDim2.new(1, 50, 0, 50))).toEqual("UDim2({1, 50}, {0, 50})")
	jestExpect(prettyFormat(Vector3.new(10, 20, 30))).toEqual("Vector3(10, 20, 30)")
end)

return {}
