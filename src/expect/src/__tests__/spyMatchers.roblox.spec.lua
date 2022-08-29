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
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll
local afterAll = JestGlobals.afterAll

local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array

local jestExpect = require(CurrentModule)
local alignedAnsiStyleSerializer = require(Packages.Dev.TestUtils).alignedAnsiStyleSerializer

local jestMock = require(Packages.Dev.JestMock).ModuleMocker

local mock

beforeAll(function()
	mock = jestMock.new()
	jestExpect.addSnapshotSerializer(alignedAnsiStyleSerializer)
end)

afterAll(function()
	jestExpect.resetSnapshotSerializers()
end)

local function createSpy(fn)
	local spy = {}
	setmetatable(spy, {
		__call = function() end,
	})

	spy.calls = {
		all = function()
			return Array.map(fn.mock.calls, function(args)
				return { args = args }
			end)
		end,
		count = function()
			return #fn.mock.calls
		end,
	}

	return spy
end

describe("Lua tests", function()
	describe("nil argument calls", function()
		it("lastCalledWith works with trailing nil argument", function()
			local fn = mock:fn()
			fn("a", "b", nil)
			jestExpect(fn).never.lastCalledWith("a", "b")
			jestExpect(function()
				jestExpect(fn).lastCalledWith("a", "b")
			end).toThrowErrorMatchingSnapshot()
		end)

		it("lastCalledWith works with inner nil argument", function()
			local fn = mock:fn()
			fn("a", nil, "b")
			jestExpect(fn).never.lastCalledWith("a", nil)
			jestExpect(fn).lastCalledWith("a", nil, "b")
			jestExpect(function()
				jestExpect(fn).lastCalledWith("a", nil)
			end).toThrowErrorMatchingSnapshot()
			jestExpect(function()
				jestExpect(fn).never.lastCalledWith("a", nil, "b")
			end).toThrowErrorMatchingSnapshot()
		end)

		it("lastCalledWith complex call with nil", function()
			local fn = mock:fn()
			fn("a", { 1, 2 }, nil, nil)
			jestExpect(fn).lastCalledWith("a", { 1, 2 }, nil, nil)
			jestExpect(function()
				jestExpect(fn).lastCalledWith("a", { 1, 3 }, nil, "b")
			end).toThrowErrorMatchingSnapshot()
			jestExpect(function()
				jestExpect(fn).lastCalledWith("a", { 1, 2 }, nil)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("lastCalledWith complex multi-call with nil", function()
			local fn = mock:fn()
			fn("a", { 1, 2 })
			fn("a", { 1, 2 }, nil, nil)
			jestExpect(fn).lastCalledWith("a", { 1, 2 }, nil, nil)
			jestExpect(function()
				jestExpect(fn).lastCalledWith("a", { 1, 2 }, nil)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("toBeCalledWith single call", function()
			local fn = mock:fn()
			fn("a", "b", nil)
			jestExpect(fn).never.toBeCalledWith("a", "b")
			jestExpect(fn).toBeCalledWith("a", "b", nil)
			jestExpect(fn).never.toBeCalledWith("a", "b", nil, nil)
		end)

		it("toBeCalledWith multi-call", function()
			local fn = mock:fn()
			fn("a", "b", nil)
			fn("a", "b", nil, nil, 4)
			jestExpect(fn).never.toBeCalledWith("a", "b")
			jestExpect(fn).toBeCalledWith("a", "b", nil)
			jestExpect(fn).never.toBeCalledWith("a", "b", nil, nil)
			jestExpect(fn).toBeCalledWith("a", "b", nil, nil, 4)
			jestExpect(fn).never.toBeCalledWith("a", "b", nil, nil, 4, nil)
			jestExpect(function()
				jestExpect(fn).toBeCalledWith("a", "b")
			end).toThrowErrorMatchingSnapshot()
			jestExpect(function()
				jestExpect(fn).toBeCalledWith("a", "b", nil, nil, 4, nil)
			end).toThrowErrorMatchingSnapshot()
		end)

		it("lastCalledWith single call", function()
			local fn = mock:fn()
			fn("a", "b", nil)
			jestExpect(fn).never.lastCalledWith("a", "b")
			jestExpect(fn).lastCalledWith("a", "b", nil)
			jestExpect(fn).never.lastCalledWith("a", "b", nil, nil)
		end)

		it("lastCalledWith multi-call", function()
			local fn = mock:fn()
			fn("a", "b", nil)
			fn("a", "b", nil, nil, 4)
			jestExpect(fn).never.lastCalledWith("a", "b")
			jestExpect(fn).never.lastCalledWith("a", "b", nil, nil)
			jestExpect(fn).lastCalledWith("a", "b", nil, nil, 4)
			jestExpect(fn).never.lastCalledWith("a", "b", nil, nil, 4, nil)
		end)

		it("nthCalledWith single call", function()
			local fn = mock:fn()
			fn("a", "b", nil)
			jestExpect(fn).never.nthCalledWith(1, "a", "b")
			jestExpect(fn).nthCalledWith(1, "a", "b", nil)
			jestExpect(fn).never.nthCalledWith(1, "a", "b", nil, nil)
		end)

		it("nthCalledWith multi-call", function()
			local fn = mock:fn()
			fn("a", "b", nil)
			fn("a", "b", nil, nil, 4)
			jestExpect(fn).never.nthCalledWith(1, "a", "b")
			jestExpect(fn).nthCalledWith(1, "a", "b", nil)
			jestExpect(fn).never.nthCalledWith(1, "a", "b", nil, nil)
			jestExpect(fn).nthCalledWith(2, "a", "b", nil, nil, 4)
			jestExpect(fn).never.nthCalledWith(2, "a", "b", nil, nil, 4, nil)
		end)

		it("works with spies", function()
			local fn = mock:fn()
			fn("arg0", nil)
			jestExpect(createSpy(fn)).never.lastCalledWith("arg0")
			jestExpect(createSpy(fn)).lastCalledWith("arg0", nil)
		end)
	end)
end)

return {}
