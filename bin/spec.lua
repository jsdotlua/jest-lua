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
