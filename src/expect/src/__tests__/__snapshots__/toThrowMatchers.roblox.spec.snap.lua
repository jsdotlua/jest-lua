-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox/snapshot-testing

local exports = {}

exports[ [=[Lua toThrowMatcher tests cleans stack trace and prints correct files 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Thrown value: <r>"attempt to perform arithmetic (add) on nil and number"</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:131 function func2
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:137
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua AssertionError error 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Error name:    <r>"AssertionError"</>
Error message: <r>""</>

      LoadedCode.JestRoblox._Index.LuauPolyfill.LuauPolyfill.AssertionError.AssertionError:397 function new
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:66 function error3
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:70 function test3
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:100
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua Error error 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Error name:    <r>"Error"</>
Error message: <r>""</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:50 function error1
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:58 function test1
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:76
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua string error 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Thrown value: <r>""</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:54 function error2
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:62 function test2
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:84
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua string error 2 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected substring: <g>"wrong information"</>
Received value:     <r>""</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:54 function error2
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:62 function test2
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.roblox.spec:92
]=]

exports[ [=[Lua toThrowMatcher tests toThrow should fail if expected is a string and thrown message is a table 1]=] ] =
	[=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected substring: <g>"string"</>
Received message:   <r>{"key": "value"}</>

]=]

return exports
