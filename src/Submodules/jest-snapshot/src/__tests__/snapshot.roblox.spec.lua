local CurrentModule = script.Parent.Parent
local Modules = CurrentModule.Parent

local jestExpect = require(Modules.Expect)

local toMatchSnapshot = require(CurrentModule).toMatchSnapshot

return function()
	jestExpect.extend({
		toMatchTrimmedSnapshot = function(self, received, length)
			return toMatchSnapshot(
				self,
				string.sub(received, 1, length),
				'toMatchTrimmedSnapshot'
			)
		end
	})

	it("native lua errors", function()
		jestExpect(function() error("oops") end).toThrowErrorMatchingSnapshot()
	end)

	it("custom snapshot matchers", function()
		jestExpect('extra long string oh my gerd').toMatchTrimmedSnapshot(10)
	end)

	it("tests that a missing snapshot throws", function()
		jestExpect(function() jestExpect().toMatchSnapshot() end).toThrow("Snapshot name: `tests that a missing snapshot throws 1`\n\nNew snapshot was [1mnot written[22m. The update flag must be explicitly passed to write a new snapshot.\n\nThis is likely because this test is run in a continuous integration (CI) environment in which snapshots are not written by default.")
	end)
end