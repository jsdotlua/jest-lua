-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/expect/src/__tests__/__snapshots__/matchers.test.js.snap

--[[
  deviation: We changed output from If it should pass with deep equality, replace "toBe" with "toEqual"
  to say toEqual instead of toStrictEqual since strict equality isn't currently any different from our
  definition of regular deep equality.
  deviation: Console output formatting is stripped from the snapshots.
]]
local snapshots = {}

snapshots['.toBe() does not crash on circular references 1'] = [=[
expect(received).toBe(expected) // Object.is equality

- Expected  - 1
+ Received  + 3

- Table {}
+ Table {
+   "circular": [Circular],
+ }]=]

snapshots['.toBe() fails for "a" with .never 1'] = [=[
expect(received).never.toBe(expected) // Object.is equality

Expected: never "a"]=]

snapshots['.toBe() fails for {} with .never 1'] = [=[
expect(received).never.toBe(expected) // Object.is equality

Expected: never {}]=]

snapshots['.toBe() fails for 1 with .never 1'] = [=[
expect(received).never.toBe(expected) // Object.is equality

Expected: never 1]=]

snapshots['.toBe() fails for false with .never 1'] = [=[
expect(received).never.toBe(expected) // Object.is equality

Expected: never false]=]

snapshots['.toBe() fails for nil with .never 1'] = [=[
expect(received).never.toBe(expected) // Object.is equality

Expected: never nil]=]

snapshots['.toBe() fails for: "" and "compare one-line string to empty string" 1'] = [=[
expect(received).toBe(expected) // Object.is equality

Expected: "compare one-line string to empty string"
Received: ""]=]

snapshots['.toBe() fails for: "abc" and "cde" 1'] = [=[
expect(received).toBe(expected) // Object.is equality

Expected: "cde"
Received: "abc"]=]

snapshots['.toBe() fails for: "four\n4\nline\nstring" and "3\nline\nstring" 1'] = [=[
expect(received).toBe(expected) // Object.is equality

- Expected  - 1
+ Received  + 2

- 3
+ four
+ 4
  line
  string]=]

snapshots['.toBe() fails for: "painless JavaScript testing" and "delightful JavaScript testing" 1'] = [=[
expect(received).toBe(expected) // Object.is equality

Expected: "delightful JavaScript testing"
Received: "painless JavaScript testing"]=]

snapshots['.toBe() fails for: "with \ntrailing space" and "without trailing space" 1'] = [=[
expect(received).toBe(expected) // Object.is equality

- Expected  - 1
+ Received  + 2

- without trailing space
+ with 
+ trailing space]=]

-- deviation: changed from regex to string
snapshots['.toBe() fails for: "received" and "expected" 1'] = [=[
expect(received).toBe(expected) // Object.is equality

Expected: "expected"
Received: "received"]=]

snapshots['.toBe() fails for: [Function anonymous] and [Function anonymous] 1'] = [=[
expect(received).toBe(expected) // Object.is equality

Expected: [Function anonymous]
Received: serializes to the same string]=]

--deviation: changed from a to anonymous
snapshots['.toBe() fails for: {"a": [Function anonymous], "b": 2} and {"a": Any<function>, "b": 2} 1'] = [=[
expect(received).toBe(expected) // Object.is equality

If it should pass with deep equality, replace "toBe" with "toEqual"

Expected: {"a": Any<function>, "b": 2}
Received: {"a": [Function anonymous], "b": 2}]=]

snapshots['.toBe() fails for: {"a": 1} and {"a": 1} 1'] = [=[
expect(received).toBe(expected) // Object.is equality

If it should pass with deep equality, replace "toBe" with "toEqual"

Expected: {"a": 1}
Received: serializes to the same string]=]

snapshots['.toBe() fails for: {"a": 1} and {"a": 5} 1'] = [=[
expect(received).toBe(expected) // Object.is equality

- Expected  - 1
+ Received  + 1

  Table {
-   "a": 5,
+   "a": 1,
  }]=]

-- deviation: changed from nil to false and therefore removed the line about
-- replacing toBe with toEqual
snapshots['.toBe() fails for: {"a": false, "b": 2} and {"b": 2} 1'] = [=[
expect(received).toBe(expected) // Object.is equality

- Expected  - 0
+ Received  + 1

  Table {
+   "a": false,
    "b": 2,
  }]=]

snapshots['.toBe() fails for: {} and {} 1'] = [=[
expect(received).toBe(expected) // Object.is equality

If it should pass with deep equality, replace "toBe" with "toEqual"

Expected: {}
Received: serializes to the same string]=]

-- deviation: changed from -0 and 0 to -inf and inf
snapshots['.toBe() fails for: -inf and inf 1'] = [=[
expect(received).toBe(expected) // Object.is equality

Expected: inf
Received: -inf]=]

snapshots['.toBe() fails for: 1 and 2 1'] = [=[
expect(received).toBe(expected) // Object.is equality

Expected: 2
Received: 1]=]

snapshots['.toBe() fails for: 2020-02-21T00:00:00.000Z and 2020-02-20T00:00:00.000Z 1'] = [=[
expect(received).toBe(expected) // Object.is equality

Expected: 2020-02-20T00:00:00.000Z
Received: 2020-02-21T00:00:00.000Z]=]

snapshots['.toBe() fails for: Symbol(received) and Symbol(expected) 1'] = [=[
expect(received).toBe(expected) // Object.is equality

Expected: Symbol(expected)
Received: Symbol(received)]=]

snapshots['.toBe() fails for: true and false 1'] = [=[
expect(received).toBe(expected) // Object.is equality

Expected: false
Received: true]=]

snapshots['.toBeCloseTo {pass: false} expect(-inf).toBeCloseTo(-1.23) 1'] = [=[
expect(received).toBeCloseTo(expected)

Expected: -1.23
Received: -inf

Expected precision:    2
Expected difference: < 0.005
Received difference:   inf]=]

snapshots['.toBeCloseTo {pass: false} expect(0).toBeCloseTo(0.01) 1'] = [=[
expect(received).toBeCloseTo(expected)

Expected: 0.01
Received: 0

Expected precision:    2
Expected difference: < 0.005
Received difference:   0.01]=]

snapshots['.toBeCloseTo {pass: false} expect(1).toBeCloseTo(1.23) 1'] = [=[
expect(received).toBeCloseTo(expected)

Expected: 1.23
Received: 1

Expected precision:    2
Expected difference: < 0.005
Received difference:   0.23]=]

snapshots['.toBeCloseTo {pass: false} expect(1.23).toBeCloseTo(1.2249999) 1'] = [=[
expect(received).toBeCloseTo(expected)

Expected: 1.2249999
Received: 1.23

Expected precision:    2
Expected difference: < 0.005
Received difference:   0.0050001]=]

snapshots['.toBeCloseTo {pass: false} expect(inf).toBeCloseTo(-inf) 1'] = [=[
expect(received).toBeCloseTo(expected)

Expected: -inf
Received: inf

Expected precision:    2
Expected difference: < 0.005
Received difference:   inf]=]

snapshots['.toBeCloseTo {pass: false} expect(inf).toBeCloseTo(1.23) 1'] = [=[
expect(received).toBeCloseTo(expected)

Expected: 1.23
Received: inf

Expected precision:    2
Expected difference: < 0.005
Received difference:   inf]=]

snapshots['.toBeCloseTo {pass: true} expect(-inf).toBeCloseTo(-inf) 1'] = [=[
expect(received).never.toBeCloseTo(expected)

Expected: never -inf
]=]

snapshots['.toBeCloseTo {pass: true} expect(0).toBeCloseTo(0) 1'] = [=[
expect(received).never.toBeCloseTo(expected)

Expected: never 0
]=]

-- deviation: upstream's printing of the expected value is 0.000004 but Lua
-- prints such a value in exponential format by default so we follow the convention
snapshots['.toBeCloseTo {pass: true} expect(0).toBeCloseTo(4e-06, 5) 1'] = [=[
expect(received).never.toBeCloseTo(expected, precision)

Expected: never 4e-06
Received:       0

Expected precision:          5
Expected difference: never < 5e-6
Received difference:         4e-6]=]

snapshots['.toBeCloseTo {pass: true} expect(0).toBeCloseTo(0.0001, 3) 1'] = [=[
expect(received).never.toBeCloseTo(expected, precision)

Expected: never 0.0001
Received:       0

Expected precision:          3
Expected difference: never < 0.0005
Received difference:         0.0001]=]

snapshots['.toBeCloseTo {pass: true} expect(0).toBeCloseTo(0.001) 1'] = [=[
expect(received).never.toBeCloseTo(expected)

Expected: never 0.001
Received:       0

Expected precision:          2
Expected difference: never < 0.005
Received difference:         0.001]=]

snapshots['.toBeCloseTo {pass: true} expect(0).toBeCloseTo(0.1, 0) 1'] = [=[
expect(received).never.toBeCloseTo(expected, precision)

Expected: never 0.1
Received:       0

Expected precision:          0
Expected difference: never < 0.5
Received difference:         0.1]=]

