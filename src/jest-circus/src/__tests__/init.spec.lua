-- ROBLOX upstream: no upstream
return function()
	local Packages = script.Parent.Parent.Parent

	local jestExpect = require(Packages.Expect)

	local JestSnapshotSerializerRaw = require(Packages.Dev.JestSnapshotSerializerRaw)

	beforeAll(function()
		jestExpect.addSnapshotSerializer(JestSnapshotSerializerRaw)
	end)

	afterAll(function()
		jestExpect.resetSnapshotSerializers()
	end)
end
