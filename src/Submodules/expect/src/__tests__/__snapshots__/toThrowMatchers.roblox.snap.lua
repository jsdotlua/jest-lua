-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox/snapshot-testing

local snapshots = {}

snapshots['Lua toThrowMatcher tests prints the stack trace for Lua Error error 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Error name:    <r>"Error"</>
Error message: <r>""</>

      LoadedCode.JestRoblox.Root.src.Submodules.Expect.__tests__.toThrowMatchers.roblox.spec:45 function error1
      LoadedCode.JestRoblox.Root.src.Submodules.Expect.__tests__.toThrowMatchers.roblox.spec:53 function test1
      LoadedCode.JestRoblox.Root.src.Submodules.Expect.__tests__.toThrowMatchers.roblox.spec:62
]=]

snapshots['Lua toThrowMatcher tests prints the stack trace for Lua string error 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Thrown value: <r>""</>

      LoadedCode.JestRoblox.Root.src.Submodules.Expect.__tests__.toThrowMatchers.roblox.spec:49 function error2
      LoadedCode.JestRoblox.Root.src.Submodules.Expect.__tests__.toThrowMatchers.roblox.spec:57 function test2
      LoadedCode.JestRoblox.Root.src.Submodules.Expect.__tests__.toThrowMatchers.roblox.spec:68
]=]

snapshots['Lua toThrowMatcher tests prints the stack trace for Lua string error 2 1'] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected substring: <g>"wrong information"</>
Received value:     <r>""</>

      LoadedCode.JestRoblox.Root.src.Submodules.Expect.__tests__.toThrowMatchers.roblox.spec:49 function error2
      LoadedCode.JestRoblox.Root.src.Submodules.Expect.__tests__.toThrowMatchers.roblox.spec:57 function test2
      LoadedCode.JestRoblox.Root.src.Submodules.Expect.__tests__.toThrowMatchers.roblox.spec:74
]=]

snapshots['Lua toThrowMatcher tests cleans stack trace and prints correct files 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Thrown value: <r>"attempt to perform arithmetic (add) on nil and number"</>

      LoadedCode.JestRoblox.Root.src.Submodules.Expect.__tests__.toThrowMatchers.roblox.spec:94 function func2
      LoadedCode.JestRoblox.Root.src.Submodules.Expect.__tests__.toThrowMatchers.roblox.spec:99
]=]

return snapshots