-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-snapshot/src/__tests__/__snapshots__/printSnapshot.test.ts.snap

local exports = {}

--[[
	deviation: in various places, we use single backslashes instead of double backslashes because
	multiline strings in Lua don't interpret escape sequences
]]

-- ROBLOX deviation: changed String to string and Object to Table
exports["printPropertiesAndReceived omit missing properties 1"] = [=[

<g>- Expected properties  - 2</>
<r>+ Received value       + 1</>

<d>  Table {</>
<g>-   "hash": Any<string>,</>
<g>-   "path": Any<string>,</>
<r>+   "path": "…",</>
<d>  }</>
]=]

exports["pass false toMatchSnapshot New snapshot was not written (multi line) 1"] = [=[

<d>expect(</><t>received</><d>).</>toMatchSnapshot<d>(</><b>hint</><d>)</>

Snapshot name: `New snapshot was not written: <b>(CI)</> 1`

New snapshot was <b>not written</>. The update flag must be explicitly passed to write a new snapshot.

This is likely because this test is run in a continuous integration (CI) environment in which snapshots are not written by default.

Received:
<t>"To write or not to write,</>
<t>that is the question."</>
]=]

exports["pass false toMatchSnapshot New snapshot was not written (single line) 1"] = [=[

<d>expect(</><t>received</><d>).</>toMatchSnapshot<d>(</><b>hint</><d>)</>

Snapshot name: `New snapshot was not written: <b>(CI)</> 2`

New snapshot was <b>not written</>. The update flag must be explicitly passed to write a new snapshot.

This is likely because this test is run in a continuous integration (CI) environment in which snapshots are not written by default.

Received: <t>"Write me if you can!"</>
]=]

-- ROBLOX deviation: Changed RangeError to Error
exports["pass false toMatchSnapshot with properties equals false isLineDiffable false 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchSnapshot<d>(</><g>properties</><d>)</>

Snapshot name: `with properties 1`

Expected properties: <g>{"name": "Error"}</>
Received value:      <r>[Error: Invalid array length]</>
]=]

-- ROBLOX deviation: changed Object to Table
exports["pass false toMatchSnapshot with properties equals false isLineDiffable true 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchSnapshot<d>(</><g>properties</><d>)</>

Snapshot name: `with properties 1`

<g>- Expected properties  - 1</>
<r>+ Received value       + 1</>

<d>  Table {</>
<g>-   "id": "abcdef",</>
<r>+   "id": "abcdefg",</>
<d>  }</>
]=]

-- ROBLOX deviation: changed Object to Table
exports["pass false toMatchSnapshot with properties equals true 1"] = [=[

<d>expect(</><t>received</><d>).</>toMatchSnapshot<d>(</>properties<d>, </><b>hint</><d>)</>

Snapshot name: `with properties: <b>change text value</> 1`

<m>- Snapshot  - 1</>
<t>+ Received  + 1</>

<d>  Table {</>
<d>    "id": "abcdef",</>
<m>-   "text": "snapshot",</>
<t>+   "text": "received",</>
<d>    "type": "ADD_ITEM",</>
<d>  }</>
]=]

exports["printSnapshotAndReceived backtick single line expected and received 1"] = [=[

Snapshot: <m>"var foo = `backtick`;"</>
Received: <t>"var foo = <i>tag</i>`backtick`;"</>
]=]

exports["printSnapshotAndReceived empty string expected and received single line 1"] = [=[

Snapshot: <m>""</>
Received: <t>"single line string"</>
]=]

exports["printSnapshotAndReceived empty string received and expected multi line 1"] = [=[

<m>- Snapshot  - 3</>
<t>+ Received  + 0</>

<m>- multi</>
<m>- line</>
<m>- string</>
]=]

exports["printSnapshotAndReceived escape backslash in multi line string 1"] = [=[

<m>- Snapshot  - 1</>
<t>+ Received  + 2</>

<m>- Forward / slash<i> and b</i>ack \ slash</>
<t>+ Forward / slash</>
<t>+ <i>B</i>ack \ slash</>
]=]

exports["printSnapshotAndReceived escape backslash in single line string 1"] = [=[

Snapshot: <m>"<i>f</i>orward / slash and back \\ slash"</>
Received: <t>"<i>F</i>orward / slash and back \\ slash"</>
]=]

