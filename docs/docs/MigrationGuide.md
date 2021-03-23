---
id: migration-guide
title: Migrating to Jest Roblox
---

If you are using TestEZ, migrating over should be fairly straightforward. Many parts of Jest Roblox still use the TestEZ API and all the relevant parts are documented in the [TestEZ API doc](testez).

Replace TestEZ with JestRoblox in your `rotriever.toml`.
```diff title="rotriever.toml"
[dev_dependencies]
- TestEZ = "github.com/roblox/testez@0.4.1"
+ JestRoblox = "github.com/roblox/jest-roblox@1.0.0"
```

Unlike TestEZ, which is injected into the global environment, you will need to explicitly require anything you need from `JestRoblox.Globals`. For example, to use the new Jest Roblox assertion library, add this to the top of your test file.
```lua
local JestRoblox = require(Packages.JestRoblox).Globals
local expect = JestRoblox.expect
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
+ end).toThrow()
```