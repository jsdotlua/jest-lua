-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/expect/src/__tests__/__snapshots__/matchers.test.js.snap

--[[
  deviation: We changed output from If it should pass with deep equality, replace "toBe" with "toEqual"
  to say toEqual instead of toStrictEqual since strict equality isn't currently any different from our
  definition of regular deep equality.
  deviation: Console output formatting is stripped from the snapshots.
]]
local snapshots = {}

snapshots[".toBe() does not crash on circular references 1"] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

<g>- Expected  - 1</>
<r>+ Received  + 3</>

<g>- Table {}</>
<r>+ Table {</>
<r>+   "circular": [Circular],</>
<r>+ }</>
]=]

snapshots['.toBe() fails for "a" with .never 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

Expected: never <g>"a"</>
]=]

snapshots[".toBe() fails for {} with .never 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

Expected: never <g>{}</>
]=]

snapshots[".toBe() fails for 1 with .never 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

Expected: never <g>1</>
]=]

snapshots[".toBe() fails for false with .never 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

Expected: never <g>false</>
]=]

snapshots[".toBe() fails for nil with .never 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

Expected: never <g>nil</>
]=]

snapshots['.toBe() fails for: "" and "compare one-line string to empty string" 1'] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

Expected: <g>"compare one-line string to empty string"</>
Received: <r>""</>
]=]

snapshots['.toBe() fails for: "abc" and "cde" 1'] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

Expected: <g>"cde"</>
Received: <r>"abc"</>
]=]

snapshots['.toBe() fails for: "four\n4\nline\nstring" and "3\nline\nstring" 1'] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

<g>- Expected  - 1</>
<r>+ Received  + 2</>

<g>- 3</>
<r>+ four</>
<r>+ 4</>
<d>  line</>
<d>  string</>
]=]

snapshots['.toBe() fails for: "painless JavaScript testing" and "delightful JavaScript testing" 1'] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

Expected: <g>"<i>delightful</i> JavaScript testing"</>
Received: <r>"<i>painless</i> JavaScript testing"</>
]=]

snapshots['.toBe() fails for: "with \ntrailing space" and "without trailing space" 1'] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

<g>- Expected  - 1</>
<r>+ Received  + 2</>

<g>- with<i>out</i> trailing space</>
<r>+ with<Y> </></>
<r>+ trailing space</>
]=]

-- ROBLOX deviation: changed from regex to string
snapshots['.toBe() fails for: "received" and "expected" 1'] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

Expected: <g>"<i>expect</i>ed"</>
Received: <r>"<i>receiv</i>ed"</>
]=]

snapshots[".toBe() fails for: [Function anonymous] and [Function anonymous] 1"] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

Expected: <g>[Function anonymous]</>
Received: serializes to the same string
]=]

snapshots['.toBe() fails for: {"a": [Function a], "b": 2} and {"a": Any<function>, "b": 2} 1'] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

<d>If it should pass with deep equality, replace "toBe" with "toEqual"</>

Expected: <g>{"a": Any<function>, "b": 2}</>
Received: <r>{"a": [Function a], "b": 2}</>
]=]

snapshots['.toBe() fails for: {"a": 1} and {"a": 1} 1'] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

<d>If it should pass with deep equality, replace "toBe" with "toEqual"</>

Expected: <g>{"a": 1}</>
Received: serializes to the same string
]=]

snapshots['.toBe() fails for: {"a": 1} and {"a": 5} 1'] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "a": 5,</>
<r>+   "a": 1,</>
<d>  }</>
]=]

-- ROBLOX deviation: changed from nil to false and therefore removed the line about
-- replacing toBe with toEqual
snapshots['.toBe() fails for: {"a": false, "b": 2} and {"b": 2} 1'] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

<g>- Expected  - 0</>
<r>+ Received  + 1</>

<d>  Table {</>
<r>+   "a": false,</>
<d>    "b": 2,</>
<d>  }</>
]=]

snapshots[".toBe() fails for: {} and {} 1"] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

<d>If it should pass with deep equality, replace "toBe" with "toEqual"</>

Expected: <g>{}</>
Received: serializes to the same string
]=]

-- ROBLOX deviation: changed from -0 and 0 to -inf and inf
snapshots[".toBe() fails for: -inf and inf 1"] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

Expected: <g>inf</>
Received: <r>-inf</>
]=]

snapshots[".toBe() fails for: 1 and 2 1"] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

Expected: <g>2</>
Received: <r>1</>
]=]

snapshots[".toBe() fails for: 2020-02-21T00:00:00.000Z and 2020-02-20T00:00:00.000Z 1"] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

Expected: <g>2020-02-20T00:00:00.000Z</>
Received: <r>2020-02-21T00:00:00.000Z</>
]=]

snapshots[".toBe() fails for: Symbol(received) and Symbol(expected) 1"] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

Expected: <g>Symbol(expected)</>
Received: <r>Symbol(received)</>
]=]

snapshots[".toBe() fails for: true and false 1"] = [=[

<d>expect(</><r>received</><d>).</>toBe<d>(</><g>expected</><d>) -- Object.is equality</>

Expected: <g>false</>
Received: <r>true</>
]=]

snapshots[".toBeCloseTo {pass: false} expect(-inf).toBeCloseTo(-1.23) 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeCloseTo<d>(</><g>expected</><d>)</>

Expected: <g>-1.23</>
Received: <r>-inf</>

Expected precision:    2
Expected difference: < <g>0.005</>
Received difference:   <r>inf</>
]=]

snapshots[".toBeCloseTo {pass: false} expect(0).toBeCloseTo(0.01) 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeCloseTo<d>(</><g>expected</><d>)</>

Expected: <g>0.01</>
Received: <r>0</>

Expected precision:    2
Expected difference: < <g>0.005</>
Received difference:   <r>0.01</>
]=]

snapshots[".toBeCloseTo {pass: false} expect(1).toBeCloseTo(1.23) 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeCloseTo<d>(</><g>expected</><d>)</>

Expected: <g>1.23</>
Received: <r>1</>

Expected precision:    2
Expected difference: < <g>0.005</>
Received difference:   <r>0.22999999999999998</>
]=]

snapshots[".toBeCloseTo {pass: false} expect(1.23).toBeCloseTo(1.2249999) 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeCloseTo<d>(</><g>expected</><d>)</>

Expected: <g>1.2249999</>
Received: <r>1.23</>

Expected precision:    2
Expected difference: < <g>0.005</>
Received difference:   <r>0.005000099999999952</>
]=]

snapshots[".toBeCloseTo {pass: false} expect(inf).toBeCloseTo(-inf) 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeCloseTo<d>(</><g>expected</><d>)</>

Expected: <g>-inf</>
Received: <r>inf</>

Expected precision:    2
Expected difference: < <g>0.005</>
Received difference:   <r>inf</>
]=]

snapshots[".toBeCloseTo {pass: false} expect(inf).toBeCloseTo(1.23) 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeCloseTo<d>(</><g>expected</><d>)</>

Expected: <g>1.23</>
Received: <r>inf</>

Expected precision:    2
Expected difference: < <g>0.005</>
Received difference:   <r>inf</>
]=]

snapshots[".toBeCloseTo {pass: true} expect(-inf).toBeCloseTo(-inf) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>)</>

Expected: never <g>-inf</>

]=]

snapshots[".toBeCloseTo {pass: true} expect(0).toBeCloseTo(0) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>)</>

Expected: never <g>0</>

]=]

snapshots[".toBeCloseTo {pass: true} expect(0).toBeCloseTo(0.000004, 5) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>, </>precision<d>)</>

Expected: never <g>0.000004</>
Received:       <r>0</>

Expected precision:          5
Expected difference: never < <g>0.000005</>
Received difference:         <r>0.000004</>
]=]

snapshots[".toBeCloseTo {pass: true} expect(0).toBeCloseTo(0.0001, 3) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>, </>precision<d>)</>

Expected: never <g>0.0001</>
Received:       <r>0</>

Expected precision:          3
Expected difference: never < <g>0.0005</>
Received difference:         <r>0.0001</>
]=]

snapshots[".toBeCloseTo {pass: true} expect(0).toBeCloseTo(0.001) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>)</>

Expected: never <g>0.001</>
Received:       <r>0</>

Expected precision:          2
Expected difference: never < <g>0.005</>
Received difference:         <r>0.001</>
]=]

snapshots[".toBeCloseTo {pass: true} expect(0).toBeCloseTo(0.1, 0) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>, </>precision<d>)</>

Expected: never <g>0.1</>
Received:       <r>0</>

Expected precision:          0
Expected difference: never < <g>0.5</>
Received difference:         <r>0.1</>
]=]

snapshots[".toBeCloseTo {pass: true} expect(1.23).toBeCloseTo(1.225) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>)</>

Expected: never <g>1.225</>
Received:       <r>1.23</>

Expected precision:          2
Expected difference: never < <g>0.005</>
Received difference:         <r>0.004999999999999893</>
]=]

snapshots[".toBeCloseTo {pass: true} expect(1.23).toBeCloseTo(1.226) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>)</>

Expected: never <g>1.226</>
Received:       <r>1.23</>

Expected precision:          2
Expected difference: never < <g>0.005</>
Received difference:         <r>0.0040000000000000036</>
]=]

snapshots[".toBeCloseTo {pass: true} expect(1.23).toBeCloseTo(1.229) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>)</>

Expected: never <g>1.229</>
Received:       <r>1.23</>

Expected precision:          2
Expected difference: never < <g>0.005</>
Received difference:         <r>0.0009999999999998899</>
]=]

snapshots[".toBeCloseTo {pass: true} expect(1.23).toBeCloseTo(1.234) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>)</>

Expected: never <g>1.234</>
Received:       <r>1.23</>

Expected precision:          2
Expected difference: never < <g>0.005</>
Received difference:         <r>0.0040000000000000036</>
]=]

snapshots[".toBeCloseTo {pass: true} expect(2.0000002).toBeCloseTo(2, 5) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>, </>precision<d>)</>

Expected: never <g>2</>
Received:       <r>2.0000002</>

Expected precision:          5
Expected difference: never < <g>5e-6</>
Received difference:         <r>2.0000000011677344e-7</>
]=]

