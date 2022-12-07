-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-config/src/__tests__/normalize.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]
local Packages = script.Parent.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
-- ROBLOX deviation START: add String & console
local String = LuauPolyfill.String
local console = LuauPolyfill.console
-- ROBLOX deviation END
type Array<T> = LuauPolyfill.Array<T>
-- ROBLOX deviation START: add Object
type Object = LuauPolyfill.Object
-- ROBLOX deviation END
type Record<K, T> = { [K]: T } --[[ ROBLOX TODO: TS 'Record' built-in type is not available in Luau ]]
local Promise = require(Packages.Promise)
-- ROBLOX deviation START: add RegExp
local RegExp = require(Packages.RegExp)
type RegExp = RegExp.RegExp
-- ROBLOX deviation END
local JestGlobals = require(Packages.Dev.JestGlobals)
-- ROBLOX deviation START: not used
-- local afterAll = JestGlobals.afterAll
-- ROBLOX deviation END
local afterEach = JestGlobals.afterEach
-- ROBLOX deviation START: not used
-- local beforeAll = JestGlobals.beforeAll
-- ROBLOX deviation END
local beforeEach = JestGlobals.beforeEach
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local jest = JestGlobals.jest
-- ROBLOX deviation START: not used
-- local test = JestGlobals.test
-- ROBLOX deviation END
-- ROBLOX deviation START: add type
type jest_SpyInstance = any
-- ROBLOX deviation END
-- ROBLOX deviation START: not used
-- local createHash = require(Packages.crypto).createHash
-- local path = require(Packages.path).default
-- local wrap = require(Packages["jest-snapshot-serializer-raw"]).wrap
-- local semver = require(Packages.semver)
-- local stripAnsi = require(Packages["strip-ansi"]).default
-- ROBLOX deviation END
local jestTypesModule = require(Packages.JestTypes)
-- ROBLOX deviation START: not used
-- type Config = jestTypesModule.Config
-- ROBLOX deviation END
type Config_Argv = jestTypesModule.Config_Argv
type Config_InitialOptions = jestTypesModule.Config_InitialOptions
-- ROBLOX deviation START: not used
-- local escapeStrForRegex = require(Packages["jest-regex-util"]).escapeStrForRegex
-- ROBLOX deviation END
local Defaults = require(script.Parent.Parent.Defaults).default
-- ROBLOX deviation START: not used
-- local DEFAULT_JS_PATTERN = require(script.Parent.Parent.constants).DEFAULT_JS_PATTERN
-- ROBLOX deviation END
local normalize = require(script.Parent.Parent.normalize).default
-- ROBLOX deviation START: not used
-- local DEFAULT_CSS_PATTERN = "\\.(css)$"
-- ROBLOX deviation END
-- ROBLOX deviation START: add helper functions
local function pathToInstance(path)
	return Array.reduce(
		Array.filter(String.split(path, "/"), Boolean.toJSBoolean),
		function(
			result: { root: Instance, leaf: Instance } | typeof(Object.None),
			pathSegment: string
		): { root: Instance, leaf: Instance }
			local leaf: Instance = Instance.new("Folder")
			leaf.Name = pathSegment
			local root = leaf
			if result ~= Object.None then
				leaf.Parent = result.leaf
				root = result.root
			end
			return {
				root = root,
				leaf = leaf,
			}
		end,
		Object.None
	).leaf
end
local JestRobloxShared = require(Packages.JestRobloxShared)
local JSON = JestRobloxShared.nodeUtils.JSON
local getRelativePath = JestRobloxShared.getRelativePath
-- ROBLOX deviation END
-- ROBLOX deviation START: not used
-- jest.mock("path", function()
-- 	return jest.requireActual("path").posix
-- end):mock("graceful-fs", function()
-- 	local realFs = jest.requireActual("fs")
-- 	return Object.assign({}, realFs, {
-- 		statSync = function()
-- 			return {
-- 				isDirectory = function()
-- 					return true
-- 				end,
-- 			}
-- 		end,
-- 	})
-- end)
-- local root: string
-- local expectedPathFooBar: string
-- local expectedPathFooQux: string
-- ROBLOX deviation END
local expectedPathAbs: string
local expectedPathAbsAnother: string
-- ROBLOX deviation START: not used
-- local virtualModuleRegexes: Array<RegExp>
-- beforeEach(function()
-- 	virtualModuleRegexes = {
-- 		error("not implemented"),--[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]]--[[ /jest-circus/ ]]
-- 		error("not implemented"),--[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]]--[[ /babel-jest/ ]]
-- 	}
-- 	return virtualModuleRegexes
-- end)
-- local findNodeModule = jest.fn(function(name)
-- 	if
-- 		Boolean.toJSBoolean(
-- 			Array.some(virtualModuleRegexes, function(regex)
-- 				return regex:test(name)
-- 			end) --[[ ROBLOX CHECK: check if 'virtualModuleRegexes' is an Array ]]
-- 		)
-- 	then
-- 		return name
-- 	end
-- 	return nil
-- end) -- Windows uses backslashes for path separators, which need to be escaped in
-- ROBLOX deviation END
-- regular expressions. This little helper function helps us generate the
-- expected strings for checking path patterns.
-- ROBLOX deviation START: issue roblox/js-to-lua #847
-- local function joinForPattern(
-- 	...: any --[[ ROBLOX CHECK: check correct type of elements. Upstream type: <Array<string>> ]]
-- )
local function joinForPattern(...: string)
	-- ROBLOX deviation END
	local args = { ... }
	-- ROBLOX deviation START
	-- return Array.join(args, escapeStrForRegex(path.sep)) --[[ ROBLOX CHECK: check if 'args' is an Array ]]
	return Array.join(args, "/")
	-- ROBLOX deviation END
