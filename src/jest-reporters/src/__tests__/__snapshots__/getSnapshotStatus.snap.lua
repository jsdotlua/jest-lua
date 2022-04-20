-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-reporters/src/__tests__/__snapshots__/getSnapshotStatus.test.js.snap
local snapshots = {}

snapshots[ [=[Retrieves the snapshot status 1]=] ] = [=[

Table {
  "[1m[32m › 1 snapshot written.[39m[22m",
  "[1m[32m › 1 snapshot updated.[39m[22m",
  "[1m[31m › 1 snapshot failed.[39m[22m",
  "[1m[33m › 1 snapshot obsolete.[39m[22m",
  "	 • test suite with unchecked snapshot",
}
]=]

snapshots[ [=[Retrieves the snapshot status after a snapshot update 1]=] ] = [=[

Table {
  "[1m[32m › 2 snapshots written.[39m[22m",
  "[1m[32m › 2 snapshots updated.[39m[22m",
  "[1m[31m › 2 snapshots failed.[39m[22m",
  "[1m[32m › 2 snapshots removed.[39m[22m",
  "	 • first test suite with unchecked snapshot",
  "	 • second test suite with unchecked snapshot",
  "[1m[32m › snapshot file removed.[39m[22m",
}
]=]

snapshots[ [=[Shows no snapshot updates if all snapshots matched 1]=] ] = "Table {}"

return snapshots