snapshots[".toBeCloseTo {pass: true} expect(inf).toBeCloseTo(inf) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>)</>

Expected: never <g>inf</>

]=]

snapshots[".toBeCloseTo throws: Matcher error promise empty isNot false received 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeCloseTo<d>(</><g>expected</><d>, </>precision<d>)</>

<b>Matcher error</>: <r>received</> value must be a number

Received has type:  string
Received has value: <r>""</>
]=]

snapshots[".toBeCloseTo throws: Matcher error promise empty isNot true expected 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a number

Expected has value: <g>nil</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [-inf, -inf] 1"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never >= <g>-inf</>
Received:          <r>-inf</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [-inf, -inf] 2"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never <= <g>-inf</>
Received:          <r>-inf</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [1, 1] 1"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never >= <g>1</>
Received:          <r>1</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [1, 1] 2"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never <= <g>1</>
Received:          <r>1</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [9007199254740991, 9007199254740991] 1"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never >= <g>9007199254740991</>
Received:          <r>9007199254740991</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [9007199254740991, 9007199254740991] 2"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never <= <g>9007199254740991</>
Received:          <r>9007199254740991</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [-9007199254740991, -9007199254740991] 1"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never >= <g>-9007199254740991</>
Received:          <r>-9007199254740991</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [-9007199254740991, -9007199254740991] 2"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never <= <g>-9007199254740991</>
Received:          <r>-9007199254740991</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [inf, inf] 1"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never >= <g>inf</>
Received:          <r>inf</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [inf, inf] 2"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never <= <g>inf</>
Received:          <r>inf</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 1"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeGreaterThan<d>(</><g>expected</><d>)</>

Expected: > <g>inf</>
Received:   <r>-inf</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 2"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThan<d>(</><g>expected</><d>)</>

Expected: never < <g>inf</>
Received:         <r>-inf</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 3"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThan<d>(</><g>expected</><d>)</>

Expected: never > <g>-inf</>
Received:         <r>inf</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 4"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeLessThan<d>(</><g>expected</><d>)</>

Expected: < <g>-inf</>
Received:   <r>inf</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 5"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: >= <g>inf</>
Received:    <r>-inf</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 6"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never <= <g>inf</>
Received:          <r>-inf</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 7"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never >= <g>-inf</>
Received:          <r>inf</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 8"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: <= <g>-inf</>
Received:    <r>inf</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 1"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeGreaterThan<d>(</><g>expected</><d>)</>

Expected: > <g>0.2</>
Received:   <r>0.1</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 2"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThan<d>(</><g>expected</><d>)</>

Expected: never < <g>0.2</>
Received:         <r>0.1</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 3"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThan<d>(</><g>expected</><d>)</>

Expected: never > <g>0.1</>
Received:         <r>0.2</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 4"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeLessThan<d>(</><g>expected</><d>)</>

Expected: < <g>0.1</>
Received:   <r>0.2</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 5"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: >= <g>0.2</>
Received:    <r>0.1</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 6"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never <= <g>0.2</>
Received:          <r>0.1</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 7"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never >= <g>0.1</>
Received:          <r>0.2</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 8"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: <= <g>0.1</>
Received:    <r>0.2</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 1"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeGreaterThan<d>(</><g>expected</><d>)</>

Expected: > <g>2</>
Received:   <r>1</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 2"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThan<d>(</><g>expected</><d>)</>

Expected: never < <g>2</>
Received:         <r>1</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 3"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThan<d>(</><g>expected</><d>)</>

Expected: never > <g>1</>
Received:         <r>2</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 4"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeLessThan<d>(</><g>expected</><d>)</>

Expected: < <g>1</>
Received:   <r>2</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 5"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: >= <g>2</>
Received:    <r>1</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 6"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never <= <g>2</>
Received:          <r>1</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 7"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never >= <g>1</>
Received:          <r>2</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 8"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: <= <g>1</>
Received:    <r>2</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 1"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeGreaterThan<d>(</><g>expected</><d>)</>

Expected: > <g>7</>
Received:   <r>3</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 2"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThan<d>(</><g>expected</><d>)</>

Expected: never < <g>7</>
Received:         <r>3</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 3"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThan<d>(</><g>expected</><d>)</>

Expected: never > <g>3</>
Received:         <r>7</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 4"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeLessThan<d>(</><g>expected</><d>)</>

Expected: < <g>3</>
Received:   <r>7</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 5"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: >= <g>7</>
Received:    <r>3</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 6"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never <= <g>7</>
Received:          <r>3</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 7"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never >= <g>3</>
Received:          <r>7</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 8"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: <= <g>3</>
Received:    <r>7</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9007199254740991, 9007199254740991] 1"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeGreaterThan<d>(</><g>expected</><d>)</>

Expected: > <g>9007199254740991</>
Received:   <r>-9007199254740991</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9007199254740991, 9007199254740991] 2"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThan<d>(</><g>expected</><d>)</>

Expected: never < <g>9007199254740991</>
Received:         <r>-9007199254740991</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9007199254740991, 9007199254740991] 3"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThan<d>(</><g>expected</><d>)</>

Expected: never > <g>-9007199254740991</>
Received:         <r>9007199254740991</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9007199254740991, 9007199254740991] 4"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeLessThan<d>(</><g>expected</><d>)</>

Expected: < <g>-9007199254740991</>
Received:   <r>9007199254740991</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9007199254740991, 9007199254740991] 5"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: >= <g>9007199254740991</>
Received:    <r>-9007199254740991</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9007199254740991, 9007199254740991] 6"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never <= <g>9007199254740991</>
Received:          <r>-9007199254740991</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9007199254740991, 9007199254740991] 7"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never >= <g>-9007199254740991</>
Received:          <r>9007199254740991</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9007199254740991, 9007199254740991] 8"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: <= <g>-9007199254740991</>
Received:    <r>9007199254740991</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 1"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeGreaterThan<d>(</><g>expected</><d>)</>

Expected: > <g>18</>
Received:   <r>9</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 2"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThan<d>(</><g>expected</><d>)</>

Expected: never < <g>18</>
Received:         <r>9</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 3"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThan<d>(</><g>expected</><d>)</>

Expected: never > <g>9</>
Received:         <r>18</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 4"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeLessThan<d>(</><g>expected</><d>)</>

Expected: < <g>9</>
Received:   <r>18</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 5"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: >= <g>18</>
Received:    <r>9</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 6"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never <= <g>18</>
Received:          <r>9</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 7"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never >= <g>9</>
Received:          <r>18</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 8"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: <= <g>9</>
Received:    <r>18</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 1"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeGreaterThan<d>(</><g>expected</><d>)</>

Expected: > <g>34</>
Received:   <r>17</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 2"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThan<d>(</><g>expected</><d>)</>

Expected: never < <g>34</>
Received:         <r>17</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 3"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThan<d>(</><g>expected</><d>)</>

Expected: never > <g>17</>
Received:         <r>34</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 4"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeLessThan<d>(</><g>expected</><d>)</>

Expected: < <g>17</>
Received:   <r>34</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 5"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: >= <g>34</>
Received:    <r>17</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 6"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never <= <g>34</>
Received:          <r>17</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 7"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeGreaterThanOrEqual<d>(</><g>expected</><d>)</>

Expected: never >= <g>17</>
Received:          <r>34</>
]=]

snapshots[".toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 8"] =
	[=[

<d>expect(</><r>received</><d>).</>toBeLessThanOrEqual<d>(</><g>expected</><d>)</>

Expected: <= <g>17</>
Received:    <r>34</>
]=]

snapshots[".toBeNan() {pass: true} expect(nan).toBeNan() 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeNan<d>()</>

Received: <r>nan</>
]=]

snapshots[".toBeNan() {pass: true} expect(nan).toBeNan() 2"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeNan<d>()</>

Received: <r>nan</>
]=]

snapshots[".toBeNan() {pass: true} expect(nan).toBeNan() 3"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeNan<d>()</>

Received: <r>nan</>
]=]

snapshots[".toBeNan() throws 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeNan<d>()</>

Received: <r>1</>
]=]

snapshots[".toBeNan() throws 2"] = [=[

<d>expect(</><r>received</><d>).</>toBeNan<d>()</>

Received: <r>""</>
]=]

snapshots[".toBeNan() throws 3"] = [=[

<d>expect(</><r>received</><d>).</>toBeNan<d>()</>

Received: <r>{}</>
]=]

snapshots[".toBeNan() throws 4"] = [=[

<d>expect(</><r>received</><d>).</>toBeNan<d>()</>

Received: <r>0.2</>
]=]

snapshots[".toBeNan() throws 5"] = [=[

<d>expect(</><r>received</><d>).</>toBeNan<d>()</>

Received: <r>0</>
]=]

snapshots[".toBeNan() throws 6"] = [=[

<d>expect(</><r>received</><d>).</>toBeNan<d>()</>

Received: <r>inf</>
]=]

snapshots[".toBeNan() throws 7"] = [=[

<d>expect(</><r>received</><d>).</>toBeNan<d>()</>

Received: <r>-inf</>
]=]

snapshots['.toBeNil() fails for "a" 1'] = [=[

<d>expect(</><r>received</><d>).</>toBeNil<d>()</>

Received: <r>"a"</>
]=]

snapshots[".toBeNil() fails for [Function anonymous] 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeNil<d>()</>

Received: <r>[Function anonymous]</>
]=]

snapshots[".toBeNil() fails for {} 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeNil<d>()</>

Received: <r>{}</>
]=]

snapshots[".toBeNil() fails for 0.5 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeNil<d>()</>

Received: <r>0.5</>
]=]

snapshots[".toBeNil() fails for 1 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeNil<d>()</>

Received: <r>1</>
]=]

snapshots[".toBeNil() fails for inf 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeNil<d>()</>

Received: <r>inf</>
]=]

snapshots[".toBeNil() fails for true 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeNil<d>()</>

Received: <r>true</>
]=]

