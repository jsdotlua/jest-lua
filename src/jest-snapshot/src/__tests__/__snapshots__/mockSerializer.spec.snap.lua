-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-snapshot/src/__tests__/__snapshots__/mockSerializer.test.ts.snap

local exports = {}

exports["mock with 0 calls and default name 1"] = "[MockFunction]"

-- ROBLOX deviation START: not supported
-- exports["mock with 0 calls and default name in React element 1"] = [=[
-- <button
--   onClick={[MockFunction]}
-- >
--   Mock me!
-- </button>]=]

-- exports["mock with 0 calls and non-default name 1"] = "[MockFunction MyConstructor]"
-- ROBLOX deviation END

-- ROBLOX deviation START: changed undefined to "undefined"
exports["mock with 1 calls and non-default name via new in object 1"] = [=[

Table {
  "fn": [MockFunction MyConstructor] {
    "calls": Table {
      Table {
        Table {
          "name": "some fine name",
        },
      },
    },
    "results": Table {
      Table {
        "type": "return",
        "value": "undefined",
      },
    },
  },
}
]=]
-- ROBLOX deviation END

exports["mock with 1 calls in React element 1"] = [=[
<button
  onClick={
    [MockFunction] {
      "calls": Table {
        Table {
          "Mocking you!",
        },
      },
      "results": Table {
        Table {
          "type": "return",
          "value": undefined,
        },
      },
    }
  }
>
  Mock me!
</button>]=]

-- ROBLOX deviation START: undefined changed to "undefined"
exports["mock with 2 calls 1"] = [=[

[MockFunction] {
  "calls": Table {
    Table {},
    Table {
      Table {
        "foo": "bar",
      },
      42,
    },
  },
  "results": Table {
    Table {
      "type": "return",
      "value": "undefined",
    },
    Table {
      "type": "return",
      "value": "undefined",
    },
  },
}
]=]
-- ROBLOX deviation END

-- ROBLOX deviation START: not supported
-- exports["mock with 2 calls, 1 return, 1 throw 1"] = [=[

-- [MockFunction] {
--   "calls": Table {
--     Table {
--       2,
--     },
--     Table {
--       3,
--     },
--   },
--   "results": Table {
--     Table {
--       "type": "return",
--       "value": 4,
--     },
--     Table {
--       "type": "throw",
--       "value": [Error: Error Message!},
--     },
--   },
-- }
-- ]=]
-- ROBLOX deviation END

return exports
