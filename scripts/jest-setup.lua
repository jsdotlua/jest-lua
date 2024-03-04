local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local ConvertAnsi = require("@pkg/@jsdotlua/pretty-format").plugins.ConvertAnsi

JestGlobals.expect.addSnapshotSerializer(ConvertAnsi)
