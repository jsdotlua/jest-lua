-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox-internal/snapshot-testing
local exports = {}
exports[ [=[.formatExecError() - Promise throw Error 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    kaboom

      LoadedCode.JestRoblox._Workspace.JestMessageUtil.JestMessageUtil.__tests__.messages.roblox.spec:49
"
]=]

exports[ [=[.formatExecError() - Promise throw string 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    LoadedCode.JestRoblox._Workspace.JestMessageUtil.JestMessageUtil.__tests__.messages.roblox.spec:34: kaboom

      LoadedCode.JestRoblox._Workspace.JestMessageUtil.JestMessageUtil.__tests__.messages.roblox.spec:34
"
]=]

exports[ [=[.formatExecError() - nested Promise throw Error 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    kaboom

      LoadedCode.JestRoblox._Workspace.JestMessageUtil.JestMessageUtil.__tests__.messages.roblox.spec:82
"
]=]

exports[ [=[.formatExecError() - nested Promise throw string 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    LoadedCode.JestRoblox._Workspace.JestMessageUtil.JestMessageUtil.__tests__.messages.roblox.spec:65: kaboom

      LoadedCode.JestRoblox._Workspace.JestMessageUtil.JestMessageUtil.__tests__.messages.roblox.spec:65
"
]=]

return exports
