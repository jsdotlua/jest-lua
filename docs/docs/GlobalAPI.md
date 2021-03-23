---
id: api
title: Globals
---

At the top of your test files, require `JestRoblox` from the `Packages` directory created by `rotriever`.

Then, explicitly import any of the following methods from `Globals`:

```lua
local JestRoblox = require(Packages.JestRoblox).Globals
local expect = JestRoblox.expect
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