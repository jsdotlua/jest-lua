-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox-internal/snapshot-testing
local exports = {}
exports[ [=[formats a string error into proper output with message 1]=] ] = [=[

Table {
  "thrown: \"something went wrong!!\"
Error
ReplicatedStorage.node_modules.@jsdotlua.jest-circus.src.circus.utils:553 function _getError
ReplicatedStorage.node_modules.@jsdotlua.collections.src.Array.map:34
ReplicatedStorage.node_modules.@jsdotlua.jest-circus.src.circus.utils:441 function makeRunResult
ReplicatedStorage.node_modules.@jsdotlua.jest-circus.src.circus.__tests__.errorParsing.roblox.spec:52
ReplicatedStorage.node_modules.@jsdotlua.jest-each.src.bind:168
ReplicatedStorage.node_modules.@jsdotlua.jest-circus.src.circus.utils:367
",
}
]=]

exports[ [=[formats an error object into proper output with message 1]=] ] = [=[

Table {
  "Error
ReplicatedStorage.node_modules.@jsdotlua.jest-circus.src.circus.__tests__.errorParsing.roblox.spec:39
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:2038 function _execModule
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:1436 function _loadModule
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:1278
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:1277 function requireModule
ReplicatedStorage.node_modules.@jsdotlua.jest-circus.src.circus.legacy-code-todo-rewrite.jestAdapter:113
",
}
]=]

exports[ [=[formats an error object with a message into proper output with message 1]=] ] = [=[

Table {
  "Error: something went wrong!!
ReplicatedStorage.node_modules.@jsdotlua.jest-circus.src.circus.__tests__.errorParsing.roblox.spec:40
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:2038 function _execModule
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:1436 function _loadModule
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:1278
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:1277 function requireModule
ReplicatedStorage.node_modules.@jsdotlua.jest-circus.src.circus.legacy-code-todo-rewrite.jestAdapter:113
",
}
]=]

exports[ [=[formats an error object with a stack and message into proper output with message 1]=] ] = [=[

Table {
  "something went wrong!!
ReplicatedStorage.node_modules.@jsdotlua.jest-circus.src.circus.__tests__.errorParsing.roblox.spec:43
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:2038 function _execModule
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:1436 function _loadModule
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:1278
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:1277 function requireModule
ReplicatedStorage.node_modules.@jsdotlua.jest-circus.src.circus.legacy-code-todo-rewrite.jestAdapter:113
",
}
]=]

exports[ [=[formats an error object with only a stack into proper output with message 1]=] ] = [=[

Table {
  "Error: something went wrong!!
ReplicatedStorage.node_modules.@jsdotlua.jest-circus.src.circus.__tests__.errorParsing.roblox.spec:47
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:2038 function _execModule
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:1436 function _loadModule
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:1278
ReplicatedStorage.node_modules.@jsdotlua.jest-runtime.src:1277 function requireModule
ReplicatedStorage.node_modules.@jsdotlua.jest-circus.src.circus.legacy-code-todo-rewrite.jestAdapter:113
",
}
]=]

return exports
