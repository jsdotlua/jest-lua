-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-reporters/src/__tests__/__snapshots__/getSnapshotStatus.test.js.snap
local exports = {}

exports[ [=[Retrieves the snapshot status 1]=] ] = [=[

Table {
  "<bold><green> › 1 snapshot written.</></>",
  "<bold><green> › 1 snapshot updated.</></>",
  "<bold><red> › 1 snapshot failed.</></>",
  "<bold><yellow> › 1 snapshot obsolete.</></>",
  "	 • test suite with unchecked snapshot",
}
]=]
exports[ [=[Retrieves the snapshot status after a snapshot update 1]=] ] = [=[

Table {
  "<bold><green> › 2 snapshots written.</></>",
  "<bold><green> › 2 snapshots updated.</></>",
  "<bold><red> › 2 snapshots failed.</></>",
  "<bold><green> › 2 snapshots removed.</></>",
  "	 • first test suite with unchecked snapshot",
  "	 • second test suite with unchecked snapshot",
  "<bold><green> › snapshot file removed.</></>",
}
]=]
exports[ [=[Shows no snapshot updates if all snapshots matched 1]=] ] = "Table {}"

return exports
