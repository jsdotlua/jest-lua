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

local PrettyFormat = require("../init")
local prettyFormat = PrettyFormat.default
local RobloxInstance = PrettyFormat.plugins.RobloxInstance

local InstanceSubset = require("@pkg/@jsdotlua/jest-roblox-shared").RobloxInstance.InstanceSubset

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local beforeEach = JestGlobals.beforeEach
local afterEach = JestGlobals.afterEach
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local prettyFormatResult = function(val: any)
	return prettyFormat(val, {
		plugins = { RobloxInstance },
		printInstanceDefaults = true,
	})
end

describe("Instance", function()
	it("serializes ModuleScript", function()
		expect(prettyFormatResult(script)).toEqual(
			"ModuleScript {\n"
				.. '  "Archivable": true,\n'
				.. '  "ClassName": "ModuleScript",\n'
				.. '  "Name": "RobloxInstance.roblox.spec",\n'
				.. '  "Parent": "__tests__" [Folder],\n'
				.. "}"
		)
	end)

	it("serializes Folder", function()
		local stableFolder = script.Parent.__tests__.dont_touch_im_used_in_snapshots
		expect(prettyFormatResult(stableFolder)).toMatchSnapshot()
	end)

	it("serializes Instances in table", function()
		local SpotLight = Instance.new("SpotLight")
		local Sky = Instance.new("Sky")
		expect(prettyFormatResult({
			a = SpotLight,
			b = Sky,
		})).toMatchSnapshot()
		SpotLight:Destroy()
		Sky:Destroy()
	end)

	it("serializes nested Roblox Instance", function()
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "Root"

		local exampleData = {
			{
				name = "hello-roact",
				label = "Hello, Roact!",
			},
			{
				name = "clock",
				label = "Clock",
			},
			{
				name = "changed-signal",
				label = "Changed Signal",
			},
			{
				name = "stress-test",
				label = "Stress Test",
			},
			{
				name = "event",
				label = "Event",
			},
			{
				name = "ref",
				label = "Ref",
			},
			{
				name = "binding",
				label = "Binding",
			},
		}

		local exampleList = Instance.new("ScrollingFrame")
		exampleList.Size = UDim2.new(0, 400, 0, 600)
		exampleList.CanvasSize = UDim2.new(0, 400, 0, 80 * #exampleData)
		exampleList.Position = UDim2.new(0.5, 0, 0.5, 0)
		exampleList.AnchorPoint = Vector2.new(0.5, 0.5)
		exampleList.BorderSizePixel = 2
		exampleList.BackgroundColor3 = Color3.new(1, 1, 1)
		exampleList.TopImage = "rbxassetid://29050676"
		exampleList.MidImage = "rbxassetid://29050676"
		exampleList.BottomImage = "rbxassetid://29050676"
		exampleList.Parent = screenGui

		local listLayout = Instance.new("UIListLayout")
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Parent = exampleList

		for index, example in ipairs(exampleData) do
			local label = ("%s: examples/%s"):format(example.label, example.name)

			local exampleCard = Instance.new("TextButton")
			exampleCard.Name = "Example: " .. example.name
			exampleCard.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
			exampleCard.BorderSizePixel = 0
			exampleCard.Text = label
			exampleCard.Font = Enum.Font.SourceSans
			exampleCard.TextSize = 20
			exampleCard.Size = UDim2.new(1, 0, 0, 80)
			exampleCard.LayoutOrder = index

			exampleCard.Parent = exampleList

			local bottomBorder = Instance.new("Frame")
			bottomBorder.Name = "Bottom Border"
			bottomBorder.Position = UDim2.new(0, 0, 1, -1)
			bottomBorder.Size = UDim2.new(0, 400, 0, 1)
			bottomBorder.BorderSizePixel = 0
			bottomBorder.BackgroundColor3 = Color3.new(0, 0, 0)
			bottomBorder.ZIndex = 2
			bottomBorder.Parent = exampleCard
		end

		expect(prettyFormatResult(screenGui)).toMatchSnapshot()
		screenGui:Destroy()
	end)

	it("collapses circular references in properties", function()
		local leftFrame = Instance.new("ScrollingFrame")
		local rightFrame = Instance.new("ScrollingFrame")
		leftFrame.Name = "LeftFrame"
		rightFrame.Name = "RightFrame"
		leftFrame.NextSelectionRight = rightFrame
		rightFrame.NextSelectionRight = leftFrame

		expect(prettyFormatResult(leftFrame)).toMatchSnapshot()
		leftFrame:Destroy()
		rightFrame:Destroy()
	end)
end)

describe("InstanceSubset", function()
	it("serializes a subset of Frame", function()
		local frame = InstanceSubset.new("Frame", { Name = "ParentFrame" })

		expect(prettyFormatResult(frame)).toEqual("Frame {\n" .. '  "Name": "ParentFrame",\n' .. "}")
	end)

	it("serializes nested InstanceSubsets", function()
		local childFrame = InstanceSubset.new("Frame", { Name = "ChildFrame" })
		local frame = InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			ChildFrame = childFrame,
		})

		expect(prettyFormatResult(frame)).toEqual(
			"Frame {\n"
				.. '  "ChildFrame": Frame {\n'
				.. '    "Name": "ChildFrame",\n'
				.. "  },\n"
				.. '  "Name": "ParentFrame",\n'
				.. "}"
		)
	end)
end)

describe("config.printInstanceDefaults", function()
	local created
	beforeEach(function()
		created = Instance.new("TextLabel")
	end)
	afterEach(function()
		created:Destroy()
	end)

	local prettyFormatResult = function(val: any)
		return prettyFormat(val, {
			plugins = { RobloxInstance },
			printInstanceDefaults = false,
		})
	end

	it("serializes unmodified Instances", function()
		expect(prettyFormatResult(created)).toEqual("TextLabel {}")
	end)

	it("serializes modified values", function()
		created.Name = "ModifiedTextLabel"
		created.TextColor3 = Color3.new(1, 0, 0)
		expect(prettyFormatResult(created)).toEqual(
			"TextLabel {\n" .. '  "Name": "ModifiedTextLabel",\n' .. '  "TextColor3": Color3(1, 0, 0),\n' .. "}"
		)
	end)

	it("serializes nested Instances", function()
		created.Name = "ParentInstance"
		local child = Instance.new("TextLabel")
		child.Parent = created
		expect(prettyFormatResult(created)).toEqual(
			"TextLabel {\n"
				.. '  "Name": "ParentInstance",\n'
				.. '  "TextLabel": TextLabel {\n'
				.. '    "Parent": "ParentInstance" [TextLabel],\n'
				.. "  },\n"
				.. "}"
		)
	end)
end)
