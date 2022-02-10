# jest-snapshot

Status: :hammer: In Progress

Source: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-snapshot

Version: v27.4.7

---

### :pencil2: Notes
* To update snapshots, first set `--load.asRobloxScript --fs.readwrite="$(pwd)"` to grant `roblox-cli` elevated privileges to be able to write to filesystem and also grant it read/write access to the current directory and additionally set either:
    * `--lua.globals=UPDATESNAPSHOT="all"` to create new snapshots and update all existing snapshots
    * `--lua.globals=UPDATESNAPSHOT="new"` to only create new snapshots, existing failing snapshots will continue to fail
* We intentionally exclude inline snapshot testing as it introduces a lot of code complexity for not much added utility.
* Major deviations on snapshot read/write implementation details because we handle reading snapshots through various Roblox-specific mechanisms like `ModuleScript`, `FileSystemService`, and `CoreScriptSyncService`.
* New snapshot tests pass by default in Jest because snapshots get automatically created for tests that do not already have a snapshot written to file, Jest Roblox cannot do this because elevated permissions are required to write snapshots to file, therefore new snapshot tests fail by default (Jest Roblox tries to match against an empty snapshot) until a snapshot update is run.
* Detailed implementation notes and deviations on snapshot handling for future reference:
    * Snapshots are written to file as a `.snap.lua` that can then be `require`'d as a valid `ModuleScript`. It exports a table with `{ [key] = "snapshot" }`.
    * The TestEZ runner writes and updates three pieces of information into a `JEST_TEST_CONTEXT` global state for Jest snapshots to access:
        * `instance`: the `Instance` reference to the `.spec.lua` that is currently running, this is needed to resolve the snapshot filesystem path.
        * `blocks`: the test context (i.e. the `describe/it` hierarchy) of the currently running test, this is needed for the matchers to locate the correct snapshot to match against.
        * `snapshotState`: the `SnapshotState` object, this is also needed for the matchers to locate the correct snapshot to match against.
    * After a `.spec.lua` file is run, the TestEZ runner attempts to save a snapshot if a snapshot is dirty and the condition matches the snapshot update strategy.
    * `toMatchSnapshot` first initializes the `SnapshotState` for a `.spec.lua` file and stores it in the `JEST_TEST_CONTEXT` global state if it doesn't already exist.
        * If a `.snap.lua` file for that `.spec.lua` file exists, it initializes a `SnapshotState` of that snapshot.
        * If it doesn't exist, it initializes an empty `SnapshotState` with its `_snapshotPath` set to `nil` (explained below).
    * The `_snapshotPath` property of a `SnapshotState` is actually an `Instance` referring to the snapshot file instead of a path on the filesystem, this is needed because we load snapshots by `require`'ing them as a `ModuleScript` and also because we load things within the Roblox DOM instead of from filesystem.
        * The exception is in `utils/saveSnapshotFile`, which actually takes a filesystem path for it's `snapshotPath` argument. The filesystem path of the snapshot is resolved in `SnapshotState:save` based off the path of the `.spec.lua` file that is currently running.
        * This means that for a snapshot that doesn't yet exist, the `_snapshotPath` is set to `nil` since there is no `Instance` to refer to.
    * Because `FileSystemService` and `CoreScriptSyncService` are heavily sandboxed and require elevated privileges, we opted to require absolutely no additional permissions to *match* against existing snapshots, but elevated permissions are needed to *update* snapshots.
        * New snapshot tests fail by default (mentioned above).
        * Obsolete snapshots (snapshots without a corresponding test) are not pruned unless done in an update snapshot run.
            * Obsolete snapshot *files* are not pruned. If a `.spec.lua` no longer contains any snapshot tests, the `.snap.lua` will not be removed even through an update snapshot run. This is because of separation between the TestEZ runner and Jest Roblox, resulting in Jest Roblox initializing the `SnapshotState` and not the runner. This can be addressed when Jest Roblox gets its own runner.

### :x: Excluded
```
src/snapshot_resolver.ts
```

### :package: [Dependencies](https://github.com/facebook/jest/blob/v27.4.7/packages/jest-snapshot/package.json)
| Package               | Version | Status                    | Notes                                                                                |
| --------------------- | ------- | ------------------------- | ------------------------------------------------------------------------------------ |
| `@jest/types`         | 27.4.2  | :heavy_check_mark: Ported |                                                                                      |
| `@chalk`              | 4.0.0   | :heavy_check_mark: Ported | Imported from the chalk-lua library                                                  |
| `@expect`             | 27.4.6  | :heavy_check_mark: Ported |                                                                                      |
| `@graceful-fs`        | 4.2.4   | :x: Will not port         | Don't need file system interaction since we use the Roblox datamodel for file access |
| `@jest-diff`          | 27.4.6  | :heavy_check_mark: Ported |                                                                                      |
| `@jest-get-type`      | 27.4.0  | :heavy_check_mark: Ported |                                                                                      |
| `@jest-matcher-utils` | 27.4.6  | :heavy_check_mark: Ported |                                                                                      |
| `@pretty-format`      | 27.4.6  | :heavy_check_mark: Ported |                                                                                      |
