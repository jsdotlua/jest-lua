# jest-fake-timers

Upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-fake-timers

This package contains the fake timers implementation for Jest. It can be activated by calling `jest.useFakeTimers()`. You can find its documentation in the [Jest documentation](https://roblox.github.io/jest-roblox-internal).

The following timers are mocked:
* `delay`
* `tick`
* `time`
* `os`
    * `os.time`
	* `os.clock`
* `task.delay`
    * `task.delay`
	* `task.cancel`
	* `task.wait`
* `DateTime`

---

### :pencil2: Notes
:exclamation: The fake timer API in Jest Lua is aligned with the "modern" fake timer implementation in Jest. However, the actual implementation of fake timers in Jest Lua under the hood massively deviates from upstream so that it works natively with the Roblox ecosystem.

Similar to how Jest fake timers work by mocking the native timer functions (i.e. `setTimeout`, `setInterval`, `clearTimeout`, `clearInterval`) and `Date`, Jest Lua fake timers work by mocking the native timer functions in Roblox (i.e. `delay`, `tick`), the Roblox `DateTime` and the Lua native timer methods `os.time` and `os.clock`.
Additionally, Jest Lua fake timers support a configurable engine frame time. By default, the engine frame time is 0 (i.e. continuous time), but if set, Jest Lua fake timers will be processed by multiples of frame time. If engine frame time is set, then timers will be processed in the first frame after they are triggered.
