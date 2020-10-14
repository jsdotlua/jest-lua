local Root = script.Parent.TestEZ

local TestEZ = require(Root.Packages.TestEZ)

-- Run all tests, collect results, and report to stdout.
TestEZ.TestBootstrap:run(
	{ Root.Modules },
	TestEZ.Reporters.TextReporter
)
