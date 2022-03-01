-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/options.noextglob.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent

	local isMatch = require(PicomatchModule).isMatch
	describe("options.noextglob", function()
		it("should disable extglob support when options.noextglob is true", function()
			assert(isMatch("a+z", "a+(z)", { noextglob = true }))
			assert(not isMatch("az", "a+(z)", { noextglob = true }))
			assert(not isMatch("azz", "a+(z)", { noextglob = true }))
			assert(not isMatch("azzz", "a+(z)", { noextglob = true }))
		end)

		it("should work with noext alias to support minimatch", function()
			assert(isMatch("a+z", "a+(z)", { noext = true }))
			assert(not isMatch("az", "a+(z)", { noext = true }))
			assert(not isMatch("azz", "a+(z)", { noext = true }))
			assert(not isMatch("azzz", "a+(z)", { noext = true }))
		end)
	end)
end
