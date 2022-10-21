-- ROBLOX NOTE: no upstream
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

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

type FIXME_ANALYZE = any

(describe.each :: FIXME_ANALYZE)("v1 | v2 | v3", { 1, 2, 3 }, { 4, 5, 6 })(
	"supports describe.each with template syntax: $v1, $v2, $v3 (string heading)",
	function(ref)
		local v1: number, v2: number, v3: number = ref.v1, ref.v2, ref.v3
		it("pass", function()
			expect(v3).toBe(v2 + 1)
			expect(v2).toBe(v1 + 1)
		end)
	end
);

(describe.each :: FIXME_ANALYZE)({ "v1 | v2 | v3" }, { 1, 2, 3 }, { 4, 5, 6 })(
	"supports describe.each with template syntax: $v1, $v2, $v3 (Array<string> heading)",
	function(ref)
		local v1: number, v2: number, v3: number = ref.v1, ref.v2, ref.v3
		it("pass", function()
			expect(v3).toBe(v2 + 1)
			expect(v2).toBe(v1 + 1)
		end)
	end
)

describe("supports it.each with template syntax", function()
	(it.each :: FIXME_ANALYZE)("v1 | v2 | v3", { 1, 2, 3 }, { 4, 5, 6 })("$v1, $v2, $v3 (string heading)", function(ref)
		local v1: number, v2: number, v3: number = ref.v1, ref.v2, ref.v3
		expect(v3).toBe(v2 + 1)
		expect(v2).toBe(v1 + 1)
	end);

	(it.each :: FIXME_ANALYZE)({ "v1 | v2 | v3" }, { 1, 2, 3 }, { 4, 5, 6 })(
		"$v1, $v2, $v3 (Array<string> heading)",
		function(ref)
			local v1: number, v2: number, v3: number = ref.v1, ref.v2, ref.v3
			expect(v3).toBe(v2 + 1)
			expect(v2).toBe(v1 + 1)
		end
	)
end)