snapshots[".toBeNil() fails for null with .not 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeNil<d>()</>

Received: <r>nil</>
]=]

snapshots['.toBeTruthy(), .toBeFalsy() "" is truthy 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeTruthy<d>()</>

Received: <r>""</>
]=]

snapshots['.toBeTruthy(), .toBeFalsy() "" is truthy 2'] = [=[

<d>expect(</><r>received</><d>).</>toBeFalsy<d>()</>

Received: <r>""</>
]=]

snapshots['.toBeTruthy(), .toBeFalsy() "a" is truthy 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeTruthy<d>()</>

Received: <r>"a"</>
]=]

snapshots['.toBeTruthy(), .toBeFalsy() "a" is truthy 2'] = [=[

<d>expect(</><r>received</><d>).</>toBeFalsy<d>()</>

Received: <r>"a"</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() [Function anonymous] is truthy 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeTruthy<d>()</>

Received: <r>[Function anonymous]</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() [Function anonymous] is truthy 2"] = [=[

<d>expect(</><r>received</><d>).</>toBeFalsy<d>()</>

Received: <r>[Function anonymous]</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() {} is truthy 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeTruthy<d>()</>

Received: <r>{}</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() {} is truthy 2"] = [=[

<d>expect(</><r>received</><d>).</>toBeFalsy<d>()</>

Received: <r>{}</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() 0 is truthy 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeTruthy<d>()</>

Received: <r>0</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() 0 is truthy 2"] = [=[

<d>expect(</><r>received</><d>).</>toBeFalsy<d>()</>

Received: <r>0</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() 0.5 is truthy 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeTruthy<d>()</>

Received: <r>0.5</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() 0.5 is truthy 2"] = [=[

<d>expect(</><r>received</><d>).</>toBeFalsy<d>()</>

Received: <r>0.5</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() 1 is truthy 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeTruthy<d>()</>

Received: <r>1</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() 1 is truthy 2"] = [=[

<d>expect(</><r>received</><d>).</>toBeFalsy<d>()</>

Received: <r>1</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() inf is truthy 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeTruthy<d>()</>

Received: <r>inf</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() inf is truthy 2"] = [=[

<d>expect(</><r>received</><d>).</>toBeFalsy<d>()</>

Received: <r>inf</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() nan is truthy 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeTruthy<d>()</>

Received: <r>nan</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() nan is truthy 2"] = [=[

<d>expect(</><r>received</><d>).</>toBeFalsy<d>()</>

Received: <r>nan</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() false is falsy 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeTruthy<d>()</>

Received: <r>false</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() false is falsy 2"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeFalsy<d>()</>

Received: <r>false</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() true is truthy 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeTruthy<d>()</>

Received: <r>true</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() true is truthy 2"] = [=[

<d>expect(</><r>received</><d>).</>toBeFalsy<d>()</>

Received: <r>true</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() nil is falsy 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeTruthy<d>()</>

Received: <r>nil</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() nil is falsy 2"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeFalsy<d>()</>

Received: <r>nil</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() does not accept arguments 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeTruthy<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>1</>
]=]

snapshots[".toBeTruthy(), .toBeFalsy() does not accept arguments 2"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeFalsy<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>1</>
]=]

snapshots[".toContain(), .toContainEqual() '\"11112111\"' contains '\"2\"' 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toContain<d>(</><g>expected</><d>) -- string.find or table.find</>

Expected substring: never <g>"2"</>
Received string:          <r>"1111</><i>2</i><r>111</>"
]=]

snapshots[".toContain(), .toContainEqual() '\"abcdef\"' contains '\"abc\"' 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toContain<d>(</><g>expected</><d>) -- string.find or table.find</>

Expected substring: never <g>"abc"</>
Received string:          <r>"</><i>abc</i><r>def</>"
]=]

snapshots['.toContain(), .toContainEqual() \'{"a", "b", "c", "d"}\' contains \'"a"\' 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toContain<d>(</><g>expected</><d>) -- string.find or table.find</>

Expected value: never <g>"a"</>
Received table:       <r>{</><i>"a"</i><r>, </><r>"b"</><r>, </><r>"c"</><r>, </><r>"d"</><r>}</>
]=]

snapshots['.toContain(), .toContainEqual() \'{"a", "b", "c", "d"}\' contains a value equal to \'"a"\' 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toContainEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected value: never <g>"a"</>
Received table:       <r>{</><i>"a"</i><r>, </><r>"b"</><r>, </><r>"c"</><r>, </><r>"d"</><r>}</>
]=]

snapshots['.toContain(), .toContainEqual() \'{{"a": "b"}, {"a": "c"}}\' contains a value equal to \'{"a": "b"}\' 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toContainEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected value: never <g>{"a": "b"}</>
Received table:       <r>{</><i>{"a": "b"}</i><r>, </><r>{"a": "c"}</><r>}</>
]=]

snapshots['.toContain(), .toContainEqual() \'{{"a": "b"}, {"a": "c"}}\' does not contain a value equal to \'{"a": "d"}\' 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toContainEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected value: <g>{"a": "d"}</>
Received table: <r>{{"a": "b"}, {"a": "c"}}</>
]=]

snapshots[".toContain(), .toContainEqual() '{{}, {}}' does not contain '{}' 1"] = [=[

<d>expect(</><r>received</><d>).</>toContain<d>(</><g>expected</><d>) -- string.find or table.find</>

Expected value: <g>{}</>
Received table: <r>{{}, {}}</>

Looks like you wanted to test for object/array equality with the stricter `toContain` matcher. You probably need to use `toContainEqual` instead.
]=]

snapshots[".toContain(), .toContainEqual() '{0, 1}' contains '1' 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toContain<d>(</><g>expected</><d>) -- string.find or table.find</>

Expected value: never <g>1</>
Received table:       <r>{</><r>0</><r>, </><i>1</i><r>}</>
]=]

snapshots[".toContain(), .toContainEqual() '{0, 1}' contains a value equal to '1' 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toContainEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected value: never <g>1</>
Received table:       <r>{</><r>0</><r>, </><i>1</i><r>}</>
]=]

snapshots[".toContain(), .toContainEqual() '{1, 2, 3, 4}' contains '1' 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toContain<d>(</><g>expected</><d>) -- string.find or table.find</>

Expected value: never <g>1</>
Received table:       <r>{</><i>1</i><r>, </><r>2</><r>, </><r>3</><r>, </><r>4</><r>}</>
]=]

snapshots[".toContain(), .toContainEqual() '{1, 2, 3, 4}' contains a value equal to '1' 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toContainEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected value: never <g>1</>
Received table:       <r>{</><i>1</i><r>, </><r>2</><r>, </><r>3</><r>, </><r>4</><r>}</>
]=]

snapshots[".toContain(), .toContainEqual() '{{1, 2}, {3, 4}}' contains a value equal to '{3, 4}' 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toContainEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected value: never <g>{3, 4}</>
Received table:       <r>{</><r>{1, 2}</><r>, </><i>{3, 4}</i><r>}</>
]=]

snapshots[".toContain(), .toContainEqual() '{1, 2, 3}' does not contain '4' 1"] = [=[

<d>expect(</><r>received</><d>).</>toContain<d>(</><g>expected</><d>) -- string.find or table.find</>

Expected value: <g>4</>
Received table: <r>{1, 2, 3}</>
]=]

snapshots[".toContain(), .toContainEqual() '{Symbol(a)}' contains 'Symbol(a)' 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toContain<d>(</><g>expected</><d>) -- string.find or table.find</>

Expected value: never <g>Symbol(a)</>
Received table:       <r>{</><i>Symbol(a)</i><r>}</>
]=]

snapshots[".toContain(), .toContainEqual() '{Symbol(a)}' contains a value equal to 'Symbol(a)' 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toContainEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected value: never <g>Symbol(a)</>
Received table:       <r>{</><i>Symbol(a)</i><r>}</>
]=]

snapshots[".toContain(), .toContainEqual() error cases 1"] = [=[

<d>expect(</><r>received</><d>).</>toContain<d>(</><g>expected</><d>) -- string.find or table.find</>

<b>Matcher error</>: <r>received</> value must not be nil

Received has value: <r>nil</>
]=]

snapshots[".toContain(), .toContainEqual() error cases 2"] = [=[

<d>expect(</><r>-0</><d>).</>toContain<d>(</><g>-0</><d>) -- string.find or table.find</>

<b>Matcher error</>: <g>expected</> value must be a string if <r>received</> value is a string

Expected has type:  number
Expected has value: <g>-0</>
Received has type:  string
Received has value: <r>"-0"</>
]=]

snapshots[".toContain(), .toContainEqual() error cases 3"] = [=[

<d>expect(</><r>nil</><d>).</>toContain<d>(</><g>nil</><d>) -- string.find or table.find</>

<b>Matcher error</>: <g>expected</> value must be a string if <r>received</> value is a string

Expected has value: <g>nil</>
Received has type:  string
Received has value: <r>"nil"</>
]=]

snapshots[".toContain(), .toContainEqual() error cases 4"] = [=[

<d>expect(</><r>null</><d>).</>toContain<d>(</><g>nil</><d>) -- string.find or table.find</>

<b>Matcher error</>: <g>expected</> value must be a string if <r>received</> value is a string

Expected has value: <g>nil</>
Received has type:  string
Received has value: <r>"null"</>
]=]

snapshots[".toContain(), .toContainEqual() error cases 5"] = [=[

<d>expect(</><r>undefined</><d>).</>toContain<d>(</><g>nil</><d>) -- string.find or table.find</>

<b>Matcher error</>: <g>expected</> value must be a string if <r>received</> value is a string

Expected has value: <g>nil</>
Received has type:  string
Received has value: <r>"undefined"</>
]=]

snapshots[".toContain(), .toContainEqual() error cases 6"] = [=[

<d>expect(</><r>false</><d>).</>toContain<d>(</><g>false</><d>) -- string.find or table.find</>

<b>Matcher error</>: <g>expected</> value must be a string if <r>received</> value is a string

Expected has type:  boolean
Expected has value: <g>false</>
Received has type:  string
Received has value: <r>"false"</>
]=]