snapshots['.toBeCloseTo {pass: true} expect(1.23).toBeCloseTo(1.225) 1'] = [=[
expect(received).never.toBeCloseTo(expected)

Expected: never 1.225
Received:       1.23

Expected precision:          2
Expected difference: never < 0.005
Received difference:         0.0049999999999999]=]

snapshots['.toBeCloseTo {pass: true} expect(1.23).toBeCloseTo(1.226) 1'] = [=[
expect(received).never.toBeCloseTo(expected)

Expected: never 1.226
Received:       1.23

Expected precision:          2
Expected difference: never < 0.005
Received difference:         0.004]=]

snapshots['.toBeCloseTo {pass: true} expect(1.23).toBeCloseTo(1.229) 1'] = [=[
expect(received).never.toBeCloseTo(expected)

Expected: never 1.229
Received:       1.23

Expected precision:          2
Expected difference: never < 0.005
Received difference:         0.00099999999999989]=]

snapshots['.toBeCloseTo {pass: true} expect(1.23).toBeCloseTo(1.234) 1'] = [=[
expect(received).never.toBeCloseTo(expected)

Expected: never 1.234
Received:       1.23

Expected precision:          2
Expected difference: never < 0.005
Received difference:         0.004]=]

snapshots['.toBeCloseTo {pass: true} expect(2.0000002).toBeCloseTo(2, 5) 1'] = [=[
expect(received).never.toBeCloseTo(expected, precision)

Expected: never 2
Received:       2.0000002

Expected precision:          5
Expected difference: never < 5e-6
Received difference:         2.0000000011677e-7]=]

snapshots['.toBeCloseTo {pass: true} expect(inf).toBeCloseTo(inf) 1'] = [=[
expect(received).never.toBeCloseTo(expected)

Expected: never inf
]=]

snapshots['.toBeCloseTo throws: Matcher error promise empty isNot false received 1'] = [=[
expect(received).toBeCloseTo(expected, precision)

Matcher error: received value must be a number

Received has type:  string
Received has value: ""]=]

snapshots['.toBeCloseTo throws: Matcher error promise empty isNot true expected 1'] = [=[
expect(received).never.toBeCloseTo(expected)

Matcher error: expected value must be a number

Expected has value: nil]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [-inf, -inf] 1'] = [=[
expect(received).never.toBeGreaterThanOrEqual(expected)

Expected: never >= -inf
Received:          -inf]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [-inf, -inf] 2'] = [=[
expect(received).never.toBeLessThanOrEqual(expected)

Expected: never <= -inf
Received:          -inf]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [1, 1] 1'] = [=[
expect(received).never.toBeGreaterThanOrEqual(expected)

Expected: never >= 1
Received:          1]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [1, 1] 2'] = [=[
expect(received).never.toBeLessThanOrEqual(expected)

Expected: never <= 1
Received:          1]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [9.007199254741e+15, 9.007199254741e+15] 1'] = [=[
expect(received).never.toBeGreaterThanOrEqual(expected)

Expected: never >= 9.007199254741e+15
Received:          9.007199254741e+15]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [9.007199254741e+15, 9.007199254741e+15] 2'] = [=[
expect(received).never.toBeLessThanOrEqual(expected)

Expected: never <= 9.007199254741e+15
Received:          9.007199254741e+15]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [-9.007199254741e+15, -9.007199254741e+15] 1'] = [=[
expect(received).never.toBeGreaterThanOrEqual(expected)

Expected: never >= -9.007199254741e+15
Received:          -9.007199254741e+15]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [-9.007199254741e+15, -9.007199254741e+15] 2'] = [=[
expect(received).never.toBeLessThanOrEqual(expected)

Expected: never <= -9.007199254741e+15
Received:          -9.007199254741e+15]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [inf, inf] 1'] = [=[
expect(received).never.toBeGreaterThanOrEqual(expected)

Expected: never >= inf
Received:          inf]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() equal numbers: [inf, inf] 2'] = [=[
expect(received).never.toBeLessThanOrEqual(expected)

Expected: never <= inf
Received:          inf]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 1'] = [=[
expect(received).toBeGreaterThan(expected)

Expected: > inf
Received:   -inf]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 2'] = [=[
expect(received).never.toBeLessThan(expected)

Expected: never < inf
Received:         -inf]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 3'] = [=[
expect(received).never.toBeGreaterThan(expected)

Expected: never > -inf
Received:         inf]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 4'] = [=[
expect(received).toBeLessThan(expected)

Expected: < -inf
Received:   inf]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 5'] = [=[
expect(received).toBeGreaterThanOrEqual(expected)

Expected: >= inf
Received:    -inf]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 6'] = [=[
expect(received).never.toBeLessThanOrEqual(expected)

Expected: never <= inf
Received:          -inf]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 7'] = [=[
expect(received).never.toBeGreaterThanOrEqual(expected)

Expected: never >= -inf
Received:          inf]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-inf, inf] 8'] = [=[
expect(received).toBeLessThanOrEqual(expected)

Expected: <= -inf
Received:    inf]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 1'] = [=[
expect(received).toBeGreaterThan(expected)

Expected: > 0.2
Received:   0.1]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 2'] = [=[
expect(received).never.toBeLessThan(expected)

Expected: never < 0.2
Received:         0.1]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 3'] = [=[
expect(received).never.toBeGreaterThan(expected)

Expected: never > 0.1
Received:         0.2]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 4'] = [=[
expect(received).toBeLessThan(expected)

Expected: < 0.1
Received:   0.2]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 5'] = [=[
expect(received).toBeGreaterThanOrEqual(expected)

Expected: >= 0.2
Received:    0.1]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 6'] = [=[
expect(received).never.toBeLessThanOrEqual(expected)

Expected: never <= 0.2
Received:          0.1]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 7'] = [=[
expect(received).never.toBeGreaterThanOrEqual(expected)

Expected: never >= 0.1
Received:          0.2]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [0.1, 0.2] 8'] = [=[
expect(received).toBeLessThanOrEqual(expected)

Expected: <= 0.1
Received:    0.2]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 1'] = [=[
expect(received).toBeGreaterThan(expected)

Expected: > 2
Received:   1]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 2'] = [=[
expect(received).never.toBeLessThan(expected)

Expected: never < 2
Received:         1]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 3'] = [=[
expect(received).never.toBeGreaterThan(expected)

Expected: never > 1
Received:         2]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 4'] = [=[
expect(received).toBeLessThan(expected)

Expected: < 1
Received:   2]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 5'] = [=[
expect(received).toBeGreaterThanOrEqual(expected)

Expected: >= 2
Received:    1]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 6'] = [=[
expect(received).never.toBeLessThanOrEqual(expected)

Expected: never <= 2
Received:          1]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 7'] = [=[
expect(received).never.toBeGreaterThanOrEqual(expected)

Expected: never >= 1
Received:          2]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [1, 2] 8'] = [=[
expect(received).toBeLessThanOrEqual(expected)

Expected: <= 1
Received:    2]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 1'] = [=[
expect(received).toBeGreaterThan(expected)

Expected: > 7
Received:   3]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 2'] = [=[
expect(received).never.toBeLessThan(expected)

Expected: never < 7
Received:         3]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 3'] = [=[
expect(received).never.toBeGreaterThan(expected)

Expected: never > 3
Received:         7]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 4'] = [=[
expect(received).toBeLessThan(expected)

Expected: < 3
Received:   7]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 5'] = [=[
expect(received).toBeGreaterThanOrEqual(expected)

Expected: >= 7
Received:    3]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 6'] = [=[
expect(received).never.toBeLessThanOrEqual(expected)

Expected: never <= 7
Received:          3]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 7'] = [=[
expect(received).never.toBeGreaterThanOrEqual(expected)

Expected: never >= 3
Received:          7]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [3, 7] 8'] = [=[
expect(received).toBeLessThanOrEqual(expected)

Expected: <= 3
Received:    7]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9.007199254741e+15, 9.007199254741e+15] 1'] = [=[
expect(received).toBeGreaterThan(expected)

Expected: > 9.007199254741e+15
Received:   -9.007199254741e+15]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9.007199254741e+15, 9.007199254741e+15] 2'] = [=[
expect(received).never.toBeLessThan(expected)

Expected: never < 9.007199254741e+15
Received:         -9.007199254741e+15]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9.007199254741e+15, 9.007199254741e+15] 3'] = [=[
expect(received).never.toBeGreaterThan(expected)

Expected: never > -9.007199254741e+15
Received:         9.007199254741e+15]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9.007199254741e+15, 9.007199254741e+15] 4'] = [=[
expect(received).toBeLessThan(expected)

Expected: < -9.007199254741e+15
Received:   9.007199254741e+15]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9.007199254741e+15, 9.007199254741e+15] 5'] = [=[
expect(received).toBeGreaterThanOrEqual(expected)

