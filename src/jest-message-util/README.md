# jest-message-util

Status: :hammer: In Progress

Source: https://github.com/facebook/jest/tree/v26.5.3/packages/jest-message-util

Version: v26.5.2

---

### :pencil2: Notes

### :x: Excluded
```
```

### :package: [Dependencies](https://github.com/facebook/jest/blob/v26.5.3/packages/jest-message-util/package.json)
| Package | Version | Status | Notes |
| - | - | - | - |
| @babel/code-frame | 7.0.0 | :x: Will not port | Babel is not needed |
| @jest/types | 26.5.2 | :x: Will not port | External typedefs not a priority |
| @types/stack-utils | 2.0.0 | :x: Will not port | External typedefs not a priority |
| chalk | 4.0.0 | :heavy_check_mark: Ported | [Lua-Chalk](https://github.com/Roblox/lua-chalk) |
| graceful-fs | 4.2.4 | :x: Will not port | No need to interact with the filesystem |
| micromatch | 4.0.1 | :x: Will not port | Deals with file paths |
| slash | 3.0.0 | :x: Will not port | Deals with file paths |
| stack-utils | 2.0.2 | | |