local Workspace = script.Parent.JestRoblox._Workspace
local runCLI = require(Workspace.JestCore.JestCore).runCLI

local status, err = runCLI(Workspace, {}, { Workspace }):awaitStatus()

print(status)
print(err)

return nil
