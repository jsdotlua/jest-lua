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

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local getParent = require("../utils").robloxGetParent

describe("getParent", function()
	it("works on Unix paths", function()
		expect(getParent("/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__/snapshot.snap.lua")).toEqual(
			"/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__/snapshot.snap.lua"
		)
	end)

	it("works on Windows paths", function()
		expect(
			getParent(
				"C:\\Users\\Raymond\\jest-roblox\\src\\Submodules\\expect\\src\\__tests__\\__snapshots__\\snapshot.snap.lua"
			)
		).toEqual(
			"C:\\Users\\Raymond\\jest-roblox\\src\\Submodules\\expect\\src\\__tests__\\__snapshots__\\snapshot.snap.lua"
		)
	end)

	it("gets parent directory", function()
		expect(
			getParent("/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__/snapshot.snap.lua", 1)
		).toEqual("/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__")
	end)

	it("gets grandparent directory", function()
		expect(
			getParent("/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__/__snapshots__/snapshot.snap.lua", 2)
		).toEqual("/Users/rng/jest-roblox/src/Submodules/expect/src/__tests__")
	end)
end)
