local JestGlobals = require("@DevPackages/JestGlobals")

local it = JestGlobals.it
local expect = JestGlobals.expect

local sum = require("@Project/Sum")

it("adds 1 + 2 to equal 3", function()
	expect(sum(1, 2)).toBe(3)
end)
