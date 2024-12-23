local Promise = require("@pkg/@jsdotlua/promise")

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach
local mockMeScript = script.Parent.mock_me

local JestConfig = require("@pkg/@jsdotlua/jest-config")

local rootJsPath = script.Parent.test_root.root
local __filename = mockMeScript
local createRuntime

type FIXME_ANALYZE = any

describe("Roblox requireActual", function()
	beforeEach(function()
		createRuntime = require("../__mocks__/createRuntime")
	end)

	it("should mock module and then require the actual module", function()
		return Promise.resolve():andThen(function()
			local runtime = createRuntime(__filename, JestConfig.projectDefaults):expect()
			local root = runtime:requireModule(runtime.__mockRootPath, rootJsPath) -- Erase module registry because root.js requires most other modules.

			root.jest.mock(mockMeScript, function()
				return {
					mocked = true,
					actual = false,
				}
			end)

			expect(runtime:requireModuleOrMock(mockMeScript).mocked).toEqual(true)
			expect(runtime:requireModuleOrMock(mockMeScript).actual).toEqual(false)

			local actualModule = root.jest.requireActual(mockMeScript)
			expect(actualModule.mocked).toBe(false)
			expect(actualModule.actual).toBe(true)
		end)
	end)

	it("should mock module using part of the actual module", function()
		return Promise.resolve():andThen(function()
			local runtime = createRuntime(__filename, JestConfig.projectDefaults):expect()
			local root = runtime:requireModule(runtime.__mockRootPath, rootJsPath) -- Erase module registry because root.js requires most other modules.

			-- this should resemble a typical usage of requireActual: i.e. you mock a module, but you also use parts of the actual module in the mock
			root.jest.mock(mockMeScript, function()
				local actual = root.jest.requireActual(mockMeScript)
				return {
					mocked = true,
					actual = actual.actual,
				}
			end)

			expect(runtime:requireModuleOrMock(mockMeScript).mocked).toEqual(true)
			expect(runtime:requireModuleOrMock(mockMeScript).actual).toEqual(true)
		end)
	end);

	(it.each :: FIXME_ANALYZE)({
		"",
		"/",
		"foo",
		"/foo",
		"foo/bar",
		"/foo/bar",
		"@alias",
		"@",
		"@alias/foo",
		"@alias/foo/bar",
	})("should explicitly disallow all forms of require by string", function(path)
		return Promise.resolve():andThen(function()
			local runtime = createRuntime(__filename, JestConfig.projectDefaults):expect()
			local root = runtime:requireModule(runtime.__mockRootPath, rootJsPath) -- Erase module registry because root.js requires most other modules.

			expect(function()
				root.jest.requireActual(path)
			end).toThrow("not enabled")
		end)
	end)
end)
