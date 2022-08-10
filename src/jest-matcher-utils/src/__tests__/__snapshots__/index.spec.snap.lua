-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-matcher-utils/src/__tests__/__snapshots__/index.test.ts.snap
local snapshots = {}

--[=[
	ROBLOX deviation: edited several of the following snapshots to say
	'Matcher error: expected value must be a number'
	instead of:
	'Matcher error: expected value must be a number or bigint'

	ROBLOX deviation: edited several of the following snapshots to use 'Table' in
	place of 'Object'

	ROBLOX deviation: edited several of the following snapshots to use 'nil' in place
	of 'null' and 'undefined'
]=]

snapshots["ensureNoExpected() throws error when expected is not undefined with matcherName 1"] = [=[

<d>expect(</><r>received</><d>)[.never].toBeDefined()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  table
Expected has value: <g>{"a": 1}</>
]=]

snapshots["ensureNoExpected() throws error when expected is not undefined with matcherName and options 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeDefined<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  table
Expected has value: <g>{"a": 1}</>
]=]

snapshots["ensureNumbers() throws error when expected is not a number (backward compatibility) 1"] = [=[

<d>expect(</><r>received</><d>)[.never].toBeCloseTo(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a number

Expected has type:  string
Expected has value: <g>"not_a_number"</>
]=]

snapshots["ensureNumbers() throws error when received is not a number (backward compatibility) 1"] = [=[

<d>expect(</><r>received</><d>)[.never].toBeCloseTo(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a number

Received has type:  string
Received has value: <r>"not_a_number"</>
]=]

snapshots["ensureNumbers() with options promise empty isNot false received 1"] = [=[

<d>expect(</><r>received</><d>).</>toBeCloseTo<d>(</><g>expected</><d>, </><g>precision</><d>)</>

<b>Matcher error</>: <r>received</> value must be a number

Received has type:  string
Received has value: <r>""</>
]=]

snapshots["ensureNumbers() with options promise empty isNot true expected 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a number

Expected has value: <g>nil</>
]=]

snapshots["ensureNumbers() with options promise rejects isNot false expected 1"] = [=[

<d>expect(</><r>received</><d>).</>rejects<d>.</>toBeCloseTo<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a number

Expected has type:  string
Expected has value: <g>"0"</>
]=]

snapshots["ensureNumbers() with options promise rejects isNot true received 1"] = [=[

<d>expect(</><r>received</><d>).</>rejects<d>.</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a number

Received has type:  symbol
Received has value: <r>Symbol(0.1)</>
]=]

snapshots["ensureNumbers() with options promise resolves isNot false received 1"] = [=[

<d>expect(</><r>received</><d>).</>resolves<d>.</>toBeCloseTo<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a number

Received has type:  boolean
Received has value: <r>false</>
]=]

snapshots["ensureNumbers() with options promise resolves isNot true expected 1"] = [=[

<d>expect(</><r>received</><d>).</>resolves<d>.</>never<d>.</>toBeCloseTo<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a number

Expected has value: <g>nil</>
]=]

-- Additional snapshots NOT in upstream so that we can run the jest-diff tests
-- We don't have mocking capabilities so we compare with the actual output of
-- jest-diff

snapshots["diff forwards to jest-diff 1"] = [=[

<g>- Expected</>
<r>+ Received</>

<g>- a</>
<r>+ b</>
]=]

snapshots["diff forwards to jest-diff 2"] = [=[
  Comparing two different types of values. Expected <g>string</> but received <r>table</>.]=]

snapshots["diff forwards to jest-diff 3"] = [=[
  Comparing two different types of values. Expected <g>string</> but received <r>nil</>.]=]

snapshots["diff forwards to jest-diff 4"] = [=[
  Comparing two different types of values. Expected <g>string</> but received <r>number</>.]=]

snapshots["diff forwards to jest-diff 5"] = [=[
  Comparing two different types of values. Expected <g>string</> but received <r>boolean</>.]=]

snapshots["diff forwards to jest-diff 6"] = [=[
  Comparing two different types of values. Expected <g>number</> but received <r>boolean</>.]=]

return snapshots
