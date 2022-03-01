-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/issue-related.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent

	local isMatch = require(PicomatchModule).isMatch
	describe("issue-related tests", function()
		it("should match with braces (see picomatch/issues#8)", function()
			assert(isMatch("directory/.test.txt", "{file.txt,directory/**/*}", { dot = true }))
			assert(isMatch("directory/test.txt", "{file.txt,directory/**/*}", { dot = true }))
			assert(not isMatch("directory/.test.txt", "{file.txt,directory/**/*}"))
			assert(isMatch("directory/test.txt", "{file.txt,directory/**/*}"))
		end)

		it("should match Japanese characters (see micromatch/issues#127)", function()
			assert(isMatch("フォルダ/aaa.js", "フ*/**/*"))
			assert(isMatch("フォルダ/aaa.js", "フォ*/**/*"))
			assert(isMatch("フォルダ/aaa.js", "フォル*/**/*"))
			assert(isMatch("フォルダ/aaa.js", "フ*ル*/**/*"))
			assert(isMatch("フォルダ/aaa.js", "フォルダ/**/*"))
		end)

		it("micromatch issue#15", function()
			assert(isMatch("a/b-c/d/e/z.js", "a/b-*/**/z.js"))
			assert(isMatch("z.js", "z*"))
			assert(isMatch("z.js", "**/z*"))
			assert(isMatch("z.js", "**/z*.js"))
			assert(isMatch("z.js", "**/*.js"))
			assert(isMatch("foo", "**/foo"))
		end)

		it("micromatch issue#23", function()
			assert(not isMatch("zzjs", "z*.js"))
			assert(not isMatch("zzjs", "*z.js"))
		end)

		it("micromatch issue#24", function()
			assert(not isMatch("a/b/c/d/", "a/b/**/f"))
			assert(isMatch("a", "a/**"))
			assert(isMatch("a", "**"))
			assert(isMatch("a/", "**"))
			assert(isMatch("a/b/c/d", "**"))
			assert(isMatch("a/b/c/d/", "**"))
			assert(isMatch("a/b/c/d/", "**/**"))
			assert(isMatch("a/b/c/d/", "**/b/**"))
			assert(isMatch("a/b/c/d/", "a/b/**"))
			assert(isMatch("a/b/c/d/", "a/b/**/"))
			assert(isMatch("a/b/c/d/e.f", "a/b/**/**/*.*"))
			assert(isMatch("a/b/c/d/e.f", "a/b/**/*.*"))
			assert(isMatch("a/b/c/d/g/e.f", "a/b/**/d/**/*.*"))
			assert(isMatch("a/b/c/d/g/g/e.f", "a/b/**/d/**/*.*"))
		end)

		itFIXME("micromatch issue#58 - only match nested dirs when `**` is the only thing in a segment", function()
			assert(not isMatch("a/b/c", "a/b**"))
			assert(not isMatch("a/c/b", "a/**b"))
		end)

		it("micromatch issue#79", function()
			assert(isMatch("a/foo.js", "**/foo.js"))
			assert(isMatch("foo.js", "**/foo.js"))
			assert(isMatch("a/foo.js", "**/foo.js", { dot = true }))
			assert(isMatch("foo.js", "**/foo.js", { dot = true }))
		end)
	end)
end
