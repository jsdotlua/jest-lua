-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/bash.spec.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent

	local isMatch = require(PicomatchModule).isMatch
	describe("bash.spec", function()
		describe("dotglob", function()
			itFIXME('"a/b/.x" should match "**/.x/**"', function()
				assert(isMatch("a/b/.x", "**/.x/**", { bash = true }))
			end)

			itFIXME('".x" should match "**/.x/**"', function()
				assert(isMatch(".x", "**/.x/**", { bash = true }))
			end)

			it('".x/" should match "**/.x/**"', function()
				assert(isMatch(".x/", "**/.x/**", { bash = true }))
			end)

			it('".x/a" should match "**/.x/**"', function()
				assert(isMatch(".x/a", "**/.x/**", { bash = true }))
			end)

			it('".x/a/b" should match "**/.x/**"', function()
				assert(isMatch(".x/a/b", "**/.x/**", { bash = true }))
			end)

			itFIXME('".x/.x" should match "**/.x/**"', function()
				assert(isMatch(".x/.x", "**/.x/**", { bash = true }))
			end)

			itFIXME('"a/.x" should match "**/.x/**"', function()
				assert(isMatch("a/.x", "**/.x/**", { bash = true }))
			end)

			it('"a/b/.x/c" should match "**/.x/**"', function()
				assert(isMatch("a/b/.x/c", "**/.x/**", { bash = true }))
			end)

			it('"a/b/.x/c/d" should match "**/.x/**"', function()
				assert(isMatch("a/b/.x/c/d", "**/.x/**", { bash = true }))
			end)

			it('"a/b/.x/c/d/e" should match "**/.x/**"', function()
				assert(isMatch("a/b/.x/c/d/e", "**/.x/**", { bash = true }))
			end)

			it('"a/b/.x/" should match "**/.x/**"', function()
				assert(isMatch("a/b/.x/", "**/.x/**", { bash = true }))
			end)

			it('"a/.x/b" should match "**/.x/**"', function()
				assert(isMatch("a/.x/b", "**/.x/**", { bash = true }))
			end)

			itFIXME('"a/.x/b/.x/c" should not match "**/.x/**"', function()
				assert(not isMatch("a/.x/b/.x/c", "**/.x/**", { bash = true }))
			end)

			itFIXME('".bashrc" should not match "?bashrc"', function()
				assert(not isMatch(".bashrc", "?bashrc", { bash = true }))
			end)

			it("should match trailing slashes with stars", function()
				assert(isMatch(".bar.baz/", ".*.*", { bash = true }))
			end)

			it('".bar.baz/" should match ".*.*/"', function()
				assert(isMatch(".bar.baz/", ".*.*/", { bash = true }))
			end)

			it('".bar.baz" should match ".*.*"', function()
				assert(isMatch(".bar.baz", ".*.*", { bash = true }))
			end)
		end)

		describe("glob", function()
			itFIXME('"a/b/.x" should match "**/.x/**"', function()
				assert(isMatch("a/b/.x", "**/.x/**", { bash = true }))
			end)

			itFIXME('".x" should match "**/.x/**"', function()
				assert(isMatch(".x", "**/.x/**", { bash = true }))
			end)

			it('".x/" should match "**/.x/**"', function()
				assert(isMatch(".x/", "**/.x/**", { bash = true }))
			end)

			it('".x/a" should match "**/.x/**"', function()
				assert(isMatch(".x/a", "**/.x/**", { bash = true }))
			end)

			it('".x/a/b" should match "**/.x/**"', function()
				assert(isMatch(".x/a/b", "**/.x/**", { bash = true }))
			end)

			itFIXME('".x/.x" should match "**/.x/**"', function()
				assert(isMatch(".x/.x", "**/.x/**", { bash = true }))
			end)

			itFIXME('"a/.x" should match "**/.x/**"', function()
				assert(isMatch("a/.x", "**/.x/**", { bash = true }))
			end)

			it('"a/b/.x/c" should match "**/.x/**"', function()
				assert(isMatch("a/b/.x/c", "**/.x/**", { bash = true }))
			end)

			it('"a/b/.x/c/d" should match "**/.x/**"', function()
				assert(isMatch("a/b/.x/c/d", "**/.x/**", { bash = true }))
			end)

			it('"a/b/.x/c/d/e" should match "**/.x/**"', function()
				assert(isMatch("a/b/.x/c/d/e", "**/.x/**", { bash = true }))
			end)

			it('"a/b/.x/" should match "**/.x/**"', function()
				assert(isMatch("a/b/.x/", "**/.x/**", { bash = true }))
			end)

			it('"a/.x/b" should match "**/.x/**"', function()
				assert(isMatch("a/.x/b", "**/.x/**", { bash = true }))
			end)

			itFIXME('"a/.x/b/.x/c" should not match "**/.x/**"', function()
				assert(not isMatch("a/.x/b/.x/c", "**/.x/**", { bash = true }))
			end)

			it('"a/c/b" should match "a/*/b"', function()
				assert(isMatch("a/c/b", "a/*/b", { bash = true }))
			end)

			it('"a/.d/b" should not match "a/*/b"', function()
				assert(not isMatch("a/.d/b", "a/*/b", { bash = true }))
			end)

			it('"a/./b" should not match "a/*/b"', function()
				assert(not isMatch("a/./b", "a/*/b", { bash = true }))
			end)

			it('"a/../b" should not match "a/*/b"', function()
				assert(not isMatch("a/../b", "a/*/b", { bash = true }))
			end)

			it('"ab" should match "ab**"', function()
				assert(isMatch("ab", "ab**", { bash = true }))
			end)

			it('"abcdef" should match "ab**"', function()
				assert(isMatch("abcdef", "ab**", { bash = true }))
			end)

			it('"abef" should match "ab**"', function()
				assert(isMatch("abef", "ab**", { bash = true }))
			end)

			it('"abcfef" should match "ab**"', function()
				assert(isMatch("abcfef", "ab**", { bash = true }))
			end)

			it('"ab" should not match "ab***ef"', function()
				assert(not isMatch("ab", "ab***ef", { bash = true }))
			end)

			it('"abcdef" should match "ab***ef"', function()
				assert(isMatch("abcdef", "ab***ef", { bash = true }))
			end)

			it('"abef" should match "ab***ef"', function()
				assert(isMatch("abef", "ab***ef", { bash = true }))
			end)

			it('"abcfef" should match "ab***ef"', function()
				assert(isMatch("abcfef", "ab***ef", { bash = true }))
			end)

			itFIXME('".bashrc" should not match "?bashrc"', function()
				assert(not isMatch(".bashrc", "?bashrc", { bash = true }))
			end)

			it('"abbc" should not match "ab?bc"', function()
				assert(not isMatch("abbc", "ab?bc", { bash = true }))
			end)

			it('"abc" should not match "ab?bc"', function()
				assert(not isMatch("abc", "ab?bc", { bash = true }))
			end)

			itFIXME('"a.a" should match "[a-d]*.[a-b]"', function()
				assert(isMatch("a.a", "[a-d]*.[a-b]", { bash = true }))
			end)

			itFIXME('"a.b" should match "[a-d]*.[a-b]"', function()
				assert(isMatch("a.b", "[a-d]*.[a-b]", { bash = true }))
			end)

			itFIXME('"c.a" should match "[a-d]*.[a-b]"', function()
				assert(isMatch("c.a", "[a-d]*.[a-b]", { bash = true }))
			end)

			itFIXME('"a.a.a" should match "[a-d]*.[a-b]"', function()
				assert(isMatch("a.a.a", "[a-d]*.[a-b]", { bash = true }))
			end)

			itFIXME('"a.a.a" should match "[a-d]*.[a-b]*.[a-b]"', function()
				assert(isMatch("a.a.a", "[a-d]*.[a-b]*.[a-b]", { bash = true }))
			end)

			itFIXME('"a.a" should match "*.[a-b]"', function()
				assert(isMatch("a.a", "*.[a-b]", { bash = true }))
			end)

			itFIXME('"a.b" should match "*.[a-b]"', function()
				assert(isMatch("a.b", "*.[a-b]", { bash = true }))
			end)

			itFIXME('"a.a.a" should match "*.[a-b]"', function()
				assert(isMatch("a.a.a", "*.[a-b]", { bash = true }))
			end)

			itFIXME('"c.a" should match "*.[a-b]"', function()
				assert(isMatch("c.a", "*.[a-b]", { bash = true }))
			end)

			it('"d.a.d" should not match "*.[a-b]"', function()
				assert(not isMatch("d.a.d", "*.[a-b]", { bash = true }))
			end)

			it('"a.bb" should not match "*.[a-b]"', function()
				assert(not isMatch("a.bb", "*.[a-b]", { bash = true }))
			end)

			it('"a.ccc" should not match "*.[a-b]"', function()
				assert(not isMatch("a.ccc", "*.[a-b]", { bash = true }))
			end)

			it('"c.ccc" should not match "*.[a-b]"', function()
				assert(not isMatch("c.ccc", "*.[a-b]", { bash = true }))
			end)

			itFIXME('"a.a" should match "*.[a-b]*"', function()
				assert(isMatch("a.a", "*.[a-b]*", { bash = true }))
			end)

			itFIXME('"a.b" should match "*.[a-b]*"', function()
				assert(isMatch("a.b", "*.[a-b]*", { bash = true }))
			end)

			itFIXME('"a.a.a" should match "*.[a-b]*"', function()
				assert(isMatch("a.a.a", "*.[a-b]*", { bash = true }))
			end)

			itFIXME('"c.a" should match "*.[a-b]*"', function()
				assert(isMatch("c.a", "*.[a-b]*", { bash = true }))
			end)

			itFIXME('"d.a.d" should match "*.[a-b]*"', function()
				assert(isMatch("d.a.d", "*.[a-b]*", { bash = true }))
			end)

			it('"d.a.d" should not match "*.[a-b]*.[a-b]*"', function()
				assert(not isMatch("d.a.d", "*.[a-b]*.[a-b]*", { bash = true }))
			end)

			itFIXME('"d.a.d" should match "*.[a-d]*.[a-d]*"', function()
				assert(isMatch("d.a.d", "*.[a-d]*.[a-d]*", { bash = true }))
			end)

			itFIXME('"a.bb" should match "*.[a-b]*"', function()
				assert(isMatch("a.bb", "*.[a-b]*", { bash = true }))
			end)

			it('"a.ccc" should not match "*.[a-b]*"', function()
				assert(not isMatch("a.ccc", "*.[a-b]*", { bash = true }))
			end)

			it('"c.ccc" should not match "*.[a-b]*"', function()
				assert(not isMatch("c.ccc", "*.[a-b]*", { bash = true }))
			end)

			itFIXME('"a.a" should match "*[a-b].[a-b]*"', function()
				assert(isMatch("a.a", "*[a-b].[a-b]*", { bash = true }))
			end)

			itFIXME('"a.b" should match "*[a-b].[a-b]*"', function()
				assert(isMatch("a.b", "*[a-b].[a-b]*", { bash = true }))
			end)

			itFIXME('"a.a.a" should match "*[a-b].[a-b]*"', function()
				assert(isMatch("a.a.a", "*[a-b].[a-b]*", { bash = true }))
			end)

			it('"c.a" should not match "*[a-b].[a-b]*"', function()
				assert(not isMatch("c.a", "*[a-b].[a-b]*", { bash = true }))
			end)

			it('"d.a.d" should not match "*[a-b].[a-b]*"', function()
				assert(not isMatch("d.a.d", "*[a-b].[a-b]*", { bash = true }))
			end)

			itFIXME('"a.bb" should match "*[a-b].[a-b]*"', function()
				assert(isMatch("a.bb", "*[a-b].[a-b]*", { bash = true }))
			end)

			it('"a.ccc" should not match "*[a-b].[a-b]*"', function()
				assert(not isMatch("a.ccc", "*[a-b].[a-b]*", { bash = true }))
			end)

			it('"c.ccc" should not match "*[a-b].[a-b]*"', function()
				assert(not isMatch("c.ccc", "*[a-b].[a-b]*", { bash = true }))
			end)

			itFIXME('"abd" should match "[a-y]*[^c]"', function()
				assert(isMatch("abd", "[a-y]*[^c]", { bash = true }))
			end)

			itFIXME('"abe" should match "[a-y]*[^c]"', function()
				assert(isMatch("abe", "[a-y]*[^c]", { bash = true }))
			end)

			itFIXME('"bb" should match "[a-y]*[^c]"', function()
				assert(isMatch("bb", "[a-y]*[^c]", { bash = true }))
			end)

			itFIXME('"bcd" should match "[a-y]*[^c]"', function()
				assert(isMatch("bcd", "[a-y]*[^c]", { bash = true }))
			end)

			itFIXME('"ca" should match "[a-y]*[^c]"', function()
				assert(isMatch("ca", "[a-y]*[^c]", { bash = true }))
			end)

			itFIXME('"cb" should match "[a-y]*[^c]"', function()
				assert(isMatch("cb", "[a-y]*[^c]", { bash = true }))
			end)

			itFIXME('"dd" should match "[a-y]*[^c]"', function()
				assert(isMatch("dd", "[a-y]*[^c]", { bash = true }))
			end)

			itFIXME('"de" should match "[a-y]*[^c]"', function()
				assert(isMatch("de", "[a-y]*[^c]", { bash = true }))
			end)

			itFIXME('"bdir/" should match "[a-y]*[^c]"', function()
				assert(isMatch("bdir/", "[a-y]*[^c]", { bash = true }))
			end)

			it('"abd" should match "**/*"', function()
				assert(isMatch("abd", "**/*", { bash = true }))
			end)
		end)

		describe("globstar", function()
			it('"a.js" should match "**/*.js"', function()
				assert(isMatch("a.js", "**/*.js", { bash = true }))
			end)

			it('"a/a.js" should match "**/*.js"', function()
				assert(isMatch("a/a.js", "**/*.js", { bash = true }))
			end)

			it('"a/a/b.js" should match "**/*.js"', function()
				assert(isMatch("a/a/b.js", "**/*.js", { bash = true }))
			end)

			it('"a/b/z.js" should match "a/b/**/*.js"', function()
				assert(isMatch("a/b/z.js", "a/b/**/*.js", { bash = true }))
			end)

			it('"a/b/c/z.js" should match "a/b/**/*.js"', function()
				assert(isMatch("a/b/c/z.js", "a/b/**/*.js", { bash = true }))
			end)

			it('"foo.md" should match "**/*.md"', function()
				assert(isMatch("foo.md", "**/*.md", { bash = true }))
			end)

			it('"foo/bar.md" should match "**/*.md"', function()
				assert(isMatch("foo/bar.md", "**/*.md", { bash = true }))
			end)

			it('"foo/bar" should match "foo/**/bar"', function()
				assert(isMatch("foo/bar", "foo/**/bar", { bash = true }))
			end)

			it('"foo/bar" should match "foo/**bar"', function()
				assert(isMatch("foo/bar", "foo/**bar", { bash = true }))
			end)

			it('"ab/a/d" should match "**/*"', function()
				assert(isMatch("ab/a/d", "**/*", { bash = true }))
			end)

			it('"ab/b" should match "**/*"', function()
				assert(isMatch("ab/b", "**/*", { bash = true }))
			end)

			it('"a/b/c/d/a.js" should match "**/*"', function()
				assert(isMatch("a/b/c/d/a.js", "**/*", { bash = true }))
			end)

			it('"a/b/c.js" should match "**/*"', function()
				assert(isMatch("a/b/c.js", "**/*", { bash = true }))
			end)

			it('"a/b/c.txt" should match "**/*"', function()
				assert(isMatch("a/b/c.txt", "**/*", { bash = true }))
			end)

			it('"a/b/.js/c.txt" should match "**/*"', function()
				assert(isMatch("a/b/.js/c.txt", "**/*", { bash = true }))
			end)

			it('"a.js" should match "**/*"', function()
				assert(isMatch("a.js", "**/*", { bash = true }))
			end)

			it('"za.js" should match "**/*"', function()
				assert(isMatch("za.js", "**/*", { bash = true }))
			end)

			it('"ab" should match "**/*"', function()
				assert(isMatch("ab", "**/*", { bash = true }))
			end)

			it('"a.b" should match "**/*"', function()
				assert(isMatch("a.b", "**/*", { bash = true }))
			end)

			it('"foo/" should match "foo/**/"', function()
				assert(isMatch("foo/", "foo/**/", { bash = true }))
			end)

			it('"foo/bar" should not match "foo/**/"', function()
				assert(not isMatch("foo/bar", "foo/**/", { bash = true }))
			end)

			it('"foo/bazbar" should not match "foo/**/"', function()
				assert(not isMatch("foo/bazbar", "foo/**/", { bash = true }))
			end)

			it('"foo/barbar" should not match "foo/**/"', function()
				assert(not isMatch("foo/barbar", "foo/**/", { bash = true }))
			end)

			it('"foo/bar/baz/qux" should not match "foo/**/"', function()
				assert(not isMatch("foo/bar/baz/qux", "foo/**/", { bash = true }))
			end)

			it('"foo/bar/baz/qux/" should match "foo/**/"', function()
				assert(isMatch("foo/bar/baz/qux/", "foo/**/", { bash = true }))
			end)
		end)
	end)
end
