-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/expect/src/__tests__/__snapshots__/extend.test.ts.snap

local snapshots = {}

snapshots['defines asymmetric unary matchers 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "value": toBeDivisibleBy<2>,</>
<r>+   "value": 3,</>
<d>  }</>
]=]

snapshots['defines asymmetric unary matchers that can be prefixed by never 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "value": never.toBeDivisibleBy<2>,</>
<r>+   "value": 2,</>
<d>  }</>
]=]

snapshots['defines asymmetric variadic matchers 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "value": toBeWithinRange<4, 11>,</>
<r>+   "value": 3,</>
<d>  }</>
]=]

snapshots['defines asymmetric variadic matchers that can be prefixed by never 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "value": never.toBeWithinRange<1, 3>,</>
<r>+   "value": 2,</>
<d>  }</>
]=]

snapshots['is available globally when matcher is unary 1'] = "expected 15 to be divisible by 2"

snapshots['is available globally when matcher is variadic 1'] = "expected 15 to be within range 1 - 3"

snapshots['is ok if there is no message specified 1'] = "<r>No message was specified for this matcher.</>"

snapshots['prints the Symbol into the error message 1'] = [=[

<d>expect(</><r>received</><d>).</>toEqual<d>(</><g>expected</><d>) -- deep equality</>

<g>- Expected  - 1</>
<r>+ Received  + 1</>

<d>  Table {</>
<g>-   "a": toBeSymbol<Symbol(bar)>,</>
<r>+   "a": Symbol(foo),</>
<d>  }</>
]=]

return snapshots