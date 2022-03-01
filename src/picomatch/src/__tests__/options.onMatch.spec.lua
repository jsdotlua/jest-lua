-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/options.onMatch.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent
	local Packages = PicomatchModule.Parent
	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Array = LuauPolyfill.Array
	local String = LuauPolyfill.String

	local jestExpect = require(Packages.Dev.Expect)

	local match = require(CurrentModule.support.match)
	local picomatch = require(PicomatchModule)
	local isMatch = picomatch.isMatch
	local function equal(actual, expected)
		jestExpect(Array.sort(Array.concat({}, actual))).toEqual(
			Array.sort(Array.concat({}, expected))
			-- ROBLOX deviation: jestExpect doesn't accept message
		)
	end
	local function format(str: string)
		return str:gsub("^%./", "")
	end
	local function options()
		return {
			format = format,
			onMatch = function(ref, matches)
				local _pattern, _regex, _input, output: string = ref.pattern, ref.regex, ref.input, ref.output
				if #output > 2 and (String.startsWith(output, "./") or String.startsWith(output, ".\\")) then
					output = String.slice(output, 2)
				end
				if matches ~= nil then
					matches:add(output)
				end
			end,
		}
	end
	describe("options.onMatch", function()
		it("should call options.onMatch on each matching string", function()
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
			assert(not isMatch("./.a", "*.a", { format = format }))
			assert(not isMatch("./.a", "./*.a", { format = format }))
			assert(not isMatch("./.a", "a/**/z/*.md", { format = format }))
			assert(not isMatch("./a/b/c/d/e/z/c.md", "./a/**/j/**/z/*.md", { format = format }))
			assert(not isMatch("./a/b/c/j/e/z/c.txt", "./a/**/j/**/z/*.md", { format = format }))
			assert(not isMatch("a/b/c/d/e/z/c.md", "./a/**/j/**/z/*.md", { format = format }))
			assert(isMatch("./.a", "./.a", { format = format }))
			assert(isMatch("./a/b/c.md", "a/**/*.md", { format = format }))
			assert(isMatch("./a/b/c/d/e/j/n/p/o/z/c.md", "./a/**/j/**/z/*.md", { format = format }))
			assert(isMatch("./a/b/c/d/e/z/c.md", "**/*.md", { format = format }))
			assert(isMatch("./a/b/c/d/e/z/c.md", "./a/**/z/*.md", { format = format }))
			assert(isMatch("./a/b/c/d/e/z/c.md", "a/**/z/*.md", { format = format }))
			assert(isMatch("./a/b/c/j/e/z/c.md", "./a/**/j/**/z/*.md", { format = format }))
			assert(isMatch("./a/b/c/j/e/z/c.md", "a/**/j/**/z/*.md", { format = format }))
			assert(isMatch("./a/b/z/.a", "./a/**/z/.a", { format = format }))
			assert(isMatch("./a/b/z/.a", "a/**/z/.a", { format = format }))
			assert(isMatch(".a", "./.a", { format = format }))
			assert(isMatch("a/b/c.md", "./a/**/*.md", { format = format }))
			assert(isMatch("a/b/c.md", "a/**/*.md", { format = format }))
			assert(isMatch("a/b/c/d/e/z/c.md", "a/**/z/*.md", { format = format }))
			assert(isMatch("a/b/c/j/e/z/c.md", "a/**/j/**/z/*.md", { format = format }))
			equal(match(fixtures, "*", options()), { "a", "b" })
			equal(
				match(fixtures, "**/a/**", options()),
				{ "a", "a/a", "a/c", "a/b", "a/x", "a/a/a", "a/a/b", "a/a/a/a", "a/a/a/a/a" }
			)
			equal(match(fixtures, "*/*", options()), { "a/a", "a/b", "a/c", "a/x", "x/y", "z/z" })
			equal(match(fixtures, "*/*/*", options()), { "a/a/a", "a/a/b" })
			equal(match(fixtures, "*/*/*/*", options()), { "a/a/a/a" })
			equal(match(fixtures, "*/*/*/*/*", options()), { "a/a/a/a/a" })
			equal(match(fixtures, "./*", options()), { "a", "b" })
			equal(
				match(fixtures, "./**/a/**", options()),
				{ "a", "a/a", "a/b", "a/c", "a/x", "a/a/a", "a/a/b", "a/a/a/a", "a/a/a/a/a" }
			)
			equal(match(fixtures, "./a/*/a", options()), { "a/a/a" })
			equal(match(fixtures, "a/*", options()), { "a/a", "a/b", "a/c", "a/x" })
			equal(match(fixtures, "a/*/*", options()), { "a/a/a", "a/a/b" })
			equal(match(fixtures, "a/*/*/*", options()), { "a/a/a/a" })
			equal(match(fixtures, "a/*/*/*/*", options()), { "a/a/a/a/a" })
			equal(match(fixtures, "a/*/a", options()), { "a/a/a" })
		end)
	end)
end
