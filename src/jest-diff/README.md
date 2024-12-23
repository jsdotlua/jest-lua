# jest-diff

Upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-diff

Display differences clearly so people can review changes confidently.

The `diff` named export serializes **values**, compares them line-by-line, and returns a string which includes comparison lines.

Two named exports compare **strings** character-by-character:

- `diffStringsUnified` returns a string.
- `diffStringsRaw` returns an array of `Diff` objects.

Three named exports compare **arrays of strings** line-by-line:

- `diffLinesUnified` and `diffLinesUnified2` return a string.
- `diffLinesRaw` returns an array of `Diff` objects.

---

### :pencil2: Notes
* `CleanupSemantic.lua` is adapted from the Lua version of [`diff-match-patch`](https://github.com/google/diff-match-patch/blob/master/lua/diff_match_patch.lua) to resemble the upstream [`cleanupSemantics.ts`](https://github.com/facebook/jest/blob/v27.4.7/packages/jest-diff/src/cleanupSemantic.ts) instead of being a direct port of it.
    * Tests for it are added, which are not included in the upstream `jest-diff
* Changes to tests:
    * Snapshots in `Diff.spec.lua` have their leading `<g>`, `<r>`, `<d>`, and `<y>` ANSI style codes manually removed.
    * Color formatting specific tests are omitted.
    * `changeColor` is assigned to a function that imitates `chalk.inverse` so we can test `diffStringsUnified`.
    * `Array[]`, `Object{}` are changed to `Table{}`.
