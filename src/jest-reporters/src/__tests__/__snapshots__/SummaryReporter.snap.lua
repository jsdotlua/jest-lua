-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-reporters/src/__tests__/__snapshots__/SummaryReporter.test.js.snap
-- Jest Snapshot v1, https://goo.gl/fbAQLP
local snapshots = {}

snapshots[tostring("snapshots all have results (after update) 1")] = [[

"[1mSnapshot Summary[22m
[1m[32m › 1 snapshot written [39m[22mfrom 1 test suite.
[1m[31m › 1 snapshot failed[39m[22m from 1 test suite. [2mInspect your code changes or run `yarn test -u` to update them.[22m
[1m[32m › 1 snapshot updated [39m[22mfrom 1 test suite.
[1m[32m › 1 snapshot file removed [39m[22mfrom 1 test suite.
[1m[32m › 1 snapshot removed [39m[22mfrom 1 test suite.
   ↳ [2mpath/to/[22m[1msuite_one[22m
     • unchecked snapshot 1

[1mTest Suites: [22m[1m[31m1 failed[39m[22m, 1 total
[1mTests:       [22m[1m[31m1 failed[39m[22m, 1 total
[1mSnapshots:   [22m[1m[31m1 failed[39m[22m, [1m[32m1 removed[39m[22m, [1m[32m1 file removed[39m[22m, [1m[32m1 updated[39m[22m, [1m[32m1 written[39m[22m, [1m[32m2 passed[39m[22m, 2 total
[1mTime:[22m        0.01 s
[2mRan all test suites[22m[2m.[22m
"
]]

snapshots[tostring("snapshots all have results (no update) 1")] = [[

"[1mSnapshot Summary[22m
[1m[32m › 1 snapshot written [39m[22mfrom 1 test suite.
[1m[31m › 1 snapshot failed[39m[22m from 1 test suite. [2mInspect your code changes or run `yarn test -u` to update them.[22m
[1m[32m › 1 snapshot updated [39m[22mfrom 1 test suite.
[1m[33m › 1 snapshot file obsolete [39m[22mfrom 1 test suite. [2mTo remove it, run `yarn test -u`.[22m
[1m[33m › 1 snapshot obsolete [39m[22mfrom 1 test suite. [2mTo remove it, run `yarn test -u`.[22m
   ↳ [2mpath/to/[22m[1msuite_one[22m
     • unchecked snapshot 1

[1mTest Suites: [22m[1m[31m1 failed[39m[22m, 1 total
[1mTests:       [22m[1m[31m1 failed[39m[22m, 1 total
[1mSnapshots:   [22m[1m[31m1 failed[39m[22m, [1m[33m1 obsolete[39m[22m, [1m[33m1 file obsolete[39m[22m, [1m[32m1 updated[39m[22m, [1m[32m1 written[39m[22m, [1m[32m2 passed[39m[22m, 2 total
[1mTime:[22m        0.01 s
[2mRan all test suites[22m[2m.[22m
"
]]

snapshots[tostring("snapshots needs update with npm test 1")] = [[

"[1mSnapshot Summary[22m
[1m[31m › 2 snapshots failed[39m[22m from 1 test suite. [2mInspect your code changes or run `npm test -- -u` to update them.[22m

[1mTest Suites: [22m[1m[31m1 failed[39m[22m, 1 total
[1mTests:       [22m[1m[31m1 failed[39m[22m, 1 total
[1mSnapshots:   [22m[1m[31m2 failed[39m[22m, 2 total
[1mTime:[22m        0.01 s
[2mRan all test suites[22m[2m.[22m
"
]]

snapshots[tostring("snapshots needs update with yarn test 1")] = [[

"[1mSnapshot Summary[22m
[1m[31m › 2 snapshots failed[39m[22m from 1 test suite. [2mInspect your code changes or run `yarn test -u` to update them.[22m

[1mTest Suites: [22m[1m[31m1 failed[39m[22m, 1 total
[1mTests:       [22m[1m[31m1 failed[39m[22m, 1 total
[1mSnapshots:   [22m[1m[31m2 failed[39m[22m, 2 total
[1mTime:[22m        0.01 s
[2mRan all test suites[22m[2m.[22m
"
]]

return snapshots
