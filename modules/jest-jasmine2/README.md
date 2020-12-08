# jest-jasmine2

Status: :hammer: In Progress

Source: https://github.com/facebook/jest/tree/v26.5.3/packages/jest-jasmine2/src/jasmine

Version: v26.5.3

---

### :pencil2: Notes
* Our upstream, Jest, doesn't include any test files for the files in this directory, `jest-jasmine2/src/jasmine/`, so we look to the upstream that Jest is based off of Jasmine, for the test files
* The tests for CallTracker and SpyStrategy are copied off of the upstream files but the `createSpy.ts` file doesn't actually have a direct upstream equivalent in Jasmine so we copy some tests from `SpySpec` instead, leaving out the majority of tests that aren't yet relevant
* We expose `andAlso` in addition to the typical `and` for createSpy since `and` is a built in keyword for Lua so we can't cleanly chain fields (i.e. we can't get `var.and` to work so we allow for `var.andAlso`)
* We use the [Roblox Lua Promise](https://github.com/evaera/roblox-lua-promise) library in this module in a number of places to more closely mirror the asynchronous tests in Jasmine


### :x: Excluded
```
```

### :package: [Dependencies](https://github.com/facebook/jest/blob/v26.5.3/packages/jest-jasmine2/package.json)
| Package | Version | Status | Notes |
| - | - | - | - |
