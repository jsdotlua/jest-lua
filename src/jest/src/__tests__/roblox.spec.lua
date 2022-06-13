return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local jest = JestGlobals.jest

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
end