snapshots[".toContain(), .toContainEqual() error cases for toContainEqual 1"] = [=[

<d>expect(</><r>received</><d>).</>toContainEqual<d>(</><g>expected</><d>) -- deep equality</>

<b>Matcher error</>: <r>received</> value must not be nil

Received has value: <r>nil</>
]=]

snapshots['.toEqual() {pass: false} expect("1 234,57 $").toEqual("1 234,57 $") 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>"1<i> </i>234,57<i> </i>$"</>
Received: <r>"1<i> </i>234,57<i> </i>$"</>
]=]

snapshots['.toEqual() {pass: false} expect("Eve").toEqual({"asymmetricMatch": [Function asymmetricMatch]}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>{"asymmetricMatch": [Function asymmetricMatch]}</>
Received: <r>"Eve"</>
]=]

snapshots['.toEqual() {pass: false} expect("abd").toEqual(StringContaining "bc") 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>StringContaining "bc"</>
Received: <r>"abd"</>
]=]

snapshots['.toEqual() {pass: false} expect("abd").toEqual(StringMatching "bc") 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>StringMatching "bc"</>
Received: <r>"abd"</>
]=]

snapshots['.toEqual() {pass: false} expect("banana").toEqual("apple") 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>"apple"</>
Received: <r>"banana"</>
]=]

snapshots['.toEqual() {pass: false} expect("type TypeName<T> = T extends Function ? \\"function\\" : \\"object\\";").toEqual("type TypeName<T> = T extends Function\n? \\"function\\"\n: \\"object\\";") 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 3</>
<r>+ Received  + 1</>

<g>- type TypeName<T> = T extends Function</>
<g>- ? "function"</>
<g>- : "object";</>
<r>+ type TypeName<T> = T extends Function<i> </i>? "function"<i> </i>: "object";</>
]=]

snapshots[".toEqual() {pass: false} expect({1, 3}).toEqual(ArrayContaining {1, 2}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>ArrayContaining {1, 2}</>
Received: <r>{1, 3}</>
]=]

snapshots[".toEqual() {pass: false} expect({1}).toEqual({2}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   2,</>
<r>+   1,</>
<d>  }</>
]=]

snapshots[".toEqual() {pass: false} expect({97, 98, 99}).toEqual({97, 98, 100}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    97,</>
<d>    98,</>
<g>-   100,</>
<r>+   99,</>
<d>  }</>
]=]

snapshots['.toEqual() {pass: false} expect({"a": 1, "b": 2}).toEqual(ObjectContaining {"a": 2}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>ObjectContaining {"a": 2}</>
Received: <r>{"a": 1, "b": 2}</>
]=]

snapshots['.toEqual() {pass: false} expect({"a": 1}).toEqual({"a": 2}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "a": 2,</>
<r>+   "a": 1,</>
<d>  }</>
]=]

snapshots['.toEqual() {pass: false} expect({"a": 5}).toEqual({"b": 6}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "b": 6,</>
<r>+   "a": 5,</>
<d>  }</>
]=]

snapshots['.toEqual() {pass: false} expect({"foo": {"bar": 1}}).toEqual({"foo": {}}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 3</>

<d>  Table {</>
<g>-   "foo": Table {},</>
<r>+   "foo": Table {</>
<r>+     "bar": 1,</>
<r>+   },</>
<d>  }</>
]=]

snapshots['.toEqual() {pass: false} expect({"nodeName": "div", "nodeType": 1}).toEqual({"nodeName": "p", "nodeType": 1}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "nodeName": "p",</>
<r>+   "nodeName": "div",</>
<d>    "nodeType": 1,</>
<d>  }</>
]=]

snapshots['.toEqual() {pass: false} expect({"target": {"nodeType": 1, "value": "a"}}).toEqual({"target": {"nodeType": 1, "value": "b"}}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    "target": Table {</>
<d>      "nodeType": 1,</>
<g>-     "value": "b",</>
<r>+     "value": "a",</>
<d>    },</>
<d>  }</>
]=]

snapshots[".toEqual() {pass: false} expect({Symbol(bar): 2, Symbol(foo): 1}).toEqual({Symbol(bar): 1, Symbol(foo): Any<number>}) 1"] =
	[=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   Symbol(bar): 1,</>
<r>+   Symbol(bar): 2,</>
<d>    Symbol(foo): Any<number>,</>
<d>  }</>
]=]

snapshots[".toEqual() {pass: false} expect({4294967295: 1}).toEqual({4294967295: 2}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   4294967295: 2,</>
<r>+   4294967295: 1,</>
<d>  }</>
]=]

snapshots[".toEqual() {pass: false} expect({Symbol(): 1}).toEqual({Symbol(): 1}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>{Symbol(): 1}</>
Received: serializes to the same string
]=]

snapshots['.toEqual() {pass: false} expect({"a": 1}).toEqual({"b": 1}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "b": 1,</>
<r>+   "a": 1,</>
<d>  }</>
]=]

snapshots['.toEqual() {pass: false} expect({"-0": 1}).toEqual({"0": 1}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "0": 1,</>
<r>+   "-0": 1,</>
<d>  }</>
]=]

snapshots[".toEqual() {pass: false} expect(0).toEqual(1) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>1</>
Received: <r>0</>
]=]

snapshots[".toEqual() {pass: false} expect(0).toEqual(-9007199254740991) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>-9007199254740991</>
Received: <r>0</>
]=]

snapshots[".toEqual() {pass: false} expect(1).toEqual(2) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>2</>
Received: <r>1</>
]=]

snapshots[".toEqual() {pass: false} expect(1).toEqual(ArrayContaining {1, 2}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>ArrayContaining {1, 2}</>
Received: <r>1</>
]=]

snapshots[".toEqual() {pass: false} expect(-9007199254740991).toEqual(0) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>0</>
Received: <r>-9007199254740991</>
]=]

snapshots['.toEqual() {pass: false} expect({"1": {"2": {"a": 99}}}).toEqual({"1": {"2": {"a": 11}}}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    "1": Table {</>
<d>      "2": Table {</>
<g>-       "a": 11,</>
<r>+       "a": 99,</>
<d>      },</>
<d>    },</>
<d>  }</>
]=]

snapshots['.toEqual() {pass: false} expect({"a": 0}).toEqual({"b": 0}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "b": 0,</>
<r>+   "a": 0,</>
<d>  }</>
]=]

snapshots[".toEqual() {pass: false} expect({1, 2}).toEqual({2, 1}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   2,</>
<d>    1,</>
<r>+   2,</>
<d>  }</>
]=]

snapshots[".toEqual() {pass: false} expect({1, 2}).toEqual({}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 4</>

<g>- Table {}</>
<r>+ Table {</>
<r>+   1,</>
<r>+   2,</>
<r>+ }</>
]=]

snapshots['.toEqual() {pass: false} expect({"v": 1}).toEqual({"v": 2}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "v": 2,</>
<r>+   "v": 1,</>
<d>  }</>
]=]

snapshots['.toEqual() {pass: false} expect({{"v"}: 1}).toEqual({{"v"}: 2}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    Table {</>
<d>      "v",</>
<g>-   }: 2,</>
<r>+   }: 1,</>
<d>  }</>
]=]

snapshots['.toEqual() {pass: false} expect({{1}: {{1}: "one"}}).toEqual({{1}: {{1}: "two"}}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<y>@@ -2,8 +2,8 @@</>
<d>    Table {</>
<d>      1,</>
<d>    }: Table {</>
<d>      Table {</>
<d>        1,</>
<g>-     }: "two",</>
<r>+     }: "one",</>
<d>    },</>
<d>  }</>
]=]

snapshots['.toEqual() {pass: false} expect({"one", "two"}).toEqual({"one"}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 0</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    "one",</>
<r>+   "two",</>
<d>  }</>
]=]

snapshots[".toEqual() {pass: false} expect({{1}, {2}}).toEqual({{1}, {2}, {2}}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 3</>
<r>+ Received  + 0</>

<y>@@ -3,9 +3,6 @@</>
<d>      1,</>
<d>    },</>
<d>    Table {</>
<d>      2,</>
<d>    },</>
<g>-   Table {</>
<g>-     2,</>
<g>-   },</>
<d>  }</>
]=]

snapshots[".toEqual() {pass: false} expect({{1}, {2}}).toEqual({{1}, {2}, {3}}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 3</>
<r>+ Received  + 0</>

<y>@@ -3,9 +3,6 @@</>
<d>      1,</>
<d>    },</>
<d>    Table {</>
<d>      2,</>
<d>    },</>
<g>-   Table {</>
<g>-     3,</>
<g>-   },</>
<d>  }</>
]=]

snapshots[".toEqual() {pass: false} expect({1, 2}).toEqual({1, 2, 3}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 0</>

<d>  Table {</>
<d>    1,</>
<d>    2,</>
<g>-   3,</>
<d>  }</>
]=]

snapshots[".toEqual() {pass: false} expect({{1}, {2}}).toEqual({{1}, {3}}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    Table {</>
<d>      1,</>
<d>    },</>
<d>    Table {</>
<g>-     3,</>
<r>+     2,</>
<d>    },</>
<d>  }</>
]=]

snapshots['.toEqual() {pass: false} expect(false).toEqual(ObjectContaining {"a": 2}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>ObjectContaining {"a": 2}</>
Received: <r>false</>
]=]

snapshots[".toEqual() {pass: false} expect(true).toEqual(false) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>false</>
Received: <r>true</>
]=]

snapshots[".toEqual() {pass: false} expect(nil).toEqual(Any<function>) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>Any<function></>
Received: <r>nil</>
]=]

snapshots[".toEqual() {pass: false} expect(nil).toEqual(Anything) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>Anything</>
Received: <r>nil</>
]=]

snapshots['.toEqual() {pass: true} expect("Alice").never.toEqual({"asymmetricMatch": [Function asymmetricMatch]}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>{"asymmetricMatch": [Function asymmetricMatch]}</>
Received:       <r>"Alice"</>
]=]

