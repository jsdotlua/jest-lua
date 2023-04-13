# jest-fake-timers

Status: :hammer: In Progress

Source: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-fake-timers

Version: v27.4.7

---

### :pencil2: Notes
:exclamation: The fake timer API in Jest Roblox is aligned with the "modern" fake timer implementation in Jest. However, the actual implementation of fake timers in Jest Roblox under the hood massively deviates from upstream so that it works natively with the Roblox ecosystem.

Similar to how Jest fake timers work by mocking the native timer functions (i.e. `setTimeout`, `setInterval`, `clearTimeout`, `clearInterval`) and `Date`, Jest Roblox fake timers work by mocking the native timer functions in Roblox (i.e. `delay`, `tick`), the Roblox `DateTime` and the Lua native timer methods `os.time` and `os.clock`.
Additionally, Jest Roblox fake timers support a configurable engine frame time. By default, the engine frame time is 0 (i.e. continuous time), but if set, Jest Roblox fake timers will be processed by multiples of frame time. If engine frame time is set, then timers will be processed in the first frame after they are triggered.

### :x: Excluded
```
src/legacyFakeTimers.ts
__tests__/legacyFakeTimers.test.ts
__tests__/__snapshots__/legacyFakeTimers.test.ts.snap
```

### :package: [Dependencies](https://github.com/facebook/jest/blob/v27.4.7/packages/jest-fake-timers/package.json)
| Package              | Version | Status                    | Notes |
| -------------------- | ------- | ------------------------- | ----- |
| @jest/types          | 27.4.2  | :heavy_check_mark: Ported |       |
| @sinonjs/fake-timers | 8.0.1   | :x: Not needed            |       |
| @types/node          | *       | :x: Not needed            |       |
| jest-message-util    | 27.4.6  | :x: Not needed            |       |
| jest-mock            | 27.4.6  | :x: Not needed            |       |
| jest-util            | 27.4.2  | :hammer: In Progress      |       |
