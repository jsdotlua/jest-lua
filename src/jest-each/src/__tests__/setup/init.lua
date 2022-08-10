-- ROBLOX upstream: no upstream
return (function()
	local Packages = script.Parent.Parent.Parent

	type Function = (...any) -> ...any

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local beforeAll = (JestGlobals.beforeAll :: any) :: Function
	local afterAll = (JestGlobals.afterAll :: any) :: Function

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

	return {}
end)()
