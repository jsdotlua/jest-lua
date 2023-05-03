-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-each/src/__tests__/__snapshots__/template.test.ts.snap
-- Jest Snapshot v1, https://goo.gl/fbAQLP
local exports = {}

exports["jest-each .describe throws an error when called with an empty string 1"] = [=[

"Error: `.each` called with an empty Tagged Template Literal of table data.
"
]=]
exports["jest-each .describe throws error when there are additional words in first column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a is the left | b | expected\"</>"
]=]
exports["jest-each .describe throws error when there are additional words in last column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b | expected value\"</>"
]=]
exports["jest-each .describe throws error when there are additional words in second column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b is the right | expected\"</>"
]=]
exports["jest-each .describe throws error when there are fewer arguments than headings over multiple rows 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>  Table {</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 2"
]=]
exports["jest-each .describe throws error when there are fewer arguments than headings when given one row 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 1"
]=]
exports["jest-each .describe throws error when there are no arguments for given headings 1"] = [=[

"Error: `.each` called with a Tagged Template Literal with no data, remember to interpolate with ${expression} syntax.
"
]=]
exports["jest-each .describe.only throws an error when called with an empty string 1"] = [=[

"Error: `.each` called with an empty Tagged Template Literal of table data.
"
]=]
exports["jest-each .describe.only throws error when there are additional words in first column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a is the left | b | expected\"</>"
]=]
exports["jest-each .describe.only throws error when there are additional words in last column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b | expected value\"</>"
]=]
exports["jest-each .describe.only throws error when there are additional words in second column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b is the right | expected\"</>"
]=]
exports["jest-each .describe.only throws error when there are fewer arguments than headings over multiple rows 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>  Table {</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 2"
]=]
exports["jest-each .describe.only throws error when there are fewer arguments than headings when given one row 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 1"
]=]
exports["jest-each .describe.only throws error when there are no arguments for given headings 1"] = [=[

"Error: `.each` called with a Tagged Template Literal with no data, remember to interpolate with ${expression} syntax.
"
]=]
exports["jest-each .describeFOCUS throws an error when called with an empty string 1"] = [=[

"Error: `.each` called with an empty Tagged Template Literal of table data.
"
]=]
exports["jest-each .describeFOCUS throws error when there are additional words in first column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a is the left | b | expected\"</>"
]=]
exports["jest-each .describeFOCUS throws error when there are additional words in last column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b | expected value\"</>"
]=]
exports["jest-each .describeFOCUS throws error when there are additional words in second column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b is the right | expected\"</>"
]=]
exports["jest-each .describeFOCUS throws error when there are fewer arguments than headings over multiple rows 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>  Table {</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 2"
]=]
exports["jest-each .describeFOCUS throws error when there are fewer arguments than headings when given one row 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 1"
]=]
exports["jest-each .describeFOCUS throws error when there are no arguments for given headings 1"] = [=[

"Error: `.each` called with a Tagged Template Literal with no data, remember to interpolate with ${expression} syntax.
"
]=]
exports["jest-each .fdescribe throws an error when called with an empty string 1"] = [=[

"Error: `.each` called with an empty Tagged Template Literal of table data.
"
]=]
exports["jest-each .fdescribe throws error when there are additional words in first column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a is the left | b | expected\"</>"
]=]
exports["jest-each .fdescribe throws error when there are additional words in last column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b | expected value\"</>"
]=]
exports["jest-each .fdescribe throws error when there are additional words in second column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b is the right | expected\"</>"
]=]
exports["jest-each .fdescribe throws error when there are fewer arguments than headings over multiple rows 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>  Table {</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 2"
]=]
exports["jest-each .fdescribe throws error when there are fewer arguments than headings when given one row 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 1"
]=]
exports["jest-each .fdescribe throws error when there are no arguments for given headings 1"] = [=[

"Error: `.each` called with a Tagged Template Literal with no data, remember to interpolate with ${expression} syntax.
"
]=]
exports["jest-each .fit throws an error when called with an empty string 1"] = [=[

"Error: `.each` called with an empty Tagged Template Literal of table data.
"
]=]
exports["jest-each .fit throws error when there are additional words in first column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a is the left | b | expected\"</>"
]=]
exports["jest-each .fit throws error when there are additional words in last column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b | expected value\"</>"
]=]
exports["jest-each .fit throws error when there are additional words in second column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b is the right | expected\"</>"
]=]
exports["jest-each .fit throws error when there are fewer arguments than headings over multiple rows 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>  Table {</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 2"
]=]
exports["jest-each .fit throws error when there are fewer arguments than headings when given one row 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 1"
]=]
exports["jest-each .fit throws error when there are no arguments for given headings 1"] = [=[

"Error: `.each` called with a Tagged Template Literal with no data, remember to interpolate with ${expression} syntax.
"
]=]
exports["jest-each .it throws an error when called with an empty string 1"] = [=[

"Error: `.each` called with an empty Tagged Template Literal of table data.
"
]=]
exports["jest-each .it throws error when there are additional words in first column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a is the left | b | expected\"</>"
]=]
exports["jest-each .it throws error when there are additional words in last column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b | expected value\"</>"
]=]
exports["jest-each .it throws error when there are additional words in second column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b is the right | expected\"</>"
]=]
exports["jest-each .it throws error when there are fewer arguments than headings over multiple rows 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>  Table {</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 2"
]=]
exports["jest-each .it throws error when there are fewer arguments than headings when given one row 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 1"
]=]
exports["jest-each .it throws error when there are no arguments for given headings 1"] = [=[

"Error: `.each` called with a Tagged Template Literal with no data, remember to interpolate with ${expression} syntax.
"
]=]
exports["jest-each .it.only throws an error when called with an empty string 1"] = [=[

"Error: `.each` called with an empty Tagged Template Literal of table data.
"
]=]
exports["jest-each .it.only throws error when there are additional words in first column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a is the left | b | expected\"</>"
]=]
exports["jest-each .it.only throws error when there are additional words in last column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b | expected value\"</>"
]=]
exports["jest-each .it.only throws error when there are additional words in second column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b is the right | expected\"</>"
]=]
exports["jest-each .it.only throws error when there are fewer arguments than headings over multiple rows 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>  Table {</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 2"
]=]
exports["jest-each .it.only throws error when there are fewer arguments than headings when given one row 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 1"
]=]
exports["jest-each .it.only throws error when there are no arguments for given headings 1"] = [=[

"Error: `.each` called with a Tagged Template Literal with no data, remember to interpolate with ${expression} syntax.
"
]=]
exports["jest-each .itFOCUS throws an error when called with an empty string 1"] = [=[

"Error: `.each` called with an empty Tagged Template Literal of table data.
"
]=]
exports["jest-each .itFOCUS throws error when there are additional words in first column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a is the left | b | expected\"</>"
]=]
exports["jest-each .itFOCUS throws error when there are additional words in last column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b | expected value\"</>"
]=]
exports["jest-each .itFOCUS throws error when there are additional words in second column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b is the right | expected\"</>"
]=]
exports["jest-each .itFOCUS throws error when there are fewer arguments than headings over multiple rows 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>  Table {</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 2"
]=]
exports["jest-each .itFOCUS throws error when there are fewer arguments than headings when given one row 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 1"
]=]
exports["jest-each .itFOCUS throws error when there are no arguments for given headings 1"] = [=[

"Error: `.each` called with a Tagged Template Literal with no data, remember to interpolate with ${expression} syntax.
"
]=]
exports["jest-each .test throws an error when called with an empty string 1"] = [=[

"Error: `.each` called with an empty Tagged Template Literal of table data.
"
]=]
exports["jest-each .test throws error when there are additional words in first column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a is the left | b | expected\"</>"
]=]
exports["jest-each .test throws error when there are additional words in last column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b | expected value\"</>"
]=]
exports["jest-each .test throws error when there are additional words in second column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b is the right | expected\"</>"
]=]
exports["jest-each .test throws error when there are fewer arguments than headings over multiple rows 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>  Table {</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 2"
]=]
exports["jest-each .test throws error when there are fewer arguments than headings when given one row 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 1"
]=]
exports["jest-each .test throws error when there are no arguments for given headings 1"] = [=[

"Error: `.each` called with a Tagged Template Literal with no data, remember to interpolate with ${expression} syntax.
"
]=]

