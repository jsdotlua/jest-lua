# jest-mock

Status: :hammer: In Progress

Source: https://github.com/facebook/jest/tree/v27.0.6/packages/jest-mock

Version: v27.0.6

---

### :pencil2: Notes
* As of right now, only a minimal set of functionality for jest-mock has been ported. The only externally facing functions that are supported are:
	* Creating an instance of the `ModuleMockerClass` via constructor (i.e. importing jest-mock and calling `.new()` on the import)
	* And then these functions are supported on an instance of the `ModuleMockerClass`:
		* `fn()` - create a function that can help in unit testing to confirm expectations on number of calls, returns, call arguments, etc. (currently this is mainly useful for the spyMatchers)
	    * `clearAllMocks()`
	    * `resetAllMocks()`
	    * `restoreAllMocks()`

### :x: Excluded
```
```

### :package: [Dependencies](https://github.com/facebook/jest/blob/v27.0.6/packages/jest-mock/package.json)
| Package | Version | Status | Notes |
| - | - | - | - |
| `@jest/types` | 27.0.6 | :x: Will not port | External type definitions are not a priority |