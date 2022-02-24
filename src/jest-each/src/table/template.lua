--!nocheck
-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-each/src/table/template.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]
local Packages = script.Parent.Parent.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local exports = {}

-- ROBLOX deviation: predefine variables
local convertRowToTable, convertTableToTemplates

local typesModule = require(Packages.JestTypes)
type Global_Row = typesModule.Global_Row
type Global_Table = typesModule.Global_Table

-- local bindModule = require(script.Parent.Parent.bind)
-- type EachTests = bindModule.EachTests
type EachTests = any
local interpolationModule = require(script.Parent.interpolation)
type Headings = interpolationModule.Headings
type Template = interpolationModule.Template
type Templates = interpolationModule.Templates
local interpolateVariables = require(script.Parent.interpolation).interpolateVariables

local function default(title: string, headings: Headings, row: Global_Row): EachTests
	local table_ = convertRowToTable(row, headings)
	local templates = convertTableToTemplates(table_, headings)
	return Array.map(templates, function(template, index)
		return {
			arguments = { template },
			title = interpolateVariables(title, template, index),
		}
	end)
end

exports.default = default

function convertRowToTable(row: Global_Row, headings: Headings): Global_Table
	return Array.map(Array.from({ length = #row / #headings }), function(_, index: number)
		return Array.slice(row, index * #headings, index * #headings + #headings)
	end)
end

function convertTableToTemplates(table: Global_Table, headings: Headings): Templates
	return Array.map(table, function(row)
		return Array.reduce(row, function(acc, value, index)
			return Object.assign(acc, { [headings[index]] = value })
		end, {})
	end)
end

return exports
