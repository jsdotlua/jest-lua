-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/jest-matcher-utils/src/__tests__/__snapshots__/printDiffOrStringify.test.ts.snap

--[=[
    deviation: Many of the tests have their outputs rearranged (while
    maintaining the same contents) to align with the output order in Lua

    deviation: edited several of the following snapshots to use 'Table' in
    place of 'Object' and 'Array'
]=]

local snapshots = {}

snapshots["printDiffOrStringify asymmetricMatcher array 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    1,</>
<d>    Any<number>,</>
<g>-   3,</>
<r>+   2,</>
<d>  }</>
]=]

snapshots["printDiffOrStringify asymmetricMatcher circular array 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    1,</>
<d>    Any<number>,</>
<g>-   3,</>
<r>+   2,</>
<d>    [Circular],</>
<d>  }</>
]=]

-- deviation: The original snapshot had another level of information for the
-- "circular" reference rather than immediately saying it was Circular:
-- https://github.com/facebook/jest/blob/v26.5.3/packages/jest-matcher-utils/src/__tests__/__snapshots__/printDiffOrStringify.test.ts.snap#L37
-- However, in our implementation Maps and Objects are treated identically so
-- circular would be printed at the surface level in both cases
snapshots["printDiffOrStringify asymmetricMatcher circular map 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    "a": 1,</>
<d>    "b": Any<number>,</>
<g>-   "c": 3,</>
<r>+   "c": 2,</>
<d>    "circular": [Circular],</>
<d>  }</>
]=]

snapshots["printDiffOrStringify asymmetricMatcher circular object 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    "a": [Circular],</>
<d>    "b": Any<number>,</>
<g>-   "c": 3,</>
<r>+   "c": 2,</>
<d>  }</>
]=]

snapshots["printDiffOrStringify asymmetricMatcher custom asymmetricMatcher 1"] = [=[

- Expected  - 1
+ Received  + 1

  Object {
    "a": equal5<>,
-   "b": false,
+   "b": true,
  }

]=]

-- deviation: test modified from having a Symbol as a key to having "h" as a
-- key, with "h" mapping to a table which in turn holds the original symbol.
-- This was done to prevent indeterministic output order in Lua
snapshots["printDiffOrStringify asymmetricMatcher jest asymmetricMatcher 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    "a": Any<number>,</>
<d>    "b": Anything,</>
<d>    "c": ArrayContaining {</>
<d>      1,</>
<d>      3,</>
<d>    },</>
<d>    "d": StringContaining "jest",</>
<d>    "e": StringMatching "jest",</>
<d>    "f": ObjectContaining {</>
<d>      "a": Any<DateTime>,</>
<d>    },</>
<g>-   "g": true,</>
<r>+   "g": false,</>
<d>    "h": Table {</>
<d>      Symbol(h): Any<string>,</>
<d>    },</>
<d>  }</>
]=]

snapshots["printDiffOrStringify asymmetricMatcher map 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    "a": 1,</>
<d>    "b": Any<number>,</>
<g>-   "c": 3,</>
<r>+   "c": 2,</>
<d>  }</>
]=]

snapshots["printDiffOrStringify asymmetricMatcher minimal test 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    "a": Any<number>,</>
<g>-   "b": 2,</>
<r>+   "b": 1,</>
<d>  }</>
]=]

snapshots["printDiffOrStringify asymmetricMatcher nested object 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    "a": Any<number>,</>
<d>    "b": Table {</>
<d>      "a": 1,</>
<d>      "b": Any<number>,</>
<d>    },</>
<g>-   "c": 2,</>
<r>+   "c": 1,</>
<d>  }</>
]=]

snapshots["printDiffOrStringify asymmetricMatcher object in array 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    1,</>
<d>    Table {</>
<d>      "a": 1,</>
<d>      "b": Any<number>,</>
<d>    },</>
<g>-   3,</>
<r>+   2,</>
<d>  }</>
]=]

snapshots["printDiffOrStringify asymmetricMatcher transitive circular 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "a": 3,</>
<r>+   "a": 2,</>
<d>    "nested": Table {</>
<d>      "b": Any<number>,</>
<d>      "parent": [Circular],</>
<d>    },</>
<d>  }</>
]=]

snapshots["printDiffOrStringify expected and received are multi line with trailing spaces 1"] = [=[

<g>- Expected  - 3</>
<r>+ Received  + 3</>

<g>- <i>delete</i><Y> </></>
<r>+ <i>insert</i><Y> </></>
<g>- common <i>expect</i>ed common</>
<r>+ common <i>receiv</i>ed common</>
<g>- <i>prev</i><Y> </></>
<r>+ <i>next</i><Y> </></>
]=]

snapshots["printDiffOrStringify expected and received are single line with multiple changes 1"] = [=[

Expected: <g>"<i>delete</i> common <i>expect</i>ed common <i>prev</i>"</>
Received: <r>"<i>insert</i> common <i>receiv</i>ed common <i>next</i>"</>
]=]

snapshots["printDiffOrStringify expected is empty and received is single line 1"] = [=[

Expected: <g>""</>
Received: <r>"single line"</>
]=]

snapshots["printDiffOrStringify expected is multi line and received is empty 1"] = [=[

Expected: <g>"multi
line"</>
Received: <r>""</>
]=]

snapshots["printDiffOrStringify has no common after clean up chaff multiline 1"] = [=[

<g>- Expected  - 2</>
<r>+ Received  + 2</>

<g>- delete</>
<g>- two</>
<r>+ insert</>
<r>+ 2</>
]=]

snapshots["printDiffOrStringify has no common after clean up chaff one-line 1"] = [=[

Expected: <g>"delete"</>
Received: <r>"insert"</>
]=]

snapshots["printDiffOrStringify object contain readonly symbol key object 1"] = [=[

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    "a": Symbol(key),</>
<g>-   "b": 2,</>
<r>+   "b": 1,</>
<d>  }</>
]=]

return snapshots