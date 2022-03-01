-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/extglobs-bash.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent

	local support = require(CurrentModule.support)
	local isMatch = require(PicomatchModule).isMatch
	--[[*
	 * Some of tests were converted from bash 4.3, 4.4, and minimatch unit tests.
	 ]]
	describe("extglobs (bash)", function()
		beforeEach(function()
			return support.windowsPathSep()
		end)
		afterEach(function()
			return support.resetPathSep()
		end)

		it('should not match empty string with "*(0|1|3|5|7|9)"', function()
			assert(not isMatch("", "*(0|1|3|5|7|9)", { bash = true }))
		end)

		it('"*(a|b[)" should not match "*(a|b\\[)"', function()
			assert(not isMatch("*(a|b[)", "*(a|b\\[)", { bash = true }))
		end)

		it('"*(a|b[)" should not match "\\*\\(a|b\\[\\)"', function()
			assert(not isMatch("*(a|b[)", "\\*\\(a|b\\[\\)", { bash = true }))
		end)

		it('"***" should match "\\*\\*\\*"', function()
			assert(isMatch("***", "\\*\\*\\*", { bash = true }))
		end)

		it(
			'"-adobe-courier-bold-o-normal--12-120-75-75-/-70-iso8859-1" should not match "-*-*-*-*-*-*-12-*-*-*-m-*-*-*"',
			function()
				assert(
					not isMatch(
						"-adobe-courier-bold-o-normal--12-120-75-75-/-70-iso8859-1",
						"-*-*-*-*-*-*-12-*-*-*-m-*-*-*",
						{ bash = true }
					)
				)
			end
		)
		it(
			'"-adobe-courier-bold-o-normal--12-120-75-75-m-70-iso8859-1" should match "-*-*-*-*-*-*-12-*-*-*-m-*-*-*"',
			function()
				assert(
					isMatch(
						"-adobe-courier-bold-o-normal--12-120-75-75-m-70-iso8859-1",
						"-*-*-*-*-*-*-12-*-*-*-m-*-*-*",
						{ bash = true }
					)
				)
			end
		)
		it(
			'"-adobe-courier-bold-o-normal--12-120-75-75-X-70-iso8859-1" should not match "-*-*-*-*-*-*-12-*-*-*-m-*-*-*"',
			function()
				assert(
					not isMatch(
						"-adobe-courier-bold-o-normal--12-120-75-75-X-70-iso8859-1",
						"-*-*-*-*-*-*-12-*-*-*-m-*-*-*",
						{ bash = true }
					)
				)
			end
		)
		it('"/dev/udp/129.22.8.102/45" should match "/dev\\/@(tcp|udp)\\/*\\/*"', function()
			assert(isMatch("/dev/udp/129.22.8.102/45", "/dev\\/@(tcp|udp)\\/*\\/*", { bash = true }))
		end)

		it('"/x/y/z" should match "/x/y/z"', function()
			assert(isMatch("/x/y/z", "/x/y/z", { bash = true }))
		end)

		itFIXME('"0377" should match "+([0-7])"', function()
			assert(isMatch("0377", "+([0-7])", { bash = true }))
		end)

		itFIXME('"07" should match "+([0-7])"', function()
			assert(isMatch("07", "+([0-7])", { bash = true }))
		end)

		it('"09" should not match "+([0-7])"', function()
			assert(not isMatch("09", "+([0-7])", { bash = true }))
		end)

		itFIXME('"1" should match "0|[1-9]*([0-9])"', function()
			assert(isMatch("1", "0|[1-9]*([0-9])", { bash = true }))
		end)

		itFIXME('"12" should match "0|[1-9]*([0-9])"', function()
			assert(isMatch("12", "0|[1-9]*([0-9])", { bash = true }))
		end)

		it('"123abc" should not match "(a+|b)*"', function()
			assert(not isMatch("123abc", "(a+|b)*", { bash = true }))
		end)

		it('"123abc" should not match "(a+|b)+"', function()
			assert(not isMatch("123abc", "(a+|b)+", { bash = true }))
		end)

		it('"123abc" should match "*?(a)bc"', function()
			assert(isMatch("123abc", "*?(a)bc", { bash = true }))
		end)

		it('"123abc" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("123abc", "a(b*(foo|bar))d", { bash = true }))
		end)

		it('"123abc" should not match "ab*(e|f)"', function()
			assert(not isMatch("123abc", "ab*(e|f)", { bash = true }))
		end)

		it('"123abc" should not match "ab**"', function()
			assert(not isMatch("123abc", "ab**", { bash = true }))
		end)

		it('"123abc" should not match "ab**(e|f)"', function()
			assert(not isMatch("123abc", "ab**(e|f)", { bash = true }))
		end)

		it('"123abc" should not match "ab**(e|f)g"', function()
			assert(not isMatch("123abc", "ab**(e|f)g", { bash = true }))
		end)

		it('"123abc" should not match "ab***ef"', function()
			assert(not isMatch("123abc", "ab***ef", { bash = true }))
		end)

		it('"123abc" should not match "ab*+(e|f)"', function()
			assert(not isMatch("123abc", "ab*+(e|f)", { bash = true }))
		end)

		it('"123abc" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("123abc", "ab*d+(e|f)", { bash = true }))
		end)

		it('"123abc" should not match "ab?*(e|f)"', function()
			assert(not isMatch("123abc", "ab?*(e|f)", { bash = true }))
		end)

		it('"12abc" should not match "0|[1-9]*([0-9])"', function()
			assert(not isMatch("12abc", "0|[1-9]*([0-9])", { bash = true }))
		end)

		it('"137577991" should match "*(0|1|3|5|7|9)"', function()
			assert(isMatch("137577991", "*(0|1|3|5|7|9)", { bash = true }))
		end)

		it('"2468" should not match "*(0|1|3|5|7|9)"', function()
			assert(not isMatch("2468", "*(0|1|3|5|7|9)", { bash = true }))
		end)

		it('"?a?b" should match "\\??\\?b"', function()
			assert(isMatch("?a?b", "\\??\\?b", { bash = true }))
		end)

		it('"\\a\\b\\c" should not match "abc"', function()
			assert(not isMatch("\\a\\b\\c", "abc", { bash = true }))
		end)

		it('"a" should match "!(*.a|*.b|*.c)"', function()
			assert(isMatch("a", "!(*.a|*.b|*.c)", { bash = true }))
		end)

		it('"a" should not match "!(a)"', function()
			assert(not isMatch("a", "!(a)", { bash = true }))
		end)

		it('"a" should not match "!(a)*"', function()
			assert(not isMatch("a", "!(a)*", { bash = true }))
		end)

		it('"a" should match "(a)"', function()
			assert(isMatch("a", "(a)", { bash = true }))
		end)

		it('"a" should not match "(b)"', function()
			assert(not isMatch("a", "(b)", { bash = true }))
		end)

		it('"a" should match "*(a)"', function()
			assert(isMatch("a", "*(a)", { bash = true }))
		end)

		it('"a" should match "+(a)"', function()
			assert(isMatch("a", "+(a)", { bash = true }))
		end)

		it('"a" should match "?"', function()
			assert(isMatch("a", "?", { bash = true }))
		end)

		it('"a" should match "?(a|b)"', function()
			assert(isMatch("a", "?(a|b)", { bash = true }))
		end)

		it('"a" should not match "??"', function()
			assert(not isMatch("a", "??", { bash = true }))
		end)

		it('"a" should match "a!(b)*"', function()
			assert(isMatch("a", "a!(b)*", { bash = true }))
		end)

		it('"a" should match "a?(a|b)"', function()
			assert(isMatch("a", "a?(a|b)", { bash = true }))
		end)

		it('"a" should match "a?(x)"', function()
			assert(isMatch("a", "a?(x)", { bash = true }))
		end)

		it('"a" should not match "a??b"', function()
			assert(not isMatch("a", "a??b", { bash = true }))
		end)

		it('"a" should not match "b?(a|b)"', function()
			assert(not isMatch("a", "b?(a|b)", { bash = true }))
		end)

		itFIXME('"a((((b" should match "a(*b"', function()
			assert(isMatch("a((((b", "a(*b", { bash = true }))
		end)

		it('"a((((b" should not match "a(b"', function()
			assert(not isMatch("a((((b", "a(b", { bash = true }))
		end)

		it('"a((((b" should not match "a\\(b"', function()
			assert(not isMatch("a((((b", "a\\(b", { bash = true }))
		end)

		itFIXME('"a((b" should match "a(*b"', function()
			assert(isMatch("a((b", "a(*b", { bash = true }))
		end)

		it('"a((b" should not match "a(b"', function()
			assert(not isMatch("a((b", "a(b", { bash = true }))
		end)

		it('"a((b" should not match "a\\(b"', function()
			assert(not isMatch("a((b", "a\\(b", { bash = true }))
		end)

		itFIXME('"a(b" should match "a(*b"', function()
			assert(isMatch("a(b", "a(*b", { bash = true }))
		end)

		it('"a(b" should match "a(b"', function()
			assert(isMatch("a(b", "a(b", { bash = true }))
		end)

		it('"a\\(b" should match "a\\(b"', function()
			assert(isMatch("a\\(b", "a\\(b", { bash = true }))
		end)

		it('"a(b" should match "a\\(b"', function()
			assert(isMatch("a(b", "a\\(b", { bash = true }))
		end)

		it('"a." should match "!(*.a|*.b|*.c)"', function()
			assert(isMatch("a.", "!(*.a|*.b|*.c)", { bash = true }))
		end)

		it('"a." should match "*!(.a|.b|.c)"', function()
			assert(isMatch("a.", "*!(.a|.b|.c)", { bash = true }))
		end)

		it('"a." should match "*.!(a)"', function()
			assert(isMatch("a.", "*.!(a)", { bash = true }))
		end)

		it('"a." should match "*.!(a|b|c)"', function()
			assert(isMatch("a.", "*.!(a|b|c)", { bash = true }))
		end)

		it('"a." should not match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(not isMatch("a.", "*.(a|b|@(ab|a*@(b))*(c)d)", { bash = true }))
		end)

		it('"a." should not match "*.+(b|d)"', function()
			assert(not isMatch("a.", "*.+(b|d)", { bash = true }))
		end)

		itFIXME('"a.a" should not match "!(*.[a-b]*)"', function()
			assert(not isMatch("a.a", "!(*.[a-b]*)", { bash = true }))
		end)

		it('"a.a" should not match "!(*.a|*.b|*.c)"', function()
			assert(not isMatch("a.a", "!(*.a|*.b|*.c)", { bash = true }))
		end)

		itFIXME('"a.a" should not match "!(*[a-b].[a-b]*)"', function()
			assert(not isMatch("a.a", "!(*[a-b].[a-b]*)", { bash = true }))
		end)

		it('"a.a" should not match "!*.(a|b)"', function()
			assert(not isMatch("a.a", "!*.(a|b)", { bash = true }))
		end)

		it('"a.a" should not match "!*.(a|b)*"', function()
			assert(not isMatch("a.a", "!*.(a|b)*", { bash = true }))
		end)

		it('"a.a" should match "(a|d).(a|b)*"', function()
			assert(isMatch("a.a", "(a|d).(a|b)*", { bash = true }))
		end)

		it('"a.a" should match "(b|a).(a)"', function()
			assert(isMatch("a.a", "(b|a).(a)", { bash = true }))
		end)

		it('"a.a" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("a.a", "*!(.a|.b|.c)", { bash = true }))
		end)

		it('"a.a" should not match "*.!(a)"', function()
			assert(not isMatch("a.a", "*.!(a)", { bash = true }))
		end)

		it('"a.a" should not match "*.!(a|b|c)"', function()
			assert(not isMatch("a.a", "*.!(a|b|c)", { bash = true }))
		end)

		it('"a.a" should match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(isMatch("a.a", "*.(a|b|@(ab|a*@(b))*(c)d)", { bash = true }))
		end)

		it('"a.a" should not match "*.+(b|d)"', function()
			assert(not isMatch("a.a", "*.+(b|d)", { bash = true }))
		end)

		it('"a.a" should match "@(b|a).@(a)"', function()
			assert(isMatch("a.a", "@(b|a).@(a)", { bash = true }))
		end)

		itFIXME('"a.a.a" should not match "!(*.[a-b]*)"', function()
			assert(not isMatch("a.a.a", "!(*.[a-b]*)", { bash = true }))
		end)

		itFIXME('"a.a.a" should not match "!(*[a-b].[a-b]*)"', function()
			assert(not isMatch("a.a.a", "!(*[a-b].[a-b]*)", { bash = true }))
		end)

		it('"a.a.a" should not match "!*.(a|b)"', function()
			assert(not isMatch("a.a.a", "!*.(a|b)", { bash = true }))
		end)

		it('"a.a.a" should not match "!*.(a|b)*"', function()
			assert(not isMatch("a.a.a", "!*.(a|b)*", { bash = true }))
		end)

		it('"a.a.a" should match "*.!(a)"', function()
			assert(isMatch("a.a.a", "*.!(a)", { bash = true }))
		end)

		it('"a.a.a" should not match "*.+(b|d)"', function()
			assert(not isMatch("a.a.a", "*.+(b|d)", { bash = true }))
		end)

		it('"a.aa.a" should not match "(b|a).(a)"', function()
			assert(not isMatch("a.aa.a", "(b|a).(a)", { bash = true }))
		end)

		it('"a.aa.a" should not match "@(b|a).@(a)"', function()
			assert(not isMatch("a.aa.a", "@(b|a).@(a)", { bash = true }))
		end)

		it('"a.abcd" should match "!(*.a|*.b|*.c)"', function()
			assert(isMatch("a.abcd", "!(*.a|*.b|*.c)", { bash = true }))
		end)

		it('"a.abcd" should not match "!(*.a|*.b|*.c)*"', function()
			assert(not isMatch("a.abcd", "!(*.a|*.b|*.c)*", { bash = true }))
		end)

		it('"a.abcd" should match "*!(*.a|*.b|*.c)*"', function()
			assert(isMatch("a.abcd", "*!(*.a|*.b|*.c)*", { bash = true }))
		end)

		it('"a.abcd" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("a.abcd", "*!(.a|.b|.c)", { bash = true }))
		end)

		it('"a.abcd" should match "*.!(a|b|c)"', function()
			assert(isMatch("a.abcd", "*.!(a|b|c)", { bash = true }))
		end)

		it('"a.abcd" should not match "*.!(a|b|c)*"', function()
			assert(not isMatch("a.abcd", "*.!(a|b|c)*", { bash = true }))
		end)

		it('"a.abcd" should match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(isMatch("a.abcd", "*.(a|b|@(ab|a*@(b))*(c)d)", { bash = true }))
		end)

		it('"a.b" should not match "!(*.*)"', function()
			assert(not isMatch("a.b", "!(*.*)", { bash = true }))
		end)

		itFIXME('"a.b" should not match "!(*.[a-b]*)"', function()
			assert(not isMatch("a.b", "!(*.[a-b]*)", { bash = true }))
		end)

		it('"a.b" should not match "!(*.a|*.b|*.c)"', function()
			assert(not isMatch("a.b", "!(*.a|*.b|*.c)", { bash = true }))
		end)

		itFIXME('"a.b" should not match "!(*[a-b].[a-b]*)"', function()
			assert(not isMatch("a.b", "!(*[a-b].[a-b]*)", { bash = true }))
		end)

		it('"a.b" should not match "!*.(a|b)"', function()
			assert(not isMatch("a.b", "!*.(a|b)", { bash = true }))
		end)

		it('"a.b" should not match "!*.(a|b)*"', function()
			assert(not isMatch("a.b", "!*.(a|b)*", { bash = true }))
		end)

		it('"a.b" should match "(a|d).(a|b)*"', function()
			assert(isMatch("a.b", "(a|d).(a|b)*", { bash = true }))
		end)

		it('"a.b" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("a.b", "*!(.a|.b|.c)", { bash = true }))
		end)

		it('"a.b" should match "*.!(a)"', function()
			assert(isMatch("a.b", "*.!(a)", { bash = true }))
		end)

		it('"a.b" should not match "*.!(a|b|c)"', function()
			assert(not isMatch("a.b", "*.!(a|b|c)", { bash = true }))
		end)

		it('"a.b" should match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(isMatch("a.b", "*.(a|b|@(ab|a*@(b))*(c)d)", { bash = true }))
		end)

		it('"a.b" should match "*.+(b|d)"', function()
			assert(isMatch("a.b", "*.+(b|d)", { bash = true }))
		end)

		itFIXME('"a.bb" should not match "!(*.[a-b]*)"', function()
			assert(not isMatch("a.bb", "!(*.[a-b]*)", { bash = true }))
		end)

		itFIXME('"a.bb" should not match "!(*[a-b].[a-b]*)"', function()
			assert(not isMatch("a.bb", "!(*[a-b].[a-b]*)", { bash = true }))
		end)

		it('"a.bb" should match "!*.(a|b)"', function()
			assert(isMatch("a.bb", "!*.(a|b)", { bash = true }))
		end)

		it('"a.bb" should not match "!*.(a|b)*"', function()
			assert(not isMatch("a.bb", "!*.(a|b)*", { bash = true }))
		end)

		it('"a.bb" should not match "!*.*(a|b)"', function()
			assert(not isMatch("a.bb", "!*.*(a|b)", { bash = true }))
		end)

		it('"a.bb" should match "(a|d).(a|b)*"', function()
			assert(isMatch("a.bb", "(a|d).(a|b)*", { bash = true }))
		end)

		it('"a.bb" should not match "(b|a).(a)"', function()
			assert(not isMatch("a.bb", "(b|a).(a)", { bash = true }))
		end)

		it('"a.bb" should match "*.+(b|d)"', function()
			assert(isMatch("a.bb", "*.+(b|d)", { bash = true }))
		end)

		it('"a.bb" should not match "@(b|a).@(a)"', function()
			assert(not isMatch("a.bb", "@(b|a).@(a)", { bash = true }))
		end)

		it('"a.c" should not match "!(*.a|*.b|*.c)"', function()
			assert(not isMatch("a.c", "!(*.a|*.b|*.c)", { bash = true }))
		end)

		it('"a.c" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("a.c", "*!(.a|.b|.c)", { bash = true }))
		end)

		it('"a.c" should not match "*.!(a|b|c)"', function()
			assert(not isMatch("a.c", "*.!(a|b|c)", { bash = true }))
		end)

		it('"a.c" should not match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(not isMatch("a.c", "*.(a|b|@(ab|a*@(b))*(c)d)", { bash = true }))
		end)

		it('"a.c.d" should match "!(*.a|*.b|*.c)"', function()
			assert(isMatch("a.c.d", "!(*.a|*.b|*.c)", { bash = true }))
		end)

		it('"a.c.d" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("a.c.d", "*!(.a|.b|.c)", { bash = true }))
		end)

		it('"a.c.d" should match "*.!(a|b|c)"', function()
			assert(isMatch("a.c.d", "*.!(a|b|c)", { bash = true }))
		end)

		it('"a.c.d" should not match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(not isMatch("a.c.d", "*.(a|b|@(ab|a*@(b))*(c)d)", { bash = true }))
		end)

		it('"a.ccc" should match "!(*.[a-b]*)"', function()
			assert(isMatch("a.ccc", "!(*.[a-b]*)", { bash = true }))
		end)

		it('"a.ccc" should match "!(*[a-b].[a-b]*)"', function()
			assert(isMatch("a.ccc", "!(*[a-b].[a-b]*)", { bash = true }))
		end)

		it('"a.ccc" should match "!*.(a|b)"', function()
			assert(isMatch("a.ccc", "!*.(a|b)", { bash = true }))
		end)

		it('"a.ccc" should match "!*.(a|b)*"', function()
			assert(isMatch("a.ccc", "!*.(a|b)*", { bash = true }))
		end)

		it('"a.ccc" should not match "*.+(b|d)"', function()
			assert(not isMatch("a.ccc", "*.+(b|d)", { bash = true }))
		end)

		it('"a.js" should not match "!(*.js)"', function()
			assert(not isMatch("a.js", "!(*.js)", { bash = true }))
		end)

		it('"a.js" should match "*!(.js)"', function()
			assert(isMatch("a.js", "*!(.js)", { bash = true }))
		end)

		it('"a.js" should not match "*.!(js)"', function()
			assert(not isMatch("a.js", "*.!(js)", { bash = true }))
		end)

		it('"a.js" should not match "a.!(js)"', function()
			assert(not isMatch("a.js", "a.!(js)", { bash = true }))
		end)

		it('"a.js" should not match "a.!(js)*"', function()
			assert(not isMatch("a.js", "a.!(js)*", { bash = true }))
		end)

		it('"a.js.js" should not match "!(*.js)"', function()
			assert(not isMatch("a.js.js", "!(*.js)", { bash = true }))
		end)

		it('"a.js.js" should match "*!(.js)"', function()
			assert(isMatch("a.js.js", "*!(.js)", { bash = true }))
		end)

		it('"a.js.js" should match "*.!(js)"', function()
			assert(isMatch("a.js.js", "*.!(js)", { bash = true }))
		end)

		it('"a.js.js" should match "*.*(js).js"', function()
			assert(isMatch("a.js.js", "*.*(js).js", { bash = true }))
		end)

		it('"a.md" should match "!(*.js)"', function()
			assert(isMatch("a.md", "!(*.js)", { bash = true }))
		end)

		it('"a.md" should match "*!(.js)"', function()
			assert(isMatch("a.md", "*!(.js)", { bash = true }))
		end)

		it('"a.md" should match "*.!(js)"', function()
			assert(isMatch("a.md", "*.!(js)", { bash = true }))
		end)

		it('"a.md" should match "a.!(js)"', function()
			assert(isMatch("a.md", "a.!(js)", { bash = true }))
		end)

		it('"a.md" should match "a.!(js)*"', function()
			assert(isMatch("a.md", "a.!(js)*", { bash = true }))
		end)

		it('"a.md.js" should not match "*.*(js).js"', function()
			assert(not isMatch("a.md.js", "*.*(js).js", { bash = true }))
		end)

		it('"a.txt" should match "a.!(js)"', function()
			assert(isMatch("a.txt", "a.!(js)", { bash = true }))
		end)

		it('"a.txt" should match "a.!(js)*"', function()
			assert(isMatch("a.txt", "a.!(js)*", { bash = true }))
		end)

		it('"a/!(z)" should match "a/!(z)"', function()
			assert(isMatch("a/!(z)", "a/!(z)", { bash = true }))
		end)

		it('"a/b" should match "a/!(z)"', function()
			assert(isMatch("a/b", "a/!(z)", { bash = true }))
		end)

		it('"a/b/c.txt" should not match "*/b/!(*).txt"', function()
			assert(not isMatch("a/b/c.txt", "*/b/!(*).txt", { bash = true }))
		end)

		it('"a/b/c.txt" should not match "*/b/!(c).txt"', function()
			assert(not isMatch("a/b/c.txt", "*/b/!(c).txt", { bash = true }))
		end)

		it('"a/b/c.txt" should match "*/b/!(cc).txt"', function()
			assert(isMatch("a/b/c.txt", "*/b/!(cc).txt", { bash = true }))
		end)

		it('"a/b/cc.txt" should not match "*/b/!(*).txt"', function()
			assert(not isMatch("a/b/cc.txt", "*/b/!(*).txt", { bash = true }))
		end)

		it('"a/b/cc.txt" should not match "*/b/!(c).txt"', function()
			assert(not isMatch("a/b/cc.txt", "*/b/!(c).txt", { bash = true }))
		end)

		it('"a/b/cc.txt" should not match "*/b/!(cc).txt"', function()
			assert(not isMatch("a/b/cc.txt", "*/b/!(cc).txt", { bash = true }))
		end)

		it('"a/dir/foo.txt" should match "*/dir/**/!(bar).txt"', function()
			assert(isMatch("a/dir/foo.txt", "*/dir/**/!(bar).txt", { bash = true }))
		end)

		it('"a/z" should not match "a/!(z)"', function()
			assert(not isMatch("a/z", "a/!(z)", { bash = true }))
		end)

		it('"a\\(b" should not match "a(*b"', function()
			assert(not isMatch("a\\(b", "a(*b", { bash = true }))
		end)

		it('"a\\(b" should not match "a(b"', function()
			assert(not isMatch("a\\(b", "a(b", { bash = true }))
		end)

		itFIXME('"a\\z" should match "a\\z"', function()
			assert(isMatch("a\\\\z", "a\\\\z", { bash = true, windows = false }))
		end)

		itFIXME('"a\\z" should match "a\\z"_', function()
			assert(isMatch("a\\\\z", "a\\\\z", { bash = true }))
		end)

		itFIXME('"a\\b" should match "a/b"', function()
			assert(isMatch("a\\b", "a/b", { windows = true }))
		end)

		itFIXME('"a\\z" should match "a\\z"__', function()
			assert(isMatch("a\\\\z", "a\\\\z", { bash = true }))
			assert(isMatch("a\\z", "a\\z", { bash = true }))
		end)

		itFIXME('"a\\z" should not match "a\\z"', function()
			assert(isMatch("a\\z", "a\\z", { bash = true }))
		end)

		it('"aa" should not match "!(a!(b))"', function()
			assert(not isMatch("aa", "!(a!(b))", { bash = true }))
		end)

		it('"aa" should match "!(a)"', function()
			assert(isMatch("aa", "!(a)", { bash = true }))
		end)

		it('"aa" should not match "!(a)*"', function()
			assert(not isMatch("aa", "!(a)*", { bash = true }))
		end)

		it('"aa" should not match "?"', function()
			assert(not isMatch("aa", "?", { bash = true }))
		end)

		it('"aa" should not match "@(a)b"', function()
			assert(not isMatch("aa", "@(a)b", { bash = true }))
		end)

		it('"aa" should match "a!(b)*"', function()
			assert(isMatch("aa", "a!(b)*", { bash = true }))
		end)

		it('"aa" should not match "a??b"', function()
			assert(not isMatch("aa", "a??b", { bash = true }))
		end)

		it('"aa.aa" should not match "(b|a).(a)"', function()
			assert(not isMatch("aa.aa", "(b|a).(a)", { bash = true }))
		end)

		it('"aa.aa" should not match "@(b|a).@(a)"', function()
			assert(not isMatch("aa.aa", "@(b|a).@(a)", { bash = true }))
		end)

		it('"aaa" should not match "!(a)*"', function()
			assert(not isMatch("aaa", "!(a)*", { bash = true }))
		end)

		it('"aaa" should match "a!(b)*"', function()
			assert(isMatch("aaa", "a!(b)*", { bash = true }))
		end)

		it('"aaaaaaabababab" should match "*ab"', function()
			assert(isMatch("aaaaaaabababab", "*ab", { bash = true }))
		end)

		it('"aaac" should match "*(@(a))a@(c)"', function()
			assert(isMatch("aaac", "*(@(a))a@(c)", { bash = true }))
		end)

		itFIXME('"aaaz" should match "[a*(]*z"', function()
			assert(isMatch("aaaz", "[a*(]*z", { bash = true }))
		end)

		it('"aab" should not match "!(a)*"', function()
			assert(not isMatch("aab", "!(a)*", { bash = true }))
		end)

		it('"aab" should not match "?"', function()
			assert(not isMatch("aab", "?", { bash = true }))
		end)

		it('"aab" should not match "??"', function()
			assert(not isMatch("aab", "??", { bash = true }))
		end)

		it('"aab" should not match "@(c)b"', function()
			assert(not isMatch("aab", "@(c)b", { bash = true }))
		end)

		it('"aab" should match "a!(b)*"', function()
			assert(isMatch("aab", "a!(b)*", { bash = true }))
		end)

		it('"aab" should not match "a??b"', function()
			assert(not isMatch("aab", "a??b", { bash = true }))
		end)

		it('"aac" should match "*(@(a))a@(c)"', function()
			assert(isMatch("aac", "*(@(a))a@(c)", { bash = true }))
		end)

		it('"aac" should not match "*(@(a))b@(c)"', function()
			assert(not isMatch("aac", "*(@(a))b@(c)", { bash = true }))
		end)

		it('"aax" should not match "a!(a*|b)"', function()
			assert(not isMatch("aax", "a!(a*|b)", { bash = true }))
		end)

		it('"aax" should match "a!(x*|b)"', function()
			assert(isMatch("aax", "a!(x*|b)", { bash = true }))
		end)

		it('"aax" should match "a?(a*|b)"', function()
			assert(isMatch("aax", "a?(a*|b)", { bash = true }))
		end)

		itFIXME('"aaz" should match "[a*(]*z"', function()
			assert(isMatch("aaz", "[a*(]*z", { bash = true }))
		end)

		it('"ab" should match "!(*.*)"', function()
			assert(isMatch("ab", "!(*.*)", { bash = true }))
		end)

		it('"ab" should match "!(a!(b))"', function()
			assert(isMatch("ab", "!(a!(b))", { bash = true }))
		end)

		it('"ab" should not match "!(a)*"', function()
			assert(not isMatch("ab", "!(a)*", { bash = true }))
		end)

		it('"ab" should match "@(a+|b)*"', function()
			assert(isMatch("ab", "@(a+|b)*", { bash = true }))
		end)

		it('"ab" should match "(a+|b)+"', function()
			assert(isMatch("ab", "(a+|b)+", { bash = true }))
		end)

		it('"ab" should not match "*?(a)bc"', function()
			assert(not isMatch("ab", "*?(a)bc", { bash = true }))
		end)

		it('"ab" should not match "a!(*(b|B))"', function()
			assert(not isMatch("ab", "a!(*(b|B))", { bash = true }))
		end)

		it('"ab" should not match "a!(@(b|B))"', function()
			assert(not isMatch("ab", "a!(@(b|B))", { bash = true }))
		end)

		it('"aB" should not match "a!(@(b|B))"', function()
			assert(not isMatch("aB", "a!(@(b|B))", { bash = true }))
		end)

		it('"ab" should not match "a!(b)*"', function()
			assert(not isMatch("ab", "a!(b)*", { bash = true }))
		end)

		it('"ab" should not match "a(*b"', function()
			assert(not isMatch("ab", "a(*b", { bash = true }))
		end)

		it('"ab" should not match "a(b"', function()
			assert(not isMatch("ab", "a(b", { bash = true }))
		end)

		it('"ab" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("ab", "a(b*(foo|bar))d", { bash = true }))
		end)

		itFIXME('"ab" should not match "a/b"', function()
			assert(not isMatch("ab", "a/b", { windows = true }))
		end)

		it('"ab" should not match "a\\(b"', function()
			assert(not isMatch("ab", "a\\(b", { bash = true }))
		end)

		it('"ab" should match "ab*(e|f)"', function()
			assert(isMatch("ab", "ab*(e|f)", { bash = true }))
		end)

		it('"ab" should match "ab**"', function()
			assert(isMatch("ab", "ab**", { bash = true }))
		end)

		it('"ab" should match "ab**(e|f)"', function()
			assert(isMatch("ab", "ab**(e|f)", { bash = true }))
		end)

		it('"ab" should not match "ab**(e|f)g"', function()
			assert(not isMatch("ab", "ab**(e|f)g", { bash = true }))
		end)

		it('"ab" should not match "ab***ef"', function()
			assert(not isMatch("ab", "ab***ef", { bash = true }))
		end)

		it('"ab" should not match "ab*+(e|f)"', function()
			assert(not isMatch("ab", "ab*+(e|f)", { bash = true }))
		end)

		it('"ab" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("ab", "ab*d+(e|f)", { bash = true }))
		end)

		it('"ab" should not match "ab?*(e|f)"', function()
			assert(not isMatch("ab", "ab?*(e|f)", { bash = true }))
		end)

		it('"ab/cXd/efXg/hi" should match "**/*X*/**/*i"', function()
			assert(isMatch("ab/cXd/efXg/hi", "**/*X*/**/*i", { bash = true }))
		end)

		it('"ab/cXd/efXg/hi" should match "*/*X*/*/*i"', function()
			assert(isMatch("ab/cXd/efXg/hi", "*/*X*/*/*i", { bash = true }))
		end)

		it('"ab/cXd/efXg/hi" should match "*X*i"', function()
			assert(isMatch("ab/cXd/efXg/hi", "*X*i", { bash = true }))
		end)

		it('"ab/cXd/efXg/hi" should match "*Xg*i"', function()
			assert(isMatch("ab/cXd/efXg/hi", "*Xg*i", { bash = true }))
		end)

		it('"ab]" should match "a!(@(b|B))"', function()
			assert(isMatch("ab]", "a!(@(b|B))", { bash = true }))
		end)

		it('"abab" should match "(a+|b)*"', function()
			assert(isMatch("abab", "(a+|b)*", { bash = true }))
		end)

		it('"abab" should match "(a+|b)+"', function()
			assert(isMatch("abab", "(a+|b)+", { bash = true }))
		end)

		it('"abab" should not match "*?(a)bc"', function()
			assert(not isMatch("abab", "*?(a)bc", { bash = true }))
		end)

		it('"abab" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("abab", "a(b*(foo|bar))d", { bash = true }))
		end)

		it('"abab" should not match "ab*(e|f)"', function()
			assert(not isMatch("abab", "ab*(e|f)", { bash = true }))
		end)

		it('"abab" should match "ab**"', function()
			assert(isMatch("abab", "ab**", { bash = true }))
		end)

		it('"abab" should match "ab**(e|f)"', function()
			assert(isMatch("abab", "ab**(e|f)", { bash = true }))
		end)

		it('"abab" should not match "ab**(e|f)g"', function()
			assert(not isMatch("abab", "ab**(e|f)g", { bash = true }))
		end)

		it('"abab" should not match "ab***ef"', function()
			assert(not isMatch("abab", "ab***ef", { bash = true }))
		end)

		it('"abab" should not match "ab*+(e|f)"', function()
			assert(not isMatch("abab", "ab*+(e|f)", { bash = true }))
		end)

		it('"abab" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("abab", "ab*d+(e|f)", { bash = true }))
		end)

		it('"abab" should not match "ab?*(e|f)"', function()
			assert(not isMatch("abab", "ab?*(e|f)", { bash = true }))
		end)

		it('"abb" should match "!(*.*)"', function()
			assert(isMatch("abb", "!(*.*)", { bash = true }))
		end)

		it('"abb" should not match "!(a)*"', function()
			assert(not isMatch("abb", "!(a)*", { bash = true }))
		end)

		it('"abb" should not match "a!(b)*"', function()
			assert(not isMatch("abb", "a!(b)*", { bash = true }))
		end)

		it('"abbcd" should match "@(ab|a*(b))*(c)d"', function()
			assert(isMatch("abbcd", "@(ab|a*(b))*(c)d", { bash = true }))
		end)

		itFIXME('"abc" should not match "\\a\\b\\c"', function()
			assert(not isMatch("abc", "\\a\\b\\c", { bash = true }))
		end)

		it('"aBc" should match "a!(@(b|B))"', function()
			assert(isMatch("aBc", "a!(@(b|B))", { bash = true }))
		end)

		it('"abcd" should match "?@(a|b)*@(c)d"', function()
			assert(isMatch("abcd", "?@(a|b)*@(c)d", { bash = true }))
		end)

		it('"abcd" should match "@(ab|a*@(b))*(c)d"', function()
			assert(isMatch("abcd", "@(ab|a*@(b))*(c)d", { bash = true }))
		end)

		it('"abcd/abcdefg/abcdefghijk/abcdefghijklmnop.txt" should match "**/*a*b*g*n*t"', function()
			assert(isMatch("abcd/abcdefg/abcdefghijk/abcdefghijklmnop.txt", "**/*a*b*g*n*t", { bash = true }))
		end)

		it('"abcd/abcdefg/abcdefghijk/abcdefghijklmnop.txtz" should not match "**/*a*b*g*n*t"', function()
			assert(not isMatch("abcd/abcdefg/abcdefghijk/abcdefghijklmnop.txtz", "**/*a*b*g*n*t", { bash = true }))
		end)

		it('"abcdef" should match "(a+|b)*"', function()
			assert(isMatch("abcdef", "(a+|b)*", { bash = true }))
		end)

		it('"abcdef" should not match "(a+|b)+"', function()
			assert(not isMatch("abcdef", "(a+|b)+", { bash = true }))
		end)

		it('"abcdef" should not match "*?(a)bc"', function()
			assert(not isMatch("abcdef", "*?(a)bc", { bash = true }))
		end)

		it('"abcdef" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("abcdef", "a(b*(foo|bar))d", { bash = true }))
		end)

		it('"abcdef" should not match "ab*(e|f)"', function()
			assert(not isMatch("abcdef", "ab*(e|f)", { bash = true }))
		end)

		it('"abcdef" should match "ab**"', function()
			assert(isMatch("abcdef", "ab**", { bash = true }))
		end)

		it('"abcdef" should match "ab**(e|f)"', function()
			assert(isMatch("abcdef", "ab**(e|f)", { bash = true }))
		end)

		it('"abcdef" should not match "ab**(e|f)g"', function()
			assert(not isMatch("abcdef", "ab**(e|f)g", { bash = true }))
		end)

		it('"abcdef" should match "ab***ef"', function()
			assert(isMatch("abcdef", "ab***ef", { bash = true }))
		end)

		it('"abcdef" should match "ab*+(e|f)"', function()
			assert(isMatch("abcdef", "ab*+(e|f)", { bash = true }))
		end)

		it('"abcdef" should match "ab*d+(e|f)"', function()
			assert(isMatch("abcdef", "ab*d+(e|f)", { bash = true }))
		end)

		it('"abcdef" should not match "ab?*(e|f)"', function()
			assert(not isMatch("abcdef", "ab?*(e|f)", { bash = true }))
		end)

		it('"abcfef" should match "(a+|b)*"', function()
			assert(isMatch("abcfef", "(a+|b)*", { bash = true }))
		end)

		it('"abcfef" should not match "(a+|b)+"', function()
			assert(not isMatch("abcfef", "(a+|b)+", { bash = true }))
		end)

		it('"abcfef" should not match "*?(a)bc"', function()
			assert(not isMatch("abcfef", "*?(a)bc", { bash = true }))
		end)

		it('"abcfef" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("abcfef", "a(b*(foo|bar))d", { bash = true }))
		end)

		it('"abcfef" should not match "ab*(e|f)"', function()
			assert(not isMatch("abcfef", "ab*(e|f)", { bash = true }))
		end)

		it('"abcfef" should match "ab**"', function()
			assert(isMatch("abcfef", "ab**", { bash = true }))
		end)

		it('"abcfef" should match "ab**(e|f)"', function()
			assert(isMatch("abcfef", "ab**(e|f)", { bash = true }))
		end)

		it('"abcfef" should not match "ab**(e|f)g"', function()
			assert(not isMatch("abcfef", "ab**(e|f)g", { bash = true }))
		end)

		it('"abcfef" should match "ab***ef"', function()
			assert(isMatch("abcfef", "ab***ef", { bash = true }))
		end)

		it('"abcfef" should match "ab*+(e|f)"', function()
			assert(isMatch("abcfef", "ab*+(e|f)", { bash = true }))
		end)

		it('"abcfef" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("abcfef", "ab*d+(e|f)", { bash = true }))
		end)

		it('"abcfef" should match "ab?*(e|f)"', function()
			assert(isMatch("abcfef", "ab?*(e|f)", { bash = true }))
		end)

		it('"abcfefg" should match "(a+|b)*"', function()
			assert(isMatch("abcfefg", "(a+|b)*", { bash = true }))
		end)

		it('"abcfefg" should not match "(a+|b)+"', function()
			assert(not isMatch("abcfefg", "(a+|b)+", { bash = true }))
		end)

		it('"abcfefg" should not match "*?(a)bc"', function()
			assert(not isMatch("abcfefg", "*?(a)bc", { bash = true }))
		end)

		it('"abcfefg" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("abcfefg", "a(b*(foo|bar))d", { bash = true }))
		end)

		it('"abcfefg" should not match "ab*(e|f)"', function()
			assert(not isMatch("abcfefg", "ab*(e|f)", { bash = true }))
		end)

		it('"abcfefg" should match "ab**"', function()
			assert(isMatch("abcfefg", "ab**", { bash = true }))
		end)

		it('"abcfefg" should match "ab**(e|f)"', function()
			assert(isMatch("abcfefg", "ab**(e|f)", { bash = true }))
		end)

		it('"abcfefg" should match "ab**(e|f)g"', function()
			assert(isMatch("abcfefg", "ab**(e|f)g", { bash = true }))
		end)

		it('"abcfefg" should not match "ab***ef"', function()
			assert(not isMatch("abcfefg", "ab***ef", { bash = true }))
		end)

		it('"abcfefg" should not match "ab*+(e|f)"', function()
			assert(not isMatch("abcfefg", "ab*+(e|f)", { bash = true }))
		end)

		it('"abcfefg" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("abcfefg", "ab*d+(e|f)", { bash = true }))
		end)

		it('"abcfefg" should not match "ab?*(e|f)"', function()
			assert(not isMatch("abcfefg", "ab?*(e|f)", { bash = true }))
		end)

		it('"abcx" should match "!([[*])*"', function()
			assert(isMatch("abcx", "!([[*])*", { bash = true }))
		end)

		it('"abcx" should match "+(a|b\\[)*"', function()
			assert(isMatch("abcx", "+(a|b\\[)*", { bash = true }))
		end)

		it('"abcx" should not match "[a*(]*z"', function()
			assert(not isMatch("abcx", "[a*(]*z", { bash = true }))
		end)

		it('"abcXdefXghi" should match "*X*i"', function()
			assert(isMatch("abcXdefXghi", "*X*i", { bash = true }))
		end)

		it('"abcz" should match "!([[*])*"', function()
			assert(isMatch("abcz", "!([[*])*", { bash = true }))
		end)

		it('"abcz" should match "+(a|b\\[)*"', function()
			assert(isMatch("abcz", "+(a|b\\[)*", { bash = true }))
		end)

		itFIXME('"abcz" should match "[a*(]*z"', function()
			assert(isMatch("abcz", "[a*(]*z", { bash = true }))
		end)

		it('"abd" should match "(a+|b)*"', function()
			assert(isMatch("abd", "(a+|b)*", { bash = true }))
		end)

		it('"abd" should not match "(a+|b)+"', function()
			assert(not isMatch("abd", "(a+|b)+", { bash = true }))
		end)

		it('"abd" should not match "*?(a)bc"', function()
			assert(not isMatch("abd", "*?(a)bc", { bash = true }))
		end)

		it('"abd" should match "a!(*(b|B))"', function()
			assert(isMatch("abd", "a!(*(b|B))", { bash = true }))
		end)

		it('"abd" should match "a!(@(b|B))"', function()
			assert(isMatch("abd", "a!(@(b|B))", { bash = true }))
		end)

		it('"abd" should not match "a!(@(b|B))d"', function()
			assert(not isMatch("abd", "a!(@(b|B))d", { bash = true }))
		end)

		it('"abd" should match "a(b*(foo|bar))d"', function()
			assert(isMatch("abd", "a(b*(foo|bar))d", { bash = true }))
		end)

		it('"abd" should match "a+(b|c)d"', function()
			assert(isMatch("abd", "a+(b|c)d", { bash = true }))
		end)

		itFIXME('"abd" should match "a[b*(foo|bar)]d"', function()
			assert(isMatch("abd", "a[b*(foo|bar)]d", { bash = true }))
		end)

		it('"abd" should not match "ab*(e|f)"', function()
			assert(not isMatch("abd", "ab*(e|f)", { bash = true }))
		end)

		it('"abd" should match "ab**"', function()
			assert(isMatch("abd", "ab**", { bash = true }))
		end)

		it('"abd" should match "ab**(e|f)"', function()
			assert(isMatch("abd", "ab**(e|f)", { bash = true }))
		end)

		it('"abd" should not match "ab**(e|f)g"', function()
			assert(not isMatch("abd", "ab**(e|f)g", { bash = true }))
		end)

		it('"abd" should not match "ab***ef"', function()
			assert(not isMatch("abd", "ab***ef", { bash = true }))
		end)

		it('"abd" should not match "ab*+(e|f)"', function()
			assert(not isMatch("abd", "ab*+(e|f)", { bash = true }))
		end)

		it('"abd" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("abd", "ab*d+(e|f)", { bash = true }))
		end)

		it('"abd" should match "ab?*(e|f)"', function()
			assert(isMatch("abd", "ab?*(e|f)", { bash = true }))
		end)

		it('"abef" should match "(a+|b)*"', function()
			assert(isMatch("abef", "(a+|b)*", { bash = true }))
		end)

		it('"abef" should not match "(a+|b)+"', function()
			assert(not isMatch("abef", "(a+|b)+", { bash = true }))
		end)

		it('"abef" should not match "*(a+|b)"', function()
			assert(not isMatch("abef", "*(a+|b)", { bash = true }))
		end)

		it('"abef" should not match "*?(a)bc"', function()
			assert(not isMatch("abef", "*?(a)bc", { bash = true }))
		end)

		it('"abef" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("abef", "a(b*(foo|bar))d", { bash = true }))
		end)

		it('"abef" should match "ab*(e|f)"', function()
			assert(isMatch("abef", "ab*(e|f)", { bash = true }))
		end)

		it('"abef" should match "ab**"', function()
			assert(isMatch("abef", "ab**", { bash = true }))
		end)

		it('"abef" should match "ab**(e|f)"', function()
			assert(isMatch("abef", "ab**(e|f)", { bash = true }))
		end)

		it('"abef" should not match "ab**(e|f)g"', function()
			assert(not isMatch("abef", "ab**(e|f)g", { bash = true }))
		end)

		it('"abef" should match "ab***ef"', function()
			assert(isMatch("abef", "ab***ef", { bash = true }))
		end)

		it('"abef" should match "ab*+(e|f)"', function()
			assert(isMatch("abef", "ab*+(e|f)", { bash = true }))
		end)

		it('"abef" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("abef", "ab*d+(e|f)", { bash = true }))
		end)

		it('"abef" should match "ab?*(e|f)"', function()
			assert(isMatch("abef", "ab?*(e|f)", { bash = true }))
		end)

		it('"abz" should not match "a!(*)"', function()
			assert(not isMatch("abz", "a!(*)", { bash = true }))
		end)

		it('"abz" should match "a!(z)"', function()
			assert(isMatch("abz", "a!(z)", { bash = true }))
		end)

		it('"abz" should match "a*!(z)"', function()
			assert(isMatch("abz", "a*!(z)", { bash = true }))
		end)

		it('"abz" should not match "a*(z)"', function()
			assert(not isMatch("abz", "a*(z)", { bash = true }))
		end)

		it('"abz" should match "a**(z)"', function()
			assert(isMatch("abz", "a**(z)", { bash = true }))
		end)

		it('"abz" should match "a*@(z)"', function()
			assert(isMatch("abz", "a*@(z)", { bash = true }))
		end)

		it('"abz" should not match "a+(z)"', function()
			assert(not isMatch("abz", "a+(z)", { bash = true }))
		end)

		it('"abz" should not match "a?(z)"', function()
			assert(not isMatch("abz", "a?(z)", { bash = true }))
		end)

		it('"abz" should not match "a@(z)"', function()
			assert(not isMatch("abz", "a@(z)", { bash = true }))
		end)

		it('"ac" should not match "!(a)*"', function()
			assert(not isMatch("ac", "!(a)*", { bash = true }))
		end)

		it('"ac" should match "*(@(a))a@(c)"', function()
			assert(isMatch("ac", "*(@(a))a@(c)", { bash = true }))
		end)

		it('"ac" should match "a!(*(b|B))"', function()
			assert(isMatch("ac", "a!(*(b|B))", { bash = true }))
		end)

		it('"ac" should match "a!(@(b|B))"', function()
			assert(isMatch("ac", "a!(@(b|B))", { bash = true }))
		end)

		it('"ac" should match "a!(b)*"', function()
			assert(isMatch("ac", "a!(b)*", { bash = true }))
		end)

		it('"accdef" should match "(a+|b)*"', function()
			assert(isMatch("accdef", "(a+|b)*", { bash = true }))
		end)

		it('"accdef" should not match "(a+|b)+"', function()
			assert(not isMatch("accdef", "(a+|b)+", { bash = true }))
		end)

		it('"accdef" should not match "*?(a)bc"', function()
			assert(not isMatch("accdef", "*?(a)bc", { bash = true }))
		end)

		it('"accdef" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("accdef", "a(b*(foo|bar))d", { bash = true }))
		end)

		it('"accdef" should not match "ab*(e|f)"', function()
			assert(not isMatch("accdef", "ab*(e|f)", { bash = true }))
		end)

		it('"accdef" should not match "ab**"', function()
			assert(not isMatch("accdef", "ab**", { bash = true }))
		end)

		it('"accdef" should not match "ab**(e|f)"', function()
			assert(not isMatch("accdef", "ab**(e|f)", { bash = true }))
		end)

		it('"accdef" should not match "ab**(e|f)g"', function()
			assert(not isMatch("accdef", "ab**(e|f)g", { bash = true }))
		end)

		it('"accdef" should not match "ab***ef"', function()
			assert(not isMatch("accdef", "ab***ef", { bash = true }))
		end)

		it('"accdef" should not match "ab*+(e|f)"', function()
			assert(not isMatch("accdef", "ab*+(e|f)", { bash = true }))
		end)

		it('"accdef" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("accdef", "ab*d+(e|f)", { bash = true }))
		end)

		it('"accdef" should not match "ab?*(e|f)"', function()
			assert(not isMatch("accdef", "ab?*(e|f)", { bash = true }))
		end)

		it('"acd" should match "(a+|b)*"', function()
			assert(isMatch("acd", "(a+|b)*", { bash = true }))
		end)

		it('"acd" should not match "(a+|b)+"', function()
			assert(not isMatch("acd", "(a+|b)+", { bash = true }))
		end)

		it('"acd" should not match "*?(a)bc"', function()
			assert(not isMatch("acd", "*?(a)bc", { bash = true }))
		end)

		it('"acd" should match "@(ab|a*(b))*(c)d"', function()
			assert(isMatch("acd", "@(ab|a*(b))*(c)d", { bash = true }))
		end)

		it('"acd" should match "a!(*(b|B))"', function()
			assert(isMatch("acd", "a!(*(b|B))", { bash = true }))
		end)

		it('"acd" should match "a!(@(b|B))"', function()
			assert(isMatch("acd", "a!(@(b|B))", { bash = true }))
		end)

		it('"acd" should match "a!(@(b|B))d"', function()
			assert(isMatch("acd", "a!(@(b|B))d", { bash = true }))
		end)

		it('"acd" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("acd", "a(b*(foo|bar))d", { bash = true }))
		end)

		it('"acd" should match "a+(b|c)d"', function()
			assert(isMatch("acd", "a+(b|c)d", { bash = true }))
		end)

		it('"acd" should not match "a[b*(foo|bar)]d"', function()
			assert(not isMatch("acd", "a[b*(foo|bar)]d", { bash = true }))
		end)

		it('"acd" should not match "ab*(e|f)"', function()
			assert(not isMatch("acd", "ab*(e|f)", { bash = true }))
		end)

		it('"acd" should not match "ab**"', function()
			assert(not isMatch("acd", "ab**", { bash = true }))
		end)

		it('"acd" should not match "ab**(e|f)"', function()
			assert(not isMatch("acd", "ab**(e|f)", { bash = true }))
		end)

		it('"acd" should not match "ab**(e|f)g"', function()
			assert(not isMatch("acd", "ab**(e|f)g", { bash = true }))
		end)

		it('"acd" should not match "ab***ef"', function()
			assert(not isMatch("acd", "ab***ef", { bash = true }))
		end)

		it('"acd" should not match "ab*+(e|f)"', function()
			assert(not isMatch("acd", "ab*+(e|f)", { bash = true }))
		end)

		it('"acd" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("acd", "ab*d+(e|f)", { bash = true }))
		end)

		it('"acd" should not match "ab?*(e|f)"', function()
			assert(not isMatch("acd", "ab?*(e|f)", { bash = true }))
		end)

		it('"ax" should match "?(a*|b)"', function()
			assert(isMatch("ax", "?(a*|b)", { bash = true }))
		end)

		it('"ax" should not match "a?(b*)"', function()
			assert(not isMatch("ax", "a?(b*)", { bash = true }))
		end)

		it('"axz" should not match "a+(z)"', function()
			assert(not isMatch("axz", "a+(z)", { bash = true }))
		end)

		it('"az" should not match "a!(*)"', function()
			assert(not isMatch("az", "a!(*)", { bash = true }))
		end)

		it('"az" should not match "a!(z)"', function()
			assert(not isMatch("az", "a!(z)", { bash = true }))
		end)

		it('"az" should match "a*!(z)"', function()
			assert(isMatch("az", "a*!(z)", { bash = true }))
		end)

		it('"az" should match "a*(z)"', function()
			assert(isMatch("az", "a*(z)", { bash = true }))
		end)

		it('"az" should match "a**(z)"', function()
			assert(isMatch("az", "a**(z)", { bash = true }))
		end)

		it('"az" should match "a*@(z)"', function()
			assert(isMatch("az", "a*@(z)", { bash = true }))
		end)

		it('"az" should match "a+(z)"', function()
			assert(isMatch("az", "a+(z)", { bash = true }))
		end)

		it('"az" should match "a?(z)"', function()
			assert(isMatch("az", "a?(z)", { bash = true }))
		end)

		it('"az" should match "a@(z)"', function()
			assert(isMatch("az", "a@(z)", { bash = true }))
		end)

		itFIXME('"az" should not match "a\\z"', function()
			assert(not isMatch("az", "a\\\\z", { bash = true, windows = false }))
		end)

		itFIXME('"az" should not match "a\\z"_', function()
			assert(not isMatch("az", "a\\\\z", { bash = true }))
		end)

		it('"b" should match "!(a)*"', function()
			assert(isMatch("b", "!(a)*", { bash = true }))
		end)

		it('"b" should match "(a+|b)*"', function()
			assert(isMatch("b", "(a+|b)*", { bash = true }))
		end)

		it('"b" should not match "a!(b)*"', function()
			assert(not isMatch("b", "a!(b)*", { bash = true }))
		end)

		it('"b.a" should match "(b|a).(a)"', function()
			assert(isMatch("b.a", "(b|a).(a)", { bash = true }))
		end)

		it('"b.a" should match "@(b|a).@(a)"', function()
			assert(isMatch("b.a", "@(b|a).@(a)", { bash = true }))
		end)

		it('"b/a" should not match "!(b/a)"', function()
			assert(not isMatch("b/a", "!(b/a)", { bash = true }))
		end)

		it('"b/b" should match "!(b/a)"', function()
			assert(isMatch("b/b", "!(b/a)", { bash = true }))
		end)

		it('"b/c" should match "!(b/a)"', function()
			assert(isMatch("b/c", "!(b/a)", { bash = true }))
		end)

		it('"b/c" should not match "b/!(c)"', function()
			assert(not isMatch("b/c", "b/!(c)", { bash = true }))
		end)

		it('"b/c" should match "b/!(cc)"', function()
			assert(isMatch("b/c", "b/!(cc)", { bash = true }))
		end)

		it('"b/c.txt" should not match "b/!(c).txt"', function()
			assert(not isMatch("b/c.txt", "b/!(c).txt", { bash = true }))
		end)

		it('"b/c.txt" should match "b/!(cc).txt"', function()
			assert(isMatch("b/c.txt", "b/!(cc).txt", { bash = true }))
		end)

		it('"b/cc" should match "b/!(c)"', function()
			assert(isMatch("b/cc", "b/!(c)", { bash = true }))
		end)

		it('"b/cc" should not match "b/!(cc)"', function()
			assert(not isMatch("b/cc", "b/!(cc)", { bash = true }))
		end)

		it('"b/cc.txt" should not match "b/!(c).txt"', function()
			assert(not isMatch("b/cc.txt", "b/!(c).txt", { bash = true }))
		end)

		it('"b/cc.txt" should not match "b/!(cc).txt"', function()
			assert(not isMatch("b/cc.txt", "b/!(cc).txt", { bash = true }))
		end)

		it('"b/ccc" should match "b/!(c)"', function()
			assert(isMatch("b/ccc", "b/!(c)", { bash = true }))
		end)

		it('"ba" should match "!(a!(b))"', function()
			assert(isMatch("ba", "!(a!(b))", { bash = true }))
		end)

		it('"ba" should match "b?(a|b)"', function()
			assert(isMatch("ba", "b?(a|b)", { bash = true }))
		end)

		it('"baaac" should not match "*(@(a))a@(c)"', function()
			assert(not isMatch("baaac", "*(@(a))a@(c)", { bash = true }))
		end)

		it('"bar" should match "!(foo)"', function()
			assert(isMatch("bar", "!(foo)", { bash = true }))
		end)

		it('"bar" should match "!(foo)*"', function()
			assert(isMatch("bar", "!(foo)*", { bash = true }))
		end)

		it('"bar" should match "!(foo)b*"', function()
			assert(isMatch("bar", "!(foo)b*", { bash = true }))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"bar" should match "*(!(foo))"', function()
			assert(isMatch("bar", "*(!(foo))", { bash = true }))
		end)

		it('"baz" should match "!(foo)*"', function()
			assert(isMatch("baz", "!(foo)*", { bash = true }))
		end)

		it('"baz" should match "!(foo)b*"', function()
			assert(isMatch("baz", "!(foo)b*", { bash = true }))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"baz" should match "*(!(foo))"', function()
			assert(isMatch("baz", "*(!(foo))", { bash = true }))
		end)

		it('"bb" should match "!(a!(b))"', function()
			assert(isMatch("bb", "!(a!(b))", { bash = true }))
		end)

		it('"bb" should match "!(a)*"', function()
			assert(isMatch("bb", "!(a)*", { bash = true }))
		end)

		it('"bb" should not match "a!(b)*"', function()
			assert(not isMatch("bb", "a!(b)*", { bash = true }))
		end)

		it('"bb" should not match "a?(a|b)"', function()
			assert(not isMatch("bb", "a?(a|b)", { bash = true }))
		end)

		it('"bbc" should match "!([[*])*"', function()
			assert(isMatch("bbc", "!([[*])*", { bash = true }))
		end)

		it('"bbc" should not match "+(a|b\\[)*"', function()
			assert(not isMatch("bbc", "+(a|b\\[)*", { bash = true }))
		end)

		it('"bbc" should not match "[a*(]*z"', function()
			assert(not isMatch("bbc", "[a*(]*z", { bash = true }))
		end)

		it('"bz" should not match "a+(z)"', function()
			assert(not isMatch("bz", "a+(z)", { bash = true }))
		end)

		it('"c" should not match "*(@(a))a@(c)"', function()
			assert(not isMatch("c", "*(@(a))a@(c)", { bash = true }))
		end)

		itFIXME('"c.a" should not match "!(*.[a-b]*)"', function()
			assert(not isMatch("c.a", "!(*.[a-b]*)", { bash = true }))
		end)

		it('"c.a" should match "!(*[a-b].[a-b]*)"', function()
			assert(isMatch("c.a", "!(*[a-b].[a-b]*)", { bash = true }))
		end)

		it('"c.a" should not match "!*.(a|b)"', function()
			assert(not isMatch("c.a", "!*.(a|b)", { bash = true }))
		end)

		it('"c.a" should not match "!*.(a|b)*"', function()
			assert(not isMatch("c.a", "!*.(a|b)*", { bash = true }))
		end)

		it('"c.a" should not match "(b|a).(a)"', function()
			assert(not isMatch("c.a", "(b|a).(a)", { bash = true }))
		end)

		it('"c.a" should not match "*.!(a)"', function()
			assert(not isMatch("c.a", "*.!(a)", { bash = true }))
		end)

		it('"c.a" should not match "*.+(b|d)"', function()
			assert(not isMatch("c.a", "*.+(b|d)", { bash = true }))
		end)

		it('"c.a" should not match "@(b|a).@(a)"', function()
			assert(not isMatch("c.a", "@(b|a).@(a)", { bash = true }))
		end)

		it('"c.c" should not match "!(*.a|*.b|*.c)"', function()
			assert(not isMatch("c.c", "!(*.a|*.b|*.c)", { bash = true }))
		end)

		it('"c.c" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("c.c", "*!(.a|.b|.c)", { bash = true }))
		end)

		it('"c.c" should not match "*.!(a|b|c)"', function()
			assert(not isMatch("c.c", "*.!(a|b|c)", { bash = true }))
		end)

		it('"c.c" should not match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(not isMatch("c.c", "*.(a|b|@(ab|a*@(b))*(c)d)", { bash = true }))
		end)

		it('"c.ccc" should match "!(*.[a-b]*)"', function()
			assert(isMatch("c.ccc", "!(*.[a-b]*)", { bash = true }))
		end)

		it('"c.ccc" should match "!(*[a-b].[a-b]*)"', function()
			assert(isMatch("c.ccc", "!(*[a-b].[a-b]*)", { bash = true }))
		end)

		it('"c.js" should not match "!(*.js)"', function()
			assert(not isMatch("c.js", "!(*.js)", { bash = true }))
		end)

		it('"c.js" should match "*!(.js)"', function()
			assert(isMatch("c.js", "*!(.js)", { bash = true }))
		end)

		it('"c.js" should not match "*.!(js)"', function()
			assert(not isMatch("c.js", "*.!(js)", { bash = true }))
		end)

		it('"c/a/v" should match "c/!(z)/v"', function()
			assert(isMatch("c/a/v", "c/!(z)/v", { bash = true }))
		end)

		it('"c/a/v" should not match "c/*(z)/v"', function()
			assert(not isMatch("c/a/v", "c/*(z)/v", { bash = true }))
		end)

		it('"c/a/v" should not match "c/+(z)/v"', function()
			assert(not isMatch("c/a/v", "c/+(z)/v", { bash = true }))
		end)

		it('"c/a/v" should not match "c/@(z)/v"', function()
			assert(not isMatch("c/a/v", "c/@(z)/v", { bash = true }))
		end)

		it('"c/z/v" should not match "*(z)"', function()
			assert(not isMatch("c/z/v", "*(z)", { bash = true }))
		end)

		it('"c/z/v" should not match "+(z)"', function()
			assert(not isMatch("c/z/v", "+(z)", { bash = true }))
		end)

		it('"c/z/v" should not match "?(z)"', function()
			assert(not isMatch("c/z/v", "?(z)", { bash = true }))
		end)

		it('"c/z/v" should not match "c/!(z)/v"', function()
			assert(not isMatch("c/z/v", "c/!(z)/v", { bash = true }))
		end)

		it('"c/z/v" should match "c/*(z)/v"', function()
			assert(isMatch("c/z/v", "c/*(z)/v", { bash = true }))
		end)

		it('"c/z/v" should match "c/+(z)/v"', function()
			assert(isMatch("c/z/v", "c/+(z)/v", { bash = true }))
		end)

		it('"c/z/v" should match "c/@(z)/v"', function()
			assert(isMatch("c/z/v", "c/@(z)/v", { bash = true }))
		end)

		it('"c/z/v" should match "c/z/v"', function()
			assert(isMatch("c/z/v", "c/z/v", { bash = true }))
		end)

		it('"cc.a" should not match "(b|a).(a)"', function()
			assert(not isMatch("cc.a", "(b|a).(a)", { bash = true }))
		end)

		it('"cc.a" should not match "@(b|a).@(a)"', function()
			assert(not isMatch("cc.a", "@(b|a).@(a)", { bash = true }))
		end)

		it('"ccc" should match "!(a)*"', function()
			assert(isMatch("ccc", "!(a)*", { bash = true }))
		end)

		it('"ccc" should not match "a!(b)*"', function()
			assert(not isMatch("ccc", "a!(b)*", { bash = true }))
		end)

		it('"cow" should match "!(*.*)"', function()
			assert(isMatch("cow", "!(*.*)", { bash = true }))
		end)

		it('"cow" should not match "!(*.*)."', function()
			assert(not isMatch("cow", "!(*.*).", { bash = true }))
		end)

		it('"cow" should not match ".!(*.*)"', function()
			assert(not isMatch("cow", ".!(*.*)", { bash = true }))
		end)

		it('"cz" should not match "a!(*)"', function()
			assert(not isMatch("cz", "a!(*)", { bash = true }))
		end)

		it('"cz" should not match "a!(z)"', function()
			assert(not isMatch("cz", "a!(z)", { bash = true }))
		end)

		it('"cz" should not match "a*!(z)"', function()
			assert(not isMatch("cz", "a*!(z)", { bash = true }))
		end)

		it('"cz" should not match "a*(z)"', function()
			assert(not isMatch("cz", "a*(z)", { bash = true }))
		end)

		it('"cz" should not match "a**(z)"', function()
			assert(not isMatch("cz", "a**(z)", { bash = true }))
		end)

		it('"cz" should not match "a*@(z)"', function()
			assert(not isMatch("cz", "a*@(z)", { bash = true }))
		end)

		it('"cz" should not match "a+(z)"', function()
			assert(not isMatch("cz", "a+(z)", { bash = true }))
		end)

		it('"cz" should not match "a?(z)"', function()
			assert(not isMatch("cz", "a?(z)", { bash = true }))
		end)

		it('"cz" should not match "a@(z)"', function()
			assert(not isMatch("cz", "a@(z)", { bash = true }))
		end)

		itFIXME('"d.a.d" should not match "!(*.[a-b]*)"', function()
			assert(not isMatch("d.a.d", "!(*.[a-b]*)", { bash = true }))
		end)

		it('"d.a.d" should match "!(*[a-b].[a-b]*)"', function()
			assert(isMatch("d.a.d", "!(*[a-b].[a-b]*)", { bash = true }))
		end)

		it('"d.a.d" should not match "!*.(a|b)*"', function()
			assert(not isMatch("d.a.d", "!*.(a|b)*", { bash = true }))
		end)

		it('"d.a.d" should match "!*.*(a|b)"', function()
			assert(isMatch("d.a.d", "!*.*(a|b)", { bash = true }))
		end)

		it('"d.a.d" should not match "!*.{a,b}*"', function()
			assert(not isMatch("d.a.d", "!*.{a,b}*", { bash = true }))
		end)

		it('"d.a.d" should match "*.!(a)"', function()
			assert(isMatch("d.a.d", "*.!(a)", { bash = true }))
		end)

		it('"d.a.d" should match "*.+(b|d)"', function()
			assert(isMatch("d.a.d", "*.+(b|d)", { bash = true }))
		end)

		it('"d.d" should match "!(*.a|*.b|*.c)"', function()
			assert(isMatch("d.d", "!(*.a|*.b|*.c)", { bash = true }))
		end)

		it('"d.d" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("d.d", "*!(.a|.b|.c)", { bash = true }))
		end)

		it('"d.d" should match "*.!(a|b|c)"', function()
			assert(isMatch("d.d", "*.!(a|b|c)", { bash = true }))
		end)

		it('"d.d" should not match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(not isMatch("d.d", "*.(a|b|@(ab|a*@(b))*(c)d)", { bash = true }))
		end)

		it('"d.js.d" should match "!(*.js)"', function()
			assert(isMatch("d.js.d", "!(*.js)", { bash = true }))
		end)

		it('"d.js.d" should match "*!(.js)"', function()
			assert(isMatch("d.js.d", "*!(.js)", { bash = true }))
		end)

		it('"d.js.d" should match "*.!(js)"', function()
			assert(isMatch("d.js.d", "*.!(js)", { bash = true }))
		end)

		it('"dd.aa.d" should not match "(b|a).(a)"', function()
			assert(not isMatch("dd.aa.d", "(b|a).(a)", { bash = true }))
		end)

		it('"dd.aa.d" should not match "@(b|a).@(a)"', function()
			assert(not isMatch("dd.aa.d", "@(b|a).@(a)", { bash = true }))
		end)

		it('"def" should not match "()ef"', function()
			assert(not isMatch("def", "()ef", { bash = true }))
		end)

		it('"e.e" should match "!(*.a|*.b|*.c)"', function()
			assert(isMatch("e.e", "!(*.a|*.b|*.c)", { bash = true }))
		end)

		it('"e.e" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("e.e", "*!(.a|.b|.c)", { bash = true }))
		end)

		it('"e.e" should match "*.!(a|b|c)"', function()
			assert(isMatch("e.e", "*.!(a|b|c)", { bash = true }))
		end)

		it('"e.e" should not match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(not isMatch("e.e", "*.(a|b|@(ab|a*@(b))*(c)d)", { bash = true }))
		end)

		it('"ef" should match "()ef"', function()
			assert(isMatch("ef", "()ef", { bash = true }))
		end)

		it('"effgz" should match "@(b+(c)d|e*(f)g?|?(h)i@(j|k))"', function()
			assert(isMatch("effgz", "@(b+(c)d|e*(f)g?|?(h)i@(j|k))", { bash = true }))
		end)

		it('"efgz" should match "@(b+(c)d|e*(f)g?|?(h)i@(j|k))"', function()
			assert(isMatch("efgz", "@(b+(c)d|e*(f)g?|?(h)i@(j|k))", { bash = true }))
		end)

		it('"egz" should match "@(b+(c)d|e*(f)g?|?(h)i@(j|k))"', function()
			assert(isMatch("egz", "@(b+(c)d|e*(f)g?|?(h)i@(j|k))", { bash = true }))
		end)

		it('"egz" should not match "@(b+(c)d|e+(f)g?|?(h)i@(j|k))"', function()
			assert(not isMatch("egz", "@(b+(c)d|e+(f)g?|?(h)i@(j|k))", { bash = true }))
		end)

		it('"egzefffgzbcdij" should match "*(b+(c)d|e*(f)g?|?(h)i@(j|k))"', function()
			assert(isMatch("egzefffgzbcdij", "*(b+(c)d|e*(f)g?|?(h)i@(j|k))", { bash = true }))
		end)

		it('"f" should not match "!(f!(o))"', function()
			assert(not isMatch("f", "!(f!(o))", { bash = true }))
		end)

		it('"f" should match "!(f(o))"', function()
			assert(isMatch("f", "!(f(o))", { bash = true }))
		end)

		it('"f" should not match "!(f)"', function()
			assert(not isMatch("f", "!(f)", { bash = true }))
		end)

		it('"f" should not match "*(!(f))"', function()
			assert(not isMatch("f", "*(!(f))", { bash = true }))
		end)

		it('"f" should not match "+(!(f))"', function()
			assert(not isMatch("f", "+(!(f))", { bash = true }))
		end)

		it('"f.a" should not match "!(*.a|*.b|*.c)"', function()
			assert(not isMatch("f.a", "!(*.a|*.b|*.c)", { bash = true }))
		end)

		it('"f.a" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("f.a", "*!(.a|.b|.c)", { bash = true }))
		end)

		it('"f.a" should not match "*.!(a|b|c)"', function()
			assert(not isMatch("f.a", "*.!(a|b|c)", { bash = true }))
		end)

		it('"f.f" should match "!(*.a|*.b|*.c)"', function()
			assert(isMatch("f.f", "!(*.a|*.b|*.c)", { bash = true }))
		end)

		it('"f.f" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("f.f", "*!(.a|.b|.c)", { bash = true }))
		end)

		it('"f.f" should match "*.!(a|b|c)"', function()
			assert(isMatch("f.f", "*.!(a|b|c)", { bash = true }))
		end)

		it('"f.f" should not match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(not isMatch("f.f", "*.(a|b|@(ab|a*@(b))*(c)d)", { bash = true }))
		end)

		it('"fa" should not match "!(f!(o))"', function()
			assert(not isMatch("fa", "!(f!(o))", { bash = true }))
		end)

		it('"fa" should match "!(f(o))"', function()
			assert(isMatch("fa", "!(f(o))", { bash = true }))
		end)

		it('"fb" should not match "!(f!(o))"', function()
			assert(not isMatch("fb", "!(f!(o))", { bash = true }))
		end)

		it('"fb" should match "!(f(o))"', function()
			assert(isMatch("fb", "!(f(o))", { bash = true }))
		end)

		it('"fff" should match "!(f)"', function()
			assert(isMatch("fff", "!(f)", { bash = true }))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"fff" should match "*(!(f))"', function()
			assert(isMatch("fff", "*(!(f))", { bash = true }))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"fff" should match "+(!(f))"', function()
			assert(isMatch("fff", "+(!(f))", { bash = true }))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"fffooofoooooffoofffooofff" should match "*(*(f)*(o))"', function()
			assert(isMatch("fffooofoooooffoofffooofff", "*(*(f)*(o))", { bash = true }))
		end)

		it('"ffo" should match "*(f*(o))"', function()
			assert(isMatch("ffo", "*(f*(o))", { bash = true }))
		end)

		it('"file.C" should not match "*.c?(c)"', function()
			assert(not isMatch("file.C", "*.c?(c)", { bash = true }))
		end)

		it('"file.c" should match "*.c?(c)"', function()
			assert(isMatch("file.c", "*.c?(c)", { bash = true }))
		end)

		it('"file.cc" should match "*.c?(c)"', function()
			assert(isMatch("file.cc", "*.c?(c)", { bash = true }))
		end)

		it('"file.ccc" should not match "*.c?(c)"', function()
			assert(not isMatch("file.ccc", "*.c?(c)", { bash = true }))
		end)

		it('"fo" should match "!(f!(o))"', function()
			assert(isMatch("fo", "!(f!(o))", { bash = true }))
		end)

		it('"fo" should not match "!(f(o))"', function()
			assert(not isMatch("fo", "!(f(o))", { bash = true }))
		end)

		it('"fofo" should match "*(f*(o))"', function()
			assert(isMatch("fofo", "*(f*(o))", { bash = true }))
		end)

		it('"fofoofoofofoo" should match "*(fo|foo)"', function()
			assert(isMatch("fofoofoofofoo", "*(fo|foo)", { bash = true }))
		end)

		it('"fofoofoofofoo" should match "*(fo|foo)"_', function()
			assert(isMatch("fofoofoofofoo", "*(fo|foo)", { bash = true }))
		end)

		it('"foo" should match "!(!(foo))"', function()
			assert(isMatch("foo", "!(!(foo))", { bash = true }))
		end)

		it('"foo" should match "!(f)"', function()
			assert(isMatch("foo", "!(f)", { bash = true }))
		end)

		it('"foo" should not match "!(foo)"', function()
			assert(not isMatch("foo", "!(foo)", { bash = true }))
		end)

		it('"foo" should not match "!(foo)*"', function()
			assert(not isMatch("foo", "!(foo)*", { bash = true }))
		end)

		it('"foo" should not match "!(foo)*"_', function()
			assert(not isMatch("foo", "!(foo)*", { bash = true }))
		end)

		it('"foo" should not match "!(foo)+"', function()
			assert(not isMatch("foo", "!(foo)+", { bash = true }))
		end)

		it('"foo" should not match "!(foo)b*"', function()
			assert(not isMatch("foo", "!(foo)b*", { bash = true }))
		end)

		it('"foo" should match "!(x)"', function()
			assert(isMatch("foo", "!(x)", { bash = true }))
		end)

		it('"foo" should match "!(x)*"', function()
			assert(isMatch("foo", "!(x)*", { bash = true }))
		end)

		it('"foo" should match "*"', function()
			assert(isMatch("foo", "*", { bash = true }))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"foo" should match "*(!(f))"', function()
			assert(isMatch("foo", "*(!(f))", { bash = true }))
		end)

		it('"foo" should not match "*(!(foo))"', function()
			assert(not isMatch("foo", "*(!(foo))", { bash = true }))
		end)

		it('"foo" should not match "*(@(a))a@(c)"', function()
			assert(not isMatch("foo", "*(@(a))a@(c)", { bash = true }))
		end)

		it('"foo" should match "*(@(foo))"', function()
			assert(isMatch("foo", "*(@(foo))", { bash = true }))
		end)

		it('"foo" should not match "*(a|b\\[)"', function()
			assert(not isMatch("foo", "*(a|b\\[)", { bash = true }))
		end)

		it('"foo" should match "*(a|b\\[)|f*"', function()
			assert(isMatch("foo", "*(a|b\\[)|f*", { bash = true }))
		end)

		it('"foo" should match "@(*(a|b\\[)|f*)"', function()
			assert(isMatch("foo", "@(*(a|b\\[)|f*)", { bash = true }))
		end)

		it('"foo" should not match "*/*/*"', function()
			assert(not isMatch("foo", "*/*/*", { bash = true }))
		end)

		it('"foo" should not match "*f"', function()
			assert(not isMatch("foo", "*f", { bash = true }))
		end)

		it('"foo" should match "*foo*"', function()
			assert(isMatch("foo", "*foo*", { bash = true }))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"foo" should match "+(!(f))"', function()
			assert(isMatch("foo", "+(!(f))", { bash = true }))
		end)

		it('"foo" should not match "??"', function()
			assert(not isMatch("foo", "??", { bash = true }))
		end)

		it('"foo" should match "???"', function()
			assert(isMatch("foo", "???", { bash = true }))
		end)

		it('"foo" should not match "bar"', function()
			assert(not isMatch("foo", "bar", { bash = true }))
		end)

		it('"foo" should match "f*"', function()
			assert(isMatch("foo", "f*", { bash = true }))
		end)

		it('"foo" should not match "fo"', function()
			assert(not isMatch("foo", "fo", { bash = true }))
		end)

		it('"foo" should match "foo"', function()
			assert(isMatch("foo", "foo", { bash = true }))
		end)

		it('"foo" should match "{*(a|b\\[),f*}"', function()
			assert(isMatch("foo", "{*(a|b\\[),f*}", { bash = true }))
		end)

		it('"foo*" should match "foo\\*"', function()
			assert(isMatch("foo*", "foo\\*", { bash = true, windows = false }))
		end)

		it('"foo*bar" should match "foo\\*bar"', function()
			assert(isMatch("foo*bar", "foo\\*bar", { bash = true }))
		end)

		it('"foo.js" should not match "!(foo).js"', function()
			assert(not isMatch("foo.js", "!(foo).js", { bash = true }))
		end)

		it('"foo.js.js" should match "*.!(js)"', function()
			assert(isMatch("foo.js.js", "*.!(js)", { bash = true }))
		end)

		it('"foo.js.js" should not match "*.!(js)*"', function()
			assert(not isMatch("foo.js.js", "*.!(js)*", { bash = true }))
		end)

		it('"foo.js.js" should not match "*.!(js)*.!(js)"', function()
			assert(not isMatch("foo.js.js", "*.!(js)*.!(js)", { bash = true }))
		end)

		it('"foo.js.js" should not match "*.!(js)+"', function()
			assert(not isMatch("foo.js.js", "*.!(js)+", { bash = true }))
		end)

		it('"foo.txt" should match "**/!(bar).txt"', function()
			assert(isMatch("foo.txt", "**/!(bar).txt", { bash = true }))
		end)

		it('"foo/bar" should not match "*/*/*"', function()
			assert(not isMatch("foo/bar", "*/*/*", { bash = true }))
		end)

		it('"foo/bar" should match "foo/!(foo)"', function()
			assert(isMatch("foo/bar", "foo/!(foo)", { bash = true }))
		end)

		it('"foo/bar" should match "foo/*"', function()
			assert(isMatch("foo/bar", "foo/*", { bash = true }))
		end)

		it('"foo/bar" should match "foo/bar"', function()
			assert(isMatch("foo/bar", "foo/bar", { bash = true }))
		end)

		it('"foo/bar" should not match "foo?bar"', function()
			assert(not isMatch("foo/bar", "foo?bar", { bash = true }))
		end)

		itFIXME('"foo/bar" should match "foo[/]bar"', function()
			assert(isMatch("foo/bar", "foo[/]bar", { bash = true }))
		end)

		it('"foo/bar/baz.jsx" should match "foo/bar/**/*.+(js|jsx)"', function()
			assert(isMatch("foo/bar/baz.jsx", "foo/bar/**/*.+(js|jsx)", { bash = true }))
		end)

		it('"foo/bar/baz.jsx" should match "foo/bar/*.+(js|jsx)"', function()
			assert(isMatch("foo/bar/baz.jsx", "foo/bar/*.+(js|jsx)", { bash = true }))
		end)

		it('"foo/bb/aa/rr" should match "**/**/**"', function()
			assert(isMatch("foo/bb/aa/rr", "**/**/**", { bash = true }))
		end)

		it('"foo/bb/aa/rr" should match "*/*/*"', function()
			assert(isMatch("foo/bb/aa/rr", "*/*/*", { bash = true }))
		end)

		it('"foo/bba/arr" should match "*/*/*"', function()
			assert(isMatch("foo/bba/arr", "*/*/*", { bash = true }))
		end)

		it('"foo/bba/arr" should match "foo*"', function()
			assert(isMatch("foo/bba/arr", "foo*", { bash = true }))
		end)

		it('"foo/bba/arr" should match "foo**"', function()
			assert(isMatch("foo/bba/arr", "foo**", { bash = true }))
		end)

		it('"foo/bba/arr" should match "foo/*"', function()
			assert(isMatch("foo/bba/arr", "foo/*", { bash = true }))
		end)

		it('"foo/bba/arr" should match "foo/**"', function()
			assert(isMatch("foo/bba/arr", "foo/**", { bash = true }))
		end)

		it('"foo/bba/arr" should match "foo/**arr"', function()
			assert(isMatch("foo/bba/arr", "foo/**arr", { bash = true }))
		end)

		it('"foo/bba/arr" should not match "foo/**z"', function()
			assert(not isMatch("foo/bba/arr", "foo/**z", { bash = true }))
		end)

		it('"foo/bba/arr" should match "foo/*arr"', function()
			assert(isMatch("foo/bba/arr", "foo/*arr", { bash = true }))
		end)

		it('"foo/bba/arr" should not match "foo/*z"', function()
			assert(not isMatch("foo/bba/arr", "foo/*z", { bash = true }))
		end)

		it('"foob" should not match "!(foo)b*"', function()
			assert(not isMatch("foob", "!(foo)b*", { bash = true }))
		end)

		it('"foob" should not match "(foo)bb"', function()
			assert(not isMatch("foob", "(foo)bb", { bash = true }))
		end)

		it('"foobar" should match "!(foo)"', function()
			assert(isMatch("foobar", "!(foo)", { bash = true }))
		end)

		it('"foobar" should not match "!(foo)*"', function()
			assert(not isMatch("foobar", "!(foo)*", { bash = true }))
		end)

		it('"foobar" should not match "!(foo)*"_', function()
			assert(not isMatch("foobar", "!(foo)*", { bash = true }))
		end)

		it('"foobar" should not match "!(foo)b*"', function()
			assert(not isMatch("foobar", "!(foo)b*", { bash = true }))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"foobar" should match "*(!(foo))"', function()
			assert(isMatch("foobar", "*(!(foo))", { bash = true }))
		end)

		it('"foobar" should match "*ob*a*r*"', function()
			assert(isMatch("foobar", "*ob*a*r*", { bash = true }))
		end)

		it('"foobar" should match "foo\\*bar"', function()
			assert(isMatch("foobar", "foo*bar", { bash = true }))
		end)

		it('"foobb" should not match "!(foo)b*"', function()
			assert(not isMatch("foobb", "!(foo)b*", { bash = true }))
		end)

		it('"foobb" should match "(foo)bb"', function()
			assert(isMatch("foobb", "(foo)bb", { bash = true }))
		end)

		it('"(foo)bb" should match "\\(foo\\)bb"', function()
			assert(isMatch("(foo)bb", "\\(foo\\)bb", { bash = true }))
		end)

		it('"foofoofo" should match "@(foo|f|fo)*(f|of+(o))"', function()
			assert(isMatch("foofoofo", "@(foo|f|fo)*(f|of+(o))", { bash = true }))
		end)

		it('"foofoofo" should match "@(foo|f|fo)*(f|of+(o))"_', function()
			assert(isMatch("foofoofo", "@(foo|f|fo)*(f|of+(o))", { bash = true }))
		end)

		it('"fooofoofofooo" should match "*(f*(o))"', function()
			assert(isMatch("fooofoofofooo", "*(f*(o))", { bash = true }))
		end)

		it('"foooofo" should match "*(f*(o))"', function()
			assert(isMatch("foooofo", "*(f*(o))", { bash = true }))
		end)

		it('"foooofof" should match "*(f*(o))"', function()
			assert(isMatch("foooofof", "*(f*(o))", { bash = true }))
		end)

		it('"foooofof" should not match "*(f+(o))"', function()
			assert(not isMatch("foooofof", "*(f+(o))", { bash = true }))
		end)

		it('"foooofofx" should not match "*(f*(o))"', function()
			assert(not isMatch("foooofofx", "*(f*(o))", { bash = true }))
		end)

		it('"foooxfooxfoxfooox" should match "*(f*(o)x)"', function()
			assert(isMatch("foooxfooxfoxfooox", "*(f*(o)x)", { bash = true }))
		end)

		it('"foooxfooxfxfooox" should match "*(f*(o)x)"', function()
			assert(isMatch("foooxfooxfxfooox", "*(f*(o)x)", { bash = true }))
		end)

		it('"foooxfooxofoxfooox" should not match "*(f*(o)x)"', function()
			assert(not isMatch("foooxfooxofoxfooox", "*(f*(o)x)", { bash = true }))
		end)

		it('"foot" should match "@(!(z*)|*x)"', function()
			assert(isMatch("foot", "@(!(z*)|*x)", { bash = true }))
		end)

		it('"foox" should match "@(!(z*)|*x)"', function()
			assert(isMatch("foox", "@(!(z*)|*x)", { bash = true }))
		end)

		it('"fz" should not match "*(z)"', function()
			assert(not isMatch("fz", "*(z)", { bash = true }))
		end)

		it('"fz" should not match "+(z)"', function()
			assert(not isMatch("fz", "+(z)", { bash = true }))
		end)

		it('"fz" should not match "?(z)"', function()
			assert(not isMatch("fz", "?(z)", { bash = true }))
		end)

		it('"moo.cow" should not match "!(moo).!(cow)"', function()
			assert(not isMatch("moo.cow", "!(moo).!(cow)", { bash = true }))
		end)

		it('"moo.cow" should not match "!(*).!(*)"', function()
			assert(not isMatch("moo.cow", "!(*).!(*)", { bash = true }))
		end)

		it('"moo.cow" should not match "!(*.*).!(*.*)"', function()
			assert(not isMatch("moo.cow", "!(*.*).!(*.*)", { bash = true }))
		end)

		it('"mad.moo.cow" should not match "!(*.*).!(*.*)"', function()
			assert(not isMatch("mad.moo.cow", "!(*.*).!(*.*)", { bash = true }))
		end)

		it('"mad.moo.cow" should not match ".!(*.*)"', function()
			assert(not isMatch("mad.moo.cow", ".!(*.*)", { bash = true }))
		end)

		it('"Makefile" should match "!(*.c|*.h|Makefile.in|config*|README)"', function()
			assert(isMatch("Makefile", "!(*.c|*.h|Makefile.in|config*|README)", { bash = true }))
		end)

		it('"Makefile.in" should not match "!(*.c|*.h|Makefile.in|config*|README)"', function()
			assert(not isMatch("Makefile.in", "!(*.c|*.h|Makefile.in|config*|README)", { bash = true }))
		end)

		it('"moo" should match "!(*.*)"', function()
			assert(isMatch("moo", "!(*.*)", { bash = true }))
		end)

		it('"moo" should not match "!(*.*)."', function()
			assert(not isMatch("moo", "!(*.*).", { bash = true }))
		end)

		it('"moo" should not match ".!(*.*)"', function()
			assert(not isMatch("moo", ".!(*.*)", { bash = true }))
		end)

		it('"moo.cow" should not match "!(*.*)"', function()
			assert(not isMatch("moo.cow", "!(*.*)", { bash = true }))
		end)

		it('"moo.cow" should not match "!(*.*)."', function()
			assert(not isMatch("moo.cow", "!(*.*).", { bash = true }))
		end)

		it('"moo.cow" should not match ".!(*.*)"', function()
			assert(not isMatch("moo.cow", ".!(*.*)", { bash = true }))
		end)

		it('"mucca.pazza" should not match "mu!(*(c))?.pa!(*(z))?"', function()
			assert(not isMatch("mucca.pazza", "mu!(*(c))?.pa!(*(z))?", { bash = true }))
		end)

		it('"ofoofo" should match "*(of+(o))"', function()
			assert(isMatch("ofoofo", "*(of+(o))", { bash = true }))
		end)

		it('"ofoofo" should match "*(of+(o)|f)"', function()
			assert(isMatch("ofoofo", "*(of+(o)|f)", { bash = true }))
		end)

		it('"ofooofoofofooo" should not match "*(f*(o))"', function()
			assert(not isMatch("ofooofoofofooo", "*(f*(o))", { bash = true }))
		end)

		it('"ofoooxoofxo" should match "*(*(of*(o)x)o)"', function()
			assert(isMatch("ofoooxoofxo", "*(*(of*(o)x)o)", { bash = true }))
		end)

		it('"ofoooxoofxoofoooxoofxo" should match "*(*(of*(o)x)o)"', function()
			assert(isMatch("ofoooxoofxoofoooxoofxo", "*(*(of*(o)x)o)", { bash = true }))
		end)

		it('"ofoooxoofxoofoooxoofxofo" should not match "*(*(of*(o)x)o)"', function()
			assert(not isMatch("ofoooxoofxoofoooxoofxofo", "*(*(of*(o)x)o)", { bash = true }))
		end)

		it('"ofoooxoofxoofoooxoofxoo" should match "*(*(of*(o)x)o)"', function()
			assert(isMatch("ofoooxoofxoofoooxoofxoo", "*(*(of*(o)x)o)", { bash = true }))
		end)

		it('"ofoooxoofxoofoooxoofxooofxofxo" should match "*(*(of*(o)x)o)"', function()
			assert(isMatch("ofoooxoofxoofoooxoofxooofxofxo", "*(*(of*(o)x)o)", { bash = true }))
		end)

		it('"ofxoofxo" should match "*(*(of*(o)x)o)"', function()
			assert(isMatch("ofxoofxo", "*(*(of*(o)x)o)", { bash = true }))
		end)

		it('"oofooofo" should match "*(of|oof+(o))"', function()
			assert(isMatch("oofooofo", "*(of|oof+(o))", { bash = true }))
		end)

		it('"ooo" should match "!(f)"', function()
			assert(isMatch("ooo", "!(f)", { bash = true }))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"ooo" should match "*(!(f))"', function()
			assert(isMatch("ooo", "*(!(f))", { bash = true }))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"ooo" should match "+(!(f))"', function()
			assert(isMatch("ooo", "+(!(f))", { bash = true }))
		end)

		it('"oxfoxfox" should not match "*(oxf+(ox))"', function()
			assert(not isMatch("oxfoxfox", "*(oxf+(ox))", { bash = true }))
		end)

		it('"oxfoxoxfox" should match "*(oxf+(ox))"', function()
			assert(isMatch("oxfoxoxfox", "*(oxf+(ox))", { bash = true }))
		end)

		it('"para" should match "para*([0-9])"', function()
			assert(isMatch("para", "para*([0-9])", { bash = true }))
		end)

		it('"para" should not match "para+([0-9])"', function()
			assert(not isMatch("para", "para+([0-9])", { bash = true }))
		end)

		it('"para.38" should match "para!(*.[00-09])"', function()
			assert(isMatch("para.38", "para!(*.[00-09])", { bash = true }))
		end)

		it('"para.graph" should match "para!(*.[0-9])"', function()
			assert(isMatch("para.graph", "para!(*.[0-9])", { bash = true }))
		end)

		itFIXME('"para13829383746592" should match "para*([0-9])"', function()
			assert(isMatch("para13829383746592", "para*([0-9])", { bash = true }))
		end)

		it('"para381" should not match "para?([345]|99)1"', function()
			assert(not isMatch("para381", "para?([345]|99)1", { bash = true }))
		end)

		it('"para39" should match "para!(*.[0-9])"', function()
			assert(isMatch("para39", "para!(*.[0-9])", { bash = true }))
		end)

		itFIXME('"para987346523" should match "para+([0-9])"', function()
			assert(isMatch("para987346523", "para+([0-9])", { bash = true }))
		end)

		it('"para991" should match "para?([345]|99)1"', function()
			assert(isMatch("para991", "para?([345]|99)1", { bash = true }))
		end)

		it('"paragraph" should match "para!(*.[0-9])"', function()
			assert(isMatch("paragraph", "para!(*.[0-9])", { bash = true }))
		end)

		it('"paragraph" should not match "para*([0-9])"', function()
			assert(not isMatch("paragraph", "para*([0-9])", { bash = true }))
		end)

		it('"paragraph" should match "para@(chute|graph)"', function()
			assert(isMatch("paragraph", "para@(chute|graph)", { bash = true }))
		end)

		it('"paramour" should not match "para@(chute|graph)"', function()
			assert(not isMatch("paramour", "para@(chute|graph)", { bash = true }))
		end)

		it('"parse.y" should match "!(*.c|*.h|Makefile.in|config*|README)"', function()
			assert(isMatch("parse.y", "!(*.c|*.h|Makefile.in|config*|README)", { bash = true }))
		end)

		it('"shell.c" should not match "!(*.c|*.h|Makefile.in|config*|README)"', function()
			assert(not isMatch("shell.c", "!(*.c|*.h|Makefile.in|config*|README)", { bash = true }))
		end)

		it('"VMS.FILE;" should not match "*\\;[1-9]*([0-9])"', function()
			assert(not isMatch("VMS.FILE;", "*\\;[1-9]*([0-9])", { bash = true }))
		end)

		it('"VMS.FILE;0" should not match "*\\;[1-9]*([0-9])"', function()
			assert(not isMatch("VMS.FILE;0", "*\\;[1-9]*([0-9])", { bash = true }))
		end)

		itFIXME('"VMS.FILE;9" should match "*\\;[1-9]*([0-9])"', function()
			assert(isMatch("VMS.FILE;9", "*\\;[1-9]*([0-9])", { bash = true }))
		end)

		itFIXME('"VMS.FILE;1" should match "*\\;[1-9]*([0-9])"', function()
			assert(isMatch("VMS.FILE;1", "*\\;[1-9]*([0-9])", { bash = true }))
		end)

		itFIXME('"VMS.FILE;1" should match "*;[1-9]*([0-9])"', function()
			assert(isMatch("VMS.FILE;1", "*;[1-9]*([0-9])", { bash = true }))
		end)

		itFIXME('"VMS.FILE;139" should match "*\\;[1-9]*([0-9])"', function()
			assert(isMatch("VMS.FILE;139", "*\\;[1-9]*([0-9])", { bash = true }))
		end)

		it('"VMS.FILE;1N" should not match "*\\;[1-9]*([0-9])"', function()
			assert(not isMatch("VMS.FILE;1N", "*\\;[1-9]*([0-9])", { bash = true }))
		end)

		it('"xfoooofof" should not match "*(f*(o))"', function()
			assert(not isMatch("xfoooofof", "*(f*(o))", { bash = true }))
		end)

		it(
			'"XXX/adobe/courier/bold/o/normal//12/120/75/75/m/70/iso8859/1" should match "XXX/*/*/*/*/*/*/12/*/*/*/m/*/*/*"',
			function()
				assert(
					isMatch(
						"XXX/adobe/courier/bold/o/normal//12/120/75/75/m/70/iso8859/1",
						"XXX/*/*/*/*/*/*/12/*/*/*/m/*/*/*",
						{ bash = true, windows = false }
					)
				)
			end
		)
		it(
			'"XXX/adobe/courier/bold/o/normal//12/120/75/75/X/70/iso8859/1" should not match "XXX/*/*/*/*/*/*/12/*/*/*/m/*/*/*"',
			function()
				assert(
					not isMatch(
						"XXX/adobe/courier/bold/o/normal//12/120/75/75/X/70/iso8859/1",
						"XXX/*/*/*/*/*/*/12/*/*/*/m/*/*/*",
						{ bash = true }
					)
				)
			end
		)
		it('"z" should match "*(z)"', function()
			assert(isMatch("z", "*(z)", { bash = true }))
		end)

		it('"z" should match "+(z)"', function()
			assert(isMatch("z", "+(z)", { bash = true }))
		end)

		it('"z" should match "?(z)"', function()
			assert(isMatch("z", "?(z)", { bash = true }))
		end)

		it('"zf" should not match "*(z)"', function()
			assert(not isMatch("zf", "*(z)", { bash = true }))
		end)

		it('"zf" should not match "+(z)"', function()
			assert(not isMatch("zf", "+(z)", { bash = true }))
		end)

		it('"zf" should not match "?(z)"', function()
			assert(not isMatch("zf", "?(z)", { bash = true }))
		end)

		it('"zoot" should not match "@(!(z*)|*x)"', function()
			assert(not isMatch("zoot", "@(!(z*)|*x)", { bash = true }))
		end)

		it('"zoox" should match "@(!(z*)|*x)"', function()
			assert(isMatch("zoox", "@(!(z*)|*x)", { bash = true }))
		end)

		it('"zz" should not match "(a+|b)*"', function()
			assert(not isMatch("zz", "(a+|b)*", { bash = true }))
		end)
	end)
end
