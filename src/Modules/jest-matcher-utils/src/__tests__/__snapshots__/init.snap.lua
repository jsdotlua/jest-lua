--!strict
-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/jest-matcher-utils/src/__tests__/__snapshots__/index.test.ts.snap
local snapshots = {}

--[[
	deviation: edited several of the following snapshots to say
	'Matcher error: expected value must be a number'
	instead of:
	'Matcher error: expected value must be a number or bigint'

	deviation: edited several of the following snapshots to use 'Table' in
	place of 'Object'

	deviation: edited several of the following snapshots to use 'nil' in place
	of 'null' and 'undefined'
]]
snapshots["ensureNoExpected() throws error when expected is not undefined with matcherName 1"] = [[
expect(received)[.never].toBeDefined()

Matcher error: this matcher must not have an expected argument

Expected has type:  table
Expected has value: {"a": 1}
]]

snapshots["ensureNoExpected() throws error when expected is not undefined with matcherName and options 1"] = [[
expect(received).never.toBeDefined()

Matcher error: this matcher must not have an expected argument

Expected has type:  table
Expected has value: {"a": 1}
]]

snapshots["ensureNumbers() throws error when expected is not a number (backward compatibility) 1"] = [[
expect(received)[.never].toBeCloseTo(expected)

Matcher error: expected value must be a number

Expected has type:  string
Expected has value: "not_a_number"]]

snapshots["ensureNumbers() throws error when received is not a number (backward compatibility) 1"] = [[
expect(received)[.never].toBeCloseTo(expected)

Matcher error: received value must be a number

Received has type:  string
Received has value: "not_a_number"
]]

snapshots["ensureNumbers() with options promise empty isNot false received 1"] = [[
expect(received).toBeCloseTo(expected, precision)

Matcher error: received value must be a number

Received has type:  string
Received has value: ""
]]

snapshots["ensureNumbers() with options promise empty isNot true expected 1"] = [[
expect(received).never.toBeCloseTo(expected)

Matcher error: expected value must be a number

Expected has value: nil
]]

snapshots["ensureNumbers() with options promise rejects isNot false expected 1"] = [[
expect(received).rejects.toBeCloseTo(expected)

Matcher error: expected value must be a number

Expected has type:  string
Expected has value: "0"
]]

snapshots["ensureNumbers() with options promise rejects isNot true received 1"] = [[
expect(received).rejects.never.toBeCloseTo(expected)

Matcher error: received value must be a number

Received has type:  symbol
Received has value: Symbol(0.1)
]]

snapshots["ensureNumbers() with options promise resolves isNot false received 1"] = [[
expect(received).resolves.toBeCloseTo(expected)

Matcher error: received value must be a number

Received has type:  boolean
Received has value: false
]]

snapshots["ensureNumbers() with options promise resolves isNot true expected 1"] = [[
expect(received).resolves.never.toBeCloseTo(expected)

Matcher error: expected value must be a number

Expected has value: nil
]]

snapshots["stringify() toJSON errors when comparing two objects 1"] = [[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Object {
-   "b": 1,
+   "a": 1,
    "toJSON": [Function anonymous],
  }
]]

-- Additional snapshots NOT in upstream so that we can run the jest-diff tests
-- We don't have mocking capabilities so we compare with the actual output of
-- jest-diff

snapshots["diff forwards to jest-diff 1"] = [[
- Expected
+ Received

- a
+ b]]

snapshots["diff forwards to jest-diff 2"] = [[
  Comparing two different types of values. Expected string but received table.]]

snapshots["diff forwards to jest-diff 3"] = [[
  Comparing two different types of values. Expected string but received nil.]]

snapshots["diff forwards to jest-diff 4"] = [[
  Comparing two different types of values. Expected string but received number.]]

snapshots["diff forwards to jest-diff 5"] = [[
  Comparing two different types of values. Expected string but received boolean.]]

snapshots["diff forwards to jest-diff 6"] = [[
  Comparing two different types of values. Expected number but received boolean.]]

return snapshots
