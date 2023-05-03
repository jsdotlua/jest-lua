-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/pretty-format/src/__tests__/ConvertAnsi.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local chalk = require(Packages.ChalkLua)

local PrettyFormat = require(CurrentModule)
local prettyFormat = PrettyFormat.default
local plugins = PrettyFormat.plugins

local ConvertAnsi = plugins.ConvertAnsi

local prettyFormatResult = function(val: string)
	return prettyFormat(val, {
		-- ROBLOX FIXME Luau: not sure why, possibly down to normalization again
		plugins = { ConvertAnsi :: any },
	})
end

describe("ConvertAnsi plugin", function()
	it("supports style.red", function()
		expect(prettyFormatResult(string.format("%s foo content %s", chalk.red.open, chalk.red.close))).toEqual(
			'"<red> foo content </>"'
		)
	end)

	it("supports style.green", function()
		expect(prettyFormatResult(string.format("%s foo content %s", chalk.green.open, chalk.green.close))).toEqual(
			'"<green> foo content </>"'
		)
	end)

	it("supports style.reset", function()
		expect(prettyFormatResult(string.format("%s foo content %s", chalk.reset.open, chalk.reset.close))).toEqual(
			'"</> foo content </>"'
		)
	end)

	it("supports style.bold", function()
		expect(prettyFormatResult(string.format("%s foo content", chalk.bold.open))).toEqual('"<bold> foo content"')
	end)

	it("supports style.dim", function()
		expect(prettyFormatResult(string.format("%s foo content", chalk.dim.open))).toEqual('"<dim> foo content"')
	end)

	it("does not support other colors", function()
		expect(prettyFormatResult(string.format("%s", chalk.blue.open))).toEqual('""')
	end)
end)
