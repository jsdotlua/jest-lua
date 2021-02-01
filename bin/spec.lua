local Root = script.Parent.JestRoblox.Root

local TestEZ = require(Root.src.TestEZ)

-- Run all tests, collect results, and report to stdout.
TestEZ.TestBootstrap:run(
	{ Root.src.Modules },
	TestEZ.Reporters.TextReporter
)
