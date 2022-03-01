-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/options.format.js

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
	local function equal(actual, expected)
		jestExpect(Array.sort(Array.concat({}, actual))).toEqual(
			Array.sort(Array.concat({}, expected))
			-- ROBLOX deviation: jestExpect doesn't accept message
		)
	end
	describe("options.format", function()
		-- see https://github.com/isaacs/minimatch/issues/30
		it("should match the string returned by options.format", function()
			local opts = {
				format = function(str)
					return str:gsub("\\", "/"):gsub("^%./", "")
				end,
				strictSlashes = true,
			}
			local fixtures = {
				"a",
				"./a",
				"b",
				"a/a",
				"./a/b",
				"a/c",
				"./a/x",
				"./a/a/a",
				"a/a/b",
				"./a/a/a/a",
				"./a/a/a/a/a",
				"x/y",
				"./z/z",
			}
			assert(not isMatch("./.a", "*.a", opts))
			assert(not isMatch("./.a", "./*.a", opts))
			assert(not isMatch("./.a", "a/**/z/*.md", opts))
			assert(not isMatch("./a/b/c/d/e/z/c.md", "./a/**/j/**/z/*.md", opts))
			assert(not isMatch("./a/b/c/j/e/z/c.txt", "./a/**/j/**/z/*.md", opts))
			assert(not isMatch("a/b/c/d/e/z/c.md", "./a/**/j/**/z/*.md", opts))
			assert(isMatch("./.a", "./.a", opts))
			assert(isMatch("./a/b/c.md", "a/**/*.md", opts))
			assert(isMatch("./a/b/c/d/e/j/n/p/o/z/c.md", "./a/**/j/**/z/*.md", opts))
			assert(isMatch("./a/b/c/d/e/z/c.md", "**/*.md", opts))
			assert(isMatch("./a/b/c/d/e/z/c.md", "./a/**/z/*.md", opts))
			assert(isMatch("./a/b/c/d/e/z/c.md", "a/**/z/*.md", opts))
			assert(isMatch("./a/b/c/j/e/z/c.md", "./a/**/j/**/z/*.md", opts))
			assert(isMatch("./a/b/c/j/e/z/c.md", "a/**/j/**/z/*.md", opts))
			assert(isMatch("./a/b/z/.a", "./a/**/z/.a", opts))
			assert(isMatch("./a/b/z/.a", "a/**/z/.a", opts))
			assert(isMatch(".a", "./.a", opts))
			assert(isMatch("a/b/c.md", "./a/**/*.md", opts))
			assert(isMatch("a/b/c.md", "a/**/*.md", opts))
			assert(isMatch("a/b/c/d/e/z/c.md", "a/**/z/*.md", opts))
			assert(isMatch("a/b/c/j/e/z/c.md", "a/**/j/**/z/*.md", opts))
			assert(isMatch("./a", "*", opts))
			assert(isMatch("./foo/bar.js", "**/foo/**", opts))
			assert(isMatch("./foo/bar.js", "./**/foo/**", opts))
			assert(isMatch(".\\foo\\bar.js", "**/foo/**", Object.assign({}, opts, { windows = false })))
			assert(isMatch(".\\foo\\bar.js", "./**/foo/**", opts))
			equal(match(fixtures, "*", opts), { "a", "b" })
			equal(
				match(fixtures, "**/a/**", opts),
				{ "a/a", "a/c", "a/b", "a/x", "a/a/a", "a/a/b", "a/a/a/a", "a/a/a/a/a" }
			)
			equal(match(fixtures, "*/*", opts), { "a/a", "a/b", "a/c", "a/x", "x/y", "z/z" })
			equal(match(fixtures, "*/*/*", opts), { "a/a/a", "a/a/b" })
			equal(match(fixtures, "*/*/*/*", opts), { "a/a/a/a" })
			equal(match(fixtures, "*/*/*/*/*", opts), { "a/a/a/a/a" })
			equal(match(fixtures, "*", opts), { "a", "b" })
			equal(
				match(fixtures, "**/a/**", opts),
				{ "a/a", "a/c", "a/b", "a/x", "a/a/a", "a/a/b", "a/a/a/a", "a/a/a/a/a" }
			)
			equal(match(fixtures, "a/*/a", opts), { "a/a/a" })
			equal(match(fixtures, "a/*", opts), { "a/a", "a/b", "a/c", "a/x" })
			equal(match(fixtures, "a/*/*", opts), { "a/a/a", "a/a/b" })
			equal(match(fixtures, "a/*/*/*", opts), { "a/a/a/a" })
			equal(match(fixtures, "a/*/*/*/*", opts), { "a/a/a/a/a" })
			equal(match(fixtures, "a/*/a", opts), { "a/a/a" })
		end)
	end)
end
