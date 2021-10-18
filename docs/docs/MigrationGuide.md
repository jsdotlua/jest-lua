---
id: migration-guide
title: Migrating to Jest Roblox
---

If you are using TestEZ, migrating over should be fairly straightforward. Many parts of Jest Roblox still use the TestEZ API and all the relevant parts are documented in the [TestEZ API doc](testez).

Replace TestEZ with `JestGlobals` in your `rotriever.toml`.
```diff title="rotriever.toml"
[dev_dependencies]
- TestEZ = "github.com/roblox/testez@0.4.1"
+ JestGlobals = "github.com/roblox/jest-roblox@2.1.0"
```

Unlike TestEZ, which is injected into the global environment, you will need to explicitly require anything you need from `JestGlobals`. For example, to use the new Jest Roblox assertion library, add this to the top of your test file.
```lua
local JestGlobals = require(Packages.JestGlobals)
local expect = JestGlobals.expect
```

Or if you're migrating tests in the `lua-apps` repo, require `JestGlobals` from `CorePackages` at the top of your test file:
```diff
local CorePackages = game:GetService("CorePackages")

local JestGlobals = require(CorePackages.JestGlobals)
local expect = JestGlobals.expect
```

:::info
Globals that are injected make life very difficult for languages with strong types — because there's no specific import, and the code artifact injecting the globals can change underneath hard-coded type signatures, it requires inefficient tooling and workarounds.

Additionally, upstream Jest also plans to remove injected globals and instead prefers that users import any needed functionality through the `@jest/globals` package.

Jest Roblox is staying ahead of that plan and not including support for injected globals.

Now that rotriever 0.5.0 allows users to import specific sub-packages, users can now specifically import `JestGlobals` and import any needed functionality from that package.

https://jestjs.io/blog/2020/05/05/jest-26#a-new-way-to-consume-jest---jestglobals
:::


If you were previously overwriting the Luau type for `expect` as a workaround for TestEZ custom expectations, you can remove it.
```diff
-local expect: any = expect
```

Then, replace the TestEZ `expect` syntax with their equivalents in Jest Roblox. The equivalent matchers for each TestEZ matcher are listed below.

The new Jest Roblox matchers are much more powerful than their TestEZ equivalents so see the [reference doc](expect) for more advanced usage, and also see all the new matchers Jest Roblox has to offer.

### `.to.equal(value)`

`.to.equal(value)` method does a strict equality check, which exists in Jest Roblox as `.toBe(value)`.
```diff
- expect(1).to.equal(1)
+ expect(1).toBe(1)
```

This is different from the `.toEqual` matcher in Jest Roblox, which does a recursive deep equality check. For example:
```lua
expect({a = 1}).to.equal({a = 1}) -- fails in TestEZ
expect({a = 1}).toBe({a = 1})     -- fails in Jest Roblox, but warns you
expect({a = 1}).toEqual({a = 1})  -- passes in Jest Roblox
```

### `.to.be.ok()`

`.to.be.ok()` is a `nil` check, which is `.never.toBeNil()` in Jest Roblox.
```diff
- expect(1).to.be.ok()
+ expect(1).never.toBeNil()
```

### `.to.be.near(value)`
`.to.be.near(value)` is used to compare floating point numbers for approximate equality. In Jest Roblox, it is `.toBeCloseTo(number, numDigits?)`.
```diff
- expect(0.1 + 0.2).to.be.near(0.3)
+ expect(0.1 + 0.2).toBeCloseTo(0.3)
```

### `.to.be.a(type)`
`.to.be.a(type)` is used to do type checking. Type checking in Jest Roblox is done using the `.toEqual()` matcher with `expect.any(type)`.
```diff
- expect(1).to.be.a("number")
+ expect(1).toEqual(expect.any("number"))
```

`expect.any()` is an asymmetric matcher, which can be used for much more than just checking primitive types like this. See the reference doc on [`expect.any()`](expect#expectanytypename--prototype).

### `.to.throw()`
`.to.throw()` can be replaced with `.toThrow()`
```diff
expect(function()
	error("nope")
- end).to.throw()
+ end).toThrow("nope")
```

A `.toThrow()` with no arguments will match against any exception, so it is recommended to match against a specific error message or use the [`Error`](expect#error) polyfill to throw and match against a specific exception. See the reference doc on [`.toThrow(error?)`](expect#tothrowerror).

### `.extend(matchers)`
`expect.extend` takes `self` (or `_` if the `matcherContext` isn't needed) as its first argument and the `message` property in the return value must be a function. See the reference doc on the [custom matcher API](expect#custom-matchers-api).
```diff
expect.extends({
-	customMatcher = function(arg)
+	customMatcher = function(_, arg)
		return {
			pass = true,
-			message = "message",
+			message = function() return "message" end
		}
	end
})
```