-- ROBLOX deviation START: .concurrent not supported
-- snapshots["jest-each .test.concurrent throws an error when called with an empty string 1"] = [=[

-- "Error: `.each` called with an empty Tagged Template Literal of table data.
-- "
-- ]=]

-- snapshots["jest-each .test.concurrent throws error when there are additional words in first column heading 1"] = [=[

-- Table headings do not conform to expected format:

-- <green>heading1 | headingN</>

-- Received:

-- <red>\"a is the left | b | expected\"</>
-- ]=]

-- snapshots["jest-each .test.concurrent throws error when there are additional words in last column heading 1"] = [=[

-- Table headings do not conform to expected format:

-- <green>heading1 | headingN</>

-- Received:

-- <red>\"a | b | expected value\"</>
-- ]=]

-- snapshots["jest-each .test.concurrent throws error when there are additional words in second column heading 1"] = [=[

-- Table headings do not conform to expected format:

-- <green>heading1 | headingN</>

-- Received:

-- <red>"</>
-- <red>          a    | b is the right | expected</>
-- <red>          "</>
-- ]=]

-- snapshots["jest-each .test.concurrent throws error when there are fewer arguments than headings over multiple rows 1"] =
-- 	[=[

-- Not enough arguments supplied for given headings:
-- <green>a | b | expected</>

-- Received:
-- <red>Table {</>
-- <red>  Table {</>
-- <red>    0,</>
-- <red>    1,</>
-- <red>    1,</>
-- <red>  },</>
-- <red>  Table {</>
-- <red>    1,</>
-- <red>    1,</>
-- <red>  },</>
-- <red>}</>

-- Missing <red>1</> argument in row 2
-- ]=]