exports["printSnapshotAndReceived escape double quote marks in string 1"] = [=[

Snapshot: <m>"What does \"<i>oo</i>bleck\" mean?"</>
Received: <t>"What does \"<i>ew</i>bleck\" mean?"</>
]=]

exports["printSnapshotAndReceived expand false 1"] = [=[

<m>- Snapshot  - 1</>
<t>+ Received  + 3</>

<y>@@ -12,7 +12,9 @@</>
<d>  ? "number"</>
<d>  : T extends boolean</>
<d>  ? "boolean"</>
<d>  : T extends undefined</>
<d>  ? "undefined"</>
<m>- : T extends Function<i> </i>? "function"<i> </i>: "object";</>
<t>+ : T extends Function</>
<t>+ ? "function"</>
<t>+ : "object";</>
<d>  ↵</>
]=]

exports["printSnapshotAndReceived expand true 1"] = [=[

<m>- Snapshot  - 1</>
<t>+ Received  + 3</>

<d>  type TypeName<T> =</>
<d>  T extends string ? "string" :</>
<d>  T extends number ? "number" :</>
<d>  T extends boolean ? "boolean" :</>
<d>  T extends undefined ? "undefined" :</>
<d>  T extends Function ? "function" :</>
<d>  "object";</>
<d>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~</>
<d>  type TypeName<T> = T extends string</>
<d>  ? "string"</>
<d>  : T extends number</>
<d>  ? "number"</>
<d>  : T extends boolean</>
<d>  ? "boolean"</>
<d>  : T extends undefined</>
<d>  ? "undefined"</>
<m>- : T extends Function<i> </i>? "function"<i> </i>: "object";</>
<t>+ : T extends Function</>
<t>+ ? "function"</>
<t>+ : "object";</>
<d>  ↵</>
]=]

exports["printSnapshotAndReceived fallback to line diff 1"] = [=[

<m>- Snapshot  - 1</>
<t>+ Received  + 8</>

<t>+ ====================================options=====================================</>
<t>+ parsers: ["flow", "typescript"]</>
<t>+ printWidth: 80</>
<t>+                                                                                 | printWidth</>
<t>+ =====================================input======================================</>
<d>  [...a, ...b,];</>
<d>  [...a, ...b];</>
<m>- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~</>
<t>+</>
<t>+ =====================================output=====================================</>
<d>  [...a, ...b];</>
<d>  [...a, ...b];</>

<t>+ ================================================================================</>
]=]

-- ROBLOX deviation: changed [] to {} and Array to Table
exports["printSnapshotAndReceived has no common after clean up chaff array 1"] = [=[

<m>- Snapshot  - 2</>
<t>+ Received  + 2</>

<d>  Table {</>
<m>-   "delete",</>
<m>-   "two",</>
<t>+   "insert",</>
<t>+   "2",</>
<d>  }</>
]=]

exports["printSnapshotAndReceived has no common after clean up chaff string single line 1"] = [=[

Snapshot: <m>"delete"</>
Received: <t>"insert"</>
]=]

exports["printSnapshotAndReceived ignore indentation object delete 1"] = [=[

<m>- Snapshot  - 2</>
<t>+ Received  + 0</>

<d>  Table {</>
<m>-   "payload": Table {</>
<d>    "text": "Ignore indentation in snapshot",</>
<d>    "time": "2019-11-11",</>
<m>-   },</>
<d>    "type": "CREATE_ITEM",</>
<d>  }</>
]=]

exports["printSnapshotAndReceived ignore indentation object insert 1"] = [=[

<m>- Snapshot  - 0</>
<t>+ Received  + 2</>

<d>  Table {</>
<t>+   "payload": Table {</>
<d>      "text": "Ignore indentation in snapshot",</>
<d>      "time": "2019-11-11",</>
<t>+   },</>
<d>    "type": "CREATE_ITEM",</>
<d>  }</>
]=]

-- ROBLOX deviation: changed null to nil and Object to Table
exports["printSnapshotAndReceived isLineDiffable false asymmetric matcher 1"] = [=[

Snapshot: <m>nil</>
Received: <t>Table {</>
<t>  "asymmetricMatch": [Function],</>
<t>}</>
]=]

exports["printSnapshotAndReceived isLineDiffable false boolean 1"] = [=[

Snapshot: <m>true</>
Received: <t>false</>
]=]

