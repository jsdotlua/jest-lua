-- ROBLOX NOTE: no upstream
-- ROBLOX deviation: this file is not aligned with upstream version

local Packages = script.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object

local Jest = require(Packages.Jest)
local testEnv = Jest.testEnv
local runtime = Jest.runtime

local TestEZ = require(Packages.TestEZ)
local TestEZJestAdapter = require(Packages.TestEZJestAdapter)

type Jest = any
local importedExpect = require(Packages.Expect)

type JestGlobals = {
	jest: Jest,
	expect: typeof(importedExpect),

	jestSnapshot: {
		toMatchSnapshot: (...any) -> any,
		toThrowErrorMatchingSnapshot: (...any) -> any,
	},
	testEnv: typeof(testEnv),
	runtime: typeof(runtime),
	TestEZ: typeof(TestEZ) & {
		reporters: typeof(TestEZ.Reporters) & typeof(TestEZJestAdapter.Reporters),
	},
}

return (
		{
			testEnv = testEnv,
			runtime = runtime,
			TestEZ = Object.assign({}, TestEZ, {
				Reporters = Object.assign({}, TestEZ.Reporters, TestEZJestAdapter.Reporters),
			}),
		} :: any
	) :: JestGlobals