snapshots['.toEqual() {pass: true} expect("abc").never.toEqual("abc") 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>"abc"</>

]=]

snapshots['.toEqual() {pass: true} expect("abcd").never.toEqual(StringContaining "bc") 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>StringContaining "bc"</>
Received:       <r>"abcd"</>
]=]

snapshots['.toEqual() {pass: true} expect("abcd").never.toEqual(StringMatching "bc") 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>StringMatching "bc"</>
Received:       <r>"abcd"</>
]=]

snapshots[".toEqual() {pass: true} expect({1, 2, 3}).never.toEqual(ArrayContaining {2, 3}) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>ArrayContaining {2, 3}</>
Received:       <r>{1, 2, 3}</>
]=]

snapshots[".toEqual() {pass: true} expect({1}).never.toEqual({1}) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>{1}</>

]=]

snapshots[".toEqual() {pass: true} expect({97, 98, 99}).never.toEqual({97, 98, 99}) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>{97, 98, 99}</>

]=]

snapshots[".toEqual() {pass: true} expect([Function anonymous]).never.toEqual(Any<function>) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>Any<function></>
Received:       <r>[Function anonymous]</>
]=]

snapshots['.toEqual() {pass: true} expect({"a": 1, "b": [Function b], "c": true}).never.toEqual({"a": 1, "b": Any<function>, "c": Anything}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>{"a": 1, "b": Any<function>, "c": Anything}</>
Received:       <r>{"a": 1, "b": [Function b], "c": true}</>
]=]

snapshots['.toEqual() {pass: true} expect({"a": 1, "b": 2}).never.toEqual(ObjectContaining {"a": 1}) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>ObjectContaining {"a": 1}</>
Received:       <r>{"a": 1, "b": 2}</>
]=]

snapshots['.toEqual() {pass: true} expect({"a": 99}).never.toEqual({"a": 99}) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>{"a": 99}</>

]=]

snapshots['.toEqual() {pass: true} expect({"nodeName": "div", "nodeType": 1}).never.toEqual({"nodeName": "div", "nodeType": 1}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>{"nodeName": "div", "nodeType": 1}</>

]=]

snapshots[".toEqual() {pass: true} expect({}).never.toEqual({}) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>{}</>

]=]

snapshots[".toEqual() {pass: true} expect(0).never.toEqual(0) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>0</>

]=]

snapshots[".toEqual() {pass: true} expect(1).never.toEqual(1) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>1</>

]=]

snapshots['.toEqual() {pass: true} expect({{2: {"a": 99}}}).never.toEqual({{2: {"a": 99}}}) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>{{2: {"a": 99}}}</>

]=]

snapshots['.toEqual() {pass: true} expect({"one", "two"}).never.toEqual({"one", "two"}) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>{"one", "two"}</>

]=]

snapshots[".toEqual() {pass: true} expect({1, 2}).never.toEqual({1, 2}) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>{1, 2}</>

]=]

snapshots['.toEqual() {pass: true} expect({{"one"}, {"two"}}).never.toEqual({{"one"}, {"two"}}) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>{{"one"}, {"two"}}</>

]=]
snapshots[".toEqual() {pass: true} expect(nan).never.toEqual(nan) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>nan</>

]=]

snapshots[".toEqual() {pass: true} expect(true).never.toEqual(Anything) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>Anything</>
Received:       <r>true</>
]=]

snapshots[".toEqual() {pass: true} expect(true).never.toEqual(true) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>true</>

]=]

snapshots['.toHaveLength {pass: false} expect("").toHaveLength(1) 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveLength<d>(</><g>expected</><d>)</>

Expected length: <g>1</>
Received length: <r>0</>
Received string: <r>""</>
]=]

snapshots['.toHaveLength {pass: false} expect("abc").toHaveLength(66) 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveLength<d>(</><g>expected</><d>)</>

Expected length: <g>66</>
Received length: <r>3</>
Received string: <r>"abc"</>
]=]

snapshots['.toHaveLength {pass: false} expect({"a", "b"}).toHaveLength(99) 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveLength<d>(</><g>expected</><d>)</>

Expected length: <g>99</>
Received length: <r>2</>
Received table:  <r>{"a", "b"}</>
]=]

snapshots[".toHaveLength {pass: false} expect({}).toHaveLength(1) 1"] = [=[

<d>expect(</><r>received</><d>).</>toHaveLength<d>(</><g>expected</><d>)</>

Expected length: <g>1</>
Received length: <r>0</>
Received table:  <r>{}</>
]=]

snapshots[".toHaveLength {pass: false} expect({1, 2}).toHaveLength(3) 1"] = [=[

<d>expect(</><r>received</><d>).</>toHaveLength<d>(</><g>expected</><d>)</>

Expected length: <g>3</>
Received length: <r>2</>
Received table:  <r>{1, 2}</>
]=]

snapshots['.toHaveLength {pass: true} expect("").toHaveLength(0) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveLength<d>(</><g>expected</><d>)</>

Expected length: never <g>0</>
Received string:       <r>""</>
]=]

snapshots['.toHaveLength {pass: true} expect({"a", "b"}).toHaveLength(2) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveLength<d>(</><g>expected</><d>)</>

Expected length: never <g>2</>
Received table:        <r>{"a", "b"}</>
]=]

snapshots[".toHaveLength {pass: true} expect({}).toHaveLength(0) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveLength<d>(</><g>expected</><d>)</>

Expected length: never <g>0</>
Received table:        <r>{}</>
]=]

snapshots[".toHaveLength {pass: true} expect({1, 2}).toHaveLength(2) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveLength<d>(</><g>expected</><d>)</>

Expected length: never <g>2</>
Received table:        <r>{1, 2}</>
]=]

snapshots[".toHaveLength error cases 1"] = [=[

<d>expect(</><r>received</><d>).</>toHaveLength<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must have a length property whose value must be a number

Received has type:  table
Received has value: <r>{"a": 9}</>
]=]

snapshots[".toHaveLength error cases 2"] = [=[

<d>expect(</><r>received</><d>).</>toHaveLength<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must have a length property whose value must be a number

Received has type:  number
Received has value: <r>0</>
]=]

snapshots[".toHaveLength error cases 3"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveLength<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must have a length property whose value must be a number

Received has value: <r>nil</>
]=]

snapshots[".toHaveLength matcher error expected length not number 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveLength<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"3"</>
]=]

snapshots[".toHaveLength matcher error expected length number Infinity 1"] = [=[

<d>expect(</><r>received</><d>).</>toHaveLength<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  number
Expected has value: <g>inf</>
]=]

snapshots[".toHaveLength matcher error expected length number NaN 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveLength<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  number
Expected has value: <g>nan</>
]=]

snapshots[".toHaveLength matcher error expected length number float 1"] = [=[

<d>expect(</><r>received</><d>).</>toHaveLength<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  number
Expected has value: <g>0.5</>
]=]

snapshots[".toHaveLength matcher error expected length number negative integer 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveLength<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  number
Expected has value: <g>-3</>
]=]

snapshots['.toHaveProperty() {error} expect({"a": {"b": {}}}).toHaveProperty(1) 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>)</>

<b>Matcher error</>: <g>expected</> path must be a string or array

Expected has type:  number
Expected has value: <g>1</>
]=]

snapshots['.toHaveProperty() {error} expect({"a": {"b": {}}}).toHaveProperty(nil) 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>)</>

<b>Matcher error</>: <g>expected</> path must be a string or array

Expected has value: <g>nil</>
]=]

snapshots[".toHaveProperty() {error} expect({}).toHaveProperty({}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>)</>

<b>Matcher error</>: <g>expected</> path must not be an empty array

Expected has type:  table
Expected has value: <g>{}</>
]=]

snapshots['.toHaveProperty() {error} expect(nil).toHaveProperty("a.b") 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>)</>

<b>Matcher error</>: <r>received</> value must not be nil

Received has value: <r>nil</>
]=]

snapshots['.toHaveProperty() {error} expect(nil).toHaveProperty("a") 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>)</>

<b>Matcher error</>: <r>received</> value must not be nil

Received has value: <r>nil</>
]=]

snapshots['.toHaveProperty() {pass: false} expect("abc").toHaveProperty("a.b.c", {"a": 5}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a.b.c"</>
Received path: <r>{}</>

Expected value: <g>{"a": 5}</>
Received value: <r>"abc"</>
]=]

snapshots['.toHaveProperty() {pass: false} expect({"a": {"b": {"c": {"d": 1}}}}).toHaveProperty({"a", "b", "c", "d"}, 2) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>{"a", "b", "c", "d"}</>

Expected value: <g>2</>
Received value: <r>1</>
]=]

snapshots['.toHaveProperty() {pass: false} expect({"a": {"b": {"c": {"d": 1}}}}).toHaveProperty("a.b.c.d", 2) 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a.b.c.d"</>

Expected value: <g>2</>
Received value: <r>1</>
]=]

snapshots['.toHaveProperty() {pass: false} expect({"a": {"b": {"c": {"d": 1}}}}).toHaveProperty("a.b.ttt.d", 1) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a.b.ttt.d"</>
Received path: <r>"a.b"</>

Expected value: <g>1</>
Received value: <r>{"c": {"d": 1}}</>
]=]

snapshots['.toHaveProperty() {pass: false} expect({"a": {"b": {"c": {}}}}).toHaveProperty("a.b.c.d", 1) 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a.b.c.d"</>
Received path: <r>"a.b.c"</>

Expected value: <g>1</>
Received value: <r>{}</>
]=]

snapshots['.toHaveProperty() {pass: false} expect({"a": {"b": {"c": 5}}}).toHaveProperty("a.b", {"c": 4}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a.b"</>

<g>- Expected value  - 1</>
<r>+ Received value  + 1</>

<d>  Table {</>
<g>-   "c": 4,</>
<r>+   "c": 5,</>
<d>  }</>
]=]

snapshots['.toHaveProperty() {pass: false} expect({"a": 1}).toHaveProperty("a.b.c.d", 5) 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a.b.c.d"</>
Received path: <r>"a"</>

Expected value: <g>5</>
Received value: <r>1</>
]=]

