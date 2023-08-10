-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-core/src/__tests__/SearchSource.test.ts
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
-- ROBLOX deviation START: not used
-- local Boolean = LuauPolyfill.Boolean
-- local Object = LuauPolyfill.Object
-- local Set = LuauPolyfill.Set
-- ROBLOX deviation END
type Array<T> = LuauPolyfill.Array<T>
type Promise<T> = LuauPolyfill.Promise<T>
local Promise = require(Packages.Promise)
local JestGlobals = require(Packages.Dev.JestGlobals)
local beforeEach = JestGlobals.beforeEach
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
-- ROBLOX deviation START: not used
-- local jest = JestGlobals.jest
-- local path = require(Packages.path)
-- ROBLOX deviation END
local jestTestResultModule = require(Packages.JestTestResult)
type Test = jestTestResultModule.Test
local jestTypesModule = require(Packages.JestTypes)
-- ROBLOX deviation START: not used
-- type Config = jestTypesModule.Config
-- ROBLOX deviation END
type Config_Argv = jestTypesModule.Config_Argv
type Config_Path = jestTypesModule.Config_Path
type Config_InitialOptions = jestTypesModule.Config_InitialOptions
type Config_ProjectConfig = jestTypesModule.Config_ProjectConfig
local normalize = require(Packages.JestConfig).normalize
-- ROBLOX deviation START: not used
-- local Runtime = require(Packages.JestRuntime).default
-- ROBLOX deviation END
local SearchSourceModule = require(script.Parent.Parent.SearchSource)
local SearchSource = SearchSourceModule.default
-- ROBLOX deviation START: add SearchSource type
type SearchSource = SearchSourceModule.SearchSource
-- ROBLOX deviation END
-- ROBLOX deviation START: importing type
-- local SearchResult = SearchSourceModule.SearchResult
type SearchResult = SearchSourceModule.SearchResult
-- ROBLOX deviation END
-- ROBLOX deviation START: not used
-- jest.setTimeout(15000)
-- ROBLOX deviation END
-- ROBLOX deviation START: additional variables
local process = {
	platform = "",
}
local path = {
	normalize = function(path)
		return path
	end,
}
-- ROBLOX deviation END
-- ROBLOX deviation START: add helper functions
local function pathRelative(root: Instance, script_: ModuleScript)
	local relativePath = script_.Name

	local curr: Instance = script_
	while curr.Parent ~= nil and curr.Parent ~= root do
		curr = curr.Parent
		relativePath = curr.Name .. "/" .. relativePath
	end
	return relativePath
end
local function toScripts(tests: Array<Test>)
	return Array.map(tests, function(ref)
		return ref.script
	end)
