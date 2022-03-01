-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/brackets.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent

	local isMatch = require(PicomatchModule).isMatch
	describe("brackets", function()
		describe("trailing stars", function()
			itFIXME("should support stars following brackets", function()
				assert(isMatch("a", "[a]*"))
				assert(isMatch("aa", "[a]*"))
				assert(isMatch("aaa", "[a]*"))
				assert(isMatch("az", "[a-z]*"))
				assert(isMatch("zzz", "[a-z]*"))
			end)

			itFIXME("should match slashes defined in brackets", function()
				assert(isMatch("foo/bar", "foo[/]bar"))
				assert(isMatch("foo/bar/", "foo[/]bar[/]"))
				assert(isMatch("foo/bar/baz", "foo[/]bar[/]baz"))
			end)

			it("should not match slashes following brackets", function()
				assert(not isMatch("a/b", "[a]*"))
			end)
		end)
	end)
end
