-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local it = JestGlobals.it

-- ROBLOX FIXME START: we can't call toMatchSnapshot and expect it to fail as this would affect the test state
it.skip("tests that a missing snapshot file throws", function()
	jestExpect(function()
		jestExpect(nil :: any).toMatchSnapshot()
	end).toThrow(
		"Snapshot name: `tests that a missing snapshot file throws 1`\n\nNew snapshot was [1mnot written[22m. The update flag must be explicitly passed to write a new snapshot.\n\nThis is likely because this test is run in a continuous integration (CI) environment in which snapshots are not written by default."
	)
end)
-- ROBLOX FIXME END

return {}
