-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox/snapshot-testing

local exports = {}

exports[ [=[tests stack traces for calls within pcalls 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Error name:    <r>"Error"</>
Error message: <r>"<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- shallow equality</>

Expected: <g>2</>
Received: <r>4</>"</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.matchers.roblox.spec:91
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.matchers.roblox.spec:80
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.matchers.roblox.spec:79
      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.matchers.roblox.spec:90
]=]

return exports