Expected: >= 9.007199254741e+15
Received:    -9.007199254741e+15]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9.007199254741e+15, 9.007199254741e+15] 6'] = [=[
expect(received).never.toBeLessThanOrEqual(expected)

Expected: never <= 9.007199254741e+15
Received:          -9.007199254741e+15]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9.007199254741e+15, 9.007199254741e+15] 7'] = [=[
expect(received).never.toBeGreaterThanOrEqual(expected)

Expected: never >= -9.007199254741e+15
Received:          9.007199254741e+15]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [-9.007199254741e+15, 9.007199254741e+15] 8'] = [=[
expect(received).toBeLessThanOrEqual(expected)

Expected: <= -9.007199254741e+15
Received:    9.007199254741e+15]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 1'] = [=[
expect(received).toBeGreaterThan(expected)

Expected: > 18
Received:   9]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 2'] = [=[
expect(received).never.toBeLessThan(expected)

Expected: never < 18
Received:         9]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 3'] = [=[
expect(received).never.toBeGreaterThan(expected)

Expected: never > 9
Received:         18]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 4'] = [=[
expect(received).toBeLessThan(expected)

Expected: < 9
Received:   18]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 5'] = [=[
expect(received).toBeGreaterThanOrEqual(expected)

Expected: >= 18
Received:    9]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 6'] = [=[
expect(received).never.toBeLessThanOrEqual(expected)

Expected: never <= 18
Received:          9]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 7'] = [=[
expect(received).never.toBeGreaterThanOrEqual(expected)

Expected: never >= 9
Received:          18]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [9, 18] 8'] = [=[
expect(received).toBeLessThanOrEqual(expected)

Expected: <= 9
Received:    18]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 1'] = [=[
expect(received).toBeGreaterThan(expected)

Expected: > 34
Received:   17]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 2'] = [=[
expect(received).never.toBeLessThan(expected)

Expected: never < 34
Received:         17]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 3'] = [=[
expect(received).never.toBeGreaterThan(expected)

Expected: never > 17
Received:         34]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 4'] = [=[
expect(received).toBeLessThan(expected)

Expected: < 17
Received:   34]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 5'] = [=[
expect(received).toBeGreaterThanOrEqual(expected)

Expected: >= 34
Received:    17]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 6'] = [=[
expect(received).never.toBeLessThanOrEqual(expected)

Expected: never <= 34
Received:          17]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 7'] = [=[
expect(received).never.toBeGreaterThanOrEqual(expected)

Expected: never >= 17
Received:          34]=]

snapshots['.toBeGreaterThan(), .toBeLessThan(), .toBeGreaterThanOrEqual(), .toBeLessThanOrEqual() throws: [17, 34] 8'] = [=[
expect(received).toBeLessThanOrEqual(expected)

Expected: <= 17
Received:    34]=]

snapshots['.toBeNan() {pass: true} expect(nan).toBeNan() 1'] = [=[
expect(received).never.toBeNan()

Received: nan]=]

snapshots['.toBeNan() {pass: true} expect(nan).toBeNan() 2'] = [=[
expect(received).never.toBeNan()

Received: nan]=]

snapshots['.toBeNan() {pass: true} expect(nan).toBeNan() 3'] = [=[
expect(received).never.toBeNan()

Received: nan]=]

snapshots['.toBeNan() throws 1'] = [=[
expect(received).toBeNan()

Received: 1]=]

snapshots['.toBeNan() throws 2'] = [=[
expect(received).toBeNan()

Received: ""]=]

snapshots['.toBeNan() throws 3'] = [=[
expect(received).toBeNan()

Received: {}]=]

snapshots['.toBeNan() throws 4'] = [=[
expect(received).toBeNan()

Received: 0.2]=]

snapshots['.toBeNan() throws 5'] = [=[
expect(received).toBeNan()

Received: 0]=]

snapshots['.toBeNan() throws 6'] = [=[
expect(received).toBeNan()

Received: inf]=]

snapshots['.toBeNan() throws 7'] = [=[
expect(received).toBeNan()

Received: -inf]=]

snapshots['.toBeNil() fails for "a" 1'] = [=[
expect(received).toBeNil()

Received: "a"]=]

snapshots['.toBeNil() fails for [Function anonymous] 1'] = [=[
expect(received).toBeNil()

Received: [Function anonymous]]=]

snapshots['.toBeNil() fails for {} 1'] = [=[
expect(received).toBeNil()

Received: {}]=]

snapshots['.toBeNil() fails for 0.5 1'] = [=[
expect(received).toBeNil()

Received: 0.5]=]

snapshots['.toBeNil() fails for 1 1'] = [=[
expect(received).toBeNil()

Received: 1]=]

snapshots['.toBeNil() fails for inf 1'] = [=[
expect(received).toBeNil()

Received: inf]=]

snapshots['.toBeNil() fails for true 1'] = [=[
expect(received).toBeNil()

Received: true]=]

snapshots['.toBeNil() fails for nil with .never 1'] = [=[
expect(received).never.toBeNil()

Received: nil]=]

snapshots['.toBeTruthy(), .toBeFalsy() "" is truthy 1'] = [=[
expect(received).never.toBeTruthy()

Received: ""]=]

snapshots['.toBeTruthy(), .toBeFalsy() "" is truthy 2'] = [=[
expect(received).toBeFalsy()

Received: ""]=]

snapshots['.toBeTruthy(), .toBeFalsy() "a" is truthy 1'] = [=[
expect(received).never.toBeTruthy()

Received: "a"]=]

snapshots['.toBeTruthy(), .toBeFalsy() "a" is truthy 2'] = [=[
expect(received).toBeFalsy()

Received: "a"]=]

snapshots['.toBeTruthy(), .toBeFalsy() [Function anonymous] is truthy 1'] = [=[
expect(received).never.toBeTruthy()

Received: [Function anonymous]]=]

snapshots['.toBeTruthy(), .toBeFalsy() [Function anonymous] is truthy 2'] = [=[
expect(received).toBeFalsy()

Received: [Function anonymous]]=]

snapshots['.toBeTruthy(), .toBeFalsy() {} is truthy 1'] = [=[
expect(received).never.toBeTruthy()

Received: {}]=]

snapshots['.toBeTruthy(), .toBeFalsy() {} is truthy 2'] = [=[
expect(received).toBeFalsy()

Received: {}]=]

snapshots['.toBeTruthy(), .toBeFalsy() 0 is truthy 1'] = [=[
expect(received).never.toBeTruthy()

Received: 0]=]

snapshots['.toBeTruthy(), .toBeFalsy() 0 is truthy 2'] = [=[
expect(received).toBeFalsy()

Received: 0]=]

snapshots['.toBeTruthy(), .toBeFalsy() 0.5 is truthy 1'] = [=[
expect(received).never.toBeTruthy()

Received: 0.5]=]

snapshots['.toBeTruthy(), .toBeFalsy() 0.5 is truthy 2'] = [=[
expect(received).toBeFalsy()

Received: 0.5]=]

snapshots['.toBeTruthy(), .toBeFalsy() 1 is truthy 1'] = [=[
expect(received).never.toBeTruthy()

Received: 1]=]

snapshots['.toBeTruthy(), .toBeFalsy() 1 is truthy 2'] = [=[
expect(received).toBeFalsy()

Received: 1]=]

snapshots['.toBeTruthy(), .toBeFalsy() inf is truthy 1'] = [=[
expect(received).never.toBeTruthy()

Received: inf]=]

snapshots['.toBeTruthy(), .toBeFalsy() inf is truthy 2'] = [=[
expect(received).toBeFalsy()

Received: inf]=]

snapshots['.toBeTruthy(), .toBeFalsy() nan is truthy 1'] = [=[
expect(received).never.toBeTruthy()

Received: nan]=]

snapshots['.toBeTruthy(), .toBeFalsy() nan is truthy 2'] = [=[
expect(received).toBeFalsy()

Received: nan]=]

snapshots['.toBeTruthy(), .toBeFalsy() false is falsy 1'] = [=[
expect(received).toBeTruthy()

Received: false]=]

snapshots['.toBeTruthy(), .toBeFalsy() false is falsy 2'] = [=[
expect(received).never.toBeFalsy()

Received: false]=]

snapshots['.toBeTruthy(), .toBeFalsy() true is truthy 1'] = [=[
expect(received).never.toBeTruthy()

Received: true]=]

snapshots['.toBeTruthy(), .toBeFalsy() true is truthy 2'] = [=[
expect(received).toBeFalsy()

Received: true]=]

snapshots['.toBeTruthy(), .toBeFalsy() nil is falsy 1'] = [=[
expect(received).toBeTruthy()

Received: nil]=]

snapshots['.toBeTruthy(), .toBeFalsy() nil is falsy 2'] = [=[
expect(received).never.toBeFalsy()

Received: nil]=]

snapshots['.toBeTruthy(), .toBeFalsy() does not accept arguments 1'] = [=[
expect(received).toBeTruthy()

Matcher error: this matcher must not have an expected argument

Expected has type:  number
Expected has value: 1]=]

