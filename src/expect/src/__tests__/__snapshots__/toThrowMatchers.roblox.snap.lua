-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox/snapshot-testing

local snapshots = {}

snapshots['Lua toThrowMatcher tests prints the stack trace for Lua Error error 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Error name:    <r>"Error"</>
Error message: <r>""</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:42 function error1
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:50 function test1
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:59
]=]

snapshots['Lua toThrowMatcher tests prints the stack trace for Lua string error 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Thrown value: <r>""</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:46 function error2
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:54 function test2
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:65
]=]

snapshots['Lua toThrowMatcher tests prints the stack trace for Lua string error 2 1'] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected substring: <g>"wrong information"</>
Received value:     <r>""</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:46 function error2
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:54 function test2
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:71
]=]

snapshots['Lua toThrowMatcher tests cleans stack trace and prints correct files 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Thrown value: <r>"attempt to perform arithmetic (add) on nil and number"</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:91 function func2
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:96
]=]

return snapshots