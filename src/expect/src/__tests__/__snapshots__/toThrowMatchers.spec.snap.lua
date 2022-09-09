-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/expect/src/__tests__/__snapshots__/toThrowMatchers.test.ts.snap

-- ROBLOX deviation: We don't print 'Thrown value:' or 'Received value:' for strings
-- we print 'Received message:' since the treatment of
-- string errors is the same as Error polyfill errors for us

-- ROBLOX deviation: For upstream snapshots that throw a primitive error, our version
-- of the snapshot has a stack trace included since our toThwoMatchers will
-- output a stack trace regardless of the kind of error thrown

local snapshots = {}

snapshots["toThrow asymmetric any-Class fail isNot false 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected asymmetric matcher: <g>Any<Err2></>

Received name:    <r>"Error"</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrow asymmetric any-Class fail isNot true 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>(</><g>expected</><d>)</>

Expected asymmetric matcher: never <g>Any<Err></>

Received name:    <r>"Error"</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrow asymmetric anything fail isNot true 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>(</><g>expected</><d>)</>

Expected asymmetric matcher: never <g>Anything</>

Received name:    <r>"Error"</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

-- ROBLOX deviation: output has anonymous instead of asymmetricMatch
snapshots["toThrow asymmetric no-symbol fail isNot false 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected asymmetric matcher: <g>{"asymmetricMatch": [Function asymmetricMatch]}</>

Received name:    <r>"Error"</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

-- ROBLOX deviation: output has anonymous instead of asymmetricMatch
snapshots["toThrow asymmetric no-symbol fail isNot true 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>(</><g>expected</><d>)</>

Expected asymmetric matcher: never <g>{"asymmetricMatch": [Function asymmetricMatch]}</>

Received name:    <r>"Error"</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrow asymmetric objectContaining fail isNot false 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected asymmetric matcher: <g>ObjectContaining {"name": "NotError"}</>

Received name:    <r>"Error"</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrow asymmetric objectContaining fail isNot true 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>(</><g>expected</><d>)</>

Expected asymmetric matcher: never <g>ObjectContaining {"name": "Error"}</>

Received name:    <r>"Error"</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrow error class did not throw at all 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected constructor: <g>Err</>

Received function never threw
]=]

snapshots["toThrow error class threw, but class did not match (error) 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected constructor: <g>Err2</>
Received constructor: <r>Err</>

Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrow error class threw, but class did not match (non-error falsey) 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected constructor: <g>Err2</>

Received value: <r>"nil"</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.spec:219
]=]

snapshots["toThrow error class threw, but class should not match (error subclass) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>(</><g>expected</><d>)</>

Expected constructor: never <g>Err</>
Received constructor:       <r>SubErr</> extends <g>Err</>

Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrow error class threw, but class should not match (error subsubclass) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>(</><g>expected</><d>)</>

Expected constructor: never <g>Err</>
Received constructor:       <r>SubSubErr</> extends … extends <g>Err</>

Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrow error class threw, but class should not match (error) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>(</><g>expected</><d>)</>

Expected constructor: never <g>Err</>

Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrow error-message fail isNot false 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected message: <g>"apple"</>
Received message: <r>"banana"</>

]=]

snapshots["toThrow error-message fail isNot true 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>(</><g>expected</><d>)</>

Expected message: never <g>"Invalid array length"</>

]=]

snapshots["toThrow error-message fail multiline diff highlight incorrect expected space 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

<g>- Expected message  - 1</>
<r>+ Received message  + 1</>

<g>- There is no route defined for key Settings.<i> </i></>
<r>+ There is no route defined for key Settings.</>
<d>  Must be one of: 'Home'</>

]=]

snapshots["toThrow expected is undefined threw, but should not have (non-error falsey) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>()</>

Thrown value: <r>"nil"</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.spec:486
]=]

snapshots["toThrow invalid actual 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>()</>

<b>Matcher error</>: <r>received</> value must be a function

Received has type:  string
Received has value: <r>"a string"</>
]=]

snapshots["toThrow invalid arguments 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a string or regular expression or class or error

Expected has type:  number
Expected has value: <g>111</>
]=]

snapshots["toThrow regexp did not throw at all 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected pattern: <g>/apple/</>

Received function never threw
]=]

