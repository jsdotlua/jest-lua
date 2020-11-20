local Root = script.Parent.JestRoblox

local TestEZ = require(Root.TestEZ)

-- Run all tests, collect results, and report to stdout.
TestEZ.TestBootstrap:run(
	{ Root.Modules },
	TestEZ.Reporters.TextReporter
)
