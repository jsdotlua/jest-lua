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

return nil
