-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/extglobs-minimatch.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent

	local support = require(CurrentModule.support)
	local isMatch = require(PicomatchModule).isMatch
	--[[*
	 * Some of tests were converted from bash 4.3, 4.4, and minimatch unit tests.
	 ]]
	describe("extglobs (minimatch)", function()
		beforeEach(function()
			return support.windowsPathSep()
		end)
		afterEach(function()
			return support.resetPathSep()
		end)

		it('should not match empty string with "*(0|1|3|5|7|9)"', function()
			assert(not isMatch("", "*(0|1|3|5|7|9)"))
		end)

		it('"*(a|b[)" should not match "*(a|b\\[)"', function()
			assert(not isMatch("*(a|b[)", "*(a|b\\[)"))
		end)

		it('"*(a|b[)" should match "\\*\\(a\\|b\\[\\)"', function()
			assert(isMatch("*(a|b[)", "\\*\\(a\\|b\\[\\)"))
		end)

		it('"***" should match "\\*\\*\\*"', function()
			assert(isMatch("***", "\\*\\*\\*"))
		end)

		it(
			'"-adobe-courier-bold-o-normal--12-120-75-75-/-70-iso8859-1" should not match "-*-*-*-*-*-*-12-*-*-*-m-*-*-*"',
			function()
				assert(
					not isMatch(
						"-adobe-courier-bold-o-normal--12-120-75-75-/-70-iso8859-1",
						"-*-*-*-*-*-*-12-*-*-*-m-*-*-*"
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
						"-*-*-*-*-*-*-12-*-*-*-m-*-*-*"
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
						"-*-*-*-*-*-*-12-*-*-*-m-*-*-*"
					)
				)
			end
		)
		it('"/dev/udp/129.22.8.102/45" should match "/dev\\/@(tcp|udp)\\/*\\/*"', function()
			assert(isMatch("/dev/udp/129.22.8.102/45", "/dev\\/@(tcp|udp)\\/*\\/*"))
		end)

		it('"/x/y/z" should match "/x/y/z"', function()
			assert(isMatch("/x/y/z", "/x/y/z"))
		end)

		itFIXME('"0377" should match "+([0-7])"', function()
			assert(isMatch("0377", "+([0-7])"))
		end)

		itFIXME('"07" should match "+([0-7])"', function()
			assert(isMatch("07", "+([0-7])"))
		end)

		it('"09" should not match "+([0-7])"', function()
			assert(not isMatch("09", "+([0-7])"))
		end)

		itFIXME('"1" should match "0|[1-9]*([0-9])"', function()
			assert(isMatch("1", "0|[1-9]*([0-9])"))
		end)

		itFIXME('"12" should match "0|[1-9]*([0-9])"', function()
			assert(isMatch("12", "0|[1-9]*([0-9])"))
		end)

		it('"123abc" should not match "(a+|b)*"', function()
			assert(not isMatch("123abc", "(a+|b)*"))
		end)

		it('"123abc" should not match "(a+|b)+"', function()
			assert(not isMatch("123abc", "(a+|b)+"))
		end)

		it('"123abc" should match "*?(a)bc"', function()
			assert(isMatch("123abc", "*?(a)bc"))
		end)

		it('"123abc" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("123abc", "a(b*(foo|bar))d"))
		end)

		it('"123abc" should not match "ab*(e|f)"', function()
			assert(not isMatch("123abc", "ab*(e|f)"))
		end)

		it('"123abc" should not match "ab**"', function()
			assert(not isMatch("123abc", "ab**"))
		end)

		it('"123abc" should not match "ab**(e|f)"', function()
			assert(not isMatch("123abc", "ab**(e|f)"))
		end)

		it('"123abc" should not match "ab**(e|f)g"', function()
			assert(not isMatch("123abc", "ab**(e|f)g"))
		end)

		it('"123abc" should not match "ab***ef"', function()
			assert(not isMatch("123abc", "ab***ef"))
		end)

		it('"123abc" should not match "ab*+(e|f)"', function()
			assert(not isMatch("123abc", "ab*+(e|f)"))
		end)

		it('"123abc" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("123abc", "ab*d+(e|f)"))
		end)

		it('"123abc" should not match "ab?*(e|f)"', function()
			assert(not isMatch("123abc", "ab?*(e|f)"))
		end)

		it('"12abc" should not match "0|[1-9]*([0-9])"', function()
			assert(not isMatch("12abc", "0|[1-9]*([0-9])"))
		end)

		it('"137577991" should match "*(0|1|3|5|7|9)"', function()
			assert(isMatch("137577991", "*(0|1|3|5|7|9)"))
		end)

		it('"2468" should not match "*(0|1|3|5|7|9)"', function()
			assert(not isMatch("2468", "*(0|1|3|5|7|9)"))
		end)

		it('"?a?b" should match "\\??\\?b"', function()
			assert(isMatch("?a?b", "\\??\\?b"))
		end)

		it('"\\a\\b\\c" should not match "abc"', function()
			assert(not isMatch("\\a\\b\\c", "abc"))
		end)

		it('"a" should match "!(*.a|*.b|*.c)"', function()
			assert(isMatch("a", "!(*.a|*.b|*.c)"))
		end)

		it('"a" should not match "!(a)"', function()
			assert(not isMatch("a", "!(a)"))
		end)

		it('"a" should not match "!(a)*"', function()
			assert(not isMatch("a", "!(a)*"))
		end)

		it('"a" should match "(a)"', function()
			assert(isMatch("a", "(a)"))
		end)

		it('"a" should not match "(b)"', function()
			assert(not isMatch("a", "(b)"))
		end)

		it('"a" should match "*(a)"', function()
			assert(isMatch("a", "*(a)"))
		end)

		it('"a" should match "+(a)"', function()
			assert(isMatch("a", "+(a)"))
		end)

		it('"a" should match "?"', function()
			assert(isMatch("a", "?"))
		end)

		it('"a" should match "?(a|b)"', function()
			assert(isMatch("a", "?(a|b)"))
		end)

		it('"a" should not match "??"', function()
			assert(not isMatch("a", "??"))
		end)

		it('"a" should match "a!(b)*"', function()
			assert(isMatch("a", "a!(b)*"))
		end)

		it('"a" should match "a?(a|b)"', function()
			assert(isMatch("a", "a?(a|b)"))
		end)

		it('"a" should match "a?(x)"', function()
			assert(isMatch("a", "a?(x)"))
		end)

		it('"a" should not match "a??b"', function()
			assert(not isMatch("a", "a??b"))
		end)

		it('"a" should not match "b?(a|b)"', function()
			assert(not isMatch("a", "b?(a|b)"))
		end)

		itFIXME('"a((((b" should match "a(*b"', function()
			assert(isMatch("a((((b", "a(*b"))
		end)

		it('"a((((b" should not match "a(b"', function()
			assert(not isMatch("a((((b", "a(b"))
		end)

		it('"a((((b" should not match "a\\(b"', function()
			assert(not isMatch("a((((b", "a\\(b"))
		end)

		itFIXME('"a((b" should match "a(*b"', function()
			assert(isMatch("a((b", "a(*b"))
		end)

		it('"a((b" should not match "a(b"', function()
			assert(not isMatch("a((b", "a(b"))
		end)

		it('"a((b" should not match "a\\(b"', function()
			assert(not isMatch("a((b", "a\\(b"))
		end)

		itFIXME('"a(b" should match "a(*b"', function()
			assert(isMatch("a(b", "a(*b"))
		end)

		it('"a(b" should match "a(b"', function()
			assert(isMatch("a(b", "a(b"))
		end)

		it('"a(b" should match "a\\(b"', function()
			assert(isMatch("a(b", "a\\(b"))
		end)

		it('"a." should match "!(*.a|*.b|*.c)"', function()
			assert(isMatch("a.", "!(*.a|*.b|*.c)"))
		end)

		it('"a." should match "*!(.a|.b|.c)"', function()
			assert(isMatch("a.", "*!(.a|.b|.c)"))
		end)

		it('"a." should match "*.!(a)"', function()
			assert(isMatch("a.", "*.!(a)"))
		end)

		it('"a." should match "*.!(a|b|c)"', function()
			assert(isMatch("a.", "*.!(a|b|c)"))
		end)

		it('"a." should not match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(not isMatch("a.", "*.(a|b|@(ab|a*@(b))*(c)d)"))
		end)

		it('"a." should not match "*.+(b|d)"', function()
			assert(not isMatch("a.", "*.+(b|d)"))
		end)

		itFIXME('"a.a" should not match "!(*.[a-b]*)"', function()
			assert(not isMatch("a.a", "!(*.[a-b]*)"))
		end)

		it('"a.a" should not match "!(*.a|*.b|*.c)"', function()
			assert(not isMatch("a.a", "!(*.a|*.b|*.c)"))
		end)

		itFIXME('"a.a" should not match "!(*[a-b].[a-b]*)"', function()
			assert(not isMatch("a.a", "!(*[a-b].[a-b]*)"))
		end)

		it('"a.a" should not match "!*.(a|b)"', function()
			assert(not isMatch("a.a", "!*.(a|b)"))
		end)

		it('"a.a" should not match "!*.(a|b)*"', function()
			assert(not isMatch("a.a", "!*.(a|b)*"))
		end)

		it('"a.a" should match "(a|d).(a|b)*"', function()
			assert(isMatch("a.a", "(a|d).(a|b)*"))
		end)

		it('"a.a" should match "(b|a).(a)"', function()
			assert(isMatch("a.a", "(b|a).(a)"))
		end)

		it('"a.a" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("a.a", "*!(.a|.b|.c)"))
		end)

		it('"a.a" should not match "*.!(a)"', function()
			assert(not isMatch("a.a", "*.!(a)"))
		end)

		it('"a.a" should not match "*.!(a|b|c)"', function()
			assert(not isMatch("a.a", "*.!(a|b|c)"))
		end)

		it('"a.a" should match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(isMatch("a.a", "*.(a|b|@(ab|a*@(b))*(c)d)"))
		end)

		it('"a.a" should not match "*.+(b|d)"', function()
			assert(not isMatch("a.a", "*.+(b|d)"))
		end)

		it('"a.a" should match "@(b|a).@(a)"', function()
			assert(isMatch("a.a", "@(b|a).@(a)"))
		end)

		itFIXME('"a.a.a" should not match "!(*.[a-b]*)"', function()
			assert(not isMatch("a.a.a", "!(*.[a-b]*)"))
		end)

		itFIXME('"a.a.a" should not match "!(*[a-b].[a-b]*)"', function()
			assert(not isMatch("a.a.a", "!(*[a-b].[a-b]*)"))
		end)

		it('"a.a.a" should not match "!*.(a|b)"', function()
			assert(not isMatch("a.a.a", "!*.(a|b)"))
		end)

		it('"a.a.a" should not match "!*.(a|b)*"', function()
			assert(not isMatch("a.a.a", "!*.(a|b)*"))
		end)

		it('"a.a.a" should match "*.!(a)"', function()
			assert(isMatch("a.a.a", "*.!(a)"))
		end)

		it('"a.a.a" should not match "*.+(b|d)"', function()
			assert(not isMatch("a.a.a", "*.+(b|d)"))
		end)

		it('"a.aa.a" should not match "(b|a).(a)"', function()
			assert(not isMatch("a.aa.a", "(b|a).(a)"))
		end)

		it('"a.aa.a" should not match "@(b|a).@(a)"', function()
			assert(not isMatch("a.aa.a", "@(b|a).@(a)"))
		end)

		it('"a.abcd" should match "!(*.a|*.b|*.c)"', function()
			assert(isMatch("a.abcd", "!(*.a|*.b|*.c)"))
		end)

		it('"a.abcd" should not match "!(*.a|*.b|*.c)*"', function()
			assert(not isMatch("a.abcd", "!(*.a|*.b|*.c)*"))
		end)

		it('"a.abcd" should match "*!(*.a|*.b|*.c)*"', function()
			assert(isMatch("a.abcd", "*!(*.a|*.b|*.c)*"))
		end)

		it('"a.abcd" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("a.abcd", "*!(.a|.b|.c)"))
		end)

		it('"a.abcd" should match "*.!(a|b|c)"', function()
			assert(isMatch("a.abcd", "*.!(a|b|c)"))
		end)

		it('"a.abcd" should not match "*.!(a|b|c)*"', function()
			assert(not isMatch("a.abcd", "*.!(a|b|c)*"))
		end)

		it('"a.abcd" should match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(isMatch("a.abcd", "*.(a|b|@(ab|a*@(b))*(c)d)"))
		end)

		it('"a.b" should not match "!(*.*)"', function()
			assert(not isMatch("a.b", "!(*.*)"))
		end)

		itFIXME('"a.b" should not match "!(*.[a-b]*)"', function()
			assert(not isMatch("a.b", "!(*.[a-b]*)"))
		end)

		it('"a.b" should not match "!(*.a|*.b|*.c)"', function()
			assert(not isMatch("a.b", "!(*.a|*.b|*.c)"))
		end)

		itFIXME('"a.b" should not match "!(*[a-b].[a-b]*)"', function()
			assert(not isMatch("a.b", "!(*[a-b].[a-b]*)"))
		end)

		it('"a.b" should not match "!*.(a|b)"', function()
			assert(not isMatch("a.b", "!*.(a|b)"))
		end)

		it('"a.b" should not match "!*.(a|b)*"', function()
			assert(not isMatch("a.b", "!*.(a|b)*"))
		end)

		it('"a.b" should match "(a|d).(a|b)*"', function()
			assert(isMatch("a.b", "(a|d).(a|b)*"))
		end)

		it('"a.b" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("a.b", "*!(.a|.b|.c)"))
		end)

		it('"a.b" should match "*.!(a)"', function()
			assert(isMatch("a.b", "*.!(a)"))
		end)

		it('"a.b" should not match "*.!(a|b|c)"', function()
			assert(not isMatch("a.b", "*.!(a|b|c)"))
		end)

		it('"a.b" should match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(isMatch("a.b", "*.(a|b|@(ab|a*@(b))*(c)d)"))
		end)

		it('"a.b" should match "*.+(b|d)"', function()
			assert(isMatch("a.b", "*.+(b|d)"))
		end)

		itFIXME('"a.bb" should not match "!(*.[a-b]*)"', function()
			assert(not isMatch("a.bb", "!(*.[a-b]*)"))
		end)

		itFIXME('"a.bb" should not match "!(*[a-b].[a-b]*)"', function()
			assert(not isMatch("a.bb", "!(*[a-b].[a-b]*)"))
		end)

		it('"a.bb" should match "!*.(a|b)"', function()
			assert(isMatch("a.bb", "!*.(a|b)"))
		end)

		it('"a.bb" should not match "!*.(a|b)*"', function()
			assert(not isMatch("a.bb", "!*.(a|b)*"))
		end)

		it('"a.bb" should not match "!*.*(a|b)"', function()
			assert(not isMatch("a.bb", "!*.*(a|b)"))
		end)

		it('"a.bb" should match "(a|d).(a|b)*"', function()
			assert(isMatch("a.bb", "(a|d).(a|b)*"))
		end)

		it('"a.bb" should not match "(b|a).(a)"', function()
			assert(not isMatch("a.bb", "(b|a).(a)"))
		end)

		it('"a.bb" should match "*.+(b|d)"', function()
			assert(isMatch("a.bb", "*.+(b|d)"))
		end)

		it('"a.bb" should not match "@(b|a).@(a)"', function()
			assert(not isMatch("a.bb", "@(b|a).@(a)"))
		end)

		it('"a.c" should not match "!(*.a|*.b|*.c)"', function()
			assert(not isMatch("a.c", "!(*.a|*.b|*.c)"))
		end)

		it('"a.c" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("a.c", "*!(.a|.b|.c)"))
		end)

		it('"a.c" should not match "*.!(a|b|c)"', function()
			assert(not isMatch("a.c", "*.!(a|b|c)"))
		end)

		it('"a.c" should not match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(not isMatch("a.c", "*.(a|b|@(ab|a*@(b))*(c)d)"))
		end)

		it('"a.c.d" should match "!(*.a|*.b|*.c)"', function()
			assert(isMatch("a.c.d", "!(*.a|*.b|*.c)"))
		end)

		it('"a.c.d" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("a.c.d", "*!(.a|.b|.c)"))
		end)

		it('"a.c.d" should match "*.!(a|b|c)"', function()
			assert(isMatch("a.c.d", "*.!(a|b|c)"))
		end)

		it('"a.c.d" should not match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(not isMatch("a.c.d", "*.(a|b|@(ab|a*@(b))*(c)d)"))
		end)

		it('"a.ccc" should match "!(*.[a-b]*)"', function()
			assert(isMatch("a.ccc", "!(*.[a-b]*)"))
		end)

		it('"a.ccc" should match "!(*[a-b].[a-b]*)"', function()
			assert(isMatch("a.ccc", "!(*[a-b].[a-b]*)"))
		end)

		it('"a.ccc" should match "!*.(a|b)"', function()
			assert(isMatch("a.ccc", "!*.(a|b)"))
		end)

		it('"a.ccc" should match "!*.(a|b)*"', function()
			assert(isMatch("a.ccc", "!*.(a|b)*"))
		end)

		it('"a.ccc" should not match "*.+(b|d)"', function()
			assert(not isMatch("a.ccc", "*.+(b|d)"))
		end)

		it('"a.js" should not match "!(*.js)"', function()
			assert(not isMatch("a.js", "!(*.js)"))
		end)

		it('"a.js" should match "*!(.js)"', function()
			assert(isMatch("a.js", "*!(.js)"))
		end)

		it('"a.js" should not match "*.!(js)"', function()
			assert(not isMatch("a.js", "*.!(js)"))
		end)

		it('"a.js" should not match "a.!(js)"', function()
			assert(not isMatch("a.js", "a.!(js)"))
		end)

		it('"a.js" should not match "a.!(js)*"', function()
			assert(not isMatch("a.js", "a.!(js)*"))
		end)

		it('"a.js.js" should not match "!(*.js)"', function()
			assert(not isMatch("a.js.js", "!(*.js)"))
		end)

		it('"a.js.js" should match "*!(.js)"', function()
			assert(isMatch("a.js.js", "*!(.js)"))
		end)

		it('"a.js.js" should match "*.!(js)"', function()
			assert(isMatch("a.js.js", "*.!(js)"))
		end)

		it('"a.js.js" should match "*.*(js).js"', function()
			assert(isMatch("a.js.js", "*.*(js).js"))
		end)

		it('"a.md" should match "!(*.js)"', function()
			assert(isMatch("a.md", "!(*.js)"))
		end)

		it('"a.md" should match "*!(.js)"', function()
			assert(isMatch("a.md", "*!(.js)"))
		end)

		it('"a.md" should match "*.!(js)"', function()
			assert(isMatch("a.md", "*.!(js)"))
		end)

		it('"a.md" should match "a.!(js)"', function()
			assert(isMatch("a.md", "a.!(js)"))
		end)

		it('"a.md" should match "a.!(js)*"', function()
			assert(isMatch("a.md", "a.!(js)*"))
		end)

		it('"a.md.js" should not match "*.*(js).js"', function()
			assert(not isMatch("a.md.js", "*.*(js).js"))
		end)

		it('"a.txt" should match "a.!(js)"', function()
			assert(isMatch("a.txt", "a.!(js)"))
		end)

		it('"a.txt" should match "a.!(js)*"', function()
			assert(isMatch("a.txt", "a.!(js)*"))
		end)

		it('"a/!(z)" should match "a/!(z)"', function()
			assert(isMatch("a/!(z)", "a/!(z)"))
		end)

		it('"a/b" should match "a/!(z)"', function()
			assert(isMatch("a/b", "a/!(z)"))
		end)

		it('"a/b/c.txt" should not match "*/b/!(*).txt"', function()
			assert(not isMatch("a/b/c.txt", "*/b/!(*).txt"))
		end)

		it('"a/b/c.txt" should not match "*/b/!(c).txt"', function()
			assert(not isMatch("a/b/c.txt", "*/b/!(c).txt"))
		end)

		it('"a/b/c.txt" should match "*/b/!(cc).txt"', function()
			assert(isMatch("a/b/c.txt", "*/b/!(cc).txt"))
		end)

		it('"a/b/cc.txt" should not match "*/b/!(*).txt"', function()
			assert(not isMatch("a/b/cc.txt", "*/b/!(*).txt"))
		end)

		it('"a/b/cc.txt" should not match "*/b/!(c).txt"', function()
			assert(not isMatch("a/b/cc.txt", "*/b/!(c).txt"))
		end)

		it('"a/b/cc.txt" should not match "*/b/!(cc).txt"', function()
			assert(not isMatch("a/b/cc.txt", "*/b/!(cc).txt"))
		end)

		it('"a/dir/foo.txt" should match "*/dir/**/!(bar).txt"', function()
			assert(isMatch("a/dir/foo.txt", "*/dir/**/!(bar).txt"))
		end)

		it('"a/z" should not match "a/!(z)"', function()
			assert(not isMatch("a/z", "a/!(z)"))
		end)

		it('"a\\(b" should not match "a(*b"', function()
			assert(not isMatch("a\\(b", "a(*b"))
		end)

		it('"a\\(b" should not match "a(b"', function()
			assert(not isMatch("a\\(b", "a(b"))
		end)

		itFIXME('"a\\z" should match "a\\z"', function()
			assert(isMatch("a\\\\z", "a\\\\z", { windows = false }))
		end)

		itFIXME('"a\\z" should match "a\\z"_', function()
			assert(isMatch("a\\\\z", "a\\\\z"))
		end)

		itFIXME('"a\\b" should match "a/b"', function()
			assert(isMatch("a\\b", "a/b", { windows = true }))
		end)

		itFIXME('"a\\z" should match "a\\z"__', function()
			assert(isMatch("a\\z", "a\\\\z", { windows = false }))
		end)

		itFIXME('"a\\z" should not match "a\\z"', function()
			assert(isMatch("a\\z", "a\\z"))
		end)

		it('"aa" should not match "!(a!(b))"', function()
			assert(not isMatch("aa", "!(a!(b))"))
		end)

		it('"aa" should match "!(a)"', function()
			assert(isMatch("aa", "!(a)"))
		end)

		it('"aa" should not match "!(a)*"', function()
			assert(not isMatch("aa", "!(a)*"))
		end)

		it('"aa" should not match "?"', function()
			assert(not isMatch("aa", "?"))
		end)

		it('"aa" should not match "@(a)b"', function()
			assert(not isMatch("aa", "@(a)b"))
		end)

		it('"aa" should match "a!(b)*"', function()
			assert(isMatch("aa", "a!(b)*"))
		end)

		it('"aa" should not match "a??b"', function()
			assert(not isMatch("aa", "a??b"))
		end)

		it('"aa.aa" should not match "(b|a).(a)"', function()
			assert(not isMatch("aa.aa", "(b|a).(a)"))
		end)

		it('"aa.aa" should not match "@(b|a).@(a)"', function()
			assert(not isMatch("aa.aa", "@(b|a).@(a)"))
		end)

		it('"aaa" should not match "!(a)*"', function()
			assert(not isMatch("aaa", "!(a)*"))
		end)

		it('"aaa" should match "a!(b)*"', function()
			assert(isMatch("aaa", "a!(b)*"))
		end)

		it('"aaaaaaabababab" should match "*ab"', function()
			assert(isMatch("aaaaaaabababab", "*ab"))
		end)

		it('"aaac" should match "*(@(a))a@(c)"', function()
			assert(isMatch("aaac", "*(@(a))a@(c)"))
		end)

		itFIXME('"aaaz" should match "[a*(]*z"', function()
			assert(isMatch("aaaz", "[a*(]*z"))
		end)

		it('"aab" should not match "!(a)*"', function()
			assert(not isMatch("aab", "!(a)*"))
		end)

		it('"aab" should not match "?"', function()
			assert(not isMatch("aab", "?"))
		end)

		it('"aab" should not match "??"', function()
			assert(not isMatch("aab", "??"))
		end)

		it('"aab" should not match "@(c)b"', function()
			assert(not isMatch("aab", "@(c)b"))
		end)

		it('"aab" should match "a!(b)*"', function()
			assert(isMatch("aab", "a!(b)*"))
		end)

		it('"aab" should not match "a??b"', function()
			assert(not isMatch("aab", "a??b"))
		end)

		it('"aac" should match "*(@(a))a@(c)"', function()
			assert(isMatch("aac", "*(@(a))a@(c)"))
		end)

		it('"aac" should not match "*(@(a))b@(c)"', function()
			assert(not isMatch("aac", "*(@(a))b@(c)"))
		end)

		it('"aax" should not match "a!(a*|b)"', function()
			assert(not isMatch("aax", "a!(a*|b)"))
		end)

		it('"aax" should match "a!(x*|b)"', function()
			assert(isMatch("aax", "a!(x*|b)"))
		end)

		it('"aax" should match "a?(a*|b)"', function()
			assert(isMatch("aax", "a?(a*|b)"))
		end)

		itFIXME('"aaz" should match "[a*(]*z"', function()
			assert(isMatch("aaz", "[a*(]*z"))
		end)

		it('"ab" should match "!(*.*)"', function()
			assert(isMatch("ab", "!(*.*)"))
		end)

		it('"ab" should match "!(a!(b))"', function()
			assert(isMatch("ab", "!(a!(b))"))
		end)

		it('"ab" should not match "!(a)*"', function()
			assert(not isMatch("ab", "!(a)*"))
		end)

		it('"ab" should match "(a+|b)*"', function()
			assert(isMatch("ab", "(a+|b)*"))
		end)

		it('"ab" should match "(a+|b)+"', function()
			assert(isMatch("ab", "(a+|b)+"))
		end)

		it('"ab" should not match "*?(a)bc"', function()
			assert(not isMatch("ab", "*?(a)bc"))
		end)

		it('"ab" should not match "a!(*(b|B))"', function()
			assert(not isMatch("ab", "a!(*(b|B))"))
		end)

		it('"ab" should not match "a!(@(b|B))"', function()
			assert(not isMatch("ab", "a!(@(b|B))"))
		end)

		it('"aB" should not match "a!(@(b|B))"', function()
			assert(not isMatch("aB", "a!(@(b|B))"))
		end)

		it('"ab" should not match "a!(b)*"', function()
			assert(not isMatch("ab", "a!(b)*"))
		end)

		it('"ab" should not match "a(*b"', function()
			assert(not isMatch("ab", "a(*b"))
		end)

		it('"ab" should not match "a(b"', function()
			assert(not isMatch("ab", "a(b"))
		end)

		it('"ab" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("ab", "a(b*(foo|bar))d"))
		end)

		itFIXME('"ab" should not match "a/b"', function()
			assert(not isMatch("ab", "a/b", { windows = true }))
		end)

		it('"ab" should not match "a\\(b"', function()
			assert(not isMatch("ab", "a\\(b"))
		end)

		it('"ab" should match "ab*(e|f)"', function()
			assert(isMatch("ab", "ab*(e|f)"))
		end)

		it('"ab" should match "ab**"', function()
			assert(isMatch("ab", "ab**"))
		end)

		it('"ab" should match "ab**(e|f)"', function()
			assert(isMatch("ab", "ab**(e|f)"))
		end)

		it('"ab" should not match "ab**(e|f)g"', function()
			assert(not isMatch("ab", "ab**(e|f)g"))
		end)

		it('"ab" should not match "ab***ef"', function()
			assert(not isMatch("ab", "ab***ef"))
		end)

		it('"ab" should not match "ab*+(e|f)"', function()
			assert(not isMatch("ab", "ab*+(e|f)"))
		end)

		it('"ab" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("ab", "ab*d+(e|f)"))
		end)

		it('"ab" should not match "ab?*(e|f)"', function()
			assert(not isMatch("ab", "ab?*(e|f)"))
		end)

		it('"ab/cXd/efXg/hi" should match "**/*X*/**/*i"', function()
			assert(isMatch("ab/cXd/efXg/hi", "**/*X*/**/*i"))
		end)

		it('"ab/cXd/efXg/hi" should match "*/*X*/*/*i"', function()
			assert(isMatch("ab/cXd/efXg/hi", "*/*X*/*/*i"))
		end)

		it('"ab/cXd/efXg/hi" should not match "*X*i"', function()
			assert(not isMatch("ab/cXd/efXg/hi", "*X*i"))
		end)

		it('"ab/cXd/efXg/hi" should not match "*Xg*i"', function()
			assert(not isMatch("ab/cXd/efXg/hi", "*Xg*i"))
		end)

		it('"ab]" should match "a!(@(b|B))"', function()
			assert(isMatch("ab]", "a!(@(b|B))"))
		end)

		it('"abab" should match "(a+|b)*"', function()
			assert(isMatch("abab", "(a+|b)*"))
		end)

		it('"abab" should match "(a+|b)+"', function()
			assert(isMatch("abab", "(a+|b)+"))
		end)

		it('"abab" should not match "*?(a)bc"', function()
			assert(not isMatch("abab", "*?(a)bc"))
		end)

		it('"abab" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("abab", "a(b*(foo|bar))d"))
		end)

		it('"abab" should not match "ab*(e|f)"', function()
			assert(not isMatch("abab", "ab*(e|f)"))
		end)

		it('"abab" should match "ab**"', function()
			assert(isMatch("abab", "ab**"))
		end)

		it('"abab" should match "ab**(e|f)"', function()
			assert(isMatch("abab", "ab**(e|f)"))
		end)

		it('"abab" should not match "ab**(e|f)g"', function()
			assert(not isMatch("abab", "ab**(e|f)g"))
		end)

		it('"abab" should not match "ab***ef"', function()
			assert(not isMatch("abab", "ab***ef"))
		end)

		it('"abab" should not match "ab*+(e|f)"', function()
			assert(not isMatch("abab", "ab*+(e|f)"))
		end)

		it('"abab" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("abab", "ab*d+(e|f)"))
		end)

		it('"abab" should not match "ab?*(e|f)"', function()
			assert(not isMatch("abab", "ab?*(e|f)"))
		end)

		it('"abb" should match "!(*.*)"', function()
			assert(isMatch("abb", "!(*.*)"))
		end)

		it('"abb" should not match "!(a)*"', function()
			assert(not isMatch("abb", "!(a)*"))
		end)

		it('"abb" should not match "a!(b)*"', function()
			assert(not isMatch("abb", "a!(b)*"))
		end)

		it('"abbcd" should match "@(ab|a*(b))*(c)d"', function()
			assert(isMatch("abbcd", "@(ab|a*(b))*(c)d"))
		end)

		itFIXME('"abc" should not match "\\a\\b\\c"', function()
			assert(not isMatch("abc", "\\a\\b\\c"))
		end)

		it('"aBc" should match "a!(@(b|B))"', function()
			assert(isMatch("aBc", "a!(@(b|B))"))
		end)

		it('"abcd" should match "?@(a|b)*@(c)d"', function()
			assert(isMatch("abcd", "?@(a|b)*@(c)d"))
		end)

		it('"abcd" should match "@(ab|a*@(b))*(c)d"', function()
			assert(isMatch("abcd", "@(ab|a*@(b))*(c)d"))
		end)

		it('"abcd/abcdefg/abcdefghijk/abcdefghijklmnop.txt" should match "**/*a*b*g*n*t"', function()
			assert(isMatch("abcd/abcdefg/abcdefghijk/abcdefghijklmnop.txt", "**/*a*b*g*n*t"))
		end)

		it('"abcd/abcdefg/abcdefghijk/abcdefghijklmnop.txtz" should not match "**/*a*b*g*n*t"', function()
			assert(not isMatch("abcd/abcdefg/abcdefghijk/abcdefghijklmnop.txtz", "**/*a*b*g*n*t"))
		end)

		it('"abcdef" should match "(a+|b)*"', function()
			assert(isMatch("abcdef", "(a+|b)*"))
		end)

		it('"abcdef" should not match "(a+|b)+"', function()
			assert(not isMatch("abcdef", "(a+|b)+"))
		end)

		it('"abcdef" should not match "*?(a)bc"', function()
			assert(not isMatch("abcdef", "*?(a)bc"))
		end)

		it('"abcdef" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("abcdef", "a(b*(foo|bar))d"))
		end)

		it('"abcdef" should not match "ab*(e|f)"', function()
			assert(not isMatch("abcdef", "ab*(e|f)"))
		end)

		it('"abcdef" should match "ab**"', function()
			assert(isMatch("abcdef", "ab**"))
		end)

		it('"abcdef" should match "ab**(e|f)"', function()
			assert(isMatch("abcdef", "ab**(e|f)"))
		end)

		it('"abcdef" should not match "ab**(e|f)g"', function()
			assert(not isMatch("abcdef", "ab**(e|f)g"))
		end)

		it('"abcdef" should match "ab***ef"', function()
			assert(isMatch("abcdef", "ab***ef"))
		end)

		it('"abcdef" should match "ab*+(e|f)"', function()
			assert(isMatch("abcdef", "ab*+(e|f)"))
		end)

		it('"abcdef" should match "ab*d+(e|f)"', function()
			assert(isMatch("abcdef", "ab*d+(e|f)"))
		end)

		it('"abcdef" should not match "ab?*(e|f)"', function()
			assert(not isMatch("abcdef", "ab?*(e|f)"))
		end)

		it('"abcfef" should match "(a+|b)*"', function()
			assert(isMatch("abcfef", "(a+|b)*"))
		end)

		it('"abcfef" should not match "(a+|b)+"', function()
			assert(not isMatch("abcfef", "(a+|b)+"))
		end)

		it('"abcfef" should not match "*?(a)bc"', function()
			assert(not isMatch("abcfef", "*?(a)bc"))
		end)

		it('"abcfef" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("abcfef", "a(b*(foo|bar))d"))
		end)

		it('"abcfef" should not match "ab*(e|f)"', function()
			assert(not isMatch("abcfef", "ab*(e|f)"))
		end)

		it('"abcfef" should match "ab**"', function()
			assert(isMatch("abcfef", "ab**"))
		end)

		it('"abcfef" should match "ab**(e|f)"', function()
			assert(isMatch("abcfef", "ab**(e|f)"))
		end)

		it('"abcfef" should not match "ab**(e|f)g"', function()
			assert(not isMatch("abcfef", "ab**(e|f)g"))
		end)

		it('"abcfef" should match "ab***ef"', function()
			assert(isMatch("abcfef", "ab***ef"))
		end)

		it('"abcfef" should match "ab*+(e|f)"', function()
			assert(isMatch("abcfef", "ab*+(e|f)"))
		end)

		it('"abcfef" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("abcfef", "ab*d+(e|f)"))
		end)

		it('"abcfef" should match "ab?*(e|f)"', function()
			assert(isMatch("abcfef", "ab?*(e|f)"))
		end)

		it('"abcfefg" should match "(a+|b)*"', function()
			assert(isMatch("abcfefg", "(a+|b)*"))
		end)

		it('"abcfefg" should not match "(a+|b)+"', function()
			assert(not isMatch("abcfefg", "(a+|b)+"))
		end)

		it('"abcfefg" should not match "*?(a)bc"', function()
			assert(not isMatch("abcfefg", "*?(a)bc"))
		end)

		it('"abcfefg" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("abcfefg", "a(b*(foo|bar))d"))
		end)

		it('"abcfefg" should not match "ab*(e|f)"', function()
			assert(not isMatch("abcfefg", "ab*(e|f)"))
		end)

		it('"abcfefg" should match "ab**"', function()
			assert(isMatch("abcfefg", "ab**"))
		end)

		it('"abcfefg" should match "ab**(e|f)"', function()
			assert(isMatch("abcfefg", "ab**(e|f)"))
		end)

		it('"abcfefg" should match "ab**(e|f)g"', function()
			assert(isMatch("abcfefg", "ab**(e|f)g"))
		end)

		it('"abcfefg" should not match "ab***ef"', function()
			assert(not isMatch("abcfefg", "ab***ef"))
		end)

		it('"abcfefg" should not match "ab*+(e|f)"', function()
			assert(not isMatch("abcfefg", "ab*+(e|f)"))
		end)

		it('"abcfefg" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("abcfefg", "ab*d+(e|f)"))
		end)

		it('"abcfefg" should not match "ab?*(e|f)"', function()
			assert(not isMatch("abcfefg", "ab?*(e|f)"))
		end)

		it('"abcx" should match "!([[*])*"', function()
			assert(isMatch("abcx", "!([[*])*"))
		end)

		it('"abcx" should match "+(a|b\\[)*"', function()
			assert(isMatch("abcx", "+(a|b\\[)*"))
		end)

		it('"abcx" should not match "[a*(]*z"', function()
			assert(not isMatch("abcx", "[a*(]*z"))
		end)

		it('"abcXdefXghi" should match "*X*i"', function()
			assert(isMatch("abcXdefXghi", "*X*i"))
		end)

		it('"abcz" should match "!([[*])*"', function()
			assert(isMatch("abcz", "!([[*])*"))
		end)

		it('"abcz" should match "+(a|b\\[)*"', function()
			assert(isMatch("abcz", "+(a|b\\[)*"))
		end)

		itFIXME('"abcz" should match "[a*(]*z"', function()
			assert(isMatch("abcz", "[a*(]*z"))
		end)

		it('"abd" should match "(a+|b)*"', function()
			assert(isMatch("abd", "(a+|b)*"))
		end)

		it('"abd" should not match "(a+|b)+"', function()
			assert(not isMatch("abd", "(a+|b)+"))
		end)

		it('"abd" should not match "*?(a)bc"', function()
			assert(not isMatch("abd", "*?(a)bc"))
		end)

		it('"abd" should match "a!(*(b|B))"', function()
			assert(isMatch("abd", "a!(*(b|B))"))
		end)

		it('"abd" should match "a!(@(b|B))"', function()
			assert(isMatch("abd", "a!(@(b|B))"))
		end)

		it('"abd" should not match "a!(@(b|B))d"', function()
			assert(not isMatch("abd", "a!(@(b|B))d"))
		end)

		it('"abd" should match "a(b*(foo|bar))d"', function()
			assert(isMatch("abd", "a(b*(foo|bar))d"))
		end)

		it('"abd" should match "a+(b|c)d"', function()
			assert(isMatch("abd", "a+(b|c)d"))
		end)

		itFIXME('"abd" should match "a[b*(foo|bar)]d"', function()
			assert(isMatch("abd", "a[b*(foo|bar)]d"))
		end)

		it('"abd" should not match "ab*(e|f)"', function()
			assert(not isMatch("abd", "ab*(e|f)"))
		end)

		it('"abd" should match "ab**"', function()
			assert(isMatch("abd", "ab**"))
		end)

		it('"abd" should match "ab**(e|f)"', function()
			assert(isMatch("abd", "ab**(e|f)"))
		end)

		it('"abd" should not match "ab**(e|f)g"', function()
			assert(not isMatch("abd", "ab**(e|f)g"))
		end)

		it('"abd" should not match "ab***ef"', function()
			assert(not isMatch("abd", "ab***ef"))
		end)

		it('"abd" should not match "ab*+(e|f)"', function()
			assert(not isMatch("abd", "ab*+(e|f)"))
		end)

		it('"abd" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("abd", "ab*d+(e|f)"))
		end)

		it('"abd" should match "ab?*(e|f)"', function()
			assert(isMatch("abd", "ab?*(e|f)"))
		end)

		it('"abef" should match "(a+|b)*"', function()
			assert(isMatch("abef", "(a+|b)*"))
		end)

		it('"abef" should not match "(a+|b)+"', function()
			assert(not isMatch("abef", "(a+|b)+"))
		end)

		it('"abef" should not match "*(a+|b)"', function()
			assert(not isMatch("abef", "*(a+|b)"))
		end)

		it('"abef" should not match "*?(a)bc"', function()
			assert(not isMatch("abef", "*?(a)bc"))
		end)

		it('"abef" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("abef", "a(b*(foo|bar))d"))
		end)

		it('"abef" should match "ab*(e|f)"', function()
			assert(isMatch("abef", "ab*(e|f)"))
		end)

		it('"abef" should match "ab**"', function()
			assert(isMatch("abef", "ab**"))
		end)

		it('"abef" should match "ab**(e|f)"', function()
			assert(isMatch("abef", "ab**(e|f)"))
		end)

		it('"abef" should not match "ab**(e|f)g"', function()
			assert(not isMatch("abef", "ab**(e|f)g"))
		end)

		it('"abef" should match "ab***ef"', function()
			assert(isMatch("abef", "ab***ef"))
		end)

		it('"abef" should match "ab*+(e|f)"', function()
			assert(isMatch("abef", "ab*+(e|f)"))
		end)

		it('"abef" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("abef", "ab*d+(e|f)"))
		end)

		it('"abef" should match "ab?*(e|f)"', function()
			assert(isMatch("abef", "ab?*(e|f)"))
		end)

		it('"abz" should not match "a!(*)"', function()
			assert(not isMatch("abz", "a!(*)"))
		end)

		it('"abz" should match "a!(z)"', function()
			assert(isMatch("abz", "a!(z)"))
		end)

		it('"abz" should match "a*!(z)"', function()
			assert(isMatch("abz", "a*!(z)"))
		end)

		it('"abz" should not match "a*(z)"', function()
			assert(not isMatch("abz", "a*(z)"))
		end)

		it('"abz" should match "a**(z)"', function()
			assert(isMatch("abz", "a**(z)"))
		end)

		it('"abz" should match "a*@(z)"', function()
			assert(isMatch("abz", "a*@(z)"))
		end)

		it('"abz" should not match "a+(z)"', function()
			assert(not isMatch("abz", "a+(z)"))
		end)

		it('"abz" should not match "a?(z)"', function()
			assert(not isMatch("abz", "a?(z)"))
		end)

		it('"abz" should not match "a@(z)"', function()
			assert(not isMatch("abz", "a@(z)"))
		end)

		it('"ac" should not match "!(a)*"', function()
			assert(not isMatch("ac", "!(a)*"))
		end)

		it('"ac" should match "*(@(a))a@(c)"', function()
			assert(isMatch("ac", "*(@(a))a@(c)"))
		end)

		it('"ac" should match "a!(*(b|B))"', function()
			assert(isMatch("ac", "a!(*(b|B))"))
		end)

		it('"ac" should match "a!(@(b|B))"', function()
			assert(isMatch("ac", "a!(@(b|B))"))
		end)

		it('"ac" should match "a!(b)*"', function()
			assert(isMatch("ac", "a!(b)*"))
		end)

		it('"accdef" should match "(a+|b)*"', function()
			assert(isMatch("accdef", "(a+|b)*"))
		end)

		it('"accdef" should not match "(a+|b)+"', function()
			assert(not isMatch("accdef", "(a+|b)+"))
		end)

		it('"accdef" should not match "*?(a)bc"', function()
			assert(not isMatch("accdef", "*?(a)bc"))
		end)

		it('"accdef" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("accdef", "a(b*(foo|bar))d"))
		end)

		it('"accdef" should not match "ab*(e|f)"', function()
			assert(not isMatch("accdef", "ab*(e|f)"))
		end)

		it('"accdef" should not match "ab**"', function()
			assert(not isMatch("accdef", "ab**"))
		end)

		it('"accdef" should not match "ab**(e|f)"', function()
			assert(not isMatch("accdef", "ab**(e|f)"))
		end)

		it('"accdef" should not match "ab**(e|f)g"', function()
			assert(not isMatch("accdef", "ab**(e|f)g"))
		end)

		it('"accdef" should not match "ab***ef"', function()
			assert(not isMatch("accdef", "ab***ef"))
		end)

		it('"accdef" should not match "ab*+(e|f)"', function()
			assert(not isMatch("accdef", "ab*+(e|f)"))
		end)

		it('"accdef" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("accdef", "ab*d+(e|f)"))
		end)

		it('"accdef" should not match "ab?*(e|f)"', function()
			assert(not isMatch("accdef", "ab?*(e|f)"))
		end)

		it('"acd" should match "(a+|b)*"', function()
			assert(isMatch("acd", "(a+|b)*"))
		end)

		it('"acd" should not match "(a+|b)+"', function()
			assert(not isMatch("acd", "(a+|b)+"))
		end)

		it('"acd" should not match "*?(a)bc"', function()
			assert(not isMatch("acd", "*?(a)bc"))
		end)

		it('"acd" should match "@(ab|a*(b))*(c)d"', function()
			assert(isMatch("acd", "@(ab|a*(b))*(c)d"))
		end)

		it('"acd" should match "a!(*(b|B))"', function()
			assert(isMatch("acd", "a!(*(b|B))"))
		end)

		it('"acd" should match "a!(@(b|B))"', function()
			assert(isMatch("acd", "a!(@(b|B))"))
		end)

		it('"acd" should match "a!(@(b|B))d"', function()
			assert(isMatch("acd", "a!(@(b|B))d"))
		end)

		it('"acd" should not match "a(b*(foo|bar))d"', function()
			assert(not isMatch("acd", "a(b*(foo|bar))d"))
		end)

		it('"acd" should match "a+(b|c)d"', function()
			assert(isMatch("acd", "a+(b|c)d"))
		end)

		it('"acd" should not match "a[b*(foo|bar)]d"', function()
			assert(not isMatch("acd", "a[b*(foo|bar)]d"))
		end)

		it('"acd" should not match "ab*(e|f)"', function()
			assert(not isMatch("acd", "ab*(e|f)"))
		end)

		it('"acd" should not match "ab**"', function()
			assert(not isMatch("acd", "ab**"))
		end)

		it('"acd" should not match "ab**(e|f)"', function()
			assert(not isMatch("acd", "ab**(e|f)"))
		end)

		it('"acd" should not match "ab**(e|f)g"', function()
			assert(not isMatch("acd", "ab**(e|f)g"))
		end)

		it('"acd" should not match "ab***ef"', function()
			assert(not isMatch("acd", "ab***ef"))
		end)

		it('"acd" should not match "ab*+(e|f)"', function()
			assert(not isMatch("acd", "ab*+(e|f)"))
		end)

		it('"acd" should not match "ab*d+(e|f)"', function()
			assert(not isMatch("acd", "ab*d+(e|f)"))
		end)

		it('"acd" should not match "ab?*(e|f)"', function()
			assert(not isMatch("acd", "ab?*(e|f)"))
		end)

		it('"axz" should not match "a+(z)"', function()
			assert(not isMatch("axz", "a+(z)"))
		end)

		it('"az" should not match "a!(*)"', function()
			assert(not isMatch("az", "a!(*)"))
		end)

		it('"az" should not match "a!(z)"', function()
			assert(not isMatch("az", "a!(z)"))
		end)

		it('"az" should match "a*!(z)"', function()
			assert(isMatch("az", "a*!(z)"))
		end)

		it('"az" should match "a*(z)"', function()
			assert(isMatch("az", "a*(z)"))
		end)

		it('"az" should match "a**(z)"', function()
			assert(isMatch("az", "a**(z)"))
		end)

		it('"az" should match "a*@(z)"', function()
			assert(isMatch("az", "a*@(z)"))
		end)

		it('"az" should match "a+(z)"', function()
			assert(isMatch("az", "a+(z)"))
		end)

		it('"az" should match "a?(z)"', function()
			assert(isMatch("az", "a?(z)"))
		end)

		it('"az" should match "a@(z)"', function()
			assert(isMatch("az", "a@(z)"))
		end)

		itFIXME('"az" should not match "a\\z"', function()
			assert(not isMatch("az", "a\\\\z", { windows = false }))
		end)

		itFIXME('"az" should not match "a\\z"_', function()
			assert(not isMatch("az", "a\\\\z"))
		end)

		it('"b" should match "!(a)*"', function()
			assert(isMatch("b", "!(a)*"))
		end)

		it('"b" should match "(a+|b)*"', function()
			assert(isMatch("b", "(a+|b)*"))
		end)

		it('"b" should not match "a!(b)*"', function()
			assert(not isMatch("b", "a!(b)*"))
		end)

		it('"b.a" should match "(b|a).(a)"', function()
			assert(isMatch("b.a", "(b|a).(a)"))
		end)

		it('"b.a" should match "@(b|a).@(a)"', function()
			assert(isMatch("b.a", "@(b|a).@(a)"))
		end)

		it('"b/a" should not match "!(b/a)"', function()
			assert(not isMatch("b/a", "!(b/a)"))
		end)

		it('"b/b" should match "!(b/a)"', function()
			assert(isMatch("b/b", "!(b/a)"))
		end)

		it('"b/c" should match "!(b/a)"', function()
			assert(isMatch("b/c", "!(b/a)"))
		end)

		it('"b/c" should not match "b/!(c)"', function()
			assert(not isMatch("b/c", "b/!(c)"))
		end)

		it('"b/c" should match "b/!(cc)"', function()
			assert(isMatch("b/c", "b/!(cc)"))
		end)

		it('"b/c.txt" should not match "b/!(c).txt"', function()
			assert(not isMatch("b/c.txt", "b/!(c).txt"))
		end)

		it('"b/c.txt" should match "b/!(cc).txt"', function()
			assert(isMatch("b/c.txt", "b/!(cc).txt"))
		end)

		it('"b/cc" should match "b/!(c)"', function()
			assert(isMatch("b/cc", "b/!(c)"))
		end)

		it('"b/cc" should not match "b/!(cc)"', function()
			assert(not isMatch("b/cc", "b/!(cc)"))
		end)

		it('"b/cc.txt" should not match "b/!(c).txt"', function()
			assert(not isMatch("b/cc.txt", "b/!(c).txt"))
		end)

		it('"b/cc.txt" should not match "b/!(cc).txt"', function()
			assert(not isMatch("b/cc.txt", "b/!(cc).txt"))
		end)

		it('"b/ccc" should match "b/!(c)"', function()
			assert(isMatch("b/ccc", "b/!(c)"))
		end)

		it('"ba" should match "!(a!(b))"', function()
			assert(isMatch("ba", "!(a!(b))"))
		end)

		it('"ba" should match "b?(a|b)"', function()
			assert(isMatch("ba", "b?(a|b)"))
		end)

		it('"baaac" should not match "*(@(a))a@(c)"', function()
			assert(not isMatch("baaac", "*(@(a))a@(c)"))
		end)

		it('"bar" should match "!(foo)"', function()
			assert(isMatch("bar", "!(foo)"))
		end)

		it('"bar" should match "!(foo)*"', function()
			assert(isMatch("bar", "!(foo)*"))
		end)

		it('"bar" should match "!(foo)b*"', function()
			assert(isMatch("bar", "!(foo)b*"))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"bar" should match "*(!(foo))"', function()
			assert(isMatch("bar", "*(!(foo))"))
		end)

		it('"baz" should match "!(foo)*"', function()
			assert(isMatch("baz", "!(foo)*"))
		end)

		it('"baz" should match "!(foo)b*"', function()
			assert(isMatch("baz", "!(foo)b*"))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"baz" should match "*(!(foo))"', function()
			assert(isMatch("baz", "*(!(foo))"))
		end)

		it('"bb" should match "!(a!(b))"', function()
			assert(isMatch("bb", "!(a!(b))"))
		end)

		it('"bb" should match "!(a)*"', function()
			assert(isMatch("bb", "!(a)*"))
		end)

		it('"bb" should not match "a!(b)*"', function()
			assert(not isMatch("bb", "a!(b)*"))
		end)

		it('"bb" should not match "a?(a|b)"', function()
			assert(not isMatch("bb", "a?(a|b)"))
		end)

		it('"bbc" should match "!([[*])*"', function()
			assert(isMatch("bbc", "!([[*])*"))
		end)

		it('"bbc" should not match "+(a|b\\[)*"', function()
			assert(not isMatch("bbc", "+(a|b\\[)*"))
		end)

		it('"bbc" should not match "[a*(]*z"', function()
			assert(not isMatch("bbc", "[a*(]*z"))
		end)

		it('"bz" should not match "a+(z)"', function()
			assert(not isMatch("bz", "a+(z)"))
		end)

		it('"c" should not match "*(@(a))a@(c)"', function()
			assert(not isMatch("c", "*(@(a))a@(c)"))
		end)

		itFIXME('"c.a" should not match "!(*.[a-b]*)"', function()
			assert(not isMatch("c.a", "!(*.[a-b]*)"))
		end)

		it('"c.a" should match "!(*[a-b].[a-b]*)"', function()
			assert(isMatch("c.a", "!(*[a-b].[a-b]*)"))
		end)

		it('"c.a" should not match "!*.(a|b)"', function()
			assert(not isMatch("c.a", "!*.(a|b)"))
		end)

		it('"c.a" should not match "!*.(a|b)*"', function()
			assert(not isMatch("c.a", "!*.(a|b)*"))
		end)

		it('"c.a" should not match "(b|a).(a)"', function()
			assert(not isMatch("c.a", "(b|a).(a)"))
		end)

		it('"c.a" should not match "*.!(a)"', function()
			assert(not isMatch("c.a", "*.!(a)"))
		end)

		it('"c.a" should not match "*.+(b|d)"', function()
			assert(not isMatch("c.a", "*.+(b|d)"))
		end)

		it('"c.a" should not match "@(b|a).@(a)"', function()
			assert(not isMatch("c.a", "@(b|a).@(a)"))
		end)

		it('"c.c" should not match "!(*.a|*.b|*.c)"', function()
			assert(not isMatch("c.c", "!(*.a|*.b|*.c)"))
		end)

		it('"c.c" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("c.c", "*!(.a|.b|.c)"))
		end)

		it('"c.c" should not match "*.!(a|b|c)"', function()
			assert(not isMatch("c.c", "*.!(a|b|c)"))
		end)

		it('"c.c" should not match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(not isMatch("c.c", "*.(a|b|@(ab|a*@(b))*(c)d)"))
		end)

		it('"c.ccc" should match "!(*.[a-b]*)"', function()
			assert(isMatch("c.ccc", "!(*.[a-b]*)"))
		end)

		it('"c.ccc" should match "!(*[a-b].[a-b]*)"', function()
			assert(isMatch("c.ccc", "!(*[a-b].[a-b]*)"))
		end)

		it('"c.js" should not match "!(*.js)"', function()
			assert(not isMatch("c.js", "!(*.js)"))
		end)

		it('"c.js" should match "*!(.js)"', function()
			assert(isMatch("c.js", "*!(.js)"))
		end)

		it('"c.js" should not match "*.!(js)"', function()
			assert(not isMatch("c.js", "*.!(js)"))
		end)

		it('"c/a/v" should match "c/!(z)/v"', function()
			assert(isMatch("c/a/v", "c/!(z)/v"))
		end)

		it('"c/a/v" should not match "c/*(z)/v"', function()
			assert(not isMatch("c/a/v", "c/*(z)/v"))
		end)

		it('"c/a/v" should not match "c/+(z)/v"', function()
			assert(not isMatch("c/a/v", "c/+(z)/v"))
		end)

		it('"c/a/v" should not match "c/@(z)/v"', function()
			assert(not isMatch("c/a/v", "c/@(z)/v"))
		end)

		it('"c/z/v" should not match "*(z)"', function()
			assert(not isMatch("c/z/v", "*(z)"))
		end)

		it('"c/z/v" should not match "+(z)"', function()
			assert(not isMatch("c/z/v", "+(z)"))
		end)

		it('"c/z/v" should not match "?(z)"', function()
			assert(not isMatch("c/z/v", "?(z)"))
		end)

		it('"c/z/v" should not match "c/!(z)/v"', function()
			assert(not isMatch("c/z/v", "c/!(z)/v"))
		end)

		it('"c/z/v" should match "c/*(z)/v"', function()
			assert(isMatch("c/z/v", "c/*(z)/v"))
		end)

		it('"c/z/v" should match "c/+(z)/v"', function()
			assert(isMatch("c/z/v", "c/+(z)/v"))
		end)

		it('"c/z/v" should match "c/@(z)/v"', function()
			assert(isMatch("c/z/v", "c/@(z)/v"))
		end)

		it('"c/z/v" should match "c/z/v"', function()
			assert(isMatch("c/z/v", "c/z/v"))
		end)

		it('"cc.a" should not match "(b|a).(a)"', function()
			assert(not isMatch("cc.a", "(b|a).(a)"))
		end)

		it('"cc.a" should not match "@(b|a).@(a)"', function()
			assert(not isMatch("cc.a", "@(b|a).@(a)"))
		end)

		it('"ccc" should match "!(a)*"', function()
			assert(isMatch("ccc", "!(a)*"))
		end)

		it('"ccc" should not match "a!(b)*"', function()
			assert(not isMatch("ccc", "a!(b)*"))
		end)

		it('"cow" should match "!(*.*)"', function()
			assert(isMatch("cow", "!(*.*)"))
		end)

		it('"cow" should not match "!(*.*)."', function()
			assert(not isMatch("cow", "!(*.*)."))
		end)

		it('"cow" should not match ".!(*.*)"', function()
			assert(not isMatch("cow", ".!(*.*)"))
		end)

		it('"cz" should not match "a!(*)"', function()
			assert(not isMatch("cz", "a!(*)"))
		end)

		it('"cz" should not match "a!(z)"', function()
			assert(not isMatch("cz", "a!(z)"))
		end)

		it('"cz" should not match "a*!(z)"', function()
			assert(not isMatch("cz", "a*!(z)"))
		end)

		it('"cz" should not match "a*(z)"', function()
			assert(not isMatch("cz", "a*(z)"))
		end)

		it('"cz" should not match "a**(z)"', function()
			assert(not isMatch("cz", "a**(z)"))
		end)

		it('"cz" should not match "a*@(z)"', function()
			assert(not isMatch("cz", "a*@(z)"))
		end)

		it('"cz" should not match "a+(z)"', function()
			assert(not isMatch("cz", "a+(z)"))
		end)

		it('"cz" should not match "a?(z)"', function()
			assert(not isMatch("cz", "a?(z)"))
		end)

		it('"cz" should not match "a@(z)"', function()
			assert(not isMatch("cz", "a@(z)"))
		end)

		itFIXME('"d.a.d" should not match "!(*.[a-b]*)"', function()
			assert(not isMatch("d.a.d", "!(*.[a-b]*)"))
		end)

		it('"d.a.d" should match "!(*[a-b].[a-b]*)"', function()
			assert(isMatch("d.a.d", "!(*[a-b].[a-b]*)"))
		end)

		it('"d.a.d" should not match "!*.(a|b)*"', function()
			assert(not isMatch("d.a.d", "!*.(a|b)*"))
		end)

		it('"d.a.d" should match "!*.*(a|b)"', function()
			assert(isMatch("d.a.d", "!*.*(a|b)"))
		end)

		it('"d.a.d" should not match "!*.{a,b}*"', function()
			assert(not isMatch("d.a.d", "!*.{a,b}*"))
		end)

		it('"d.a.d" should match "*.!(a)"', function()
			assert(isMatch("d.a.d", "*.!(a)"))
		end)

		it('"d.a.d" should match "*.+(b|d)"', function()
			assert(isMatch("d.a.d", "*.+(b|d)"))
		end)

		it('"d.d" should match "!(*.a|*.b|*.c)"', function()
			assert(isMatch("d.d", "!(*.a|*.b|*.c)"))
		end)

		it('"d.d" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("d.d", "*!(.a|.b|.c)"))
		end)

		it('"d.d" should match "*.!(a|b|c)"', function()
			assert(isMatch("d.d", "*.!(a|b|c)"))
		end)

		it('"d.d" should not match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(not isMatch("d.d", "*.(a|b|@(ab|a*@(b))*(c)d)"))
		end)

		it('"d.js.d" should match "!(*.js)"', function()
			assert(isMatch("d.js.d", "!(*.js)"))
		end)

		it('"d.js.d" should match "*!(.js)"', function()
			assert(isMatch("d.js.d", "*!(.js)"))
		end)

		it('"d.js.d" should match "*.!(js)"', function()
			assert(isMatch("d.js.d", "*.!(js)"))
		end)

		it('"dd.aa.d" should not match "(b|a).(a)"', function()
			assert(not isMatch("dd.aa.d", "(b|a).(a)"))
		end)

		it('"dd.aa.d" should not match "@(b|a).@(a)"', function()
			assert(not isMatch("dd.aa.d", "@(b|a).@(a)"))
		end)

		it('"def" should not match "()ef"', function()
			assert(not isMatch("def", "()ef"))
		end)

		it('"e.e" should match "!(*.a|*.b|*.c)"', function()
			assert(isMatch("e.e", "!(*.a|*.b|*.c)"))
		end)

		it('"e.e" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("e.e", "*!(.a|.b|.c)"))
		end)

		it('"e.e" should match "*.!(a|b|c)"', function()
			assert(isMatch("e.e", "*.!(a|b|c)"))
		end)

		it('"e.e" should not match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(not isMatch("e.e", "*.(a|b|@(ab|a*@(b))*(c)d)"))
		end)

		it('"ef" should match "()ef"', function()
			assert(isMatch("ef", "()ef"))
		end)

		it('"effgz" should match "@(b+(c)d|e*(f)g?|?(h)i@(j|k))"', function()
			assert(isMatch("effgz", "@(b+(c)d|e*(f)g?|?(h)i@(j|k))"))
		end)

		it('"efgz" should match "@(b+(c)d|e*(f)g?|?(h)i@(j|k))"', function()
			assert(isMatch("efgz", "@(b+(c)d|e*(f)g?|?(h)i@(j|k))"))
		end)

		it('"egz" should match "@(b+(c)d|e*(f)g?|?(h)i@(j|k))"', function()
			assert(isMatch("egz", "@(b+(c)d|e*(f)g?|?(h)i@(j|k))"))
		end)

		it('"egz" should not match "@(b+(c)d|e+(f)g?|?(h)i@(j|k))"', function()
			assert(not isMatch("egz", "@(b+(c)d|e+(f)g?|?(h)i@(j|k))"))
		end)

		it('"egzefffgzbcdij" should match "*(b+(c)d|e*(f)g?|?(h)i@(j|k))"', function()
			assert(isMatch("egzefffgzbcdij", "*(b+(c)d|e*(f)g?|?(h)i@(j|k))"))
		end)

		it('"f" should not match "!(f!(o))"', function()
			assert(not isMatch("f", "!(f!(o))"))
		end)

		it('"f" should match "!(f(o))"', function()
			assert(isMatch("f", "!(f(o))"))
		end)

		it('"f" should not match "!(f)"', function()
			assert(not isMatch("f", "!(f)"))
		end)

		it('"f" should not match "*(!(f))"', function()
			assert(not isMatch("f", "*(!(f))"))
		end)

		it('"f" should not match "+(!(f))"', function()
			assert(not isMatch("f", "+(!(f))"))
		end)

		it('"f.a" should not match "!(*.a|*.b|*.c)"', function()
			assert(not isMatch("f.a", "!(*.a|*.b|*.c)"))
		end)

		it('"f.a" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("f.a", "*!(.a|.b|.c)"))
		end)

		it('"f.a" should not match "*.!(a|b|c)"', function()
			assert(not isMatch("f.a", "*.!(a|b|c)"))
		end)

		it('"f.f" should match "!(*.a|*.b|*.c)"', function()
			assert(isMatch("f.f", "!(*.a|*.b|*.c)"))
		end)

		it('"f.f" should match "*!(.a|.b|.c)"', function()
			assert(isMatch("f.f", "*!(.a|.b|.c)"))
		end)

		it('"f.f" should match "*.!(a|b|c)"', function()
			assert(isMatch("f.f", "*.!(a|b|c)"))
		end)

		it('"f.f" should not match "*.(a|b|@(ab|a*@(b))*(c)d)"', function()
			assert(not isMatch("f.f", "*.(a|b|@(ab|a*@(b))*(c)d)"))
		end)

		it('"fa" should not match "!(f!(o))"', function()
			assert(not isMatch("fa", "!(f!(o))"))
		end)

		it('"fa" should match "!(f(o))"', function()
			assert(isMatch("fa", "!(f(o))"))
		end)

		it('"fb" should not match "!(f!(o))"', function()
			assert(not isMatch("fb", "!(f!(o))"))
		end)

		it('"fb" should match "!(f(o))"', function()
			assert(isMatch("fb", "!(f(o))"))
		end)

		it('"fff" should match "!(f)"', function()
			assert(isMatch("fff", "!(f)"))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"fff" should match "*(!(f))"', function()
			assert(isMatch("fff", "*(!(f))"))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"fff" should match "+(!(f))"', function()
			assert(isMatch("fff", "+(!(f))"))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"fffooofoooooffoofffooofff" should match "*(*(f)*(o))"', function()
			assert(isMatch("fffooofoooooffoofffooofff", "*(*(f)*(o))"))
		end)

		it('"ffo" should match "*(f*(o))"', function()
			assert(isMatch("ffo", "*(f*(o))"))
		end)

		it('"file.C" should not match "*.c?(c)"', function()
			assert(not isMatch("file.C", "*.c?(c)"))
		end)

		it('"file.c" should match "*.c?(c)"', function()
			assert(isMatch("file.c", "*.c?(c)"))
		end)

		it('"file.cc" should match "*.c?(c)"', function()
			assert(isMatch("file.cc", "*.c?(c)"))
		end)

		it('"file.ccc" should not match "*.c?(c)"', function()
			assert(not isMatch("file.ccc", "*.c?(c)"))
		end)

		it('"fo" should match "!(f!(o))"', function()
			assert(isMatch("fo", "!(f!(o))"))
		end)

		it('"fo" should not match "!(f(o))"', function()
			assert(not isMatch("fo", "!(f(o))"))
		end)

		it('"fofo" should match "*(f*(o))"', function()
			assert(isMatch("fofo", "*(f*(o))"))
		end)

		it('"fofoofoofofoo" should match "*(fo|foo)"', function()
			assert(isMatch("fofoofoofofoo", "*(fo|foo)"))
		end)

		it('"fofoofoofofoo" should match "*(fo|foo)"_', function()
			assert(isMatch("fofoofoofofoo", "*(fo|foo)"))
		end)

		it('"foo" should match "!(!(foo))"', function()
			assert(isMatch("foo", "!(!(foo))"))
		end)

		it('"foo" should match "!(f)"', function()
			assert(isMatch("foo", "!(f)"))
		end)

		it('"foo" should not match "!(foo)"', function()
			assert(not isMatch("foo", "!(foo)"))
		end)

		it('"foo" should not match "!(foo)*"', function()
			assert(not isMatch("foo", "!(foo)*"))
		end)

		it('"foo" should not match "!(foo)*"_', function()
			assert(not isMatch("foo", "!(foo)*"))
		end)

		it('"foo" should not match "!(foo)+"', function()
			assert(not isMatch("foo", "!(foo)+"))
		end)

		it('"foo" should not match "!(foo)b*"', function()
			assert(not isMatch("foo", "!(foo)b*"))
		end)

		it('"foo" should match "!(x)"', function()
			assert(isMatch("foo", "!(x)"))
		end)

		it('"foo" should match "!(x)*"', function()
			assert(isMatch("foo", "!(x)*"))
		end)

		it('"foo" should match "*"', function()
			assert(isMatch("foo", "*"))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"foo" should match "*(!(f))"', function()
			assert(isMatch("foo", "*(!(f))"))
		end)

		it('"foo" should not match "*(!(foo))"', function()
			assert(not isMatch("foo", "*(!(foo))"))
		end)

		it('"foo" should not match "*(@(a))a@(c)"', function()
			assert(not isMatch("foo", "*(@(a))a@(c)"))
		end)

		it('"foo" should match "*(@(foo))"', function()
			assert(isMatch("foo", "*(@(foo))"))
		end)

		it('"foo" should not match "*(a|b\\[)"', function()
			assert(not isMatch("foo", "*(a|b\\[)"))
		end)

		it('"foo" should match "*(a|b\\[)|f*"', function()
			assert(isMatch("foo", "*(a|b\\[)|f*"))
		end)

		it('"foo" should match "@(*(a|b\\[)|f*)"', function()
			assert(isMatch("foo", "@(*(a|b\\[)|f*)"))
		end)

		it('"foo" should not match "*/*/*"', function()
			assert(not isMatch("foo", "*/*/*"))
		end)

		it('"foo" should not match "*f"', function()
			assert(not isMatch("foo", "*f"))
		end)

		it('"foo" should match "*foo*"', function()
			assert(isMatch("foo", "*foo*"))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"foo" should match "+(!(f))"', function()
			assert(isMatch("foo", "+(!(f))"))
		end)

		it('"foo" should not match "??"', function()
			assert(not isMatch("foo", "??"))
		end)

		it('"foo" should match "???"', function()
			assert(isMatch("foo", "???"))
		end)

		it('"foo" should not match "bar"', function()
			assert(not isMatch("foo", "bar"))
		end)

		it('"foo" should match "f*"', function()
			assert(isMatch("foo", "f*"))
		end)

		it('"foo" should not match "fo"', function()
			assert(not isMatch("foo", "fo"))
		end)

		it('"foo" should match "foo"', function()
			assert(isMatch("foo", "foo"))
		end)

		it('"foo" should match "{*(a|b\\[),f*}"', function()
			assert(isMatch("foo", "{*(a|b\\[),f*}"))
		end)

		it('"foo*" should match "foo\\*"', function()
			assert(isMatch("foo*", "foo\\*", { windows = false }))
		end)

		it('"foo*bar" should match "foo\\*bar"', function()
			assert(isMatch("foo*bar", "foo\\*bar"))
		end)

		it('"foo.js" should not match "!(foo).js"', function()
			assert(not isMatch("foo.js", "!(foo).js"))
		end)

		it('"foo.js.js" should match "*.!(js)"', function()
			assert(isMatch("foo.js.js", "*.!(js)"))
		end)

		it('"foo.js.js" should not match "*.!(js)*"', function()
			assert(not isMatch("foo.js.js", "*.!(js)*"))
		end)

		it('"foo.js.js" should not match "*.!(js)*.!(js)"', function()
			assert(not isMatch("foo.js.js", "*.!(js)*.!(js)"))
		end)

		it('"foo.js.js" should not match "*.!(js)+"', function()
			assert(not isMatch("foo.js.js", "*.!(js)+"))
		end)

		it('"foo.txt" should match "**/!(bar).txt"', function()
			assert(isMatch("foo.txt", "**/!(bar).txt"))
		end)

		it('"foo/bar" should not match "*/*/*"', function()
			assert(not isMatch("foo/bar", "*/*/*"))
		end)

		it('"foo/bar" should match "foo/!(foo)"', function()
			assert(isMatch("foo/bar", "foo/!(foo)"))
		end)

		it('"foo/bar" should match "foo/*"', function()
			assert(isMatch("foo/bar", "foo/*"))
		end)

		it('"foo/bar" should match "foo/bar"', function()
			assert(isMatch("foo/bar", "foo/bar"))
		end)

		it('"foo/bar" should not match "foo?bar"', function()
			assert(not isMatch("foo/bar", "foo?bar"))
		end)

		itFIXME('"foo/bar" should match "foo[/]bar"', function()
			assert(isMatch("foo/bar", "foo[/]bar"))
		end)

		it('"foo/bar/baz.jsx" should match "foo/bar/**/*.+(js|jsx)"', function()
			assert(isMatch("foo/bar/baz.jsx", "foo/bar/**/*.+(js|jsx)"))
		end)

		it('"foo/bar/baz.jsx" should match "foo/bar/*.+(js|jsx)"', function()
			assert(isMatch("foo/bar/baz.jsx", "foo/bar/*.+(js|jsx)"))
		end)

		it('"foo/bb/aa/rr" should match "**/**/**"', function()
			assert(isMatch("foo/bb/aa/rr", "**/**/**"))
		end)

		it('"foo/bb/aa/rr" should not match "*/*/*"', function()
			assert(not isMatch("foo/bb/aa/rr", "*/*/*"))
		end)

		it('"foo/bba/arr" should match "*/*/*"', function()
			assert(isMatch("foo/bba/arr", "*/*/*"))
		end)

		it('"foo/bba/arr" should not match "foo*"', function()
			assert(not isMatch("foo/bba/arr", "foo*"))
		end)

		it('"foo/bba/arr" should not match "foo**"', function()
			assert(not isMatch("foo/bba/arr", "foo**"))
		end)

		it('"foo/bba/arr" should not match "foo/*"', function()
			assert(not isMatch("foo/bba/arr", "foo/*"))
		end)

		it('"foo/bba/arr" should match "foo/**"', function()
			assert(isMatch("foo/bba/arr", "foo/**"))
		end)

		itFIXME('"foo/bba/arr" should not match "foo/**arr"', function()
			assert(not isMatch("foo/bba/arr", "foo/**arr"))
		end)

		it('"foo/bba/arr" should not match "foo/**z"', function()
			assert(not isMatch("foo/bba/arr", "foo/**z"))
		end)

		it('"foo/bba/arr" should not match "foo/*arr"', function()
			assert(not isMatch("foo/bba/arr", "foo/*arr"))
		end)

		it('"foo/bba/arr" should not match "foo/*z"', function()
			assert(not isMatch("foo/bba/arr", "foo/*z"))
		end)

		it('"foob" should not match "!(foo)b*"', function()
			assert(not isMatch("foob", "!(foo)b*"))
		end)

		it('"foob" should not match "(foo)bb"', function()
			assert(not isMatch("foob", "(foo)bb"))
		end)

		it('"foobar" should match "!(foo)"', function()
			assert(isMatch("foobar", "!(foo)"))
		end)

		it('"foobar" should not match "!(foo)*"', function()
			assert(not isMatch("foobar", "!(foo)*"))
		end)

		it('"foobar" should not match "!(foo)b*"', function()
			assert(not isMatch("foobar", "!(foo)b*"))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"foobar" should match "*(!(foo))"', function()
			assert(isMatch("foobar", "*(!(foo))"))
		end)

		it('"foobar" should match "*ob*a*r*"', function()
			assert(isMatch("foobar", "*ob*a*r*"))
		end)

		it('"foobar" should not match "foo\\*bar"', function()
			assert(not isMatch("foobar", "foo\\*bar"))
		end)

		it('"foobb" should not match "!(foo)b*"', function()
			assert(not isMatch("foobb", "!(foo)b*"))
		end)

		it('"foobb" should match "(foo)bb"', function()
			assert(isMatch("foobb", "(foo)bb"))
		end)

		it('"(foo)bb" should match "\\(foo\\)bb"', function()
			assert(isMatch("(foo)bb", "\\(foo\\)bb"))
		end)

		it('"foofoofo" should match "@(foo|f|fo)*(f|of+(o))"', function()
			assert(isMatch("foofoofo", "@(foo|f|fo)*(f|of+(o))"))
		end)

		it('"foofoofo" should match "@(foo|f|fo)*(f|of+(o))"_', function()
			assert(isMatch("foofoofo", "@(foo|f|fo)*(f|of+(o))"))
		end)

		it('"fooofoofofooo" should match "*(f*(o))"', function()
			assert(isMatch("fooofoofofooo", "*(f*(o))"))
		end)

		it('"foooofo" should match "*(f*(o))"', function()
			assert(isMatch("foooofo", "*(f*(o))"))
		end)

		it('"foooofof" should match "*(f*(o))"', function()
			assert(isMatch("foooofof", "*(f*(o))"))
		end)

		it('"foooofof" should not match "*(f+(o))"', function()
			assert(not isMatch("foooofof", "*(f+(o))"))
		end)

		it('"foooofofx" should not match "*(f*(o))"', function()
			assert(not isMatch("foooofofx", "*(f*(o))"))
		end)

		it('"foooxfooxfoxfooox" should match "*(f*(o)x)"', function()
			assert(isMatch("foooxfooxfoxfooox", "*(f*(o)x)"))
		end)

		it('"foooxfooxfxfooox" should match "*(f*(o)x)"', function()
			assert(isMatch("foooxfooxfxfooox", "*(f*(o)x)"))
		end)

		it('"foooxfooxofoxfooox" should not match "*(f*(o)x)"', function()
			assert(not isMatch("foooxfooxofoxfooox", "*(f*(o)x)"))
		end)

		it('"foot" should match "@(!(z*)|*x)"', function()
			assert(isMatch("foot", "@(!(z*)|*x)"))
		end)

		it('"foox" should match "@(!(z*)|*x)"', function()
			assert(isMatch("foox", "@(!(z*)|*x)"))
		end)

		it('"fz" should not match "*(z)"', function()
			assert(not isMatch("fz", "*(z)"))
		end)

		it('"fz" should not match "+(z)"', function()
			assert(not isMatch("fz", "+(z)"))
		end)

		it('"fz" should not match "?(z)"', function()
			assert(not isMatch("fz", "?(z)"))
		end)

		it('"moo.cow" should not match "!(moo).!(cow)"', function()
			assert(not isMatch("moo.cow", "!(moo).!(cow)"))
		end)

		it('"moo.cow" should not match "!(*).!(*)"', function()
			assert(not isMatch("moo.cow", "!(*).!(*)"))
		end)

		it('"mad.moo.cow" should not match "!(*.*).!(*.*)"', function()
			assert(not isMatch("mad.moo.cow", "!(*.*).!(*.*)"))
		end)

		it('"mad.moo.cow" should not match ".!(*.*)"', function()
			assert(not isMatch("mad.moo.cow", ".!(*.*)"))
		end)

		it('"Makefile" should match "!(*.c|*.h|Makefile.in|config*|README)"', function()
			assert(isMatch("Makefile", "!(*.c|*.h|Makefile.in|config*|README)"))
		end)

		it('"Makefile.in" should not match "!(*.c|*.h|Makefile.in|config*|README)"', function()
			assert(not isMatch("Makefile.in", "!(*.c|*.h|Makefile.in|config*|README)"))
		end)

		it('"moo" should match "!(*.*)"', function()
			assert(isMatch("moo", "!(*.*)"))
		end)

		it('"moo" should not match "!(*.*)."', function()
			assert(not isMatch("moo", "!(*.*)."))
		end)

		it('"moo" should not match ".!(*.*)"', function()
			assert(not isMatch("moo", ".!(*.*)"))
		end)

		it('"moo.cow" should not match "!(*.*)"', function()
			assert(not isMatch("moo.cow", "!(*.*)"))
		end)

		it('"moo.cow" should not match "!(*.*)."', function()
			assert(not isMatch("moo.cow", "!(*.*)."))
		end)

		it('"moo.cow" should not match ".!(*.*)"', function()
			assert(not isMatch("moo.cow", ".!(*.*)"))
		end)

		it('"mucca.pazza" should not match "mu!(*(c))?.pa!(*(z))?"', function()
			assert(not isMatch("mucca.pazza", "mu!(*(c))?.pa!(*(z))?"))
		end)

		it('"ofoofo" should match "*(of+(o))"', function()
			assert(isMatch("ofoofo", "*(of+(o))"))
		end)

		it('"ofoofo" should match "*(of+(o)|f)"', function()
			assert(isMatch("ofoofo", "*(of+(o)|f)"))
		end)

		it('"ofooofoofofooo" should not match "*(f*(o))"', function()
			assert(not isMatch("ofooofoofofooo", "*(f*(o))"))
		end)

		it('"ofoooxoofxo" should match "*(*(of*(o)x)o)"', function()
			assert(isMatch("ofoooxoofxo", "*(*(of*(o)x)o)"))
		end)

		it('"ofoooxoofxoofoooxoofxo" should match "*(*(of*(o)x)o)"', function()
			assert(isMatch("ofoooxoofxoofoooxoofxo", "*(*(of*(o)x)o)"))
		end)

		it('"ofoooxoofxoofoooxoofxofo" should not match "*(*(of*(o)x)o)"', function()
			assert(not isMatch("ofoooxoofxoofoooxoofxofo", "*(*(of*(o)x)o)"))
		end)

		it('"ofoooxoofxoofoooxoofxoo" should match "*(*(of*(o)x)o)"', function()
			assert(isMatch("ofoooxoofxoofoooxoofxoo", "*(*(of*(o)x)o)"))
		end)

		it('"ofoooxoofxoofoooxoofxooofxofxo" should match "*(*(of*(o)x)o)"', function()
			assert(isMatch("ofoooxoofxoofoooxoofxooofxofxo", "*(*(of*(o)x)o)"))
		end)

		it('"ofxoofxo" should match "*(*(of*(o)x)o)"', function()
			assert(isMatch("ofxoofxo", "*(*(of*(o)x)o)"))
		end)

		it('"oofooofo" should match "*(of|oof+(o))"', function()
			assert(isMatch("oofooofo", "*(of|oof+(o))"))
		end)

		it('"ooo" should match "!(f)"', function()
			assert(isMatch("ooo", "!(f)"))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"ooo" should match "*(!(f))"', function()
			assert(isMatch("ooo", "*(!(f))"))
		end)

		-- ROBLOX NOTE: test hangs
		itFIXME('"ooo" should match "+(!(f))"', function()
			assert(isMatch("ooo", "+(!(f))"))
		end)

		it('"oxfoxfox" should not match "*(oxf+(ox))"', function()
			assert(not isMatch("oxfoxfox", "*(oxf+(ox))"))
		end)

		it('"oxfoxoxfox" should match "*(oxf+(ox))"', function()
			assert(isMatch("oxfoxoxfox", "*(oxf+(ox))"))
		end)

		it('"para" should match "para*([0-9])"', function()
			assert(isMatch("para", "para*([0-9])"))
		end)

		it('"para" should not match "para+([0-9])"', function()
			assert(not isMatch("para", "para+([0-9])"))
		end)

		it('"para.38" should match "para!(*.[00-09])"', function()
			assert(isMatch("para.38", "para!(*.[00-09])"))
		end)

		it('"para.graph" should match "para!(*.[0-9])"', function()
			assert(isMatch("para.graph", "para!(*.[0-9])"))
		end)

		itFIXME('"para13829383746592" should match "para*([0-9])"', function()
			assert(isMatch("para13829383746592", "para*([0-9])"))
		end)

		it('"para381" should not match "para?([345]|99)1"', function()
			assert(not isMatch("para381", "para?([345]|99)1"))
		end)

		it('"para39" should match "para!(*.[0-9])"', function()
			assert(isMatch("para39", "para!(*.[0-9])"))
		end)

		itFIXME('"para987346523" should match "para+([0-9])"', function()
			assert(isMatch("para987346523", "para+([0-9])"))
		end)

		it('"para991" should match "para?([345]|99)1"', function()
			assert(isMatch("para991", "para?([345]|99)1"))
		end)

		it('"paragraph" should match "para!(*.[0-9])"', function()
			assert(isMatch("paragraph", "para!(*.[0-9])"))
		end)

		it('"paragraph" should not match "para*([0-9])"', function()
			assert(not isMatch("paragraph", "para*([0-9])"))
		end)

		it('"paragraph" should match "para@(chute|graph)"', function()
			assert(isMatch("paragraph", "para@(chute|graph)"))
		end)

		it('"paramour" should not match "para@(chute|graph)"', function()
			assert(not isMatch("paramour", "para@(chute|graph)"))
		end)

		it('"parse.y" should match "!(*.c|*.h|Makefile.in|config*|README)"', function()
			assert(isMatch("parse.y", "!(*.c|*.h|Makefile.in|config*|README)"))
		end)

		it('"shell.c" should not match "!(*.c|*.h|Makefile.in|config*|README)"', function()
			assert(not isMatch("shell.c", "!(*.c|*.h|Makefile.in|config*|README)"))
		end)

		it('"VMS.FILE;" should not match "*\\;[1-9]*([0-9])"', function()
			assert(not isMatch("VMS.FILE;", "*\\;[1-9]*([0-9])"))
		end)

		it('"VMS.FILE;0" should not match "*\\;[1-9]*([0-9])"', function()
			assert(not isMatch("VMS.FILE;0", "*\\;[1-9]*([0-9])"))
		end)

		itFIXME('"VMS.FILE;1" should match "*\\;[1-9]*([0-9])"', function()
			assert(isMatch("VMS.FILE;1", "*\\;[1-9]*([0-9])"))
		end)

		itFIXME('"VMS.FILE;1" should match "*;[1-9]*([0-9])"', function()
			assert(isMatch("VMS.FILE;1", "*;[1-9]*([0-9])"))
		end)

		itFIXME('"VMS.FILE;139" should match "*\\;[1-9]*([0-9])"', function()
			assert(isMatch("VMS.FILE;139", "*\\;[1-9]*([0-9])"))
		end)

		it('"VMS.FILE;1N" should not match "*\\;[1-9]*([0-9])"', function()
			assert(not isMatch("VMS.FILE;1N", "*\\;[1-9]*([0-9])"))
		end)

		it('"xfoooofof" should not match "*(f*(o))"', function()
			assert(not isMatch("xfoooofof", "*(f*(o))"))
		end)

		it(
			'"XXX/adobe/courier/bold/o/normal//12/120/75/75/m/70/iso8859/1" should match "XXX/*/*/*/*/*/*/12/*/*/*/m/*/*/*"',
			function()
				assert(
					isMatch(
						"XXX/adobe/courier/bold/o/normal//12/120/75/75/m/70/iso8859/1",
						"XXX/*/*/*/*/*/*/12/*/*/*/m/*/*/*",
						{ windows = false }
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
						"XXX/*/*/*/*/*/*/12/*/*/*/m/*/*/*"
					)
				)
			end
		)
		it('"z" should match "*(z)"', function()
			assert(isMatch("z", "*(z)"))
		end)

		it('"z" should match "+(z)"', function()
			assert(isMatch("z", "+(z)"))
		end)

		it('"z" should match "?(z)"', function()
			assert(isMatch("z", "?(z)"))
		end)

		it('"zf" should not match "*(z)"', function()
			assert(not isMatch("zf", "*(z)"))
		end)

		it('"zf" should not match "+(z)"', function()
			assert(not isMatch("zf", "+(z)"))
		end)

		it('"zf" should not match "?(z)"', function()
			assert(not isMatch("zf", "?(z)"))
		end)

		it('"zoot" should not match "@(!(z*)|*x)"', function()
			assert(not isMatch("zoot", "@(!(z*)|*x)"))
		end)

		it('"zoox" should match "@(!(z*)|*x)"', function()
			assert(isMatch("zoox", "@(!(z*)|*x)"))
		end)

		it('"zz" should not match "(a+|b)*"', function()
			assert(not isMatch("zz", "(a+|b)*"))
		end)
	end)
end
