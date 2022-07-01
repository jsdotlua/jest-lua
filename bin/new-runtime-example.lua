local Workspace = script.Parent.JestRoblox._Workspace
local TestRunner = require(Workspace.JestRunner.JestRunner).default
local makeProjectConfig = require(Workspace.TestUtils.TestUtils).makeProjectConfig

local TestWatcher = {}
TestWatcher.__index = TestWatcher

function TestWatcher.new(...): any
	return setmetatable({}, TestWatcher)
end

function TestWatcher:isInterrupted()
	return false
end

local globalConfig = { maxWorkers = 2, watch = false, maxConcurrency = 1 }
local config = makeProjectConfig({ rootDir = "/path/" })
local context = { config = config }
local runner = TestRunner.new(globalConfig :: any)

runner:on("test-file-start", function(event)
	local test = event[1]
	print("test file start", test.path.Name)
end)
runner:on("test-file-success", function(event)
	local test, testResult = table.unpack(event, 1, 2)
	print("test file success", test.path.Name)
end)
runner:on("test-file-failure", function(event)
	local test, err = table.unpack(event, 1, 2)
	print("test file failure", test.path.Name)
end)
runner:on("test-case-result", function(event)
	local testPath, testCaseResult = table.unpack(event, 1, 2)
	print("test case result", testPath.Name, testCaseResult.fullName, testCaseResult.status)
end)

runner
	:runTests({
		{
			context = context :: any,
			path = Workspace.JestRunner.JestRunner.__tests__["tmp.test"],
		},
		{
			context = context :: any,
			path = Workspace.JestRunner.JestRunner.__tests__["tmp2.test"],
		},
	}, TestWatcher.new({ isWatchMode = globalConfig.watch }), nil, nil, nil, { serial = true })
	:expect()

return nil
