local Workspace = script.Parent.JestRoblox._Workspace
local JestGlobals = require(Workspace.JestGlobals.JestGlobals)

local TestEZ = JestGlobals.TestEZ

-- Run all tests, collect results, and report to stdout.
TestEZ.TestBootstrap:run(
	{ Workspace },
	TestEZ.Reporters.pipe({
		TestEZ.Reporters.JestDefaultReporter,
		TestEZ.Reporters.JestSummaryReporter,
	}),
	{
		extraEnvironment = JestGlobals.testEnv,
	}
)
-- ROBLOX TODO: after converting jest-runner this should be included there
JestGlobals.runtime:teardown()

return nil
