# jest-diff

Status: :hammer: In Progress

Source: https://github.com/facebook/jest/tree/v26.5.3/packages/jest-diff

Version: v26.5.2

---

### :pencil2: Notes
* :x: Color formatting isn't supported.
* :hammer: Currently doesn't support any features that require `prettyFormat` plugins (e.g. React elements).
* `CleanupSemantic.lua` is adapted from the Lua version of [`diff-match-patch`](https://github.com/google/diff-match-patch/blob/master/lua/diff_match_patch.lua) to resemble the upstream [`cleanupSemantics.ts`](https://github.com/facebook/jest/blob/v26.5.3/packages/jest-diff/src/cleanupSemantic.ts) instead of being a direct port of it.
    * Tests for it are added, which are not included in the upstream `jest-diff
* Changes to tests:
    * Snapshots in `Diff.spec.lua` have their leading `<g>`, `<r>`, `<d>`, and `<y>` ANSI style codes manually removed.
    * Color formatting specific tests are omitted.
    * `changeColor` is assigned to a function that imitates `chalk.inverse` so we can test `diffStringsUnified`.
    * `Array[]`, `Object{}` are changed to `Table{}`.

### :x: Excluded
```
src/types.ts
```

### :package: [Dependencies](https://github.com/facebook/jest/blob/v26.5.3/packages/jest-diff/package.json)
| Package | Version | Status | Notes |
| - | - | - | - |
| chalk | 4.0.0 | :x: Will not port | Console output styling is not a priority |
| diff-sequences | 26.5.0 | :heavy_check_mark: Ported | |
| jest-get-type | 26.3.0 | :heavy_check_mark: Ported | |
| pretty-format | 26.5.2 | :heavy_check_mark: Ported | Mostly complete, need plugins |