end
-- ROBLOX deviation END
-- ROBLOX deviation START: not used
-- jest.mock("graceful-fs", function()
-- 	local realFs = jest.requireActual("fs")
-- 	return Object.assign({}, realFs, {
-- 		statSync = function(path)
-- 			if path == "/foo/bar/prefix" then
-- 				return {
-- 					isDirectory = function()
-- 						return true
-- 					end,
-- 				}
-- 			end
-- 			return realFs:statSync(path)
-- 		end,
-- 	})
-- end)
-- ROBLOX deviation END
-- ROBLOX deviation START: rootDir needs to be an Instance
-- local rootDir = path:resolve(__dirname, "test_root")
local rootDir = script.Parent.test_root
-- ROBLOX deviation END
-- ROBLOX deviation START: not used
-- local testRegex = tostring(path.sep) .. "__testtests__" .. tostring(path.sep)
-- local testMatch = { "**/__testtests__/**/*" }
-- local maxWorkers = 1
-- local function toPaths(tests: Array<Test>)
-- 	return Array.map(tests, function(ref0)
-- 		local path = ref0.path
-- 		return path
-- 	end) --[[ ROBLOX CHECK: check if 'tests' is an Array ]]
-- end
-- ROBLOX deviation END
local findMatchingTests: (config: Config_ProjectConfig) -> Promise<SearchResult>
describe("SearchSource", function()
	local id = "SearchSource"
	local searchSource: SearchSource
	describe("isTestFilePath", function()
		local config
		beforeEach(function()
			return Promise.resolve():andThen(function()
				-- ROBLOX deviation START: needs to be an Instance
				-- config = normalize({ id = id, rootDir = ".", roots = {} }, {} :: Config_Argv):expect().options
				config = normalize({ id = id, rootDir = script.Parent, roots = {} }, {} :: Config_Argv):expect().options
				-- ROBLOX deviation END
				-- ROBLOX deviation START: Runtime.createContext is not ported
				-- return Runtime:createContext(config, { maxWorkers = maxWorkers, watchman = false })
				-- 	:then_(function(context)
				-- 		searchSource = SearchSource.new(context)
				-- 	end)
				searchSource = SearchSource.new({ config = config })
				-- ROBLOX deviation END
			end)
		end) -- micromatch doesn't support '..' through the globstar ('**') to avoid
		-- infinite recursion.
		it("supports ../ paths and unix separators via testRegex", function()
			return Promise.resolve():andThen(function()
				if process.platform ~= "win32" then
					config = normalize({
						id = id,
						-- ROBLOX deviation START: needs to be an Instance
						-- rootDir = ".",
						rootDir = script.Parent,
						-- ROBLOX deviation END
						roots = {},
						testMatch = nil,
						-- ROBLOX deviation START: lua extension instead of jsx
						-- testRegex = "(/__tests__/.*|(\\.|/)(test|spec))\\.jsx?$",
						testRegex = "(/__tests__/.*|(\\.|/)(test|spec))\\.lua$",
						-- ROBLOX deviation END
					}, {} :: Config_Argv):expect().options
					-- ROBLOX deviation START: Runtime.createContext is not ported
					-- return Runtime:createContext(config, { maxWorkers = maxWorkers, watchman = false })
					-- 	:then_(function(context)
					-- 		searchSource = SearchSource.new(context)
					-- 		local path = "/path/to/__tests__/foo/bar/baz/../../../test.js"
					-- 		expect(searchSource:isTestFilePath(path)).toEqual(true)
					-- 	end)
					searchSource = SearchSource.new({ config = config })
					-- ROBLOX NOTE: lua extension instead of js
					local path = "/path/to/__tests__/foo/bar/baz/../../../test.lua"
					expect(searchSource:isTestFilePath(path)).toEqual(true)
					-- ROBLOX deviation END
				else
					-- ROBLOX deviation START: dont return nil
					-- return nil
					return
					-- ROBLOX deviation END
				end
			end)
		end)
		it("supports unix separators", function()
			if process.platform ~= "win32" then
				-- ROBLOX deviation START: default testMatch matches .lua files
				-- local path = "/path/to/__tests__/test.js"
				local path = "/path/to/__tests__/test.lua"
				-- ROBLOX deviation END
				expect(searchSource:isTestFilePath(path)).toEqual(true)
			end
		end)
		-- ROBLOX deviation START: no process.platform support
		-- it("supports win32 separators", function()
		-- 	if process.platform == "win32" then
		-- 		local path = "\\path\\to\\__tests__\\test.js"
		-- 		expect(searchSource:isTestFilePath(path)).toEqual(true)
		-- 	end
		-- end)
		-- ROBLOX deviation END
	end)
	describe("testPathsMatching", function()
		beforeEach(function()
			findMatchingTests = function(config: Config_ProjectConfig)
				-- ROBLOX deviation START: Runtime.createContext is not ported
				-- return Runtime:createContext(config, { maxWorkers = maxWorkers, watchman = false })
				-- 	:then_(function(context)
				-- 		return SearchSource.new(context):findMatchingTests()
				-- 	end)
				return Promise.resolve(SearchSource.new({ config = config }):findMatchingTests())
				-- ROBLOX deviation END
			end
		end)
		it("finds tests matching a pattern via testRegex", function()
			return Promise.resolve():andThen(function()
				local config = normalize({
					-- ROBLOX deviation START: not supported
					-- moduleFileExtensions = { "js", "jsx", "txt" },
					-- ROBLOX deviation END
					id = id,
					rootDir = rootDir,
					testMatch = nil,
					-- TODO: change back to "not-really-a-test once https://roblox.atlassian.net/browse/LUATOOLS-146 is resolved
					-- Ticket to remove: https://roblox.atlassian.net/browse/ADO-2644
					testRegex = "not-really-a-test.txt",
				}, {} :: Config_Argv):expect().options
				-- ROBLOX deviation START: then_ not available, using andThen instead
				-- return findMatchingTests(config):then_(function(data)
				return findMatchingTests(config):andThen(function(data)
					-- ROBLOX deviation END
					-- ROBLOX deviation START: use scripts to calculate relative path
					-- local relPaths = Array.sort(
					-- 	Array.map(toPaths(data.tests), function(absPath)
					-- 		return path:relative(rootDir, absPath)
					-- 	end) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
					-- )
					local relPaths = Array.sort(Array.map(toScripts(data.tests), function(absPath)
						return pathRelative(rootDir, absPath)
					end))
					-- ROBLOX deviation END
					expect(relPaths).toEqual(Array.sort({
						-- ROBLOX deviation START: issue #864
						-- path:normalize(".hiddenFolder/not-really-a-test.txt"),
						-- path:normalize("__testtests__/not-really-a-test.txt"),
						path.normalize(".hiddenFolder/not-really-a-test.txt"),
						path.normalize("__testtests__/not-really-a-test.txt"),
						-- ROBLOX deviation END
					}))
				end)
			end)
		end)
		it("finds tests matching a pattern via testMatch", function()
			return Promise.resolve():andThen(function()
				local config = normalize({
					-- ROBLOX deviation START: not supported
					-- moduleFileExtensions = { "js", "jsx", "txt" },
					-- ROBLOX deviation END
					id = id,
					rootDir = rootDir,
					testMatch = { "**/not-really-a-test.txt", "!**/do-not-match-me.txt" },
					testRegex = "",
				}, {} :: Config_Argv):expect().options
				-- ROBLOX deviation START: then_ not available, using andThen instead
				-- return findMatchingTests(config):then_(function(data)
				return findMatchingTests(config):andThen(function(data)
					-- ROBLOX deviation END
					-- ROBLOX deviation START: use scripts to calculate relative path
					-- local relPaths = Array.sort(
					-- 	Array.map(toPaths(data.tests), function(absPath)
					-- 		return path:relative(rootDir, absPath)
					-- 	end) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
					-- )
					local relPaths = Array.sort(Array.map(toScripts(data.tests), function(absPath)
						return pathRelative(rootDir, absPath)
					end))
					-- ROBLOX deviation END
					expect(relPaths).toEqual(Array.sort({
						-- ROBLOX deviation START: issue #864
						-- path:normalize(".hiddenFolder/not-really-a-test.txt"),
						-- path:normalize("__testtests__/not-really-a-test.txt"),
						path.normalize(".hiddenFolder/not-really-a-test.txt"),
						path.normalize("__testtests__/not-really-a-test.txt"),
						-- ROBLOX deviation END
					}))
				end)
			end)
		end)
		it("finds tests matching a JS regex pattern", function()
			return Promise.resolve():andThen(function()
				local config = normalize({
					-- ROBLOX deviation START: not supported
					-- moduleFileExtensions = { "js", "jsx" },
					-- ROBLOX deviation END
					id = id,
					rootDir = rootDir,
					testMatch = nil,
					testRegex = "test.jsx?",
				}, {} :: Config_Argv):expect().options
				-- ROBLOX deviation START: then_ not available, using andThen instead
				-- return findMatchingTests(config):then_(function(data)
				return findMatchingTests(config):andThen(function(data)
					-- ROBLOX deviation END
					-- ROBLOX deviation START: use scripts to calculate relative path
					-- local relPaths = Array.map(toPaths(data.tests), function(absPath)
					-- 	return path:relative(rootDir, absPath)
					-- end) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
					local relPaths = Array.map(toScripts(data.tests), function(absPath)
						return pathRelative(rootDir, absPath)
					end)
					-- ROBLOX deviation END
					expect(Array.sort(relPaths) --[[ ROBLOX CHECK: check if 'relPaths' is an Array ]]).toEqual({
						-- ROBLOX deviation START: issue #864
						-- path:normalize("__testtests__/test.js"),
						-- path:normalize("__testtests__/test.jsx"),
						path.normalize("__testtests__/test.js"),
						path.normalize("__testtests__/test.jsx"),
						-- ROBLOX deviation END
					})
				end)
			end)
		end)
		it("finds tests matching a JS glob pattern", function()
			return Promise.resolve():andThen(function()
				local config = normalize({
					-- ROBLOX deviation START: not supported
					-- moduleFileExtensions = { "js", "jsx" },
					-- ROBLOX deviation END
					id = id,
					rootDir = rootDir,
					testMatch = { "**/test.js?(x)" },
					testRegex = "",
				}, {} :: Config_Argv):expect().options
				-- ROBLOX deviation START: then_ not available, using andThen instead
				-- return findMatchingTests(config):then_(function(data)
				return findMatchingTests(config):andThen(function(data)
					-- ROBLOX deviation END
					-- ROBLOX deviation START: use scripts to calculate relative path
					-- local relPaths = Array.map(toPaths(data.tests), function(absPath)
					-- 	return path:relative(rootDir, absPath)
					-- end) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
					local relPaths = Array.map(toScripts(data.tests), function(absPath)
						return pathRelative(rootDir, absPath)
					end)
					-- ROBLOX deviation END
					expect(Array.sort(relPaths) --[[ ROBLOX CHECK: check if 'relPaths' is an Array ]]).toEqual({
						-- ROBLOX deviation START: issue #864
						-- path:normalize("__testtests__/test.js"),
						-- path:normalize("__testtests__/test.jsx"),
						path.normalize("__testtests__/test.js"),
						path.normalize("__testtests__/test.jsx"),
						-- ROBLOX deviation END
					})
				end)
			end)
		end)
		it("finds tests matching a JS with overriding glob patterns", function()
			return Promise.resolve():andThen(function()
				local config = normalize({
					-- ROBLOX deviation START: not supported
					-- moduleFileExtensions = { "js", "jsx" },
					-- ROBLOX devation END
					id = id,
					rootDir = rootDir,
					testMatch = {
						"**/*.js?(x)",
						"!**/test.js?(x)",
						"**/test.js",
						"!**/test.js",
					},
					testRegex = "",
				}, {} :: Config_Argv):expect().options
				-- ROBLOX deviation START: then_ not available, using andThen instead
				-- return findMatchingTests(config):then_(function(data)
				return findMatchingTests(config):andThen(function(data)
					-- ROBLOX deviation END
					-- ROBLOX deviation START: use scripts to calculate relative path
					-- local relPaths = Array.map(toPaths(data.tests), function(absPath)
					-- 	return path:relative(rootDir, absPath)
					-- end) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
					local relPaths = Array.map(toScripts(data.tests), function(absPath)
						return pathRelative(rootDir, absPath)
					end)
					-- ROBLOX deviation END
					-- ROBLOX deviation START: issue #864
					-- expect(
					-- 	Array.sort(relPaths) --[[ ROBLOX CHECK: check if 'relPaths' is an Array ]]
					-- ).toEqual({ path:normalize("module.jsx"), path:normalize("noTests.js") })
					expect(Array.sort(relPaths) --[[ ROBLOX CHECK: check if 'relPaths' is an Array ]]).toEqual({
						path.normalize("module.jsx"),
						path.normalize("noTests.js"),
					})
					-- ROBLOX deviation END
				end)
			end)
		end)
		-- ROBLOX deviation START: only lua extensions are supported in Luau version
		-- it("finds tests with default file extensions using testRegex", function()
		-- 	return Promise.resolve():andThen(function()
		-- 		local config = normalize(
		-- 			{ id = id, rootDir = rootDir, testMatch = nil, testRegex = testRegex },
		-- 			{} :: Config_Argv
		-- 		):expect().options
		-- 		return findMatchingTests(config):then_(function(data)
		-- 			local relPaths = Array.map(toPaths(data.tests), function(absPath)
		-- 				return path:relative(rootDir, absPath)
		-- 			end) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
		-- 			expect(
		-- 				Array.sort(relPaths) --[[ ROBLOX CHECK: check if 'relPaths' is an Array ]]
		-- 			).toEqual({
		-- 				path:normalize("__testtests__/test.js"),
		-- 				path:normalize("__testtests__/test.jsx"),
		-- 			})
		-- 		end)
		-- 	end)
		-- end)
		-- it("finds tests with default file extensions using testMatch", function()
		-- 	return Promise.resolve():andThen(function()
		-- 		local config = normalize(
		-- 			{ id = id, rootDir = rootDir, testMatch = testMatch, testRegex = "" },
		-- 			{} :: Config_Argv
		-- 		):expect().options
		-- 		return findMatchingTests(config):then_(function(data)
		-- 			local relPaths = Array.map(toPaths(data.tests), function(absPath)
		-- 				return path:relative(rootDir, absPath)
		-- 			end) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
		-- 			expect(
		-- 				Array.sort(relPaths) --[[ ROBLOX CHECK: check if 'relPaths' is an Array ]]
		-- 			).toEqual({
		-- 				path:normalize("__testtests__/test.js"),
		-- 				path:normalize("__testtests__/test.jsx"),
		-- 			})
		-- 		end)
		-- 	end)
		-- end)
		-- ROBLOX deviation END
		it("finds tests with parentheses in their rootDir when using testMatch", function()
			return Promise.resolve():andThen(function()
				local config = normalize({
					id = id,
					-- ROBLOX deviation START: needs to be an Instance
					-- rootDir = path:resolve(__dirname, "test_root_with_(parentheses)"),
					rootDir = script.Parent["test_root_with_(parentheses)"],
					-- ROBLOX deviation END
					-- ROBLOX deviation START
					-- testMatch = { "<rootDir>**/__testtests__/**/*" },
					testMatch = { "**/__testtests__/**/*" },
					-- ROBLOX deviation END
					testRegex = nil,
				}, {} :: Config_Argv):expect().options
				-- ROBLOX deviation START: then_ not available, using andThen instead
				-- return findMatchingTests(config):then_(function(data)
				return findMatchingTests(config):andThen(function(data)
					-- ROBLOX deviation END
					-- ROBLOX deviation START: use scripts to calculate relative path
					-- local relPaths = Array.map(toPaths(data.tests), function(absPath)
					-- 	return path:relative(rootDir, absPath)
					-- end) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
					local relPaths = Array.map(toScripts(data.tests), function(absPath)
						return pathRelative(rootDir, absPath)
					end)
					-- ROBLOX deviation END
					expect(Array.sort(relPaths) --[[ ROBLOX CHECK: check if 'relPaths' is an Array ]]).toEqual({
						-- ROBLOX deviation START: issue #864
						-- expect.stringContaining(path:normalize("__testtests__/test.js")),
						expect.stringContaining(path.normalize("__testtests__/test.js")),
						-- ROBLOX deviation END
					})
				end)
			end)
		end)
		-- ROBLOX deviation START: only lua extensions are supported in Luau version
		-- it("finds tests with similar but custom file extensions", function()
		-- 	return Promise.resolve():andThen(function()
		-- 		local config = normalize({
		-- 			moduleFileExtensions = { "js", "jsx" },
		-- 			id = id,
		-- 			rootDir = rootDir,
		-- 			testMatch = testMatch,
		-- 		}, {} :: Config_Argv):expect().options
		-- 		return findMatchingTests(config):then_(function(data)
		-- 			local relPaths = Array.map(toPaths(data.tests), function(absPath)
		-- 				return path:relative(rootDir, absPath)
		-- 			end) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
		-- 			expect(
		-- 				Array.sort(relPaths) --[[ ROBLOX CHECK: check if 'relPaths' is an Array ]]
		-- 			).toEqual({
		-- 				path:normalize("__testtests__/test.js"),
		-- 				path:normalize("__testtests__/test.jsx"),
		-- 			})
		-- 		end)
		-- 	end)
		-- end)
		-- it("finds tests with totally custom foobar file extensions", function()
		-- 	return Promise.resolve():andThen(function()
		-- 		local config = normalize({
		-- 			moduleFileExtensions = { "js", "foobar" },
		-- 			id = id,
		-- 			rootDir = rootDir,
		-- 			testMatch = testMatch,
		-- 		}, {} :: Config_Argv):expect().options
		-- 		return findMatchingTests(config):then_(function(data)
		-- 			local relPaths = Array.map(toPaths(data.tests), function(absPath)
		-- 				return path:relative(rootDir, absPath)
		-- 			end) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
		-- 			expect(
		-- 				Array.sort(relPaths) --[[ ROBLOX CHECK: check if 'relPaths' is an Array ]]
		-- 			).toEqual({
		-- 				path:normalize("__testtests__/test.foobar"),
		-- 				path:normalize("__testtests__/test.js"),
		-- 			})
		-- 		end)
		-- 	end)
		-- end)
		-- it("finds tests with many kinds of file extensions", function()
		-- 	return Promise.resolve():andThen(function()
		-- 		local config = normalize({
		-- 			moduleFileExtensions = { "js", "jsx" },
		-- 			id = id,
		-- 			rootDir = rootDir,
		-- 			testMatch = testMatch,
		-- 		}, {} :: Config_Argv):expect().options
		-- 		return findMatchingTests(config):then_(function(data)
		-- 			local relPaths = Array.map(toPaths(data.tests), function(absPath)
		-- 				return path:relative(rootDir, absPath)
		-- 			end) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
		-- 			expect(
		-- 				Array.sort(relPaths) --[[ ROBLOX CHECK: check if 'relPaths' is an Array ]]
		-- 			).toEqual({
		-- 				path:normalize("__testtests__/test.js"),
		-- 				path:normalize("__testtests__/test.jsx"),
		-- 			})
		-- 		end)
		-- 	end)
		-- end)
		-- it("finds tests using a regex only", function()
		-- 	return Promise.resolve():andThen(function()
		-- 		local config = normalize(
		-- 			{ id = id, rootDir = rootDir, testMatch = nil, testRegex = testRegex },
		-- 			{} :: Config_Argv
		-- 		):expect().options
		-- 		return findMatchingTests(config):then_(function(data)
		-- 			local relPaths = Array.map(toPaths(data.tests), function(absPath)
		-- 				return path:relative(rootDir, absPath)
		-- 			end) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
		-- 			expect(
		-- 				Array.sort(relPaths) --[[ ROBLOX CHECK: check if 'relPaths' is an Array ]]
		-- 			).toEqual({
		-- 				path:normalize("__testtests__/test.js"),
		-- 				path:normalize("__testtests__/test.jsx"),
		-- 			})
		-- 		end)
		-- 	end)
		-- end)
		-- it("finds tests using a glob only", function()
		-- 	return Promise.resolve():andThen(function()
		-- 		local config = normalize(
		-- 			{ id = id, rootDir = rootDir, testMatch = testMatch, testRegex = "" },
		-- 			{} :: Config_Argv
		-- 		):expect().options
		-- 		return findMatchingTests(config):then_(function(data)
		-- 			local relPaths = Array.map(toPaths(data.tests), function(absPath)
		-- 				return path:relative(rootDir, absPath)
		-- 			end) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
		-- 			expect(
		-- 				Array.sort(relPaths) --[[ ROBLOX CHECK: check if 'relPaths' is an Array ]]
		-- 			).toEqual({
		-- 				path:normalize("__testtests__/test.js"),
		-- 				path:normalize("__testtests__/test.jsx"),
		-- 			})
		-- 		end)
		-- 	end)
		-- end)
		-- ROBLOX deviation END
	end)
	-- ROBLOX deviation START: not supported
	-- describe("filterPathsWin32", function()
	-- 	beforeEach(function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local config = normalize({ id = id, rootDir = ".", roots = {} }, {} :: Config_Argv):expect().options
	-- 			local context = Runtime:createContext(config, { maxWorkers = maxWorkers, watchman = false }):expect()
	-- 			searchSource = SearchSource.new(context)
	-- 			context.hasteFS.getAllFiles = function(_self: any)
	-- 				return {
	-- 					path:resolve("packages/lib/my-lib.ts"),
	-- 					path:resolve("packages/@core/my-app.ts"),
	-- 					path:resolve("packages/+cli/my-cli.ts"),
	-- 					path:resolve("packages/.hidden/my-app-hidden.ts"),
	-- 					path:resolve("packages/programs (x86)/my-program.ts"),
	-- 				}
	-- 			end
	-- 		end)
	-- 	end)
	-- 	it("should allow a simple match", function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local result = searchSource:filterPathsWin32({ "packages/lib/my-lib.ts" })
	-- 			expect(result).toEqual({ path:resolve("packages/lib/my-lib.ts") })
	-- 		end)
	-- 	end)
	-- 	it("should allow to match a file inside a hidden directory", function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local result = searchSource:filterPathsWin32({ "packages/.hidden/my-app-hidden.ts" })
	-- 			expect(result).toEqual({ path:resolve("packages/.hidden/my-app-hidden.ts") })
	-- 		end)
	-- 	end)
	-- 	it('should allow to match a file inside a directory prefixed with a "@"', function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local result = searchSource:filterPathsWin32({ "packages/@core/my-app.ts" })
	-- 			expect(result).toEqual({ path:resolve("packages/@core/my-app.ts") })
	-- 		end)
	-- 	end)
	-- 	it('should allow to match a file inside a directory prefixed with a "+"', function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local result = searchSource:filterPathsWin32({ "packages/+cli/my-cli.ts" })
	-- 			expect(result).toEqual({ path:resolve("packages/+cli/my-cli.ts") })
	-- 		end)
	-- 	end)
	-- 	it("should allow an @(pattern)", function()
	-- 		local result = searchSource:filterPathsWin32({ "packages/@(@core)/my-app.ts" })
	-- 		expect(result).toEqual({ path:resolve("packages/@core/my-app.ts") })
	-- 	end)
	-- 	it("should allow a +(pattern)", function()
	-- 		local result = searchSource:filterPathsWin32({ "packages/+(@core)/my-app.ts" })
	-- 		expect(result).toEqual({ path:resolve("packages/@core/my-app.ts") })
	-- 	end)
	-- 	it("should allow for (pattern) in file path", function()
	-- 		local result = searchSource:filterPathsWin32({ "packages/programs (x86)/my-program.ts" })
	-- 		expect(result).toEqual({ path:resolve("packages/programs (x86)/my-program.ts") })
	-- 	end)
	-- 	it("should allow no results found", function()
	-- 		local result = searchSource:filterPathsWin32({ "not/exists" })
	-- 		expect(result).toHaveLength(0)
	-- 	end)
	-- end)
	-- describe("findRelatedTests", function()
	-- 	local rootDir = Array.join(path, __dirname, "..", "..", "..", "jest-runtime", "src", "__tests__", "test_root") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 	local rootPath = Array.join(path, rootDir, "root.js") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 	beforeEach(function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local config = normalize({
	-- 				haste = {
	-- 					hasteImplModulePath = Array.join(
	-- 						path,
	-- 						__dirname,
	-- 						"..",
	-- 						"..",
	-- 						"..",
	-- 						"jest-haste-map",
	-- 						"src",
	-- 						"__tests__",
	-- 						"haste_impl.js"
	-- 					),--[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 				},
	-- 				name = "SearchSource-findRelatedTests-tests",
	-- 				rootDir = rootDir,
	-- 			}, {} :: Config_Argv):expect().options
	-- 			local context = Runtime:createContext(config, { maxWorkers = maxWorkers, watchman = false }):expect()
	-- 			searchSource = SearchSource.new(context)
	-- 		end)
	-- 	end)
	-- 	it("makes sure a file is related to itself", function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local data = searchSource:findRelatedTests(Set.new({ rootPath }), false):expect()
	-- 			expect(toPaths(data.tests)).toEqual({ rootPath })
	-- 		end)
	-- 	end)
	-- 	it("finds tests that depend directly on the path", function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local filePath = Array.join(path, rootDir, "RegularModule.js") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 			local file2Path = Array.join(path, rootDir, "RequireRegularModule.js") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 			local parentDep = Array.join(path, rootDir, "ModuleWithSideEffects.js") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 			local data = searchSource:findRelatedTests(Set.new({ filePath }), false):expect()
	-- 			expect(
	-- 				Array.sort(toPaths(data.tests)) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
	-- 			).toEqual({ parentDep, filePath, file2Path, rootPath })
	-- 		end)
	-- 	end)
	-- 	it("excludes untested files from coverage", function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local unrelatedFile = Array.join(path, rootDir, "JSONFile.json") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 			local regular = Array.join(path, rootDir, "RegularModule.js") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 			local requireRegular = Array.join(path, rootDir, "RequireRegularMode.js") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 			local data =
	-- 				searchSource:findRelatedTests(Set.new({ regular, requireRegular, unrelatedFile }), true):expect()
	-- 			expect(Array.from(Boolean.toJSBoolean(data.collectCoverageFrom) and data.collectCoverageFrom or {})).toEqual({
	-- 				"RegularModule.js",
	-- 			})
	-- 		end)
	-- 	end)
	-- end)
	-- describe("findRelatedTestsFromPattern", function()
	-- 	beforeEach(function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local config = normalize({
	-- 				moduleFileExtensions = { "js", "jsx", "foobar" },
	-- 				id = id,
	-- 				rootDir = rootDir,
	-- 				testMatch = testMatch,
	-- 			}, {} :: Config_Argv):expect().options
	-- 			local context = Runtime:createContext(config, { maxWorkers = maxWorkers, watchman = false }):expect()
	-- 			searchSource = SearchSource.new(context)
	-- 		end)
	-- 	end)
	-- 	it("returns empty search result for empty input", function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local input: Array<Config_Path> = {}
	-- 			local data = searchSource:findRelatedTestsFromPattern(input, false):expect()
	-- 			expect(data.tests).toEqual({})
	-- 		end)
	-- 	end)
	-- 	it("returns empty search result for invalid input", function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local input = { "non-existend.js" }
	-- 			local data = searchSource:findRelatedTestsFromPattern(input, false):expect()
	-- 			expect(data.tests).toEqual({})
	-- 		end)
	-- 	end)
	-- 	it("returns empty search result if no related tests were found", function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local input = { "no_tests.js" }
	-- 			local data = searchSource:findRelatedTestsFromPattern(input, false):expect()
	-- 			expect(data.tests).toEqual({})
	-- 		end)
	-- 	end)
	-- 	it("finds tests for a single file", function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local input = { "packages/jest-core/src/__tests__/test_root/module.jsx" }
	-- 			local data = searchSource:findRelatedTestsFromPattern(input, false):expect()
	-- 			expect(
	-- 				Array.sort(toPaths(data.tests)) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
	-- 			).toEqual({
	-- 				Array.join(path, rootDir, "__testtests__", "test.js"),--[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 				Array.join(path, rootDir, "__testtests__", "test.jsx"),--[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 			})
	-- 		end)
	-- 	end)
	-- 	it("finds tests for multiple files", function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local input = {
	-- 				"packages/jest-core/src/__tests__/test_root/module.jsx",
	-- 				"packages/jest-core/src/__tests__/test_root/module.foobar",
	-- 			}
	-- 			local data = searchSource:findRelatedTestsFromPattern(input, false):expect()
	-- 			expect(
	-- 				Array.sort(toPaths(data.tests)) --[[ ROBLOX CHECK: check if 'toPaths(data.tests)' is an Array ]]
	-- 			).toEqual({
	-- 				Array.join(path, rootDir, "__testtests__", "test.foobar"),--[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 				Array.join(path, rootDir, "__testtests__", "test.js"),--[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 				Array.join(path, rootDir, "__testtests__", "test.jsx"),--[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 			})
	-- 		end)
	-- 	end)
	-- 	it("does not mistake roots folders with prefix names", function()
	-- 		return Promise.resolve():andThen(function()
	-- 			if process.platform ~= "win32" then
	-- 				local config = normalize(
	-- 					{ id = id, rootDir = ".", roots = { "/foo/bar/prefix" } },
	-- 					{} :: Config_Argv
	-- 				):expect().options
	-- 				searchSource = SearchSource.new(
	-- 					Runtime:createContext(config, { maxWorkers = maxWorkers, watchman = false }):expect()
	-- 				)
	-- 				local input = { "/foo/bar/prefix-suffix/__tests__/my-test.test.js" }
	-- 				local data = searchSource:findTestsByPaths(input)
	-- 				expect(data.tests).toEqual({})
	-- 			end
	-- 		end)
	-- 	end)
	-- end)
	-- describe("findRelatedSourcesFromTestsInChangedFiles", function()
	-- 	local rootDir = path:resolve(__dirname, "../../../jest-runtime/src/__tests__/test_root")
	-- 	beforeEach(function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local config = normalize({
	-- 				haste = {
	-- 					hasteImplModulePath = path:resolve(
	-- 						__dirname,
	-- 						"../../../jest-haste-map/src/__tests__/haste_impl.js"
	-- 					),
	-- 				},
	-- 				name = "SearchSource-findRelatedSourcesFromTestsInChangedFiles-tests",
	-- 				rootDir = rootDir,
	-- 			}, {} :: Config_Argv):expect().options
	-- 			local context = Runtime:createContext(config, { maxWorkers = maxWorkers, watchman = false }):expect()
	-- 			searchSource = SearchSource.new(context)
	-- 		end)
	-- 	end)
	-- 	it("return empty set if no SCM", function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local requireRegularModule = Array.join(path, rootDir, "RequireRegularModule.js") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 			local sources = searchSource
	-- 				:findRelatedSourcesFromTestsInChangedFiles({
	-- 					changedFiles = Set.new({ requireRegularModule }),
	-- 					repos = { git = Set.new(), hg = Set.new() },
	-- 				})
	-- 				:expect()
	-- 			expect(sources).toEqual({})
	-- 		end)
	-- 	end)
	-- 	it("return sources required by tests", function()
	-- 		return Promise.resolve():andThen(function()
	-- 			local regularModule = Array.join(path, rootDir, "RegularModule.js") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 			local requireRegularModule = Array.join(path, rootDir, "RequireRegularModule.js") --[[ ROBLOX CHECK: check if 'path' is an Array ]]
	-- 			local sources = searchSource
	-- 				:findRelatedSourcesFromTestsInChangedFiles({
	-- 					changedFiles = Set.new({ requireRegularModule }),
	-- 					repos = { git = Set.new("/path/to/git"), hg = Set.new() },
	-- 				})
	-- 				:expect()
	-- 			expect(sources).toEqual({ regularModule })
	-- 		end)
	-- 	end)
	-- end)
	-- ROBLOX deviation END
end)
