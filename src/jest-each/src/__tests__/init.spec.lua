-- ROBLOX upstream: no upstream
return function()
	local Packages = script.Parent.Parent.Parent

	local jestExpect = require(Packages.Dev.Expect)
	local ConvertAnsi = require(Packages.PrettyFormat).plugins.ConvertAnsi

	beforeAll(function()
		jestExpect.addSnapshotSerializer({
			serialize = ConvertAnsi.toHumanReadableAnsi,
			test = ConvertAnsi.test,
		})
	end)

	afterAll(function()
		jestExpect.resetSnapshotSerializers()
	end)
end