snapshots["toThrow regexp threw, but message did not match (error) 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected pattern: <g>/banana/</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

-- ROBLOX deviation: we print "0" instead of 0
snapshots["toThrow regexp threw, but message did not match (non-error falsey) 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected pattern: <g>/^[123456789]\d*/</>
Received value:   <r>"0"</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.spec:152
]=]

snapshots["toThrow regexp threw, but message should not match (error) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>(</><g>expected</><d>)</>

Expected pattern: never <g>/ array /</>
Received message:       <r>"Invalid</><i> array </i><r>length</>"

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

-- ROBLOX deviation: we print "404" instead of 404
snapshots["toThrow regexp threw, but message should not match (non-error truthy) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>(</><g>expected</><d>)</>

Expected pattern: never <g>/^[123456789]\d*/</>
Received value:         <r>"404"</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.spec:170
]=]

snapshots["toThrow substring did not throw at all 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected substring: <g>"apple"</>

Received function never threw
]=]

snapshots["toThrow substring threw, but message did not match (error) 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected substring: <g>"banana"</>
Received message:   <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

-- ROBLOX deviation: we include the stack trace even when catching a "primitive" error()
snapshots["toThrow substring threw, but message did not match (non-error falsey) 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrow<d>(</><g>expected</><d>)</>

Expected substring: <g>"Server Error"</>
Received value:     <r>""</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.spec:92
]=]

snapshots["toThrow substring threw, but message should not match (error) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>(</><g>expected</><d>)</>

Expected substring: never <g>"array"</>
Received message:         <r>"Invalid </><i>array</i><r> length</>"

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrow substring threw, but message should not match (non-error truthy) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrow<d>(</><g>expected</><d>)</>

Expected substring: never <g>"Server Error"</>
Received value:           <r>"Internal Server Error"</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.spec:114
]=]

snapshots["toThrowError asymmetric any-Class fail isNot false 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowError<d>(</><g>expected</><d>)</>

Expected asymmetric matcher: <g>Any<Err2></>

Received name:    <r>"Error"</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrowError asymmetric any-Class fail isNot true 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrowError<d>(</><g>expected</><d>)</>

Expected asymmetric matcher: never <g>Any<Err></>

Received name:    <r>"Error"</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrowError asymmetric anything fail isNot true 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrowError<d>(</><g>expected</><d>)</>

Expected asymmetric matcher: never <g>Anything</>

Received name:    <r>"Error"</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

-- ROBLOX deviation: output has anonymous instead of asymmetricMatch
snapshots["toThrowError asymmetric no-symbol fail isNot false 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowError<d>(</><g>expected</><d>)</>

Expected asymmetric matcher: <g>{"asymmetricMatch": [Function asymmetricMatch]}</>

Received name:    <r>"Error"</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

-- ROBLOX deviation: output has anonymous instead of asymmetricMatch
snapshots["toThrowError asymmetric no-symbol fail isNot true 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrowError<d>(</><g>expected</><d>)</>

Expected asymmetric matcher: never <g>{"asymmetricMatch": [Function asymmetricMatch]}</>

Received name:    <r>"Error"</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrowError asymmetric objectContaining fail isNot false 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowError<d>(</><g>expected</><d>)</>

Expected asymmetric matcher: <g>ObjectContaining {"name": "NotError"}</>

Received name:    <r>"Error"</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrowError asymmetric objectContaining fail isNot true 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrowError<d>(</><g>expected</><d>)</>

Expected asymmetric matcher: never <g>ObjectContaining {"name": "Error"}</>

Received name:    <r>"Error"</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrowError error class did not throw at all 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowError<d>(</><g>expected</><d>)</>

Expected constructor: <g>Err</>

Received function never threw
]=]

snapshots["toThrowError error class threw, but class did not match (error) 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowError<d>(</><g>expected</><d>)</>

Expected constructor: <g>Err2</>
Received constructor: <r>Err</>

Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrowError error class threw, but class did not match (non-error falsey) 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowError<d>(</><g>expected</><d>)</>

Expected constructor: <g>Err2</>

Received value: <r>"nil"</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.spec:219
]=]