snapshots['.toHaveProperty() {pass: false} expect({"a.b.c.d": 1}).toHaveProperty("a.b.c.d", 2) 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a.b.c.d"</>
Received path: <r>{}</>

Expected value: <g>2</>
Received value: <r>{"a.b.c.d": 1}</>
]=]

snapshots['.toHaveProperty() {pass: false} expect({"a.b.c.d": 1}).toHaveProperty({"a.b.c.d"}, 2) 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>{"a.b.c.d"}</>

Expected value: <g>2</>
Received value: <r>1</>
]=]

snapshots['.toHaveProperty() {pass: false} expect({"children": {"\\"That cartoon\\""}, "type": "p"}).toHaveProperty({"children", 1}, "\\"That cat cartoon\\"") 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>{"children", 1}</>

Expected value: <g>"\"That <i>cat </i>cartoon\""</>
Received value: <r>"\"That cartoon\""</>
]=]

snapshots['.toHaveProperty() {pass: false} expect({"children": {"Roses are red.\nViolets are blue.\nTesting with Jest is good for you."}, "type": "pre"}).toHaveProperty({"children", 1}, "Roses are red, violets are blue.\nTesting with Jest\nIs good for you.") 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>{"children", 1}</>

<g>- Expected value  - 3</>
<r>+ Received value  + 3</>

<g>- Roses are red<i>, v</i>iolets are blue.</>
<r>+ Roses are red<i>.</i></>
<r>+ <i>V</i>iolets are blue.</>
<g>- Testing with Jest</>
<g>- <i>I</i>s good for you.</>
<r>+ Testing with Jest<i> i</i>s good for you.</>
]=]

snapshots['.toHaveProperty() {pass: false} expect({}).toHaveProperty("a", "test") 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a"</>
Received path: <r>{}</>

Expected value: <g>"test"</>
Received value: <r>{}</>
]=]

snapshots['.toHaveProperty() {pass: false} expect(1).toHaveProperty("a.b.c", "test") 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a.b.c"</>
Received path: <r>{}</>

Expected value: <g>"test"</>
Received value: <r>1</>
]=]

snapshots['.toHaveProperty() {pass: true} expect("").toHaveProperty("len", Any<function>) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"len"</>

Expected value: never <g>Any<function></>
Received value:       <r>[Function len]</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {1, 2, 3}}}).toHaveProperty({"a", "b", 2}) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>)</>

Expected path: never <g>{"a", "b", 2}</>

Received value: <r>2</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {1, 2, 3}}}).toHaveProperty({"a", "b", 2}, 2) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>{"a", "b", 2}</>

Expected value: never <g>2</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {1, 2, 3}}}).toHaveProperty({"a", "b", 2}, Any<number>) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>{"a", "b", 2}</>

Expected value: never <g>Any<number></>
Received value:       <r>2</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {{"c": {{"d": 1}}}}}}).toHaveProperty("a.b[1].c[1].d", 1) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a.b[1].c[1].d"</>

Expected value: never <g>1</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {{"c": {"d": {{"e": 1}, {"f": 2}}}}}}}).toHaveProperty("a.b[1].c.d[2].f", 2) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a.b[1].c.d[2].f"</>

Expected value: never <g>2</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {{{"c": {{"d": 1}}}}}}}).toHaveProperty("a.b[1][1].c[1].d", 1) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a.b[1][1].c[1].d"</>

Expected value: never <g>1</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {"c": {"d": 1}}}}).toHaveProperty({"a", "b", "c", "d"}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>)</>

Expected path: never <g>{"a", "b", "c", "d"}</>

Received value: <r>1</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {"c": {"d": 1}}}}).toHaveProperty({"a", "b", "c", "d"}, 1) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>{"a", "b", "c", "d"}</>

Expected value: never <g>1</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {"c": {"d": 1}}}}).toHaveProperty("a.b.c.d") 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>)</>

Expected path: never <g>"a.b.c.d"</>

Received value: <r>1</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {"c": {"d": 1}}}}).toHaveProperty("a.b.c.d", 1) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a.b.c.d"</>

Expected value: never <g>1</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {"c": 5}}}).toHaveProperty("a.b", {"c": 5}) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a.b"</>

Expected value: never <g>{"c": 5}</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": false}}).toHaveProperty("a.b") 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>)</>

Expected path: never <g>"a.b"</>

Received value: <r>false</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": false}}).toHaveProperty("a.b", false) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a.b"</>

Expected value: never <g>false</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": 0}).toHaveProperty("a") 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>)</>

Expected path: never <g>"a"</>

Received value: <r>0</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": 0}).toHaveProperty("a", 0) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"a"</>

Expected value: never <g>0</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a.b.c.d": 1}).toHaveProperty({"a.b.c.d"}) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>)</>

Expected path: never <g>{"a.b.c.d"}</>

Received value: <r>1</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"a.b.c.d": 1}).toHaveProperty({"a.b.c.d"}, 1) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>{"a.b.c.d"}</>

Expected value: never <g>1</>
]=]

snapshots['.toHaveProperty() {pass: true} expect({"property": 1}).toHaveProperty("property", 1) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveProperty<d>(</><g>path</><d>, </><g>value</><d>)</>

Expected path: <g>"property"</>

Expected value: never <g>1</>
]=]

snapshots['.toMatch() throws if non String actual value passed: [/foo/i, "foo"] 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatch<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a string

Received has type:  regexp
Received has value: <r>/foo/i</>
]=]

snapshots['.toMatch() throws if non String actual value passed: [[Function anonymous], "foo"] 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatch<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a string

Received has type:  function
Received has value: <r>[Function anonymous]</>
]=]

snapshots['.toMatch() throws if non String actual value passed: [{}, "foo"] 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatch<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a string

Received has type:  table
Received has value: <r>{}</>
]=]

snapshots['.toMatch() throws if non String actual value passed: [1, "foo"] 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatch<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a string

Received has type:  number
Received has value: <r>1</>
]=]

snapshots['.toMatch() throws if non String actual value passed: [true, "foo"] 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatch<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a string

Received has type:  boolean
Received has value: <r>true</>
]=]

snapshots['.toMatch() throws if non String actual value passed: [nil, "foo"] 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatch<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a string

Received has value: <r>nil</>
]=]

snapshots['.toMatch() throws if non String/RegExp expected value passed: ["foo", [Function anonymous]] 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatch<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a string or regular expression

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

snapshots['.toMatch() throws if non String/RegExp expected value passed: ["foo", {}] 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatch<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a string or regular expression

Expected has type:  table
Expected has value: <g>{}</>
]=]

snapshots['.toMatch() throws if non String/RegExp expected value passed: ["foo", 1] 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatch<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a string or regular expression

Expected has type:  number
Expected has value: <g>1</>
]=]

snapshots['.toMatch() throws if non String/RegExp expected value passed: ["foo", true] 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatch<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a string or regular expression

Expected has type:  boolean
Expected has value: <g>true</>
]=]

snapshots['.toMatch() throws if non String/RegExp expected value passed: ["foo", nil] 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatch<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a string or regular expression

Expected has value: <g>nil</>
]=]

snapshots[".toMatch() throws: [bar, /foo/] 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatch<d>(</><g>expected</><d>)</>

Expected pattern: <g>/foo/</>
Received string:  <r>"bar"</>
]=]

snapshots[".toMatch() throws: [bar, foo] 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatch<d>(</><g>expected</><d>)</>

Expected pattern: <g>"foo"</>
Received string:  <r>"bar"</>
]=]

snapshots[".toStrictEqual() displays substring diff 1"] = [=[

<d>expect(</><r>received</><d>).</>toStrictEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>"<i>Another caveat is that</i> Jest will not typecheck your tests."</>
Received: <r>"<i>Because TypeScript support in Babel is just transpilation,</i> Jest will not type<i>-</i>check your tests<i> as they run</i>."</>
]=]

snapshots[".toStrictEqual() displays substring diff for multiple lines 1"] = [=[

<d>expect(</><r>received</><d>).</>toStrictEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 7</>
<r>+ Received  + 7</>

<g>-     6<i>9</i> |<Y> </></>
<r>+     6<i>8</i> |<Y> </></>
<g>-     <i>70</i> | test('assert.doesNotThrow', () => {</>
<r>+     <i>69</i> | test('assert.doesNotThrow', () => {</>
<g>-   > 7<i>1</i> |   assert.doesNotThrow(() => {</>
<r>+   > 7<i>0</i> |   assert.doesNotThrow(() => {</>
<d>         |          ^</>
<g>-     7<i>2</i> |     throw Error('err!');</>
<r>+     7<i>1</i> |     throw Error('err!');</>
<g>-     7<i>3</i> |   });</>
<r>+     7<i>2</i> |   });</>
<g>-     7<i>4</i> | });</>
<r>+     7<i>3</i> | });</>
<g>-     at Object.doesNotThrow (__tests__/assertionError.test.js:7<i>1</i>:10)</>
<r>+     at Object.doesNotThrow (__tests__/assertionError.test.js:7<i>0</i>:10)</>
]=]

snapshots[".toStrictEqual() matches the expected snapshot when it fails 1"] = [=[

<d>expect(</><r>received</><d>).</>toStrictEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 4</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "test": Table {</>
<g>-     "a": 1,</>
<g>-     "b": 2,</>
<g>-   },</>
<r>+   "test": 2,</>
<d>  }</>
]=]

snapshots[".toStrictEqual() matches the expected snapshot when it fails 2"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toStrictEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: not <g>{"test": {"a": 1, "b": 2}}</>

]=]

snapshots["toMatchObject() {pass: false} expect({0}).toMatchObject({-0}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   -0,</>
<r>+   0,</>
<d>  }</>
]=]

snapshots["toMatchObject() {pass: false} expect({1, 2}).toMatchObject({1, 3}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    1,</>
<g>-   3,</>
<r>+   2,</>
<d>  }</>
]=]

