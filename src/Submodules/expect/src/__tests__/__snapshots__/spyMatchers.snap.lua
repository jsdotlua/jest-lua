-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/expect/src/__tests__/__snapshots__/spyMatchers.test.ts.snap

--[[
       deviations:
              - changed "undefined" to "nil"
              - changed "not" to "never"
              - changed named functions i.e. "[Function fn]" to "[Function anonymous]"
              - changed "Infinity" to "inf"
              - snapshots that have "works with map" in their description were changed from Map to Table

]]

local snapshots = {}

snapshots['lastCalledWith includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

snapshots['lastCalledWith works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['lastCalledWith works when not called 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>

Number of calls: <r>0</>
]=]

snapshots['lastCalledWith works with Immutable.js objects 1'] = [=[

expect(jest.fn()).never.lastCalledWith(...expected)

Expected: never Immutable.Map {"a": {"b": "c"}}, Immutable.Map {"a": {"b": "c"}}

Number of calls: 1
]=]

snapshots['lastCalledWith works with Map 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of calls: <r>1</>
]=]

snapshots['lastCalledWith works with Map 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Table {</>
<d>    Table {</>
<g>-     "a",</>
<g>-     "b",</>
<r>+     1,</>
<r>+     2,</>
<d>    },</>
<d>    Table {</>
<g>-     "b",</>
<g>-     "a",</>
<r>+     2,</>
<r>+     1,</>
<d>    },</>
<d>  }</>,

Number of calls: <r>1</>
]=]

snapshots['lastCalledWith works with Set 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of calls: <r>1</>
]=]

snapshots['lastCalledWith works with Set 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Set {</>
<g>-   3,</>
<g>-   4,</>
<r>+   1,</>
<r>+   2,</>
<d>  }</>,

Number of calls: <r>1</>
]=]

snapshots['lastCalledWith works with arguments that don\'t match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <r>"bar1"</>

Number of calls: <r>1</>
]=]

snapshots['lastCalledWith works with arguments that match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

snapshots['lastCalledWith works with many arguments 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>
Received
       2:       <d>"foo"</>, <r>"bar1"</>
->     3:       <d>"foo"</>, <d>"bar"</>

Number of calls: <r>3</>
]=]

snapshots['lastCalledWith works with many arguments that don\'t match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received
       2: <d>"foo"</>, <r>"bar2"</>
->     3: <d>"foo"</>, <r>"bar3"</>

Number of calls: <r>3</>
]=]

snapshots['lastCalledWith works with trailing undefined arguments 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

snapshots['lastReturnedWith a call that throws is not considered to have returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

snapshots['lastReturnedWith a call that throws undefined is not considered to have returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

snapshots['lastReturnedWith includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

snapshots['lastReturnedWith lastReturnedWith incomplete recursive calls are handled properly 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>0</>
Received
       3: function call has not returned yet
->     4: function call has not returned yet

Number of returns: <r>0</>
Number of calls:   <r>4</>
]=]

snapshots['lastReturnedWith lastReturnedWith works with three calls 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>"foo3"</>
Received
       2:       <r>"foo2"</>
->     3:       <d>"foo3"</>

Number of returns: <r>3</>
]=]

snapshots['lastReturnedWith works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['lastReturnedWith works when not called 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

snapshots['lastReturnedWith works with Immutable.js objects directly created 1'] = [=[

expect(jest.fn()).never.lastReturnedWith(expected)

Expected: never Immutable.Map {"a": {"b": "c"}}

Number of returns: 1
]=]

snapshots['lastReturnedWith works with Immutable.js objects indirectly created 1'] = [=[

expect(jest.fn()).never.lastReturnedWith(expected)

Expected: never Immutable.Map {"a": {"b": "c"}}

Number of returns: 1
]=]

snapshots['lastReturnedWith works with Map 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

snapshots['lastReturnedWith works with Map 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>{{"a", "b"}, {"b", "a"}}</>
Received: <r>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

snapshots['lastReturnedWith works with Set 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of returns: <r>1</>
]=]

snapshots['lastReturnedWith works with Set 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>Set {3, 4}</>
Received: <r>Set {1, 2}</>

Number of returns: <r>1</>
]=]

snapshots['lastReturnedWith works with argument that does match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>"foo"</>

Number of returns: <r>1</>
]=]

snapshots['lastReturnedWith works with argument that does not match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"bar"</>
Received: <r>"foo"</>

Number of returns: <r>1</>
]=]

snapshots['lastReturnedWith works with undefined 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>lastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>nil</>

Number of returns: <r>1</>
]=]

snapshots['nthCalledWith includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

snapshots['nthCalledWith negative throw matcher error for n that is not integer 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: inf
]=]

snapshots['nthCalledWith positive throw matcher error for n that is not integer 1'] = [=[

<d>expect(</><r>received</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0.1
]=]

snapshots['nthCalledWith positive throw matcher error for n that is not positive integer 1'] = [=[

<d>expect(</><r>received</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0
]=]

snapshots['nthCalledWith works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['nthCalledWith works when not called 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>, <g>"bar"</>

Number of calls: <r>0</>
]=]

snapshots['nthCalledWith works with Immutable.js objects 1'] = [=[

expect(jest.fn()).never.nthCalledWith(n, ...expected)

n: 1
Expected: never Immutable.Map {"a": {"b": "c"}}, Immutable.Map {"a": {"b": "c"}}

Number of calls: 1
]=]

snapshots['nthCalledWith works with Map 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>{{1, 2}, {2, 1}}</>

Number of calls: <r>1</>
]=]

