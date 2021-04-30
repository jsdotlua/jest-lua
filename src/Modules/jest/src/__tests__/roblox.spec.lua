return function()
	local Workspace = script.Parent.Parent
	local Modules = Workspace.Parent

	local jestExpect = require(Modules.Expect)

	local jest = require(Workspace)

	-- ROBLOX TODO: ADO-1461
	describeSKIP('Jest Object', function()
		describe('methods are initialized', function()
			describe('jestMock', function()
				it('fn', function()
					jestExpect(jest.fn).never.toBeNil()
				end)
			end)
		end)
	end)
end