exports["printSnapshotAndReceived isLineDiffable false date 1"] = [=[

Snapshot: <m>2019-09-19T00:00:00.000Z</>
Received: <t>2019-09-20T00:00:00.000Z</>
]=]

exports["printSnapshotAndReceived isLineDiffable false error 1"] = [=[

Snapshot: <m>[Error: Cannot spread fragment "NameAndAppearances" within itself.]</>
Received: <t>[Error: Cannot spread fragment "NameAndAppearancesAndFriends" within itself.]</>
]=]

-- ROBLOX deviation: changed undefined to nil
exports["printSnapshotAndReceived isLineDiffable false function 1"] = [=[

Snapshot: <m>nil</>
Received: <t>[Function]</>
]=]

-- ROBLOX deviation: changed NaN to nan
exports["printSnapshotAndReceived isLineDiffable false number 1"] = [=[

Snapshot: <m>-0</>
Received: <t>nan</>
]=]

-- ROBLOX deviation: changed Array and Object to Table and [] to {}
exports["printSnapshotAndReceived isLineDiffable true array 1"] = [=[

<m>- Snapshot  - 0</>
<t>+ Received  + 2</>

<d>  Table {</>
<d>    Table {</>
<t>+     "_id": "b14680dec683e744ada1f2fe08614086",</>
<d>      "code": 4011,</>
<d>      "weight": 2.13,</>
<d>    },</>
<d>    Table {</>
<t>+     "_id": "7fc63ff01769c4fa7d9279e97e307829",</>
<d>      "code": 4019,</>
<d>      "count": 4,</>
<d>    },</>
<d>  }</>
]=]

-- ROBLOX deviation: changed Object to Table
exports["printSnapshotAndReceived isLineDiffable true object 1"] = [=[

<m>- Snapshot  - 2</>
<t>+ Received  + 3</>

<d>  Table {</>
<d>    "props": Table {</>
<m>-     "className": "logo",</>
<m>-     "src": "/img/jest.png",</>
<t>+     "alt": "Jest logo",</>
<t>+     "class": "logo",</>
<t>+     "src": "/img/jest.svg",</>
<d>    },</>
<d>    "type": "img",</>
<d>  }</>
]=]

-- ROBLOX deviation: changed Array [] to Table {}
exports["printSnapshotAndReceived isLineDiffable true single line expected and multi line received 1"] = [=[

<m>- Snapshot  - 1</>
<t>+ Received  + 3</>

<m>- Table {}</>
<t>+ Table {</>
<t>+   0,</>
<t>+ }</>
]=]

exports["printSnapshotAndReceived multi line small change in one line and other is unchanged 1"] = [=[

<m>- Snapshot  - 1</>
<t>+ Received  + 1</>

<m>- There is no route defined for key <i>'</i>Settings<i>'</i>.</>
<t>+ There is no route defined for key Settings.</>
<d>  Must be one of: 'Home'</>
]=]

exports["printSnapshotAndReceived multi line small changes 1"] = [=[

<m>- Snapshot  - 7</>
<t>+ Received  + 7</>

<m>-     6<i>9</i> | </>
<t>+     6<i>8</i> | </>
<m>-     <i>70</i> | test('assert.doesNotThrow', () => {</>
<t>+     <i>69</i> | test('assert.doesNotThrow', () => {</>
<m>-   > 7<i>1</i> |   assert.doesNotThrow(() => {</>
<t>+   > 7<i>0</i> |   assert.doesNotThrow(() => {</>
<d>         |          ^</>
<m>-     7<i>2</i> |     throw Error('err!');</>
<t>+     7<i>1</i> |     throw Error('err!');</>
<m>-     7<i>3</i> |   });</>
<t>+     7<i>2</i> |   });</>
<m>-     7<i>4</i> | });</>
<t>+     7<i>3</i> | });</>
<m>-     at Object.doesNotThrow (__tests__/assertionError.test.js:7<i>1</i>:10)</>
<t>+     at Object.doesNotThrow (__tests__/assertionError.test.js:7<i>0</i>:10)</>
]=]

exports["printSnapshotAndReceived single line large changes 1"] = [=[

Snapshot: <m>"<i>A</i>rray length<i> must be a finite positive integer</i>"</>
Received: <t>"<i>Invalid a</i>rray length"</>
]=]

