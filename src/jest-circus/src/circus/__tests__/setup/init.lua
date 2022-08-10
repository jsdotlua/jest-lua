-- ROBLOX upstream: no upstream
local Packages = script.Parent.Parent.Parent.Parent
return (function(...: any)
	type Function = (...any) -> ...any

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local beforeAll = (JestGlobals.beforeAll :: any) :: Function
	local afterAll = (JestGlobals.afterAll :: any) :: Function

	local JestSnapshotSerializerRaw = require(Packages.Dev.JestSnapshotSerializerRaw)

	beforeAll(function()
		jestExpect.addSnapshotSerializer(JestSnapshotSerializerRaw)
	end)

	afterAll(function()
		jestExpect.resetSnapshotSerializers()
	end)

	return {}
end)()
