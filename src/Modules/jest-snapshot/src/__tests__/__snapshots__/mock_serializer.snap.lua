-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/jest-snapshot/src/__tests__/__snapshots__/mock_serializer.test.ts.snap

local exports = {}

exports["mock with 0 calls and default name 1"] = "[MockFunction]"

exports["mock with 0 calls and default name in React element 1"] = [=[
<button
  onClick={[MockFunction]}
>
  Mock me!
</button>]=]

exports["mock with 0 calls and non-default name 1"] = "[MockFunction MyConstructor]"


-- deviation: changed undefined to "undefined"
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
}]=]

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

-- deviation: undefined changed to "undefined"
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
}]=]

exports["mock with 2 calls, 1 return, 1 throw 1"] = [=[
[MockFunction] {
  "calls": Table {
    Table {
      2,
    },
    Table {
      3,
    },
  },
  "results": Table {
    Table {
      "type": "return",
      "value": 4,
    },
    Table {
      "type": "throw",
      "value": [Error: Error Message!},
    },
  },
}]=]

return exports