--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]
-- ROBLOX NOTE: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-globals/src/__tests__/index.ts

return (function()
	type Function = (...any) -> ...any

	local JestGlobals = require(script.Parent.Parent)
	local expect = JestGlobals.expect
	local test = JestGlobals.test

	test("throw when directly imported", function()
		expect(function()
			require(script.Parent.Parent.index)
		end).toThrowError(
			-- ROBLOX deviation START: aligned message to make sense for jest-roblox
			"Do not import `JestGlobals` outside of the Jest test environment"
			-- ROBLOX deviation END
		)
	end)

	return {}
end)()
