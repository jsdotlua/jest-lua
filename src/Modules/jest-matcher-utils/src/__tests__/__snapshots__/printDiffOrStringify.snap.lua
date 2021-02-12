-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/jest-matcher-utils/src/__tests__/__snapshots__/printDiffOrStringify.test.ts.snap

--[[
    deviation: Many of the tests have their outputs rearranged (while
    maintaining the same contents) to align with the output order in Lua

    deviation: edited several of the following snapshots to use 'Table' in
    place of 'Object' and 'Array'
]]
local snapshots = {}

snapshots["printDiffOrStringify asymmetricMatcher array 1"] = [[
- Expected  - 1
+ Received  + 1

  Table {
    1,
    Any<number>,
-   3,
+   2,
  }]]

snapshots["printDiffOrStringify asymmetricMatcher circular array 1"] = [[
- Expected  - 1
+ Received  + 1

  Table {
    1,
    Any<number>,
-   3,
+   2,
    [Circular],
  }]]

-- deviation: The original snapshot had another level of information for the
-- "circular" reference rather than immediately saying it was Circular:
-- https://github.com/facebook/jest/blob/v26.5.3/packages/jest-matcher-utils/src/__tests__/__snapshots__/printDiffOrStringify.test.ts.snap#L37
-- However, in our implementation Maps and Objects are treated identically so
-- circular would be printed at the surface level in both cases
snapshots["printDiffOrStringify asymmetricMatcher circular map 1"] = [[
- Expected  - 1
+ Received  + 1

  Table {
    "a": 1,
    "b": Any<number>,
-   "c": 3,
+   "c": 2,
    "circular": [Circular],
  }]]

snapshots["printDiffOrStringify asymmetricMatcher circular object 1"] = [[
- Expected  - 1
+ Received  + 1

  Table {
    "a": [Circular],
    "b": Any<number>,
-   "c": 3,
+   "c": 2,
  }]]

snapshots["printDiffOrStringify asymmetricMatcher custom asymmetricMatcher 1"] = [[
- Expected  - 1
+ Received  + 1

  Object {
    "a": equal5<>,
-   "b": false,
+   "b": true,
  }
]]

-- deviation: test modified from having a Symbol as a key to having "h" as a
-- key, with "h" mapping to a table which in turn holds the original symbol.
-- This was done to prevent indeterministic output order in Lua
snapshots["printDiffOrStringify asymmetricMatcher jest asymmetricMatcher 1"] = [[
- Expected  - 1
+ Received  + 1

  Table {
    "a": Any<number>,
    "b": Anything,
    "c": ArrayContaining [
      1,
      3,
    ],
    "d": StringContaining "jest",
    "e": StringMatching "jest",
    "f": ObjectContaining {
      "a": Any<DateTime>,
    },
-   "g": true,
+   "g": false,
    "h": Table {
      Symbol(h): Any<string>,
    },
  }]]

snapshots["printDiffOrStringify asymmetricMatcher map 1"] = [[
- Expected  - 1
+ Received  + 1

  Table {
    "a": 1,
    "b": Any<number>,
-   "c": 3,
+   "c": 2,
  }]]

snapshots["printDiffOrStringify asymmetricMatcher minimal test 1"] = [[
- Expected  - 1
+ Received  + 1

  Table {
    "a": Any<number>,
-   "b": 2,
+   "b": 1,
  }]]

snapshots["printDiffOrStringify asymmetricMatcher nested object 1"] = [[
- Expected  - 1
+ Received  + 1

  Table {
    "a": Any<number>,
    "b": Table {
      "a": 1,
      "b": Any<number>,
    },
-   "c": 2,
+   "c": 1,
  }]]

snapshots["printDiffOrStringify asymmetricMatcher object in array 1"] = [[
- Expected  - 1
+ Received  + 1

  Table {
    1,
    Table {
      "a": 1,
      "b": Any<number>,
    },
-   3,
+   2,
  }]]

snapshots["printDiffOrStringify asymmetricMatcher transitive circular 1"] = [[
- Expected  - 1
+ Received  + 1

  Table {
-   "a": 3,
+   "a": 2,
    "nested": Table {
      "b": Any<number>,
      "parent": [Circular],
    },
  }]]

snapshots["printDiffOrStringify expected and received are multi line with trailing spaces 1"] = [[
- Expected  - 3
+ Received  + 3

- delete 
+ insert 
- common expected common
+ common received common
- prev 
+ next ]]

snapshots["printDiffOrStringify expected and received are single line with multiple changes 1"] = [[
Expected: "delete common expected common prev"
Received: "insert common received common next"]]

snapshots["printDiffOrStringify expected is empty and received is single line 1"] = [[
Expected: ""
Received: "single line"]]

snapshots["printDiffOrStringify expected is multi line and received is empty 1"] = [[
Expected: "multi
line"
Received: ""]]

snapshots["printDiffOrStringify has no common after clean up chaff multiline 1"] = [[
- Expected  - 2
+ Received  + 2

- delete
- two
+ insert
+ 2]]

snapshots["printDiffOrStringify has no common after clean up chaff one-line 1"] = [[
Expected: "delete"
Received: "insert"]]

snapshots["printDiffOrStringify object contain readonly symbol key object 1"] = [[
- Expected  - 1
+ Received  + 1

  Table {
    "a": Symbol(key),
-   "b": 2,
+   "b": 1,
  }]]

return snapshots