snapshots['.toBeTruthy(), .toBeFalsy() does not accept arguments 2'] = [=[
expect(received).never.toBeFalsy()

Matcher error: this matcher must not have an expected argument

Expected has type:  number
Expected has value: 1]=]

snapshots['.toContain(), .toContainEqual() "11112111" contains "2" 1'] = [=[
expect(received).never.toContain(expected) // indexOf

Expected substring: never "2"
Received string:          "11112111"]=]

snapshots['.toContain(), .toContainEqual() "abcdef" contains "abc" 1'] = [=[
expect(received).never.toContain(expected) // indexOf

Expected substring: never "abc"
Received string:          "abcdef"]=]

snapshots['.toContain(), .toContainEqual() {"a", "b", "c", "d"} contains "a" 1'] = [=[
expect(received).never.toContain(expected) // indexOf

Expected value: never "a"
Received table:       {"a", "b", "c", "d"}]=]

snapshots['.toContain(), .toContainEqual() {"a", "b", "c", "d"} contains a value equal to "a" 1'] = [=[
expect(received).never.toContainEqual(expected) // deep equality

Expected value: never "a"
Received table:       {"a", "b", "c", "d"}]=]

snapshots['.toContain(), .toContainEqual() {{"a": "b"}, {"a": "c"}} contains a value equal to {"a": "b"} 1'] = [=[
expect(received).never.toContainEqual(expected) // deep equality

Expected value: never {"a": "b"}
Received table:       {{"a": "b"}, {"a": "c"}}]=]

snapshots['.toContain(), .toContainEqual() {{"a": "b"}, {"a": "c"}} does not contain a value equal to {"a": "d"} 1'] = [=[
expect(received).toContainEqual(expected) // deep equality

Expected value: {"a": "d"}
Received table: {{"a": "b"}, {"a": "c"}}]=]

snapshots['.toContain(), .toContainEqual() {{}, {}} does not contain {} 1'] = [=[
expect(received).toContain(expected) // indexOf

Expected value: {}
Received table: {{}, {}}

Looks like you wanted to test for object/array equality with the stricter `toContain` matcher. You probably need to use `toContainEqual` instead.]=]

snapshots['.toContain(), .toContainEqual() {0, 1} contains 1 1'] = [=[
expect(received).never.toContain(expected) // indexOf

Expected value: never 1
Received table:       {0, 1}]=]

snapshots['.toContain(), .toContainEqual() {0, 1} contains a value equal to 1 1'] = [=[
expect(received).never.toContainEqual(expected) // deep equality

Expected value: never 1
Received table:       {0, 1}]=]

snapshots['.toContain(), .toContainEqual() {1, 2, 3, 4} contains 1 1'] = [=[
expect(received).never.toContain(expected) // indexOf

Expected value: never 1
Received table:       {1, 2, 3, 4}]=]

snapshots['.toContain(), .toContainEqual() {1, 2, 3, 4} contains a value equal to 1 1'] = [=[
expect(received).never.toContainEqual(expected) // deep equality

Expected value: never 1
Received table:       {1, 2, 3, 4}]=]

snapshots['.toContain(), .toContainEqual() {{1, 2}, {3, 4}} contains a value equal to {3, 4} 1'] = [=[
expect(received).never.toContainEqual(expected) // deep equality

Expected value: never {3, 4}
Received table:       {{1, 2}, {3, 4}}]=]

snapshots['.toContain(), .toContainEqual() {1, 2, 3} does not contain 4 1'] = [=[
expect(received).toContain(expected) // indexOf

Expected value: 4
Received table: {1, 2, 3}]=]

snapshots['.toContain(), .toContainEqual() {Symbol(a)} contains Symbol(a) 1'] = [=[
expect(received).never.toContain(expected) // indexOf

Expected value: never Symbol(a)
Received table:       {Symbol(a)}]=]

snapshots['.toContain(), .toContainEqual() {Symbol(a)} contains a value equal to Symbol(a) 1'] = [=[
expect(received).never.toContainEqual(expected) // deep equality

Expected value: never Symbol(a)
Received table:       {Symbol(a)}]=]

snapshots['.toContain(), .toContainEqual() error cases 1'] = [=[
expect(received).toContain(expected) // indexOf

Matcher error: received value must not be nil

Received has value: nil]=]

snapshots['.toContain(), .toContainEqual() error cases for toContainEqual 1'] = [=[
expect(received).toContainEqual(expected) // deep equality

Matcher error: received value must not be nil

Received has value: nil]=]

snapshots['.toEqual() {pass: false} expect("1 234,57 $").toEqual("1 234,57 $") 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: "1 234,57 $"
Received: "1 234,57 $"]=]

snapshots['.toEqual() {pass: false} expect("Eve").toEqual({"asymmetricMatch": [Function anonymous]}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: {"asymmetricMatch": [Function anonymous]}
Received: "Eve"]=]

snapshots['.toEqual() {pass: false} expect("abd").toEqual(StringContaining "bc") 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: StringContaining "bc"
Received: "abd"]=]

snapshots['.toEqual() {pass: false} expect("abd").toEqual(StringMatching "bc") 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: StringMatching "bc"
Received: "abd"]=]

snapshots['.toEqual() {pass: false} expect("banana").toEqual("apple") 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: "apple"
Received: "banana"]=]

snapshots['.toEqual() {pass: false} expect("type TypeName<T> = T extends Function ? \\"function\\" : \\"object\\";").toEqual("type TypeName<T> = T extends Function\n? \\"function\\"\n: \\"object\\";") 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 3
+ Received  + 1

- type TypeName<T> = T extends Function
- ? "function"
- : "object";
+ type TypeName<T> = T extends Function ? "function" : "object";]=]

snapshots['.toEqual() {pass: false} expect({1, 3}).toEqual(ArrayContaining [1, 2]) 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: ArrayContaining [1, 2]
Received: {1, 3}]=]

snapshots['.toEqual() {pass: false} expect({1}).toEqual({2}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
-   2,
+   1,
  }]=]

snapshots['.toEqual() {pass: false} expect({97, 98, 99}).toEqual({97, 98, 100}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
    97,
    98,
-   100,
+   99,
  }]=]

snapshots['.toEqual() {pass: false} expect({"a": 1, "b": 2}).toEqual(ObjectContaining {"a": 2}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: ObjectContaining {"a": 2}
Received: {"a": 1, "b": 2}]=]

snapshots['.toEqual() {pass: false} expect({"a": 1}).toEqual({"a": 2}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
-   "a": 2,
+   "a": 1,
  }]=]

snapshots['.toEqual() {pass: false} expect({"a": 5}).toEqual({"b": 6}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
-   "b": 6,
+   "a": 5,
  }]=]

snapshots['.toEqual() {pass: false} expect({"foo": {"bar": 1}}).toEqual({"foo": {}}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 3

  Table {
-   "foo": Table {},
+   "foo": Table {
+     "bar": 1,
+   },
  }]=]

snapshots['.toEqual() {pass: false} expect({"nodeName": "div", "nodeType": 1}).toEqual({"nodeName": "p", "nodeType": 1}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
-   "nodeName": "p",
+   "nodeName": "div",
    "nodeType": 1,
  }]=]

snapshots['.toEqual() {pass: false} expect({"target": {"nodeType": 1, "value": "a"}}).toEqual({"target": {"nodeType": 1, "value": "b"}}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
    "target": Table {
      "nodeType": 1,
-     "value": "b",
+     "value": "a",
    },
  }]=]

snapshots['.toEqual() {pass: false} expect({Symbol(bar): 2, Symbol(foo): 1}).toEqual({Symbol(bar): 1, Symbol(foo): Any<number>}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
-   Symbol(bar): 1,
+   Symbol(bar): 2,
    Symbol(foo): Any<number>,
  }]=]

snapshots['.toEqual() {pass: false} expect(0).toEqual(1) 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: 1
Received: 0]=]

snapshots['.toEqual() {pass: false} expect(0).toEqual(-9.007199254741e+15) 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: -9.007199254741e+15
Received: 0]=]

snapshots['.toEqual() {pass: false} expect(1).toEqual(2) 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: 2
Received: 1]=]

snapshots['.toEqual() {pass: false} expect(1).toEqual(ArrayContaining [1, 2]) 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: ArrayContaining [1, 2]
Received: 1]=]

snapshots['.toEqual() {pass: false} expect(-9.007199254741e+15).toEqual(0) 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: 0
Received: -9.007199254741e+15]=]

snapshots['.toEqual() {pass: false} expect({"1": {"2": {"a": 99}}}).toEqual({"1": {"2": {"a": 11}}}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
    "1": Table {
      "2": Table {
-       "a": 11,
+       "a": 99,
      },
    },
  }]=]

snapshots['.toEqual() {pass: false} expect({"a": 0}).toEqual({"b": 0}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
-   "b": 0,
+   "a": 0,
  }]=]

snapshots['.toEqual() {pass: false} expect({1, 2}).toEqual({2, 1}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
-   2,
    1,
+   2,
  }]=]

