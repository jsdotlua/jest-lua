--!nocheck
return function()
	local Workspace = script.Parent.Parent
	local Modules = Workspace.Parent

	local jestExpect = require(Modules.Expect)

	local jest = require(Workspace)

	describe('Jest Object', function()
		describe('methods are initialized', function()
			describe('jestMock', function()
				it('fn', function()
					jestExpect(jest.fn).never.toBeNil()
				end)
				it('clearAllMocks', function()
					jestExpect(jest.clearAllMocks).never.toBeNil()
				end)
				it('resetAllMocks', function()
					jestExpect(jest.resetAllMocks).never.toBeNil()
				end)
			end)
		end)
	end)
end