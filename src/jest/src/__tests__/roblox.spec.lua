return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local jestExpect = require(Packages.Dev.Expect)

	local jest = require(CurrentModule)

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