snapshots['.toEqual() {pass: false} expect({1, 2}).toEqual({}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 4

- Table {}
+ Table {
+   1,
+   2,
+ }]=]

snapshots['.toEqual() {pass: false} expect({"v": 1}).toEqual({"v": 2}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
-   "v": 2,
+   "v": 1,
  }]=]

snapshots['.toEqual() {pass: false} expect({{"v"}: 1}).toEqual({{"v"}: 2}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
    Table {
      "v",
-   }: 2,
+   }: 1,
  }]=]

snapshots['.toEqual() {pass: false} expect({{1}: {{1}: "one"}}).toEqual({{1}: {{1}: "two"}}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

@@ -2,8 +2,8 @@
    Table {
      1,
    }: Table {
      Table {
        1,
-     }: "two",
+     }: "one",
    },
  }]=]

snapshots['.toEqual() {pass: false} expect({"one", "two"}).toEqual({"one"}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 0
+ Received  + 1

  Table {
    "one",
+   "two",
  }]=]

snapshots['.toEqual() {pass: false} expect({{1}, {2}}).toEqual({{1}, {2}, {2}}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 3
+ Received  + 0

@@ -3,9 +3,6 @@
      1,
    },
    Table {
      2,
    },
-   Table {
-     2,
-   },
  }]=]

snapshots['.toEqual() {pass: false} expect({{1}, {2}}).toEqual({{1}, {2}, {3}}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 3
+ Received  + 0

@@ -3,9 +3,6 @@
      1,
    },
    Table {
      2,
    },
-   Table {
-     3,
-   },
  }]=]

snapshots['.toEqual() {pass: false} expect({1, 2}).toEqual({1, 2, 3}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 0

  Table {
    1,
    2,
-   3,
  }]=]

snapshots['.toEqual() {pass: false} expect({{1}, {2}}).toEqual({{1}, {3}}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
    Table {
      1,
    },
    Table {
-     3,
+     2,
    },
  }]=]

snapshots['.toEqual() {pass: false} expect(false).toEqual(ObjectContaining {"a": 2}) 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: ObjectContaining {"a": 2}
Received: false]=]

snapshots['.toEqual() {pass: false} expect(true).toEqual(false) 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: false
Received: true]=]

snapshots['.toEqual() {pass: false} expect(nil).toEqual(Any<function>) 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: Any<function>
Received: nil]=]

snapshots['.toEqual() {pass: false} expect(nil).toEqual(Anything) 1'] = [=[
expect(received).toEqual(expected) // deep equality

Expected: Anything
Received: nil]=]

snapshots['.toEqual() {pass: true} expect("Alice").never.toEqual({"asymmetricMatch": [Function anonymous]}) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never {"asymmetricMatch": [Function anonymous]}
Received:       "Alice"]=]

snapshots['.toEqual() {pass: true} expect("abc").never.toEqual("abc") 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never "abc"
]=]

snapshots['.toEqual() {pass: true} expect("abcd").never.toEqual(StringContaining "bc") 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never StringContaining "bc"
Received:       "abcd"]=]

snapshots['.toEqual() {pass: true} expect("abcd").never.toEqual(StringMatching "bc") 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never StringMatching "bc"
Received:       "abcd"]=]

snapshots['.toEqual() {pass: true} expect({1, 2, 3}).never.toEqual(ArrayContaining [2, 3]) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never ArrayContaining [2, 3]
Received:       {1, 2, 3}]=]

snapshots['.toEqual() {pass: true} expect({1}).never.toEqual({1}) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never {1}
]=]

snapshots['.toEqual() {pass: true} expect({97, 98, 99}).never.toEqual({97, 98, 99}) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never {97, 98, 99}
]=]

snapshots['.toEqual() {pass: true} expect([Function anonymous]).never.toEqual(Any<function>) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never Any<function>
Received:       [Function anonymous]]=]

snapshots['.toEqual() {pass: true} expect({"a": 1, "b": [Function anonymous], "c": true}).never.toEqual({"a": 1, "b": Any<function>, "c": Anything}) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never {"a": 1, "b": Any<function>, "c": Anything}
Received:       {"a": 1, "b": [Function anonymous], "c": true}]=]

snapshots['.toEqual() {pass: true} expect({"a": 1, "b": 2}).never.toEqual(ObjectContaining {"a": 1}) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never ObjectContaining {"a": 1}
Received:       {"a": 1, "b": 2}]=]

snapshots['.toEqual() {pass: true} expect({"a": 99}).never.toEqual({"a": 99}) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never {"a": 99}
]=]

snapshots['.toEqual() {pass: true} expect({"nodeName": "div", "nodeType": 1}).never.toEqual({"nodeName": "div", "nodeType": 1}) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never {"nodeName": "div", "nodeType": 1}
]=]

snapshots['.toEqual() {pass: true} expect({}).never.toEqual({}) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never {}
]=]

snapshots['.toEqual() {pass: true} expect(0).never.toEqual(0) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never 0
]=]

snapshots['.toEqual() {pass: true} expect(1).never.toEqual(1) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never 1
]=]

snapshots['.toEqual() {pass: true} expect({{2: {"a": 99}}}).never.toEqual({{2: {"a": 99}}}) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never {{2: {"a": 99}}}
]=]

snapshots['.toEqual() {pass: true} expect({"one", "two"}).never.toEqual({"one", "two"}) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never {"one", "two"}
]=]

snapshots['.toEqual() {pass: true} expect({1, 2}).never.toEqual({1, 2}) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never {1, 2}
]=]

snapshots['.toEqual() {pass: true} expect({{"one"}, {"two"}}).never.toEqual({{"one"}, {"two"}}) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never {{"one"}, {"two"}}
]=]
snapshots['.toEqual() {pass: true} expect(nan).never.toEqual(nan) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never nan
]=]

snapshots['.toEqual() {pass: true} expect(true).never.toEqual(Anything) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never Anything
Received:       true]=]

snapshots['.toEqual() {pass: true} expect(true).never.toEqual(true) 1'] = [=[
expect(received).never.toEqual(expected) // deep equality

Expected: never true
]=]

snapshots['.toHaveLength {pass: false} expect("").toHaveLength(1) 1'] = [=[
expect(received).toHaveLength(expected)

Expected length: 1
Received length: 0
Received string: ""]=]

snapshots['.toHaveLength {pass: false} expect("abc").toHaveLength(66) 1'] = [=[
expect(received).toHaveLength(expected)

Expected length: 66
Received length: 3
Received string: "abc"]=]

snapshots['.toHaveLength {pass: false} expect({"a", "b"}).toHaveLength(99) 1'] = [=[
expect(received).toHaveLength(expected)

Expected length: 99
Received length: 2
Received table:  {"a", "b"}]=]

snapshots['.toHaveLength {pass: false} expect({}).toHaveLength(1) 1'] = [=[
expect(received).toHaveLength(expected)

Expected length: 1
Received length: 0
Received table:  {}]=]

snapshots['.toHaveLength {pass: false} expect({1, 2}).toHaveLength(3) 1'] = [=[
expect(received).toHaveLength(expected)

Expected length: 3
Received length: 2
Received table:  {1, 2}]=]

snapshots['.toHaveLength {pass: true} expect("").toHaveLength(0) 1'] = [=[
expect(received).never.toHaveLength(expected)

Expected length: never 0
Received string:       ""]=]

snapshots['.toHaveLength {pass: true} expect({"a", "b"}).toHaveLength(2) 1'] = [=[
expect(received).never.toHaveLength(expected)

Expected length: never 2
Received table:        {"a", "b"}]=]

snapshots['.toHaveLength {pass: true} expect({}).toHaveLength(0) 1'] = [=[
expect(received).never.toHaveLength(expected)

Expected length: never 0
Received table:        {}]=]

snapshots['.toHaveLength {pass: true} expect({1, 2}).toHaveLength(2) 1'] = [=[
expect(received).never.toHaveLength(expected)

Expected length: never 2
Received table:        {1, 2}]=]

snapshots['.toHaveLength error cases 1'] = [=[
expect(received).toHaveLength(expected)

Matcher error: received value must have a length property whose value must be a number

Received has type:  table
Received has value: {"a": 9}]=]

snapshots['.toHaveLength error cases 2'] = [=[
expect(received).toHaveLength(expected)

Matcher error: received value must have a length property whose value must be a number

Received has type:  number
Received has value: 0]=]

snapshots['.toHaveLength error cases 3'] = [=[
expect(received).never.toHaveLength(expected)

Matcher error: received value must have a length property whose value must be a number

Received has value: nil]=]

snapshots['.toHaveLength matcher error expected length not number 1'] = [=[
expect(received).never.toHaveLength(expected)

Matcher error: expected value must be a non-negative integer

Expected has type:  string
Expected has value: "3"]=]

snapshots['.toHaveLength matcher error expected length number inf 1'] = [=[
expect(received).toHaveLength(expected)

Matcher error: expected value must be a non-negative integer

Expected has type:  number
Expected has value: inf]=]