snapshots['nthCalledWith works with Map 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
<g>- Expected</>
<r>+ Received</>

<d>  Table {</>
<d>    Table {</>
<g>-     "a",</>
<g>-     "b",</>
<r>+     1,</>
<r>+     2,</>
<d>    },</>
<d>    Table {</>
<g>-     "b",</>
<g>-     "a",</>
<r>+     2,</>
<r>+     1,</>
<d>    },</>
<d>  }</>,

Number of calls: <r>1</>
]=]

snapshots['nthCalledWith works with Set 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>Set {1, 2}</>

Number of calls: <r>1</>
]=]

snapshots['nthCalledWith works with Set 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
<g>- Expected</>
<r>+ Received</>

<d>  Set {</>
<g>-   3,</>
<g>-   4,</>
<r>+   1,</>
<r>+   2,</>
<d>  }</>,

Number of calls: <r>1</>
]=]

snapshots['nthCalledWith works with arguments that don\'t match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <r>"bar1"</>

Number of calls: <r>1</>
]=]

snapshots['nthCalledWith works with arguments that match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

snapshots['nthCalledWith works with three calls 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>"foo1"</>, <g>"bar"</>
Received
->     1:       <d>"foo1"</>, <d>"bar"</>
       2:       <r>"foo"</>, <r>"bar1"</>

Number of calls: <r>3</>
]=]

