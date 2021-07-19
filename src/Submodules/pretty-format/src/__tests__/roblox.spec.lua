--!nocheck

return function()
	local CurrentModule = script.Parent.Parent
	local Modules = CurrentModule.Parent

	local jestExpect = require(Modules.Expect)

	local prettyFormat = require(CurrentModule).prettyFormat

	it('userdata', function()
		local testObject = newproxy()

		jestExpect(prettyFormat(testObject)).toContain('userdata: 0x')
	end)

	it('Instance', function()
		local testObject = Instance.new("Frame")

		jestExpect(prettyFormat(testObject)).toEqual("Frame")
	end)
end