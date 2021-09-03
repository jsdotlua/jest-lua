---
id: api
title: Globals
---

At the top of your test files, require `JestGlobals` from the `Packages` directory created by `rotriever`.

Then, explicitly import any of the following members:

```lua
local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
```

## Methods

import TOCInline from "@theme/TOCInline";

<TOCInline toc={
	toc[toc.length - 1].children
}/>

---

## Reference

### `expect(value)`
The `expect` function is used every time you want to test a value. See the [`expect` API doc](expect).

### `jest`
Returns the [Jest Object](jest-object).

### `jestSnapshot`
Returns the snapshot matchers `toMatchSnapshot` and `toThrowErrorMatchingSnapshot` for use in [custom snapshot matchers](expect#custom-snapshot-matchers).

### `TestEZ`
Returns TestEZ for use as the test runner when bootstrapping a project and for projects that may want to directly access TestEZ for legacy reasons.