end
-- ROBLOX deviation START: add
local originalWarn = console.warn
-- ROBLOX deviation END
beforeEach(function()
	-- ROBLOX deviation START: not used
	-- root = path:resolve("/")
	-- expectedPathFooBar = Array.join(path, root, "root", "path", "foo", "bar", "baz") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- expectedPathFooQux = Array.join(path, root, "root", "path", "foo", "qux", "quux") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- ROBLOX deviation END
	-- ROBLOX deviation START: hardcode path
	-- expectedPathAbs = Array.join(path, root, "an", "abs", "path") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- expectedPathAbsAnother = Array.join(path, root, "another", "abs", "path") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	expectedPathAbs = "/an/abs/path"
	expectedPathAbsAnother = "/another/abs/path"
	-- ROBLOX deviation END
	-- ROBLOX deviation START: not used
	-- require_("jest-resolve").default.findNodeModule = findNodeModule
	-- ROBLOX deviation END
	-- ROBLOX deviation START: jest.spyOn not available
	-- jest.spyOn(console, "warn")
	console.warn = jest.fn()
	-- ROBLOX deviation END
end)
afterEach(function()
	-- ROBLOX deviation START: jest.spyOn not available
	-- ((console.warn :: unknown) :: jest_SpyInstance):mockRestore()
	console.warn = originalWarn
	-- ROBLOX deviation END
end)
-- ROBLOX deviation START: additional tests
describe("rootDir", function()
	it("throws error when rootDir is string", function()
		expect(function()
			normalize({ rootDir = "rootDir" :: any }, {} :: Config_Argv):expect()
		end).toThrowErrorMatchingSnapshot()
	end)

	it("throws error when rootDir is table", function()
		expect(function()
			normalize({
				rootDir = setmetatable({}, {
					__tostring = function()
						return "TABLE"
					end,
				}) :: any,
			}, {} :: Config_Argv):expect()
		end).toThrowErrorMatchingSnapshot()
	end)
end)
-- ROBLOX deviation END
it("picks a name based on the rootDir", function()
	return Promise.resolve():andThen(function()
		-- ROBLOX deviation START: uses pathToInstance helper function
		-- local rootDir = "/root/path/foo"
		local rootDir = pathToInstance("/root/path/foo")
		-- ROBLOX deviation END
		-- ROBLOX deviation START: createHash not available
		-- local expected = createHash("md5"):update("/root/path/foo"):update(String(math.huge)):digest("hex")
		local expected = "/root/path/foo"
		-- ROBLOX deviation END
		local options = normalize({ rootDir = rootDir }, {} :: Config_Argv):expect().options
		expect(options.name).toBe(expected)
	end)
end)
it("keeps custom project name based on the projects rootDir", function()
	return Promise.resolve():andThen(function()
		local name = "test"
		local options = normalize(
			-- ROBLOX deviation START: uses pathToInstance helper function
			-- { projects = { { name = name, rootDir = "/path/to/foo" } }, rootDir = "/root/path/baz" },
			{
				projects = { { name = name, rootDir = pathToInstance("/path/to/foo") } :: any },
				rootDir = pathToInstance("/root/path/baz"),
			},
			-- ROBLOX deviation END
			{} :: Config_Argv
		):expect().options
		-- ROBLOX deviation START: add type
		-- expect(options.projects[
		-- 	1 --[[ ROBLOX adaptation: added 1 to array index ]]
		-- ].name).toBe(name)
		expect((options.projects[1] :: any).name).toBe(name)
		-- ROBLOX deviation END
	end)
end)
it("keeps custom names based on the rootDir", function()
	return Promise.resolve():andThen(function()
		local options =
			-- ROBLOX deviation START: uses pathToInstance helper function
			-- normalize({ name = "custom-name", rootDir = "/root/path/foo" }, {} :: Config_Argv):expect().options
			normalize({ name = "custom-name", rootDir = pathToInstance("/root/path/foo") }, {} :: Config_Argv):expect().options
		-- ROBLOX deviation END
		expect(options.name).toBe("custom-name")
	end)
end)
it("minimal config is stable across runs", function()
	return Promise.resolve():andThen(function()
		-- ROBLOX deviation START: uses pathToInstance helper function
		-- local firstNormalization = normalize({ rootDir = "/root/path/foo" }, {} :: Config_Argv):expect()
		-- local secondNormalization = normalize({ rootDir = "/root/path/foo" }, {} :: Config_Argv):expect()
		local rootDir = pathToInstance("/root/path/foo")
		local firstNormalization = normalize({ rootDir = rootDir }, {} :: Config_Argv):expect()
		local secondNormalization = normalize({ rootDir = rootDir }, {} :: Config_Argv):expect()
		-- ROBLOX deviation END
		expect(firstNormalization).toEqual(secondNormalization)
		-- ROBLOX deviation START: issue roblox/js-to-lua #864
		-- expect(JSON:stringify(firstNormalization)).toBe(JSON:stringify(secondNormalization))
		expect(JSON.stringify(firstNormalization)).toBe(JSON.stringify(secondNormalization))
		-- ROBLOX deviation END
	end)
end)
-- ROBLOX deviation START: not supported
-- it("sets coverageReporters correctly when argv.json is set", function()
-- 	return Promise.resolve():andThen(function()
-- 		local options = normalize({ rootDir = "/root/path/foo" }, { json = true } :: Config_Argv):expect().options
-- 		expect(options.coverageReporters).toEqual({ "json", "lcov", "clover" })
-- 	end)
-- end)
-- ROBLOX deviation END
describe("rootDir", function()
	it("throws if the options is missing a rootDir property", function()
		return Promise.resolve():andThen(function()
			expect.assertions(1)
			expect(normalize({}, {} :: Config_Argv)).rejects.toThrowErrorMatchingSnapshot():expect()
		end)
	end)
end)
describe("automock", function()
	it("falsy automock is not overwritten", function()
		return Promise.resolve():andThen(function()
			((console.warn :: unknown) :: jest_SpyInstance):mockImplementation(function() end)
			local options =
				-- ROBLOX deviation START: uses pathToInstance helper function
				-- normalize({ automock = false, rootDir = "/root/path/foo" }, {} :: Config_Argv):expect().options
				normalize({ automock = false, rootDir = pathToInstance("/root/path/foo") }, {} :: Config_Argv):expect().options
			-- ROBLOX deviation END
			expect(options.automock).toBe(false)
		end)
	end)
end)
-- ROBLOX deviation START: not supported
-- describe("collectCoverageOnlyFrom", function()
-- 	it("normalizes all paths relative to rootDir", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({
-- 				collectCoverageOnlyFrom = { ["bar/baz"] = true, ["qux/quux/"] = true },
-- 				rootDir = "/root/path/foo/",
-- 			}, {} :: Config_Argv):expect().options
-- 			local expected = Object.create(nil)
-- 			expected[tostring(expectedPathFooBar)] = true
-- 			expected[tostring(expectedPathFooQux)] = true
-- 			expect(options.collectCoverageOnlyFrom).toEqual(expected)
-- 		end)
-- 	end)
-- 	it("does not change absolute paths", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({
-- 				collectCoverageOnlyFrom = {
-- 					["/an/abs/path"] = true,
-- 					["/another/abs/path"] = true,
-- 				},
-- 				rootDir = "/root/path/foo",
-- 			}, {} :: Config_Argv):expect().options
-- 			local expected = Object.create(nil)
-- 			expected[tostring(expectedPathAbs)] = true
-- 			expected[tostring(expectedPathAbsAnother)] = true
-- 			expect(options.collectCoverageOnlyFrom).toEqual(expected)
-- 		end)
-- 	end)
-- 	it("substitutes <rootDir> tokens", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({
-- 				collectCoverageOnlyFrom = { ["<rootDir>/bar/baz"] = true },
-- 				rootDir = "/root/path/foo",
-- 			}, {} :: Config_Argv):expect().options
-- 			local expected = Object.create(nil)
-- 			expected[tostring(expectedPathFooBar)] = true
-- 			expect(options.collectCoverageOnlyFrom).toEqual(expected)
-- 		end)
-- 	end)
-- end)
-- describe("collectCoverageFrom", function()
-- 	it("substitutes <rootDir> tokens", function()
-- 		return Promise.resolve():andThen(function()
-- 			local barBaz = "bar/baz"
-- 			local quxQuux = "qux/quux/"
-- 			local notQuxQuux = ("!%s"):format(tostring(quxQuux))
-- 			local options = normalize({
-- 				collectCoverageFrom = {
-- 					barBaz,
-- 					notQuxQuux,
-- 					("<rootDir>/%s"):format(tostring(barBaz)),
-- 					("!<rootDir>/%s"):format(tostring(quxQuux)),
-- 				},
-- 				rootDir = "/root/path/foo/",
-- 			}, {} :: Config_Argv):expect().options
-- 			local expected = { barBaz, notQuxQuux, barBaz, notQuxQuux }
-- 			expect(options.collectCoverageFrom).toEqual(expected)
-- 		end)
-- 	end)
-- end)
-- describe("findRelatedTests", function()
-- 	it("it generates --coverageCoverageFrom patterns when needed", function()
-- 		return Promise.resolve():andThen(function()
-- 			local sourceFile = "file1.js"
-- 			local options = normalize({ collectCoverage = true, rootDir = "/root/path/foo/" }, {
-- 				_ = {
-- 					("/root/path/%s"):format(tostring(sourceFile)),
-- 					sourceFile,
-- 					("<rootDir>/bar/%s"):format(tostring(sourceFile)),
-- 				},
-- 				findRelatedTests = true,
-- 			} :: Config_Argv):expect().options
-- 			local expected = {
-- 				("../%s"):format(tostring(sourceFile)),
-- 				("%s"):format(tostring(sourceFile)),
-- 				("bar/%s"):format(tostring(sourceFile)),
-- 			}
-- 			expect(options.collectCoverageFrom).toEqual(expected)
-- 		end)
-- 	end)
-- end)
-- ROBLOX deviation END

local function testPathArray(key: string)
	-- ROBLOX deviation START: not supported
	-- it("normalizes all paths relative to rootDir", function()
	-- 	return Promise.resolve():andThen(function()
	-- 		local options = normalize(
	-- 			{ [tostring(key)] = { "bar/baz", "qux/quux/" }, rootDir = "/root/path/foo" },
	-- 			{} :: Config_Argv
	-- 		):expect().options
	-- 		expect(options[tostring(key)]).toEqual({ expectedPathFooBar, expectedPathFooQux })
	-- 	end)
	-- end)
	-- ROBLOX deviation END
	it("does not change absolute paths", function()
		return Promise.resolve():andThen(function()
			local options = normalize({
				-- ROBLOX deviation START: uses pathToInstance helper function
				-- [tostring(key)] = { "/an/abs/path", "/another/abs/path" },
				-- rootDir = "/root/path/foo",
				[key] = { pathToInstance("/an/abs/path"), pathToInstance("/another/abs/path") },
				rootDir = pathToInstance("/root/path/foo"),
				-- ROBLOX deviation END
				-- ROBLOX deviation START: cast to type any to suppress type error
				-- }, {} :: Config_Argv):expect().options
			} :: any, {} :: Config_Argv):expect().options
			-- ROBLOX deviation END
			-- ROBLOX deviation START
			-- expect(options[tostring(key)]).toEqual({ expectedPathAbs, expectedPathAbsAnother })
			expect(Array.map((options :: Object)[key], function(path)
				return getRelativePath(path, nil)
			end)).toEqual({
				expectedPathAbs,
				expectedPathAbsAnother,
			})
			-- ROBLOX deviation END
		end)
	end)
	-- ROBLOX deviation START: not supported
	-- it("substitutes <rootDir> tokens", function()
	-- 	return Promise.resolve():andThen(function()
	-- 		local options = normalize(
	-- 			{ [tostring(key)] = { "<rootDir>/bar/baz" }, rootDir = "/root/path/foo" },
	-- 			{} :: Config_Argv
	-- 		):expect().options
	-- 		expect(options[tostring(key)]).toEqual({ expectedPathFooBar })
	-- 	end)
	-- end)
	-- ROBLOX deviation END
