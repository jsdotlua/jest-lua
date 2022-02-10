--!nocheck
-- ROBLOX NOTE: no upstream

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local jestExpect = require(Packages.Dev.Expect)

	local toMatchSnapshot = require(CurrentModule).toMatchSnapshot
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

	it("tests snapshots with asymmetric matchers", function()
		jestExpect({
			createdAt = DateTime.now(),
			id = math.floor(math.random() * 20),
			name = "LeBron James"
		}).toMatchSnapshot({
			createdAt = jestExpect.any("DateTime"),
			id = jestExpect.any("number"),
			name = "LeBron James"
		})
	end)

	it("tests snapshots with asymmetric matchers and a subset of properties", function()
		jestExpect({
			createdAt = DateTime.now(),
			id = math.floor(math.random() * 20),
			name = "LeBron James"
		}).toMatchSnapshot({
			createdAt = jestExpect.any("DateTime"),
			id = jestExpect.any("number"),
		})
	end)

	it("test with newlines\nin the name\nand body", function()
		jestExpect("a\nb").toMatchSnapshot()
	end)
end