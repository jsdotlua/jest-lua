# jest-mock

Upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-mock

This package implements the various function and module mocking capabilities used by Jest. You can find its documentation in the [Jest documentation](https://roblox.github.io/jest-roblox-internal).

---

### :pencil2: Notes
* As of right now, only a minimal set of functionality for jest-mock has been ported. The only externally facing functions that are supported are:
	* Creating an instance of the `ModuleMockerClass` via constructor (i.e. importing jest-mock and calling `.new()` on the import)
	* And then these functions are supported on an instance of the `ModuleMockerClass`:
		* `fn()` - create a function that can help in unit testing to confirm expectations on number of calls, returns, call arguments, etc. (currently this is mainly useful for the spyMatchers)
	    * `clearAllMocks()`
	    * `resetAllMocks()`
	    * `restoreAllMocks()`
