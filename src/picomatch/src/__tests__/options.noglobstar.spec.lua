-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/options.noglobstar.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent

	local isMatch = require(PicomatchModule).isMatch
	describe("options.noglobstar", function()
		it("should disable extglob support when options.noglobstar is true", function()
			assert(isMatch("a/b/c", "**", { noglobstar = false }))
			assert(not isMatch("a/b/c", "**", { noglobstar = true }))
			assert(isMatch("a/b/c", "a/**", { noglobstar = false }))
			assert(not isMatch("a/b/c", "a/**", { noglobstar = true }))
		end)
	end)
end
