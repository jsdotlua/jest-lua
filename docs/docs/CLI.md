---
id: cli
title: CLI Options
---

:::caution
This section is subject to change since passing in flags directly to `roblox-cli` will be superceded by `jest-rbx-cli` soon.
:::

When running Jest Roblox using `roblox-cli` there are a handful of useful options. These can be appended to the end of your `roblox-cli run` command:
```bash
roblox-cli run --load.model default.project.json --run spec.lua <options>
```

## Options

import TOCInline from "@theme/TOCInline";

<TOCInline toc={
	toc[toc.length - 1].children
}/>

---

## Reference

### `--lua.globals=NOCOLOR=true`
Disables error output styling for Jest Roblox. This may be useful when running in an environment that doesn't support terminal output styling.

### `--lua.globals=UPDATESNAPSHOT="all"`
Use this flag to re-record every snapshot that fails during this test run. Can pass in values `all` to update all failed snapshots or `new` to only create missing snapshots.

You'll also need to pass in these flags to `roblox-cli` to grant it permissions to write snapshot files:
```
--load.asRobloxScript --fs.readwrite="$(pwd)" 
```
`--fs.readwrite` should be an **absolute** path pointing to the directory containing your tests.

### `--testService.errorExitCode=1`
Sets the error exit code to 1 so that CI like Github actions correctly recognize test failures.