-- snapshots["jest-each .test.concurrent throws error when there are fewer arguments than headings when given one row 1"] =
-- 	[=[

-- Not enough arguments supplied for given headings:
-- <green>a | b | expected</>

-- Received:
-- <red>Table {</>
-- <red>  Table {</>
-- <red>    0,</>
-- <red>    1,</>
-- <red>  },</>
-- <red>}</>

-- Missing <red>1</> argument in row 1
-- ]=]

-- snapshots["jest-each .test.concurrent throws error when there are no arguments for given headings 1"] = [=[

-- "Error: `.each` called with a Tagged Template Literal with no data, remember to interpolate with ${expression} syntax.
-- "
-- ]=]

-- snapshots["jest-each .test.concurrent.only throws an error when called with an empty string 1"] = [=[

-- "Error: `.each` called with an empty Tagged Template Literal of table data.
-- "
-- ]=]

-- snapshots["jest-each .test.concurrent.only throws error when there are additional words in first column heading 1"] =
-- 	[=[

-- Table headings do not conform to expected format:

-- <green>heading1 | headingN</>

-- Received:

-- <red>\"a is the left | b | expected\"</>
-- ]=]

-- snapshots["jest-each .test.concurrent.only throws error when there are additional words in last column heading 1"] = [=[

-- Table headings do not conform to expected format:

-- <green>heading1 | headingN</>

-- Received:

-- <red>\"a | b | expected value\"</>
-- ]=]

-- snapshots["jest-each .test.concurrent.only throws error when there are additional words in second column heading 1"] =
-- 	[=[

-- 	Table headings do not conform to expected format:

-- <green>heading1 | headingN</>

-- Received:

-- <red>"</>
-- <red>          a    | b is the right | expected</>
-- <red>          "</>
-- ]=]

-- snapshots["jest-each .test.concurrent.only throws error when there are fewer arguments than headings over multiple rows 1"] =
-- 	[=[

-- Not enough arguments supplied for given headings:
-- <green>a | b | expected</>

-- Received:
-- <red>Table {</>
-- <red>  Table {</>
-- <red>    0,</>
-- <red>    1,</>
-- <red>    1,</>
-- <red>  },</>
-- <red>  Table {</>
-- <red>    1,</>
-- <red>    1,</>
-- <red>  },</>
-- <red>}</>

-- Missing <red>1</> argument in row 2
-- ]=]

-- snapshots["jest-each .test.concurrent.only throws error when there are fewer arguments than headings when given one row 1"] =
-- 	[=[

-- Not enough arguments supplied for given headings:
-- <green>a | b | expected</>

-- Received:
-- <red>Table {</>
-- <red>  Table {</>
-- <red>    0,</>
-- <red>    1,</>
-- <red>  },</>
-- <red>}</>

-- Missing <red>1</> argument in row 1
-- ]=]

-- snapshots["jest-each .test.concurrent.only throws error when there are no arguments for given headings 1"] = [=[

-- "Error: `.each` called with a Tagged Template Literal with no data, remember to interpolate with ${expression} syntax.
-- "
-- ]=]

-- snapshots["jest-each .test.concurrent.skip throws an error when called with an empty string 1"] = [=[

-- "Error: `.each` called with an empty Tagged Template Literal of table data.
-- "
-- ]=]

