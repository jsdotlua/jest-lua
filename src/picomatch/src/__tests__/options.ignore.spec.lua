-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/options.ignore.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent
	local Packages = PicomatchModule.Parent
	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Array = LuauPolyfill.Array
	local Object = LuauPolyfill.Object

	local jestExpect = require(Packages.Dev.Expect)

	local match = require(CurrentModule.support.match)
	local isMatch = require(PicomatchModule).isMatch
	describe("options.ignore", function()
		it("should not match ignored patterns", function()
			assert(isMatch("a+b/src/glimini.js", "a+b/src/*.js", { ignore = { "**/f*" } }))
			assert(not isMatch("a+b/src/glimini.js", "a+b/src/*.js", { ignore = { "**/g*" } }))
			assert(isMatch("+b/src/glimini.md", "+b/src/*", { ignore = { "**/*.js" } }))
			assert(not isMatch("+b/src/glimini.js", "+b/src/*", { ignore = { "**/*.js" } }))
		end)
		local negations = { "a/a", "a/b", "a/c", "a/d", "a/e", "b/a", "b/b", "b/c" }
		local globs = Array.sort({
			".a",
			".a/a",
			".a/a/a",
			".a/a/a/a",
			"a",
			"a/.a",
			"a/a",
			"a/a/.a",
			"a/a/a",
			"a/a/a/a",
			"a/a/a/a/a",
			"a/a/b",
			"a/b",
			"a/b/c",
			"a/c",
			"a/x",
			"b",
			"b/b/b",
			"b/b/c",
			"c/c/c",
			"e/f/g",
			"h/i/a",
			"x/x/x",
			"x/y",
			"z/z",
			"z/z/z",
		})
		it("should filter out ignored patterns", function()
			local opts = { ignore = { "a/**" }, strictSlashes = true }
			local dotOpts = Object.assign({}, opts, { dot = true })
			jestExpect(match(globs, "*", opts)).toEqual({ "a", "b" })
			jestExpect(match(globs, "*", Object.assign({}, opts, { strictSlashes = false }))).toEqual({ "b" })
			jestExpect(match(globs, "*", { ignore = "**/a" })).toEqual({ "b" })
			jestExpect(match(globs, "*/*", opts)).toEqual({ "x/y", "z/z" })
			jestExpect(match(globs, "*/*/*", opts)).toEqual({
				"b/b/b",
				"b/b/c",
				"c/c/c",
				"e/f/g",
				"h/i/a",
				"x/x/x",
				"z/z/z",
			})
			jestExpect(match(globs, "*/*/*/*", opts)).toEqual({})
			jestExpect(match(globs, "*/*/*/*/*", opts)).toEqual({})
			jestExpect(match(globs, "a/*", opts)).toEqual({})
			jestExpect(match(globs, "**/*/x", opts)).toEqual({ "x/x/x" })
			-- ROBLOX FIXME
			-- jestExpect(match(globs, "**/*/[b-z]", opts)).toEqual({
			-- 	"b/b/b",
			-- 	"b/b/c",
			-- 	"c/c/c",
			-- 	"e/f/g",
			-- 	"x/x/x",
			-- 	"x/y",
			-- 	"z/z",
			-- 	"z/z/z",
			-- })
			jestExpect(match(globs, "*", { ignore = "**/a", dot = true })).toEqual({ ".a", "b" })
			jestExpect(match(globs, "*", dotOpts)).toEqual({ ".a", "a", "b" })
			jestExpect(match(globs, "*/*", dotOpts)).toEqual(Array.sort({ ".a/a", "x/y", "z/z" }))
			jestExpect(match(globs, "*/*/*", dotOpts)).toEqual(
				Array.sort({ ".a/a/a", "b/b/b", "b/b/c", "c/c/c", "e/f/g", "h/i/a", "x/x/x", "z/z/z" })
			)
			jestExpect(match(globs, "*/*/*/*", dotOpts)).toEqual({ ".a/a/a/a" })
			jestExpect(match(globs, "*/*/*/*/*", dotOpts)).toEqual({})
			jestExpect(match(globs, "a/*", dotOpts)).toEqual({})
			jestExpect(match(globs, "**/*/x", dotOpts)).toEqual({ "x/x/x" }) -- see https://github.com/jonschlinkert/micromatch/issues/79
			jestExpect(match({ "foo.js", "a/foo.js" }, "**/foo.js")).toEqual({ "foo.js", "a/foo.js" })
			jestExpect(match({ "foo.js", "a/foo.js" }, "**/foo.js", { dot = true })).toEqual({ "foo.js", "a/foo.js" })
			jestExpect(match(negations, "!b/a", opts)).toEqual({ "b/b", "b/c" })
			jestExpect(match(negations, "!b/(a)", opts)).toEqual({ "b/b", "b/c" })
			jestExpect(match(negations, "!(b/(a))", opts)).toEqual({ "b/b", "b/c" })
			jestExpect(match(negations, "!(b/a)", opts)).toEqual({ "b/b", "b/c" })
			jestExpect(match(negations, "**")).toEqual(
				negations
				-- ROBLOX deviation: jestExpect doesn't accept message argument
				-- , "nothing is ignored"
			)
			jestExpect(match(negations, "**", { ignore = { "*/b", "*/a" } })).toEqual({ "a/c", "a/d", "a/e", "b/c" })
			jestExpect(match(negations, "**", { ignore = { "**" } })).toEqual({})
		end)
	end)
end
