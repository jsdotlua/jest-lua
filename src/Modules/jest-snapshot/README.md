# jest-snapshot

Status: :hammer: In Progress

Source: https://github.com/facebook/jest/tree/v26.5.3/packages/jest-snapshot

Version: v26.5.3

---

### :pencil2: Notes
* We intentionally exclude inline snapshot testing as it introduces a lot of code complexity for not much added utility
* Major deviations on snapshot read/write implementation details because we handle reading snapshots through various Roblox-specific mechanisms like `ModuleScript`, `FileSystemService`, and `CoreScriptSyncService`
* New snapshot tests pass by default in Jest because snapshots get automatically created for tests that do not already have a snapshot written to file, Jest Roblox cannot do this because elevated permissions are required to write snapshots to file, therefore new snapshot tests fail by default (Jest Roblos tries to match against an empty snapshot) until a snapshot update is run

### :x: Excluded
```
src/snapshot_resolver.ts
```

### :package: [Dependencies](https://github.com/facebook/jest/blob/v26.5.3/packages/jest-snapshot/package.json)
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