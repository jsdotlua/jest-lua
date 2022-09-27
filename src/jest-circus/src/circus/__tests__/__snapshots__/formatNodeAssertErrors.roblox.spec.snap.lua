-- ROBLOX NOTE: no upstream
-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox/snapshot-testing

local exports = {}

exports[ [=[formatNodeAssertErrors should format AssertionError with message 1]=] ] = [=[

Table {
  Table {
    "message": "</>Expected value </>  <green>nil</>
</>Received:</>
</></>  <red>nil</></></>
</></>
</>Message:</>
</>  kaboom</>

Difference:

<dim>Compared values have no visual difference.</>
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.formatNodeAssertErrors.roblox.spec:36
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:345
LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:262
",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: deepEqual 1]=] ] = [=[

Table {
  Table {
    "message": "<dim>assert</><dim>.deepEqual(</><red>received</><dim>, </><green>expected</><dim>)</>

</>Expected value to deeply equal to:</>
</></>  <green>{\"foo\": \"foo\"}</>
</>Received:</>
</></>  <red>{\"foo\": \"fooBar\"}</>

Difference:

<green>- Expected</>
<red>+ Received</>

<dim>  Table {</>
<green>-   \"foo\": \"foo\",</>
<red>+   \"foo\": \"fooBar\",</>
<dim>  }</>
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.formatNodeAssertErrors.roblox.spec:112
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:345
LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:262
",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: deepStrictEqual 1]=] ] = [=[

Table {
  Table {
    "message": "<dim>assert</><dim>.deepStrictEqual(</><red>received</><dim>, </><green>expected</><dim>)</>

</>Expected value to deeply and strictly equal to:</>
</></>  <green>{\"foo\": \"foo\"}</>
</>Received:</>
</></>  <red>{\"foo\": \"fooBar\"}</>

Difference:

<green>- Expected</>
<red>+ Received</>

<dim>  Table {</>
<green>-   \"foo\": \"foo\",</>
<red>+   \"foo\": \"fooBar\",</>
<dim>  }</>
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.formatNodeAssertErrors.roblox.spec:112
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:345
LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:262
",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: notDeepEqual 1]=] ] = [=[

Table {
  Table {
    "message": "<dim>assert</><dim>.notDeepEqual(</><red>received</><dim>, </><green>expected</><dim>)</>

</>Expected value not to deeply equal to:</>
</></>  <green>{\"foo\": \"foo\"}</>
</>Received:</>
</></>  <red>{\"foo\": \"foo\"}</>

Difference:

<dim>Compared values have no visual difference.</>
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.formatNodeAssertErrors.roblox.spec:112
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:345
LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:262
",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: notDeepEqualUnequal 1]=] ] = [=[

Table {
  Table {
    "message": "<dim>assert</><dim>.notDeepEqualUnequal(</><red>received</><dim>, </><green>expected</><dim>)</>

</>Expected value notDeepEqualUnequal to:</>
</></>  <green>{\"foo\": \"foo\"}</>
</>Received:</>
</></>  <red>{\"foo\": \"foo\"}</>

Difference:

<dim>Compared values have no visual difference.</>
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.formatNodeAssertErrors.roblox.spec:112
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:345
LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:262
",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: notDeepStrictEqual 1]=] ] = [=[

Table {
  Table {
    "message": "<dim>assert</><dim>.notDeepStrictEqual(</><red>received</><dim>, </><green>expected</><dim>)</>

</>Expected value not to deeply and strictly equal to:</>
</></>  <green>{\"foo\": \"foo\"}</>
</>Received:</>
</></>  <red>{\"foo\": \"foo\"}</>

Difference:

<dim>Compared values have no visual difference.</>
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.formatNodeAssertErrors.roblox.spec:112
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:345
LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:262
",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: notIdentical 1]=] ] = [=[

Table {
  Table {
    "message": "<dim>assert</><dim>.notIdentical(</><red>received</><dim>, </><green>expected</><dim>)</>

</>Expected value notIdentical to:</>
</></>  <green>{\"foo\": \"foo\"}</>
</>Received:</>
</></>  <red>{\"foo\": \"foo\"}</>

Difference:

<dim>Compared values have no visual difference.</>
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.formatNodeAssertErrors.roblox.spec:112
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:345
LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:262
",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: notStrictEqual 1]=] ] = [=[

Table {
  Table {
    "message": "<dim>assert</><dim>.notStrictEqual(</><red>received</><dim>, </><green>expected</><dim>)</>

</>Expected value not be strictly equal to:</>
</></>  <green>{\"foo\": \"foo\"}</>
</>Received:</>
</></>  <red>{\"foo\": \"foo\"}</>

Difference:

<dim>Compared values have no visual difference.</>
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.formatNodeAssertErrors.roblox.spec:112
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:345
LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:262
",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: notStrictEqualObject 1]=] ] = [=[

Table {
  Table {
    "message": "<dim>assert</><dim>.notStrictEqualObject(</><red>received</><dim>, </><green>expected</><dim>)</>

</>Expected value notStrictEqualObject to:</>
</></>  <green>{\"foo\": \"foo\"}</>
</>Received:</>
</></>  <red>{\"foo\": \"foo\"}</>

Difference:

<dim>Compared values have no visual difference.</>
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.formatNodeAssertErrors.roblox.spec:112
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:345
LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:262
",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: strictEqual 1]=] ] = [=[

Table {
  Table {
    "message": "<dim>assert</><dim>.strictEqual(</><red>received</><dim>, </><green>expected</><dim>)</>

</>Expected value to strictly be equal to:</>
</></>  <green>{\"foo\": \"foo\"}</>
</>Received:</>
</></>  <red>{\"foo\": \"fooBar\"}</>

Difference:

<green>- Expected</>
<red>+ Received</>

<dim>  Table {</>
<green>-   \"foo\": \"foo\",</>
<red>+   \"foo\": \"fooBar\",</>
<dim>  }</>
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.formatNodeAssertErrors.roblox.spec:112
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:345
LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:262
",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: strictEqualObject 1]=] ] = [=[

Table {
  Table {
    "message": "<dim>assert</><dim>.strictEqualObject(</><red>received</><dim>, </><green>expected</><dim>)</>

</>Expected value strictEqualObject to:</>
</></>  <green>{\"foo\": \"foo\"}</>
</>Received:</>
</></>  <red>{\"foo\": \"fooBar\"}</>

Difference:

<green>- Expected</>
<red>+ Received</>

<dim>  Table {</>
<green>-   \"foo\": \"foo\",</>
<red>+   \"foo\": \"fooBar\",</>
<dim>  }</>
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.__tests__.formatNodeAssertErrors.roblox.spec:112
LoadedCode.JestRoblox._Workspace.JestCircus.JestCircus.circus.utils:345
LoadedCode.JestRoblox._Index.Promise.Promise:151 function runExecutor
LoadedCode.JestRoblox._Index.Promise.Promise:262
",
  },
}
]=]

return exports
