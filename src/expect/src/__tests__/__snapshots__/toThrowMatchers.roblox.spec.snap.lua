-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox-internal/snapshot-testing

local exports = {}

exports[ [=[Lua toThrowMatcher tests cleans stack trace and prints correct files 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Thrown value: <r>"attempt to perform arithmetic (add) on nil and number"</>

      ReplicatedStorage.node_modules.@jsdotlua.expect.src.__tests__.toThrowMatchers.roblox.spec:163 function func2
      ReplicatedStorage.node_modules.@jsdotlua.expect.src.__tests__.toThrowMatchers.roblox.spec:169
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua AssertionError error 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Error name:    <r>"AssertionError"</>
Error message: <r>""</>

      AssertionError [ERR_ASSERTION]
      ReplicatedStorage.node_modules.@jsdotlua.expect.src.__tests__.toThrowMatchers.roblox.spec:73 function error3
      ReplicatedStorage.node_modules.@jsdotlua.expect.src.__tests__.toThrowMatchers.roblox.spec:77 function test3
      ReplicatedStorage.node_modules.@jsdotlua.expect.src.__tests__.toThrowMatchers.roblox.spec:107
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua Error error 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Error name:    <r>"Error"</>
Error message: <r>""</>

      Error
      ReplicatedStorage.node_modules.@jsdotlua.expect.src.__tests__.toThrowMatchers.roblox.spec:57 function error1
      ReplicatedStorage.node_modules.@jsdotlua.expect.src.__tests__.toThrowMatchers.roblox.spec:65 function test1
      ReplicatedStorage.node_modules.@jsdotlua.expect.src.__tests__.toThrowMatchers.roblox.spec:83
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua string error 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Thrown value: <r>""</>

      ReplicatedStorage.node_modules.@jsdotlua.expect.src.__tests__.toThrowMatchers.roblox.spec:61 function error2
      ReplicatedStorage.node_modules.@jsdotlua.expect.src.__tests__.toThrowMatchers.roblox.spec:69 function test2
      ReplicatedStorage.node_modules.@jsdotlua.expect.src.__tests__.toThrowMatchers.roblox.spec:91
]=]

exports[ [=[Lua toThrowMatcher tests prints the stack trace for Lua string error 2 1]=] ] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected substring: <g>"wrong information"</>
Received value:     <r>""</>

      ReplicatedStorage.node_modules.@jsdotlua.expect.src.__tests__.toThrowMatchers.roblox.spec:61 function error2
      ReplicatedStorage.node_modules.@jsdotlua.expect.src.__tests__.toThrowMatchers.roblox.spec:69 function test2
      ReplicatedStorage.node_modules.@jsdotlua.expect.src.__tests__.toThrowMatchers.roblox.spec:99
]=]

exports[ [=[Lua toThrowMatcher tests toThrow should fail if expected is a string and thrown message is a table 1]=] ] =
	[=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected substring: <g>"string"</>
Received message:   <r>{"key": "value"}</>

]=]

return exports
