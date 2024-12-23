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
--!strict
-- ROBLOX NOTE: no upstream
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local test = JestGlobals.test
local beforeEach = JestGlobals.beforeEach

local DataModelMocker = require("../DataModelMocker")

-- An example instance to be proxied by tests below.
local original
local mocker: DataModelMocker.DataModelMocker
beforeEach(function()
	original = Instance.new("TextLabel")
	original.Name = "The Example Instance"
	original.BackgroundColor3 = Color3.new(1, 1, 1)
	original.Size = UDim2.fromOffset(200, 50)
	original.Text = "I am a good example!"
	original.TextColor3 = Color3.new(0, 0, 0)
	original.Font = Enum.Font.BuilderSans

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 16)
	corner.Parent = original

	mocker = DataModelMocker.new()
end)

describe("mockInstance()", function()
	test("returns a complete instance proxy", function()
		local proxy = mocker:mockInstance(original)

		expect(proxy).toEqual(expect.any("table"))
		expect(proxy.spy.Name).toEqual(original.Name)
		expect(proxy.controls.mockMethod).toEqual(expect.any("function"))
	end)

	test("caches proxies when called again", function()
		expect(mocker:mockInstance(original) == mocker:mockInstance(original)).toBeTruthy()
	end)
end)