snapshots['nthCalledWith works with trailing undefined arguments 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

snapshots['nthReturnedWith a call that throws is not considered to have returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

snapshots['nthReturnedWith a call that throws undefined is not considered to have returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

snapshots['nthReturnedWith includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

snapshots['nthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>6</>
Received
->     1: function call has not returned yet
       2: function call has not returned yet

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

snapshots['nthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 2
Expected: <g>3</>
Received
       1: function call has not returned yet
->     2: function call has not returned yet
       3: <r>1</>

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

snapshots['nthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 3'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 3
Expected: never <g>1</>
Received
       2:       function call has not returned yet
->     3:       <d>1</>
       4:       <r>0</>

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

snapshots['nthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 4'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 4
Expected: never <g>0</>
Received
       3:       <r>1</>
->     4:       <d>0</>

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

snapshots['nthReturnedWith nthReturnedWith negative throw matcher error for n that is not number 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has value: nil
]=]

snapshots['nthReturnedWith nthReturnedWith positive throw matcher error for n that is not integer 1'] = [=[

<d>expect(</><r>received</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0.1
]=]

snapshots['nthReturnedWith nthReturnedWith positive throw matcher error for n that is not positive integer 1'] = [=[

<d>expect(</><r>received</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0
]=]

snapshots['nthReturnedWith nthReturnedWith should reject nth value greater than number of calls 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 4
Expected: <g>"foo"</>
Received
       3: <d>"foo"</>

Number of returns: <r>3</>
]=]

snapshots['nthReturnedWith nthReturnedWith should replace 1st, 2nd, 3rd with first, second, third 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"bar1"</>
Received
->     1: <r>"foo1"</>
       2: <r>"foo2"</>

Number of returns: <r>3</>
]=]

snapshots['nthReturnedWith nthReturnedWith should replace 1st, 2nd, 3rd with first, second, third 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>"foo1"</>
Received
->     1:       <d>"foo1"</>
       2:       <r>"foo2"</>

Number of returns: <r>3</>
]=]

snapshots['nthReturnedWith nthReturnedWith works with three calls 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>"foo1"</>
Received
->     1:       <d>"foo1"</>
       2:       <r>"foo2"</>

Number of returns: <r>3</>
]=]

snapshots['nthReturnedWith works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['nthReturnedWith works when not called 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

snapshots['nthReturnedWith works with Immutable.js objects directly created 1'] = [=[

expect(jest.fn()).never.nthReturnedWith(n, expected)

n: 1
Expected: never Immutable.Map {"a": {"b": "c"}}

Number of returns: 1
]=]

snapshots['nthReturnedWith works with Immutable.js objects indirectly created 1'] = [=[

expect(jest.fn()).never.nthReturnedWith(n, expected)

n: 1
Expected: never Immutable.Map {"a": {"b": "c"}}

Number of returns: 1
]=]

snapshots['nthReturnedWith works with Map 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

snapshots['nthReturnedWith works with Map 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>{{"a", "b"}, {"b", "a"}}</>
Received: <r>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

snapshots['nthReturnedWith works with Set 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>Set {1, 2}</>

Number of returns: <r>1</>
]=]

snapshots['nthReturnedWith works with Set 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>Set {3, 4}</>
Received: <r>Set {1, 2}</>

Number of returns: <r>1</>
]=]

snapshots['nthReturnedWith works with argument that does match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>"foo"</>

Number of returns: <r>1</>
]=]

snapshots['nthReturnedWith works with argument that does not match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"bar"</>
Received: <r>"foo"</>

Number of returns: <r>1</>
]=]

snapshots['nthReturnedWith works with undefined 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>nthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>nil</>

Number of returns: <r>1</>
]=]

snapshots['toBeCalled .not fails with any argument passed 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCalled<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

snapshots['toBeCalled .not passes when called 1'] = [=[

<d>expect(</><r>spy</><d>).</>toBeCalled<d>()</>

Expected number of calls: >= <g>1</>
Received number of calls:    <r>0</>
]=]

snapshots['toBeCalled fails with any argument passed 1'] = [=[

<d>expect(</><r>received</><d>).</>toBeCalled<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

snapshots['toBeCalled includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toBeCalled<d>()</>

Expected number of calls: <g>0</>
Received number of calls: <r>1</>

1: called with 0 arguments
]=]

snapshots['toBeCalled passes when called 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toBeCalled<d>()</>

Expected number of calls: <g>0</>
Received number of calls: <r>1</>

1: <r>"arg0"</>, <r>"arg1"</>, <r>"arg2"</>
]=]

snapshots['toBeCalled works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>toBeCalled<d>()</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['toBeCalledTimes .not only accepts a number argument 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

-- snapshots['toBeCalledTimes .not only accepts a number argument 2'] = [=[

-- expect(received).never.toBeCalledTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  array
-- Expected has value: []]=]

snapshots['toBeCalledTimes .not only accepts a number argument 2'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

snapshots['toBeCalledTimes .not only accepts a number argument 3'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

-- snapshots['toBeCalledTimes .not only accepts a number argument 5'] = [=[

-- expect(received).never.toBeCalledTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  map
-- Expected has value: Map {}]=]

snapshots['toBeCalledTimes .not only accepts a number argument 4'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

snapshots['toBeCalledTimes .not passes if function called less than expected times 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: <g>2</>
Received number of calls: <r>1</>
]=]

snapshots['toBeCalledTimes .not passes if function called more than expected times 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: <g>2</>
Received number of calls: <r>3</>
]=]

snapshots['toBeCalledTimes .not works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['toBeCalledTimes includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>toBeCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: <g>2</>
Received number of calls: <r>1</>
]=]

snapshots['toBeCalledTimes only accepts a number argument 1'] = [=[

<d>expect(</><r>received</><d>).</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

-- snapshots['toBeCalledTimes only accepts a number argument 2'] = [=[

-- expect(received).toBeCalledTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  array
-- Expected has value: []]=]

snapshots['toBeCalledTimes only accepts a number argument 2'] = [=[

<d>expect(</><r>received</><d>).</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

snapshots['toBeCalledTimes only accepts a number argument 3'] = [=[

<d>expect(</><r>received</><d>).</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

-- snapshots['toBeCalledTimes only accepts a number argument 5'] = [=[

-- expect(received).toBeCalledTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  map
-- Expected has value: Map {}]=]

snapshots['toBeCalledTimes only accepts a number argument 4'] = [=[

<d>expect(</><r>received</><d>).</>toBeCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

snapshots['toBeCalledTimes passes if function called equal to expected times 1'] = [=[

<d>expect(</><r>spy</><d>).</>never<d>.</>toBeCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: never <g>2</>
]=]

snapshots['toBeCalledWith includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

snapshots['toBeCalledWith works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['toBeCalledWith works when not called 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>

Number of calls: <r>0</>
]=]

snapshots['toBeCalledWith works with Immutable.js objects 1'] = [=[

expect(jest.fn()).never.toBeCalledWith(...expected)

Expected: never Immutable.Map {"a": {"b": "c"}}, Immutable.Map {"a": {"b": "c"}}

Number of calls: 1
]=]

snapshots['toBeCalledWith works with Map 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of calls: <r>1</>
]=]

snapshots['toBeCalledWith works with Map 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Table {</>
<d>    Table {</>
<g>-     "a",</>
<g>-     "b",</>
<r>+     1,</>
<r>+     2,</>
<d>    },</>
<d>    Table {</>
<g>-     "b",</>
<g>-     "a",</>
<r>+     2,</>
<r>+     1,</>
<d>    },</>
<d>  }</>,

Number of calls: <r>1</>
]=]

snapshots['toBeCalledWith works with Set 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of calls: <r>1</>
]=]

snapshots['toBeCalledWith works with Set 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Set {</>
<g>-   3,</>
<g>-   4,</>
<r>+   1,</>
<r>+   2,</>
<d>  }</>,

Number of calls: <r>1</>
]=]

snapshots['toBeCalledWith works with arguments that don\'t match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <r>"bar1"</>

Number of calls: <r>1</>
]=]

snapshots['toBeCalledWith works with arguments that match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

snapshots['toBeCalledWith works with many arguments 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>
Received
       3:       <d>"foo"</>, <d>"bar"</>

Number of calls: <r>3</>
]=]

snapshots['toBeCalledWith works with many arguments that don\'t match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received
       1: <d>"foo"</>, <r>"bar1"</>
       2: <d>"foo"</>, <r>"bar2"</>
       3: <d>"foo"</>, <r>"bar3"</>

Number of calls: <r>3</>
]=]

snapshots['toBeCalledWith works with trailing undefined arguments 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toBeCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenCalled .not fails with any argument passed 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveBeenCalled<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

snapshots['toHaveBeenCalled .not passes when called 1'] = [=[

<d>expect(</><r>spy</><d>).</>toHaveBeenCalled<d>()</>

Expected number of calls: >= <g>1</>
Received number of calls:    <r>0</>
]=]

snapshots['toHaveBeenCalled fails with any argument passed 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenCalled<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

snapshots['toHaveBeenCalled includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toHaveBeenCalled<d>()</>

Expected number of calls: <g>0</>
Received number of calls: <r>1</>

1: called with 0 arguments
]=]

snapshots['toHaveBeenCalled passes when called 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenCalled<d>()</>

Expected number of calls: <g>0</>
Received number of calls: <r>1</>

1: <r>"arg0"</>, <r>"arg1"</>, <r>"arg2"</>
]=]

snapshots['toHaveBeenCalled works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenCalled<d>()</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['toHaveBeenCalledTimes .not only accepts a number argument 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

-- snapshots['toHaveBeenCalledTimes .not only accepts a number argument 2'] = [=[

-- expect(received).never.toHaveBeenCalledTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  array
-- Expected has value: []]=]

snapshots['toHaveBeenCalledTimes .not only accepts a number argument 2'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

snapshots['toHaveBeenCalledTimes .not only accepts a number argument 3'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

-- snapshots['toHaveBeenCalledTimes .not only accepts a number argument 5'] = [=[

-- expect(received).never.toHaveBeenCalledTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  map
-- Expected has value: Map {}]=]

snapshots['toHaveBeenCalledTimes .not only accepts a number argument 4'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

snapshots['toHaveBeenCalledTimes .not passes if function called less than expected times 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: <g>2</>
Received number of calls: <r>1</>
]=]

snapshots['toHaveBeenCalledTimes .not passes if function called more than expected times 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: <g>2</>
Received number of calls: <r>3</>
]=]

snapshots['toHaveBeenCalledTimes .not works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['toHaveBeenCalledTimes includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: <g>2</>
Received number of calls: <r>1</>
]=]

snapshots['toHaveBeenCalledTimes only accepts a number argument 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

-- snapshots['toHaveBeenCalledTimes only accepts a number argument 2'] = [=[

-- expect(received).toHaveBeenCalledTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  array
-- Expected has value: []]=]

snapshots['toHaveBeenCalledTimes only accepts a number argument 2'] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

snapshots['toHaveBeenCalledTimes only accepts a number argument 3'] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

-- snapshots['toHaveBeenCalledTimes only accepts a number argument 5'] = [=[

-- expect(received).toHaveBeenCalledTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  map
-- Expected has value: Map {}]=]

snapshots['toHaveBeenCalledTimes only accepts a number argument 4'] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

snapshots['toHaveBeenCalledTimes passes if function called equal to expected times 1'] = [=[

<d>expect(</><r>spy</><d>).</>never<d>.</>toHaveBeenCalledTimes<d>(</><g>expected</><d>)</>

Expected number of calls: never <g>2</>
]=]

snapshots['toHaveBeenCalledWith includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenCalledWith works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['toHaveBeenCalledWith works when not called 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>

Number of calls: <r>0</>
]=]

snapshots['toHaveBeenCalledWith works with Immutable.js objects 1'] = [=[

expect(jest.fn()).never.toHaveBeenCalledWith(...expected)

Expected: never Immutable.Map {"a": {"b": "c"}}, Immutable.Map {"a": {"b": "c"}}

Number of calls: 1
]=]

snapshots['toHaveBeenCalledWith works with Map 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenCalledWith works with Map 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Table {</>
<d>    Table {</>
<g>-     "a",</>
<g>-     "b",</>
<r>+     1,</>
<r>+     2,</>
<d>    },</>
<d>    Table {</>
<g>-     "b",</>
<g>-     "a",</>
<r>+     2,</>
<r>+     1,</>
<d>    },</>
<d>  }</>,

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenCalledWith works with Set 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenCalledWith works with Set 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Set {</>
<g>-   3,</>
<g>-   4,</>
<r>+   1,</>
<r>+   2,</>
<d>  }</>,

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenCalledWith works with arguments that don\'t match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <r>"bar1"</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenCalledWith works with arguments that match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenCalledWith works with many arguments 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>
Received
       3:       <d>"foo"</>, <d>"bar"</>

Number of calls: <r>3</>
]=]

snapshots['toHaveBeenCalledWith works with many arguments that don\'t match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received
       1: <d>"foo"</>, <r>"bar1"</>
       2: <d>"foo"</>, <r>"bar2"</>
       3: <d>"foo"</>, <r>"bar3"</>

Number of calls: <r>3</>
]=]

snapshots['toHaveBeenCalledWith works with trailing undefined arguments 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenLastCalledWith includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenLastCalledWith works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['toHaveBeenLastCalledWith works when not called 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>

Number of calls: <r>0</>
]=]

snapshots['toHaveBeenLastCalledWith works with Immutable.js objects 1'] = [=[

expect(jest.fn()).never.toHaveBeenLastCalledWith(...expected)

Expected: never Immutable.Map {"a": {"b": "c"}}, Immutable.Map {"a": {"b": "c"}}

Number of calls: 1
]=]

snapshots['toHaveBeenLastCalledWith works with Map 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenLastCalledWith works with Map 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Table {</>
<d>    Table {</>
<g>-     "a",</>
<g>-     "b",</>
<r>+     1,</>
<r>+     2,</>
<d>    },</>
<d>    Table {</>
<g>-     "b",</>
<g>-     "a",</>
<r>+     2,</>
<r>+     1,</>
<d>    },</>
<d>  }</>,

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenLastCalledWith works with Set 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenLastCalledWith works with Set 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

<g>- Expected</>
<r>+ Received</>

<d>  Set {</>
<g>-   3,</>
<g>-   4,</>
<r>+   1,</>
<r>+   2,</>
<d>  }</>,

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenLastCalledWith works with arguments that don\'t match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <r>"bar1"</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenLastCalledWith works with arguments that match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenLastCalledWith works with many arguments 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: never <g>"foo"</>, <g>"bar"</>
Received
       2:       <d>"foo"</>, <r>"bar1"</>
->     3:       <d>"foo"</>, <d>"bar"</>

Number of calls: <r>3</>
]=]

