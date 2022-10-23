-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox/snapshot-testing
local exports = {}
exports[ [=[.formatExecError() - Promise throw Error 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    kaboom

      LoadedCode.JestRoblox._Workspace.JestMessageUtil.JestMessageUtil.__tests__.messages.roblox.spec:46
      LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
      LoadedCode.JestRoblox._Index.Promise.Promise:160
      LoadedCode.JestRoblox._Index.Promise.Promise:877
      LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
      LoadedCode.JestRoblox._Index.Promise.Promise:262
"
]=]

exports[ [=[.formatExecError() - Promise throw string 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    LoadedCode.JestRoblox._Workspace.JestMessageUtil.JestMessageUtil.__tests__.messages.roblox.spec:31: kaboom

      LoadedCode.JestRoblox._Workspace.JestMessageUtil.JestMessageUtil.__tests__.messages.roblox.spec:31
      LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
      LoadedCode.JestRoblox._Index.Promise.Promise:160
      LoadedCode.JestRoblox._Index.Promise.Promise:877
      LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
      LoadedCode.JestRoblox._Index.Promise.Promise:262
"
]=]

exports[ [=[.formatExecError() - nested Promise throw Error 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    kaboom

      LoadedCode.JestRoblox._Workspace.JestMessageUtil.JestMessageUtil.__tests__.messages.roblox.spec:79
      LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
      LoadedCode.JestRoblox._Index.Promise.Promise:160
      LoadedCode.JestRoblox._Index.Promise.Promise:877
      LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
      LoadedCode.JestRoblox._Index.Promise.Promise:262
"
]=]

exports[ [=[.formatExecError() - nested Promise throw string 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    LoadedCode.JestRoblox._Workspace.JestMessageUtil.JestMessageUtil.__tests__.messages.roblox.spec:62: kaboom

      LoadedCode.JestRoblox._Workspace.JestMessageUtil.JestMessageUtil.__tests__.messages.roblox.spec:62
      LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
      LoadedCode.JestRoblox._Index.Promise.Promise:160
      LoadedCode.JestRoblox._Index.Promise.Promise:877
      LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
      LoadedCode.JestRoblox._Index.Promise.Promise:262
"
]=]

return exports
