-- local Workspace = script.Parent.JestRoblox._Workspace
-- local JestGlobals = require(Workspace.JestGlobals.JestGlobals)

-- local TestEZ = JestGlobals.TestEZ

-- -- Run all tests, collect results, and report to stdout.
-- TestEZ.TestBootstrap:run(
-- 	{ Workspace },
-- 	TestEZ.Reporters.pipe({
-- 		TestEZ.Reporters.JestDefaultReporter,
-- 		TestEZ.Reporters.JestSummaryReporter,
-- 	}),
-- 	{
-- 		extraEnvironment = JestGlobals.testEnv,
-- 	}
-- )
-- -- ROBLOX TODO: after converting jest-runner this should be included there
-- JestGlobals.runtime:teardown()

-- return nil

local Workspace = script.Parent.JestRoblox._Workspace
local runCLI = require(Workspace.JestCore.JestCore).runCLI

local status, result = runCLI(Workspace, {
	verbose = _G.verbose == "true",
	ci = _G.CI == "true",
	updateSnapshot = _G.UPDATESNAPSHOT == "true"
}, { Workspace }):awaitStatus()

if status == "Rejected" then
	print(result)
end

return nil
