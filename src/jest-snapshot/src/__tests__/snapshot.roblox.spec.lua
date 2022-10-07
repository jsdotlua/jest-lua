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
-- ROBLOX deviation START: importing expectExtended to avoid analyze errors for additional matchers
local expect = JestGlobals.expectExtended
-- ROBLOX deviation END
local it = JestGlobals.it

local toMatchSnapshot = require(CurrentModule).toMatchSnapshot
expect.extend({
	toMatchTrimmedSnapshot = function(self, received: string, length: number?)
		return toMatchSnapshot(self, string.sub(received, 1, length), "toMatchTrimmedSnapshot")
	end,
})

it("native lua errors", function()
	expect(function()
		error("oops")
	end).toThrowErrorMatchingSnapshot()
end)

it("custom snapshot matchers", function()
	expect("extra long string oh my gerd").toMatchTrimmedSnapshot(10)
end)

-- ROBLOX FIXME START: we can't call toMatchSnapshot and expect it to fail as this would affect the test state
it.skip("tests that a missing snapshot throws", function()
	expect(function()
		expect().toMatchSnapshot()
	end).toThrow(
		"Snapshot name: `tests that a missing snapshot throws 1`\n\nNew snapshot was [1mnot written[22m. The update flag must be explicitly passed to write a new snapshot.\n\nThis is likely because this test is run in a continuous integration (CI) environment in which snapshots are not written by default."
	)
end)
-- ROBLOX FIXME END

it("tests snapshots with asymmetric matchers", function()
	expect({
		createdAt = DateTime.now(),
		id = math.floor(math.random() * 20),
		name = "LeBron James",
	}).toMatchSnapshot({
		createdAt = expect.any("DateTime"),
		id = expect.any("number"),
		name = "LeBron James",
	})
end)

it("tests snapshots with asymmetric matchers and a subset of properties", function()
	expect({
		createdAt = DateTime.now(),
		id = math.floor(math.random() * 20),
		name = "LeBron James",
	}).toMatchSnapshot({
		createdAt = expect.any("DateTime"),
		id = expect.any("number"),
	})
end)

it("test with newlines\nin the name\nand body", function()
	expect("a\nb").toMatchSnapshot()
end)

return {}