snapshots['.toHaveLength matcher error expected length number nan 1'] = [=[
expect(received).never.toHaveLength(expected)

Matcher error: expected value must be a non-negative integer

Expected has type:  number
Expected has value: nan]=]

snapshots['.toHaveLength matcher error expected length number float 1'] = [=[
expect(received).toHaveLength(expected)

Matcher error: expected value must be a non-negative integer

Expected has type:  number
Expected has value: 0.5]=]

snapshots['.toHaveLength matcher error expected length number negative integer 1'] = [=[
expect(received).never.toHaveLength(expected)

Matcher error: expected value must be a non-negative integer

Expected has type:  number
Expected has value: -3]=]

snapshots['.toHaveProperty() {error} expect({"a": {"b": {}}}).toHaveProperty(1) 1'] = [=[
expect(received).toHaveProperty(path)

Matcher error: expected path must be a string or array

Expected has type:  number
Expected has value: 1]=]

snapshots['.toHaveProperty() {error} expect({"a": {"b": {}}}).toHaveProperty(nil) 1'] = [=[
expect(received).toHaveProperty(path)

Matcher error: expected path must be a string or array

Expected has value: nil]=]

snapshots['.toHaveProperty() {error} expect({}).toHaveProperty({}) 1'] = [=[
expect(received).toHaveProperty(path)

Matcher error: expected path must not be an empty array

Expected has type:  table
Expected has value: {}]=]

snapshots['.toHaveProperty() {error} expect(nil).toHaveProperty("a.b") 1'] = [=[
expect(received).toHaveProperty(path)

Matcher error: received value must not be nil

Received has value: nil]=]

snapshots['.toHaveProperty() {error} expect(nil).toHaveProperty("a") 1'] = [=[
expect(received).toHaveProperty(path)

Matcher error: received value must not be nil

Received has value: nil]=]

snapshots['.toHaveProperty() {pass: false} expect("abc").toHaveProperty("a.b.c", {"a": 5}) 1'] = [=[
expect(received).toHaveProperty(path, value)

Expected path: "a.b.c"
Received path: {}

Expected value: {"a": 5}
Received value: "abc"]=]

snapshots['.toHaveProperty() {pass: false} expect({"a": {"b": {"c": {"d": 1}}}}).toHaveProperty({"a", "b", "c", "d"}, 2) 1'] = [=[
expect(received).toHaveProperty(path, value)

Expected path: {"a", "b", "c", "d"}

Expected value: 2
Received value: 1]=]

snapshots['.toHaveProperty() {pass: false} expect({"a": {"b": {"c": {"d": 1}}}}).toHaveProperty("a.b.c.d", 2) 1'] = [=[
expect(received).toHaveProperty(path, value)

Expected path: "a.b.c.d"

Expected value: 2
Received value: 1]=]

snapshots['.toHaveProperty() {pass: false} expect({"a": {"b": {"c": {"d": 1}}}}).toHaveProperty("a.b.ttt.d", 1) 1'] = [=[
expect(received).toHaveProperty(path, value)

Expected path: "a.b.ttt.d"
Received path: "a.b"

Expected value: 1
Received value: {"c": {"d": 1}}]=]

snapshots['.toHaveProperty() {pass: false} expect({"a": {"b": {"c": {}}}}).toHaveProperty("a.b.c.d", 1) 1'] = [=[
expect(received).toHaveProperty(path, value)

Expected path: "a.b.c.d"
Received path: "a.b.c"

Expected value: 1
Received value: {}]=]

snapshots['.toHaveProperty() {pass: false} expect({"a": {"b": {"c": 5}}}).toHaveProperty("a.b", {"c": 4}) 1'] = [=[
expect(received).toHaveProperty(path, value)

Expected path: "a.b"

- Expected value  - 1
+ Received value  + 1

  Table {
-   "c": 4,
+   "c": 5,
  }]=]

snapshots['.toHaveProperty() {pass: false} expect({"a": 1}).toHaveProperty("a.b.c.d", 5) 1'] = [=[
expect(received).toHaveProperty(path, value)

Expected path: "a.b.c.d"
Received path: "a"

Expected value: 5
Received value: 1]=]

snapshots['.toHaveProperty() {pass: false} expect({"a.b.c.d": 1}).toHaveProperty("a.b.c.d", 2) 1'] = [=[
expect(received).toHaveProperty(path, value)

Expected path: "a.b.c.d"
Received path: {}

Expected value: 2
Received value: {"a.b.c.d": 1}]=]

snapshots['.toHaveProperty() {pass: false} expect({"a.b.c.d": 1}).toHaveProperty({"a.b.c.d"}, 2) 1'] = [=[
expect(received).toHaveProperty(path, value)

Expected path: {"a.b.c.d"}

Expected value: 2
Received value: 1]=]

snapshots['.toHaveProperty() {pass: false} expect({"children": {"\\"That cartoon\\""}, "type": "p"}).toHaveProperty({"children", 1}, "\\"That cat cartoon\\"") 1'] = [=[
expect(received).toHaveProperty(path, value)

Expected path: {"children", 1}

Expected value: "\"That cat cartoon\""
Received value: "\"That cartoon\""]=]

snapshots['.toHaveProperty() {pass: false} expect({"children": {"Roses are red.\nViolets are blue.\nTesting with Jest is good for you."}, "type": "pre"}).toHaveProperty({"children", 1}, "Roses are red, violets are blue.\nTesting with Jest\nIs good for you.") 1'] = [=[
expect(received).toHaveProperty(path, value)

Expected path: {"children", 1}

- Expected value  - 3
+ Received value  + 3

- Roses are red, violets are blue.
+ Roses are red.
+ Violets are blue.
- Testing with Jest
- Is good for you.
+ Testing with Jest is good for you.]=]

snapshots['.toHaveProperty() {pass: false} expect({}).toHaveProperty("a", "test") 1'] = [=[
expect(received).toHaveProperty(path, value)

Expected path: "a"
Received path: {}

Expected value: "test"
Received value: {}]=]

snapshots['.toHaveProperty() {pass: false} expect(1).toHaveProperty("a.b.c", "test") 1'] = [=[
expect(received).toHaveProperty(path, value)

Expected path: "a.b.c"
Received path: {}

Expected value: "test"
Received value: 1]=]

snapshots['.toHaveProperty() {pass: true} expect("").toHaveProperty("len", Any<function>) 1'] = [=[
expect(received).never.toHaveProperty(path, value)

Expected path: "len"

Expected value: never Any<function>]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {1, 2, 3}}}).toHaveProperty({"a", "b", 2}) 1'] = [=[
expect(received).never.toHaveProperty(path)

Expected path: never {"a", "b", 2}

Received value: 2]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {1, 2, 3}}}).toHaveProperty({"a", "b", 2}, 2) 1'] = [=[
expect(received).never.toHaveProperty(path, value)

Expected path: {"a", "b", 2}

Expected value: never 2]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {1, 2, 3}}}).toHaveProperty({"a", "b", 2}, Any<number>) 1'] = [=[
expect(received).never.toHaveProperty(path, value)

Expected path: {"a", "b", 2}

Expected value: never Any<number>
Received value:       2]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {"c": {"d": 1}}}}).toHaveProperty({"a", "b", "c", "d"}) 1'] = [=[
expect(received).never.toHaveProperty(path)

Expected path: never {"a", "b", "c", "d"}

Received value: 1]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {"c": {"d": 1}}}}).toHaveProperty({"a", "b", "c", "d"}, 1) 1'] = [=[
expect(received).never.toHaveProperty(path, value)

Expected path: {"a", "b", "c", "d"}

Expected value: never 1]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {"c": {"d": 1}}}}).toHaveProperty("a.b.c.d") 1'] = [=[
expect(received).never.toHaveProperty(path)

Expected path: never "a.b.c.d"

Received value: 1]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {"c": {"d": 1}}}}).toHaveProperty("a.b.c.d", 1) 1'] = [=[
expect(received).never.toHaveProperty(path, value)

Expected path: "a.b.c.d"

Expected value: never 1]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": {"c": 5}}}).toHaveProperty("a.b", {"c": 5}) 1'] = [=[
expect(received).never.toHaveProperty(path, value)

Expected path: "a.b"

Expected value: never {"c": 5}]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": false}}).toHaveProperty("a.b") 1'] = [=[
expect(received).never.toHaveProperty(path)

Expected path: never "a.b"

Received value: false]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": {"b": false}}).toHaveProperty("a.b", false) 1'] = [=[
expect(received).never.toHaveProperty(path, value)

Expected path: "a.b"

Expected value: never false]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": 0}).toHaveProperty("a") 1'] = [=[
expect(received).never.toHaveProperty(path)

Expected path: never "a"

Received value: 0]=]

snapshots['.toHaveProperty() {pass: true} expect({"a": 0}).toHaveProperty("a", 0) 1'] = [=[
expect(received).never.toHaveProperty(path, value)

Expected path: "a"

Expected value: never 0]=]

