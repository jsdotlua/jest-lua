-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-reporters/src/__tests__/__snapshots__/getSnapshotSummary.test.js.snap
-- Jest Snapshot v1, https://goo.gl/fbAQLP
local snapshots = {}

snapshots[tostring("creates a snapshot summary 1")] = [[

"[1mSnapshot Summary[22m
[1m[32m › 1 snapshot written [39m[22mfrom 1 test suite.
[1m[31m › 1 snapshot failed[39m[22m from 1 test suite. [2mInspect your code changes or press --u to update them.[22m
[1m[32m › 1 snapshot updated [39m[22mfrom 1 test suite.
[1m[33m › 1 snapshot file obsolete [39m[22mfrom 1 test suite. [2mTo remove it, press --u.[22m
[1m[33m › 1 snapshot obsolete [39m[22mfrom 1 test suite. [2mTo remove it, press --u.[22m
   ↳ [2mpath/to/[22m[1msuite_one[22m
     • unchecked snapshot 1"
]]

snapshots[tostring("creates a snapshot summary after an update 1")] = [[

"[1mSnapshot Summary[22m
[1m[32m › 1 snapshot written [39m[22mfrom 1 test suite.
[1m[31m › 1 snapshot failed[39m[22m from 1 test suite. [2mInspect your code changes or press --u to update them.[22m
[1m[32m › 1 snapshot updated [39m[22mfrom 1 test suite.
[1m[32m › 1 snapshot file removed [39m[22mfrom 1 test suite.
[1m[32m › 1 snapshot removed [39m[22mfrom 1 test suite.
   ↳ [2mpath/to/[22m[1msuite_one[22m
     • unchecked snapshot 1"
]]

snapshots[tostring("creates a snapshot summary with multiple snapshot being written/updated 1")] = [[

"[1mSnapshot Summary[22m
[1m[32m › 2 snapshots written [39m[22mfrom 2 test suites.
[1m[31m › 2 snapshots failed[39m[22m from 2 test suites. [2mInspect your code changes or press --u to update them.[22m
[1m[32m › 2 snapshots updated [39m[22mfrom 2 test suites.
[1m[33m › 2 snapshot files obsolete [39m[22mfrom 2 test suites. [2mTo remove them all, press --u.[22m
[1m[33m › 2 snapshots obsolete [39m[22mfrom 2 test suites. [2mTo remove them all, press --u.[22m
   ↳ [2mpath/to/[22m[1msuite_one[22m
     • unchecked snapshot 1
   ↳ [2mpath/to/[22m[1msuite_two[22m
     • unchecked snapshot 2"
]]

snapshots[tostring("returns nothing if there are no updates 1")] = '"[1mSnapshot Summary[22m"'

return snapshots
