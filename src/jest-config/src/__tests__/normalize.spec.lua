-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-config/src/__tests__/normalize.test.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]

type unknown = any --[[ ROBLOX FIXME: adding `unknown` type alias to make it easier to use Luau unknown equivalent when supported ]]
local Packages = script.Parent.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local String = LuauPolyfill.String
local console = LuauPolyfill.console
type Array<T> = LuauPolyfill.Array<T>
type Object = LuauPolyfill.Object
local Promise = require(Packages.Promise)
local RegExp = require(Packages.RegExp)
type RegExp = RegExp.RegExp

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local jestExpect = JestGlobals.expect
local describe = (JestGlobals.describe :: any) :: Function
local it = (JestGlobals.it :: any) :: Function
local beforeEach = (JestGlobals.beforeEach :: any) :: Function
local afterEach = (JestGlobals.afterEach :: any) :: Function
type jest_SpyInstance = any

-- ROBLOX deviation START: not used
-- local createHash = require(Packages.crypto).createHash
-- local path = require(Packages.path).default
-- local wrap = require(Packages.Dev.JestSnapshotSerializerRaw).wrap
-- local semver = require(Packages.semver)
-- local stripAnsi = require(Packages["strip-ansi"]).default
-- ROBLOX deviation END
local typesModule = require(Packages.JestTypes)
type Config_Argv = typesModule.Config_Argv
type Config_InitialOptions = typesModule.Config_InitialOptions
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

-- ROBLOX deviation START: helper functions
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
local RobloxShared = require(Packages.RobloxShared)
local JSON = RobloxShared.nodeUtils.JSON
local getRelativePath = RobloxShared.getRelativePath
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
local virtualModuleRegexes: Array<RegExp>

beforeEach(function()
	virtualModuleRegexes = {
		RegExp("jest-circus"),
		RegExp("babel-jest"),
	}
	return virtualModuleRegexes
end)

-- ROBLOX deviation START: not used
-- local findNodeModule = jest.fn(function(name)
-- 	if Array.some(virtualModuleRegexes, function(regex)
-- 		return regex:test(name)
-- 	end) then
-- 		return name
-- 	end
-- 	return nil
-- end)

-- -- Windows uses backslashes for path separators, which need to be escaped in
-- -- regular expressions. This little helper function helps us generate the
-- -- expected strings for checking path patterns.
-- local function joinForPattern(...: string)
-- 	local args = { ... }
-- 	return Array.join(args, escapeStrForRegex(path.sep))
-- end
-- ROBLOX deviation END

local originalWarn = console.warn