snapshots['toHaveBeenLastCalledWith works with many arguments that don\'t match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>, <g>"bar"</>
Received
       2: <d>"foo"</>, <r>"bar2"</>
->     3: <d>"foo"</>, <r>"bar3"</>

Number of calls: <r>3</>
]=]

snapshots['toHaveBeenLastCalledWith works with trailing undefined arguments 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenLastCalledWith<d>(</><g>...expected</><d>)</>

Expected: <g>"foo"</>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenNthCalledWith includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenNthCalledWith negative throw matcher error for n that is not integer 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: inf
]=]

snapshots['toHaveBeenNthCalledWith positive throw matcher error for n that is not integer 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0.1
]=]

snapshots['toHaveBeenNthCalledWith positive throw matcher error for n that is not positive integer 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0
]=]

snapshots['toHaveBeenNthCalledWith works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock or spy function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['toHaveBeenNthCalledWith works when not called 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>, <g>"bar"</>

Number of calls: <r>0</>
]=]

snapshots['toHaveBeenNthCalledWith works with Immutable.js objects 1'] = [=[

expect(jest.fn()).never.toHaveBeenNthCalledWith(n, ...expected)

n: 1
Expected: never Immutable.Map {"a": {"b": "c"}}, Immutable.Map {"a": {"b": "c"}}

Number of calls: 1
]=]