snapshots["toThrowError error class threw, but class should not match (error subclass) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrowError<d>(</><g>expected</><d>)</>

Expected constructor: never <g>Err</>
Received constructor:       <r>SubErr</> extends <g>Err</>

Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrowError error class threw, but class should not match (error subsubclass) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrowError<d>(</><g>expected</><d>)</>

Expected constructor: never <g>Err</>
Received constructor:       <r>SubSubErr</> extends … extends <g>Err</>

Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrowError error class threw, but class should not match (error) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrowError<d>(</><g>expected</><d>)</>

Expected constructor: never <g>Err</>

Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrowError error-message fail isNot false 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowError<d>(</><g>expected</><d>)</>

Expected message: <g>"apple"</>
Received message: <r>"banana"</>

]=]

snapshots["toThrowError error-message fail isNot true 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrowError<d>(</><g>expected</><d>)</>

Expected message: never <g>"Invalid array length"</>

]=]

snapshots["toThrowError error-message fail multiline diff highlight incorrect expected space 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowError<d>(</><g>expected</><d>)</>

<g>- Expected message  - 1</>
<r>+ Received message  + 1</>

<g>- There is no route defined for key Settings.<i> </i></>
<r>+ There is no route defined for key Settings.</>
<d>  Must be one of: 'Home'</>

]=]

snapshots["toThrowError expected is undefined threw, but should not have (non-error falsey) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrowError<d>()</>

Thrown value: <r>"nil"</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.spec:486
]=]

snapshots["toThrowError invalid actual 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowError<d>()</>

<b>Matcher error</>: <r>received</> value must be a function

Received has type:  string
Received has value: <r>"a string"</>
]=]

snapshots["toThrowError invalid arguments 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrowError<d>(</><g>expected</><d>)</>

<b>Matcher error</>: <g>expected</> value must be a string or regular expression or class or error

Expected has type:  number
Expected has value: <g>111</>
]=]

snapshots["toThrowError regexp did not throw at all 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowError<d>(</><g>expected</><d>)</>

Expected pattern: <g>/apple/</>

Received function never threw
]=]

snapshots["toThrowError regexp threw, but message did not match (error) 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowError<d>(</><g>expected</><d>)</>

Expected pattern: <g>/banana/</>
Received message: <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

-- ROBLOX deviation: we print "0" instead of 0
snapshots["toThrowError regexp threw, but message did not match (non-error falsey) 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowError<d>(</><g>expected</><d>)</>

Expected pattern: <g>/^[123456789]\d*/</>
Received value:   <r>"0"</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.spec:152
]=]

snapshots["toThrowError regexp threw, but message should not match (error) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrowError<d>(</><g>expected</><d>)</>

Expected pattern: never <g>/ array /</>
Received message:       <r>"Invalid</><i> array </i><r>length</>"

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

-- ROBLOX deviation: we print "404" instead of 404
snapshots["toThrowError regexp threw, but message should not match (non-error truthy) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrowError<d>(</><g>expected</><d>)</>

Expected pattern: never <g>/^[123456789]\d*/</>
Received value:         <r>"404"</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.spec:170
]=]

snapshots["toThrowError substring did not throw at all 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowError<d>(</><g>expected</><d>)</>

Expected substring: <g>"apple"</>

Received function never threw
]=]

snapshots["toThrowError substring threw, but message did not match (error) 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowError<d>(</><g>expected</><d>)</>

Expected substring: <g>"banana"</>
Received message:   <r>"apple"</>

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

-- ROBLOX deviation: we include the stack trace even when catching a "primitive" error()
snapshots["toThrowError substring threw, but message did not match (non-error falsey) 1"] = [=[

<d>expect(</><r>received</><d>).</>toThrowError<d>(</><g>expected</><d>)</>

Expected substring: <g>"Server Error"</>
Received value:     <r>""</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.spec:92
]=]

snapshots["toThrowError substring threw, but message should not match (error) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrowError<d>(</><g>expected</><d>)</>

Expected substring: never <g>"array"</>
Received message:         <r>"Invalid </><i>array</i><r> length</>"

      at expect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)
]=]

snapshots["toThrowError substring threw, but message should not match (non-error truthy) 1"] = [=[

<d>expect(</><r>received</><d>).</>never<d>.</>toThrowError<d>(</><g>expected</><d>)</>

Expected substring: never <g>"Server Error"</>
Received value:           <r>"Internal Server Error"</>

      LoadedCode.JestRoblox._Workspace.Expect.Expect.__tests__.toThrowMatchers.spec:114
]=]

return snapshots
