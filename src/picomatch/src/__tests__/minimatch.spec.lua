-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/minimatch.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent

	local function format(str)
		return str:gsub("^%./", "", 1)
	end
	local Picomatch = require(PicomatchModule)
	local isMatch, makeRe = Picomatch.isMatch, Picomatch.makeRe
	describe("minimatch parity:", function()
		describe("minimatch issues (as of 12/7/2016)", function()
			it("https://github.com/isaacs/minimatch/issues/29", function()
				assert(isMatch("foo/bar.txt", "foo/**/*.txt"))
				assert(makeRe("foo/**/*.txt"):test("foo/bar.txt"))
				assert(not isMatch("n/!(axios)/**", "n/axios/a.js"))
				assert(not makeRe("n/!(axios)/**"):test("n/axios/a.js"))
			end)

			it("https://github.com/isaacs/minimatch/issues/30", function()
				assert(isMatch("foo/bar.js", "**/foo/**", { format = format }))
				assert(isMatch("./foo/bar.js", "./**/foo/**", { format = format }))
				assert(isMatch("./foo/bar.js", "**/foo/**", { format = format }))
				assert(isMatch("./foo/bar.txt", "foo/**/*.txt", { format = format }))
				assert(makeRe("./foo/**/*.txt"):test("foo/bar.txt"))
				assert(not isMatch("./foo/!(bar)/**", "foo/bar/a.js", { format = format }))
				assert(not makeRe("./foo/!(bar)/**"):test("foo/bar/a.js"))
			end)

			itFIXME("https://github.com/isaacs/minimatch/issues/50", function()
				assert(isMatch("foo/bar-[ABC].txt", "foo/**/*-\\[ABC\\].txt"))
				assert(not isMatch("foo/bar-[ABC].txt", "foo/**/*-\\[abc\\].txt"))
				assert(isMatch("foo/bar-[ABC].txt", "foo/**/*-\\[abc\\].txt", { nocase = true }))
			end)

			it(
				"https://github.com/isaacs/minimatch/issues/67 (should work consistently with `makeRe` and matcher functions)",
				function()
					local re = makeRe("node_modules/foobar/**/*.bar")
					assert(re:test("node_modules/foobar/foo.bar"))
					assert(isMatch("node_modules/foobar/foo.bar", "node_modules/foobar/**/*.bar"))
				end
			)
			it("https://github.com/isaacs/minimatch/issues/75", function()
				assert(isMatch("foo/baz.qux.js", "foo/@(baz.qux).js"))
				assert(isMatch("foo/baz.qux.js", "foo/+(baz.qux).js"))
				assert(isMatch("foo/baz.qux.js", "foo/*(baz.qux).js"))
				assert(not isMatch("foo/baz.qux.js", "foo/!(baz.qux).js"))
				assert(not isMatch("foo/bar/baz.qux.js", "foo/*/!(baz.qux).js"))
				assert(not isMatch("foo/bar/bazqux.js", "**/!(bazqux).js"))
				assert(not isMatch("foo/bar/bazqux.js", "**/bar/!(bazqux).js"))
				assert(not isMatch("foo/bar/bazqux.js", "foo/**/!(bazqux).js"))
				assert(not isMatch("foo/bar/bazqux.js", "foo/**/!(bazqux)*.js"))
				assert(not isMatch("foo/bar/baz.qux.js", "foo/**/!(baz.qux)*.js"))
				assert(not isMatch("foo/bar/baz.qux.js", "foo/**/!(baz.qux).js"))
				assert(not isMatch("foobar.js", "!(foo)*.js"))
				assert(not isMatch("foo.js", "!(foo).js"))
				assert(not isMatch("foo.js", "!(foo)*.js"))
			end)

			itFIXME("https://github.com/isaacs/minimatch/issues/78", function()
				assert(isMatch("a\\b\\c.txt", "a/**/*.txt", { windows = true }))
				assert(isMatch("a/b/c.txt", "a/**/*.txt", { windows = true }))
			end)

			it("https://github.com/isaacs/minimatch/issues/82", function()
				assert(isMatch("./src/test/a.js", "**/test/**", { format = format }))
				assert(isMatch("src/test/a.js", "**/test/**"))
			end)

			it("https://github.com/isaacs/minimatch/issues/83", function()
				assert(not makeRe("foo/!(bar)/**"):test("foo/bar/a.js"))
				assert(not isMatch("foo/!(bar)/**", "foo/bar/a.js"))
			end)
		end)
	end)
end