snapshots['.toHaveProperty() {pass: true} expect({"a.b.c.d": 1}).toHaveProperty({"a.b.c.d"}) 1'] = [=[
expect(received).never.toHaveProperty(path)

Expected path: never {"a.b.c.d"}

Received value: 1]=]

snapshots['.toHaveProperty() {pass: true} expect({"a.b.c.d": 1}).toHaveProperty({"a.b.c.d"}, 1) 1'] = [=[
expect(received).never.toHaveProperty(path, value)

Expected path: {"a.b.c.d"}

Expected value: never 1]=]

snapshots['.toHaveProperty() {pass: true} expect({"property": 1}).toHaveProperty("property", 1) 1'] = [=[
expect(received).never.toHaveProperty(path, value)

Expected path: "property"

Expected value: never 1]=]

snapshots['.toMatch() throws if non String actual value passed: [[Function anonymous], "foo"] 1'] = [=[
expect(received).toMatch(expected)

Matcher error: received value must be a string

Received has type:  function
Received has value: [Function anonymous]]=]

snapshots['.toMatch() throws if non String actual value passed: [{}, "foo"] 1'] = [=[
expect(received).toMatch(expected)

Matcher error: received value must be a string

Received has type:  table
Received has value: {}]=]

snapshots['.toMatch() throws if non String actual value passed: [1, "foo"] 1'] = [=[
expect(received).toMatch(expected)

Matcher error: received value must be a string

Received has type:  number
Received has value: 1]=]

snapshots['.toMatch() throws if non String actual value passed: [true, "foo"] 1'] = [=[
expect(received).toMatch(expected)

Matcher error: received value must be a string

Received has type:  boolean
Received has value: true]=]

snapshots['.toMatch() throws if non String actual value passed: [nil, "foo"] 1'] = [=[
expect(received).toMatch(expected)

Matcher error: received value must be a string

Received has value: nil]=]

snapshots['.toMatch() throws if non String/RegExp expected value passed: ["foo", [Function anonymous]] 1'] = [=[
expect(received).toMatch(expected)

Matcher error: expected value must be a string or regular expression

Expected has type:  function
Expected has value: [Function anonymous]]=]

snapshots['.toMatch() throws if non String/RegExp expected value passed: ["foo", {}] 1'] = [=[
expect(received).toMatch(expected)

Matcher error: expected value must be a string or regular expression

Expected has type:  table
Expected has value: {}]=]

snapshots['.toMatch() throws if non String/RegExp expected value passed: ["foo", 1] 1'] = [=[
expect(received).toMatch(expected)

Matcher error: expected value must be a string or regular expression

Expected has type:  number
Expected has value: 1]=]

snapshots['.toMatch() throws if non String/RegExp expected value passed: ["foo", true] 1'] = [=[
expect(received).toMatch(expected)

Matcher error: expected value must be a string or regular expression

Expected has type:  boolean
Expected has value: true]=]

snapshots['.toMatch() throws if non String/RegExp expected value passed: ["foo", nil] 1'] = [=[
expect(received).toMatch(expected)

Matcher error: expected value must be a string or regular expression

Expected has value: nil]=]

snapshots['.toMatch() throws: [bar, foo] 1'] = [=[
expect(received).toMatch(expected)

Expected pattern: "foo"
Received string:  "bar"]=]

snapshots['toMatchObject() {pass: false} expect({0}).toMatchObject({-0}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 1
+ Received  + 1

  Table {
-   -0,
+   0,
  }]=]

snapshots['toMatchObject() {pass: false} expect({1, 2}).toMatchObject({1, 3}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 1
+ Received  + 1

  Table {
    1,
-   3,
+   2,
  }]=]

snapshots['toMatchObject() {pass: false} expect({"a": "a", "c": "d"}).toMatchObject({"a": Any<number>}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 1
+ Received  + 1

  Table {
-   "a": Any<number>,
+   "a": "a",
  }]=]

snapshots['toMatchObject() {pass: false} expect({"a": "b", "c": "d"}).toMatchObject({"a": "b!", "c": "d"}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 1
+ Received  + 1

  Table {
-   "a": "b!",
+   "a": "b",
    "c": "d",
  }]=]

snapshots['toMatchObject() {pass: false} expect({"a": "b", "c": "d"}).toMatchObject({"e": "b"}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 1
+ Received  + 2

  Table {
-   "e": "b",
+   "a": "b",
+   "c": "d",
  }]=]

snapshots['toMatchObject() {pass: false} expect({"a": "b", "t": {"x": {"r": "r"}, "z": "z"}}).toMatchObject({"a": "b", "t": {"z": {3}}}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 3
+ Received  + 1

  Table {
    "a": "b",
    "t": Table {
-     "z": Table {
-       3,
-     },
+     "z": "z",
    },
  }]=]

snapshots['toMatchObject() {pass: false} expect({"a": "b", "t": {"x": {"r": "r"}, "z": "z"}}).toMatchObject({"t": {"l": {"r": "r"}}}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 1
+ Received  + 2

  Table {
    "t": Table {
-     "l": Table {
+     "x": Table {
        "r": "r",
      },
+     "z": "z",
    },
  }]=]

snapshots['toMatchObject() {pass: false} expect({"a": {3, 4, "v"}, "b": "b"}).toMatchObject({"a": {"v"}}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 0
+ Received  + 2

  Table {
    "a": Table {
+     3,
+     4,
      "v",
    },
  }]=]

snapshots['toMatchObject() {pass: false} expect({"a": {3, 4, 5}, "b": "b"}).toMatchObject({"a": {3, 4, 5, 6}}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 1
+ Received  + 0

  Table {
    "a": Table {
      3,
      4,
      5,
-     6,
    },
  }]=]

snapshots['toMatchObject() {pass: false} expect({"a": {3, 4, 5}, "b": "b"}).toMatchObject({"a": {3, 4}}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 0
+ Received  + 1

  Table {
    "a": Table {
      3,
      4,
+     5,
    },
  }]=]

snapshots['toMatchObject() {pass: false} expect({"a": {3, 4, 5}, "b": "b"}).toMatchObject({"a": {"b": 4}}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 1
+ Received  + 3

  Table {
    "a": Table {
-     "b": 4,
+     3,
+     4,
+     5,
    },
  }]=]

-- deviation: snapshot changed since we don't have a difference as Objet and Array as in upstream
snapshots['toMatchObject() {pass: false} expect({"a": {3, 4, 5}, "b": "b"}).toMatchObject({"a": {"b": Any<string>}}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 1
+ Received  + 3

  Table {
    "a": Table {
-     "b": Any<string>,
+     3,
+     4,
+     5,
    },
  }]=]

snapshots['toMatchObject() {pass: true} expect({}).toMatchObject({}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {}]=]

snapshots['toMatchObject() {pass: true} expect({1, 2}).toMatchObject({1, 2}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {1, 2}]=]

snapshots['toMatchObject() {pass: true} expect({"a": "b", "c": "d", Symbol(jest): "jest"}).toMatchObject({"a": "b", "c": "d", Symbol(jest): "jest"}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {"a": "b", "c": "d", Symbol(jest): "jest"}]=]

snapshots['toMatchObject() {pass: true} expect({"a": "b", "c": "d", Symbol(jest): "jest"}).toMatchObject({"a": "b", Symbol(jest): "jest"}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {"a": "b", Symbol(jest): "jest"}
Received:       {"a": "b", "c": "d", Symbol(jest): "jest"}]=]

snapshots['toMatchObject() {pass: true} expect({"a": "b", "c": "d"}).toMatchObject({"a": "b", "c": "d"}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {"a": "b", "c": "d"}]=]

snapshots['toMatchObject() {pass: true} expect({"a": "b", "c": "d"}).toMatchObject({"a": "b"}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {"a": "b"}
Received:       {"a": "b", "c": "d"}]=]

snapshots['toMatchObject() {pass: true} expect({"a": "b", "t": {"x": {"r": "r"}, "z": "z"}}).toMatchObject({"a": "b", "t": {"z": "z"}}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {"a": "b", "t": {"z": "z"}}
Received:       {"a": "b", "t": {"x": {"r": "r"}, "z": "z"}}]=]

snapshots['toMatchObject() {pass: true} expect({"a": "b", "t": {"x": {"r": "r"}, "z": "z"}}).toMatchObject({"t": {"x": {"r": "r"}}}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {"t": {"x": {"r": "r"}}}
Received:       {"a": "b", "t": {"x": {"r": "r"}, "z": "z"}}]=]

snapshots['toMatchObject() {pass: true} expect({"a": {{"a": "a", "b": "b"}}}).toMatchObject({"a": {{"a": "a"}}}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {"a": {{"a": "a"}}}
Received:       {"a": {{"a": "a", "b": "b"}}}]=]

snapshots['toMatchObject() {pass: true} expect({"a": {3, 4, 5, "v"}, "b": "b"}).toMatchObject({"a": {3, 4, 5, "v"}}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {"a": {3, 4, 5, "v"}}
Received:       {"a": {3, 4, 5, "v"}, "b": "b"}]=]

