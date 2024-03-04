local runCLI = require("@pkg/@jsdotlua/jest").runCLI

local processServiceExists, ProcessService = pcall(function()
	return game:GetService("ProcessService")
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local status, result = runCLI(ReplicatedStorage, {
	verbose = if _G.verbose == "true" then true else nil,
	ci = true,
	-- updateSnapshot = _G.UPDATESNAPSHOT == "true",
}, { ReplicatedStorage }):awaitStatus()

if status == "Rejected" then
	print(result)
end

if status == "Resolved" and result.results.numFailedTestSuites == 0 and result.results.numFailedTests == 0 then
	if processServiceExists then
		ProcessService:ExitAsync(0)
	end
end

if processServiceExists then
	ProcessService:ExitAsync(1)
end

return nil
