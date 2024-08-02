# jest-each

Upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-each

A parameterized testing library for Jest. You can find its documentation in the [Jest documentation](https://roblox.github.io/jest-roblox-internal).

---

### :pencil2: Notes
* Deviations:
    * Tagged templates are not available in Lua. As an alternative, a headings string must be used with a list of arrays containing the same amount of items as headings.
    Example:
    ```lua
    each("a | b | expected",
        { 0, 0, 0 },
        { 0, 1, 1 },
        { 1, 1, 2 }
    ).it("returns $expected when given $a and $b",
        function(ref)
            local a: number, b: number, expected = ref.a, ref.b, ref.expected
            jestExpect(a + b).toBe(expected)
        end
    )
    ```
    * Use `NIL` provided constant instead of nil when passing values to each
    ```lua
    each("expected", { NIL }).it(
		"templates properly convert $expected to nil before running the tests",
		function(ref)
			jestExpect(ref.expected).toBe(nil)
		end
	)
    ```
    * TestEZ methods are supported (`*FOCUS`, `*SKIP`), however, these may be dropped at some point in favor of jest's callable objects(`it`, `it.only`, `it.skip`), which are supported too
