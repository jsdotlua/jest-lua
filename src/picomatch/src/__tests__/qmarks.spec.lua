-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/qmarks.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent
	local Packages = PicomatchModule.Parent

	local jestExpect = require(Packages.Dev.Expect)

	local match = require(CurrentModule.support.match)
	local isMatch = require(PicomatchModule).isMatch
	describe("qmarks and stars", function()
		it("should match question marks with question marks", function()
			jestExpect(match({ "?", "??", "???" }, "?")).toEqual({ "?" })
			jestExpect(match({ "?", "??", "???" }, "??")).toEqual({ "??" })
			jestExpect(match({ "?", "??", "???" }, "???")).toEqual({ "???" })
		end)

		it("should match question marks and stars with question marks and stars", function()
			jestExpect(match({ "?", "??", "???" }, "?*")).toEqual({ "?", "??", "???" })
			jestExpect(match({ "?", "??", "???" }, "*?")).toEqual({ "?", "??", "???" })
			jestExpect(match({ "?", "??", "???" }, "?*?")).toEqual({ "??", "???" })
			jestExpect(match({ "?*", "?*?", "?*?*?" }, "?*")).toEqual({ "?*", "?*?", "?*?*?" })
			jestExpect(match({ "?*", "?*?", "?*?*?" }, "*?")).toEqual({ "?*", "?*?", "?*?*?" })
			jestExpect(match({ "?*", "?*?", "?*?*?" }, "?*?")).toEqual({ "?*", "?*?", "?*?*?" })
		end)

		it("should support consecutive stars and question marks", function()
			jestExpect(match({ "aaa", "aac", "abc" }, "a*?c")).toEqual({ "aac", "abc" })
			jestExpect(match({ "abc", "abb", "acc" }, "a**?c")).toEqual({ "abc", "acc" })
			jestExpect(match({ "abc", "aaaabbbbbbccccc" }, "a*****?c")).toEqual({ "abc", "aaaabbbbbbccccc" })
			jestExpect(match({ "a", "ab", "abc", "abcd" }, "*****?")).toEqual({ "a", "ab", "abc", "abcd" })
			jestExpect(match({ "a", "ab", "abc", "abcd" }, "*****??")).toEqual({ "ab", "abc", "abcd" })
			jestExpect(match({ "a", "ab", "abc", "abcd" }, "?*****??")).toEqual({ "abc", "abcd" })
			jestExpect(match({ "abc", "abb", "zzz" }, "?*****?c")).toEqual({ "abc" })
			jestExpect(match({ "abc", "bbb", "zzz" }, "?***?****?")).toEqual({ "abc", "bbb", "zzz" })
			jestExpect(match({ "abc", "bbb", "zzz" }, "?***?****c")).toEqual({ "abc" })
			jestExpect(match({ "abc" }, "*******?")).toEqual({ "abc" })
			jestExpect(match({ "abc" }, "*******c")).toEqual({ "abc" })
			jestExpect(match({ "abc" }, "?***?****")).toEqual({ "abc" })
			jestExpect(match({ "abcdecdhjk" }, "a****c**?**??*****")).toEqual({ "abcdecdhjk" })
			jestExpect(match({ "abcdecdhjk" }, "a**?**cd**?**??***k")).toEqual({ "abcdecdhjk" })
			jestExpect(match({ "abcdecdhjk" }, "a**?**cd**?**??***k**")).toEqual({ "abcdecdhjk" })
			jestExpect(match({ "abcdecdhjk" }, "a**?**cd**?**??k")).toEqual({ "abcdecdhjk" })
			jestExpect(match({ "abcdecdhjk" }, "a**?**cd**?**??k***")).toEqual({ "abcdecdhjk" })
			jestExpect(match({ "abcdecdhjk" }, "a*cd**?**??k")).toEqual({ "abcdecdhjk" })
		end)

		it("should match backslashes with question marks when not on windows", function()
			-- ROBLOX FIXME: need a test for platform
			local isWindows = false
			if isWindows then
				assert(not isMatch("aaa\\\\bbb", "aaa?bbb"))
				assert(isMatch("aaa\\\\bbb", "aaa??bbb"))
				assert(isMatch("aaa\\bbb", "aaa?bbb"))
			end
		end)

		it("should match one character per question mark", function()
			local fixtures = { "a", "aa", "ab", "aaa", "abcdefg" }
			jestExpect(match(fixtures, "?")).toEqual({ "a" })
			jestExpect(match(fixtures, "??")).toEqual({ "aa", "ab" })
			jestExpect(match(fixtures, "???")).toEqual({ "aaa" })
			jestExpect(match({ "a/", "/a/", "/a/b/", "/a/b/c/", "/a/b/c/d/" }, "??")).toEqual({})
			jestExpect(match({ "a/b/c.md" }, "a/?/c.md")).toEqual({ "a/b/c.md" })
			jestExpect(match({ "a/bb/c.md" }, "a/?/c.md")).toEqual({})
			jestExpect(match({ "a/bb/c.md" }, "a/??/c.md")).toEqual({ "a/bb/c.md" })
			jestExpect(match({ "a/bbb/c.md" }, "a/??/c.md")).toEqual({})
			jestExpect(match({ "a/bbb/c.md" }, "a/???/c.md")).toEqual({ "a/bbb/c.md" })
			jestExpect(match({ "a/bbbb/c.md" }, "a/????/c.md")).toEqual({ "a/bbbb/c.md" })
		end)

		it("should not match slashes question marks", function()
			local fixtures = { "//", "a/", "/a", "/a/", "aa", "/aa", "a/a", "aaa", "/aaa" }
			jestExpect(match(fixtures, "/?")).toEqual({ "/a" })
			jestExpect(match(fixtures, "/??")).toEqual({ "/aa" })
			jestExpect(match(fixtures, "/???")).toEqual({ "/aaa" })
			jestExpect(match(fixtures, "/?/")).toEqual({ "/a/" })
			jestExpect(match(fixtures, "??")).toEqual({ "aa" })
			jestExpect(match(fixtures, "?/?")).toEqual({ "a/a" })
			jestExpect(match(fixtures, "???")).toEqual({ "aaa" })
			jestExpect(match(fixtures, "a?a")).toEqual({ "aaa" })
			jestExpect(match(fixtures, "aa?")).toEqual({ "aaa" })
			jestExpect(match(fixtures, "?aa")).toEqual({ "aaa" })
		end)

		it("should support question marks and stars between slashes", function()
			jestExpect(match({ "a/b.bb/c/d/efgh.ijk/e" }, "a/*/?/**/e")).toEqual({ "a/b.bb/c/d/efgh.ijk/e" })
			jestExpect(match({ "a/b/c/d/e" }, "a/?/c/?/*/e")).toEqual({})
			jestExpect(match({ "a/b/c/d/e/e" }, "a/?/c/?/*/e")).toEqual({ "a/b/c/d/e/e" })
			jestExpect(match({ "a/b/c/d/efgh.ijk/e" }, "a/*/?/**/e")).toEqual({ "a/b/c/d/efgh.ijk/e" })
			jestExpect(match({ "a/b/c/d/efghijk/e" }, "a/*/?/**/e")).toEqual({ "a/b/c/d/efghijk/e" })
			jestExpect(match({ "a/b/c/d/efghijk/e" }, "a/?/**/e")).toEqual({ "a/b/c/d/efghijk/e" })
			jestExpect(match({ "a/b/c/d/efghijk/e" }, "a/?/c/?/*/e")).toEqual({ "a/b/c/d/efghijk/e" })
			jestExpect(match({ "a/bb/e" }, "a/?/**/e")).toEqual({})
			jestExpect(match({ "a/bb/e" }, "a/?/e")).toEqual({})
			jestExpect(match({ "a/bbb/c/d/efgh.ijk/e" }, "a/*/?/**/e")).toEqual({ "a/bbb/c/d/efgh.ijk/e" })
		end)

		it("should match no more than one character between slashes", function()
			local fixtures = { "a/a", "a/a/a", "a/aa/a", "a/aaa/a", "a/aaaa/a", "a/aaaaa/a" }
			jestExpect(match(fixtures, "?/?")).toEqual({ "a/a" })
			jestExpect(match(fixtures, "?/???/?")).toEqual({ "a/aaa/a" })
			jestExpect(match(fixtures, "?/????/?")).toEqual({ "a/aaaa/a" })
			jestExpect(match(fixtures, "?/?????/?")).toEqual({ "a/aaaaa/a" })
			jestExpect(match(fixtures, "a/?")).toEqual({ "a/a" })
			jestExpect(match(fixtures, "a/?/a")).toEqual({ "a/a/a" })
			jestExpect(match(fixtures, "a/??/a")).toEqual({ "a/aa/a" })
			jestExpect(match(fixtures, "a/???/a")).toEqual({ "a/aaa/a" })
			jestExpect(match(fixtures, "a/????/a")).toEqual({ "a/aaaa/a" })
			jestExpect(match(fixtures, "a/????a/a")).toEqual({ "a/aaaaa/a" })
		end)

		itFIXME("should not match non-leading dots with question marks", function()
			local fixtures = { ".", ".a", "a", "aa", "a.a", "aa.a", "aaa", "aaa.a", "aaaa.a", "aaaaa" }
			jestExpect(match(fixtures, "?")).toEqual({ "a" })
			jestExpect(match(fixtures, ".?")).toEqual({ ".a" })
			jestExpect(match(fixtures, "?a")).toEqual({ "aa" })
			jestExpect(match(fixtures, "??")).toEqual({ "aa" })
			jestExpect(match(fixtures, "?a?")).toEqual({ "aaa" })
			jestExpect(match(fixtures, "aaa?a")).toEqual({ "aaa.a", "aaaaa" })
			jestExpect(match(fixtures, "a?a?a")).toEqual({ "aaa.a", "aaaaa" })
			jestExpect(match(fixtures, "a???a")).toEqual({ "aaa.a", "aaaaa" })
			jestExpect(match(fixtures, "a?????")).toEqual({ "aaaa.a" })
		end)

		it("should match non-leading dots with question marks when options.dot is true", function()
			local fixtures = { ".", ".a", "a", "aa", "a.a", "aa.a", ".aa", "aaa.a", "aaaa.a", "aaaaa" }
			local opts = { dot = true }
			jestExpect(match(fixtures, "?", opts)).toEqual({ ".", "a" })
			jestExpect(match(fixtures, ".?", opts)).toEqual({ ".a" })
			jestExpect(match(fixtures, "?a", opts)).toEqual({ ".a", "aa" })
			jestExpect(match(fixtures, "??", opts)).toEqual({ ".a", "aa" })
			jestExpect(match(fixtures, "?a?", opts)).toEqual({ ".aa" })
		end)
	end)
end
