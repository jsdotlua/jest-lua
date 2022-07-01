-- ROBLOX upstream: no upstream
return function()
	local Packages = script.Parent.Parent.Parent.Parent

	local jestExpect = require(Packages.Dev.JestGlobals).expect

	local JestSnapshotSerializerRaw = require(Packages.Dev.JestSnapshotSerializerRaw)

	beforeAll(function()
		jestExpect.addSnapshotSerializer(JestSnapshotSerializerRaw)
	end)

	afterAll(function()
		jestExpect.resetSnapshotSerializers()
	end)
end
