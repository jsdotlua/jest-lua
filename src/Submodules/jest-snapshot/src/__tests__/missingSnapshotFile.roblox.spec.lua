local CurrentModule = script.Parent.Parent
local Modules = CurrentModule.Parent

local jestExpect = require(Modules.Expect)

return function()
	it("tests that a missing snapshot file throws", function()
        jestExpect(function() jestExpect().toMatchSnapshot() end).toThrow("Snapshot name: `tests that a missing snapshot file throws 1`\n\nNew snapshot was [1mnot written[22m. The update flag must be explicitly passed to write a new snapshot.\n\nThis is likely because this test is run in a continuous integration (CI) environment in which snapshots are not written by default.")
    end)
end