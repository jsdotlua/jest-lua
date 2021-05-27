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
				-- ROBLOX TODO: ADO-1499 remove in v2.0
				it('colon syntax for jestMock', function()
					local mockFn = jest:fn(function() return 1 end)
					local val = mockFn()
					jestExpect(mockFn).toHaveBeenCalled()
					jestExpect(val).toBe(1)
					jest:clearAllMocks()
					jestExpect(mockFn).never.toHaveBeenCalled()

					jest:resetAllMocks()
					val = mockFn()
					jestExpect(val).toBeNil()
				end)
			end)
		end)
	end)
end