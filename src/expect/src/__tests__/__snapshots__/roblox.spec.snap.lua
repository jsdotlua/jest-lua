-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox/snapshot-testing
local exports = {}
exports[ [=[assertions & hasAssertions assertions fails 1]=] ] = [=[

"<dim>expect.assertions(</><green>4</><dim>)</>

Expected <green>four assertions</> to be called but received <red>three assertion calls</>."
]=]

exports[ [=[assertions & hasAssertions assertions fails 2]=] ] = [=[

"Error: <dim>expect.assertions(</><green>4</><dim>)</>

Expected <green>four assertions</> to be called but received <red>three assertion calls</>.
LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.roblox.spec:44
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:369
LoadedCode.JestRoblox._Index.Promise.Promise:172 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:299
"
]=]

exports[ [=[assertions & hasAssertions hasAssertions fails 1]=] ] = [=[

"<dim>expect.hasAssertions()</>

Expected <green>at least one assertion</> to be called but <red>received none</>."
]=]

exports[ [=[assertions & hasAssertions hasAssertions fails 2]=] ] = [=[

"Error: <dim>expect.hasAssertions()</>

Expected <green>at least one assertion</> to be called but <red>received none</>.
LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.roblox.spec:69
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:369
LoadedCode.JestRoblox._Index.Promise.Promise:172 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:299
"
]=]

return exports
