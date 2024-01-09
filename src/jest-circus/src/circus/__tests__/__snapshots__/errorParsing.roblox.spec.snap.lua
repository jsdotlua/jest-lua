-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox/snapshot-testing
local exports = {}
exports[ [=[formats a string error into proper output with message 1]=] ] = [=[

Table {
  "thrown: \"something went wrong!!\"
Error
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:555 function _getError
LoadedCode.JestRoblox._Index.Collections.Collections.Array.map:50
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:443 function makeRunResult
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.errorParsing.roblox.spec:53
LoadedCode.JestRoblox._Workspace.JestEach.JestEach.bind:170
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:369
LoadedCode.JestRoblox._Index.Promise.Promise:172 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:299
",
}
]=]

exports[ [=[formats an error object into proper output with message 1]=] ] = [=[

Table {
  "Error
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.errorParsing.roblox.spec:40
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:2039 function _execModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1437 function _loadModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1279
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1278 function requireModule
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.legacy-code-todo-rewrite.jestAdapter:114
LoadedCode.JestRoblox._Index.Promise.Promise:172 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:181
LoadedCode.JestRoblox._Index.Promise.Promise:1245
LoadedCode.JestRoblox._Index.Promise.Promise:172 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:299
",
}
]=]

exports[ [=[formats an error object with a message into proper output with message 1]=] ] = [=[

Table {
  "Error: something went wrong!!
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.errorParsing.roblox.spec:41
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:2039 function _execModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1437 function _loadModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1279
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1278 function requireModule
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.legacy-code-todo-rewrite.jestAdapter:114
LoadedCode.JestRoblox._Index.Promise.Promise:172 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:181
LoadedCode.JestRoblox._Index.Promise.Promise:1245
LoadedCode.JestRoblox._Index.Promise.Promise:172 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:299
",
}
]=]

exports[ [=[formats an error object with a stack and message into proper output with message 1]=] ] = [=[

Table {
  "something went wrong!!
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.errorParsing.roblox.spec:44
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:2039 function _execModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1437 function _loadModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1279
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1278 function requireModule
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.legacy-code-todo-rewrite.jestAdapter:114
LoadedCode.JestRoblox._Index.Promise.Promise:172 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:181
LoadedCode.JestRoblox._Index.Promise.Promise:1245
LoadedCode.JestRoblox._Index.Promise.Promise:172 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:299
",
}
]=]

exports[ [=[formats an error object with only a stack into proper output with message 1]=] ] = [=[

Table {
  "Error: something went wrong!!
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.errorParsing.roblox.spec:48
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:2039 function _execModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1437 function _loadModule
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1279
LoadedCode.JestRoblox._Workspace.JestRuntime.JestRuntime:1278 function requireModule
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.legacy-code-todo-rewrite.jestAdapter:114
LoadedCode.JestRoblox._Index.Promise.Promise:172 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:181
LoadedCode.JestRoblox._Index.Promise.Promise:1245
LoadedCode.JestRoblox._Index.Promise.Promise:172 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:299
",
}
]=]

return exports
