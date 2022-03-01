-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/parens.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent

	local isMatch = require(PicomatchModule).isMatch
	describe("parens (non-extglobs)", function()
		it("should support stars following parens", function()
			assert(isMatch("a", "(a)*"))
			assert(isMatch("az", "(a)*"))
			assert(not isMatch("zz", "(a)*"))
			assert(isMatch("ab", "(a|b)*"))
			assert(isMatch("abc", "(a|b)*"))
			assert(isMatch("aa", "(a)*"))
			assert(isMatch("aaab", "(a|b)*"))
			assert(isMatch("aaabbb", "(a|b)*"))
		end)

		it("should not match slashes with single stars", function()
			assert(not isMatch("a/b", "(a)*"))
			assert(not isMatch("a/b", "(a|b)*"))
		end)
	end)
end
