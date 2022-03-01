-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/malicious.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent
	local Packages = PicomatchModule.Parent

	local jestExpect = require(Packages.Dev.Expect)

	local isMatch = require(PicomatchModule).isMatch
	local function repeat_(n)
		return string.rep("\\", n)
	end
	--[[*
	 * These tests are based on minimatch unit tests
	 ]]
	describe("handling of potential regex exploits", function()
		it("should support long escape sequences", function()
			-- ROBLOX FIXME: need a test for platform
			local isWindows = false
			if isWindows then
				assert(isMatch("\\A", ("%sA"):format(repeat_(65500))), "within the limits, and valid match")
			end
			assert(isMatch("A", ("!%sA"):format(repeat_(65500))), "within the limits, and valid match")
			assert(isMatch("A", ("!(%sA)"):format(repeat_(65500))), "within the limits, and valid match")
			assert(not isMatch("A", ("[!(%sA"):format(repeat_(65500))), "within the limits, but invalid regex")
		end)

		it("should throw an error when the pattern is too long", function()
			jestExpect(function()
				return isMatch("foo", string.rep("*", 65537))
			end).toThrowError("exceeds maximum allowed")
			jestExpect(function()
				assert(not isMatch("A", ("!(%sA)"):format(repeat_(65536))))
			end).toThrowError("Input length: 65540, exceeds maximum allowed length: 65536")
		end)

		it("should allow max bytes to be customized", function()
			jestExpect(function()
				assert(not isMatch("A", ("!(%sA)"):format(repeat_(500)), { maxLength = 499 }))
			end).toThrowError("Input length: 504, exceeds maximum allowed length: 499")
		end)
	end)
end