snapshots['toMatchObject() {pass: true} expect({"a": {3, 4, 5}, "b": "b"}).toMatchObject({"a": {3, 4, 5}}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {"a": {3, 4, 5}}
Received:       {"a": {3, 4, 5}, "b": "b"}]=]

snapshots['toMatchObject() {pass: true} expect({"a": {"x": "x", "y": "y"}}).toMatchObject({"a": {"x": Any<string>}}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {"a": {"x": Any<string>}}
Received:       {"a": {"x": "x", "y": "y"}}]=]

snapshots['toMatchObject() {pass: true} expect({"a": 1, "c": 2}).toMatchObject({"a": Any<number>}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {"a": Any<number>}
Received:       {"a": 1, "c": 2}]=]

snapshots['toMatchObject() {pass: true} expect({"a": 2015-11-30T00:00:00.000Z, "b": "b"}).toMatchObject({"a": 2015-11-30T00:00:00.000Z}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {"a": 2015-11-30T00:00:00.000Z}
Received:       {"a": 2015-11-30T00:00:00.000Z, "b": "b"}]=]

snapshots['toMatchObject() {pass: true} expect({"a": "undefined", "b": "b"}).toMatchObject({"a": "undefined"}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {"a": "undefined"}
Received:       {"a": "undefined", "b": "b"}]=]

snapshots['toMatchObject() circular references simple circular references {pass: false} expect({"a": "hello", "ref": [Circular]}).toMatchObject({"a": "world", "ref": [Circular]}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 1
+ Received  + 1

  Table {
-   "a": "world",
+   "a": "hello",
    "ref": [Circular],
  }]=]

snapshots['toMatchObject() circular references simple circular references {pass: false} expect({"ref": "not a ref"}).toMatchObject({"a": "hello", "ref": [Circular]}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 2
+ Received  + 1

  Table {
-   "a": "hello",
-   "ref": [Circular],
+   "ref": "not a ref",
  }]=]

snapshots['toMatchObject() circular references simple circular references {pass: false} expect({}).toMatchObject({"a": "hello", "ref": [Circular]}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 4
+ Received  + 1

- Table {
-   "a": "hello",
-   "ref": [Circular],
- }
+ Table {}]=]

snapshots['toMatchObject() circular references simple circular references {pass: true} expect({"a": "hello", "ref": [Circular]}).toMatchObject({"a": "hello", "ref": [Circular]}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {"a": "hello", "ref": [Circular]}]=]

snapshots['toMatchObject() circular references simple circular references {pass: true} expect({"a": "hello", "ref": [Circular]}).toMatchObject({}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {}
Received:       {"a": "hello", "ref": [Circular]}]=]

snapshots['toMatchObject() circular references transitive circular references {pass: false} expect({"a": "world", "nestedObj": {"parentObj": [Circular]}}).toMatchObject({"a": "hello", "nestedObj": {"parentObj": [Circular]}}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 1
+ Received  + 1

  Table {
-   "a": "hello",
+   "a": "world",
    "nestedObj": Table {
      "parentObj": [Circular],
    },
  }]=]

snapshots['toMatchObject() circular references transitive circular references {pass: false} expect({"nestedObj": {"parentObj": "not the parent ref"}}).toMatchObject({"a": "hello", "nestedObj": {"parentObj": [Circular]}}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 2
+ Received  + 1

  Table {
-   "a": "hello",
    "nestedObj": Table {
-     "parentObj": [Circular],
+     "parentObj": "not the parent ref",
    },
  }]=]

snapshots['toMatchObject() circular references transitive circular references {pass: false} expect({}).toMatchObject({"a": "hello", "nestedObj": {"parentObj": [Circular]}}) 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 6
+ Received  + 1

- Table {
-   "a": "hello",
-   "nestedObj": Table {
-     "parentObj": [Circular],
-   },
- }
+ Table {}]=]

snapshots['toMatchObject() circular references transitive circular references {pass: true} expect({"a": "hello", "nestedObj": {"parentObj": [Circular]}}).toMatchObject({"a": "hello", "nestedObj": {"parentObj": [Circular]}}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {"a": "hello", "nestedObj": {"parentObj": [Circular]}}]=]

snapshots['toMatchObject() circular references transitive circular references {pass: true} expect({"a": "hello", "nestedObj": {"parentObj": [Circular]}}).toMatchObject({}) 1'] = [=[
expect(received).never.toMatchObject(expected)

Expected: never {}
Received:       {"a": "hello", "nestedObj": {"parentObj": [Circular]}}]=]

snapshots['toMatchObject() does not match properties up in the prototype chain 1'] = [=[
expect(received).toMatchObject(expected)

- Expected  - 1
+ Received  + 0

  Table {
    "other": "child",
-   "ref": [Circular],
  }]=]

snapshots['toMatchObject() throws expect("44").toMatchObject({}) 1'] = [=[
expect(received).toMatchObject(expected)

Matcher error: received value must be a non-nil object

Received has type:  string
Received has value: "44"]=]

snapshots['toMatchObject() throws expect({}).toMatchObject("some string") 1'] = [=[
expect(received).toMatchObject(expected)

Matcher error: expected value must be a non-nil object

Expected has type:  string
Expected has value: "some string"]=]

snapshots['toMatchObject() throws expect({}).toMatchObject(4) 1'] = [=[
expect(received).toMatchObject(expected)

Matcher error: expected value must be a non-nil object

Expected has type:  number
Expected has value: 4]=]

snapshots['toMatchObject() throws expect({}).toMatchObject(true) 1'] = [=[
expect(received).toMatchObject(expected)

Matcher error: expected value must be a non-nil object

Expected has type:  boolean
Expected has value: true]=]

snapshots['toMatchObject() throws expect({}).toMatchObject(nil) 1'] = [=[
expect(received).toMatchObject(expected)

Matcher error: expected value must be a non-nil object

Expected has value: nil]=]

snapshots['toMatchObject() throws expect(4).toMatchObject({}) 1'] = [=[
expect(received).toMatchObject(expected)

Matcher error: received value must be a non-nil object

Received has type:  number
Received has value: 4]=]

snapshots['toMatchObject() throws expect(true).toMatchObject({}) 1'] = [=[
expect(received).toMatchObject(expected)

Matcher error: received value must be a non-nil object

Received has type:  boolean
Received has value: true]=]

snapshots['toMatchObject() throws expect(nil).toMatchObject({}) 1'] = [=[
expect(received).toMatchObject(expected)

Matcher error: received value must be a non-nil object

Received has value: nil]=]

snapshots['.toBeDefined() .toBeUndefined() "a" is defined 1'] = [=[
expect(received).never.toBeDefined()

Received: "a"]=]

snapshots['.toBeDefined() .toBeUndefined() [Function anonymous] is defined 1'] = [=[
expect(received).never.toBeDefined()

Received: [Function anonymous]]=]

snapshots['.toBeDefined() .toBeUndefined() {} is defined 1'] = [=[
expect(received).never.toBeDefined()

Received: {}]=]

snapshots['.toBeDefined() .toBeUndefined() 0.5 is defined 1'] = [=[
expect(received).never.toBeDefined()

Received: 0.5]=]

snapshots['.toBeDefined() .toBeUndefined() 1 is defined 1'] = [=[
expect(received).never.toBeDefined()

Received: 1]=]

snapshots['.toBeDefined() .toBeUndefined() inf is defined 1'] = [=[
expect(received).never.toBeDefined()

Received: inf]=]

snapshots['.toBeDefined() .toBeUndefined() true is defined 1'] = [=[
expect(received).never.toBeDefined()

Received: true]=]

snapshots['.toBeDefined() .toBeUndefined() "a" is defined 2'] = [=[
expect(received).toBeUndefined()

Received: "a"]=]

snapshots['.toBeDefined() .toBeUndefined() [Function anonymous] is defined 2'] = [=[
expect(received).toBeUndefined()

Received: [Function anonymous]]=]

snapshots['.toBeDefined() .toBeUndefined() {} is defined 2'] = [=[
expect(received).toBeUndefined()

Received: {}]=]

snapshots['.toBeDefined() .toBeUndefined() 0.5 is defined 2'] = [=[
expect(received).toBeUndefined()

Received: 0.5]=]

snapshots['.toBeDefined() .toBeUndefined() 1 is defined 2'] = [=[
expect(received).toBeUndefined()

Received: 1]=]

snapshots['.toBeDefined() .toBeUndefined() inf is defined 2'] = [=[
expect(received).toBeUndefined()

Received: inf]=]

snapshots['.toBeDefined() .toBeUndefined() true is defined 2'] = [=[
expect(received).toBeUndefined()

Received: true]=]

snapshots['.toBeDefined() .toBeUndefined() nil is undefined 1'] = [=[
expect(received).toBeDefined()

Received: nil]=]

snapshots['.toBeDefined() .toBeUndefined() nil is undefined 2'] = [=[
expect(received).never.toBeUndefined()

Received: nil]=]

return snapshots