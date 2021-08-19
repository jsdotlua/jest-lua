--!nocheck

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local jestExpect = require(Packages.Dev.Expect)

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