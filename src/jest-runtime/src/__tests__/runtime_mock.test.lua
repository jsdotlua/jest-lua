-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/jest-runtime/src/__tests__/runtime_mock.test.js
local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent
local Promise = require(Packages.Promise)
local JestGlobals = require(Packages.Dev.JestGlobals)
-- ROBLOX deviation: pass config to runtime new
local JestConfig = require(Packages.Dev.JestConfig)
local beforeEach = JestGlobals.beforeEach
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local jest = JestGlobals.jest
local it = JestGlobals.it
local createRuntime

-- ROBLOX deviation START: path not available, using luau alternatives
local rootJsPath = script.Parent.test_root.root
local __filename = script
-- ROBLOX deviation END
-- ROBLOX deviation START: no upstream
local mockMeScript = script.Parent.mock_me
-- ROBLOX deviation END

describe("Runtime", function()
	beforeEach(function()
		createRuntime = require(CurrentModule.__mocks__.createRuntime)
		jest.mock(mockMeScript, function()
			return { mocked = true }
		end)
	end)

	describe("jest.mock", function()
		-- ROBLOX deviation START: no upstream
		it("mocks a module", function()
			local mockMeModule = require(mockMeScript)
			expect(mockMeModule.mocked).toBe(true)
		end)
		-- ROBLOX deviation END
		it("uses explicitly set mocks instead of automocking", function()
			return Promise.resolve():andThen(function()
				-- ROBLOX deviation START: using current ModuleScript instead of
				-- __filename, also pass in config to runtime
				local runtime = createRuntime(__filename, JestConfig.projectDefaults):expect()
				-- ROBLOX deviation END
				local mockReference = { isMock = true }
				local root = runtime:requireModule(runtime.__mockRootPath, rootJsPath) -- Erase module registry because root.js requires most other modules.
				-- ROBLOX deviation START: using ModuleScript instead of path & exporting jest as a default export in 'root'
				-- root.jest:mock("RegularModule", function()
				-- 	return mockReference
				-- end)
				-- root.jest:mock("ManuallyMocked", function()
				-- 	return mockReference
				-- end)
				-- root.jest:mock("nested1/nested2/nested3")
				-- expect(runtime:requireModuleOrMock(runtime.__mockRootPath, "RegularModule")).toEqual(mockReference)
				-- expect(runtime:requireModuleOrMock(runtime.__mockRootPath, "ManuallyMocked")).toEqual(mockReference)
				-- expect(runtime:requireModuleOrMock(runtime.__mockRootPath, "nested1/nested2/nested3")).toEqual(
				-- 	mockReference
				-- )

				root.jest.resetModules()
				root.jest.mock(runtime.__mockRootPath.RegularModule, function()
					return mockReference
				end)
				root.jest.mock(runtime.__mockRootPath.ManuallyMocked, function()
					return mockReference
				end)
				-- ROBLOX NOTE: automocking not supported
				-- root.jest.mock(runtime.__mockRootPath.nested1.nested2.nested3)
				expect(runtime:requireModuleOrMock(runtime.__mockRootPath.RegularModule)).toEqual(mockReference)
				expect(runtime:requireModuleOrMock(runtime.__mockRootPath.ManuallyMocked)).toEqual(mockReference)
				-- ROBLOX deviation END
			end)
		end)
		-- ROBLOX deviation START: virtual mocks not supported
		-- it("sets virtual mock for non-existing module required from same directory", function()
		-- 	return Promise.resolve():andThen(function()

		-- 		local runtime = createRuntime(__filename, config):expect()
		-- 		local mockReference = { isVirtualMock = true }
		-- 		local virtual = true
		-- 		local root = runtime:requireModule(runtime.__mockRootPath, rootJsPath) -- Erase module registry because root.js requires most other modules.
		-- 		root.jest:resetModules()
		-- 		root.jest:mock("NotInstalledModule", function()
		-- 			return mockReference
		-- 		end, { virtual = virtual })
		-- 		root.jest:mock("../ManuallyMocked", function()
		-- 			return mockReference
		-- 		end, { virtual = virtual })
		-- 		root.jest:mock("/AbsolutePath/Mock", function()
		-- 			return mockReference
		-- 		end, { virtual = virtual })
		-- 		expect(runtime:requireModuleOrMock(runtime.__mockRootPath, "NotInstalledModule")).toEqual(mockReference)
		-- 		expect(runtime:requireModuleOrMock(runtime.__mockRootPath, "../ManuallyMocked")).toEqual(mockReference)
		-- 		expect(runtime:requireModuleOrMock(runtime.__mockRootPath, "/AbsolutePath/Mock")).toEqual(mockReference)
		-- 	end)
		-- end)
		-- it("sets virtual mock for non-existing module required from different directory", function()
		-- 	return Promise.resolve():andThen(function()

		-- 		local runtime = createRuntime(__filename, config):expect()
		-- 		local mockReference = { isVirtualMock = true }
		-- 		local virtual = true
		-- 		local root = runtime:requireModule(runtime.__mockRootPath, rootJsPath) -- Erase module registry because root.js requires most other modules.
		-- 		root.jest:resetModules()
		-- 		root.jest:mock("NotInstalledModule", function()
		-- 			return mockReference
		-- 		end, { virtual = virtual })
		-- 		root.jest:mock("../ManuallyMocked", function()
		-- 			return mockReference
		-- 		end, { virtual = virtual })
		-- 		root.jest:mock("/AbsolutePath/Mock", function()
		-- 			return mockReference
		-- 		end, { virtual = virtual })
		-- 		expect(runtime:requireModuleOrMock(runtime.__mockSubdirPath, "NotInstalledModule")).toEqual(
		-- 			mockReference
		-- 		)
		-- 		expect(runtime:requireModuleOrMock(runtime.__mockSubdirPath, "../../../ManuallyMocked")).toEqual(
		-- 			mockReference
		-- 		)
		-- 		expect(runtime:requireModuleOrMock(runtime.__mockSubdirPath, "/AbsolutePath/Mock")).toEqual(
		-- 			mockReference
		-- 		)
		-- 	end)
		-- end)
		-- ROBLOX deviation END
	end)
	-- ROBLOX deviation START: no upstream

	describe("jest.unmock", function()
		it("unmocks a mocked module", function()
			local mockMeModule = require(mockMeScript)

			expect(mockMeModule.mocked).toBe(true)
			jest.unmock(mockMeScript)

			local mockMeModule2 = require(mockMeScript)
			expect(mockMeModule2.mocked).toBe(false)
		end)
	end)
	-- ROBLOX deviation END
	describe("jest.setMock", function()
		it("uses explicitly set mocks instead of automocking", function()
			return Promise.resolve():andThen(function()
				-- ROBLOX deviation: pass config to runtime new
				local runtime = createRuntime(__filename, JestConfig.projectDefaults):expect()
				local mockReference = { isMock = true }
				local root = runtime:requireModule(runtime.__mockRootPath, rootJsPath) -- Erase module registry because root.js requires most other modules.
				root.jest.resetModules()
				root.jest.setMock(runtime.__mockRootPath.RegularModule, mockReference)
				root.jest.setMock(runtime.__mockRootPath.ManuallyMocked, mockReference)
				expect(runtime:requireModuleOrMock(runtime.__mockRootPath.RegularModule)).toBe(mockReference)
				expect(runtime:requireModuleOrMock(runtime.__mockRootPath.ManuallyMocked)).toBe(mockReference)
			end)
		end)
	end)
end)

return {}