snapshots['toMatchObject() {pass: false} expect({"a": "a", "c": "d"}).toMatchObject({"a": Any<number>}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "a": Any<number>,</>
<r>+   "a": "a",</>
<d>  }</>
]=]

snapshots['toMatchObject() {pass: false} expect({"a": "b", "c": "d"}).toMatchObject({"a": "b!", "c": "d"}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "a": "b!",</>
<r>+   "a": "b",</>
<d>    "c": "d",</>
<d>  }</>
]=]

snapshots['toMatchObject() {pass: false} expect({"a": "b", "c": "d"}).toMatchObject({"e": "b"}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 1</>
<r>+ Received  + 2</>

<d>  Table {</>
<g>-   "e": "b",</>
<r>+   "a": "b",</>
<r>+   "c": "d",</>
<d>  }</>
]=]

snapshots['toMatchObject() {pass: false} expect({"a": "b", "t": {"x": {"r": "r"}, "z": "z"}}).toMatchObject({"a": "b", "t": {"z": {3}}}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 3</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    "a": "b",</>
<d>    "t": Table {</>
<g>-     "z": Table {</>
<g>-       3,</>
<g>-     },</>
<r>+     "z": "z",</>
<d>    },</>
<d>  }</>
]=]

snapshots['toMatchObject() {pass: false} expect({"a": "b", "t": {"x": {"r": "r"}, "z": "z"}}).toMatchObject({"t": {"l": {"r": "r"}}}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 1</>
<r>+ Received  + 2</>

<d>  Table {</>
<d>    "t": Table {</>
<g>-     "l": Table {</>
<r>+     "x": Table {</>
<d>        "r": "r",</>
<d>      },</>
<r>+     "z": "z",</>
<d>    },</>
<d>  }</>
]=]

snapshots['toMatchObject() {pass: false} expect({"a": {3, 4, "v"}, "b": "b"}).toMatchObject({"a": {"v"}}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 0</>
<r>+ Received  + 2</>

<d>  Table {</>
<d>    "a": Table {</>
<r>+     3,</>
<r>+     4,</>
<d>      "v",</>
<d>    },</>
<d>  }</>
]=]

snapshots['toMatchObject() {pass: false} expect({"a": {3, 4, 5}, "b": "b"}).toMatchObject({"a": {3, 4, 5, 6}}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 1</>
<r>+ Received  + 0</>

<d>  Table {</>
<d>    "a": Table {</>
<d>      3,</>
<d>      4,</>
<d>      5,</>
<g>-     6,</>
<d>    },</>
<d>  }</>
]=]

snapshots['toMatchObject() {pass: false} expect({"a": {3, 4, 5}, "b": "b"}).toMatchObject({"a": {3, 4}}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 0</>
<r>+ Received  + 1</>

<d>  Table {</>
<d>    "a": Table {</>
<d>      3,</>
<d>      4,</>
<r>+     5,</>
<d>    },</>
<d>  }</>
]=]

snapshots['toMatchObject() {pass: false} expect({"a": {3, 4, 5}, "b": "b"}).toMatchObject({"a": {"b": 4}}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 1</>
<r>+ Received  + 3</>

<d>  Table {</>
<d>    "a": Table {</>
<g>-     "b": 4,</>
<r>+     3,</>
<r>+     4,</>
<r>+     5,</>
<d>    },</>
<d>  }</>
]=]

-- ROBLOX deviation: snapshot changed since we don't have a difference as Object and Array as in upstream
snapshots['toMatchObject() {pass: false} expect({"a": {3, 4, 5}, "b": "b"}).toMatchObject({"a": {"b": Any<string>}}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 1</>
<r>+ Received  + 3</>

<d>  Table {</>
<d>    "a": Table {</>
<g>-     "b": Any<string>,</>
<r>+     3,</>
<r>+     4,</>
<r>+     5,</>
<d>    },</>
<d>  }</>
]=]

snapshots["toMatchObject() {pass: true} expect({}).toMatchObject({}) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{}</>
]=]

snapshots["toMatchObject() {pass: true} expect({1, 2}).toMatchObject({1, 2}) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{1, 2}</>
]=]

snapshots['toMatchObject() {pass: true} expect({"a": "b", "c": "d", Symbol(jest): "jest"}).toMatchObject({"a": "b", "c": "d", Symbol(jest): "jest"}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{"a": "b", "c": "d", Symbol(jest): "jest"}</>
]=]

snapshots['toMatchObject() {pass: true} expect({"a": "b", "c": "d", Symbol(jest): "jest"}).toMatchObject({"a": "b", Symbol(jest): "jest"}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{"a": "b", Symbol(jest): "jest"}</>
Received:       <r>{"a": "b", "c": "d", Symbol(jest): "jest"}</>
]=]

snapshots['toMatchObject() {pass: true} expect({"a": "b", "c": "d"}).toMatchObject({"a": "b", "c": "d"}) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{"a": "b", "c": "d"}</>
]=]

snapshots['toMatchObject() {pass: true} expect({"a": "b", "c": "d"}).toMatchObject({"a": "b"}) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{"a": "b"}</>
Received:       <r>{"a": "b", "c": "d"}</>
]=]

snapshots['toMatchObject() {pass: true} expect({"a": "b", "t": {"x": {"r": "r"}, "z": "z"}}).toMatchObject({"a": "b", "t": {"z": "z"}}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{"a": "b", "t": {"z": "z"}}</>
Received:       <r>{"a": "b", "t": {"x": {"r": "r"}, "z": "z"}}</>
]=]

snapshots['toMatchObject() {pass: true} expect({"a": "b", "t": {"x": {"r": "r"}, "z": "z"}}).toMatchObject({"t": {"x": {"r": "r"}}}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{"t": {"x": {"r": "r"}}}</>
Received:       <r>{"a": "b", "t": {"x": {"r": "r"}, "z": "z"}}</>
]=]

snapshots['toMatchObject() {pass: true} expect({"a": {{"a": "a", "b": "b"}}}).toMatchObject({"a": {{"a": "a"}}}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{"a": {{"a": "a"}}}</>
Received:       <r>{"a": {{"a": "a", "b": "b"}}}</>
]=]

snapshots['toMatchObject() {pass: true} expect({"a": {3, 4, 5, "v"}, "b": "b"}).toMatchObject({"a": {3, 4, 5, "v"}}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{"a": {3, 4, 5, "v"}}</>
Received:       <r>{"a": {3, 4, 5, "v"}, "b": "b"}</>
]=]

snapshots['toMatchObject() {pass: true} expect({"a": {3, 4, 5}, "b": "b"}).toMatchObject({"a": {3, 4, 5}}) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{"a": {3, 4, 5}}</>
Received:       <r>{"a": {3, 4, 5}, "b": "b"}</>
]=]

snapshots['toMatchObject() {pass: true} expect({"a": {"x": "x", "y": "y"}}).toMatchObject({"a": {"x": Any<string>}}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{"a": {"x": Any<string>}}</>
Received:       <r>{"a": {"x": "x", "y": "y"}}</>
]=]

snapshots['toMatchObject() {pass: true} expect({"a": 1, "c": 2}).toMatchObject({"a": Any<number>}) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{"a": Any<number>}</>
Received:       <r>{"a": 1, "c": 2}</>
]=]

snapshots['toMatchObject() {pass: true} expect({"a": 2015-11-30T00:00:00.000Z, "b": "b"}).toMatchObject({"a": 2015-11-30T00:00:00.000Z}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{"a": 2015-11-30T00:00:00.000Z}</>
Received:       <r>{"a": 2015-11-30T00:00:00.000Z, "b": "b"}</>
]=]

snapshots['toMatchObject() {pass: true} expect({"a": "undefined", "b": "b"}).toMatchObject({"a": "undefined"}) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{"a": "undefined"}</>
Received:       <r>{"a": "undefined", "b": "b"}</>
]=]

snapshots['toMatchObject() circular references simple circular references {pass: false} expect({"a": "hello", "ref": [Circular]}).toMatchObject({"a": "world", "ref": [Circular]}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "a": "world",</>
<r>+   "a": "hello",</>
<d>    "ref": [Circular],</>
<d>  }</>
]=]

snapshots['toMatchObject() circular references simple circular references {pass: false} expect({"ref": "not a ref"}).toMatchObject({"a": "hello", "ref": [Circular]}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 2</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "a": "hello",</>
<g>-   "ref": [Circular],</>
<r>+   "ref": "not a ref",</>
<d>  }</>
]=]

snapshots['toMatchObject() circular references simple circular references {pass: false} expect({}).toMatchObject({"a": "hello", "ref": [Circular]}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 4</>
<r>+ Received  + 1</>

<g>- Table {</>
<g>-   "a": "hello",</>
<g>-   "ref": [Circular],</>
<g>- }</>
<r>+ Table {}</>
]=]

snapshots['toMatchObject() circular references simple circular references {pass: true} expect({"a": "hello", "ref": [Circular]}).toMatchObject({"a": "hello", "ref": [Circular]}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{"a": "hello", "ref": [Circular]}</>
]=]

snapshots['toMatchObject() circular references simple circular references {pass: true} expect({"a": "hello", "ref": [Circular]}).toMatchObject({}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{}</>
Received:       <r>{"a": "hello", "ref": [Circular]}</>
]=]

snapshots['toMatchObject() circular references transitive circular references {pass: false} expect({"a": "world", "nestedObj": {"parentObj": [Circular]}}).toMatchObject({"a": "hello", "nestedObj": {"parentObj": [Circular]}}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "a": "hello",</>
<r>+   "a": "world",</>
<d>    "nestedObj": Table {</>
<d>      "parentObj": [Circular],</>
<d>    },</>
<d>  }</>
]=]

snapshots['toMatchObject() circular references transitive circular references {pass: false} expect({"nestedObj": {"parentObj": "not the parent ref"}}).toMatchObject({"a": "hello", "nestedObj": {"parentObj": [Circular]}}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 2</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "a": "hello",</>
<d>    "nestedObj": Table {</>
<g>-     "parentObj": [Circular],</>
<r>+     "parentObj": "not the parent ref",</>
<d>    },</>
<d>  }</>
]=]

