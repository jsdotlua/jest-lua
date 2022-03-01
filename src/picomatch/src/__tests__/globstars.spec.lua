-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/globstars.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent
	local Packages = PicomatchModule.Parent

	local jestExpect = require(Packages.Dev.Expect)

	local match = require(CurrentModule.support.match)
	local isMatch = require(PicomatchModule).isMatch
	describe("stars", function()
		describe("issue related", function()
			it("should match paths with no slashes (micromatch/#15)", function()
				assert(isMatch("a.js", "**/*.js"))
				assert(isMatch("a.js", "**/a*"))
				assert(isMatch("a.js", "**/a*.js"))
				assert(isMatch("abc", "**/abc"))
			end)

			itFIXME("should regard non-exclusive double-stars as single stars", function()
				local fixtures = {
					"a",
					"a/",
					"a/a",
					"a/a/",
					"a/a/a",
					"a/a/a/",
					"a/a/a/a",
					"a/a/a/a/",
					"a/a/a/a/a",
					"a/a/a/a/a/",
					"a/a/b",
					"a/a/b/",
					"a/b",
					"a/b/",
					"a/b/c/.d/e/",
					"a/c",
					"a/c/",
					"a/b",
					"a/x/",
					"b",
					"b/",
					"x/y",
					"x/y/",
					"z/z",
					"z/z/",
				}
				jestExpect(match(fixtures, "**a/a/*/")).toEqual({ "a/a/a/", "a/a/b/" })
				assert(not isMatch("aaa/bba/ccc", "aaa/**ccc"))
				assert(not isMatch("aaa/bba/ccc", "aaa/**z"))
				assert(isMatch("aaa/bba/ccc", "aaa/**b**/ccc"))
				assert(not isMatch("a/b/c", "**c"))
				assert(not isMatch("a/b/c", "a/**c"))
				assert(not isMatch("a/b/c", "a/**z"))
				assert(not isMatch("a/b/c/b/c", "a/**b**/c"))
				assert(not isMatch("a/b/c/d/e.js", "a/b/c**/*.js"))
				assert(isMatch("a/b/c/b/c", "a/**/b/**/c"))
				assert(isMatch("a/aba/c", "a/**b**/c"))
				assert(isMatch("a/b/c", "a/**b**/c"))
				assert(isMatch("a/b/c/d.js", "a/b/c**/*.js"))
			end)

			it("should support globstars followed by braces", function()
				assert(isMatch("a/b/c/d/e/z/foo.md", "a/**/c/**{,(/z|/x)}/*.md"))
				assert(isMatch("a/b/c/d/e/z/foo.md", "a/**{,(/x|/z)}/*.md"))
			end)

			it("should support globstars followed by braces with nested extglobs", function()
				assert(isMatch("/x/foo.md", "@(/x|/z)/*.md"))
				assert(isMatch("/z/foo.md", "@(/x|/z)/*.md"))
				assert(isMatch("a/b/c/d/e/z/foo.md", "a/**/c/**@(/z|/x)/*.md"))
				assert(isMatch("a/b/c/d/e/z/foo.md", "a/**@(/x|/z)/*.md"))
			end)

			it("should support multiple globstars in one pattern", function()
				assert(not isMatch("a/b/c/d/e/z/foo.md", "a/**/j/**/z/*.md"))
				assert(not isMatch("a/b/c/j/e/z/foo.txt", "a/**/j/**/z/*.md"))
				assert(isMatch("a/b/c/d/e/j/n/p/o/z/foo.md", "a/**/j/**/z/*.md"))
				assert(isMatch("a/b/c/d/e/z/foo.md", "a/**/z/*.md"))
				assert(isMatch("a/b/c/j/e/z/foo.md", "a/**/j/**/z/*.md"))
			end)

			itFIXME("should match file extensions:", function()
				jestExpect(match({ ".md", "a.md", "a/b/c.md", ".txt" }, "**/*.md")).toEqual({ "a.md", "a/b/c.md" })
				jestExpect(match({ ".md/.md", ".md", "a/.md", "a/b/.md" }, "**/.md")).toEqual({
					".md",
					"a/.md",
					"a/b/.md",
				})
				jestExpect(match({ ".md/.md", ".md/foo/.md", ".md", "a/.md", "a/b/.md" }, ".md/**/.md")).toEqual({
					".md/.md",
					".md/foo/.md",
				})
			end)

			itFIXME("should respect trailing slashes on paterns", function()
				local fixtures = {
					"a",
					"a/",
					"a/a",
					"a/a/",
					"a/a/a",
					"a/a/a/",
					"a/a/a/a",
					"a/a/a/a/",
					"a/a/a/a/a",
					"a/a/a/a/a/",
					"a/a/b",
					"a/a/b/",
					"a/b",
					"a/b/",
					"a/b/c/.d/e/",
					"a/c",
					"a/c/",
					"a/b",
					"a/x/",
					"b",
					"b/",
					"x/y",
					"x/y/",
					"z/z",
					"z/z/",
				}
				jestExpect(match(fixtures, "**/*/a/")).toEqual({ "a/a/", "a/a/a/", "a/a/a/a/", "a/a/a/a/a/" })
				jestExpect(match(fixtures, "**/*/a/*/")).toEqual({ "a/a/a/", "a/a/a/a/", "a/a/a/a/a/", "a/a/b/" })
				jestExpect(match(fixtures, "**/*/x/")).toEqual({ "a/x/" })
				jestExpect(match(fixtures, "**/*/*/*/*/")).toEqual({ "a/a/a/a/", "a/a/a/a/a/" })
				jestExpect(match(fixtures, "**/*/*/*/*/*/")).toEqual({ "a/a/a/a/a/" })
				jestExpect(match(fixtures, "*a/a/*/")).toEqual({ "a/a/a/", "a/a/b/" })
				jestExpect(match(fixtures, "**a/a/*/")).toEqual({ "a/a/a/", "a/a/b/" })
				jestExpect(match(fixtures, "**/a/*/*/")).toEqual({ "a/a/a/", "a/a/a/a/", "a/a/a/a/a/", "a/a/b/" })
				jestExpect(match(fixtures, "**/a/*/*/*/")).toEqual({ "a/a/a/a/", "a/a/a/a/a/" })
				jestExpect(match(fixtures, "**/a/*/*/*/*/")).toEqual({ "a/a/a/a/a/" })
				jestExpect(match(fixtures, "**/a/*/a/")).toEqual({ "a/a/a/", "a/a/a/a/", "a/a/a/a/a/" })
				jestExpect(match(fixtures, "**/a/*/b/")).toEqual({ "a/a/b/" })
			end)

			itFIXME("should match literal globstars when stars are escaped", function()
				local fixtures = { ".md", "**a.md", "**.md", ".md", "**" }
				jestExpect(match(fixtures, "\\*\\**.md")).toEqual({ "**a.md", "**.md" })
				jestExpect(match(fixtures, "\\*\\*.md")).toEqual({ "**.md" })
			end)

			it("single dots", function()
				assert(not isMatch(".a/a", "**"))
				assert(not isMatch("a/.a", "**"))
				assert(not isMatch(".a/a", "**/"))
				assert(not isMatch("a/.a", "**/"))
				assert(not isMatch(".a/a", "**/**"))
				assert(not isMatch("a/.a", "**/**"))
				assert(not isMatch(".a/a", "**/**/*"))
				assert(not isMatch("a/.a", "**/**/*"))
				assert(not isMatch(".a/a", "**/**/x"))
				assert(not isMatch("a/.a", "**/**/x"))
				assert(not isMatch(".a/a", "**/x"))
				assert(not isMatch("a/.a", "**/x"))
				assert(not isMatch(".a/a", "**/x/*"))
				assert(not isMatch("a/.a", "**/x/*"))
				assert(not isMatch(".a/a", "**/x/**"))
				assert(not isMatch("a/.a", "**/x/**"))
				assert(not isMatch(".a/a", "**/x/*/*"))
				assert(not isMatch("a/.a", "**/x/*/*"))
				assert(not isMatch(".a/a", "*/x/**"))
				assert(not isMatch("a/.a", "*/x/**"))
				assert(not isMatch(".a/a", "a/**"))
				assert(not isMatch("a/.a", "a/**"))
				assert(not isMatch(".a/a", "a/**/*"))
				assert(not isMatch("a/.a", "a/**/*"))
				assert(not isMatch(".a/a", "a/**/**/*"))
				assert(not isMatch("a/.a", "a/**/**/*"))
				assert(not isMatch(".a/a", "b/**"))
				assert(not isMatch("a/.a", "b/**"))
			end)

			it("double dots", function()
				assert(not isMatch("a/../a", "**"))
				assert(not isMatch("ab/../ac", "**"))
				assert(not isMatch("../a", "**"))
				assert(not isMatch("../../b", "**"))
				assert(not isMatch("../c", "**"))
				assert(not isMatch("../c/d", "**"))
				assert(not isMatch("a/../a", "**/"))
				assert(not isMatch("ab/../ac", "**/"))
				assert(not isMatch("../a", "**/"))
				assert(not isMatch("../../b", "**/"))
				assert(not isMatch("../c", "**/"))
				assert(not isMatch("../c/d", "**/"))
				assert(not isMatch("a/../a", "**/**"))
				assert(not isMatch("ab/../ac", "**/**"))
				assert(not isMatch("../a", "**/**"))
				assert(not isMatch("../../b", "**/**"))
				assert(not isMatch("../c", "**/**"))
				assert(not isMatch("../c/d", "**/**"))
				assert(not isMatch("a/../a", "**/**/*"))
				assert(not isMatch("ab/../ac", "**/**/*"))
				assert(not isMatch("../a", "**/**/*"))
				assert(not isMatch("../../b", "**/**/*"))
				assert(not isMatch("../c", "**/**/*"))
				assert(not isMatch("../c/d", "**/**/*"))
				assert(not isMatch("a/../a", "**/**/x"))
				assert(not isMatch("ab/../ac", "**/**/x"))
				assert(not isMatch("../a", "**/**/x"))
				assert(not isMatch("../../b", "**/**/x"))
				assert(not isMatch("../c", "**/**/x"))
				assert(not isMatch("../c/d", "**/**/x"))
				assert(not isMatch("a/../a", "**/x"))
				assert(not isMatch("ab/../ac", "**/x"))
				assert(not isMatch("../a", "**/x"))
				assert(not isMatch("../../b", "**/x"))
				assert(not isMatch("../c", "**/x"))
				assert(not isMatch("../c/d", "**/x"))
				assert(not isMatch("a/../a", "**/x/*"))
				assert(not isMatch("ab/../ac", "**/x/*"))
				assert(not isMatch("../a", "**/x/*"))
				assert(not isMatch("../../b", "**/x/*"))
				assert(not isMatch("../c", "**/x/*"))
				assert(not isMatch("../c/d", "**/x/*"))
				assert(not isMatch("a/../a", "**/x/**"))
				assert(not isMatch("ab/../ac", "**/x/**"))
				assert(not isMatch("../a", "**/x/**"))
				assert(not isMatch("../../b", "**/x/**"))
				assert(not isMatch("../c", "**/x/**"))
				assert(not isMatch("../c/d", "**/x/**"))
				assert(not isMatch("a/../a", "**/x/*/*"))
				assert(not isMatch("ab/../ac", "**/x/*/*"))
				assert(not isMatch("../a", "**/x/*/*"))
				assert(not isMatch("../../b", "**/x/*/*"))
				assert(not isMatch("../c", "**/x/*/*"))
				assert(not isMatch("../c/d", "**/x/*/*"))
				assert(not isMatch("a/../a", "*/x/**"))
				assert(not isMatch("ab/../ac", "*/x/**"))
				assert(not isMatch("../a", "*/x/**"))
				assert(not isMatch("../../b", "*/x/**"))
				assert(not isMatch("../c", "*/x/**"))
				assert(not isMatch("../c/d", "*/x/**"))
				assert(not isMatch("a/../a", "a/**"))
				assert(not isMatch("ab/../ac", "a/**"))
				assert(not isMatch("../a", "a/**"))
				assert(not isMatch("../../b", "a/**"))
				assert(not isMatch("../c", "a/**"))
				assert(not isMatch("../c/d", "a/**"))
				assert(not isMatch("a/../a", "a/**/*"))
				assert(not isMatch("ab/../ac", "a/**/*"))
				assert(not isMatch("../a", "a/**/*"))
				assert(not isMatch("../../b", "a/**/*"))
				assert(not isMatch("../c", "a/**/*"))
				assert(not isMatch("../c/d", "a/**/*"))
				assert(not isMatch("a/../a", "a/**/**/*"))
				assert(not isMatch("ab/../ac", "a/**/**/*"))
				assert(not isMatch("../a", "a/**/**/*"))
				assert(not isMatch("../../b", "a/**/**/*"))
				assert(not isMatch("../c", "a/**/**/*"))
				assert(not isMatch("../c/d", "a/**/**/*"))
				assert(not isMatch("a/../a", "b/**"))
				assert(not isMatch("ab/../ac", "b/**"))
				assert(not isMatch("../a", "b/**"))
				assert(not isMatch("../../b", "b/**"))
				assert(not isMatch("../c", "b/**"))
				assert(not isMatch("../c/d", "b/**"))
			end)

			it("should match", function()
				assert(not isMatch("a", "**/"))
				assert(not isMatch("a", "**/a/*"))
				assert(not isMatch("a", "**/a/*/*"))
				assert(not isMatch("a", "*/a/**"))
				assert(not isMatch("a", "a/**/*"))
				assert(not isMatch("a", "a/**/**/*"))
				assert(not isMatch("a/b", "**/"))
				assert(not isMatch("a/b", "**/b/*"))
				assert(not isMatch("a/b", "**/b/*/*"))
				assert(not isMatch("a/b", "b/**"))
				assert(not isMatch("a/b/c", "**/"))
				assert(not isMatch("a/b/c", "**/**/b"))
				assert(not isMatch("a/b/c", "**/b"))
				assert(not isMatch("a/b/c", "**/b/*/*"))
				assert(not isMatch("a/b/c", "b/**"))
				assert(not isMatch("a/b/c/d", "**/"))
				assert(not isMatch("a/b/c/d", "**/d/*"))
				assert(not isMatch("a/b/c/d", "b/**"))
				assert(isMatch("a", "**"))
				assert(isMatch("a", "**/**"))
				assert(isMatch("a", "**/**/*"))
				assert(isMatch("a", "**/**/a"))
				assert(isMatch("a", "**/a"))
				assert(isMatch("a", "**/a/**"))
				assert(isMatch("a", "a/**"))
				assert(isMatch("a/b", "**"))
				assert(isMatch("a/b", "**/**"))
				assert(isMatch("a/b", "**/**/*"))
				assert(isMatch("a/b", "**/**/b"))
				assert(isMatch("a/b", "**/b"))
				assert(isMatch("a/b", "**/b/**"))
				assert(isMatch("a/b", "*/b/**"))
				assert(isMatch("a/b", "a/**"))
				assert(isMatch("a/b", "a/**/*"))
				assert(isMatch("a/b", "a/**/**/*"))
				assert(isMatch("a/b/c", "**"))
				assert(isMatch("a/b/c", "**/**"))
				assert(isMatch("a/b/c", "**/**/*"))
				assert(isMatch("a/b/c", "**/b/*"))
				assert(isMatch("a/b/c", "**/b/**"))
				assert(isMatch("a/b/c", "*/b/**"))
				assert(isMatch("a/b/c", "a/**"))
				assert(isMatch("a/b/c", "a/**/*"))
				assert(isMatch("a/b/c", "a/**/**/*"))
				assert(isMatch("a/b/c/d", "**"))
				assert(isMatch("a/b/c/d", "**/**"))
				assert(isMatch("a/b/c/d", "**/**/*"))
				assert(isMatch("a/b/c/d", "**/**/d"))
				assert(isMatch("a/b/c/d", "**/b/**"))
				assert(isMatch("a/b/c/d", "**/b/*/*"))
				assert(isMatch("a/b/c/d", "**/d"))
				assert(isMatch("a/b/c/d", "*/b/**"))
				assert(isMatch("a/b/c/d", "a/**"))
				assert(isMatch("a/b/c/d", "a/**/*"))
				assert(isMatch("a/b/c/d", "a/**/**/*"))
			end)

			it("should match nested directories", function()
				assert(isMatch("a/b", "*/*"))
				assert(isMatch("a/b/c/xyz.md", "a/b/c/*.md"))
				assert(isMatch("a/bb.bb/c/xyz.md", "a/*/c/*.md"))
				assert(isMatch("a/bb/c/xyz.md", "a/*/c/*.md"))
				assert(isMatch("a/bbbb/c/xyz.md", "a/*/c/*.md"))
				assert(isMatch("a/b/c", "**/*"))
				assert(isMatch("a/b/c", "**/**"))
				assert(isMatch("a/b/c", "*/**"))
				assert(isMatch("a/b/c/d/e/j/n/p/o/z/c.md", "a/**/j/**/z/*.md"))
				assert(isMatch("a/b/c/d/e/z/c.md", "a/**/z/*.md"))
				assert(isMatch("a/bb.bb/aa/b.b/aa/c/xyz.md", "a/**/c/*.md"))
				assert(isMatch("a/bb.bb/aa/bb/aa/c/xyz.md", "a/**/c/*.md"))
				assert(not isMatch("a/b/c/j/e/z/c.txt", "a/**/j/**/z/*.md"))
				assert(not isMatch("a/b/c/xyz.md", "a/b/**/c{d,e}/**/xyz.md"))
				assert(not isMatch("a/b/d/xyz.md", "a/b/**/c{d,e}/**/xyz.md"))
				assert(not isMatch("a/b", "a/**/"))
				assert(not isMatch("a/b/.js/c.txt", "**/*"))
				assert(not isMatch("a/b/c/d", "a/**/"))
				assert(not isMatch("a/bb", "a/**/"))
				assert(not isMatch("a/cb", "a/**/"))
				assert(isMatch("/a/b", "/**"))
				assert(isMatch("a.b", "**/*"))
				assert(isMatch("a.js", "**/*"))
				assert(isMatch("a.js", "**/*.js"))
				assert(isMatch("a/", "a/**/"))
				assert(isMatch("a/a.js", "**/*.js"))
				assert(isMatch("a/a/b.js", "**/*.js"))
				assert(isMatch("a/b", "a/**/b"))
				assert(isMatch("a/b", "a/**b"))
				assert(isMatch("a/b.md", "**/*.md"))
				assert(isMatch("a/b/c.js", "**/*"))
				assert(isMatch("a/b/c.txt", "**/*"))
				assert(isMatch("a/b/c/d/", "a/**/"))
				assert(isMatch("a/b/c/d/a.js", "**/*"))
				assert(isMatch("a/b/c/z.js", "a/b/**/*.js"))
				assert(isMatch("a/b/z.js", "a/b/**/*.js"))
				assert(isMatch("ab", "**/*"))
				assert(isMatch("ab/c", "**/*"))
				assert(isMatch("ab/c/d", "**/*"))
				assert(isMatch("abc.js", "**/*"))
			end)

			it("should not match dotfiles by default", function()
				assert(not isMatch("a/.b", "a/**/z/*.md"))
				assert(not isMatch("a/b/z/.a", "a/**/z/*.a"))
				assert(not isMatch("a/b/z/.a", "a/*/z/*.a"))
				assert(not isMatch("a/b/z/.a", "b/a"))
				assert(not isMatch("a/foo/z/.b", "a/**/z/*.md"))
			end)

			itFIXME("should match leading dots when defined in pattern", function()
				local fixtures = {
					".gitignore",
					"a/b/z/.dotfile",
					"a/b/z/.dotfile.md",
					"a/b/z/.dotfile.md",
					"a/b/z/.dotfile.md",
				}
				assert(not isMatch(".gitignore", "a/**/z/*.md"))
				assert(not isMatch("a/b/z/.dotfile", "a/**/z/*.md"))
				assert(not isMatch("a/b/z/.dotfile.md", "**/c/.*.md"))
				assert(isMatch("a/.b", "a/.*"))
				assert(isMatch("a/b/z/.a", "a/*/z/.a"))
				assert(isMatch("a/b/z/.dotfile.md", "**/.*.md"))
				assert(isMatch("a/b/z/.dotfile.md", "a/**/z/.*.md"))
				jestExpect(match({ ".md", "a.md", "a/b/c.md", ".txt" }, "**/*.md")).toEqual({ "a.md", "a/b/c.md" })
				jestExpect(match({ ".md/.md", ".md", "a/.md", "a/b/.md" }, "**/.md")).toEqual({
					".md",
					"a/.md",
					"a/b/.md",
				})
				jestExpect(match({ ".md/.md", ".md/foo/.md", ".md", "a/.md", "a/b/.md" }, ".md/**/.md")).toEqual({
					".md/.md",
					".md/foo/.md",
				})
				jestExpect(match(fixtures, "a/**/z/.*.md")).toEqual({ "a/b/z/.dotfile.md" })
			end)

			it("todo... (micromatch/#24)", function()
				assert(isMatch("foo/bar/baz/one/image.png", "foo/bar/**/one/**/*.*"))
				assert(isMatch("foo/bar/baz/one/two/image.png", "foo/bar/**/one/**/*.*"))
				assert(isMatch("foo/bar/baz/one/two/three/image.png", "foo/bar/**/one/**/*.*"))
				assert(not isMatch("a/b/c/d/", "a/b/**/f"))
				assert(isMatch("a", "a/**"))
				assert(isMatch("a", "**"))
				assert(isMatch("a", "a{,/**}"))
				assert(isMatch("a/", "**"))
				assert(isMatch("a/", "a/**"))
				assert(isMatch("a/b/c/d", "**"))
				assert(isMatch("a/b/c/d/", "**"))
				assert(isMatch("a/b/c/d/", "**/**"))
				assert(isMatch("a/b/c/d/", "**/b/**"))
				assert(isMatch("a/b/c/d/", "a/b/**"))
				assert(isMatch("a/b/c/d/", "a/b/**/"))
				assert(isMatch("a/b/c/d/", "a/b/**/c/**/"))
				assert(isMatch("a/b/c/d/", "a/b/**/c/**/d/"))
				assert(isMatch("a/b/c/d/e.f", "a/b/**/**/*.*"))
				assert(isMatch("a/b/c/d/e.f", "a/b/**/*.*"))
				assert(isMatch("a/b/c/d/e.f", "a/b/**/c/**/d/*.*"))
				assert(isMatch("a/b/c/d/e.f", "a/b/**/d/**/*.*"))
				assert(isMatch("a/b/c/d/g/e.f", "a/b/**/d/**/*.*"))
				assert(isMatch("a/b/c/d/g/g/e.f", "a/b/**/d/**/*.*"))
				assert(isMatch("a/b-c/z.js", "a/b-*/**/z.js"))
				assert(isMatch("a/b-c/d/e/z.js", "a/b-*/**/z.js"))
			end)
		end)

		describe("globstars", function()
			it("should match globstars", function()
				assert(isMatch("a/b/c/d.js", "**/*.js"))
				assert(isMatch("a/b/c.js", "**/*.js"))
				assert(isMatch("a/b.js", "**/*.js"))
				assert(isMatch("a/b/c/d/e/f.js", "a/b/**/*.js"))
				assert(isMatch("a/b/c/d/e.js", "a/b/**/*.js"))
				assert(isMatch("a/b/c/d.js", "a/b/c/**/*.js"))
				assert(isMatch("a/b/c/d.js", "a/b/**/*.js"))
				assert(isMatch("a/b/d.js", "a/b/**/*.js"))
				assert(not isMatch("a/d.js", "a/b/**/*.js"))
				assert(not isMatch("d.js", "a/b/**/*.js"))
			end)

			itFIXME("should regard non-exclusive double-stars as single stars", function()
				assert(not isMatch("a/b/c", "**c"))
				assert(not isMatch("a/b/c", "a/**c"))
				assert(not isMatch("a/b/c", "a/**z"))
				assert(not isMatch("a/b/c/b/c", "a/**b**/c"))
				assert(not isMatch("a/b/c/d/e.js", "a/b/c**/*.js"))
				assert(isMatch("a/b/c/b/c", "a/**/b/**/c"))
				assert(isMatch("a/aba/c", "a/**b**/c"))
				assert(isMatch("a/b/c", "a/**b**/c"))
				assert(isMatch("a/b/c/d.js", "a/b/c**/*.js"))
			end)

			it("should support globstars (**)", function()
				assert(not isMatch("a", "a/**/*"))
				assert(not isMatch("a", "a/**/**/*"))
				assert(not isMatch("a", "a/**/**/**/*"))
				assert(not isMatch("a/", "**/a"))
				assert(not isMatch("a/", "a/**/*"))
				assert(not isMatch("a/", "a/**/**/*"))
				assert(not isMatch("a/", "a/**/**/**/*"))
				assert(not isMatch("a/b", "**/a"))
				assert(not isMatch("a/b/c/j/e/z/c.txt", "a/**/j/**/z/*.md"))
				assert(not isMatch("a/bb", "a/**/b"))
				assert(not isMatch("a/c", "**/a"))
				assert(not isMatch("a/b", "**/a"))
				assert(not isMatch("a/x/y", "**/a"))
				assert(not isMatch("a/b/c/d", "**/a"))
				assert(isMatch("a", "**"))
				assert(isMatch("a", "**/a"))
				assert(isMatch("a", "a/**"))
				assert(isMatch("a/", "**"))
				assert(isMatch("a/", "**/a/**"))
				assert(isMatch("a/", "a/**"))
				assert(isMatch("a/", "a/**/**"))
				assert(isMatch("a/a", "**/a"))
				assert(isMatch("a/b", "**"))
				assert(isMatch("a/b", "*/*"))
				assert(isMatch("a/b", "a/**"))
				assert(isMatch("a/b", "a/**/*"))
				assert(isMatch("a/b", "a/**/**/*"))
				assert(isMatch("a/b", "a/**/**/**/*"))
				assert(isMatch("a/b", "a/**/b"))
				assert(isMatch("a/b/c", "**"))
				assert(isMatch("a/b/c", "**/*"))
				assert(isMatch("a/b/c", "**/**"))
				assert(isMatch("a/b/c", "*/**"))
				assert(isMatch("a/b/c", "a/**"))
				assert(isMatch("a/b/c", "a/**/*"))
				assert(isMatch("a/b/c", "a/**/**/*"))
				assert(isMatch("a/b/c", "a/**/**/**/*"))
				assert(isMatch("a/b/c/d", "**"))
				assert(isMatch("a/b/c/d", "a/**"))
				assert(isMatch("a/b/c/d", "a/**/*"))
				assert(isMatch("a/b/c/d", "a/**/**/*"))
				assert(isMatch("a/b/c/d", "a/**/**/**/*"))
				assert(isMatch("a/b/c/d.e", "a/b/**/c/**/*.*"))
				assert(isMatch("a/b/c/d/e/f/g.md", "a/**/f/*.md"))
				assert(isMatch("a/b/c/d/e/f/g/h/i/j/k/l.md", "a/**/f/**/k/*.md"))
				assert(isMatch("a/b/c/def.md", "a/b/c/*.md"))
				assert(isMatch("a/bb.bb/c/ddd.md", "a/*/c/*.md"))
				assert(isMatch("a/bb.bb/cc/d.d/ee/f/ggg.md", "a/**/f/*.md"))
				assert(isMatch("a/bb.bb/cc/dd/ee/f/ggg.md", "a/**/f/*.md"))
				assert(isMatch("a/bb/c/ddd.md", "a/*/c/*.md"))
				assert(isMatch("a/bbbb/c/ddd.md", "a/*/c/*.md"))
			end)
		end)
	end)
end
