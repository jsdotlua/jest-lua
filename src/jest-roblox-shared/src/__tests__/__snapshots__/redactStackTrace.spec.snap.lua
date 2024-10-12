-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox-internal/snapshot-testing
local exports = {}
exports[ [=[stack traces should stay the same in snapshots 1]=] ] = [=[

"Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck"
]=]

exports[ [=[stack traces should stay the same in snapshots 2]=] ] = [=[

"Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck"
]=]

return exports