beforeEach(function()
	-- ROBLOX deviation START: not used
	-- 	root = path:resolve("/")
	-- 	expectedPathFooBar = Array.join(path, root, "root", "path", "foo", "bar", "baz") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 	expectedPathFooQux = Array.join(path, root, "root", "path", "foo", "qux", "quux") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- ROBLOX deviation END
	-- ROBLOX deviation START: hardcode path
	expectedPathAbs = "/an/abs/path"
	expectedPathAbsAnother = "/another/abs/path"
	-- ROBLOX deviation END
	-- ROBLOX deviation START: not used
	-- 	require_("jest-resolve").default.findNodeModule = findNodeModule
	-- ROBLOX deviation END
	-- ROBLOX deviation START: jest.spyOn not available
	--	jest.spyOn(console, "warn")
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
		jestExpect(function()
			normalize({ rootDir = "rootDir" :: any }, {} :: Config_Argv):expect()
		end).toThrowErrorMatchingSnapshot()
	end)

	it("throws error when rootDir is table", function()
		jestExpect(function()
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
	return Promise.resolve()
		:andThen(function()
			local rootDir = pathToInstance("/root/path/foo")
			-- ROBLOX deviation START: createHash not available
			local expected = "/root/path/foo"
			-- local expected = createHash("md5"):update("/root/path/foo"):update(tostring(math.huge)):digest("hex")
			-- ROBLOX deviation END
			local options = normalize({ rootDir = rootDir }, {} :: Config_Argv):expect().options
			jestExpect(options.name).toBe(expected)
		end)
		:expect()
end)

it("keeps custom project name based on the projects rootDir", function()
	return Promise.resolve()
		:andThen(function()
			local name = "test"
			local options = normalize({
				projects = { { name = name, rootDir = pathToInstance("/path/to/foo") } :: any },
				rootDir = pathToInstance("/root/path/baz"),
			}, {} :: Config_Argv):expect().options
			jestExpect((options.projects[1] :: any).name).toBe(name)
		end)
		:expect()
end)

it("keeps custom names based on the rootDir", function()
	return Promise.resolve()
		:andThen(function()
			local options = normalize(
				{ name = "custom-name", rootDir = pathToInstance("/root/path/foo") },
				{} :: Config_Argv
			):expect().options
			jestExpect(options.name).toBe("custom-name")
		end)
		:expect()
end)

it("minimal config is stable across runs", function()
	return Promise.resolve()
		:andThen(function()
			local rootDir = pathToInstance("/root/path/foo")
			local firstNormalization = normalize({ rootDir = rootDir }, {} :: Config_Argv):expect()
			local secondNormalization = normalize({ rootDir = rootDir }, {} :: Config_Argv):expect()
			jestExpect(firstNormalization).toEqual(secondNormalization)
			jestExpect(JSON.stringify(firstNormalization)).toBe(JSON.stringify(secondNormalization))
		end)
		:expect()
end)

-- ROBLOX deviation START: not supported
-- it("sets coverageReporters correctly when argv.json is set", function()
-- 	return Promise.resolve():andThen(function()
-- 		local options = normalize({ rootDir = pathToInstance("/root/path/foo") }, { json = true } :: Config_Argv):expect().options
-- 		jestExpect(options.coverageReporters).toEqual({ "json", "lcov", "clover" })
-- 	end)
-- end)
-- ROBLOX deviation END

describe("rootDir", function()
	it("throws if the options is missing a rootDir property", function()
		return Promise.resolve()
			:andThen(function()
				-- ROBLOX deviation START: no .rejects and .assertions
				-- expect:assertions(1)
				jestExpect(function()
					normalize({}, {} :: Config_Argv):expect()
				end).toThrowErrorMatchingSnapshot()
				-- ROBLOX deviation END
			end)
			:expect()
	end)
end)

describe("automock", function()
	it("falsy automock is not overwritten", function()
		return Promise.resolve()
			:andThen(function()
				((console.warn :: unknown) :: jest_SpyInstance):mockImplementation(function() end)
				local options = normalize(
					{ automock = false, rootDir = pathToInstance("/root/path/foo") },
					{} :: Config_Argv
				):expect().options
				jestExpect(options.automock).toBe(false)
			end)
			:expect()
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
-- 			jestExpect(options.collectCoverageOnlyFrom).toEqual(expected)
-- 		end)
-- 	end)
-- 	it("does not change absolute paths", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({
-- 				collectCoverageOnlyFrom = { ["/an/abs/path"] = true, ["/another/abs/path"] = true },
-- 				rootDir = "/root/path/foo",
-- 			}, {} :: Config_Argv):expect().options
-- 			local expected = Object.create(nil)
-- 			expected[tostring(expectedPathAbs)] = true
-- 			expected[tostring(expectedPathAbsAnother)] = true
-- 			jestExpect(options.collectCoverageOnlyFrom).toEqual(expected)
-- 		end)
-- 	end)
-- 	it("substitutes <rootDir> tokens", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize(
-- 				{ collectCoverageOnlyFrom = { ["<rootDir>/bar/baz"] = true }, rootDir = "/root/path/foo" },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			local expected = Object.create(nil)
-- 			expected[tostring(expectedPathFooBar)] = true
-- 			jestExpect(options.collectCoverageOnlyFrom).toEqual(expected)
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
-- 			jestExpect(options.collectCoverageFrom).toEqual(expected)
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
-- 			jestExpect(options.collectCoverageFrom).toEqual(expected)
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
	-- 		jestExpect(options[tostring(key)]).toEqual({ expectedPathFooBar, expectedPathFooQux })
	-- 	end)
	-- end)
	-- ROBLOX deviation END

	it("does not change absolute paths", function()
		return Promise.resolve():andThen(function()
			local options = normalize({
				[key] = { pathToInstance("/an/abs/path"), pathToInstance("/another/abs/path") },
				rootDir = pathToInstance("/root/path/foo"),
			} :: any, {} :: Config_Argv):expect().options
			jestExpect(Array.map((options :: Object)[key], function(path)
				return getRelativePath(path, nil)
			end)).toEqual({
				expectedPathAbs,
				expectedPathAbsAnother,
			})
		end)
	end)

	-- ROBLOX deviation START: not supported
	-- 	it("substitutes <rootDir> tokens", function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local options = normalize(
	-- 				{ [tostring(key)] = { "<rootDir>/bar/baz" }, rootDir = "/root/path/foo" },
	-- 				{} :: Config_Argv
	-- 			):expect().options
	-- 			jestExpect(options[tostring(key)]).toEqual({ expectedPathFooBar })
	-- 		end)
	-- 	end)
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
-- 			jestExpect(options.transform).toEqual({
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
-- 			jestExpect(options.transform).toEqual({
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
-- 			jestExpect(options.haste).toEqual({ hasteImplModulePath = "/root/haste_impl.js" })
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
-- 			jestExpect(options.setupFilesAfterEnv).toEqual({ expectedPathFooBar })
-- 		end)
-- 	end)
-- 	it("does not change absolute paths", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize(
-- 				{ rootDir = "/root/path/foo", setupFilesAfterEnv = { "/an/abs/path" } },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.setupFilesAfterEnv).toEqual({ expectedPathAbs })
-- 		end)
-- 	end)
-- 	it("substitutes <rootDir> tokens", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize(
-- 				{ rootDir = "/root/path/foo", setupFilesAfterEnv = { "<rootDir>/bar/baz" } },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.setupFilesAfterEnv).toEqual({ expectedPathFooBar })
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
-- 			jestExpect(((console.warn :: unknown) :: jest_SpyInstance).mock.calls[1][1]).toMatchSnapshot()
-- 		end)
-- 	end)
-- 	it("logs an error when `setupTestFrameworkScriptFile` and `setupFilesAfterEnv` are used", function()
-- 		return Promise.resolve():andThen(function()
-- 			jestExpect(normalize({
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
-- 			local options = normalize(
-- 				{ coveragePathIgnorePatterns = { "bar/baz", "qux/quux" }, rootDir = "/root/path/foo" },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.coveragePathIgnorePatterns).toEqual({
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
-- 				{ coveragePathIgnorePatterns = { "bar/baz", "qux/quux/" }, rootDir = "/root/path/foo" },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.coveragePathIgnorePatterns).toEqual({
-- 				joinForPattern("bar", "baz"),
-- 				joinForPattern("qux", "quux", ""),
-- 			})
-- 		end)
-- 	end)
-- 	it("substitutes <rootDir> tokens", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize(
-- 				{ coveragePathIgnorePatterns = { "hasNoToken", "<rootDir>/hasAToken" }, rootDir = "/root/path/foo" },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.coveragePathIgnorePatterns).toEqual({
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
-- 			jestExpect(options.watchPathIgnorePatterns).toEqual({
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
-- 			jestExpect(options.watchPathIgnorePatterns).toEqual({
-- 				joinForPattern("bar", "baz"),
-- 				joinForPattern("qux", "quux", ""),
-- 			})
-- 		end)
-- 	end)
-- 	it("substitutes <rootDir> tokens", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize(
-- 				{ rootDir = "/root/path/foo", watchPathIgnorePatterns = { "hasNoToken", "<rootDir>/hasAToken" } },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.watchPathIgnorePatterns).toEqual({
-- 				"hasNoToken",
-- 				joinForPattern("", "root", "path", "foo", "hasAToken"),
-- 			})
-- 		end)
-- 	end)
-- end)
-- describe("testPathIgnorePatterns", function()
-- 	it("does not normalize paths relative to rootDir", function()
-- 		return Promise.resolve():andThen(function()
-- 			-- This is a list of patterns, so we can't assume any of them are
-- 			-- directories
-- 			local options = normalize(
-- 				{ rootDir = "/root/path/foo", testPathIgnorePatterns = { "bar/baz", "qux/quux" } },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.testPathIgnorePatterns).toEqual({
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
-- 				{ rootDir = "/root/path/foo", testPathIgnorePatterns = { "bar/baz", "qux/quux/" } },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.testPathIgnorePatterns).toEqual({
-- 				joinForPattern("bar", "baz"),
-- 				joinForPattern("qux", "quux", ""),
-- 			})
-- 		end)
-- 	end)
-- 	it("substitutes <rootDir> tokens", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize(
-- 				{ rootDir = "/root/path/foo", testPathIgnorePatterns = { "hasNoToken", "<rootDir>/hasAToken" } },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.testPathIgnorePatterns).toEqual({
-- 				"hasNoToken",
-- 				joinForPattern("", "root", "path", "foo", "hasAToken"),
-- 			})
-- 		end)
-- 	end)
-- end)
-- describe("modulePathIgnorePatterns", function()
-- 	it("does not normalize paths relative to rootDir", function()
-- 		return Promise.resolve():andThen(function()
-- 			-- This is a list of patterns, so we can't assume any of them are
-- 			-- directories
-- 			local options = normalize(
-- 				{ modulePathIgnorePatterns = { "bar/baz", "qux/quux" }, rootDir = "/root/path/foo" },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.modulePathIgnorePatterns).toEqual({
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
-- 				{ modulePathIgnorePatterns = { "bar/baz", "qux/quux/" }, rootDir = "/root/path/foo" },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.modulePathIgnorePatterns).toEqual({
-- 				joinForPattern("bar", "baz"),
-- 				joinForPattern("qux", "quux", ""),
-- 			})
-- 		end)
-- 	end)
-- 	it("substitutes <rootDir> tokens", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize(
-- 				{ modulePathIgnorePatterns = { "hasNoToken", "<rootDir>/hasAToken" }, rootDir = "/root/path/foo" },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.modulePathIgnorePatterns).toEqual({
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
-- 			jestExpect(options.testRunner).toMatch("jest-circus")
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
-- 			jestExpect(options.testRunner).toMatch("jest-jasmine2")
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
-- 			jestExpect(options.testRunner).toBe("mocha")
-- 		end)
-- 	end)
-- end)
-- describe("coverageDirectory", function()
-- 	it("defaults to <rootDir>/coverage", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({ rootDir = "/root/path/foo" }, {} :: Config_Argv):expect().options
-- 			jestExpect(options.coverageDirectory).toBe("/root/path/foo/coverage")
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
-- 			jestExpect(options.testEnvironment).toEqual("node_modules/jest-environment-jsdom")
-- 		end)
-- 	end)
-- 	it("resolves to node environment by default", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({ rootDir = "/root" }, {} :: Config_Argv):expect().options
-- 			jestExpect(options.testEnvironment).toEqual(require_:resolve("jest-environment-node"))
-- 		end)
-- 	end)
-- 	it("throws on invalid environment names", function()
-- 		return Promise.resolve():andThen(function()
-- 			jestExpect(normalize({ rootDir = "/root", testEnvironment = "phantom" }, {} :: Config_Argv)).rejects
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
-- 			jestExpect(options.testEnvironment).toEqual("/root/testEnvironment.js")
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
-- 			jestExpect(options.transform[1][1]).toBe(DEFAULT_JS_PATTERN)
-- 			jestExpect(options.transform[1][2]).toEqual(require_:resolve("babel-jest"))
-- 		end)
-- 	end)
-- 	it("uses babel-jest if babel-jest is explicitly specified in a custom transform options", function()
-- 		return Promise.resolve():andThen(function()
-- 			local customJSPattern = "\\.js$"
-- 			local options = normalize(
-- 				{ rootDir = "/root", transform = { [tostring(customJSPattern)] = "babel-jest" } },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.transform[1][1]).toBe(customJSPattern)
-- 			jestExpect(options.transform[1][2]).toEqual(require_:resolve("babel-jest"))
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
-- 			jestExpect(options.transform).toEqual({ { ".*", "/node_modules/bar/baz", {} } })
-- 			jestExpect(options.transformIgnorePatterns).toEqual({
-- 				joinForPattern("bar", "baz"),
-- 				joinForPattern("qux", "quux"),
-- 			})
-- 			jestExpect(options)["not"].toHaveProperty("scriptPreprocessor")
-- 			jestExpect(options)["not"].toHaveProperty("preprocessorIgnorePatterns")
-- 			jestExpect(hasDeprecationWarnings).toBeTruthy()
-- 			jestExpect(((console.warn :: unknown) :: jest_SpyInstance).mock.calls[1][1]).toMatchSnapshot()
-- 		end)
-- 	end)
-- end)
-- ROBLOX deviation END

describe("testRegex", function()
	it("testRegex empty string is mapped to empty array", function()
		return Promise.resolve()
			:andThen(function()
				local options =
					normalize({ rootDir = pathToInstance("/root"), testRegex = "" }, {} :: Config_Argv):expect().options
				jestExpect(options.testRegex).toEqual({})
			end)
			:expect()
	end)

	it("testRegex string is mapped to an array", function()
		return Promise.resolve()
			:andThen(function()
				local options =
					normalize(
						{ rootDir = pathToInstance("/root"), testRegex = ".*" },
						{} :: Config_Argv
					):expect().options
				jestExpect(options.testRegex).toEqual({ ".*" })
			end)
			:expect()
	end)

	it("testRegex array is preserved", function()
		return Promise.resolve()
			:andThen(function()
				local options = normalize(
					{ rootDir = pathToInstance("/root"), testRegex = { ".*", "foo\\.bar" } },
					{} :: Config_Argv
				):expect().options
				jestExpect(options.testRegex).toEqual({ ".*", "foo\\.bar" })
			end)
			:expect()
	end)
end)

describe("testMatch", function()
	it("testMatch default not applied if testRegex is set", function()
		return Promise.resolve()
			:andThen(function()
				local options =
					normalize(
						{ rootDir = pathToInstance("/root"), testRegex = ".*" },
						{} :: Config_Argv
					):expect().options
				jestExpect(#options.testMatch).toBe(0)
			end)
			:expect()
	end)

	it("testRegex default not applied if testMatch is set", function()
		return Promise.resolve()
			:andThen(function()
				local options = normalize(
					{ rootDir = pathToInstance("/root"), testMatch = { "**/*.js" } },
					{} :: Config_Argv
				):expect().options
				jestExpect(options.testRegex).toEqual({})
			end)
			:expect()
	end)

	it("throws if testRegex and testMatch are both specified", function()
		return Promise.resolve()
			:andThen(function()
				-- ROBLOX deviation START: no .rejects
				jestExpect(function()
					normalize(
						{ rootDir = pathToInstance("/root"), testMatch = { "**/*.js" }, testRegex = ".*" },
						{} :: Config_Argv
					):expect()
				end).toThrowErrorMatchingSnapshot()
				-- ROBLOX deviation END
			end)
			:expect()
	end)

	-- ROBLOX deviation START: not supported
	-- it("normalizes testMatch", function()
	-- 	return Promise.resolve():andThen(function()
	-- 		local options =
	-- 			normalize({ rootDir = pathToInstance("/root"), testMatch = { "<rootDir>/**/*.js" } }, {} :: Config_Argv):expect().options
	-- 		jestExpect(options.testMatch).toEqual({ "/root/**/*.js" })
	-- 	end):expect()
	-- end)
	-- ROBLOX deviation END
end)

-- ROBLOX deviation START: not supported
-- describe("moduleDirectories", function()
-- 	it("defaults to node_modules", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({ rootDir = "/root" }, {} :: Config_Argv):expect().options
-- 			jestExpect(options.moduleDirectories).toEqual({ "node_modules" })
-- 		end)
-- 	end)
-- 	it("normalizes moduleDirectories", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize(
-- 				{ moduleDirectories = { "<rootDir>/src", "<rootDir>/node_modules" }, rootDir = "/root" },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.moduleDirectories).toEqual({ "/root/src", "/root/node_modules" })
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
-- 			jestExpect(normalize({ preset = "doesnt-exist", rootDir = "/root/path/foo" }, {} :: Config_Argv)).rejects
-- 				.toThrowErrorMatchingSnapshot()
-- 				:expect()
-- 		end)
-- 	end)
-- 	test('throws when module was found but no "jest-preset.js" or "jest-preset.json" files', function()
-- 		return Promise.resolve():andThen(function()
-- 			jestExpect(normalize({ preset = "exist-but-no-jest-preset", rootDir = "/root/path/foo" }, {} :: Config_Argv)).rejects
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
-- 			jestExpect(normalize({ preset = "react-native-js-preset", rootDir = "/root/path/foo" }, {} :: Config_Argv)).rejects
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
-- 			jestExpect(normalize({ preset = "react-native", rootDir = "/root/path/foo" }, {} :: Config_Argv)).rejects
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
-- 			jestExpect(normalize({ preset = "react-native-js-preset", rootDir = "/root/path/foo" }, {} :: Config_Argv)).rejects
-- 				.toThrowError(errorMessage)
-- 				:expect()
-- 		end)
-- 	end)
-- 	test('works with "react-native"', function()
-- 		return Promise.resolve():andThen(function()
-- 			jestExpect(normalize({ preset = "react-native", rootDir = "/root/path/foo" }, {} :: Config_Argv)).resolves["not"]
-- 				.toThrow()
-- 				:expect()
-- 		end)
-- 	end)
-- 	test:each({ "react-native-js-preset", "cjs-preset" })("works with cjs preset", function(presetName)
-- 		return Promise.resolve():andThen(function()
-- 			jestExpect(normalize({ preset = presetName, rootDir = "/root/path/foo" }, {} :: Config_Argv)).resolves["not"]
-- 				.toThrow()
-- 				:expect()
-- 		end)
-- 	end)
-- 	test("works with esm preset", function()
-- 		return Promise.resolve():andThen(function()
-- 			jestExpect(normalize({ preset = "mjs-preset", rootDir = "/root/path/foo" }, {} :: Config_Argv)).resolves["not"]
-- 				.toThrow()
-- 				:expect()
-- 		end)
-- 	end)
-- 	test("searches for .json, .js, .cjs, .mjs preset files", function()
-- 		return Promise.resolve():andThen(function()
-- 			local Resolver = require_("jest-resolve").default
-- 			normalize({ preset = "react-native", rootDir = "/root/path/foo" }, {} :: Config_Argv):expect()
-- 			local options = Resolver.findNodeModule.mock.calls[1][2]
-- 			jestExpect(options.extensions).toEqual({ ".json", ".js", ".cjs", ".mjs" })
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
-- 			jestExpect(options.moduleNameMapper).toEqual({ { "a", "a" }, { "b", "b" } })
-- 			jestExpect(options.modulePathIgnorePatterns).toEqual({ "b", "a" })
-- 			jestExpect(
-- 				Array.sort(options.setupFiles) --[[ ROBLOX CHECK: check if 'options.setupFiles' is an Array ]]
-- 			).toEqual({ "/node_modules/a", "/node_modules/b" })
-- 			jestExpect(
-- 				Array.sort(options.setupFilesAfterEnv) --[[ ROBLOX CHECK: check if 'options.setupFilesAfterEnv' is an Array ]]
-- 			).toEqual({ "/node_modules/a", "/node_modules/b" })
-- 			jestExpect(options.transform).toEqual({
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
-- 			local options = normalize(
-- 				{ moduleNameMapper = moduleNameMapper, preset = "react-native", rootDir = "/root/path/foo" },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.moduleNameMapper).toEqual({
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
-- 			jestExpect(options.transform).toEqual({
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
-- 			jestExpect(options.setupFilesAfterEnv).toEqual({ "/node_modules/b" })
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
-- 			jestExpect(options.globals).toEqual({
-- 				__DEV__ = true,
-- 				config = { hereToStay = "This should stay here", sideBySide = "This should also live another day" },
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
-- 			local options = normalize(
-- 				{ [tostring(configKey)] = { "a" }, preset = "react-foo", rootDir = "/root/path/foo" },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options).toEqual(expect:objectContaining({ [tostring(configKey)] = { "/node_modules/a" } }))
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
-- 			jestExpect(options.runner).toBe(require_:resolve("jest-runner"))
-- 		end)
-- 	end)
-- 	it("resolves to runners that do not have the prefix", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options =
-- 				normalize({ rootDir = "/root/", runner = "my-runner-foo" }, {} :: Config_Argv):expect().options
-- 			jestExpect(options.runner).toBe("node_modules/my-runner-foo")
-- 		end)
-- 	end)
-- 	it("resolves to runners and prefers jest-runner-`name`", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({ rootDir = "/root/", runner = "eslint" }, {} :: Config_Argv):expect().options
-- 			jestExpect(options.runner).toBe("node_modules/jest-runner-eslint")
-- 		end)
-- 	end)
-- 	it("throw error when a runner is not found", function()
-- 		return Promise.resolve():andThen(function()
-- 			jestExpect(normalize({ rootDir = "/root/", runner = "missing-runner" }, {} :: Config_Argv)).rejects
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
-- 				Boolean.toJSBoolean(
-- 					Array.includes({ "typeahead", "jest-watch-typeahead", "my-watch-plugin" }, name)
-- 				)
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
-- 			jestExpect(options.watchPlugins).toEqual(nil)
-- 		end)
-- 	end)
-- 	it("resolves to watch plugins and prefers jest-watch-`name`", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options =
-- 				normalize({ rootDir = "/root/", watchPlugins = { "typeahead" } }, {} :: Config_Argv):expect().options
-- 			jestExpect(options.watchPlugins).toEqual({
-- 				{ config = {} :: Config_Argv, path = "node_modules/jest-watch-typeahead" },
-- 			})
-- 		end)
-- 	end)
-- 	it("resolves watch plugins that do not have the prefix", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize(
-- 				{ rootDir = "/root/", watchPlugins = { "my-watch-plugin" } },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.watchPlugins).toEqual({
-- 				{ config = {} :: Config_Argv, path = "node_modules/my-watch-plugin" },
-- 			})
-- 		end)
-- 	end)
-- 	it("normalizes multiple watchPlugins", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize(
-- 				{ rootDir = "/root/", watchPlugins = { "jest-watch-typeahead", "<rootDir>/path/to/plugin" } },
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.watchPlugins).toEqual({
-- 				{ config = {} :: Config_Argv, path = "node_modules/jest-watch-typeahead" },
-- 				{ config = {} :: Config_Argv, path = "/root/path/to/plugin" },
-- 			})
-- 		end)
-- 	end)
-- 	it("throw error when a watch plugin is not found", function()
-- 		return Promise.resolve():andThen(function()
-- 			jestExpect(normalize({ rootDir = "/root/", watchPlugins = { "missing-plugin" } }, {} :: Config_Argv)).rejects
-- 				.toThrowErrorMatchingSnapshot()
-- 				:expect()
-- 		end)
-- 	end)
-- end)
-- ROBLOX deviation END

describe("testPathPattern", function()
	local initialOptions = { rootDir = pathToInstance("/root") }
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
			jestExpect(options.testPathPattern).toBe("")
		end)
	end)

	local cliOptions = {
		{ name = "--testPathPattern", property = "testPathPattern" },
		{ name = "<regexForTestFiles>", property = "_" },
	}
	for _, opt in cliOptions do
		describe(opt.name, function()
			it("uses " .. opt.name .. " if set", function()
				return Promise.resolve()
					:andThen(function()
						local argv = { [opt.property] = { "a/b" } } :: Config_Argv
						local options = normalize(initialOptions, argv):expect().options
						jestExpect(options.testPathPattern).toBe("a/b")
					end)
					:expect()
			end)

			it("ignores invalid regular expressions and logs a warning", function()
				return Promise.resolve()
					:andThen(function()
						local argv = { [opt.property] = { "a(" } } :: Config_Argv
						local options = normalize(initialOptions, argv):expect().options
						jestExpect(options.testPathPattern).toBe("")
						jestExpect(((console.log :: unknown) :: jest_SpyInstance).mock.calls[1][1]).toMatchSnapshot()
					end)
					:expect()
			end)

			it("joins multiple " .. opt.name .. " if set", function()
				return Promise.resolve()
					:andThen(function()
						local argv = { testPathPattern = { "a/b", "c/d" } } :: Config_Argv
						local options = normalize(initialOptions, argv):expect().options
						jestExpect(options.testPathPattern).toBe("a/b|c/d")
					end)
					:expect()
			end)

			describe("posix", function()
				it("should not escape the pattern", function()
					return Promise.resolve()
						:andThen(function()
							local argv = { [opt.property] = { "a\\/b", "a/b", "a\\b", "a\\\\b" } } :: Config_Argv
							local options = normalize(initialOptions, argv):expect().options
							jestExpect(options.testPathPattern).toBe("a\\/b|a/b|a\\b|a\\\\b")
						end)
						:expect()
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
			-- 			jestExpect(options.testPathPattern).toBe("a\\b|c\\\\d")
			-- 		end)
			-- 	end)
			-- 	it("replaces POSIX path separators", function()
			-- 		return Promise.resolve():andThen(function()
			-- 			local argv = { [tostring(opt.property)] = { "a/b" } }
			-- 			local options = require_("../normalize"):default(initialOptions, argv):expect().options
			-- 			jestExpect(options.testPathPattern).toBe("a\\\\b")
			-- 		end)
			-- 	end)
			-- 	it("replaces POSIX paths in multiple args", function()
			-- 		return Promise.resolve():andThen(function()
			-- 			local argv = { [tostring(opt.property)] = { "a/b", "c/d" } }
			-- 			local options = require_("../normalize"):default(initialOptions, argv):expect().options
			-- 			jestExpect(options.testPathPattern).toBe("a\\\\b|c\\\\d")
			-- 		end)
			-- 	end)
			-- 	it("coerces all patterns to strings", function()
			-- 		return Promise.resolve():andThen(function()
			-- 			local argv = { [tostring(opt.property)] = { 1 } } :: Config_Argv
			-- 			local options = normalize(initialOptions, argv):expect().options
			-- 			jestExpect(options.testPathPattern).toBe("1")
			-- 		end)
			-- 	end)
			-- end)
			-- ROBLOX deviation END
		end)
	end

	it("joins multiple --testPathPatterns and <regexForTestFiles>", function()
		return Promise.resolve()
			:andThen(function()
				local options = normalize(
					initialOptions,
					{ _ = { "a", "b" }, testPathPattern = { "c", "d" } } :: Config_Argv
				):expect().options
				jestExpect(options.testPathPattern).toBe("a|b|c|d")
			end)
			:expect()
	end)

	-- ROBLOX deviation START: not supported
	-- it("gives precedence to --all", function()
	-- 	return Promise.resolve():andThen(function()
	-- 		local options =
	-- 			normalize(initialOptions, { all = true, onlyChanged = true } :: Config_Argv):expect().options
	-- 		jestExpect(options.onlyChanged).toBe(false)
	-- 	end):expect()
	-- end)
	-- ROBLOX deviation END
end)

-- ROBLOX deviation START: not supported
-- describe("moduleFileExtensions", function()
-- 	it("defaults to something useful", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options = normalize({ rootDir = "/root" }, {} :: Config_Argv):expect().options
-- 			jestExpect(options.moduleFileExtensions).toEqual({ "js", "jsx", "ts", "tsx", "json", "node" })
-- 		end)
-- 	end)
-- 	it:each({ nil, "jest-runner" })("throws if missing `js` but using jest-runner", function(runner)
-- 		return Promise.resolve():andThen(function()
-- 			jestExpect(
-- 					normalize(
-- 						{ moduleFileExtensions = { "json", "jsx" }, rootDir = "/root/", runner = runner },
-- 						{} :: Config_Argv
-- 					)
-- 				).rejects
-- 				.toThrowError("moduleFileExtensions must include 'js'")
-- 				:expect()
-- 		end)
-- 	end)
-- 	it("does not throw if missing `js` with a custom runner", function()
-- 		return Promise.resolve():andThen(function()
-- 			jestExpect(normalize({
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
-- 			jestExpect(options.cwd).toBe(process:cwd())
-- 		end)
-- 	end)
-- 	it("is not lost if the config has its own cwd property", function()
-- 		return Promise.resolve():andThen(function()
-- 			((console.warn :: unknown) :: jest_SpyInstance):mockImplementation(function() end)
-- 			local options = normalize(
-- 				{ cwd = "/tmp/config-sets-cwd-itself", rootDir = "/root/" } :: Config_InitialOptions,
-- 				{} :: Config_Argv
-- 			):expect().options
-- 			jestExpect(options.cwd).toBe(process:cwd())
-- 			jestExpect(console.warn).toHaveBeenCalled()
-- 		end)
-- 	end)
-- end)
-- ROBLOX deviation END

describe("Defaults", function()
	it("should be accepted by normalize", function()
		return Promise.resolve():andThen(function()
			normalize(Object.assign({}, Defaults, { rootDir = pathToInstance("/root") }), {} :: Config_Argv):expect()
			jestExpect(console.warn).never.toHaveBeenCalled()
		end)
	end)
end)

describe("displayName", function()
	for _, ref in
		{
			{ displayName = {}, description = "is an empty object" } :: any,
			{ displayName = { name = "hello" }, description = "missing color" },
			{ displayName = { color = "green" }, description = "missing name" },
			{ displayName = { color = 2, name = {} }, description = "using invalid values" },
		}
	do
		it("should throw an error when displayName is " .. ref.description, function()
			local displayName = ref.displayName
			return Promise.resolve()
				:andThen(function()
					-- ROBLOX deviation START: no .rejects
					jestExpect(function()
						normalize({ displayName = displayName, rootDir = pathToInstance("/root/") }, {} :: Config_Argv):expect()
					end).toThrowErrorMatchingSnapshot()
					-- ROBLOX deviation END
				end)
				:expect()
		end)
	end

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
	-- 			jestExpect((displayName :: any).name).toBe("project")
	-- 			jestExpect((displayName :: any).color).toMatchSnapshot()
	-- 		end)
	-- 	end
	-- )
	-- ROBLOX deviation END
end)

describe("testTimeout", function()
	it("should return timeout value if defined", function()
		return Promise.resolve()
			:andThen(function()
				((console.warn :: unknown) :: jest_SpyInstance):mockImplementation(function() end)
				local options =
					normalize(
						{ rootDir = pathToInstance("/root/"), testTimeout = 1000 },
						{} :: Config_Argv
					):expect().options
				jestExpect(options.testTimeout).toBe(1000)
				jestExpect(console.warn).never.toHaveBeenCalled()
			end)
			:expect()
	end)

	it("should throw an error if timeout is a negative number", function()
		return Promise.resolve()
			:andThen(function()
				-- ROBLOX deviation START: no .rejects
				jestExpect(function()
					normalize({ rootDir = pathToInstance("/root/"), testTimeout = -1 }, {} :: Config_Argv):expect()
				end).toThrowErrorMatchingSnapshot()
				-- ROBLOX deviation END
			end)
			:expect()
	end)
end)

-- ROBLOX deviation START: not supported
-- describe("extensionsToTreatAsEsm", function()
-- 	local function matchErrorSnapshot(
-- 		callback: { --[[ ROBLOX TODO: Unhandled node for type: TSCallSignatureDeclaration ]] --[[ (): Promise<{
--     hasDeprecationWarnings: boolean;
--     options: Config.ProjectConfig & Config.GlobalConfig;
--   }>; ]]
-- 			--[[ ROBLOX TODO: Unhandled node for type: TSCallSignatureDeclaration ]]
-- 			--[[ (): Promise<{
--     hasDeprecationWarnings: boolean;
--     options: Config.ProjectConfig & Config.GlobalConfig;
--   }>; ]]
-- 			--[[ ROBLOX TODO: Unhandled node for type: TSCallSignatureDeclaration ]]
-- 			--[[ (): any; ]]
-- 		}
-- 	)
-- 		return Promise.resolve():andThen(function()
-- 			expect:assertions(1)
-- 			do --[[ ROBLOX COMMENT: try-catch block conversion ]]
-- 				local ok, result, hasReturned = xpcall(function()
-- 					callback():expect()
-- 				end, function(error_)
-- 					jestExpect(wrap(stripAnsi(error_.message):trim())).toMatchSnapshot()
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
-- 			jestExpect(options.extensionsToTreatAsEsm).toEqual({ ".ts" })
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
-- 			jestExpect(normalize({ haste = { enableSymlinks = true }, rootDir = "/root/" }, {})).rejects
-- 				.toThrow("haste.enableSymlinks is incompatible with watchman")
-- 				:expect()
-- 			jestExpect(normalize({ haste = { enableSymlinks = true }, rootDir = "/root/", watchman = true }, {})).rejects
-- 				.toThrow("haste.enableSymlinks is incompatible with watchman")
-- 				:expect()
-- 			local options = normalize(
-- 				{ haste = { enableSymlinks = true }, rootDir = "/root/", watchman = false },
-- 				{}
-- 			):expect().options
-- 			jestExpect(options.haste.enableSymlinks).toBe(true)
-- 			jestExpect(options.watchman).toBe(false)
-- 		end)
-- 	end)
-- end)
-- describe("haste.forceNodeFilesystemAPI", function()
-- 	it("should pass option through", function()
-- 		return Promise.resolve():andThen(function()
-- 			local options =
-- 				normalize({ haste = { forceNodeFilesystemAPI = true }, rootDir = "/root/" }, {}):expect().options
-- 			jestExpect(options.haste.forceNodeFilesystemAPI).toBe(true)
-- 			jestExpect(console.warn)["not"].toHaveBeenCalled()
-- 		end)
-- 	end)
-- end)
-- ROBLOX deviation END

return {}
