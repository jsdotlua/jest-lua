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

local InstanceProxy = require("./InstanceProxy")

-- An example instance to be proxied by tests below.
local original
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
end)

describe("spy transparency", function()
	test("properties can be read", function()
		local spy = InstanceProxy.new(original).spy

		expect(spy.Name).toBe("The Example Instance")

		original.Name = "Pamela"
		expect(spy.Name).toBe("Pamela")
	end)

	test("properties can be written", function()
		local spy = InstanceProxy.new(original).spy

		expect(function()
			spy.Name = "Susan"
		end).never.toThrow()

		expect(spy.Name).toBe("Susan")
		expect(original.Name).toBe("Susan")
	end)

	test("methods can be called", function()
		local spy = InstanceProxy.new(original).spy

		expect(spy:IsA("GuiObject")).toBe(true)
	end)

	test("events can be listened to", function(_, done)
		local spy = InstanceProxy.new(original).spy

		local numFires = 0

		expect(function()
			spy.Changed:Connect(function()
				numFires += 1
			end)
		end).never.toThrow()

		expect(numFires).toBe(0)

		original.Name = "Pamela"
		-- in Deferred SignalBehaviour, this is required
		task.defer(function()
			expect(numFires).toBe(1)
			done()
		end)
	end)

	test("callbacks can be assigned and invoked", function()
		local bindable = Instance.new("BindableFunction")
		local spy = InstanceProxy.new(bindable).spy

		local accumulator = 0

		expect(function()
			spy.OnInvoke = function(number)
				accumulator += number
			end
		end).never.toThrow()

		bindable:Invoke(24)
		expect(accumulator).toBe(24)
	end)

	test("tostring behaviour", function()
		local spy = InstanceProxy.new(original).spy

		expect(tostring(spy)).toEqual(tostring(original))
	end)

	test("correctly-locked metatable", function()
		local spy = InstanceProxy.new(original).spy

		expect(getmetatable(spy :: any)).toEqual(getmetatable(original :: any))
	end)
end)

describe("mocking behaviour", function()
	test("methods can be mocked and unmocked", function()
		local proxy = InstanceProxy.new(original)

		local unmock = proxy.controls:mockMethod("IsA", function(_, class: string)
			return class == "Sausage Roll"
		end)

		expect(proxy.spy:IsA("GuiObject")).toBe(false)
		expect(proxy.spy:IsA("Sausage Roll" :: any)).toBe(true)

		expect(original:IsA("GuiObject")).toBe(true)

		unmock()

		expect(proxy.spy:IsA("GuiObject")).toBe(true)
		expect(proxy.spy:IsA("Sausage Roll" :: any)).toBe(false)
	end)

	test("method unmock is ignored after multiple calls", function()
		local proxy = InstanceProxy.new(original)

		local unmock = proxy.controls:mockMethod("IsA", function(_, class: string)
			return class == "Sausage Roll"
		end)

		expect(function()
			unmock()
			unmock()
			unmock()
		end).never.toThrow()
	end)

	test("method unmock is ignored after being replaced", function()
		local proxy = InstanceProxy.new(original)

		local unmockSausage = proxy.controls:mockMethod("IsA", function(_, class: string)
			return class == "Sausage Roll"
		end)

		proxy.controls:mockMethod("IsA", function(_, class: string)
			return class == "Egg Sandwich"
		end)

		unmockSausage()

		expect(proxy.spy:IsA("GuiObject")).toBe(false)
		expect(proxy.spy:IsA("Sausage Roll" :: any)).toBe(false)
		expect(proxy.spy:IsA("Egg Sandwich" :: any)).toBe(true)
	end)

	test("method mock passes correct arguments", function()
		local proxy = InstanceProxy.new(original)

		proxy.controls:mockMethod("IsA", function(self, class)
			expect(self).never.toEqual(original)
			expect(self).toEqual(proxy.spy)
			expect(class).toEqual(expect.any("string"))
		end)

		proxy.spy:IsA("GuiObject")
	end)
end)
