-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/wildmat.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent

	local isMatch = require(PicomatchModule).isMatch
	describe("Wildmat (git) tests", function()
		it("Basic wildmat features", function()
			assert(not isMatch("foo", "*f"))
			assert(not isMatch("foo", "??"))
			assert(not isMatch("foo", "bar"))
			assert(not isMatch("foobar", "foo\\*bar"))
			assert(isMatch("?a?b", "\\??\\?b"))
			assert(isMatch("aaaaaaabababab", "*ab"))
			assert(isMatch("foo", "*"))
			assert(isMatch("foo", "*foo*"))
			assert(isMatch("foo", "???"))
			assert(isMatch("foo", "f*"))
			assert(isMatch("foo", "foo"))
			assert(isMatch("foobar", "*ob*a*r*"))
		end)

		it("should support recursion", function()
			assert(
				not isMatch(
					"-adobe-courier-bold-o-normal--12-120-75-75-/-70-iso8859-1",
					"-*-*-*-*-*-*-12-*-*-*-m-*-*-*"
				)
			)
			assert(
				not isMatch(
					"-adobe-courier-bold-o-normal--12-120-75-75-X-70-iso8859-1",
					"-*-*-*-*-*-*-12-*-*-*-m-*-*-*"
				)
			)
			assert(not isMatch("ab/cXd/efXg/hi", "*X*i"))
			assert(not isMatch("ab/cXd/efXg/hi", "*Xg*i"))
			assert(not isMatch("abcd/abcdefg/abcdefghijk/abcdefghijklmnop.txtz", "**/*a*b*g*n*t"))
			assert(not isMatch("foo", "*/*/*"))
			assert(not isMatch("foo", "fo"))
			assert(not isMatch("foo/bar", "*/*/*"))
			assert(not isMatch("foo/bar", "foo?bar"))
			assert(not isMatch("foo/bb/aa/rr", "*/*/*"))
			assert(not isMatch("foo/bba/arr", "foo*"))
			assert(not isMatch("foo/bba/arr", "foo**"))
			assert(not isMatch("foo/bba/arr", "foo/*"))
			-- ROBLOX FIXME
			-- assert(not isMatch("foo/bba/arr", "foo/**arr"))
			assert(not isMatch("foo/bba/arr", "foo/**z"))
			assert(not isMatch("foo/bba/arr", "foo/*arr"))
			assert(not isMatch("foo/bba/arr", "foo/*z"))
			assert(
				not isMatch(
					"XXX/adobe/courier/bold/o/normal//12/120/75/75/X/70/iso8859/1",
					"XXX/*/*/*/*/*/*/12/*/*/*/m/*/*/*"
				)
			)
			assert(
				isMatch("-adobe-courier-bold-o-normal--12-120-75-75-m-70-iso8859-1", "-*-*-*-*-*-*-12-*-*-*-m-*-*-*")
			)
			assert(isMatch("ab/cXd/efXg/hi", "**/*X*/**/*i"))
			assert(isMatch("ab/cXd/efXg/hi", "*/*X*/*/*i"))
			assert(isMatch("abcd/abcdefg/abcdefghijk/abcdefghijklmnop.txt", "**/*a*b*g*n*t"))
			assert(isMatch("abcXdefXghi", "*X*i"))
			assert(isMatch("foo", "foo"))
			assert(isMatch("foo/bar", "foo/*"))
			assert(isMatch("foo/bar", "foo/bar"))
			-- ROBLOX FIXME
			-- assert(isMatch("foo/bar", "foo[/]bar"))
			assert(isMatch("foo/bb/aa/rr", "**/**/**"))
			assert(isMatch("foo/bba/arr", "*/*/*"))
			assert(isMatch("foo/bba/arr", "foo/**"))
		end)
	end)
end
