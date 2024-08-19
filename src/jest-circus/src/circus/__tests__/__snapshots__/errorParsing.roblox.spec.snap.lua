-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox-internal/snapshot-testing
local exports = {}
exports[ [=[formats a string error into proper output with message 1]=] ] = [=[

Table {
  "thrown: \"something went wrong!!\"
Error
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
",
}
]=]

exports[ [=[formats an error object into proper output with message 1]=] ] = [=[

Table {
  "Error
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
",
}
]=]

exports[ [=[formats an error object with a message into proper output with message 1]=] ] = [=[

Table {
  "Error: something went wrong!!
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
",
}
]=]

exports[ [=[formats an error object with a stack and message into proper output with message 1]=] ] = [=[

Table {
  "something went wrong!!
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
",
}
]=]

exports[ [=[formats an error object with only a stack into proper output with message 1]=] ] = [=[

Table {
  "Error: something went wrong!!
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
Redacted.Stack.Trace:1337 function epicDuck
",
}
]=]

return exports
