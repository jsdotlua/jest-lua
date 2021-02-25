-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/expect/src/__tests__/__snapshots__/toThrowMatchers.test.ts.snap

-- deviation: We don't print 'Thrown value:' or 'Received value:' for strings
-- we print 'Received message:' since the treatment of
-- string errors is the same as Error polyfill errors for us

local snapshots = {}

snapshots['toThrow asymmetric any-Class fail isNot false 1'] = [=[
expect(received).toThrow(expected)

Expected asymmetric matcher: Any<Err2>

Received name:    "Error"
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrow asymmetric any-Class fail isNot true 1'] = [=[
expect(received).never.toThrow(expected)

Expected asymmetric matcher: never Any<Err>

Received name:    "Error"
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrow asymmetric anything fail isNot true 1'] = [=[
expect(received).never.toThrow(expected)

Expected asymmetric matcher: never Anything

Received name:    "Error"
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

-- deviation: output has anonymous instead of asymmetricMatch
snapshots['toThrow asymmetric no-symbol fail isNot false 1'] = [=[
expect(received).toThrow(expected)

Expected asymmetric matcher: {"asymmetricMatch": [Function anonymous]}

Received name:    "Error"
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

-- deviation: output has anonymous instead of asymmetricMatch
snapshots['toThrow asymmetric no-symbol fail isNot true 1'] = [=[
expect(received).never.toThrow(expected)

Expected asymmetric matcher: never {"asymmetricMatch": [Function anonymous]}

Received name:    "Error"
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrow asymmetric objectContaining fail isNot false 1'] = [=[
expect(received).toThrow(expected)

Expected asymmetric matcher: ObjectContaining {"name": "NotError"}

Received name:    "Error"
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrow asymmetric objectContaining fail isNot true 1'] = [=[
expect(received).never.toThrow(expected)

Expected asymmetric matcher: never ObjectContaining {"name": "Error"}

Received name:    "Error"
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrow error class did not throw at all 1'] = [=[
expect(received).toThrow(expected)

Expected constructor: Err

Received function never threw]=]

snapshots['toThrow error class threw, but class did not match (error) 1'] = [=[
expect(received).toThrow(expected)

Expected constructor: Err2
Received constructor: Err

Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrow error class threw, but class did not match (non-error falsey) 1'] = [=[
expect(received).toThrow(expected)

Expected constructor: Err2

Received value: "nil"
]=]

-- deviation: changed from SubErr extends Err to SubErr
snapshots['toThrow error class threw, but class should not match (error subclass) 1'] = [=[
expect(received).never.toThrow(expected)

Expected constructor: never Err
Received constructor:       SubErr

Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

-- deviation: changed from SubErr extends .. extends Err to SubErr
snapshots['toThrow error class threw, but class should not match (error subsubclass) 1'] = [=[
expect(received).never.toThrow(expected)

Expected constructor: never Err
Received constructor:       SubSubErr

Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrow error class threw, but class should not match (error) 1'] = [=[
expect(received).never.toThrow(expected)

Expected constructor: never Err

Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrow error-message fail isNot false 1'] = [=[
expect(received).toThrow(expected)

Expected message: "apple"
Received message: "banana"
]=]

snapshots['toThrow error-message fail isNot true 1'] = [=[
expect(received).never.toThrow(expected)

Expected message: never "Invalid array length"
]=]

snapshots['toThrow error-message fail multiline diff highlight incorrect expected space 1'] = [=[
expect(received).toThrow(expected)

- Expected message  - 1
+ Received message  + 1

- There is no route defined for key Settings. 
+ There is no route defined for key Settings.
  Must be one of: 'Home'
]=]

snapshots['toThrow expected is undefined threw, but should not have (non-error falsey) 1'] = [=[
expect(received).never.toThrow()

Thrown value: "nil"
]=]

snapshots['toThrow invalid actual 1'] = [=[
expect(received).toThrow()

Matcher error: received value must be a function

Received has type:  string
Received has value: "a string"]=]

snapshots['toThrow invalid arguments 1'] = [=[
expect(received).never.toThrow(expected)

Matcher error: expected value must be a string or regular expression or class or error

Expected has type:  number
Expected has value: 111]=]

snapshots['toThrow regexp did not throw at all 1'] = [=[
expect(received).toThrow(expected)

Expected pattern: /apple/

Received function never threw]=]

snapshots['toThrow regexp threw, but message did not match (error) 1'] = [=[
expect(received).toThrow(expected)

Expected pattern: /banana/
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

-- deviation: we print "0" instead of 0
snapshots['toThrow regexp threw, but message did not match (non-error falsey) 1'] = [=[
expect(received).toThrow(expected)

Expected pattern: /^[123456789]\d*/
Received value:   "0"
]=]

snapshots['toThrow regexp threw, but message should not match (error) 1'] = [=[
expect(received).never.toThrow(expected)

Expected pattern: never / array /
Received message:       "Invalid array length"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

-- deviation: we print "404" instead of 404
snapshots['toThrow regexp threw, but message should not match (non-error truthy) 1'] = [=[
expect(received).never.toThrow(expected)

Expected pattern: never /^[123456789]\d*/
Received value:         "404"
]=]

snapshots['toThrow substring did not throw at all 1'] = [=[
expect(received).toThrow(expected)

Expected substring: "apple"

Received function never threw]=]

snapshots['toThrow substring threw, but message did not match (error) 1'] = [=[
expect(received).toThrow(expected)

Expected substring: "banana"
Received message:   "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrow substring threw, but message did not match (non-error falsey) 1'] = [=[
expect(received).toThrow(expected)

Expected substring: "Server Error"
Received value:     ""
]=]

snapshots['toThrow substring threw, but message should not match (error) 1'] = [=[
expect(received).never.toThrow(expected)

Expected substring: never "array"
Received message:         "Invalid array length"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrow substring threw, but message should not match (non-error truthy) 1'] = [=[
expect(received).never.toThrow(expected)

Expected substring: never "Server Error"
Received value:           "Internal Server Error"
]=]

snapshots['toThrowError asymmetric any-Class fail isNot false 1'] = [=[
expect(received).toThrowError(expected)

Expected asymmetric matcher: Any<Err2>

Received name:    "Error"
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrowError asymmetric any-Class fail isNot true 1'] = [=[
expect(received).never.toThrowError(expected)

Expected asymmetric matcher: never Any<Err>

Received name:    "Error"
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrowError asymmetric anything fail isNot true 1'] = [=[
expect(received).never.toThrowError(expected)

Expected asymmetric matcher: never Anything

Received name:    "Error"
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

-- deviation: output has anonymous instead of asymmetricMatch
snapshots['toThrowError asymmetric no-symbol fail isNot false 1'] = [=[
expect(received).toThrowError(expected)

Expected asymmetric matcher: {"asymmetricMatch": [Function anonymous]}

Received name:    "Error"
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

-- deviation: output has anonymous instead of asymmetricMatch
snapshots['toThrowError asymmetric no-symbol fail isNot true 1'] = [=[
expect(received).never.toThrowError(expected)

Expected asymmetric matcher: never {"asymmetricMatch": [Function anonymous]}

Received name:    "Error"
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrowError asymmetric objectContaining fail isNot false 1'] = [=[
expect(received).toThrowError(expected)

Expected asymmetric matcher: ObjectContaining {"name": "NotError"}

Received name:    "Error"
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrowError asymmetric objectContaining fail isNot true 1'] = [=[
expect(received).never.toThrowError(expected)

Expected asymmetric matcher: never ObjectContaining {"name": "Error"}

Received name:    "Error"
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrowError error class did not throw at all 1'] = [=[
expect(received).toThrowError(expected)

Expected constructor: Err

Received function never threw]=]

snapshots['toThrowError error class threw, but class did not match (error) 1'] = [=[
expect(received).toThrowError(expected)

Expected constructor: Err2
Received constructor: Err

Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrowError error class threw, but class did not match (non-error falsey) 1'] = [=[
expect(received).toThrowError(expected)

Expected constructor: Err2

Received value: "nil"
]=]

-- deviation: changed from SubErr extends Err to SubErr
snapshots['toThrowError error class threw, but class should not match (error subclass) 1'] = [=[
expect(received).never.toThrowError(expected)

Expected constructor: never Err
Received constructor:       SubErr

Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

-- deviation: changed from SubErr extends .. extends Err to SubErr
snapshots['toThrowError error class threw, but class should not match (error subsubclass) 1'] = [=[
expect(received).never.toThrowError(expected)

Expected constructor: never Err
Received constructor:       SubSubErr

Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrowError error class threw, but class should not match (error) 1'] = [=[
expect(received).never.toThrowError(expected)

Expected constructor: never Err

Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrowError error-message fail isNot false 1'] = [=[
expect(received).toThrowError(expected)

Expected message: "apple"
Received message: "banana"
]=]

snapshots['toThrowError error-message fail isNot true 1'] = [=[
expect(received).never.toThrowError(expected)

Expected message: never "Invalid array length"
]=]

snapshots['toThrowError error-message fail multiline diff highlight incorrect expected space 1'] = [=[
expect(received).toThrowError(expected)

- Expected message  - 1
+ Received message  + 1

- There is no route defined for key Settings. 
+ There is no route defined for key Settings.
  Must be one of: 'Home'
]=]

snapshots['toThrowError expected is undefined threw, but should not have (non-error falsey) 1'] = [=[
expect(received).never.toThrowError()

Thrown value: "nil"
]=]

snapshots['toThrowError invalid actual 1'] = [=[
expect(received).toThrowError()

Matcher error: received value must be a function

Received has type:  string
Received has value: "a string"]=]

snapshots['toThrowError invalid arguments 1'] = [=[
expect(received).never.toThrowError(expected)

Matcher error: expected value must be a string or regular expression or class or error

Expected has type:  number
Expected has value: 111]=]

snapshots['toThrowError regexp did not throw at all 1'] = [=[
expect(received).toThrowError(expected)

Expected pattern: /apple/

Received function never threw]=]

snapshots['toThrowError regexp threw, but message did not match (error) 1'] = [=[
expect(received).toThrowError(expected)

Expected pattern: /banana/
Received message: "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

-- deviation: we print "0" instead of 0
snapshots['toThrowError regexp threw, but message did not match (non-error falsey) 1'] = [=[
expect(received).toThrowError(expected)

Expected pattern: /^[123456789]\d*/
Received value:   "0"
]=]

snapshots['toThrowError regexp threw, but message should not match (error) 1'] = [=[
expect(received).never.toThrowError(expected)

Expected pattern: never / array /
Received message:       "Invalid array length"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

-- deviation: we print "404" instead of 404
snapshots['toThrowError regexp threw, but message should not match (non-error truthy) 1'] = [=[
expect(received).never.toThrowError(expected)

Expected pattern: never /^[123456789]\d*/
Received value:         "404"
]=]

snapshots['toThrowError substring did not throw at all 1'] = [=[
expect(received).toThrowError(expected)

Expected substring: "apple"

Received function never threw]=]

snapshots['toThrowError substring threw, but message did not match (error) 1'] = [=[
expect(received).toThrowError(expected)

Expected substring: "banana"
Received message:   "apple"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrowError substring threw, but message did not match (non-error falsey) 1'] = [=[
expect(received).toThrowError(expected)

Expected substring: "Server Error"
Received value:     ""
]=]

snapshots['toThrowError substring threw, but message should not match (error) 1'] = [=[
expect(received).never.toThrowError(expected)

Expected substring: never "array"
Received message:         "Invalid array length"

      at jestExpect (packages/expect/src/__tests__/toThrowMatchers-test.js:24:74)]=]

snapshots['toThrowError substring threw, but message should not match (non-error truthy) 1'] = [=[
expect(received).never.toThrowError(expected)

Expected substring: never "Server Error"
Received value:           "Internal Server Error"
]=]

snapshots['Lua tests correctly prints the stack trace for Lua Error error 1'] = [=[
expect(received).never.toThrow()

Error name:    "Error"
Error message: ""]=]

snapshots['Lua tests correctly prints the stack trace for Lua string error 1'] = [=[
expect(received).never.toThrow()

Thrown value: ""]=]

snapshots['Lua tests correctly prints the stack trace for Lua string error 2'] = [=[
expect(received).toThrow(expected)

Expected substring: "wrong information"
Received value:     ""]=]
return snapshots