snapshots['toHaveBeenNthCalledWith works with Map 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>{{1, 2}, {2, 1}}</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenNthCalledWith works with Map 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
<g>- Expected</>
<r>+ Received</>

<d>  Table {</>
<d>    Table {</>
<g>-     "a",</>
<g>-     "b",</>
<r>+     1,</>
<r>+     2,</>
<d>    },</>
<d>    Table {</>
<g>-     "b",</>
<g>-     "a",</>
<r>+     2,</>
<r>+     1,</>
<d>    },</>
<d>  }</>,

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenNthCalledWith works with Set 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>Set {1, 2}</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenNthCalledWith works with Set 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
<g>- Expected</>
<r>+ Received</>

<d>  Set {</>
<g>-   3,</>
<g>-   4,</>
<r>+   1,</>
<r>+   2,</>
<d>  }</>,

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenNthCalledWith works with arguments that don\'t match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>, <g>"bar"</>
Received: <d>"foo"</>, <r>"bar1"</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenNthCalledWith works with arguments that match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>"foo"</>, <g>"bar"</>

Number of calls: <r>1</>
]=]

snapshots['toHaveBeenNthCalledWith works with three calls 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: never <g>"foo1"</>, <g>"bar"</>
Received
->     1:       <d>"foo1"</>, <d>"bar"</>
       2:       <r>"foo"</>, <r>"bar1"</>

Number of calls: <r>3</>
]=]

snapshots['toHaveBeenNthCalledWith works with trailing undefined arguments 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveBeenNthCalledWith<d>(</>n<d>, </><g>...expected</><d>)</>

n: 1
Expected: <g>"foo"</>
Received: <d>"foo"</>, <r>nil</>

Number of calls: <r>1</>
]=]

snapshots['toHaveLastReturnedWith a call that throws is not considered to have returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

snapshots['toHaveLastReturnedWith a call that throws undefined is not considered to have returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

snapshots['toHaveLastReturnedWith includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

snapshots['toHaveLastReturnedWith lastReturnedWith incomplete recursive calls are handled properly 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>0</>
Received
       3: function call has not returned yet
->     4: function call has not returned yet

Number of returns: <r>0</>
Number of calls:   <r>4</>
]=]

snapshots['toHaveLastReturnedWith lastReturnedWith works with three calls 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>"foo3"</>
Received
       2:       <r>"foo2"</>
->     3:       <d>"foo3"</>

Number of returns: <r>3</>
]=]

snapshots['toHaveLastReturnedWith works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['toHaveLastReturnedWith works when not called 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

snapshots['toHaveLastReturnedWith works with Immutable.js objects directly created 1'] = [=[

expect(jest.fn()).never.toHaveLastReturnedWith(expected)

Expected: never Immutable.Map {"a": {"b": "c"}}

Number of returns: 1
]=]

snapshots['toHaveLastReturnedWith works with Immutable.js objects indirectly created 1'] = [=[

expect(jest.fn()).never.toHaveLastReturnedWith(expected)

Expected: never Immutable.Map {"a": {"b": "c"}}

Number of returns: 1
]=]

snapshots['toHaveLastReturnedWith works with Map 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

snapshots['toHaveLastReturnedWith works with Map 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>{{"a", "b"}, {"b", "a"}}</>
Received: <r>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

snapshots['toHaveLastReturnedWith works with Set 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of returns: <r>1</>
]=]

snapshots['toHaveLastReturnedWith works with Set 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>Set {3, 4}</>
Received: <r>Set {1, 2}</>

Number of returns: <r>1</>
]=]

snapshots['toHaveLastReturnedWith works with argument that does match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>"foo"</>

Number of returns: <r>1</>
]=]

snapshots['toHaveLastReturnedWith works with argument that does not match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"bar"</>
Received: <r>"foo"</>

Number of returns: <r>1</>
]=]

snapshots['toHaveLastReturnedWith works with undefined 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveLastReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>nil</>

Number of returns: <r>1</>
]=]

snapshots['toHaveNthReturnedWith a call that throws is not considered to have returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

snapshots['toHaveNthReturnedWith a call that throws undefined is not considered to have returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

snapshots['toHaveNthReturnedWith includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

snapshots['toHaveNthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>6</>
Received
->     1: function call has not returned yet
       2: function call has not returned yet

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

snapshots['toHaveNthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 2
Expected: <g>3</>
Received
       1: function call has not returned yet
->     2: function call has not returned yet
       3: <r>1</>

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

snapshots['toHaveNthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 3'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 3
Expected: never <g>1</>
Received
       2:       function call has not returned yet
->     3:       <d>1</>
       4:       <r>0</>

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

snapshots['toHaveNthReturnedWith nthReturnedWith incomplete recursive calls are handled properly 4'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 4
Expected: never <g>0</>
Received
       3:       <r>1</>
->     4:       <d>0</>

Number of returns: <r>2</>
Number of calls:   <r>4</>
]=]

snapshots['toHaveNthReturnedWith nthReturnedWith negative throw matcher error for n that is not number 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has value: nil
]=]

snapshots['toHaveNthReturnedWith nthReturnedWith positive throw matcher error for n that is not integer 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0.1
]=]

snapshots['toHaveNthReturnedWith nthReturnedWith positive throw matcher error for n that is not positive integer 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: n must be a positive integer

n has type:  number
n has value: 0
]=]

snapshots['toHaveNthReturnedWith nthReturnedWith should reject nth value greater than number of calls 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 4
Expected: <g>"foo"</>
Received
       3: <d>"foo"</>

Number of returns: <r>3</>
]=]

snapshots['toHaveNthReturnedWith nthReturnedWith should replace 1st, 2nd, 3rd with first, second, third 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"bar1"</>
Received
->     1: <r>"foo1"</>
       2: <r>"foo2"</>

Number of returns: <r>3</>
]=]

