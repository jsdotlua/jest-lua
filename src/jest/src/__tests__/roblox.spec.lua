local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

describe("Jest Object", function()
	describe("methods are initialized", function()
		describe("jestMock", function()
			it("fn", function()
				jestExpect(jest.fn).never.toBeNil()
			end)
			it("clearAllMocks", function()
				jestExpect(jest.clearAllMocks).never.toBeNil()
			end)
			it("resetAllMocks", function()
				jestExpect(jest.resetAllMocks).never.toBeNil()
			end)
		end)
	end)
end)

return {}
