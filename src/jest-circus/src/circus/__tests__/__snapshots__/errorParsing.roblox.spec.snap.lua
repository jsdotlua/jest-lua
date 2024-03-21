-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox-internal/snapshot-testing
local exports = {}
exports[ [=[formats a string error into proper output with message 1]=] ] = [=[

Table {
  "thrown: \"something went wrong!!\"
Error
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:555 function _getError
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:443 function makeRunResult
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.errorParsing.roblox.spec:56
LoadedCode.JestRoblox._Workspace.JestEach.JestEach.bind:170
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:369
",
}
]=]

exports[ [=[formats an error object into proper output with message 1]=] ] = [=[

Table {
  "Error
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.errorParsing.roblox.spec:43
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1999 function _execModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1400 function _loadModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1246
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1245 function requireModule
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.legacy-code-todo-rewrite.jestAdapter:114
",
}
]=]

exports[ [=[formats an error object with a message into proper output with message 1]=] ] = [=[

Table {
  "Error: something went wrong!!
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.errorParsing.roblox.spec:44
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1999 function _execModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1400 function _loadModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1246
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1245 function requireModule
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.legacy-code-todo-rewrite.jestAdapter:114
",
}
]=]

exports[ [=[formats an error object with a stack and message into proper output with message 1]=] ] = [=[

Table {
  "something went wrong!!
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.errorParsing.roblox.spec:47
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1999 function _execModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1400 function _loadModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1246
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1245 function requireModule
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.legacy-code-todo-rewrite.jestAdapter:114
",
}
]=]

exports[ [=[formats an error object with only a stack into proper output with message 1]=] ] = [=[

Table {
  "Error: something went wrong!!
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.errorParsing.roblox.spec:51
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1999 function _execModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1400 function _loadModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1246
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1245 function requireModule
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.legacy-code-todo-rewrite.jestAdapter:114
",
}
]=]

return exports