snapshots['toHaveNthReturnedWith nthReturnedWith should replace 1st, 2nd, 3rd with first, second, third 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>"foo1"</>
Received
->     1:       <d>"foo1"</>
       2:       <r>"foo2"</>

Number of returns: <r>3</>
]=]

snapshots['toHaveNthReturnedWith nthReturnedWith works with three calls 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>"foo1"</>
Received
->     1:       <d>"foo1"</>
       2:       <r>"foo2"</>

Number of returns: <r>3</>
]=]

snapshots['toHaveNthReturnedWith works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['toHaveNthReturnedWith works when not called 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

snapshots['toHaveNthReturnedWith works with Immutable.js objects directly created 1'] = [=[

expect(jest.fn()).never.toHaveNthReturnedWith(n, expected)

n: 1
Expected: never Immutable.Map {"a": {"b": "c"}}

Number of returns: 1
]=]

snapshots['toHaveNthReturnedWith works with Immutable.js objects indirectly created 1'] = [=[

expect(jest.fn()).never.toHaveNthReturnedWith(n, expected)

n: 1
Expected: never Immutable.Map {"a": {"b": "c"}}

Number of returns: 1
]=]

snapshots['toHaveNthReturnedWith works with Map 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

snapshots['toHaveNthReturnedWith works with Map 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>{{"a", "b"}, {"b", "a"}}</>
Received: <r>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

-- deviation: changed not to never
snapshots['toHaveNthReturnedWith works with Set 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>Set {1, 2}</>

Number of returns: <r>1</>
]=]

snapshots['toHaveNthReturnedWith works with Set 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>Set {3, 4}</>
Received: <r>Set {1, 2}</>

Number of returns: <r>1</>
]=]

snapshots['toHaveNthReturnedWith works with argument that does match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>"foo"</>

Number of returns: <r>1</>
]=]

snapshots['toHaveNthReturnedWith works with argument that does not match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: <g>"bar"</>
Received: <r>"foo"</>

Number of returns: <r>1</>
]=]

snapshots['toHaveNthReturnedWith works with undefined 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveNthReturnedWith<d>(</>n<d>, </><g>expected</><d>)</>

n: 1
Expected: never <g>nil</>

Number of returns: <r>1</>
]=]

snapshots['toHaveReturned .not fails with any argument passed 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveReturned<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

snapshots['toHaveReturned .not passes when a call throws undefined 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturned<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
Received number of calls:      <r>1</>
]=]

snapshots['toHaveReturned .not passes when all calls throw 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturned<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
Received number of calls:      <r>2</>
]=]

snapshots['toHaveReturned .not passes when not returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturned<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
]=]

snapshots['toHaveReturned .not works only on jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveReturned<d>()</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['toHaveReturned fails with any argument passed 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveReturned<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

snapshots['toHaveReturned includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toHaveReturned<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>1</>

1: <r>42</>
]=]

snapshots['toHaveReturned incomplete recursive calls are handled properly 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturned<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
Received number of calls:      <r>4</>
]=]

snapshots['toHaveReturned passes when at least one call does not throw 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturned<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>2</>

1: <r>42</>
3: <r>42</>

Received number of calls:   <r>3</>
]=]

snapshots['toHaveReturned passes when returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturned<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>1</>

1: <r>42</>
]=]

snapshots['toHaveReturned passes when undefined is returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturned<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>1</>

1: <r>nil</>
]=]

-- deviation: this snapshot is heavily changed
snapshots['toHaveReturned throw matcher error if received is spy 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveReturned<d>()</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  table
Received has value: <r>{"calls": {"all": [Function anonymous], "count": [Function anonymous]}}</>
]=]

snapshots['toHaveReturnedTimes .not only accepts a number argument 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

-- snapshots['toHaveReturnedTimes .not only accepts a number argument 2'] = [=[

-- expect(received).never.toHaveReturnedTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  array
-- Expected has value: []]=]

snapshots['toHaveReturnedTimes .not only accepts a number argument 2'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

snapshots['toHaveReturnedTimes .not only accepts a number argument 3'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

-- snapshots['toHaveReturnedTimes .not only accepts a number argument 5'] = [=[

-- expect(received).never.toHaveReturnedTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  map
-- Expected has value: Map {}]=]

snapshots['toHaveReturnedTimes .not only accepts a number argument 4'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

snapshots['toHaveReturnedTimes .not passes if function called less than expected times 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>2</>
Received number of returns: <r>1</>
]=]

snapshots['toHaveReturnedTimes .not passes if function returned more than expected times 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>2</>
Received number of returns: <r>3</>
]=]

snapshots['toHaveReturnedTimes calls that return undefined are counted as returns 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>
]=]

snapshots['toHaveReturnedTimes calls that throw are not counted 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>3</>
Received number of returns: <r>2</>
Received number of calls:   <r>3</>
]=]