end
describe("roots", function()
	testPathArray("roots")
end)
-- ROBLOX deviation START: not supported
-- describe("transform", function()
-- 	local Resolver
-- 	beforeEach(function()
-- 		Resolver = require_("jest-resolve").default
-- 		Resolver.findNodeModule = jest.fn(function(name)
-- 			return name
-- 		end)
-- 	end)
-- 	it("normalizes the path", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({
-- 				rootDir = "/root/",
-- 				transform = {
-- 					[tostring(DEFAULT_CSS_PATTERN)] = "<rootDir>/node_modules/jest-regex-util",
-- 					[tostring(DEFAULT_JS_PATTERN)] = "babel-jest",
-- 					["abs-path"] = "/qux/quux",
-- 				},
-- 			}, {} :: Config_Argv):expect().options
-- 			expect(options.transform).toEqual({
-- 				{ DEFAULT_CSS_PATTERN, "/root/node_modules/jest-regex-util", {} },
-- 				{ DEFAULT_JS_PATTERN, require_:resolve("babel-jest"), {} },
-- 				{ "abs-path", "/qux/quux", {} },
-- 			})
-- 		end)
-- 	end)
-- 	it("pulls in config if it's passed as an array, and defaults to empty object", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({
-- 				rootDir = "/root/",
-- 				transform = {
-- 					[tostring(DEFAULT_CSS_PATTERN)] = "<rootDir>/node_modules/jest-regex-util",
-- 					[tostring(DEFAULT_JS_PATTERN)] = { "babel-jest", { rootMode = "upward" } },
-- 					["abs-path"] = "/qux/quux",
-- 				},
-- 			}, {} :: Config_Argv):expect().options
-- 			expect(options.transform).toEqual({
-- 				{ DEFAULT_CSS_PATTERN, "/root/node_modules/jest-regex-util", {} },
-- 				{ DEFAULT_JS_PATTERN, require_:resolve("babel-jest"), { rootMode = "upward" } },
-- 				{ "abs-path", "/qux/quux", {} },
-- 			})
-- 		end)
-- 	end)
-- end)
-- describe("haste", function()
-- 	local Resolver
-- 	beforeEach(function()
-- 		Resolver = require_("jest-resolve").default
-- 		Resolver.findNodeModule = jest.fn(function(name)
-- 			return name
-- 		end)
-- 	end)
-- 	it("normalizes the path for hasteImplModulePath", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize(
-- 				{ haste = { hasteImplModulePath = "<rootDir>/haste_impl.js" }, rootDir = "/root/" },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			expect(options.haste).toEqual({ hasteImplModulePath = "/root/haste_impl.js" })
-- 		end)
-- 	end)
-- end)
-- describe("setupFilesAfterEnv", function()
-- 	local Resolver
-- 	beforeEach(function()
-- 		Resolver = require_("jest-resolve").default
-- 		Resolver.findNodeModule = jest.fn(function(name)
-- 			return if Boolean.toJSBoolean(name:startsWith("/"))
-- 				then name
-- 				else "/root/path/foo" .. tostring(path.sep) .. tostring(name)
-- 		end)
-- 	end)
-- 	it("normalizes the path according to rootDir", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize(
-- 				{ rootDir = "/root/path/foo", setupFilesAfterEnv = { "bar/baz" } },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			expect(options.setupFilesAfterEnv).toEqual({ expectedPathFooBar })
-- 		end)
-- 	end)
-- 	it("does not change absolute paths", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize(
-- 				{ rootDir = "/root/path/foo", setupFilesAfterEnv = { "/an/abs/path" } },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			expect(options.setupFilesAfterEnv).toEqual({ expectedPathAbs })
-- 		end)
-- 	end)
-- 	it("substitutes <rootDir> tokens", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize(
-- 				{ rootDir = "/root/path/foo", setupFilesAfterEnv = { "<rootDir>/bar/baz" } },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			expect(options.setupFilesAfterEnv).toEqual({ expectedPathFooBar })
-- 		end)
-- 	end)
-- end)
-- describe("setupTestFrameworkScriptFile", function()
-- 	local Resolver
-- 	beforeEach(function()
-- 		((console.warn :: unknown) :: jest_SpyInstance):mockImplementation(function() end)
-- 		Resolver = require_("jest-resolve").default
-- 		Resolver.findNodeModule = jest.fn(function(name)
-- 			return if Boolean.toJSBoolean(name:startsWith("/"))
-- 				then name
-- 				else "/root/path/foo" .. tostring(path.sep) .. tostring(name)
-- 		end)
-- 	end)
-- 	it("logs a deprecation warning when `setupTestFrameworkScriptFile` is used", function()
-- 		return Promise.resolve():andThen(function()
-- 			normalize({ rootDir = "/root/path/foo", setupTestFrameworkScriptFile = "bar/baz" }, {} :: Config_Argv):expect()
-- 			expect(((console.warn :: unknown) :: jest_SpyInstance).mock.calls[
-- 				1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			][
-- 				1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			]).toMatchSnapshot()
-- 		end)
-- 	end)
-- 	it("logs an error when `setupTestFrameworkScriptFile` and `setupFilesAfterEnv` are used", function()
-- 		return Promise.resolve():andThen(function()
-- 			expect(normalize({
-- 					rootDir = "/root/path/foo",
-- 					setupFilesAfterEnv = { "bar/baz" },
-- 					setupTestFrameworkScriptFile = "bar/baz",
-- 				}, {} :: Config_Argv)).rejects
-- 				.toThrowErrorMatchingSnapshot()
-- 				:expect()
-- 		end)
-- 	end)
-- end)
-- describe("coveragePathIgnorePatterns", function()
-- 	it("does not normalize paths relative to rootDir", function()
-- 		return Promise.resolve():andThen(function()
-- 			-- This is a list of patterns, so we can't assume any of them are
-- 			-- directories
-- 			local options = normalize({
-- 				coveragePathIgnorePatterns = { "bar/baz", "qux/quux" },
-- 				rootDir = "/root/path/foo",
-- 			}, {} :: Config_Argv):expect().options
-- 			expect(options.coveragePathIgnorePatterns).toEqual({
-- 				joinForPattern("bar", "baz"),
-- 				joinForPattern("qux", "quux"),
-- 			})
-- 		end)
-- 	end)
-- 	it("does not normalize trailing slashes", function()
-- 		return Promise.resolve():andThen(function()
-- 			-- This is a list of patterns, so we can't assume any of them are
-- 			-- directories
-- 			local options = normalize({
-- 				coveragePathIgnorePatterns = { "bar/baz", "qux/quux/" },
-- 				rootDir = "/root/path/foo",
-- 			}, {} :: Config_Argv):expect().options
-- 			expect(options.coveragePathIgnorePatterns).toEqual({
-- 				joinForPattern("bar", "baz"),
-- 				joinForPattern("qux", "quux", ""),
-- 			})
-- 		end)
-- 	end)
-- 	it("substitutes <rootDir> tokens", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({
-- 				coveragePathIgnorePatterns = { "hasNoToken", "<rootDir>/hasAToken" },
-- 				rootDir = "/root/path/foo",
-- 			}, {} :: Config_Argv):expect().options
-- 			expect(options.coveragePathIgnorePatterns).toEqual({
-- 				"hasNoToken",
-- 				joinForPattern("", "root", "path", "foo", "hasAToken"),
-- 			})
-- 		end)
-- 	end)
-- end)
-- describe("watchPathIgnorePatterns", function()
-- 	it("does not normalize paths relative to rootDir", function()
-- 		return Promise.resolve():andThen(function()
-- 			-- This is a list of patterns, so we can't assume any of them are
-- 			-- directories
-- 			local options = normalize(
-- 				{ rootDir = "/root/path/foo", watchPathIgnorePatterns = { "bar/baz", "qux/quux" } },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			expect(options.watchPathIgnorePatterns).toEqual({
-- 				joinForPattern("bar", "baz"),
-- 				joinForPattern("qux", "quux"),
-- 			})
-- 		end)
-- 	end)
-- 	it("does not normalize trailing slashes", function()
-- 		return Promise.resolve():andThen(function()
-- 			-- This is a list of patterns, so we can't assume any of them are
-- 			-- directories
-- 			local options = normalize(
-- 				{ rootDir = "/root/path/foo", watchPathIgnorePatterns = { "bar/baz", "qux/quux/" } },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			expect(options.watchPathIgnorePatterns).toEqual({
-- 				joinForPattern("bar", "baz"),
-- 				joinForPattern("qux", "quux", ""),
-- 			})
-- 		end)
-- 	end)
-- 	it("substitutes <rootDir> tokens", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({
-- 				rootDir = "/root/path/foo",
-- 				watchPathIgnorePatterns = { "hasNoToken", "<rootDir>/hasAToken" },
-- 			}, {} :: Config_Argv):expect().options
-- 			expect(options.watchPathIgnorePatterns).toEqual({
-- 				"hasNoToken",
-- 				joinForPattern("", "root", "path", "foo", "hasAToken"),
-- 			})
-- 		end)
-- 	end)
-- end)
-- ROBLOX deviation END
describe("testPathIgnorePatterns", function()
	it("does not normalize paths relative to rootDir", function()
		return Promise.resolve():andThen(function()
			-- This is a list of patterns, so we can't assume any of them are
			-- directories
			local options = normalize(
				-- ROBLOX deviation START: uses pathToInstance helper function
				-- { rootDir = "/root/path/foo", testPathIgnorePatterns = { "bar/baz", "qux/quux" } },
				{ rootDir = pathToInstance("/root/path/foo"), testPathIgnorePatterns = { "bar/baz", "qux/quux" } },
				-- ROBLOX deviation END
				{} :: Config_Argv
			):expect().options
			expect(options.testPathIgnorePatterns).toEqual({
				joinForPattern("bar", "baz"),
				joinForPattern("qux", "quux"),
			})
		end)
	end)
	it("does not normalize trailing slashes", function()
		return Promise.resolve():andThen(function()
			-- This is a list of patterns, so we can't assume any of them are
			-- directories
			local options = normalize(
				-- ROBLOX deviation START: uses pathToInstance helper function
				-- { rootDir = "/root/path/foo", testPathIgnorePatterns = { "bar/baz", "qux/quux/" } },
				{ rootDir = pathToInstance("/root/path/foo"), testPathIgnorePatterns = { "bar/baz", "qux/quux/" } },
				-- ROBLOX deviation END
				{} :: Config_Argv
			):expect().options
			expect(options.testPathIgnorePatterns).toEqual({
				joinForPattern("bar", "baz"),
				joinForPattern("qux", "quux", ""),
			})
		end)
	end)
	-- ROBLOX deviation START: not supported
	-- it("substitutes <rootDir> tokens", function()
	-- 	return Promise.resolve():andThen(function()
	-- 		local options = normalize({
	-- 			rootDir = "/root/path/foo",
	-- 			testPathIgnorePatterns = { "hasNoToken", "<rootDir>/hasAToken" },
	-- 		}, {} :: Config_Argv):expect().options
	-- 		expect(options.testPathIgnorePatterns).toEqual({
	-- 			"hasNoToken",
	-- 			joinForPattern("", "root", "path", "foo", "hasAToken"),
	-- 		})
	-- 	end)
	-- end)
	-- ROBLOX deviation END
end)
-- ROBLOX deviation START
-- describe("modulePathIgnorePatterns", function()
-- 	it("does not normalize paths relative to rootDir", function()
-- 		return Promise.resolve():andThen(function()
-- 			-- This is a list of patterns, so we can't assume any of them are
-- 			-- directories
-- 			local options = normalize(
-- 				{ modulePathIgnorePatterns = { "bar/baz", "qux/quux" }, rootDir = "/root/path/foo" },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			expect(options.modulePathIgnorePatterns).toEqual({
-- 				joinForPattern("bar", "baz"),
-- 				joinForPattern("qux", "quux"),
-- 			})
-- 		end)
-- 	end)
-- 	it("does not normalize trailing slashes", function()
-- 		return Promise.resolve():andThen(function()
-- 			-- This is a list of patterns, so we can't assume any of them are
-- 			-- directories
-- 			local options = normalize({
-- 				modulePathIgnorePatterns = { "bar/baz", "qux/quux/" },
-- 				rootDir = "/root/path/foo",
-- 			}, {} :: Config_Argv):expect().options
-- 			expect(options.modulePathIgnorePatterns).toEqual({
-- 				joinForPattern("bar", "baz"),
-- 				joinForPattern("qux", "quux", ""),
-- 			})
-- 		end)
-- 	end)
-- 	it("substitutes <rootDir> tokens", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({
-- 				modulePathIgnorePatterns = { "hasNoToken", "<rootDir>/hasAToken" },
-- 				rootDir = "/root/path/foo",
-- 			}, {} :: Config_Argv):expect().options
-- 			expect(options.modulePathIgnorePatterns).toEqual({
-- 				"hasNoToken",
-- 				joinForPattern("", "root", "path", "foo", "hasAToken"),
-- 			})
-- 		end)
-- 	end)
-- end)
-- describe("testRunner", function()
-- 	it("defaults to Circus", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({ rootDir = "/root/path/foo" }, {} :: Config_Argv):expect().options
-- 			expect(options.testRunner).toMatch("jest-circus")
-- 		end)
-- 	end)
-- 	it("resolves jasmine", function()
-- 		return Promise.resolve():andThen(function()
-- 			local Resolver = require_("jest-resolve").default
-- 			Resolver.findNodeModule = jest.fn(function(name)
-- 				return name
-- 			end)
-- 			local options =
-- 				normalize({ rootDir = "/root/path/foo" }, { testRunner = "jasmine2" } :: Config_Argv):expect().options
-- 			expect(options.testRunner).toMatch("jest-jasmine2")
-- 		end)
-- 	end)
-- 	it("is overwritten by argv", function()
-- 		return Promise.resolve():andThen(function()
-- 			local Resolver = require_("jest-resolve").default
-- 			Resolver.findNodeModule = jest.fn(function(name)
-- 				return name
-- 			end)
-- 			local options =
-- 				normalize({ rootDir = "/root/path/foo" }, { testRunner = "mocha" } :: Config_Argv):expect().options
-- 			expect(options.testRunner).toBe("mocha")
-- 		end)
-- 	end)
-- end)
-- describe("coverageDirectory", function()
-- 	it("defaults to <rootDir>/coverage", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({ rootDir = "/root/path/foo" }, {} :: Config_Argv):expect().options
-- 			expect(options.coverageDirectory).toBe("/root/path/foo/coverage")
-- 		end)
-- 	end)
-- end)
-- describe("testEnvironment", function()
-- 	local Resolver
-- 	beforeEach(function()
-- 		Resolver = require_("jest-resolve").default
-- 		Resolver.findNodeModule = jest.fn(function(name)
-- 			if Boolean.toJSBoolean(Array.includes({ "jsdom", "jest-environment-jsdom" }, name)) then
-- 				return ("node_modules/%s"):format(tostring(name))
-- 			end
-- 			if Boolean.toJSBoolean(name:startsWith("/root")) then
-- 				return name
-- 			end
-- 			return findNodeModule(name)
-- 		end)
-- 	end)
-- 	it("resolves to an environment and prefers jest-environment-`name`", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options =
-- 				normalize({ rootDir = "/root", testEnvironment = "jsdom" }, {} :: Config_Argv):expect().options
-- 			expect(options.testEnvironment).toEqual("node_modules/jest-environment-jsdom")
-- 		end)
-- 	end)
-- 	it("resolves to node environment by default", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({ rootDir = "/root" }, {} :: Config_Argv):expect().options
-- 			expect(options.testEnvironment).toEqual(require_:resolve("jest-environment-node"))
-- 		end)
-- 	end)
-- 	it("throws on invalid environment names", function()
-- 		return Promise.resolve():andThen(function()
-- 			expect(normalize({ rootDir = "/root", testEnvironment = "phantom" }, {} :: Config_Argv)).rejects
-- 				.toThrowErrorMatchingSnapshot()
-- 				:expect()
-- 		end)
-- 	end)
-- 	it("works with rootDir", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize(
-- 				{ rootDir = "/root", testEnvironment = "<rootDir>/testEnvironment.js" },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			expect(options.testEnvironment).toEqual("/root/testEnvironment.js")
-- 		end)
-- 	end)
-- end)
-- describe("babel-jest", function()
-- 	local Resolver
-- 	beforeEach(function()
-- 		Resolver = require_("jest-resolve").default
-- 		Resolver.findNodeModule = jest.fn(function(name)
-- 			return if Array.indexOf(name, "babel-jest") --[[ ROBLOX CHECK: check if 'name' is an Array ]]
-- 					== -1
-- 				then tostring(path.sep) .. "node_modules" .. tostring(path.sep) .. tostring(name)
-- 				else name
-- 		end)
-- 	end)
-- 	it("correctly identifies and uses babel-jest", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({ rootDir = "/root" }, {} :: Config_Argv):expect().options
-- 			expect(options.transform[
-- 				1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			][
-- 				1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			]).toBe(DEFAULT_JS_PATTERN)
-- 			expect(options.transform[
-- 				1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			][
-- 				2 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			]).toEqual(require_:resolve("babel-jest"))
-- 		end)
-- 	end)
-- 	it("uses babel-jest if babel-jest is explicitly specified in a custom transform options", function()
-- 		return Promise.resolve():andThen(function()
-- 			local customJSPattern = "\\.js$"
-- 			local options = normalize({
-- 				rootDir = "/root",
-- 				transform = { [tostring(customJSPattern)] = "babel-jest" },
-- 			}, {} :: Config_Argv):expect().options
-- 			expect(options.transform[
-- 				1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			][
-- 				1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			]).toBe(customJSPattern)
-- 			expect(options.transform[
-- 				1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			][
-- 				2 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			]).toEqual(require_:resolve("babel-jest"))
-- 		end)
-- 	end)
-- end)
-- describe("Upgrade help", function()
-- 	beforeEach(function()
-- 		((console.warn :: unknown) :: jest_SpyInstance):mockImplementation(function() end)
-- 		local Resolver = require_("jest-resolve").default
-- 		Resolver.findNodeModule = jest.fn(function(name)
-- 			if
-- 				name == "bar/baz" --[[ ROBLOX CHECK: loose equality used upstream ]]
-- 			then
-- 				return "/node_modules/bar/baz"
-- 			end
-- 			return findNodeModule(name)
-- 		end)
-- 	end)
-- 	it("logs a warning when `scriptPreprocessor` and/or `preprocessorIgnorePatterns` are used", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options, hasDeprecationWarnings
-- 			do
-- 				local ref = normalize({
-- 					preprocessorIgnorePatterns = { "bar/baz", "qux/quux" },
-- 					rootDir = "/root/path/foo",
-- 					scriptPreprocessor = "bar/baz",
-- 				}, {} :: Config_Argv):expect()
-- 				options, hasDeprecationWarnings = ref.options, ref.hasDeprecationWarnings
-- 			end
-- 			expect(options.transform).toEqual({ { ".*", "/node_modules/bar/baz", {} } })
-- 			expect(options.transformIgnorePatterns).toEqual({
-- 				joinForPattern("bar", "baz"),
-- 				joinForPattern("qux", "quux"),
-- 			})
-- 			expect(options)["not"].toHaveProperty("scriptPreprocessor")
-- 			expect(options)["not"].toHaveProperty("preprocessorIgnorePatterns")
-- 			expect(hasDeprecationWarnings).toBeTruthy()
-- 			expect(((console.warn :: unknown) :: jest_SpyInstance).mock.calls[
-- 				1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			][
-- 				1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			]).toMatchSnapshot()
-- 		end)
-- 	end)
-- end)
-- ROBLOX deviation END
describe("testRegex", function()
	it("testRegex empty string is mapped to empty array", function()
		return Promise.resolve():andThen(function()
			-- ROBLOX deviation START: uses pathToInstance helper function
			-- local options = normalize({ rootDir = "/root", testRegex = "" }, {} :: Config_Argv):expect().options
			local options =
				normalize({ rootDir = pathToInstance("/root"), testRegex = "" }, {} :: Config_Argv):expect().options
			-- ROBLOX deviation END
			expect(options.testRegex).toEqual({})
		end)
	end)
	it("testRegex string is mapped to an array", function()
		return Promise.resolve():andThen(function()
			-- ROBLOX deviation START: uses pathToInstance helper function
			-- local options = normalize({ rootDir = "/root", testRegex = ".*" }, {} :: Config_Argv):expect().options
			local options =
				normalize({ rootDir = pathToInstance("/root"), testRegex = ".*" }, {} :: Config_Argv):expect().options
			-- ROBLOX deviation END
			expect(options.testRegex).toEqual({ ".*" })
		end)
	end)
	it("testRegex array is preserved", function()
		return Promise.resolve():andThen(function()
			-- ROBLOX deviation START: uses pathToInstance helper function
			-- local options =
			-- 	normalize({ rootDir = "/root", testRegex = { ".*", "foo\\.bar" } }, {} :: Config_Argv):expect().options
			local options = normalize(
				{ rootDir = pathToInstance("/root"), testRegex = { ".*", "foo\\.bar" } },
				{} :: Config_Argv
			):expect().options
			-- ROBLOX deviation END
			expect(options.testRegex).toEqual({ ".*", "foo\\.bar" })
		end)
	end)
end)
describe("testMatch", function()
	it("testMatch default not applied if testRegex is set", function()
		return Promise.resolve():andThen(function()
			-- ROBLOX deviation START: uses pathToInstance helper function
			-- local options = normalize({ rootDir = "/root", testRegex = ".*" }, {} :: Config_Argv):expect().options
			local options =
				normalize({ rootDir = pathToInstance("/root"), testRegex = ".*" }, {} :: Config_Argv):expect().options
			-- ROBLOX deviation END
			-- ROBLOX deviation START: uses pound to get array length
			-- expect(options.testMatch.length).toBe(0)
			expect(#options.testMatch).toBe(0)
			-- ROBLOX deviation END
		end)
	end)
	it("testRegex default not applied if testMatch is set", function()
		return Promise.resolve():andThen(function()
			local options =
				-- ROBLOX deviation START: uses pathToInstance helper function
				-- normalize({ rootDir = "/root", testMatch = { "**/*.js" } }, {} :: Config_Argv):expect().options
				normalize({ rootDir = pathToInstance("/root"), testMatch = { "**/*.js" } }, {} :: Config_Argv):expect().options
			-- ROBLOX deviation END
			expect(options.testRegex).toEqual({})
		end)
	end)
	it("throws if testRegex and testMatch are both specified", function()
		return Promise.resolve():andThen(function()
			-- ROBLOX deviation START: uses pathToInstance helper function
			-- expect(normalize({ rootDir = "/root", testMatch = { "**/*.js" }, testRegex = ".*" }, {} :: Config_Argv)).rejects
			expect(
					normalize(
						{ rootDir = pathToInstance("/root"), testMatch = { "**/*.js" }, testRegex = ".*" },
						{} :: Config_Argv
					)
				)
				.rejects
				-- ROBLOX deviation END
				.toThrowErrorMatchingSnapshot()
				:expect()
		end)
	end)
	-- ROBLOX deviation START: not supported
	-- it("normalizes testMatch", function()
	-- 	return Promise.resolve():andThen(function()
	-- 		local options =
	-- 			normalize({ rootDir = "/root", testMatch = { "<rootDir>/**/*.js" } }, {} :: Config_Argv):expect().options
	-- 		expect(options.testMatch).toEqual({ "/root/**/*.js" })
	-- 	end)
	-- end)
	-- ROBLOX deviation END
end)
-- ROBLOX deviation START: not supported
-- describe("moduleDirectories", function()
-- 	it("defaults to node_modules", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({ rootDir = "/root" }, {} :: Config_Argv):expect().options
-- 			expect(options.moduleDirectories).toEqual({ "node_modules" })
-- 		end)
-- 	end)
-- 	it("normalizes moduleDirectories", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({
-- 				moduleDirectories = { "<rootDir>/src", "<rootDir>/node_modules" },
-- 				rootDir = "/root",
-- 			}, {} :: Config_Argv):expect().options
-- 			expect(options.moduleDirectories).toEqual({ "/root/src", "/root/node_modules" })
-- 		end)
-- 	end)
-- end)
-- describe("preset", function()
-- 	beforeEach(function()
-- 		local Resolver = require_("jest-resolve").default
-- 		Resolver.findNodeModule = jest.fn(function(name)
-- 			if name == "react-native/jest-preset" then
-- 				return "/node_modules/react-native/jest-preset.json"
-- 			end
-- 			if name == "react-native-js-preset/jest-preset" then
-- 				return "/node_modules/react-native-js-preset/jest-preset.js"
-- 			end
-- 			if name == "cjs-preset/jest-preset" then
-- 				return "/node_modules/cjs-preset/jest-preset.cjs"
-- 			end
-- 			if name == "mjs-preset/jest-preset" then
-- 				return "/node_modules/mjs-preset/jest-preset.mjs"
-- 			end
-- 			if
-- 				Boolean.toJSBoolean(
-- 					Array.includes(name, "doesnt-exist") --[[ ROBLOX CHECK: check if 'name' is an Array ]]
-- 				)
-- 			then
-- 				return nil
-- 			end
-- 			return "/node_modules/" .. tostring(name)
-- 		end)
-- 		jest.doMock("/node_modules/react-native/jest-preset.json", function()
-- 			return {
-- 				moduleNameMapper = { b = "b" },
-- 				modulePathIgnorePatterns = { "b" },
-- 				setupFiles = { "b" },
-- 				setupFilesAfterEnv = { "b" },
-- 				transform = { b = "b" },
-- 			}
-- 		end, { virtual = true })
-- 		jest.doMock("/node_modules/react-native-js-preset/jest-preset.js", function()
-- 			return { moduleNameMapper = { json = true } }
-- 		end, { virtual = true })
-- 		jest.doMock("/node_modules/cjs-preset/jest-preset.cjs", function()
-- 			return { moduleNameMapper = { cjs = true } }
-- 		end, { virtual = true })
-- 		jest.doMock("/node_modules/mjs-preset/jest-preset.mjs", function()
-- 			return { moduleNameMapper = { mjs = true } }
-- 		end, { virtual = true })
-- 	end)
-- 	afterEach(function()
-- 		jest.dontMock("/node_modules/react-native/jest-preset.json")
-- 		jest.dontMock("/node_modules/react-native-js-preset/jest-preset.js")
-- 		jest.dontMock("/node_modules/cjs-preset/jest-preset.cjs")
-- 		jest.dontMock("/node_modules/mjs-preset/jest-preset.mjs")
-- 	end)
-- 	test("throws when preset not found", function()
-- 		return Promise.resolve():andThen(function()
-- 			expect(normalize({ preset = "doesnt-exist", rootDir = "/root/path/foo" }, {} :: Config_Argv)).rejects
-- 				.toThrowErrorMatchingSnapshot()
-- 				:expect()
-- 		end)
-- 	end)
-- 	test('throws when module was found but no "jest-preset.js" or "jest-preset.json" files', function()
-- 		return Promise.resolve():andThen(function()
-- 			expect(normalize({ preset = "exist-but-no-jest-preset", rootDir = "/root/path/foo" }, {} :: Config_Argv)).rejects
-- 				.toThrowErrorMatchingSnapshot()
-- 				:expect()
-- 		end)
-- 	end)
-- 	test("throws when a dependency is missing in the preset", function()
-- 		return Promise.resolve():andThen(function()
-- 			jest.doMock("/node_modules/react-native-js-preset/jest-preset.js", function()
-- 				require_("library-that-is-not-installed")
-- 				return { transform = {} :: Config_Argv }
-- 			end, { virtual = true })
-- 			expect(normalize({ preset = "react-native-js-preset", rootDir = "/root/path/foo" }, {} :: Config_Argv)).rejects
-- 				.toThrowError(
-- 					error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /Cannot find module 'library-that-is-not-installed'/ ]]
-- 				)
-- 				:expect()
-- 		end)
-- 	end)
-- 	test("throws when preset is invalid", function()
-- 		return Promise.resolve():andThen(function()
-- 			jest.doMock("/node_modules/react-native/jest-preset.json", function()
-- 				return jest.requireActual("./jest-preset.json")
-- 			end)
-- 			expect(normalize({ preset = "react-native", rootDir = "/root/path/foo" }, {} :: Config_Argv)).rejects
-- 				.toThrowError(
-- 					error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /Unexpected token } in JSON at position 104[\s\S]* at / ]]
-- 				)
-- 				:expect()
-- 		end)
-- 	end)
-- 	test("throws when preset evaluation throws type error", function()
-- 		return Promise.resolve():andThen(function()
-- 			jest.doMock("/node_modules/react-native-js-preset/jest-preset.js", function()
-- 				return { transform = ({}).nonExistingProp() }
-- 			end, { virtual = true })
-- 			local errorMessage = if Boolean.toJSBoolean(semver:satisfies(process.versions.node, ">=16.9.1"))
-- 				then "TypeError: Cannot read properties of undefined (reading 'call')"
-- 				else
-- 					error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /TypeError: Cannot read property 'call' of undefined[\s\S]* at / ]]
-- 			expect(normalize({ preset = "react-native-js-preset", rootDir = "/root/path/foo" }, {} :: Config_Argv)).rejects
-- 				.toThrowError(errorMessage)
-- 				:expect()
-- 		end)
-- 	end)
-- 	test('works with "react-native"', function()
-- 		return Promise.resolve():andThen(function()
-- 			expect(normalize({ preset = "react-native", rootDir = "/root/path/foo" }, {} :: Config_Argv)).resolves["not"]
-- 				.toThrow()
-- 				:expect()
-- 		end)
-- 	end)
-- 	test:each({ "react-native-js-preset", "cjs-preset" })("works with cjs preset", function(presetName)
-- 		return Promise.resolve():andThen(function()
-- 			expect(normalize({ preset = presetName, rootDir = "/root/path/foo" }, {} :: Config_Argv)).resolves["not"]
-- 				.toThrow()
-- 				:expect()
-- 		end)
-- 	end)
-- 	test("works with esm preset", function()
-- 		return Promise.resolve():andThen(function()
-- 			expect(normalize({ preset = "mjs-preset", rootDir = "/root/path/foo" }, {} :: Config_Argv)).resolves["not"]
-- 				.toThrow()
-- 				:expect()
-- 		end)
-- 	end)
-- 	test("searches for .json, .js, .cjs, .mjs preset files", function()
-- 		return Promise.resolve():andThen(function()
-- 			local Resolver = require_("jest-resolve").default
-- 			normalize({ preset = "react-native", rootDir = "/root/path/foo" }, {} :: Config_Argv):expect()
-- 			local options = Resolver.findNodeModule.mock.calls[
-- 				1 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			][
-- 				2 --[[ ROBLOX adaptation: added 1 to array index ]]
-- 			]
-- 			expect(options.extensions).toEqual({ ".json", ".js", ".cjs", ".mjs" })
-- 		end)
-- 	end)
-- 	test("merges with options", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({
-- 				moduleNameMapper = { a = "a" },
-- 				modulePathIgnorePatterns = { "a" },
-- 				preset = "react-native",
-- 				rootDir = "/root/path/foo",
-- 				setupFiles = { "a" },
-- 				setupFilesAfterEnv = { "a" },
-- 				transform = { a = "a" },
-- 			}, {} :: Config_Argv):expect().options
-- 			expect(options.moduleNameMapper).toEqual({ { "a", "a" }, { "b", "b" } })
-- 			expect(options.modulePathIgnorePatterns).toEqual({ "b", "a" })
-- 			expect(
-- 				Array.sort(options.setupFiles) --[[ ROBLOX CHECK: check if 'options.setupFiles' is an Array ]]
-- 			).toEqual({ "/node_modules/a", "/node_modules/b" })
-- 			expect(
-- 				Array.sort(options.setupFilesAfterEnv) --[[ ROBLOX CHECK: check if 'options.setupFilesAfterEnv' is an Array ]]
-- 			).toEqual({ "/node_modules/a", "/node_modules/b" })
-- 			expect(options.transform).toEqual({
-- 				{ "a", "/node_modules/a", {} },
-- 				{ "b", "/node_modules/b", {} },
-- 			})
-- 		end)
-- 	end)
-- 	test("merges with options and moduleNameMapper preset is overridden by options", function()
-- 		return Promise.resolve():andThen(function()
-- 			-- Object initializer not used for properties as a workaround for
-- 			--  sort-keys eslint rule while specifying properties in
-- 			--  non-alphabetical order for a better test
-- 			local moduleNameMapper = {} :: Record<string, string>
-- 			moduleNameMapper.e = "ee"
-- 			moduleNameMapper.b = "bb"
-- 			moduleNameMapper.c = "cc"
-- 			moduleNameMapper.a = "aa"
-- 			local options = normalize({
-- 				moduleNameMapper = moduleNameMapper,
-- 				preset = "react-native",
-- 				rootDir = "/root/path/foo",
-- 			}, {} :: Config_Argv):expect().options
-- 			expect(options.moduleNameMapper).toEqual({
-- 				{ "e", "ee" },
-- 				{ "b", "bb" },
-- 				{ "c", "cc" },
-- 				{ "a", "aa" },
-- 			})
-- 		end)
-- 	end)
-- 	test("merges with options and transform preset is overridden by options", function()
-- 		return Promise.resolve():andThen(function()
-- 			--[[ eslint-disable sort-keys ]]
-- 			local transform = { e = "ee", b = "bb", c = "cc", a = "aa" }
-- 			--[[ eslint-enable ]]
-- 			local options = normalize(
-- 				{ preset = "react-native", rootDir = "/root/path/foo", transform = transform },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			expect(options.transform).toEqual({
-- 				{ "e", "/node_modules/ee", {} },
-- 				{ "b", "/node_modules/bb", {} },
-- 				{ "c", "/node_modules/cc", {} },
-- 				{ "a", "/node_modules/aa", {} },
-- 			})
-- 		end)
-- 	end)
-- 	test("extracts setupFilesAfterEnv from preset", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options =
-- 				normalize({ preset = "react-native", rootDir = "/root/path/foo" }, {} :: Config_Argv):expect().options
-- 			expect(options.setupFilesAfterEnv).toEqual({ "/node_modules/b" })
-- 		end)
-- 	end)
-- end)
-- describe("preset with globals", function()
-- 	beforeEach(function()
-- 		local Resolver = require_("jest-resolve").default
-- 		Resolver.findNodeModule = jest.fn(function(name)
-- 			if name == "global-foo/jest-preset" then
-- 				return "/node_modules/global-foo/jest-preset.json"
-- 			end
-- 			return "/node_modules/" .. tostring(name)
-- 		end)
-- 		jest.doMock("/node_modules/global-foo/jest-preset.json", function()
-- 			return {
-- 				globals = {
-- 					__DEV__ = false,
-- 					config = { hereToStay = "This should stay here" },
-- 					myString = "hello world",
-- 				},
-- 			}
-- 		end, { virtual = true })
-- 	end)
-- 	afterEach(function()
-- 		jest.dontMock("/node_modules/global-foo/jest-preset.json")
-- 	end)
-- 	test("should merge the globals preset correctly", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({
-- 				globals = {
-- 					__DEV__ = true,
-- 					config = { sideBySide = "This should also live another day" },
-- 					myString = "hello sunshine",
-- 					textValue = "This is just text",
-- 				},
-- 				preset = "global-foo",
-- 				rootDir = "/root/path/foo",
-- 			}, {} :: Config_Argv):expect().options
-- 			expect(options.globals).toEqual({
-- 				__DEV__ = true,
-- 				config = {
-- 					hereToStay = "This should stay here",
-- 					sideBySide = "This should also live another day",
-- 				},
-- 				myString = "hello sunshine",
-- 				textValue = "This is just text",
-- 			})
-- 		end)
-- 	end)
-- end)
-- describe:each({ "setupFiles", "setupFilesAfterEnv" })("preset without %s", function(configKey)
-- 	local Resolver
-- 	beforeEach(function()
-- 		Resolver = require_("jest-resolve").default
-- 		Resolver.findNodeModule = jest.fn(function(name)
-- 			return tostring(path.sep) .. "node_modules" .. tostring(path.sep) .. tostring(name)
-- 		end)
-- 	end)
-- 	beforeAll(function()
-- 		jest.doMock("/node_modules/react-foo/jest-preset", function()
-- 			return { moduleNameMapper = { b = "b" }, modulePathIgnorePatterns = { "b" } }
-- 		end, { virtual = true })
-- 	end)
-- 	afterAll(function()
-- 		jest.dontMock("/node_modules/react-foo/jest-preset")
-- 	end)
-- 	it(("should normalize %s correctly"):format(tostring(configKey)), function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({
-- 				[tostring(configKey)] = { "a" },
-- 				preset = "react-foo",
-- 				rootDir = "/root/path/foo",
-- 			}, {} :: Config_Argv):expect().options
-- 			expect(options).toEqual(expect.objectContaining({ [tostring(configKey)] = { "/node_modules/a" } }))
-- 		end)
-- 	end)
-- end)
-- describe("runner", function()
-- 	local Resolver
-- 	beforeEach(function()
-- 		Resolver = require_("jest-resolve").default
-- 		Resolver.findNodeModule = jest.fn(function(name)
-- 			if Boolean.toJSBoolean(Array.includes({ "eslint", "jest-runner-eslint", "my-runner-foo" }, name)) then
-- 				return ("node_modules/%s"):format(tostring(name))
-- 			end
-- 			if Boolean.toJSBoolean(name:startsWith("/root")) then
-- 				return name
-- 			end
-- 			return findNodeModule(name)
-- 		end)
-- 	end)
-- 	it("defaults to `jest-runner`", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({ rootDir = "/root" }, {} :: Config_Argv):expect().options
-- 			expect(options.runner).toBe(require_:resolve("jest-runner"))
-- 		end)
-- 	end)
-- 	it("resolves to runners that do not have the prefix", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options =
-- 				normalize({ rootDir = "/root/", runner = "my-runner-foo" }, {} :: Config_Argv):expect().options
-- 			expect(options.runner).toBe("node_modules/my-runner-foo")
-- 		end)
-- 	end)
-- 	it("resolves to runners and prefers jest-runner-`name`", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({ rootDir = "/root/", runner = "eslint" }, {} :: Config_Argv):expect().options
-- 			expect(options.runner).toBe("node_modules/jest-runner-eslint")
-- 		end)
-- 	end)
-- 	it("throw error when a runner is not found", function()
-- 		return Promise.resolve():andThen(function()
-- 			expect(normalize({ rootDir = "/root/", runner = "missing-runner" }, {} :: Config_Argv)).rejects
-- 				.toThrowErrorMatchingSnapshot()
-- 				:expect()
-- 		end)
-- 	end)
-- end)
-- describe("watchPlugins", function()
-- 	local Resolver
-- 	beforeEach(function()
-- 		Resolver = require_("jest-resolve").default
-- 		Resolver.findNodeModule = jest.fn(function(name)
-- 			if
-- 				Boolean.toJSBoolean(Array.includes({ "typeahead", "jest-watch-typeahead", "my-watch-plugin" }, name))
-- 			then
-- 				return ("node_modules/%s"):format(tostring(name))
-- 			end
-- 			if Boolean.toJSBoolean(name:startsWith("/root")) then
-- 				return name
-- 			end
-- 			return findNodeModule(name)
-- 		end)
-- 	end)
-- 	it("defaults to undefined", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({ rootDir = "/root" }, {} :: Config_Argv):expect().options
-- 			expect(options.watchPlugins).toEqual(nil)
-- 		end)
-- 	end)
-- 	it("resolves to watch plugins and prefers jest-watch-`name`", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options =
-- 				normalize({ rootDir = "/root/", watchPlugins = { "typeahead" } }, {} :: Config_Argv):expect().options
-- 			expect(options.watchPlugins).toEqual({
-- 				{ config = {} :: Config_Argv, path = "node_modules/jest-watch-typeahead" },
-- 			})
-- 		end)
-- 	end)
-- 	it("resolves watch plugins that do not have the prefix", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options =
-- 				normalize({ rootDir = "/root/", watchPlugins = { "my-watch-plugin" } }, {} :: Config_Argv):expect().options
-- 			expect(options.watchPlugins).toEqual({
-- 				{ config = {} :: Config_Argv, path = "node_modules/my-watch-plugin" },
-- 			})
-- 		end)
-- 	end)
-- 	it("normalizes multiple watchPlugins", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({
-- 				rootDir = "/root/",
-- 				watchPlugins = { "jest-watch-typeahead", "<rootDir>/path/to/plugin" },
-- 			}, {} :: Config_Argv):expect().options
-- 			expect(options.watchPlugins).toEqual({
-- 				{ config = {} :: Config_Argv, path = "node_modules/jest-watch-typeahead" },
-- 				{ config = {} :: Config_Argv, path = "/root/path/to/plugin" },
-- 			})
-- 		end)
-- 	end)
-- 	it("throw error when a watch plugin is not found", function()
-- 		return Promise.resolve():andThen(function()
-- 			expect(normalize({ rootDir = "/root/", watchPlugins = { "missing-plugin" } }, {} :: Config_Argv)).rejects
-- 				.toThrowErrorMatchingSnapshot()
-- 				:expect()
-- 		end)
-- 	end)
-- end)
-- ROBLOX deviation END
describe("testPathPattern", function()
	-- ROBLOX deviation START: uses pathToInstance helper function
	-- local initialOptions = { rootDir = "/root" }
	local initialOptions = { rootDir = pathToInstance("/root") }
	-- ROBLOX deviation END
	local consoleLog = console.log
	beforeEach(function()
		console.log = jest.fn()
	end)
	afterEach(function()
		console.log = consoleLog
	end)
	it("defaults to empty", function()
		return Promise.resolve():andThen(function()
			local options = normalize(initialOptions, {} :: Config_Argv):expect().options
			expect(options.testPathPattern).toBe("")
		end)
	end)
	local cliOptions = {
		{ name = "--testPathPattern", property = "testPathPattern" },
		{ name = "<regexForTestFiles>", property = "_" },
	}
	for _, opt in cliOptions do
		describe(opt.name, function()
			-- ROBLOX deviation START
			-- it("uses " .. tostring(opt.name) .. " if set", function()
			it("uses " .. opt.name .. " if set", function()
				-- ROBLOX deviation END
				return Promise.resolve():andThen(function()
					-- ROBLOX deviation START
					-- local argv = { [tostring(opt.property)] = { "a/b" } } :: Config_Argv
					local argv = { [opt.property] = { "a/b" } } :: Config_Argv
					-- ROBLOX deviation END
					local options = normalize(initialOptions, argv):expect().options
					expect(options.testPathPattern).toBe("a/b")
				end)
			end)
			it("ignores invalid regular expressions and logs a warning", function()
				return Promise.resolve():andThen(function()
					-- ROBLOX deviation START
					-- local argv = { [tostring(opt.property)] = { "a(" } } :: Config_Argv
					local argv = { [opt.property] = { "a(" } } :: Config_Argv
					-- ROBLOX deviation END
					local options = normalize(initialOptions, argv):expect().options
					expect(options.testPathPattern).toBe("")
					expect(((console.log :: unknown) :: jest_SpyInstance).mock.calls[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					][
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					]).toMatchSnapshot()
				end)
			end)
			-- ROBLOX deviation START
			-- it("joins multiple " .. tostring(opt.name) .. " if set", function()
			it("joins multiple " .. opt.name .. " if set", function()
				-- ROBLOX deviation END
				return Promise.resolve():andThen(function()
					local argv = { testPathPattern = { "a/b", "c/d" } } :: Config_Argv
					local options = normalize(initialOptions, argv):expect().options
					expect(options.testPathPattern).toBe("a/b|c/d")
				end)
			end)
			describe("posix", function()
				it("should not escape the pattern", function()
					return Promise.resolve():andThen(function()
						local argv = {
							-- ROBLOX deviation START
							-- [tostring(opt.property)] = { "a\\/b", "a/b", "a\\b", "a\\\\b" },
							[opt.property] = { "a\\/b", "a/b", "a\\b", "a\\\\b" },
							-- ROBLOX deviation END
						} :: Config_Argv
						local options = normalize(initialOptions, argv):expect().options
						expect(options.testPathPattern).toBe("a\\/b|a/b|a\\b|a\\\\b")
					end)
				end)
			end)
			-- ROBLOX deviation START: not supported
			-- describe("win32", function()
			-- 	beforeEach(function()
			-- 		jest.mock("path", function()
			-- 			return jest.requireActual("path").win32
			-- 		end)
			-- 		require_("jest-resolve").default.findNodeModule = findNodeModule
			-- 	end)
			-- 	afterEach(function()
			-- 		jest.resetModules()
			-- 	end)
			-- 	it('preserves any use of "\\"', function()
			-- 		return Promise.resolve():andThen(function()
			-- 			local argv = { [tostring(opt.property)] = { "a\\b", "c\\\\d" } }
			-- 			local options = require_("../normalize"):default(initialOptions, argv):expect().options
			-- 			expect(options.testPathPattern).toBe("a\\b|c\\\\d")
			-- 		end)
			-- 	end)
			-- 	it("replaces POSIX path separators", function()
			-- 		return Promise.resolve():andThen(function()
			-- 			local argv = { [tostring(opt.property)] = { "a/b" } }
			-- 			local options = require_("../normalize"):default(initialOptions, argv):expect().options
			-- 			expect(options.testPathPattern).toBe("a\\\\b")
			-- 		end)
			-- 	end)
			-- 	it("replaces POSIX paths in multiple args", function()
			-- 		return Promise.resolve():andThen(function()
			-- 			local argv = { [tostring(opt.property)] = { "a/b", "c/d" } }
			-- 			local options = require_("../normalize"):default(initialOptions, argv):expect().options
			-- 			expect(options.testPathPattern).toBe("a\\\\b|c\\\\d")
			-- 		end)
			-- 	end)
			-- 	it("coerces all patterns to strings", function()
			-- 		return Promise.resolve():andThen(function()
			-- 			local argv = { [tostring(opt.property)] = { 1 } } :: Config_Argv
			-- 			local options = normalize(initialOptions, argv):expect().options
			-- 			expect(options.testPathPattern).toBe("1")
			-- 		end)
			-- 	end)
			-- end)
			-- ROBLOX deviation END
		end)
	end
	it("joins multiple --testPathPatterns and <regexForTestFiles>", function()
		return Promise.resolve():andThen(function()
			local options = normalize(
				initialOptions,
				{ _ = { "a", "b" }, testPathPattern = { "c", "d" } } :: Config_Argv
			):expect().options
			expect(options.testPathPattern).toBe("a|b|c|d")
		end)
	end)
	-- ROBLOX deviation START: not supported
	-- it("gives precedence to --all", function()
	-- 	return Promise.resolve():andThen(function()
	-- 		local options =
	-- 			normalize(initialOptions, { all = true, onlyChanged = true } :: Config_Argv):expect().options
	-- 		expect(options.onlyChanged).toBe(false)
	-- 	end)
	-- end)
	-- ROBLOX deviation END
end)
-- ROBLOX deviation START: not supported
-- describe("moduleFileExtensions", function()
-- 	it("defaults to something useful", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({ rootDir = "/root" }, {} :: Config_Argv):expect().options
-- 			expect(options.moduleFileExtensions).toEqual({
-- 				"js",
-- 				"jsx",
-- 				"ts",
-- 				"tsx",
-- 				"json",
-- 				"node",
-- 			})
-- 		end)
-- 	end)
-- 	it:each({ nil, "jest-runner" })("throws if missing `js` but using jest-runner", function(runner)
-- 		return Promise.resolve():andThen(function()
-- 			expect(normalize({
-- 					moduleFileExtensions = { "json", "jsx" },
-- 					rootDir = "/root/",
-- 					runner = runner,
-- 				}, {} :: Config_Argv)).rejects
-- 				.toThrowError("moduleFileExtensions must include 'js'")
-- 				:expect()
-- 		end)
-- 	end)
-- 	it("does not throw if missing `js` with a custom runner", function()
-- 		return Promise.resolve():andThen(function()
-- 			expect(normalize({
-- 					moduleFileExtensions = { "json", "jsx" },
-- 					rootDir = "/root/",
-- 					runner = "./", -- does not need to be a valid runner for this validation
-- 				}, {} :: Config_Argv)).resolves["not"]
-- 				.toThrow()
-- 				:expect()
-- 		end)
-- 	end)
-- end)
-- describe("cwd", function()
-- 	it("is set to process.cwd", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({ rootDir = "/root/" }, {} :: Config_Argv):expect().options
-- 			expect(options.cwd).toBe(process:cwd())
-- 		end)
-- 	end)
-- 	it("is not lost if the config has its own cwd property", function()
-- 		return Promise.resolve():andThen(function()
-- 			((console.warn :: unknown) :: jest_SpyInstance):mockImplementation(function() end)
-- 			local options = normalize(
-- 				{ cwd = "/tmp/config-sets-cwd-itself", rootDir = "/root/" } :: Config_InitialOptions,
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			expect(options.cwd).toBe(process:cwd())
-- 			expect(console.warn).toHaveBeenCalled()
-- 		end)
-- 	end)
-- end)
-- ROBLOX deviation END
describe("Defaults", function()
	it("should be accepted by normalize", function()
		return Promise.resolve():andThen(function()
			-- ROBLOX deviation START
			-- normalize(Object.assign({}, Defaults, { rootDir = "/root" }), {} :: Config_Argv):expect()
			-- expect(console.warn)["not"].toHaveBeenCalled()
			normalize(Object.assign({}, Defaults, { rootDir = pathToInstance("/root") }), {} :: Config_Argv):expect()
			expect(console.warn).never.toHaveBeenCalled()
			-- ROBLOX deviation END
		end)
	end)
end)
describe("displayName", function()
	-- ROBLOX deviation START
	-- (error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: TaggedTemplateExpression ]] --[[ test.each`
	--   displayName             | description
	--   ${{}}                   | ${'is an empty object'}
	--   ${{
	--   name: 'hello'
	-- }}      | ${'missing color'}
	--   ${{
	--   color: 'green'
	-- }}     | ${'missing name'}
	--   ${{
	--   color: 2,
	--   name: []
	-- }} | ${'using invalid values'}
	-- ` ]])("should throw an error when displayName is $description", function(ref0)
	for _, ref0 in
		{
			{ displayName = {}, description = "is an empty object" } :: any,
			{ displayName = { name = "hello" }, description = "missing color" },
			{ displayName = { color = "green" }, description = "missing name" },
			{ displayName = { color = 2, name = {} }, description = "using invalid values" },
		}
	do
		it("should throw an error when displayName is " .. ref0.description, function()
			-- ROBLOX deviation END
			local displayName = ref0.displayName
			return Promise.resolve():andThen(function()
				-- ROBLOX deviation START: uses pathToInstance helper function
				-- expect(normalize({ displayName = displayName, rootDir = "/root/" }, {} :: Config_Argv)).rejects
				expect(normalize({ displayName = displayName, rootDir = pathToInstance("/root/") }, {} :: Config_Argv))
					.rejects
					-- ROBLOX deviation END
					.toThrowErrorMatchingSnapshot()
					:expect()
			end)
		end)
		-- ROBLOX deviation START: add end for the for loop
	end
	-- ROBLOX deviation END
	-- ROBLOX deviation START: not supported
	-- it:each({ nil, "jest-runner", "jest-runner-eslint", "jest-runner-tslint", "jest-runner-tsc" })(
	-- 	"generates a default color for the runner %s",
	-- 	function(runner)
	-- 		return Promise.resolve():andThen(function()
	-- 			table.insert(
	-- 				virtualModuleRegexes,
	-- 				error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /jest-runner-.+/ ]]
	-- 			) --[[ ROBLOX CHECK: check if 'virtualModuleRegexes' is an Array ]]
	-- 			local displayName = normalize(
	-- 				{ displayName = "project", rootDir = "/root/", runner = runner },
	-- 				{} :: Config_Argv
	-- 			):expect().options.displayName
	-- 			expect((displayName :: any).name).toBe("project")
	-- 			expect((displayName :: any).color).toMatchSnapshot()
	-- 		end)
	-- 	end
	-- )
	-- ROBLOX deviation END
