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
-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local it = JestGlobals.it

-- ROBLOX FIXME START: we can't call toMatchSnapshot and expect it to fail as this would affect the test state
it.skip("tests that a missing snapshot file throws", function()
	jestExpect(function()
		jestExpect(nil :: any).toMatchSnapshot()
	end).toThrow(
		"Snapshot name: `tests that a missing snapshot file throws 1`\n\nNew snapshot was [1mnot written[22m. The update flag must be explicitly passed to write a new snapshot.\n\nThis is likely because this test is run in a continuous integration (CI) environment in which snapshots are not written by default."
	)
end)
-- ROBLOX FIXME END

return {}
