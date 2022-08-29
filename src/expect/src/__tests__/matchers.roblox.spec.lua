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
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll
local afterAll = JestGlobals.afterAll

local jestExpect = require(CurrentModule)

local chalk = require(Packages.Dev.ChalkLua)
local alignedAnsiStyleSerializer = require(Packages.Dev.TestUtils).alignedAnsiStyleSerializer

local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local Set = LuauPolyfill.Set

local CustomClass = {}
CustomClass.__index = CustomClass

function CustomClass.new()
	return setmetatable({ foo = true }, CustomClass)
end

local screenGui
beforeAll(function()
	jestExpect.addSnapshotSerializer(alignedAnsiStyleSerializer)

	screenGui = Instance.new("ScreenGui")
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
end)

afterAll(function()
	jestExpect.resetSnapshotSerializers()
end)

-- test cases devised from https://github.com/Roblox/jest-roblox/pull/27#discussion_r561374828
it("tests toStrictEqual matcher with example class", function()
	jestExpect(CustomClass.new()).never.toBe(CustomClass.new()) -- not the same table
	jestExpect(CustomClass.new()).toStrictEqual(CustomClass.new()) -- not the same table, but same shape and same class
	jestExpect(CustomClass.new()).never.toStrictEqual({ foo = true }) -- same shape but not same class
	jestExpect(CustomClass.new()).toEqual({ foo = true }) -- same shape
end)

-- test case taken from Jest docs
local LaCroix = {}
LaCroix.__index = LaCroix
function LaCroix.new(flavor)
	return setmetatable({
		flavor = flavor,
	}, LaCroix)
end

it("the La Croix cans on my desk are not semantically the same", function()
	jestExpect(LaCroix.new("lemon")).toEqual({ flavor = "lemon" })
	jestExpect(LaCroix.new("lemon")).never.toStrictEqual({ flavor = "lemon" })
end)

it("tests the set polyfill", function()
	jestExpect(Set.new({ 1, 2, 5 })).toEqual(Set.new({ 2, 5, 1 }))
	jestExpect(Set.new({ 1, 2, 6 })).never.toEqual(Set.new({ 1, 2, 5 }))
	jestExpect(Set.new({ { 1, 2 }, { 3, 4 } })).toEqual(Set.new({ { 3, 4 }, { 1, 2 } }))
	jestExpect(Set.new({ { 1, 2 }, { 3, 4 } })).never.toEqual(Set.new({ { 1, 2 }, { 3, 5 } }))
	jestExpect(Set.new({ "a" })).toContain("a")
end)

describe("chalk tests", function()
	it("tests basic chalked string", function()
		jestExpect(chalk.red("i am chalked")).toMatch("i am chalked")
		jestExpect(chalk.red("i am chalked")).toMatch(chalk.red("i am chalked"))
	end)

	it("tests nested chalk string", function()
		local nestedStyle = chalk.red .. chalk.bold .. chalk.bgYellow
		jestExpect(nestedStyle("i am heavily chalked")).toMatch("i am heavily chalked")
		jestExpect(nestedStyle("i am heavily chalked")).toMatch(chalk.bgYellow("i am heavily chalked"))
		jestExpect(nestedStyle("i am heavily chalked")).toMatch(chalk.bold(chalk.bgYellow("i am heavily chalked")))
		jestExpect(nestedStyle("i am heavily chalked")).toMatch(nestedStyle("i am heavily chalked"))

		jestExpect(nestedStyle("i am heavily chalked")).never.toMatch(chalk.red("i am heavily chalked"))
	end)
end)

local nestedFn = function(fn)
	local success, result = pcall(function()
		fn()
	end)
	if not success then
		error(result)
	end
end

it("tests stack traces for calls within pcalls", function()
	jestExpect(function()
		jestExpect(function()
			nestedFn(function()
				jestExpect(4).toBe(2)
			end)
		end).never.toThrow()
	end).toThrowErrorMatchingSnapshot()
end)

local nestedFnWithError = function(fn)
	local success, result = pcall(function()
		fn()
	end)
	if not success then
		error(Error(result))
	end
end

-- TODO: ADO-1716 unskip this test and determine how to reconcile behavior
it.skip("tests stack traces for calls within pcalls with Error polyfill", function()
	jestExpect(function()
		jestExpect(function()
			nestedFnWithError(function()
				jestExpect(4).toBe(2)
			end)
		end).never.toThrow()
	end).toThrowErrorMatchingSnapshot()
end)

describe("Instance matchers", function()
	describe(".toMatchInstance", function()
		it("matches properties of instance", function()
			jestExpect(screenGui).toMatchInstance({
				Name = "Root",
				ClassName = "ScreenGui",
			})
		end)

		it("matches properties of children", function()
			jestExpect(screenGui).toMatchInstance({
				["ScrollingFrame"] = {
					Size = UDim2.new(0, 400, 0, 600),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					TopImage = "rbxassetid://29050676",
				},
			})
		end)

		it("matches subset of instance", function()
			jestExpect(screenGui).toMatchInstance({
				ClassName = "ScreenGui",
				AbsolutePosition = Vector2.new(0, 0),
				["ScrollingFrame"] = {
					AbsolutePosition = Vector2.new(200, 0),
					MidImage = "rbxassetid://29050676",
					["Example: binding"] = {
						["Bottom Border"] = {
							AbsoluteRotation = 0,
						},
					},
					["Example: changed-signal"] = {
						["Bottom Border"] = {
							ClassName = "Frame",
						},
					},
				},
			})
		end)

		it("does not match properties of instance", function()
			jestExpect(function()
				jestExpect(screenGui).toMatchInstance({
					ClassName = "Frame",
				})
			end).toThrowErrorMatchingSnapshot()
		end)

		it("does not match subset of instance", function()
			jestExpect(function()
				jestExpect(screenGui).toMatchInstance({
					ClassName = "ScreenGui",
					Name = "Root",
					["ScrollingFrame"] = {
						AbsolutePosition = Vector2.new(100, 100),
						["Example: wrongname"] = {
							["Bottom Border"] = {
								ClassName = "Frame",
							},
						},
					},
				})
			end).toThrowErrorMatchingSnapshot()
		end)

		it("works with asymmetric matchers", function()
			jestExpect(function()
				jestExpect(screenGui).toMatchInstance({
					AbsolutePosition = jestExpect.any("Vector3"),
					["ScrollingFrame"] = {
						MidImage = jestExpect.stringMatching("foobar"),
					},
				})
			end).toThrowErrorMatchingSnapshot()
		end)
	end)

	describe(".toMatchSnapshot", function()
		it("matches instance against snapshot", function()
			jestExpect(screenGui).toMatchSnapshot()
		end)

		it.skip("matches instance against snapshot with fuzzy values", function()
			local frame = Instance.new("Frame")
			frame.Position = UDim2.fromOffset(math.random(0, 100), math.random(0, 100))
			jestExpect(frame).toMatchSnapshot({
				Position = jestExpect.any("UDim2"),
			})
		end)
	end)
end)

return {}
