# jest-snapshot

Status: :hammer: In Progress

Source: https://github.com/facebook/jest/tree/v26.5.3/packages/jest-snapshot

Version: v26.5.3

---

### :pencil2: Notes
* We intentionally exclude inline snapshot testing as it introduces a lot of code complexity for not much added utility

### :x: Excluded
```
```

### :package: [Dependencies]()
| Package | Version | Status | Notes |
| - | - | - | - |
| `@jest/types` | 26.5.2 | :x: Will not port | External type definitions are not a priority |
| `@chalk` | see chalk-lua | :heavy_check_mark: Ported  | Imported from the chalk-lua library |
| `@expect` | 26.5.3 | :heavy_check_mark: Ported  | |
| `@graceful-fs` | 4.2.4 | :x: Will not port  | Don't need file system interaction since we use the Roblox datamodel for file access |
| `@jest-diff` | 26.5.2 | :heavy_check_mark: Ported  | |
| `@jest-get-type` | 26.5.2 | :heavy_check_mark: Ported  | |
| `@jest-matcher-utils` | 26.5.2 | :heavy_check_mark: Ported  | |
| `@pretty-format` | 26.5.2 | :heavy_check_mark: Ported  | |