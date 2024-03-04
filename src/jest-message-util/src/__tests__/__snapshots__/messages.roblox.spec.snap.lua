-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox-internal/snapshot-testing
local exports = {}
exports[ [=[.formatExecError() - Promise throw Error 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    kaboom

      ReplicatedStorage.node_modules.@jsdotlua.jest-message-util.src.__tests__.messages.roblox.spec:47
"
]=]

exports[ [=[.formatExecError() - Promise throw string 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    ReplicatedStorage.node_modules.@jsdotlua.jest-message-util.src.__tests__.messages.roblox.spec:32: kaboom

      ReplicatedStorage.node_modules.@jsdotlua.jest-message-util.src.__tests__.messages.roblox.spec:32
"
]=]

exports[ [=[.formatExecError() - nested Promise throw Error 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    kaboom

      ReplicatedStorage.node_modules.@jsdotlua.jest-message-util.src.__tests__.messages.roblox.spec:80
"
]=]

exports[ [=[.formatExecError() - nested Promise throw string 1]=] ] = [=[

"  <bold>● </>Test suite failed to run

    ReplicatedStorage.node_modules.@jsdotlua.jest-message-util.src.__tests__.messages.roblox.spec:63: kaboom

      ReplicatedStorage.node_modules.@jsdotlua.jest-message-util.src.__tests__.messages.roblox.spec:63
"
]=]

return exports
