local path = require("../init").path
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

describe("path.normalize normalizes the given path", function()
	local normalizeTests = {
		{
			"/foo/bar//baz/asdf/quux/..",
			"/foo/bar/baz/asdf",
		},
	}

	for _, test in ipairs(normalizeTests) do
		it("normalizes to" .. test[2], function()
			local result = path:normalize(test[1])
			expect(result).toEqual(test[2])
		end)
	end
end)

describe("path.basename returns the last portion of a path", function()
	local basenameTests = {
		{
			{ "/foo/bar/baz/asdf/quux.html" } :: { string } | string,
			"quux.html",
		},
		{
			{ "/foo/bar/baz/asdf/quux.html", ".html" } :: { string } | string,
			"quux",
		},
	}

	for _, test in ipairs(basenameTests) do
		local args = test[1] :: { string }
		local expected = test[2] :: string

		it("basename result " .. expected, function()
			local actual = path:basename(table.unpack(args))
			expect(actual).toEqual(expected)
		end)
	end
end)

describe("path.isAbsolute determines if a path is an absolute path", function()
	local isAbsoluteTests = {
		{
			"/foo/bar" :: string | boolean,
			true,
		},
		{
			"/baz/.." :: string | boolean,
			true,
		},
		{
			"qux/" :: string | boolean,
			false,
		},
		{
			"." :: string | boolean,
			false,
		},
	}

	for _, test in ipairs(isAbsoluteTests) do
		it(test[1] :: string .. " should return " .. tostring(test[2]), function()
			expect(path:isAbsolute(test[1] :: string)).toEqual(test[2])
		end)
	end
end)

describe("path.extname returns the extension of the path", function()
	local extnameTests = {
		{
			"index.html",
			".html",
		},
		{
			"index.coffee.md",
			".md",
		},
		{
			"index.",
			".",
		},
		{
			"index",
			"",
		},
		{
			".index",
			"",
		},
		{
			".index.md",
			".md",
		},
	}

	for _, test in ipairs(extnameTests) do
		it(test[1] .. " should return " .. test[2], function()
			expect(path:extname(test[1])).toEqual(test[2])
		end)
	end
end)

describe("path.dirname returns directory name of a path", function()
	local dirnameTests = {
		{
			"/foo/bar/baz/asdf/quux",
			"/foo/bar/baz/asdf",
		},
	}

	for _, test in ipairs(dirnameTests) do
		it("returns directory name " .. test[2], function()
			local dirname = path:dirname(test[1])
			expect(dirname).toEqual(test[2])
		end)
	end
end)

describe("path.join joins all given path segments", function()
	local joinTests = {
		{
			{ "/foo", "bar", "baz/asdf", "quux", ".." } :: { string } | string,
			"/foo/bar/baz/asdf",
		},
	}

	for _, test in ipairs(joinTests) do
		local parts = test[1] :: { string }
		local expected = test[2] :: string

		it("resolves to " .. expected, function()
			local actual = path:join(unpack(parts))
			expect(actual).toEqual(expected)
		end)
	end
end)

describe("path.resolve correctly resolves absolute paths", function()
	local resolveTests = {
		{
			{ "/foo/bar", "./baz" } :: { string } | string,
			"/foo/bar/baz",
		},
		{
			{ "/foo/bar", "/tmp/file/" } :: { string } | string,
			"/tmp/file",
		},
		{
			{ "/wwwroot", "static_files/png/", "../gif/image.gif" } :: { string } | string,
			"/wwwroot/static_files/gif/image.gif",
		},
	}

	for _, test in ipairs(resolveTests) do
		local args = test[1] :: { string }
		local expected = test[2] :: string
		it(table.concat(test[1] :: { string }, ", ") .. " resolves to " .. expected, function()
			local result = path:resolve(table.unpack(args))
			expect(result).toEqual(test[2])
		end)
	end
end)

describe("path.relative correctly resolves relative paths", function()
	local relativeTests = {
		{ "/data/orandea/test/aaa", "/data/orandea/impl/bbb", "../../impl/bbb" },
		{ ".", "1234567890/1234567890/1234.js", "1234567890/1234567890/1234.js" },
		{ "", "1234567890/1234567890/1234.js", "1234567890/1234567890/1234.js" },
	}

	for _, test in ipairs(relativeTests) do
		local from = test[1]
		local to = test[2]
		local expected = test[3]

		it("should resolve " .. from .. " to " .. to .. " to " .. expected, function()
			local actual = path:relative(from, to)
			expect(actual).toEqual(expected)
		end)
	end
end)
