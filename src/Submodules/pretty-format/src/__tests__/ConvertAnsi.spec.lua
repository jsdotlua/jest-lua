--!nocheck
-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/pretty-format/src/__tests__/ConvertAnsi.test.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

local Workspace = script.Parent.Parent
local Modules = Workspace.Parent
local Packages = Modules.Parent.Parent

local jestExpect = require(Modules.Expect)

local chalk = require(Packages.ChalkLua)

local PrettyFormat = require(Workspace)
local prettyFormat = PrettyFormat.prettyFormat
local ConvertAnsi = PrettyFormat.plugins.ConvertAnsi


local prettyFormatResult = function(val: string)
	return prettyFormat(val, {
		plugins = {ConvertAnsi}
	})
end

return function()
	describe('ConvertAnsi plugin', function()
		it('supports style.red', function()
			jestExpect(
				prettyFormatResult(
					string.format('%s foo content %s', chalk.red.open, chalk.red.close)
				)
			).toEqual('"<red> foo content </>"')
		end)

		it('supports style.green', function()
			jestExpect(
				prettyFormatResult(
					string.format('%s foo content %s', chalk.green.open, chalk.green.close)
				)
			).toEqual('"<green> foo content </>"')
		end)

		it('supports style.reset', function()
			jestExpect(
				prettyFormatResult(
					string.format('%s foo content %s', chalk.reset.open, chalk.reset.close)
				)
			).toEqual('"</> foo content </>"')
		end)

		it('supports style.bold', function()
			jestExpect(prettyFormatResult(string.format('%s foo content', chalk.bold.open))).toEqual(
				'"<bold> foo content"')
		end)

		it('supports style.dim', function()
			jestExpect(prettyFormatResult(string.format('%s foo content', chalk.dim.open))).toEqual(
				'"<dim> foo content"')
		end)

		it('does not support other colors', function()
			jestExpect(prettyFormatResult(string.format('%s', chalk.blue.open))).toEqual('""')
		end)
	end)
end