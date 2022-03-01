-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/posix-classes.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent
	local Packages = PicomatchModule.Parent

	local RegExp = require(Packages.RegExp)

	local jestExpect = require(Packages.Dev.Expect)

	local pm = require(PicomatchModule)
	local makeRe, parse = pm.makeRe, pm.parse
	local opts = { strictSlashes = true, posix = true, regex = true }
	local function isMatch(...: any)
		local args = { ... }
		table.insert(args, opts)
		return pm.isMatch(table.unpack(args))
	end
	local function convert(...: any)
		local args = { ... }
		table.insert(args, opts)
		local state = parse(table.unpack(args))
		return state.output
	end
	describe("posix classes", function()
		describe("posix bracket type conversion", function()
			itFIXME("should create regex character classes from POSIX bracket expressions:", function()
				jestExpect(convert("foo[[:lower:]]bar")).toEqual("foo[a-z]bar")
				jestExpect(convert("foo[[:lower:][:upper:]]bar")).toEqual("foo[a-zA-Z]bar")
				jestExpect(convert("[[:alpha:]123]")).toEqual("(?=.)[a-zA-Z123]")
				jestExpect(convert("[[:lower:]]")).toEqual("(?=.)[a-z]")
				jestExpect(convert("[![:lower:]]")).toEqual("(?=.)[^a-z]")
				jestExpect(convert("[[:digit:][:upper:][:space:]]")).toEqual("(?=.)[0-9A-Z \\t\\r\\n\\v\\f]")
				jestExpect(convert("[[:xdigit:]]"), "(?=.)[A-Fa-f0-9]")
				jestExpect(
					convert(
						"[[:alnum:][:alpha:][:blank:][:cntrl:][:digit:][:graph:][:lower:][:print:][:punct:][:space:][:upper:][:xdigit:]]"
					)
				).toEqual(
					"(?=.)[a-zA-Z0-9a-zA-Z \\t\\x00-\\x1F\\x7F0-9\\x21-\\x7Ea-z\\x20-\\x7E \\-!\"#$%&'()\\*+,./:;<=>?@[\\]^_`{|}~ \\t\\r\\n\\v\\fA-ZA-Fa-f0-9]"
				)
				jestExpect(
					convert("[^[:alnum:][:alpha:][:blank:][:cntrl:][:digit:][:lower:][:space:][:upper:][:xdigit:]]")
				).toEqual("(?=.)[^a-zA-Z0-9a-zA-Z \\t\\x00-\\x1F\\x7F0-9a-z \\t\\r\\n\\v\\fA-ZA-Fa-f0-9]")
				jestExpect(convert("[a-c[:digit:]x-z]")).toEqual("(?=.)[a-c0-9x-z]")
				jestExpect(convert("[_[:alpha:]][_[:alnum:]][_[:alnum:]]*")).toEqual(
					"(?=.)[_a-zA-Z][_a-zA-Z0-9][_a-zA-Z0-9]*",
					{}
				)
			end)
		end)

		describe(".isMatch", function()
			itFIXME("should support POSIX.2 character classes", function()
				assert(isMatch("e", "[[:xdigit:]]"))
				assert(isMatch("a", "[[:alpha:]123]"))
				assert(isMatch("1", "[[:alpha:]123]"))
				assert(not isMatch("5", "[[:alpha:]123]"))
				assert(isMatch("A", "[[:alpha:]123]"))
				assert(isMatch("A", "[[:alpha:]]"))
				assert(not isMatch("9", "[[:alpha:]]"))
				assert(isMatch("b", "[[:alpha:]]"))
				assert(not isMatch("A", "[![:alpha:]]"))
				assert(isMatch("9", "[![:alpha:]]"))
				assert(not isMatch("b", "[![:alpha:]]"))
				assert(not isMatch("A", "[^[:alpha:]]"))
				assert(isMatch("9", "[^[:alpha:]]"))
				assert(not isMatch("b", "[^[:alpha:]]"))
				assert(not isMatch("A", "[[:digit:]]"))
				assert(isMatch("9", "[[:digit:]]"))
				assert(not isMatch("b", "[[:digit:]]"))
				assert(isMatch("A", "[^[:digit:]]"))
				assert(not isMatch("9", "[^[:digit:]]"))
				assert(isMatch("b", "[^[:digit:]]"))
				assert(isMatch("A", "[![:digit:]]"))
				assert(not isMatch("9", "[![:digit:]]"))
				assert(isMatch("b", "[![:digit:]]"))
				assert(isMatch("a", "[[:lower:]]"))
				assert(not isMatch("A", "[[:lower:]]"))
				assert(not isMatch("9", "[[:lower:]]"))
				assert(isMatch("a", "[:alpha:]"), "invalid posix bracket, but valid char class")
				assert(isMatch("l", "[:alpha:]"), "invalid posix bracket, but valid char class")
				assert(isMatch("p", "[:alpha:]"), "invalid posix bracket, but valid char class")
				assert(isMatch("h", "[:alpha:]"), "invalid posix bracket, but valid char class")
				assert(isMatch(":", "[:alpha:]"), "invalid posix bracket, but valid char class")
				assert(not isMatch("b", "[:alpha:]")("invalid posix bracket, but valid char class"))
			end)

			itFIXME("should support multiple posix brackets in one character class", function()
				assert(isMatch("9", "[[:lower:][:digit:]]"))
				assert(isMatch("a", "[[:lower:][:digit:]]"))
				assert(not isMatch("A", "[[:lower:][:digit:]]"))
				assert(not isMatch("aa", "[[:lower:][:digit:]]"))
				assert(not isMatch("99", "[[:lower:][:digit:]]"))
				assert(not isMatch("a9", "[[:lower:][:digit:]]"))
				assert(not isMatch("9a", "[[:lower:][:digit:]]"))
				assert(not isMatch("aA", "[[:lower:][:digit:]]"))
				assert(not isMatch("9A", "[[:lower:][:digit:]]"))
				assert(isMatch("aa", "[[:lower:][:digit:]]+"))
				assert(isMatch("99", "[[:lower:][:digit:]]+"))
				assert(isMatch("a9", "[[:lower:][:digit:]]+"))
				assert(isMatch("9a", "[[:lower:][:digit:]]+"))
				assert(not isMatch("aA", "[[:lower:][:digit:]]+"))
				assert(not isMatch("9A", "[[:lower:][:digit:]]+"))
				assert(isMatch("a", "[[:lower:][:digit:]]*"))
				assert(not isMatch("A", "[[:lower:][:digit:]]*"))
				assert(not isMatch("AA", "[[:lower:][:digit:]]*"))
				assert(isMatch("aa", "[[:lower:][:digit:]]*"))
				assert(isMatch("aaa", "[[:lower:][:digit:]]*"))
				assert(isMatch("999", "[[:lower:][:digit:]]*"))
			end)

			itFIXME("should match word characters", function()
				assert(not isMatch("a c", "a[[:word:]]+c"))
				assert(not isMatch("a.c", "a[[:word:]]+c"))
				assert(not isMatch("a.xy.zc", "a[[:word:]]+c"))
				assert(not isMatch("a.zc", "a[[:word:]]+c"))
				assert(not isMatch("abq", "a[[:word:]]+c"))
				assert(not isMatch("axy zc", "a[[:word:]]+c"))
				assert(not isMatch("axy", "a[[:word:]]+c"))
				assert(not isMatch("axy.zc", "a[[:word:]]+c"))
				assert(isMatch("a123c", "a[[:word:]]+c"))
				assert(isMatch("a1c", "a[[:word:]]+c"))
				assert(isMatch("abbbbc", "a[[:word:]]+c"))
				assert(isMatch("abbbc", "a[[:word:]]+c"))
				assert(isMatch("abbc", "a[[:word:]]+c"))
				assert(isMatch("abc", "a[[:word:]]+c"))
				assert(not isMatch("a c", "a[[:word:]]+"))
				assert(not isMatch("a.c", "a[[:word:]]+"))
				assert(not isMatch("a.xy.zc", "a[[:word:]]+"))
				assert(not isMatch("a.zc", "a[[:word:]]+"))
				assert(not isMatch("axy zc", "a[[:word:]]+"))
				assert(not isMatch("axy.zc", "a[[:word:]]+"))
				assert(isMatch("a123c", "a[[:word:]]+"))
				assert(isMatch("a1c", "a[[:word:]]+"))
				assert(isMatch("abbbbc", "a[[:word:]]+"))
				assert(isMatch("abbbc", "a[[:word:]]+"))
				assert(isMatch("abbc", "a[[:word:]]+"))
				assert(isMatch("abc", "a[[:word:]]+"))
				assert(isMatch("abq", "a[[:word:]]+"))
				assert(isMatch("axy", "a[[:word:]]+"))
				assert(isMatch("axyzc", "a[[:word:]]+"))
				assert(isMatch("axyzc", "a[[:word:]]+"))
			end)

			itFIXME("should not create an invalid posix character class:", function()
				jestExpect(convert("[:al:]")).toEqual("(?:\\[:al:\\]|[:al:])")
				jestExpect(convert("[abc[:punct:][0-9]")).toEqual(
					"(?=.)[abc\\-!\"#$%&'()\\*+,./:;<=>?@[\\]^_`{|}~\\[0-9]"
				)
			end)

			itFIXME("should return `true` when the pattern matches:", function()
				assert(isMatch("a", "[[:lower:]]"))
				assert(isMatch("A", "[[:upper:]]"))
				assert(isMatch("A", "[[:digit:][:upper:][:space:]]"))
				assert(isMatch("1", "[[:digit:][:upper:][:space:]]"))
				assert(isMatch(" ", "[[:digit:][:upper:][:space:]]"))
				assert(isMatch("5", "[[:xdigit:]]"))
				assert(isMatch("f", "[[:xdigit:]]"))
				assert(isMatch("D", "[[:xdigit:]]"))
				assert(
					isMatch(
						"_",
						"[[:alnum:][:alpha:][:blank:][:cntrl:][:digit:][:graph:][:lower:][:print:][:punct:][:space:][:upper:][:xdigit:]]"
					)
				)
				assert(
					isMatch(
						"_",
						"[[:alnum:][:alpha:][:blank:][:cntrl:][:digit:][:graph:][:lower:][:print:][:punct:][:space:][:upper:][:xdigit:]]"
					)
				)
				assert(
					isMatch(
						".",
						"[^[:alnum:][:alpha:][:blank:][:cntrl:][:digit:][:lower:][:space:][:upper:][:xdigit:]]"
					)
				)
				assert(isMatch("5", "[a-c[:digit:]x-z]"))
				assert(isMatch("b", "[a-c[:digit:]x-z]"))
				assert(isMatch("y", "[a-c[:digit:]x-z]"))
			end)

			itFIXME("should return `false` when the pattern does not match:", function()
				assert(not isMatch("A", "[[:lower:]]"))
				assert(isMatch("A", "[![:lower:]]"))
				assert(not isMatch("a", "[[:upper:]]"))
				assert(not isMatch("a", "[[:digit:][:upper:][:space:]]"))
				assert(not isMatch(".", "[[:digit:][:upper:][:space:]]"))
				assert(
					not isMatch(
						".",
						"[[:alnum:][:alpha:][:blank:][:cntrl:][:digit:][:lower:][:space:][:upper:][:xdigit:]]"
					)
				)
				assert(not isMatch("q", "[a-c[:digit:]x-z]"))
			end)
		end)

		describe("literals", function()
			itFIXME("should match literal brackets when escaped", function()
				assert(isMatch("a [b]", "a [b]"))
				assert(isMatch("a b", "a [b]"))
				assert(isMatch("a [b] c", "a [b] c"))
				assert(isMatch("a b c", "a [b] c"))
				assert(isMatch("a [b]", "a \\[b\\]"))
				assert(not isMatch("a b", "a \\[b\\]"))
				assert(isMatch("a [b]", "a ([b])"))
				assert(isMatch("a b", "a ([b])"))
				assert(isMatch("a b", "a (\\[b\\]|[b])"))
				assert(isMatch("a [b]", "a (\\[b\\]|[b])"))
			end)
		end)

		describe(".makeRe()", function()
			itFIXME("should make a regular expression for the given pattern:", function()
				jestExpect(makeRe("[[:alpha:]123]", opts)).toEqual(RegExp("/^(?:(?=.)[a-zA-Z123])$/"))
				jestExpect(makeRe("[![:lower:]]", opts)).toEqual(RegExp("/^(?:(?=.)[^a-z])$/"))
			end)
		end)

		describe("POSIX: From the test suite for the POSIX.2 (BRE) pattern matching code:", function()
			itFIXME("First, test POSIX.2 character classes", function()
				assert(isMatch("e", "[[:xdigit:]]"))
				assert(isMatch("1", "[[:xdigit:]]"))
				assert(isMatch("a", "[[:alpha:]123]"))
				assert(isMatch("1", "[[:alpha:]123]"))
			end)

			itFIXME("should match using POSIX.2 negation patterns", function()
				assert(isMatch("9", "[![:alpha:]]"))
				assert(isMatch("9", "[^[:alpha:]]"))
			end)

			itFIXME("should match word characters", function()
				assert(isMatch("A", "[[:word:]]"))
				assert(isMatch("B", "[[:word:]]"))
				assert(isMatch("a", "[[:word:]]"))
				assert(isMatch("b", "[[:word:]]"))
			end)

			itFIXME("should match digits with word class", function()
				assert(isMatch("1", "[[:word:]]"))
				assert(isMatch("2", "[[:word:]]"))
			end)

			itFIXME("should not digits", function()
				assert(isMatch("1", "[[:digit:]]"))
				assert(isMatch("2", "[[:digit:]]"))
			end)

			it("should not match word characters with digit class", function()
				assert(not isMatch("a", "[[:digit:]]"))
				assert(not isMatch("A", "[[:digit:]]"))
			end)

			itFIXME("should match uppercase alpha characters", function()
				assert(isMatch("A", "[[:upper:]]"))
				assert(isMatch("B", "[[:upper:]]"))
			end)

			itFIXME("should not match lowercase alpha characters", function()
				assert(not isMatch("a", "[[:upper:]]"))
				assert(not isMatch("b", "[[:upper:]]"))
			end)

			it("should not match digits with upper class", function()
				assert(not isMatch("1", "[[:upper:]]"))
				assert(not isMatch("2", "[[:upper:]]"))
			end)

			itFIXME("should match lowercase alpha characters", function()
				assert(isMatch("a", "[[:lower:]]"))
				assert(isMatch("b", "[[:lower:]]"))
			end)

			it("should not match uppercase alpha characters", function()
				assert(not isMatch("A", "[[:lower:]]"))
				assert(not isMatch("B", "[[:lower:]]"))
			end)

			itFIXME("should match one lower and one upper character", function()
				assert(isMatch("aA", "[[:lower:]][[:upper:]]"))
				assert(not isMatch("AA", "[[:lower:]][[:upper:]]"))
				assert(not isMatch("Aa", "[[:lower:]][[:upper:]]"))
			end)

			itFIXME("should match hexadecimal digits", function()
				assert(isMatch("ababab", "[[:xdigit:]]*"))
				assert(isMatch("020202", "[[:xdigit:]]*"))
				assert(isMatch("900", "[[:xdigit:]]*"))
			end)

			itFIXME("should match punctuation characters (\\-!\"#$%&'()\\*+,./:;<=>?@[\\]^_`{|}~)", function()
				assert(isMatch("!", "[[:punct:]]"))
				assert(isMatch("?", "[[:punct:]]"))
				assert(isMatch("#", "[[:punct:]]"))
				assert(isMatch("&", "[[:punct:]]"))
				assert(isMatch("@", "[[:punct:]]"))
				assert(isMatch("+", "[[:punct:]]"))
				assert(isMatch("*", "[[:punct:]]"))
				assert(isMatch(":", "[[:punct:]]"))
				assert(isMatch("=", "[[:punct:]]"))
				assert(isMatch("|", "[[:punct:]]"))
				assert(isMatch("|++", "[[:punct:]]*"))
			end)

			it("should only match one character", function()
				assert(not isMatch("?*+", "[[:punct:]]"))
			end)

			itFIXME("should only match zero or more punctuation characters", function()
				assert(isMatch("?*+", "[[:punct:]]*"))
				assert(isMatch("foo", "foo[[:punct:]]*"))
				assert(isMatch("foo?*+", "foo[[:punct:]]*"))
			end)

			itFIXME("invalid character class expressions are just characters to be matched", function()
				assert(isMatch("a", "[:al:]"))
				assert(isMatch("a", "[[:al:]"))
				assert(isMatch("!", "[abc[:punct:][0-9]"))
			end)

			itFIXME("should match the start of a valid sh identifier", function()
				assert(isMatch("PATH", "[_[:alpha:]]*"))
			end)

			itFIXME("should match the first two characters of a valid sh identifier", function()
				assert(isMatch("PATH", "[_[:alpha:]][_[:alnum:]]*"))
			end)

			itFIXME("should match multiple posix classses", function()
				assert(isMatch("a1B", "[[:alpha:]][[:digit:]][[:upper:]]"))
				assert(not isMatch("a1b", "[[:alpha:]][[:digit:]][[:upper:]]"))
				assert(isMatch(".", "[[:digit:][:punct:][:space:]]"))
				assert(not isMatch("a", "[[:digit:][:punct:][:space:]]"))
				assert(isMatch("!", "[[:digit:][:punct:][:space:]]"))
				assert(not isMatch("!", "[[:digit:]][[:punct:]][[:space:]]"))
				assert(isMatch("1! ", "[[:digit:]][[:punct:]][[:space:]]"))
				assert(not isMatch("1!  ", "[[:digit:]][[:punct:]][[:space:]]"))
			end)

			--[[*
    		 * Some of these tests (and their descriptions) were ported directly
    		 * from the Bash 4.3 unit tests.
    		 ]]
			itFIXME("how about A?", function()
				assert(isMatch("9", "[[:digit:]]"))
				assert(not isMatch("X", "[[:digit:]]"))
				assert(isMatch("aB", "[[:lower:]][[:upper:]]"))
				assert(isMatch("a", "[[:alpha:][:digit:]]"))
				assert(isMatch("3", "[[:alpha:][:digit:]]"))
				assert(not isMatch("aa", "[[:alpha:][:digit:]]"))
				assert(not isMatch("a3", "[[:alpha:][:digit:]]"))
				assert(not isMatch("a", "[[:alpha:]\\]"))
				assert(not isMatch("b", "[[:alpha:]\\]"))
			end)

			itFIXME("OK, what's a tab?  is it a blank? a space?", function()
				assert(isMatch("\t", "[[:blank:]]"))
				assert(isMatch("\t", "[[:space:]]"))
				assert(isMatch(" ", "[[:space:]]"))
			end)

			it("let's check out characters in the ASCII range", function()
				assert(not isMatch("\\377", "[[:ascii:]]"))
				assert(not isMatch("9", "[1[:alpha:]123]"))
			end)

			it("punctuation", function()
				assert(not isMatch(" ", "[[:punct:]]"))
			end)

			itFIXME("graph", function()
				assert(isMatch("A", "[[:graph:]]"))
				assert(not isMatch("\\b", "[[:graph:]]"))
				assert(not isMatch("\\n", "[[:graph:]]"))
				assert(not isMatch("\\s", "[[:graph:]]"))
			end)
		end)
	end)
end