exports["printSnapshotAndReceived without serialize backtick single line expected and multi line received 1"] = [=[

<m>- Snapshot  - 1</>
<t>+ Received  + 2</>

<m>- var foo = `backtick`;</>
<t>+ var foo = `back</>
<t>+ tick`;</>
]=]

exports["printSnapshotAndReceived without serialize backtick single line expected and received 1"] = [=[

<m>- Snapshot  - 1</>
<t>+ Received  + 1</>

<m>- var foo = `backtick`;</>
<t>+ var foo = `back<i>${x}</i>tick`;</>
]=]

exports["printSnapshotAndReceived without serialize has no common after clean up chaff multi line 1"] = [=[

<m>- Snapshot  - 2</>
<t>+ Received  + 2</>

<m>- delete</>
<m>- two</>
<t>+ insert</>
<t>+ 2</>
]=]

exports["printSnapshotAndReceived without serialize has no common after clean up chaff single line 1"] = [=[

<m>- Snapshot  - 1</>
<t>+ Received  + 1</>

<m>- delete</>
<t>+ insert</>
]=]

exports["printSnapshotAndReceived without serialize prettier/pull/5590 1"] = [=[

<m>- Snapshot  - 1</>
<t>+ Received  + 1</>

<y>@@ -4,8 +4,8 @@</>
<d>                                                                                  | printWidth</>
<d>  =====================================input======================================</>
<d>  <img src="test.png" alt='John "ShotGun" Nelson'></>

<d>  =====================================output=====================================</>
<m>- <img src="test.png" alt=<i>"</i>John <i>&quot;</i>ShotGun<i>&quot;</i> Nelson<i>"</i> /></>
<t>+ <img src="test.png" alt=<i>'</i>John <i>"</i>ShotGun<i>"</i> Nelson<i>'</i> /></>

<d>  ================================================================================</>
]=]

exports["matcher error toMatchSnapshot Expected properties must be an object (non-null) 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchSnapshot<d>(</><g>properties</><d>)</>

<b>Matcher error</>: Expected <g>properties</> must be an object

Expected properties has type:  function
Expected properties has value: <g>[Function]</>
]=]

exports["matcher error toMatchSnapshot Expected properties must be an object (null) with hint 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchSnapshot<d>(</><g>properties</><d>, </><b>hint</><d>)</>

<b>Matcher error</>: Expected <g>properties</> must be an object

Expected properties has value: <g>nil</>

To provide a hint without properties: toMatchSnapshot('hint')
]=]

exports["matcher error toMatchSnapshot Expected properties must be an object (null) without hint 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchSnapshot<d>(</><g>properties</><d>)</>

<b>Matcher error</>: Expected <g>properties</> must be an object

Expected properties has value: <g>nil</>
]=]

exports["matcher error toMatchSnapshot Snapshot state must be initialized 1"] = [=[

<d>expect(</><r>received</><d>).</>resolves<d>.</>toMatchSnapshot<d>(</><b>hint</><d>)</>

Snapshot state must be initialized

Snapshot state has value: undefined
]=]

exports["matcher error toMatchSnapshot received value must be an object (non-null) 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchSnapshot<d>(</><g>properties</><d>)</>

<b>Matcher error</>: <r>received</> value must be an object when the matcher has <g>properties</>

Received has type:  string
Received has value: <r>"string"</>
]=]

exports["matcher error toMatchSnapshot received value must be an object (null) 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchSnapshot<d>(</><g>properties</><d>)</>

<b>Matcher error</>: <r>received</> value must be an object when the matcher has <g>properties</>

Received has value: <r>nil</>
]=]

exports["matcher error toThrowErrorMatchingSnapshot Received value must be a function 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowErrorMatchingSnapshot<d>()</>

<b>Matcher error</>: <r>received</> value must be a function

Received has type:  number
Received has value: <r>13</>
]=]

-- ROBLOX deviation: changed not to never
exports["matcher error toThrowErrorMatchingSnapshot Snapshot matchers cannot be used with not 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrowErrorMatchingSnapshot<d>(</><b>hint</><d>)</>

<b>Matcher error</>: Snapshot matchers cannot be used with <b>never</>
]=]

exports["other error toThrowErrorMatchingSnapshot Received function did not throw 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowErrorMatchingSnapshot<d>()</>

Received function did not throw
]=]

return exports
