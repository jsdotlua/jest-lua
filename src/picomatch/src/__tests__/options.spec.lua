-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/options.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent
	local Packages = PicomatchModule.Parent
	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Array = LuauPolyfill.Array
	local Object = LuauPolyfill.Object

	local jestExpect = require(Packages.Dev.Expect)

	local support = require(CurrentModule.support)
	local match = require(CurrentModule.support.match)
	local isMatch = require(PicomatchModule).isMatch
	describe("options", function()
		beforeEach(function()
			return support.windowsPathSep()
		end)
		afterEach(function()
			return support.resetPathSep()
		end)

		describe("options.matchBase", function()
			itFIXME("should match the basename of file paths when `options.matchBase` is true", function()
				jestExpect(match({ "a/b/c/d.md" }, "*.md")).toEqual(
					{}
					-- ROBLOX deviation: jestExpect doesn't accept message
					-- , "should not match multiple levels"
				)
				jestExpect(match({ "a/b/c/foo.md" }, "*.md")).toEqual(
					{}
					-- ROBLOX deviation: jestExpect doesn't accept message
					--, "should not match multiple levels"
				)
				jestExpect(match({ "ab", "acb", "acb/", "acb/d/e", "x/y/acb", "x/y/acb/d" }, "a?b")).toEqual(
					{ "acb" }
					-- ROBLOX deviation: jestExpect doesn't accept message
					-- ,"should not match multiple levels"
				)
				jestExpect(match({ "a/b/c/d.md" }, "*.md", { matchBase = true })).toEqual({ "a/b/c/d.md" })
				jestExpect(match({ "a/b/c/foo.md" }, "*.md", { matchBase = true })).toEqual({ "a/b/c/foo.md" })
				jestExpect(match({ "x/y/acb", "acb/", "acb/d/e", "x/y/acb/d" }, "a?b", { matchBase = true })).toEqual({
					"x/y/acb",
					"acb/",
				})
			end)

			itFIXME("should work with negation patterns", function()
				assert(isMatch("./x/y.js", "*.js", { matchBase = true }))
				assert(not isMatch("./x/y.js", "!*.js", { matchBase = true }))
				assert(isMatch("./x/y.js", "**/*.js", { matchBase = true }))
				assert(not isMatch("./x/y.js", "!**/*.js", { matchBase = true }))
			end)
		end)

		describe("options.flags", function()
			it("should be case-sensitive by default", function()
				jestExpect(match({ "a/b/d/e.md" }, "a/b/D/*.md")).toEqual(
					{}
					-- ROBLOX deviation: jestExpect doesn't accept message
					-- , "should not match a dirname"
				)
				jestExpect(match({ "a/b/c/e.md" }, "A/b/*/E.md")).toEqual(
					{}
					-- ROBLOX deviation: jestExpect doesn't accept message
					-- , "should not match a basename"
				)
				jestExpect(match({ "a/b/c/e.md" }, "A/b/C/*.MD")).toEqual(
					{}
					-- ROBLOX deviation: jestExpect doesn't accept message
					-- , "should not match a file extension"
				)
			end)

			itFIXME("should not be case-sensitive when `i` is set on `options.flags`", function()
				jestExpect(match({ "a/b/d/e.md" }, "a/b/D/*.md", { flags = "i" })).toEqual({ "a/b/d/e.md" })
				jestExpect(match({ "a/b/c/e.md" }, "A/b/*/E.md", { flags = "i" })).toEqual({ "a/b/c/e.md" })
				jestExpect(match({ "a/b/c/e.md" }, "A/b/C/*.MD", { flags = "i" })).toEqual({ "a/b/c/e.md" })
			end)
		end)

		describe("options.nocase", function()
			itFIXME("should not be case-sensitive when `options.nocase` is true", function()
				jestExpect(match({ "a/b/c/e.md" }, "A/b/*/E.md", { nocase = true })).toEqual({ "a/b/c/e.md" })
				jestExpect(match({ "a/b/c/e.md" }, "A/b/C/*.MD", { nocase = true })).toEqual({ "a/b/c/e.md" })
				jestExpect(match({ "a/b/c/e.md" }, "A/b/C/*.md", { nocase = true })).toEqual({ "a/b/c/e.md" })
				jestExpect(match({ "a/b/d/e.md" }, "a/b/D/*.md", { nocase = true })).toEqual({ "a/b/d/e.md" })
			end)

			itFIXME("should not double-set `i` when both `nocase` and the `i` flag are set", function()
				local opts = { nocase = true, flags = "i" }
				jestExpect(match({ "a/b/d/e.md" }, "a/b/D/*.md", opts)).toEqual({ "a/b/d/e.md" })
				jestExpect(match({ "a/b/c/e.md" }, "A/b/*/E.md", opts)).toEqual({ "a/b/c/e.md" })
				jestExpect(match({ "a/b/c/e.md" }, "A/b/C/*.MD", opts)).toEqual({ "a/b/c/e.md" })
			end)
		end)

		describe("options.noextglob", function()
			it("should match literal parens when noextglob is true (issue #116)", function()
				assert(isMatch("a/(dir)", "a/(dir)", { noextglob = true }))
			end)

			it("should not match extglobs when noextglob is true", function()
				assert(not isMatch("ax", "?(a*|b)", { noextglob = true }))
				jestExpect(match({ "a.j.js", "a.md.js" }, "*.*(j).js", { noextglob = true })).toEqual({ "a.j.js" })
				jestExpect(match({ "a/z", "a/b", "a/!(z)" }, "a/!(z)", { noextglob = true })).toEqual({ "a/!(z)" })
				jestExpect(match({ "a/z", "a/b" }, "a/!(z)", { noextglob = true })).toEqual({})
				jestExpect(match({ "c/a/v" }, "c/!(z)/v", { noextglob = true })).toEqual({})
				jestExpect(match({ "c/z/v", "c/a/v" }, "c/!(z)/v", { noextglob = true })).toEqual({})
				jestExpect(match({ "c/z/v", "c/a/v" }, "c/@(z)/v", { noextglob = true })).toEqual({})
				jestExpect(match({ "c/z/v", "c/a/v" }, "c/+(z)/v", { noextglob = true })).toEqual({})
				jestExpect(match({ "c/z/v", "c/a/v" }, "c/*(z)/v", { noextglob = true })).toEqual({ "c/z/v" })
				jestExpect(match({ "c/z/v", "z", "zf", "fz" }, "?(z)", { noextglob = true })).toEqual({ "fz" })
				jestExpect(match({ "c/z/v", "z", "zf", "fz" }, "+(z)", { noextglob = true })).toEqual({})
				jestExpect(match({ "c/z/v", "z", "zf", "fz" }, "*(z)", { noextglob = true })).toEqual({
					"z",
					"fz",
				})
				jestExpect(match({ "cz", "abz", "az" }, "a@(z)", { noextglob = true })).toEqual({})
				jestExpect(match({ "cz", "abz", "az" }, "a*@(z)", { noextglob = true })).toEqual({})
				jestExpect(match({ "cz", "abz", "az" }, "a!(z)", { noextglob = true })).toEqual({})
				jestExpect(match({ "cz", "abz", "az", "azz" }, "a?(z)", { noextglob = true })).toEqual({
					"abz",
					"azz",
				})
				jestExpect(match({ "cz", "abz", "az", "azz", "a+z" }, "a+(z)", { noextglob = true })).toEqual({
					"a+z",
				})
				jestExpect(match({ "cz", "abz", "az" }, "a*(z)", { noextglob = true })).toEqual({ "abz", "az" })
				jestExpect(match({ "cz", "abz", "az" }, "a**(z)", { noextglob = true })).toEqual({ "abz", "az" })
				jestExpect(match({ "cz", "abz", "az" }, "a*!(z)", { noextglob = true })).toEqual({})
			end)
		end)

		describe("options.unescape", function()
			itFIXME("should remove backslashes in glob patterns:", function()
				local fixtures = { "abc", "/a/b/c", "\\a\\b\\c" }
				jestExpect(match(fixtures, "\\a\\b\\c")).toEqual({ "/a/b/c" })
				jestExpect(match(fixtures, "\\a\\b\\c", { unescape = true })).toEqual({ "abc", "/a/b/c" })
				jestExpect(match(fixtures, "\\a\\b\\c", { unescape = false })).toEqual({ "/a/b/c" })
			end)
		end)

		describe("options.nonegate", function()
			it("should support the `nonegate` option:", function()
				jestExpect(match({ "a/a/a", "a/b/a", "b/b/a", "c/c/a", "c/c/b" }, "!**/a")).toEqual({ "c/c/b" })
				jestExpect(match({ "a.md", "!a.md", "a.txt" }, "!*.md", { nonegate = true })).toEqual({ "!a.md" })
				jestExpect(
					match({ "!a/a/a", "!a/a", "a/b/a", "b/b/a", "!c/c/a", "!c/a" }, "!**/a", { nonegate = true })
				).toEqual({ "!a/a", "!c/a" })
				jestExpect(match({ "!*.md", ".dotfile.txt", "a/b/.dotfile" }, "!*.md", { nonegate = true })).toEqual({
					"!*.md",
				})
			end)
		end)

		describe("options.windows", function()
			itFIXME("should windows file paths by default", function()
				jestExpect(match({ "a\\b\\c.md" }, "**/*.md")).toEqual({ "a/b/c.md" })
				jestExpect(match({ "a\\b\\c.md" }, "**/*.md", { windows = false })).toEqual({ "a\\b\\c.md" })
			end)

			itFIXME("should windows absolute paths", function()
				jestExpect(match({ "E:\\a\\b\\c.md" }, "E:/**/*.md")).toEqual({ "E:/a/b/c.md" })
				jestExpect(match({ "E:\\a\\b\\c.md" }, "E:/**/*.md", { windows = false })).toEqual({})
			end)

			it("should strip leading `./`", function()
				local fixtures = Array.sort({
					"./a",
					"./a/a/a",
					"./a/a/a/a",
					"./a/a/a/a/a",
					"./a/b",
					"./a/x",
					"./z/z",
					"a",
					"a/a",
					"a/a/b",
					"a/c",
					"b",
					"x/y",
				})
				local function format(str)
					return str:gsub("^%./", "")
				end
				local opts = { format = format }
				jestExpect(match(fixtures, "*", opts)).toEqual({ "a", "b" })
				jestExpect(match(fixtures, "**/a/**", opts)).toEqual({
					"a",
					"a/a/a",
					"a/a/a/a",
					"a/a/a/a/a",
					"a/b",
					"a/x",
					"a/a",
					"a/a/b",
					"a/c",
				})
				jestExpect(match(fixtures, "*/*", opts)).toEqual({ "a/b", "a/x", "z/z", "a/a", "a/c", "x/y" })
				jestExpect(match(fixtures, "*/*/*", opts)).toEqual({ "a/a/a", "a/a/b" })
				jestExpect(match(fixtures, "*/*/*/*", opts)).toEqual({ "a/a/a/a" })
				jestExpect(match(fixtures, "*/*/*/*/*", opts)).toEqual({ "a/a/a/a/a" })
				jestExpect(match(fixtures, "./*", opts)).toEqual({ "a", "b" })
				jestExpect(match(fixtures, "./**/a/**", opts)).toEqual({
					"a",
					"a/a/a",
					"a/a/a/a",
					"a/a/a/a/a",
					"a/b",
					"a/x",
					"a/a",
					"a/a/b",
					"a/c",
				})
				jestExpect(match(fixtures, "./a/*/a", opts)).toEqual({ "a/a/a" })
				jestExpect(match(fixtures, "a/*", opts)).toEqual({ "a/b", "a/x", "a/a", "a/c" })
				jestExpect(match(fixtures, "a/*/*", opts)).toEqual({ "a/a/a", "a/a/b" })
				jestExpect(match(fixtures, "a/*/*/*", opts)).toEqual({ "a/a/a/a" })
				jestExpect(match(fixtures, "a/*/*/*/*", opts)).toEqual({ "a/a/a/a/a" })
				jestExpect(match(fixtures, "a/*/a", opts)).toEqual({ "a/a/a" })
				jestExpect(match(fixtures, "*", Object.assign({}, opts, { windows = false }))).toEqual({
					"a",
					"b",
				})
				jestExpect(match(fixtures, "**/a/**", Object.assign({}, opts, { windows = false }))).toEqual({
					"a",
					"a/a/a",
					"a/a/a/a",
					"a/a/a/a/a",
					"a/b",
					"a/x",
					"a/a",
					"a/a/b",
					"a/c",
				})
				jestExpect(match(fixtures, "*/*", Object.assign({}, opts, { windows = false }))).toEqual({
					"a/b",
					"a/x",
					"z/z",
					"a/a",
					"a/c",
					"x/y",
				})
				jestExpect(match(fixtures, "*/*/*", Object.assign({}, opts, { windows = false }))).toEqual({
					"a/a/a",
					"a/a/b",
				})
				jestExpect(match(fixtures, "*/*/*/*", Object.assign({}, opts, { windows = false }))).toEqual({
					"a/a/a/a",
				})
				jestExpect(match(fixtures, "*/*/*/*/*", Object.assign({}, opts, { windows = false }))).toEqual({
					"a/a/a/a/a",
				})
				jestExpect(match(fixtures, "./*", Object.assign({}, opts, { windows = false }))).toEqual({ "a", "b" })
				jestExpect(match(fixtures, "./**/a/**", Object.assign({}, opts, { windows = false }))).toEqual({
					"a",
					"a/a/a",
					"a/a/a/a",
					"a/a/a/a/a",
					"a/b",
					"a/x",
					"a/a",
					"a/a/b",
					"a/c",
				})
				jestExpect(match(fixtures, "./a/*/a", Object.assign({}, opts, { windows = false }))).toEqual({
					"a/a/a",
				})
				jestExpect(match(fixtures, "a/*", Object.assign({}, opts, { windows = false }))).toEqual({
					"a/b",
					"a/x",
					"a/a",
					"a/c",
				})
				jestExpect(match(fixtures, "a/*/*", Object.assign({}, opts, { windows = false }))).toEqual({
					"a/a/a",
					"a/a/b",
				})
				jestExpect(match(fixtures, "a/*/*/*", Object.assign({}, opts, { windows = false }))).toEqual({
					"a/a/a/a",
				})
				jestExpect(match(fixtures, "a/*/*/*/*", Object.assign({}, opts, { windows = false }))).toEqual({
					"a/a/a/a/a",
				})
				jestExpect(match(fixtures, "a/*/a", Object.assign({}, opts, { windows = false }))).toEqual({ "a/a/a" })
			end)
		end)

		describe("windows", function()
			itFIXME("should convert file paths to posix slashes", function()
				jestExpect(match({ "a\\b\\c.md" }, "**/*.md")).toEqual({ "a/b/c.md" })
				jestExpect(match({ "a\\b\\c.md" }, "**/*.md", { windows = false })).toEqual({ "a\\b\\c.md" })
			end)

			itFIXME("should convert absolute paths to posix slashes", function()
				jestExpect(match({ "E:\\a\\b\\c.md" }, "E:/**/*.md")).toEqual({ "E:/a/b/c.md" })
				jestExpect(match({ "E:\\a\\b\\c.md" }, "E:/**/*.md", { windows = false })).toEqual({})
			end)
		end)
	end)
end