snapshots['toHaveReturnedTimes calls that throw undefined are not counted 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>

Received number of calls:         <r>3</>
]=]

snapshots['toHaveReturnedTimes includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>1</>
Received number of returns: <r>2</>
]=]

snapshots['toHaveReturnedTimes incomplete recursive calls are handled properly 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>

Received number of calls:         <r>4</>
]=]

snapshots['toHaveReturnedTimes only accepts a number argument 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

-- snapshots['toHaveReturnedTimes only accepts a number argument 2'] = [=[

-- expect(received).toHaveReturnedTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  array
-- Expected has value: []]=]

snapshots['toHaveReturnedTimes only accepts a number argument 2'] = [=[

<d>expect(</><r>received</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

snapshots['toHaveReturnedTimes only accepts a number argument 3'] = [=[

<d>expect(</><r>received</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

-- snapshots['toHaveReturnedTimes only accepts a number argument 5'] = [=[

-- expect(received).toHaveReturnedTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  map
-- Expected has value: Map {}]=]

snapshots['toHaveReturnedTimes only accepts a number argument 4'] = [=[

<d>expect(</><r>received</><d>).</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

snapshots['toHaveReturnedTimes passes if function returned equal to expected times 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>
]=]

-- deviation: this snapshot is heavily changed
snapshots['toHaveReturnedTimes throw matcher error if received is spy 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toHaveReturnedTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  table
Received has value: <r>{"calls": {"all": [Function anonymous], "count": [Function anonymous]}}</>
]=]

snapshots['toHaveReturnedWith a call that throws is not considered to have returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

snapshots['toHaveReturnedWith a call that throws undefined is not considered to have returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

snapshots['toHaveReturnedWith includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

snapshots['toHaveReturnedWith returnedWith incomplete recursive calls are handled properly 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received
       1: function call has not returned yet
       2: function call has not returned yet
       3: function call has not returned yet

Number of returns: <r>0</>
Number of calls:   <r>4</>
]=]

snapshots['toHaveReturnedWith returnedWith works with more calls than the limit 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"bar"</>
Received
       1: <r>"foo1"</>
       2: <r>"foo2"</>
       3: <r>"foo3"</>

Number of returns: <r>6</>
]=]

snapshots['toHaveReturnedWith works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['toHaveReturnedWith works when not called 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

snapshots['toHaveReturnedWith works with Immutable.js objects directly created 1'] = [=[

expect(jest.fn()).never.toHaveReturnedWith(expected)

Expected: never Immutable.Map {"a": {"b": "c"}}

Number of returns: 1
]=]

snapshots['toHaveReturnedWith works with Immutable.js objects indirectly created 1'] = [=[

expect(jest.fn()).never.toHaveReturnedWith(expected)

Expected: never Immutable.Map {"a": {"b": "c"}}

Number of returns: 1
]=]

snapshots['toHaveReturnedWith works with Map 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

snapshots['toHaveReturnedWith works with Map 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>{{"a", "b"}, {"b", "a"}}</>
Received: <r>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

snapshots['toHaveReturnedWith works with Set 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of returns: <r>1</>
]=]

snapshots['toHaveReturnedWith works with Set 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>Set {3, 4}</>
Received: <r>Set {1, 2}</>

Number of returns: <r>1</>
]=]

snapshots['toHaveReturnedWith works with argument that does match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>"foo"</>

Number of returns: <r>1</>
]=]

snapshots['toHaveReturnedWith works with argument that does not match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: <g>"bar"</>
Received: <r>"foo"</>

Number of returns: <r>1</>
]=]

snapshots['toHaveReturnedWith works with undefined 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toHaveReturnedWith<d>(</><g>expected</><d>)</>

Expected: never <g>nil</>

Number of returns: <r>1</>
]=]

snapshots['toReturn .not fails with any argument passed 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toReturn<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

snapshots['toReturn .not passes when a call throws undefined 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturn<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
Received number of calls:      <r>1</>
]=]

snapshots['toReturn .not passes when all calls throw 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturn<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
Received number of calls:      <r>2</>
]=]

snapshots['toReturn .not passes when not returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturn<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
]=]

snapshots['toReturn .not works only on jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toReturn<d>()</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['toReturn fails with any argument passed 1'] = [=[

<d>expect(</><r>received</><d>).</>toReturn<d>()</>

<b>Matcher error</>: this matcher must not have an expected argument

Expected has type:  number
Expected has value: <g>555</>
]=]

snapshots['toReturn includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>never<d>.</>toReturn<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>1</>

1: <r>42</>
]=]

snapshots['toReturn incomplete recursive calls are handled properly 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturn<d>()</>

Expected number of returns: >= <g>1</>
Received number of returns:    <r>0</>
Received number of calls:      <r>4</>
]=]

snapshots['toReturn passes when at least one call does not throw 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturn<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>2</>

1: <r>42</>
3: <r>42</>

Received number of calls:   <r>3</>
]=]

snapshots['toReturn passes when returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturn<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>1</>

1: <r>42</>
]=]

snapshots['toReturn passes when undefined is returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturn<d>()</>

Expected number of returns: <g>0</>
Received number of returns: <r>1</>

1: <r>nil</>
]=]

-- deviation: this snapshot is heavily changed
snapshots['toReturn throw matcher error if received is spy 1'] = [=[

<d>expect(</><r>received</><d>).</>toReturn<d>()</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  table
Received has value: <r>{"calls": {"all": [Function anonymous], "count": [Function anonymous]}}</>
]=]

