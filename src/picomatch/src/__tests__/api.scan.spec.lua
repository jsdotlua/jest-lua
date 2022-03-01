-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/api.scan.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent
	local Packages = PicomatchModule.Parent
	local scan = require(PicomatchModule.scan)

	local jestExpect = require(Packages.Dev.Expect)

	local function base(...: any)
		return scan(...).base
	end
	local function both(...: any)
		local ref = scan(...)
		local base, glob = ref.base, ref.glob
		return { base, glob }
	end
	--[[*
	 * @param {String} pattern
	 * @param {String[]} parts
	 ]]
	local function assertParts(pattern, parts)
		local info = scan(pattern, { parts = true })
		jestExpect(info.parts):toEqual(parts)
	end
	--[[*
	 * Most of the unit tests in this file were from https://github.com/es128/glob-parent
	 * and https://github.com/jonschlinkert/glob-base. Both libraries use a completely
	 * different approach to separating the glob pattern from the "path" from picomatch,
	 * and both libraries use path.dirname. Picomatch does not.
	 ]]
	describe("picomatch", function()
		describe(".scan", function()
			it('should get the "base" and "glob" from a pattern', function()
				jestExpect(both("foo/bar")).toEqual({ "foo/bar", "" })
				jestExpect(both("foo/@bar")).toEqual({ "foo/@bar", "" })
				jestExpect(both("foo/@bar\\+")).toEqual({ "foo/@bar\\+", "" })
				jestExpect(both("foo/bar+")).toEqual({ "foo/bar+", "" })
				jestExpect(both("foo/bar*")).toEqual({ "foo", "bar*" })
			end)

			itFIXME('should handle leading "./"', function()
				jestExpect(scan("./foo/bar/*.js")).toEqual({
					input = "./foo/bar/*.js",
					prefix = "./",
					start = 3,
					base = "foo/bar",
					glob = "*.js",
					isBrace = false,
					isBracket = false,
					isGlob = true,
					isGlobstar = false,
					isExtglob = false,
					negated = false,
					negatedExtglob = false,
				})
			end)

			it("should detect braces", function()
				jestExpect(scan("foo/{a,b,c}/*.js", { scanToEnd = true })).toEqual({
					input = "foo/{a,b,c}/*.js",
					prefix = "",
					start = 1,
					base = "foo",
					glob = "{a,b,c}/*.js",
					isBrace = true,
					isBracket = false,
					isGlob = true,
					isGlobstar = false,
					isExtglob = false,
					negated = false,
					negatedExtglob = false,
				})
			end)

			itFIXME("should detect globstars", function()
				jestExpect(scan("./foo/**/*.js", { scanToEnd = true })).toEqual({
					input = "./foo/**/*.js",
					prefix = "./",
					start = 3,
					base = "foo",
					glob = "**/*.js",
					isBrace = false,
					isBracket = false,
					isGlob = true,
					isGlobstar = true,
					isExtglob = false,
					negated = false,
					negatedExtglob = false,
				})
			end)

			itFIXME("should detect extglobs", function()
				jestExpect(scan("./foo/@(foo)/*.js")).toEqual({
					input = "./foo/@(foo)/*.js",
					prefix = "./",
					start = 3,
					base = "foo",
					glob = "@(foo)/*.js",
					isBrace = false,
					isBracket = false,
					isGlob = true,
					isGlobstar = false,
					isExtglob = true,
					negated = false,
					negatedExtglob = false,
				})
			end)

			itFIXME("should detect extglobs and globstars", function()
				jestExpect(scan("./foo/@(bar)/**/*.js", { parts = true })).toEqual({
					input = "./foo/@(bar)/**/*.js",
					prefix = "./",
					start = 3,
					base = "foo",
					glob = "@(bar)/**/*.js",
					isBrace = false,
					isBracket = false,
					isGlob = true,
					isGlobstar = true,
					isExtglob = true,
					negated = false,
					negatedExtglob = false,
					slashes = { 1, 5, 12, 15 },
					parts = { "foo", "@(bar)", "**", "*.js" },
				})
			end)

			itFIXME('should handle leading "!"', function()
				jestExpect(scan("!foo/bar/*.js")).toEqual({
					input = "!foo/bar/*.js",
					prefix = "!",
					start = 2,
					base = "foo/bar",
					glob = "*.js",
					isBrace = false,
					isBracket = false,
					isGlob = true,
					isGlobstar = false,
					isExtglob = false,
					negated = true,
					negatedExtglob = false,
				})
			end)

			it("should detect negated extglobs at the begining", function()
				jestExpect(scan("!(foo)*")).toEqual({
					input = "!(foo)*",
					prefix = "",
					start = 1,
					base = "",
					glob = "!(foo)*",
					isBrace = false,
					isBracket = false,
					isGlob = true,
					isGlobstar = false,
					isExtglob = true,
					negated = false,
					negatedExtglob = true,
				})
				jestExpect(scan("!(foo)")).toEqual({
					input = "!(foo)",
					prefix = "",
					start = 1,
					base = "",
					glob = "!(foo)",
					isBrace = false,
					isBracket = false,
					isGlob = true,
					isGlobstar = false,
					isExtglob = true,
					negated = false,
					negatedExtglob = true,
				})
			end)

			it("should not detect negated extglobs in the middle", function()
				jestExpect(scan("test/!(foo)/*")).toEqual({
					input = "test/!(foo)/*",
					prefix = "",
					start = 1,
					base = "test",
					glob = "!(foo)/*",
					isBrace = false,
					isBracket = false,
					isGlob = true,
					isGlobstar = false,
					isExtglob = true,
					negated = false,
					negatedExtglob = false,
				})
			end)

			itFIXME('should handle leading "./" when negated', function()
				jestExpect(scan("./!foo/bar/*.js")).toEqual({
					input = "./!foo/bar/*.js",
					prefix = "./!",
					start = 4,
					base = "foo/bar",
					glob = "*.js",
					isBrace = false,
					isBracket = false,
					isGlob = true,
					isGlobstar = false,
					isExtglob = false,
					negated = true,
					negatedExtglob = false,
				})
				jestExpect(scan("!./foo/bar/*.js")).toEqual({
					input = "!./foo/bar/*.js",
					prefix = "!./",
					start = 4,
					base = "foo/bar",
					glob = "*.js",
					isBrace = false,
					isBracket = false,
					isGlob = true,
					isGlobstar = false,
					isExtglob = false,
					negated = true,
					negatedExtglob = false,
				})
			end)

			it("should recognize leading ./", function()
				jestExpect(base("./(a|b)")).toBe("")
			end)

			it("should strip glob magic to return base path", function()
				jestExpect(base(".")).toBe(".")
				jestExpect(base(".*")).toBe("")
				jestExpect(base("/.*")).toBe("/")
				jestExpect(base("/.*/")).toBe("/")
				jestExpect(base("a/.*/b")).toBe("a")
				jestExpect(base("a*/.*/b")).toBe("")
				jestExpect(base("*/a/b/c")).toBe("")
				jestExpect(base("*")).toBe("")
				jestExpect(base("*/")).toBe("")
				jestExpect(base("*/*")).toBe("")
				jestExpect(base("*/*/")).toBe("")
				jestExpect(base("**")).toBe("")
				jestExpect(base("**/")).toBe("")
				jestExpect(base("**/*")).toBe("")
				jestExpect(base("**/*/")).toBe("")
				jestExpect(base("/*.js")).toBe("/")
				jestExpect(base("*.js")).toBe("")
				jestExpect(base("**/*.js")).toBe("")
				jestExpect(base("/root/path/to/*.js")).toBe("/root/path/to")
				jestExpect(base("[a-z]")).toBe("")
				jestExpect(base("chapter/foo [bar]/")).toBe("chapter")
				jestExpect(base("path/!/foo")).toBe("path/!/foo")
				jestExpect(base("path/!/foo/")).toBe("path/!/foo/")
				jestExpect(base("path/!subdir/foo.js")).toBe("path/!subdir/foo.js")
				jestExpect(base("path/**/*")).toBe("path")
				jestExpect(base("path/**/subdir/foo.*")).toBe("path")
				jestExpect(base("path/*/foo")).toBe("path")
				jestExpect(base("path/*/foo/")).toBe("path")
				jestExpect(base("path/+/foo")).toBe("path/+/foo", "plus sign must be escaped")
				jestExpect(base("path/+/foo/")).toBe("path/+/foo/", "plus sign must be escaped")
				jestExpect(base("path/?/foo")).toBe("path", "qmarks must be escaped")
				jestExpect(base("path/?/foo/")).toBe("path", "qmarks must be escaped")
				jestExpect(base("path/@/foo")).toBe("path/@/foo")
				jestExpect(base("path/@/foo/")).toBe("path/@/foo/")
				jestExpect(base("path/[a-z]")).toBe("path")
				jestExpect(base("path/subdir/**/foo.js")).toBe("path/subdir")
				jestExpect(base("path/to/*.js")).toBe("path/to")
			end)

			it("should respect escaped characters", function()
				jestExpect(base("path/\\*\\*/subdir/foo.*")).toBe("path/\\*\\*/subdir")
				jestExpect(base("path/\\[\\*\\]/subdir/foo.*")).toBe("path/\\[\\*\\]/subdir")
				jestExpect(base("path/\\[foo bar\\]/subdir/foo.*")).toBe("path/\\[foo bar\\]/subdir")
				jestExpect(base("path/\\[bar]/")).toBe("path/\\[bar]/")
				jestExpect(base("path/\\[bar]")).toBe("path/\\[bar]")
				jestExpect(base("[bar]")).toBe("")
				jestExpect(base("[bar]/")).toBe("")
				jestExpect(base("./\\[bar]")).toBe("\\[bar]")
				jestExpect(base("\\[bar]/")).toBe("\\[bar]/")
				jestExpect(base("\\[bar\\]/")).toBe("\\[bar\\]/")
				jestExpect(base("[bar\\]/")).toBe("[bar\\]/")
				jestExpect(base("path/foo \\[bar]/")).toBe("path/foo \\[bar]/")
				jestExpect(base("\\[bar]")).toBe("\\[bar]")
				jestExpect(base("[bar\\]")).toBe("[bar\\]")
			end)

			it("should return full non-glob paths", function()
				jestExpect(base("path")).toBe("path")
				jestExpect(base("path/foo")).toBe("path/foo")
				jestExpect(base("path/foo/")).toBe("path/foo/")
				jestExpect(base("path/foo/bar.js")).toBe("path/foo/bar.js")
			end)

			it("should not return glob when noext is true", function()
				jestExpect(scan("./foo/bar/*.js", { noext = true })).toEqual({
					input = "./foo/bar/*.js",
					prefix = "./",
					start = 3,
					base = "foo/bar/*.js",
					glob = "",
					isBrace = false,
					isBracket = false,
					isGlob = false,
					isGlobstar = false,
					isExtglob = false,
					negated = false,
					negatedExtglob = false,
				})
			end)

			it("should respect nonegate opts", function()
				jestExpect(scan("!foo/bar/*.js", { nonegate = true })).toEqual({
					input = "!foo/bar/*.js",
					prefix = "",
					start = 1,
					base = "!foo/bar",
					glob = "*.js",
					isBrace = false,
					isBracket = false,
					isGlob = true,
					isGlobstar = false,
					isExtglob = false,
					negated = false,
					negatedExtglob = false,
				})
			end)

			itFIXME("should return parts of the pattern", function()
				-- Right now it returns []
				-- assertParts('', ['']);
				-- assertParts('*', ['*']);
				-- assertParts('.*', ['.*']);
				-- assertParts('**', ['**']);
				-- assertParts('foo', ['foo']);
				-- assertParts('foo*', ['foo*']);
				-- assertParts('/', ['', '']);
				-- assertParts('/*', ['', '*']);
				-- assertParts('./', ['']);
				-- assertParts('{1..9}', ['{1..9}']);
				-- assertParts('c!(.)z', ['c!(.)z']);
				-- assertParts('(b|a).(a)', ['(b|a).(a)']);
				-- assertParts('+(a|b\\[)*', ['+(a|b\\[)*']);
				-- assertParts('@(a|b).md', ['@(a|b).md']);
				-- assertParts('(a/b)', ['(a/b)']);
				-- assertParts('(a\\b)', ['(a\\b)']);
				-- assertParts('foo\\[a\\/]', ['foo\\[a\\/]']);
				-- assertParts('foo[/]bar', ['foo[/]bar']);
				-- assertParts('/dev\\/@(tcp|udp)\\/*\\/*', ['', '/dev\\/@(tcp|udp)\\/*\\/*']);
				-- Right now it returns ['*']
				-- assertParts('*/', ['*', '']);
				-- Right now it returns ['!(!(bar)', 'baz)']
				-- assertParts('!(!(bar)/baz)', ['!(!(bar)/baz)']);
				assertParts("./foo", { "foo" })
				assertParts("../foo", { "..", "foo" })
				assertParts("foo/bar", { "foo", "bar" })
				assertParts("foo/*", { "foo", "*" })
				assertParts("foo/**", { "foo", "**" })
				assertParts("foo/**/*", { "foo", "**", "*" })
				assertParts("\u{30D5}\u{30A9}\u{30EB}\u{30C0}/**/*", { "\u{30D5}\u{30A9}\u{30EB}\u{30C0}", "**", "*" })
				assertParts("foo/!(abc)", { "foo", "!(abc)" })
				assertParts("c/!(z)/v", { "c", "!(z)", "v" })
				assertParts("c/@(z)/v", { "c", "@(z)", "v" })
				assertParts("foo/(bar|baz)", { "foo", "(bar|baz)" })
				assertParts("foo/(bar|baz)*", { "foo", "(bar|baz)*" })
				assertParts("**/*(W*, *)*", { "**", "*(W*, *)*" })
				assertParts("a/**@(/x|/z)/*.md", { "a", "**@(/x|/z)", "*.md" })
				assertParts("foo/(bar|baz)/*.js", { "foo", "(bar|baz)", "*.js" })
				assertParts("XXX/*/*/12/*/*/m/*/*", { "XXX", "*", "*", "12", "*", "*", "m", "*", "*" })
				assertParts('foo/\\"**\\"/bar', { "foo", '\\"**\\"', "bar" })
				assertParts("[0-9]/[0-9]", { "[0-9]", "[0-9]" })
				assertParts("foo/[0-9]/[0-9]", { "foo", "[0-9]", "[0-9]" })
				assertParts("foo[0-9]/bar[0-9]", { "foo[0-9]", "bar[0-9]" })
			end)
		end)

		describe(".base (glob2base test patterns)", function()
			it("should get a base name", function()
				jestExpect(base("js/*.js")).toBe("js")
			end)

			it("should get a base name from a nested glob", function()
				jestExpect(base("js/**/test/*.js")).toBe("js")
			end)

			it("should get a base name from a flat file", function()
				jestExpect(base("js/test/wow.js")).toBe("js/test/wow.js") -- differs
			end)

			it("should get a base name from character class pattern", function()
				jestExpect(base("js/t[a-z]st}/*.js")).toBe("js")
			end)

			it("should get a base name from extglob", function()
				jestExpect(base("js/t+(wo|est)/*.js")).toBe("js")
			end)

			it("should get a base name from a path with non-exglob parens", function()
				jestExpect(base("(a|b)")).toBe("")
				jestExpect(base("foo/(a|b)")).toBe("foo")
				jestExpect(base("/(a|b)")).toBe("/")
				jestExpect(base("a/(b c)")).toBe("a")
				jestExpect(base("foo/(b c)/baz")).toBe("foo")
				jestExpect(base("a/(b c)/")).toBe("a")
				jestExpect(base("a/(b c)/d")).toBe("a")
				jestExpect(base("a/(b c)", { noparen = true })).toBe("a/(b c)")
				jestExpect(base("a/(b c)/", { noparen = true })).toBe("a/(b c)/")
				jestExpect(base("a/(b c)/d", { noparen = true })).toBe("a/(b c)/d")
				jestExpect(base("foo/(b c)/baz", { noparen = true })).toBe("foo/(b c)/baz")
				jestExpect(base("path/(foo bar)/subdir/foo.*", { noparen = true })).toBe("path/(foo bar)/subdir")
				jestExpect(base("a/\\(b c)")).toBe("a/\\(b c)", "parens must be escaped")
				jestExpect(base("a/\\+\\(b c)/foo")).toBe("a/\\+\\(b c)/foo", "parens must be escaped")
				jestExpect(base("js/t(wo|est)/*.js")).toBe("js")
				jestExpect(base("js/t/(wo|est)/*.js")).toBe("js/t")
				jestExpect(base("path/(foo bar)/subdir/foo.*")).toBe("path", "parens must be escaped")
				jestExpect(base("path/(foo/bar|baz)")).toBe("path")
				jestExpect(base("path/(foo/bar|baz)/")).toBe("path")
				jestExpect(base("path/(to|from)")).toBe("path")
				jestExpect(base("path/\\(foo/bar|baz)/")).toBe("path/\\(foo/bar|baz)/")
				jestExpect(base("path/\\*(a|b)")).toBe("path")
				jestExpect(base("path/\\*(a|b)/subdir/foo.*")).toBe("path")
				jestExpect(base("path/\\*/(a|b)/subdir/foo.*")).toBe("path/\\*")
				jestExpect(base("path/\\*\\(a\\|b\\)/subdir/foo.*")).toBe("path/\\*\\(a\\|b\\)/subdir")
			end)
		end)

		describe("technically invalid windows globs", function()
			it("should support simple globs with backslash path separator", function()
				jestExpect(base("C:\\path\\*.js")).toBe("C:\\path\\*.js")
				jestExpect(base("C:\\\\path\\\\*.js")).toBe("")
				jestExpect(base("C:\\\\path\\*.js")).toBe("C:\\\\path\\*.js")
			end)
		end)

		describe("glob base >", function()
			it("should parse globs", function()
				jestExpect(both("!foo")).toEqual({ "foo", "" })
				jestExpect(both("*")).toEqual({ "", "*" })
				jestExpect(both("**")).toEqual({ "", "**" })
				jestExpect(both("**/*.md")).toEqual({ "", "**/*.md" })
				jestExpect(both("**/*.min.js")).toEqual({ "", "**/*.min.js" })
				jestExpect(both("**/*foo.js")).toEqual({ "", "**/*foo.js" })
				jestExpect(both("**/.*")).toEqual({ "", "**/.*" })
				jestExpect(both("**/d")).toEqual({ "", "**/d" })
				jestExpect(both("*.*")).toEqual({ "", "*.*" })
				jestExpect(both("*.js")).toEqual({ "", "*.js" })
				jestExpect(both("*.md")).toEqual({ "", "*.md" })
				jestExpect(both("*.min.js")).toEqual({ "", "*.min.js" })
				jestExpect(both("*/*")).toEqual({ "", "*/*" })
				jestExpect(both("*/*/*/*")).toEqual({ "", "*/*/*/*" })
				jestExpect(both("*/*/*/e")).toEqual({ "", "*/*/*/e" })
				jestExpect(both("*/b/*/e")).toEqual({ "", "*/b/*/e" })
				jestExpect(both("*b")).toEqual({ "", "*b" })
				jestExpect(both(".*")).toEqual({ "", ".*" })
				jestExpect(both("*")).toEqual({ "", "*" })
				jestExpect(both("a/**/j/**/z/*.md")).toEqual({ "a", "**/j/**/z/*.md" })
				jestExpect(both("a/**/z/*.md")).toEqual({ "a", "**/z/*.md" })
				jestExpect(both("node_modules/*-glob/**/*.js")).toEqual({ "node_modules", "*-glob/**/*.js" })
				jestExpect(both("{a/b/{c,/foo.js}/e.f.g}")).toEqual({ "", "{a/b/{c,/foo.js}/e.f.g}" })
				jestExpect(both(".a*")).toEqual({ "", ".a*" })
				jestExpect(both(".b*")).toEqual({ "", ".b*" })
				jestExpect(both("/*")).toEqual({ "/", "*" })
				jestExpect(both("a/***")).toEqual({ "a", "***" })
				jestExpect(both("a/**/b/*.{foo,bar}")).toEqual({ "a", "**/b/*.{foo,bar}" })
				jestExpect(both("a/**/c/*")).toEqual({ "a", "**/c/*" })
				jestExpect(both("a/**/c/*.md")).toEqual({ "a", "**/c/*.md" })
				jestExpect(both("a/**/e")).toEqual({ "a", "**/e" })
				jestExpect(both("a/**/j/**/z/*.md")).toEqual({ "a", "**/j/**/z/*.md" })
				jestExpect(both("a/**/z/*.md")).toEqual({ "a", "**/z/*.md" })
				jestExpect(both("a/**c*")).toEqual({ "a", "**c*" })
				jestExpect(both("a/**c/*")).toEqual({ "a", "**c/*" })
				jestExpect(both("a/*/*/e")).toEqual({ "a", "*/*/e" })
				jestExpect(both("a/*/c/*.md")).toEqual({ "a", "*/c/*.md" })
				jestExpect(both("a/b/**/c{d,e}/**/xyz.md")).toEqual({ "a/b", "**/c{d,e}/**/xyz.md" })
				jestExpect(both("a/b/**/e")).toEqual({ "a/b", "**/e" })
				jestExpect(both("a/b/*.{foo,bar}")).toEqual({ "a/b", "*.{foo,bar}" })
				jestExpect(both("a/b/*/e")).toEqual({ "a/b", "*/e" })
				jestExpect(both("a/b/.git/")).toEqual({ "a/b/.git/", "" })
				jestExpect(both("a/b/.git/**")).toEqual({ "a/b/.git", "**" })
				jestExpect(both("a/b/.{foo,bar}")).toEqual({ "a/b", ".{foo,bar}" })
				jestExpect(both("a/b/c/*")).toEqual({ "a/b/c", "*" })
				jestExpect(both("a/b/c/**/*.min.js")).toEqual({ "a/b/c", "**/*.min.js" })
				jestExpect(both("a/b/c/*.md")).toEqual({ "a/b/c", "*.md" })
				jestExpect(both("a/b/c/.*.md")).toEqual({ "a/b/c", ".*.md" })
				jestExpect(both("a/b/{c,.gitignore,{a,b}}/{a,b}/abc.foo.js")).toEqual({
					"a/b",
					"{c,.gitignore,{a,b}}/{a,b}/abc.foo.js",
				})
				jestExpect(both("a/b/{c,/.gitignore}")).toEqual({ "a/b", "{c,/.gitignore}" })
				jestExpect(both("a/b/{c,d}/")).toEqual({ "a/b", "{c,d}/" })
				jestExpect(both("a/b/{c,d}/e/f.g")).toEqual({ "a/b", "{c,d}/e/f.g" })
				jestExpect(both("b/*/*/*")).toEqual({ "b", "*/*/*" })
			end)

			it("should support file extensions", function()
				jestExpect(both(".md")).toEqual({ ".md", "" })
			end)

			itFIXME("should support negation pattern", function()
				jestExpect(both("!*.min.js")).toEqual({ "", "*.min.js" })
				jestExpect(both("!foo")).toEqual({ "foo", "" })
				jestExpect(both("!foo/*.js")).toEqual({ "foo", "*.js" })
				jestExpect(both("!foo/(a|b).min.js")).toEqual({ "foo", "(a|b).min.js" })
				jestExpect(both("!foo/[a-b].min.js")).toEqual({ "foo", "[a-b].min.js" })
				jestExpect(both("!foo/{a,b}.min.js")).toEqual({ "foo", "{a,b}.min.js" })
				jestExpect(both("a/b/c/!foo")).toEqual({ "a/b/c/!foo", "" })
			end)

			it("should support extglobs", function()
				jestExpect(both("/a/b/!(a|b)/e.f.g/")).toEqual({ "/a/b", "!(a|b)/e.f.g/" })
				jestExpect(both("/a/b/@(a|b)/e.f.g/")).toEqual({ "/a/b", "@(a|b)/e.f.g/" })
				jestExpect(both("@(a|b)/e.f.g/")).toEqual({ "", "@(a|b)/e.f.g/" })
				jestExpect(base("path/!(to|from)")).toBe("path")
				jestExpect(base("path/*(to|from)")).toBe("path")
				jestExpect(base("path/+(to|from)")).toBe("path")
				jestExpect(base("path/?(to|from)")).toBe("path")
				jestExpect(base("path/@(to|from)")).toBe("path")
			end)

			itFIXME("should support regex character classes", function()
				local opts = { unescape = true }
				jestExpect(both("[a-c]b*")).toEqual({ "", "[a-c]b*" })
				jestExpect(both("[a-j]*[^c]")).toEqual({ "", "[a-j]*[^c]" })
				jestExpect(both("[a-j]*[^c]b/c")).toEqual({ "", "[a-j]*[^c]b/c" })
				jestExpect(both("[a-j]*[^c]bc")).toEqual({ "", "[a-j]*[^c]bc" })
				jestExpect(both("[ab][ab]")).toEqual({ "", "[ab][ab]" })
				jestExpect(both("foo/[a-b].min.js")).toEqual({ "foo", "[a-b].min.js" })
				jestExpect(base("path/foo[a\\/]/", opts)).toBe("path")
				jestExpect(base("path/foo\\[a\\/]/", opts)).toBe("path/foo[a\\/]/")
				jestExpect(base("foo[a\\/]", opts)).toBe("")
				jestExpect(base("foo\\[a\\/]", opts)).toBe("foo[a\\/]")
			end)

			it("should support qmarks", function()
				jestExpect(both("?")).toEqual({ "", "?" })
				jestExpect(both("?/?")).toEqual({ "", "?/?" })
				jestExpect(both("??")).toEqual({ "", "??" })
				jestExpect(both("???")).toEqual({ "", "???" })
				jestExpect(both("?a")).toEqual({ "", "?a" })
				jestExpect(both("?b")).toEqual({ "", "?b" })
				jestExpect(both("a?b")).toEqual({ "", "a?b" })
				jestExpect(both("a/?/c.js")).toEqual({ "a", "?/c.js" })
				jestExpect(both("a/?/c.md")).toEqual({ "a", "?/c.md" })
				jestExpect(both("a/?/c/?/*/f.js")).toEqual({ "a", "?/c/?/*/f.js" })
				jestExpect(both("a/?/c/?/*/f.md")).toEqual({ "a", "?/c/?/*/f.md" })
				jestExpect(both("a/?/c/?/e.js")).toEqual({ "a", "?/c/?/e.js" })
				jestExpect(both("a/?/c/?/e.md")).toEqual({ "a", "?/c/?/e.md" })
				jestExpect(both("a/?/c/???/e.js")).toEqual({ "a", "?/c/???/e.js" })
				jestExpect(both("a/?/c/???/e.md")).toEqual({ "a", "?/c/???/e.md" })
				jestExpect(both("a/??/c.js")).toEqual({ "a", "??/c.js" })
				jestExpect(both("a/??/c.md")).toEqual({ "a", "??/c.md" })
				jestExpect(both("a/???/c.js")).toEqual({ "a", "???/c.js" })
				jestExpect(both("a/???/c.md")).toEqual({ "a", "???/c.md" })
				jestExpect(both("a/????/c.js")).toEqual({ "a", "????/c.js" })
			end)

			it("should support non-glob patterns", function()
				jestExpect(both("")).toEqual({ "", "" })
				jestExpect(both(".")).toEqual({ ".", "" })
				jestExpect(both("a")).toEqual({ "a", "" })
				jestExpect(both(".a")).toEqual({ ".a", "" })
				jestExpect(both("/a")).toEqual({ "/a", "" })
				jestExpect(both("a/")).toEqual({ "a/", "" })
				jestExpect(both("/a/")).toEqual({ "/a/", "" })
				jestExpect(both("/a/b/c")).toEqual({ "/a/b/c", "" })
				jestExpect(both("/a/b/c/")).toEqual({ "/a/b/c/", "" })
				jestExpect(both("a/b/c/")).toEqual({ "a/b/c/", "" })
				jestExpect(both("a.min.js")).toEqual({ "a.min.js", "" })
				jestExpect(both("a/.x.md")).toEqual({ "a/.x.md", "" })
				jestExpect(both("a/b/.gitignore")).toEqual({ "a/b/.gitignore", "" })
				jestExpect(both("a/b/c/d.md")).toEqual({ "a/b/c/d.md", "" })
				jestExpect(both("a/b/c/d.e.f/g.min.js")).toEqual({ "a/b/c/d.e.f/g.min.js", "" })
				jestExpect(both("a/b/.git")).toEqual({ "a/b/.git", "" })
				jestExpect(both("a/b/.git/")).toEqual({ "a/b/.git/", "" })
				jestExpect(both("a/b/c")).toEqual({ "a/b/c", "" })
				jestExpect(both("a/b/c.d/e.md")).toEqual({ "a/b/c.d/e.md", "" })
				jestExpect(both("a/b/c.md")).toEqual({ "a/b/c.md", "" })
				jestExpect(both("a/b/c.min.js")).toEqual({ "a/b/c.min.js", "" })
				jestExpect(both("a/b/git/")).toEqual({ "a/b/git/", "" })
				jestExpect(both("aa")).toEqual({ "aa", "" })
				jestExpect(both("ab")).toEqual({ "ab", "" })
				jestExpect(both("bb")).toEqual({ "bb", "" })
				jestExpect(both("c.md")).toEqual({ "c.md", "" })
				jestExpect(both("foo")).toEqual({ "foo", "" })
			end)
		end)

		describe("braces", function()
			it("should recognize brace sets", function()
				jestExpect(base("path/{to,from}")).toBe("path")
				jestExpect(base("path/{foo,bar}/")).toBe("path")
				jestExpect(base("js/{src,test}/*.js")).toBe("js")
				jestExpect(base("{a,b}")).toBe("")
				jestExpect(base("/{a,b}")).toBe("/")
				jestExpect(base("/{a,b}/")).toBe("/")
			end)

			it("should recognize brace ranges", function()
				jestExpect(base("js/test{0..9}/*.js")).toBe("js")
			end)

			itFIXME("should respect brace enclosures with embedded separators", function()
				local opts = { unescape = true }
				jestExpect(base("path/{,/,bar/baz,qux}/", opts)).toBe("path")
				jestExpect(base("path/\\{,/,bar/baz,qux}/", opts)).toBe("path/{,/,bar/baz,qux}/")
				jestExpect(base("path/\\{,/,bar/baz,qux\\}/", opts)).toBe("path/{,/,bar/baz,qux}/")
				jestExpect(base("/{,/,bar/baz,qux}/", opts)).toBe("/")
				jestExpect(base("/\\{,/,bar/baz,qux}/", opts)).toBe("/{,/,bar/baz,qux}/")
				jestExpect(base("{,/,bar/baz,qux}", opts)).toBe("")
				jestExpect(base("\\{,/,bar/baz,qux\\}", opts)).toBe("{,/,bar/baz,qux}")
				jestExpect(base("\\{,/,bar/baz,qux}/", opts)).toBe("{,/,bar/baz,qux}/")
			end)

			itFIXME("should handle escaped nested braces", function()
				local opts = { unescape = true }
				jestExpect(base("\\{../,./,\\{bar,/baz},qux}", opts)).toBe("{../,./,{bar,/baz},qux}")
				jestExpect(base("\\{../,./,\\{bar,/baz},qux}/", opts)).toBe("{../,./,{bar,/baz},qux}/")
				jestExpect(base("path/\\{,/,bar/{baz,qux}}/", opts)).toBe("path/{,/,bar/{baz,qux}}/")
				jestExpect(base("path/\\{../,./,\\{bar,/baz},qux}/", opts)).toBe("path/{../,./,{bar,/baz},qux}/")
				jestExpect(base("path/\\{../,./,\\{bar,/baz},qux}/", opts)).toBe("path/{../,./,{bar,/baz},qux}/")
				jestExpect(base("path/\\{../,./,{bar,/baz},qux}/", opts)).toBe("path/{../,./,{bar,/baz},qux}/")
				jestExpect(base("path/{,/,bar/\\{baz,qux}}/", opts)).toBe("path")
			end)

			itFIXME("should recognize escaped braces", function()
				local opts = { unescape = true }
				jestExpect(base("\\{foo,bar\\}", opts)).toBe("{foo,bar}")
				jestExpect(base("\\{foo,bar\\}/", opts)).toBe("{foo,bar}/")
				jestExpect(base("\\{foo,bar}/", opts)).toBe("{foo,bar}/")
				jestExpect(base("path/\\{foo,bar}/", opts)).toBe("path/{foo,bar}/")
			end)

			it("should get a base name from a complex brace glob", function()
				jestExpect(base("one/{foo,bar}/**/{baz,qux}/*.txt")).toBe("one")
				jestExpect(base("two/baz/**/{abc,xyz}/*.js")).toBe("two/baz")
				jestExpect(base("foo/{bar,baz}/**/aaa/{bbb,ccc}")).toBe("foo")
			end)

			it("should support braces: no path", function()
				jestExpect(both("/a/b/{c,/foo.js}/e.f.g/")).toEqual({ "/a/b", "{c,/foo.js}/e.f.g/" })
				jestExpect(both("{a/b/c.js,/a/b/{c,/foo.js}/e.f.g/}")).toEqual({
					"",
					"{a/b/c.js,/a/b/{c,/foo.js}/e.f.g/}",
				})
				jestExpect(both("/a/b/{c,d}/")).toEqual({ "/a/b", "{c,d}/" })
				jestExpect(both("/a/b/{c,d}/*.js")).toEqual({ "/a/b", "{c,d}/*.js" })
				jestExpect(both("/a/b/{c,d}/*.min.js")).toEqual({ "/a/b", "{c,d}/*.min.js" })
				jestExpect(both("/a/b/{c,d}/e.f.g/")).toEqual({ "/a/b", "{c,d}/e.f.g/" })
				jestExpect(both("{.,*}")).toEqual({ "", "{.,*}" })
			end)

			it("should support braces in filename", function()
				jestExpect(both("a/b/.{c,.gitignore}")).toEqual({ "a/b", ".{c,.gitignore}" })
				jestExpect(both("a/b/.{c,/.gitignore}")).toEqual({ "a/b", ".{c,/.gitignore}" })
				jestExpect(both("a/b/.{foo,bar}")).toEqual({ "a/b", ".{foo,bar}" })
				jestExpect(both("a/b/{c,.gitignore}")).toEqual({ "a/b", "{c,.gitignore}" })
				jestExpect(both("a/b/{c,/.gitignore}")).toEqual({ "a/b", "{c,/.gitignore}" })
				jestExpect(both("a/b/{c,/gitignore}")).toEqual({ "a/b", "{c,/gitignore}" })
				jestExpect(both("a/b/{c,d}")).toEqual({ "a/b", "{c,d}" })
			end)

			it("should support braces in dirname", function()
				jestExpect(both("a/b/{c,./d}/e/f.g")).toEqual({ "a/b", "{c,./d}/e/f.g" })
				jestExpect(both("a/b/{c,./d}/e/f.min.g")).toEqual({ "a/b", "{c,./d}/e/f.min.g" })
				jestExpect(both("a/b/{c,.gitignore,{a,./b}}/{a,b}/abc.foo.js")).toEqual({
					"a/b",
					"{c,.gitignore,{a,./b}}/{a,b}/abc.foo.js",
				})
				jestExpect(both("a/b/{c,.gitignore,{a,b}}/{a,b}/*.foo.js")).toEqual({
					"a/b",
					"{c,.gitignore,{a,b}}/{a,b}/*.foo.js",
				})
				jestExpect(both("a/b/{c,.gitignore,{a,b}}/{a,b}/abc.foo.js")).toEqual({
					"a/b",
					"{c,.gitignore,{a,b}}/{a,b}/abc.foo.js",
				})
				jestExpect(both("a/b/{c,/d}/e/f.g")).toEqual({ "a/b", "{c,/d}/e/f.g" })
				jestExpect(both("a/b/{c,/d}/e/f.min.g")).toEqual({ "a/b", "{c,/d}/e/f.min.g" })
				jestExpect(both("a/b/{c,d}/")).toEqual({ "a/b", "{c,d}/" })
				jestExpect(both("a/b/{c,d}/*.js")).toEqual({ "a/b", "{c,d}/*.js" })
				jestExpect(both("a/b/{c,d}/*.min.js")).toEqual({ "a/b", "{c,d}/*.min.js" })
				jestExpect(both("a/b/{c,d}/e.f.g/")).toEqual({ "a/b", "{c,d}/e.f.g/" })
				jestExpect(both("a/b/{c,d}/e/f.g")).toEqual({ "a/b", "{c,d}/e/f.g" })
				jestExpect(both("a/b/{c,d}/e/f.min.g")).toEqual({ "a/b", "{c,d}/e/f.min.g" })
				jestExpect(both("foo/{a,b}.min.js")).toEqual({ "foo", "{a,b}.min.js" })
			end)
		end)
	end)
end