snapshots['toMatchObject() circular references transitive circular references {pass: false} expect({}).toMatchObject({"a": "hello", "nestedObj": {"parentObj": [Circular]}}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 6</>
<r>+ Received  + 1</>

<g>- Table {</>
<g>-   "a": "hello",</>
<g>-   "nestedObj": Table {</>
<g>-     "parentObj": [Circular],</>
<g>-   },</>
<g>- }</>
<r>+ Table {}</>
]=]

snapshots['toMatchObject() circular references transitive circular references {pass: true} expect({"a": "hello", "nestedObj": {"parentObj": [Circular]}}).toMatchObject({"a": "hello", "nestedObj": {"parentObj": [Circular]}}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{"a": "hello", "nestedObj": {"parentObj": [Circular]}}</>
]=]

snapshots['toMatchObject() circular references transitive circular references {pass: true} expect({"a": "hello", "nestedObj": {"parentObj": [Circular]}}).toMatchObject({}) 1'] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>{}</>
Received:       <r>{"a": "hello", "nestedObj": {"parentObj": [Circular]}}</>
]=]

snapshots["toMatchObject() does not match properties up in the prototype chain 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 1</>
<r>+ Received  + 0</>

<d>  Table {</>
<d>    "other": "child",</>
<g>-   "ref": [Circular],</>
<d>  }</>
]=]

snapshots['toMatchObject() throws expect("44").toMatchObject({}) 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a non-nil object

Received has type:  string
Received has value: <r>"44"</>
]=]

snapshots['toMatchObject() throws expect({}).toMatchObject("some string") 1'] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-nil object

Expected has type:  string
Expected has value: <g>"some string"</>
]=]

snapshots["toMatchObject() throws expect({}).toMatchObject(4) 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-nil object

Expected has type:  number
Expected has value: <g>4</>
]=]

snapshots["toMatchObject() throws expect({}).toMatchObject(true) 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-nil object

Expected has type:  boolean
Expected has value: <g>true</>
]=]

snapshots["toMatchObject() throws expect({}).toMatchObject(nil) 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-nil object

Expected has value: <g>nil</>
]=]

snapshots["toMatchObject() throws expect(4).toMatchObject({}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a non-nil object

Received has type:  number
Received has value: <r>4</>
]=]

snapshots["toMatchObject() throws expect(true).toMatchObject({}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a non-nil object

Received has type:  boolean
Received has value: <r>true</>
]=]

snapshots["toMatchObject() throws expect(nil).toMatchObject({}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a non-nil object

Received has value: <r>nil</>
]=]

snapshots['.toBeDefined() .toBeUndefined() "a" is defined 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeDefined<d>()</>

Received: <r>"a"</>
]=]

snapshots[".toBeDefined() .toBeUndefined() [Function anonymous] is defined 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeDefined<d>()</>

Received: <r>[Function anonymous]</>
]=]

snapshots[".toBeDefined() .toBeUndefined() {} is defined 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeDefined<d>()</>

Received: <r>{}</>
]=]

snapshots[".toBeDefined() .toBeUndefined() 0.5 is defined 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeDefined<d>()</>

Received: <r>0.5</>
]=]

snapshots[".toBeDefined() .toBeUndefined() 1 is defined 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeDefined<d>()</>

Received: <r>1</>
]=]

snapshots[".toBeDefined() .toBeUndefined() inf is defined 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeDefined<d>()</>

Received: <r>inf</>
]=]

snapshots[".toBeDefined() .toBeUndefined() true is defined 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeDefined<d>()</>

Received: <r>true</>
]=]

snapshots['.toBeDefined() .toBeUndefined() "a" is defined 2'] = [=[

<d>expect(</><r>received</><d>).</>toBeUndefined<d>()</>

Received: <r>"a"</>
]=]

snapshots[".toBeDefined() .toBeUndefined() [Function anonymous] is defined 2"] = [=[

<d>expect(</><r>received</><d>).</>toBeUndefined<d>()</>

Received: <r>[Function anonymous]</>
]=]

snapshots[".toBeDefined() .toBeUndefined() {} is defined 2"] = [=[

<d>expect(</><r>received</><d>).</>toBeUndefined<d>()</>

Received: <r>{}</>
]=]

snapshots[".toBeDefined() .toBeUndefined() 0.5 is defined 2"] = [=[

<d>expect(</><r>received</><d>).</>toBeUndefined<d>()</>

Received: <r>0.5</>
]=]

snapshots[".toBeDefined() .toBeUndefined() 1 is defined 2"] = [=[

<d>expect(</><r>received</><d>).</>toBeUndefined<d>()</>

Received: <r>1</>
]=]

snapshots[".toBeDefined() .toBeUndefined() inf is defined 2"] = [=[

<d>expect(</><r>received</><d>).</>toBeUndefined<d>()</>

Received: <r>inf</>
]=]

snapshots[".toBeDefined() .toBeUndefined() true is defined 2"] = [=[

<d>expect(</><r>received</><d>).</>toBeUndefined<d>()</>

Received: <r>true</>
]=]

snapshots[".toBeDefined() .toBeUndefined() nil is undefined 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeDefined<d>()</>

Received: <r>nil</>
]=]

snapshots[".toBeDefined() .toBeUndefined() nil is undefined 2"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeUndefined<d>()</>

Received: <r>nil</>
]=]

-- ROBLOX deviation: we use {} instead of Map {}
snapshots[".toEqual() {pass: false} expect({}).toEqual(Set {}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: <g>Set {}</>
Received: <r>{}</>
]=]

snapshots[".toEqual() {pass: false} expect(Set {1, 2}).toEqual(Set {}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 4</>

<g>- Set {}</>
<r>+ Set {</>
<r>+   1,</>
<r>+   2,</>
<r>+ }</>
]=]

snapshots[".toEqual() {pass: false} expect(Set {1, 2}).toEqual(Set {1, 2, 3}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 0</>

<d>  Set {</>
<d>    1,</>
<d>    2,</>
<g>-   3,</>
<d>  }</>
]=]

snapshots[".toEqual() {pass: false} expect(Set {{1}, {2}}).toEqual(Set {{1}, {2}, {2}}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 3</>
<r>+ Received  + 0</>

<y>@@ -3,9 +3,6 @@</>
<d>      1,</>
<d>    },</>
<d>    Table {</>
<d>      2,</>
<d>    },</>
<g>-   Table {</>
<g>-     2,</>
<g>-   },</>
<d>  }</>
]=]

snapshots[".toEqual() {pass: false} expect(Set {{1}, {2}}).toEqual(Set {{1}, {2}, {3}}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 3</>
<r>+ Received  + 0</>

<y>@@ -3,9 +3,6 @@</>
<d>      1,</>
<d>    },</>
<d>    Table {</>
<d>      2,</>
<d>    },</>
<g>-   Table {</>
<g>-     3,</>
<g>-   },</>
<d>  }</>
]=]

snapshots[".toEqual() {pass: false} expect(Set {Set {1}, Set {2}}).toEqual(Set {Set {1}, Set {3}}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Set {</>
<d>    Set {</>
<d>      1,</>
<d>    },</>
<d>    Set {</>
<g>-     3,</>
<r>+     2,</>
<d>    },</>
<d>  }</>
]=]

snapshots[".toEqual() {pass: true} expect(Set {}).never.toEqual(Set {}) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>Set {}</>

]=]

snapshots[".toEqual() {pass: true} expect(Set {1, 2}).never.toEqual(Set {1, 2}) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>Set {1, 2}</>

]=]

snapshots[".toEqual() {pass: true} expect(Set {1, 2}).never.toEqual(Set {2, 1}) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>Set {2, 1}</>
Received:       <r>Set {1, 2}</>
]=]

snapshots[".toEqual() {pass: true} expect(Set {Set {{1}}, Set {{2}}}).never.toEqual(Set {Set {{2}}, Set {{1}}}) 1"] =
	[=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>Set {Set {{2}}, Set {{1}}}</>
Received:       <r>Set {Set {{1}}, Set {{2}}}</>
]=]

snapshots[".toEqual() {pass: true} expect(Set {{1}, {2}, {3}, {3}}).never.toEqual(Set {{3}, {3}, {2}, {1}}) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>Set {{3}, {3}, {2}, {1}}</>
Received:       <r>Set {{1}, {2}, {3}, {3}}</>
]=]

snapshots['.toEqual() {pass: true} expect(Set {{"a": 1}, {"b": 2}}).never.toEqual(Set {{"b": 2}, {"a": 1}}) 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected: never <g>Set {{"b": 2}, {"a": 1}}</>
Received:       <r>Set {{"a": 1}, {"b": 2}}</>
]=]

snapshots['.toContain(), .toContainEqual() \'Set {"abc", "def"}\' contains \'"abc"\' 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toContain<d>(</><g>expected</><d>) -- string.find or table.find</>

Expected value: never <g>"abc"</>
Received set:         <r>Set {"abc", "def"}</>
]=]

snapshots[".toContain(), .toContainEqual() 'Set {1, 2, 3, 4}' contains a value equal to '1' 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toContainEqual<d>(</><g>expected</><d>) -- deep equality</>

Expected value: never <g>1</>
Received set:         <r>Set {1, 2, 3, 4}</>
]=]

snapshots["toMatchObject() {pass: true} expect(Set {1, 2}).toMatchObject(Set {1, 2}) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>Set {1, 2}</>
]=]

snapshots["toMatchObject() {pass: true} expect(Set {1, 2}).toMatchObject(Set {2, 1}) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toMatchObject<d>(</><g>expected</><d>)</>

Expected: never <g>Set {2, 1}</>
Received:       <r>Set {1, 2}</>
]=]

snapshots["toMatchObject() {pass: false} expect(Set {1, 2}).toMatchObject(Set {2}) 1"] = [=[

<d>expect(</><r>received</><d>).</>toMatchObject<d>(</><g>expected</><d>)</>

<g>- Expected  - 0</>
<r>+ Received  + 1</>

<d>  Set {</>
<r>+   1,</>
<d>    2,</>
<d>  }</>
]=]

return snapshots