snapshots['toReturnTimes .not only accepts a number argument 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

-- snapshots['toReturnTimes .not only accepts a number argument 2'] = [=[

-- expect(received).never.toReturnTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  array
-- Expected has value: []]=]

snapshots['toReturnTimes .not only accepts a number argument 2'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

snapshots['toReturnTimes .not only accepts a number argument 3'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

-- snapshots['toReturnTimes .not only accepts a number argument 5'] = [=[

-- expect(received).never.toReturnTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  map
-- Expected has value: Map {}]=]

snapshots['toReturnTimes .not only accepts a number argument 4'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

snapshots['toReturnTimes .not passes if function called less than expected times 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>2</>
Received number of returns: <r>1</>
]=]

snapshots['toReturnTimes .not passes if function returned more than expected times 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>2</>
Received number of returns: <r>3</>
]=]

snapshots['toReturnTimes calls that return undefined are counted as returns 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>
]=]

snapshots['toReturnTimes calls that throw are not counted 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>3</>
Received number of returns: <r>2</>
Received number of calls:   <r>3</>
]=]

snapshots['toReturnTimes calls that throw undefined are not counted 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>

Received number of calls:         <r>3</>
]=]

snapshots['toReturnTimes includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: <g>1</>
Received number of returns: <r>2</>
]=]

snapshots['toReturnTimes incomplete recursive calls are handled properly 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>

Received number of calls:         <r>4</>
]=]

snapshots['toReturnTimes only accepts a number argument 1'] = [=[

<d>expect(</><r>received</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  table
Expected has value: <g>{}</>
]=]

-- snapshots['toReturnTimes only accepts a number argument 2'] = [=[

-- expect(received).toReturnTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  array
-- Expected has value: []]=]

snapshots['toReturnTimes only accepts a number argument 2'] = [=[

<d>expect(</><r>received</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  boolean
Expected has value: <g>true</>
]=]

snapshots['toReturnTimes only accepts a number argument 3'] = [=[

<d>expect(</><r>received</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  string
Expected has value: <g>"a"</>
]=]

-- snapshots['toReturnTimes only accepts a number argument 5'] = [=[

-- expect(received).toReturnTimes(expected)

-- Matcher error: expected value must be a non-negative integer

-- Expected has type:  map
-- Expected has value: Map {}]=]

snapshots['toReturnTimes only accepts a number argument 4'] = [=[

<d>expect(</><r>received</><d>).</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a non-negative integer

Expected has type:  function
Expected has value: <g>[Function anonymous]</>
]=]

snapshots['toReturnTimes passes if function returned equal to expected times 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

Expected number of returns: never <g>2</>
]=]

-- deviation: this snapshot is heavily changed
snapshots['toReturnTimes throw matcher error if received is spy 1'] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toReturnTimes<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  table
Received has value: <r>{"calls": {"all": [Function anonymous], "count": [Function anonymous]}}</>
]=]

snapshots['toReturnWith a call that throws is not considered to have returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

snapshots['toReturnWith a call that throws undefined is not considered to have returned 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received: function call threw an error

Number of returns: <r>0</>
Number of calls:   <r>1</>
]=]

snapshots['toReturnWith includes the custom mock name in the error message 1'] = [=[

<d>expect(</><r>named-mock</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

snapshots['toReturnWith returnedWith incomplete recursive calls are handled properly 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>nil</>
Received
       1: function call has not returned yet
       2: function call has not returned yet
       3: function call has not returned yet

Number of returns: <r>0</>
Number of calls:   <r>4</>
]=]

snapshots['toReturnWith returnedWith works with more calls than the limit 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>"bar"</>
Received
       1: <r>"foo1"</>
       2: <r>"foo2"</>
       3: <r>"foo3"</>

Number of returns: <r>6</>
]=]

snapshots['toReturnWith works only on spies or jest.fn 1'] = [=[

<d>expect(</><r>received</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <r>received</> value must be a mock function

Received has type:  function
Received has value: <r>[Function fn]</>
]=]

snapshots['toReturnWith works when not called 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>"foo"</>

Number of returns: <r>0</>
]=]

snapshots['toReturnWith works with Immutable.js objects directly created 1'] = [=[

expect(jest.fn()).never.toReturnWith(expected)

Expected: never Immutable.Map {"a": {"b": "c"}}

Number of returns: 1
]=]

snapshots['toReturnWith works with Immutable.js objects indirectly created 1'] = [=[

expect(jest.fn()).never.toReturnWith(expected)

Expected: never Immutable.Map {"a": {"b": "c"}}

Number of returns: 1
]=]

snapshots['toReturnWith works with Map 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: never <g>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]

snapshots['toReturnWith works with Map 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>{{"a", "b"}, {"b", "a"}}</>
Received: <r>{{1, 2}, {2, 1}}</>

Number of returns: <r>1</>
]=]
snapshots['toReturnWith works with Set 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: never <g>Set {1, 2}</>

Number of returns: <r>1</>
]=]

snapshots['toReturnWith works with Set 2'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>Set {3, 4}</>
Received: <r>Set {1, 2}</>

Number of returns: <r>1</>
]=]

snapshots['toReturnWith works with argument that does match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: never <g>"foo"</>

Number of returns: <r>1</>
]=]

snapshots['toReturnWith works with argument that does not match 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: <g>"bar"</>
Received: <r>"foo"</>

Number of returns: <r>1</>
]=]

snapshots['toReturnWith works with undefined 1'] = [=[

<d>expect(</><r>jest.fn()</><d>).</>never<d>.</>toReturnWith<d>(</><g>expected</><d>)</>

Expected: never <g>nil</>

Number of returns: <r>1</>
]=]

return snapshots