-- snapshots["jest-each .test.concurrent.skip throws error when there are additional words in first column heading 1"] =
-- 	[=[

-- Table headings do not conform to expected format:

-- <green>heading1 | headingN</>

-- Received:

-- <red>\"a is the left | b | expected\"</>
-- ]=]

-- snapshots["jest-each .test.concurrent.skip throws error when there are additional words in last column heading 1"] = [=[

-- Table headings do not conform to expected format:

-- <green>heading1 | headingN</>

-- Received:

-- <red>\"a | b | expected value\"</>
-- ]=]

-- snapshots["jest-each .test.concurrent.skip throws error when there are additional words in second column heading 1"] =
-- 	[=[

-- 	Table headings do not conform to expected format:

-- <green>heading1 | headingN</>

-- Received:

-- <red>"</>
-- <red>          a    | b is the right | expected</>
-- <red>          "</>
-- ]=]

-- snapshots["jest-each .test.concurrent.skip throws error when there are fewer arguments than headings over multiple rows 1"] =
-- 	[=[

-- Not enough arguments supplied for given headings:
-- <green>a | b | expected</>

-- Received:
-- <red>Table {</>
-- <red>  Table {</>
-- <red>    0,</>
-- <red>    1,</>
-- <red>    1,</>
-- <red>  },</>
-- <red>  Table {</>
-- <red>    1,</>
-- <red>    1,</>
-- <red>  },</>
-- <red>}</>

-- Missing <red>1</> argument in row 2
-- ]=]

-- snapshots["jest-each .test.concurrent.skip throws error when there are fewer arguments than headings when given one row 1"] =
-- 	[=[

-- Not enough arguments supplied for given headings:
-- <green>a | b | expected</>

-- Received:
-- <red>Table {</>
-- <red>  Table {</>
-- <red>    0,</>
-- <red>    1,</>
-- <red>  },</>
-- <red>}</>

-- Missing <red>1</> argument in row 1
-- ]=]

-- snapshots["jest-each .test.concurrent.skip throws error when there are no arguments for given headings 1"] = [=[

-- "Error: `.each` called with a Tagged Template Literal with no data, remember to interpolate with ${expression} syntax.
-- "
-- ]=]
-- ROBLOX deviation END
exports["jest-each .test.only throws an error when called with an empty string 1"] = [=[

"Error: `.each` called with an empty Tagged Template Literal of table data.
"
]=]
exports["jest-each .test.only throws error when there are additional words in first column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a is the left | b | expected\"</>"
]=]
exports["jest-each .test.only throws error when there are additional words in last column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b | expected value\"</>"
]=]
exports["jest-each .test.only throws error when there are additional words in second column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b is the right | expected\"</>"
]=]
exports["jest-each .test.only throws error when there are fewer arguments than headings over multiple rows 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>  Table {</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 2"
]=]
exports["jest-each .test.only throws error when there are fewer arguments than headings when given one row 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 1"
]=]
exports["jest-each .test.only throws error when there are no arguments for given headings 1"] = [=[

"Error: `.each` called with a Tagged Template Literal with no data, remember to interpolate with ${expression} syntax.
"
]=]
exports["jest-each .testFOCUS throws an error when called with an empty string 1"] = [=[

"Error: `.each` called with an empty Tagged Template Literal of table data.
"
]=]
exports["jest-each .testFOCUS throws error when there are additional words in first column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a is the left | b | expected\"</>"
]=]
exports["jest-each .testFOCUS throws error when there are additional words in last column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b | expected value\"</>"
]=]
exports["jest-each .testFOCUS throws error when there are additional words in second column heading 1"] = [=[

"Table headings do not conform to expected format:

<green>heading1 | headingN</>

Received:

<red>\"a | b is the right | expected\"</>"
]=]
exports["jest-each .testFOCUS throws error when there are fewer arguments than headings over multiple rows 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>  Table {</>
<red>    1,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 2"
]=]
exports["jest-each .testFOCUS throws error when there are fewer arguments than headings when given one row 1"] = [=[

"Not enough arguments supplied for given headings:
<green>a | b | expected</>

Received:
<red>Table {</>
<red>  Table {</>
<red>    0,</>
<red>    1,</>
<red>  },</>
<red>}</>

Missing <red>1</> argument in row 1"
]=]
exports["jest-each .testFOCUS throws error when there are no arguments for given headings 1"] = [=[

"Error: `.each` called with a Tagged Template Literal with no data, remember to interpolate with ${expression} syntax.
"
]=]

return exports
