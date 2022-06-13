-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/pretty-format/src/__tests__/ConvertAnsi.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local jestExpect = require(Packages.Dev.JestGlobals).expect

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
			jestExpect(prettyFormatResult(string.format("%s foo content %s", chalk.red.open, chalk.red.close))).toEqual(
				'"<red> foo content </>"'
			)
		end)

		it("supports style.green", function()
			jestExpect(prettyFormatResult(string.format("%s foo content %s", chalk.green.open, chalk.green.close))).toEqual(
				'"<green> foo content </>"'
			)
		end)

		it("supports style.reset", function()
			jestExpect(prettyFormatResult(string.format("%s foo content %s", chalk.reset.open, chalk.reset.close))).toEqual(
				'"</> foo content </>"'
			)
		end)

		it("supports style.bold", function()
			jestExpect(prettyFormatResult(string.format("%s foo content", chalk.bold.open))).toEqual(
				'"<bold> foo content"'
			)
		end)

		it("supports style.dim", function()
			jestExpect(prettyFormatResult(string.format("%s foo content", chalk.dim.open))).toEqual(
				'"<dim> foo content"'
			)
		end)

		it("does not support other colors", function()
			jestExpect(prettyFormatResult(string.format("%s", chalk.blue.open))).toEqual('""')
		end)
	end)
end
