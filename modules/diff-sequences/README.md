# diff-sequences

Status: :heavy_check_mark: Ported

Source: https://github.com/facebook/jest/tree/v26.5.3/packages/diff-sequences

Version: v26.5.0

---

### :pencil2: Notes
* :x: Property tests and performance tests from upstream are not included.
* :warning: Lua does not allow indexing into strings, the consumer is expected to handle the input types in `isCommon` and `foundSubsequence`.
    * A `stringToArray` function is implemented to convert input strings to arrays for tests.
    * Substring tests are done using arrays of characters instead. The substring comparison methods are omitted.
* Lua is 1 indexed so array indices are replaced with `index + 1`.
* Uses of `NOT_YET_SET` are replaced with just a 0 since this is a JS-specific workaround.
* Lua's `==` operator doesn't compare array values so we implement an `arrayEquals` to check array equality for tests.
* Lua treats `0` as a true value so `nChange || baDeltaLength` needs to be written as `nChange ~= 0 and nChange or baDeltaLength`.