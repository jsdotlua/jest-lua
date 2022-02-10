-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/diff-sequences/src/__tests__/__snapshots__/index.test.ts.snap

local snapshots = {}

snapshots['common substrings regression 1'] = [=[

Table {
  "I",
  " se",
  "e",
  " ",
  "a",
  " perfection ",
  "i",
  " att",
  "in",
  "e",
  " no",
  " ",
  "n",
  " i",
  " n",
  " ",
  "a",
  " ",
  "u",
  " ",
  "en",
  " ",
  "t",
  "er",
  " ",
  "is ",
  "n",
  "i",
  "n",
  " ",
  "r",
  "e",
  " ",
  " re",
  "e",
  ".",
}
]=]

snapshots['common substrings wrapping 1'] = [=[

Table {
  "When engineers ",
  "a",
  "v",
  "e",
  " ",
  "ready-to-use tools, they",
  " writ",
  " more",
  "tests, which",
  " results in",
  "more stabl",
  "e",
  " code bases.",
}
]=]

return snapshots