-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/expect/src/__tests__/__snapshots__/extend.test.ts.snap

local snapshots = {}

snapshots['defines asymmetric unary matchers 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
-   "value": toBeDivisibleBy<2>,
+   "value": 3,
  }]=]

snapshots['defines asymmetric unary matchers that can be prefixed by never 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
-   "value": never.toBeDivisibleBy<2>,
+   "value": 2,
  }]=]

snapshots['defines asymmetric variadic matchers 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
-   "value": toBeWithinRange<4, 11>,
+   "value": 3,
  }]=]

snapshots['defines asymmetric variadic matchers that can be prefixed by never 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
-   "value": never.toBeWithinRange<1, 3>,
+   "value": 2,
  }]=]

snapshots['is available globally when matcher is unary 1'] = "expected 15 to be divisible by 2"

snapshots['is available globally when matcher is variadic 1'] = "expected 15 to be within range 1 - 3"

snapshots['is ok if there is no message specified 1'] = "No message was specified for this matcher."

snapshots['prints the Symbol into the error message 1'] = [=[
expect(received).toEqual(expected) // deep equality

- Expected  - 1
+ Received  + 1

  Table {
-   "a": toBeSymbol<Symbol(bar)>,
+   "a": Symbol(foo),
  }]=]

return snapshots