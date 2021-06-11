---
id: cli
title: CLI Options
---

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

### `--fastFlags.overrides "UseDateTimeType3=true"`
Enables support for the Roblox [DateTime](https://developer.roblox.com/en-us/api-reference/datatype/DateTime) object within Jest Roblox.

### `--lua.globals=NOCOLOR=true`
Disables error output styling for Jest Roblox. This may be useful when running in an environment that doesn't support terminal output styling.

### `--testService.errorExitCode=1`
Sets the error exit code to 1 so that CI like Github actions correctly recognize test failures.