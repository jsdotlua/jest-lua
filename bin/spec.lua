local Root = script.Parent.JestRoblox.Root
local Modules = Root.src.Submodules

local Jest = require(Modules.Jest)

local TestEZ = require(Root.src.TestEZ)

-- Run all tests, collect results, and report to stdout.
TestEZ.TestBootstrap:run(
	{ Modules },
	TestEZ.Reporters.TextReporter,
	{ extraEnvironment = Jest.testEnv }
)
