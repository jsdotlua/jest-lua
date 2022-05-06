-- ROBLOX NOTE: no upstream
-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox/snapshot-testing

local exports = {}

exports[ [=[formatNodeAssertErrors should format AssertionError with message 1]=] ] = [=[

Table {
  Table {
    "message": "[0mExpected value [0m  [32mnil[39m
[0mReceived:
[0m  [31mnil[39m[0m

Message:
  kaboom[0m

Difference:

[2mCompared values have no visual difference.[22mLoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: deepEqual 1]=] ] = [=[

Table {
  Table {
    "message": "[2massert[22m[2m.deepEqual([22m[31mreceived[39m[2m, [22m[32mexpected[39m[2m)[22m

[0mExpected value to deeply equal to:
[0m  [32m{\"foo\": \"foo\"}[39m
[0mReceived:
[0m  [31m{\"foo\": \"fooBar\"}[39m

Difference:

[32m- Expected[39m
[31m+ Received[39m

[2m  Table {[22m
[32m-   \"foo\": \"foo\",[39m
[31m+   \"foo\": \"fooBar\",[39m
[2m  }[22mLoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: deepStrictEqual 1]=] ] = [=[

Table {
  Table {
    "message": "[2massert[22m[2m.deepStrictEqual([22m[31mreceived[39m[2m, [22m[32mexpected[39m[2m)[22m

[0mExpected value to deeply and strictly equal to:
[0m  [32m{\"foo\": \"foo\"}[39m
[0mReceived:
[0m  [31m{\"foo\": \"fooBar\"}[39m

Difference:

[32m- Expected[39m
[31m+ Received[39m

[2m  Table {[22m
[32m-   \"foo\": \"foo\",[39m
[31m+   \"foo\": \"fooBar\",[39m
[2m  }[22mLoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: notDeepEqual 1]=] ] = [=[

Table {
  Table {
    "message": "[2massert[22m[2m.notDeepEqual([22m[31mreceived[39m[2m, [22m[32mexpected[39m[2m)[22m

[0mExpected value not to deeply equal to:
[0m  [32m{\"foo\": \"foo\"}[39m
[0mReceived:
[0m  [31m{\"foo\": \"foo\"}[39m

Difference:

[2mCompared values have no visual difference.[22mLoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: notDeepEqualUnequal 1]=] ] = [=[

Table {
  Table {
    "message": "[2massert[22m[2m.notDeepEqualUnequal([22m[31mreceived[39m[2m, [22m[32mexpected[39m[2m)[22m

[0mExpected value notDeepEqualUnequal to:
[0m  [32m{\"foo\": \"foo\"}[39m
[0mReceived:
[0m  [31m{\"foo\": \"foo\"}[39m

Difference:

[2mCompared values have no visual difference.[22mLoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: notDeepStrictEqual 1]=] ] = [=[

Table {
  Table {
    "message": "[2massert[22m[2m.notDeepStrictEqual([22m[31mreceived[39m[2m, [22m[32mexpected[39m[2m)[22m

[0mExpected value not to deeply and strictly equal to:
[0m  [32m{\"foo\": \"foo\"}[39m
[0mReceived:
[0m  [31m{\"foo\": \"foo\"}[39m

Difference:

[2mCompared values have no visual difference.[22mLoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: notIdentical 1]=] ] = [=[

Table {
  Table {
    "message": "[2massert[22m[2m.notIdentical([22m[31mreceived[39m[2m, [22m[32mexpected[39m[2m)[22m

[0mExpected value notIdentical to:
[0m  [32m{\"foo\": \"foo\"}[39m
[0mReceived:
[0m  [31m{\"foo\": \"foo\"}[39m

Difference:

[2mCompared values have no visual difference.[22mLoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: notStrictEqual 1]=] ] = [=[

Table {
  Table {
    "message": "[2massert[22m[2m.notStrictEqual([22m[31mreceived[39m[2m, [22m[32mexpected[39m[2m)[22m

[0mExpected value not be strictly equal to:
[0m  [32m{\"foo\": \"foo\"}[39m
[0mReceived:
[0m  [31m{\"foo\": \"foo\"}[39m

Difference:

[2mCompared values have no visual difference.[22mLoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: notStrictEqualObject 1]=] ] = [=[

Table {
  Table {
    "message": "[2massert[22m[2m.notStrictEqualObject([22m[31mreceived[39m[2m, [22m[32mexpected[39m[2m)[22m

[0mExpected value notStrictEqualObject to:
[0m  [32m{\"foo\": \"foo\"}[39m
[0mReceived:
[0m  [31m{\"foo\": \"foo\"}[39m

Difference:

[2mCompared values have no visual difference.[22mLoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: strictEqual 1]=] ] = [=[

Table {
  Table {
    "message": "[2massert[22m[2m.strictEqual([22m[31mreceived[39m[2m, [22m[32mexpected[39m[2m)[22m

[0mExpected value to strictly be equal to:
[0m  [32m{\"foo\": \"foo\"}[39m
[0mReceived:
[0m  [31m{\"foo\": \"fooBar\"}[39m

Difference:

[32m- Expected[39m
[31m+ Received[39m

[2m  Table {[22m
[32m-   \"foo\": \"foo\",[39m
[31m+   \"foo\": \"fooBar\",[39m
[2m  }[22mLoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.",
  },
}
]=]

exports[ [=[formatNodeAssertErrors should format AssertionError with operator: strictEqualObject 1]=] ] = [=[

Table {
  Table {
    "message": "[2massert[22m[2m.strictEqualObject([22m[31mreceived[39m[2m, [22m[32mexpected[39m[2m)[22m

[0mExpected value strictEqualObject to:
[0m  [32m{\"foo\": \"foo\"}[39m
[0mReceived:
[0m  [31m{\"foo\": \"fooBar\"}[39m

Difference:

[32m- Expected[39m
[31m+ Received[39m

[2m  Table {[22m
[32m-   \"foo\": \"foo\",[39m
[31m+   \"foo\": \"fooBar\",[39m
[2m  }[22mLoadedCode.JestRoblox._Workspace.RobloxShared.RobloxShared.",
  },
}
]=]

return exports