end)
describe("testTimeout", function()
	it("should return timeout value if defined", function()
		return Promise.resolve():andThen(function()
			((console.warn :: unknown) :: jest_SpyInstance):mockImplementation(function() end)
			-- ROBLOX deviation START: uses pathToInstance helper function
			-- local options = normalize({ rootDir = "/root/", testTimeout = 1000 }, {} :: Config_Argv):expect().options
			local options =
				normalize({ rootDir = pathToInstance("/root/"), testTimeout = 1000 }, {} :: Config_Argv):expect().options
			-- ROBLOX deviation END
			expect(options.testTimeout).toBe(1000)
			-- ROBLOX deviation START
			-- expect(console.warn)["not"].toHaveBeenCalled()
			expect(console.warn).never.toHaveBeenCalled()
			-- ROBLOX deviation END
		end)
	end)
	it("should throw an error if timeout is a negative number", function()
		return Promise.resolve():andThen(function()
			-- ROBLOX deviation START: uses pathToInstance helper function
			-- expect(normalize({ rootDir = "/root/", testTimeout = -1 }, {} :: Config_Argv)).rejects
			expect(normalize({ rootDir = pathToInstance("/root/"), testTimeout = -1 }, {} :: Config_Argv))
				.rejects
				-- ROBLOX deviation END
				.toThrowErrorMatchingSnapshot()
				:expect()
		end)
	end)
end)
-- ROBLOX deviation START: not supported
-- describe("extensionsToTreatAsEsm", function()
-- 	local function matchErrorSnapshot(
-- 		callback: {
-- 			__unhandledIdentifier__: nil, --[[ ROBLOX TODO: Unhandled node for type: TSCallSignatureDeclaration ]] --[[ (): Promise<{
--       hasDeprecationWarnings: boolean;
--       options: Config.ProjectConfig & Config.GlobalConfig;
--     }>; ]]
-- 			__unhandledIdentifier__: nil, --[[ ROBLOX TODO: Unhandled node for type: TSCallSignatureDeclaration ]] --[[ (): Promise<{
--       hasDeprecationWarnings: boolean;
--       options: Config.ProjectConfig & Config.GlobalConfig;
--     }>; ]]
-- 			__unhandledIdentifier__: nil, --[[ ROBLOX TODO: Unhandled node for type: TSCallSignatureDeclaration ]] --[[ (): any; ]]
-- 		}
-- 	)
-- 		return Promise.resolve():andThen(function()
-- 			expect.assertions(1)
-- 			do --[[ ROBLOX COMMENT: try-catch block conversion ]]
-- 				local ok, result, hasReturned = xpcall(function()
-- 					callback():expect()
-- 				end, function(error_)
-- 					expect(wrap(stripAnsi(error_.message):trim())).toMatchSnapshot()
-- 				end)
-- 				if hasReturned then
-- 					return result
-- 				end
-- 			end
-- 		end)
-- 	end
-- 	it("should pass valid config through", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options =
-- 				normalize({ extensionsToTreatAsEsm = { ".ts" }, rootDir = "/root/" }, {} :: Config_Argv):expect().options
-- 			expect(options.extensionsToTreatAsEsm).toEqual({ ".ts" })
-- 		end)
-- 	end)
-- 	it("should enforce leading dots", function()
-- 		return Promise.resolve():andThen(function()
-- 			matchErrorSnapshot(function()
-- 				return Promise.resolve():andThen(function()
-- 					return normalize({ extensionsToTreatAsEsm = { "ts" }, rootDir = "/root/" }, {} :: Config_Argv)
-- 				end)
-- 			end):expect()
-- 		end)
-- 	end)
-- 	it:each({ ".js", ".mjs", ".cjs" })("throws on %s", function(ext)
-- 		return Promise.resolve():andThen(function()
-- 			matchErrorSnapshot(function()
-- 				return Promise.resolve():andThen(function()
-- 					return normalize({ extensionsToTreatAsEsm = { ext }, rootDir = "/root/" }, {} :: Config_Argv)
-- 				end)
-- 			end):expect()
-- 		end)
-- 	end)
-- end)
-- describe("haste.enableSymlinks", function()
-- 	it("should throw if watchman is not disabled", function()
-- 		return Promise.resolve():andThen(function()
-- 			expect(normalize({ haste = { enableSymlinks = true }, rootDir = "/root/" }, {})).rejects
-- 				.toThrow("haste.enableSymlinks is incompatible with watchman")
-- 				:expect()
-- 			expect(normalize({ haste = { enableSymlinks = true }, rootDir = "/root/", watchman = true }, {})).rejects
-- 				.toThrow("haste.enableSymlinks is incompatible with watchman")
-- 				:expect()
-- 			local options =
-- 				normalize({ haste = { enableSymlinks = true }, rootDir = "/root/", watchman = false }, {}):expect().options
-- 			expect(options.haste.enableSymlinks).toBe(true)
-- 			expect(options.watchman).toBe(false)
-- 		end)
-- 	end)
-- end)
-- describe("haste.forceNodeFilesystemAPI", function()
-- 	it("should pass option through", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options =
-- 				normalize({ haste = { forceNodeFilesystemAPI = true }, rootDir = "/root/" }, {}):expect().options
-- 			expect(options.haste.forceNodeFilesystemAPI).toBe(true)
-- 			expect(console.warn)["not"].toHaveBeenCalled()
-- 		end)
-- 	end)
-- end)
-- ROBLOX deviation END
