--!nocheck

return function()
	local Workspace = script.Parent.Parent
	local Modules = Workspace.Parent

	local jestExpect = require(Modules.Expect)

	local prettyFormat = require(Workspace).prettyFormat

	it('userdata', function()
		local testObject = newproxy()

		jestExpect(prettyFormat(testObject)).toContain('userdata: 0x')
	end)

	it('Instance', function()
		local testObject = Instance.new("Frame")

		jestExpect(prettyFormat(testObject)).toEqual("Frame")
	end)
end