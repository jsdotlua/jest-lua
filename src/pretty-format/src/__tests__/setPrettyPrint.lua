-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/pretty-format/src/__tests__/setPrettyPrint.ts
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local exports = {}

local prettyFormat = require(script.Parent.Parent).default
local typesModule = require(script.Parent.Parent.Types)
type OptionsReceived = typesModule.OptionsReceived
type Plugins = typesModule.Plugins

local jestExpect = require(Packages.Dev.JestGlobals).expect

--[[ ROBLOX TODO: Unhandled node for type: TSModuleDeclaration ]]
--[[ declare global {
  namespace jest {
    interface Matchers<R> {
      toPrettyPrintTo(expected: unknown, options?: OptionsReceived): R;
    }
  }
} ]]
local function setPrettyPrint(plugins: Plugins)
	jestExpect.extend({
		toPrettyPrintTo = function(self, received: unknown, expected: unknown, options: OptionsReceived?)
			local prettyFormatted = prettyFormat(received, Object.assign({}, { plugins = plugins }, options))
			local pass = prettyFormatted == expected
			local message = if Boolean.toJSBoolean(pass)
				then function()
					return tostring(self.utils:matcherHint(".not.toBe"))
						.. "\n\n"
						.. "Expected value to not be:\n"
						.. ("  %s\n"):format(self.utils:printExpected(expected))
						.. "Received:\n"
						.. ("  %s"):format(self.utils:printReceived(prettyFormatted))
				end
				else function()
					local diffString = self.utils:diff(expected, prettyFormatted, { expand = self.expand })
					return tostring(self.utils:matcherHint(".toBe"))
						.. "\n\n"
						.. "Expected value to be:\n"
						.. ("  %s\n"):format(self.utils:printExpected(expected))
						.. "Received:\n"
						.. ("  %s"):format(self.utils:printReceived(prettyFormatted))
						.. tostring(
							if Boolean.toJSBoolean(diffString) then ("\n\nDifference:\n\n%s"):format(diffString) else ""
						)
				end
			return { actual = prettyFormatted, message = message, pass = pass }
		end,
	})
end
exports.default = setPrettyPrint
return exports
