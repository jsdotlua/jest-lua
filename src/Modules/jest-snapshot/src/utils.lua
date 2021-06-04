-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/jest-snapshot/src/utils.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

-- deviation: for now we have ported a very limited subset of utils that
-- corresponds to the functions needed by the other translated files. We plan
-- on filling the rest of utils out as we continue with the jest-snapshot file.

local Workspace = script.Parent
local Modules = Workspace.Parent

local prettyFormat = require(Modules.PrettyFormat).prettyFormat
local getSerializers = require(Workspace.plugins).getSerializers

local escapeRegex = true
local printFunctionName = false

local normalizeNewLines

local function serialize(val: any, indent: number?): string
	indent = indent or 2
	return normalizeNewLines(
		prettyFormat(val, {
			escapeRegex = escapeRegex,
			indent = indent,
			plugins = getSerializers(),
			printFunctionName = printFunctionName
		})
	)
end

local function minify(val: any): string
	return prettyFormat(val, {
		escapeRegex = true,
		min = true,
		plugins = getSerializers(),
		printFunctionName = printFunctionName
	})
end

-- // Remove double quote marks and unescape double quotes and backslashes.
local function deserializeString(stringified: string): string
	stringified = string.sub(stringified, 2, -2)
	stringified = string.gsub(stringified, "\\\\", "\\")
	stringified = string.gsub(stringified, '\\"', '"')
	return stringified
end

function normalizeNewLines(string_: string)
	string_ = string.gsub(string_, "\r\n", "\n")
	return string.gsub(string_, "\r", "\n")
end

return {
	serialize = serialize,
	minify = minify,
	deserializeString = deserializeString
}
