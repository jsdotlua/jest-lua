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
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local RobloxInstance = require(CurrentModule.RobloxInstance)
local instanceSubsetEquality = RobloxInstance.instanceSubsetEquality
local getInstanceSubset = RobloxInstance.getInstanceSubset
local getRobloxProperties = RobloxInstance.getRobloxProperties
local InstanceSubset = RobloxInstance.InstanceSubset

describe("getRobloxProperties()", function()
	it("returns properties for Instance", function()
		jestExpect(getRobloxProperties("Instance")).toEqual({ "Archivable", "ClassName", "Name", "Parent" })
	end)

	it("doesn't return protected properties", function()
		jestExpect(getRobloxProperties("ModuleScript")).never.toContain({ "Source" })
	end)

	it("doesn't return hidden properties", function()
		jestExpect(getRobloxProperties("TextLabel")).never.toContain({ "LocalizedText", "Transparency" })
	end)

	it("returns all properties and inherited properties of Frame", function()
		jestExpect(getRobloxProperties("Frame")).toEqual({
			"AbsolutePosition",
			"AbsoluteRotation",
			"AbsoluteSize",
			"Active",
			"AnchorPoint",
			"Archivable",
			"AutoLocalize",
			"AutomaticSize",
			"BackgroundColor3",
			"BackgroundTransparency",
			"BorderColor3",
			"BorderMode",
			"BorderSizePixel",
			"ClassName",
			"ClipsDescendants",
			"LayoutOrder",
			"Name",
			"NextSelectionDown",
			"NextSelectionLeft",
			"NextSelectionRight",
			"NextSelectionUp",
			"Parent",
			"Position",
			"RootLocalizationTable",
			"Rotation",
			"Selectable",
			"SelectionImageObject",
			"Size",
			"SizeConstraint",
			"Style",
			"Visible",
			"ZIndex",
		})
	end)
end)

describe("instanceSubsetEquality()", function()
	local parentFrame = Instance.new("Frame")
	parentFrame.Name = "ParentFrame"

	local childFrame = Instance.new("Frame")
	childFrame.Parent = parentFrame
	childFrame.Name = "ChildFrame"

	it("matching Instance returns true", function()
		jestExpect(instanceSubsetEquality(parentFrame, { Name = "ParentFrame", ClassName = "Frame" })).toBe(true)
	end)

	it("Instance does not match", function()
		jestExpect(instanceSubsetEquality(parentFrame, { Name = "ParentFrame", ClassName = "TextButton" })).toBe(false)
	end)

	it("Instance does not have property", function()
		jestExpect(instanceSubsetEquality(parentFrame, { Foo = "Bar" })).toBe(false)
	end)

	it("table without keys is undefined", function()
		jestExpect(instanceSubsetEquality(parentFrame, { 1, 2, 3 })).toBeNil()
	end)

	it("non table subset is undefined", function()
		jestExpect(instanceSubsetEquality(parentFrame, 1)).toBeNil()
	end)

	it("non Instance object is undefined", function()
		jestExpect(instanceSubsetEquality({}, { Foo = "Bar" })).toBeNil()
	end)

	it("returns false for circular references", function()
		local circularObjA = {}
		local circularObjB = { Parent = circularObjA }
		circularObjA.Parent = circularObjB

		jestExpect(instanceSubsetEquality(parentFrame, circularObjA)).toBe(false)
	end)

	it("returns true if child matches subset", function()
		jestExpect(instanceSubsetEquality(parentFrame, {
			Name = "ParentFrame",
			ChildFrame = {
				Name = "ChildFrame",
			},
		})).toBe(true)
	end)

	it("returns false if child does not match subset", function()
		jestExpect(instanceSubsetEquality(parentFrame, {
			Name = "ParentFrame",
			ChildFrame = {
				Name = "Foo",
			},
		})).toBe(false)
	end)

	it("returns false if child does not exist", function()
		jestExpect(instanceSubsetEquality(parentFrame, {
			Name = "ParentFrame",
			ChildButton = {
				Name = "ChildFrame",
			},
		})).toBe(false)
	end)

	it("returns true if nested Instance matches", function()
		jestExpect(instanceSubsetEquality(childFrame, {
			Name = "ChildFrame",
			Parent = {
				Name = "ParentFrame",
			},
		})).toBe(true)
	end)

	it("returns false if nested Instance does not match", function()
		jestExpect(instanceSubsetEquality(childFrame, {
			Name = "ChildFrame",
			Parent = {
				Name = "Frame",
			},
		})).toBe(false)
	end)
end)

describe("getInstanceSubset()", function()
	local parentFrame = Instance.new("Frame")
	parentFrame.Name = "ParentFrame"

	local childFrame = Instance.new("Frame")
	childFrame.Parent = parentFrame
	childFrame.Name = "ChildFrame"

	it("returns subset", function()
		local subset = { Name = "ParentFrame" }
		local received, expected = getInstanceSubset(parentFrame, subset)
		jestExpect(received).toEqual(InstanceSubset.new("Frame", { Name = "ParentFrame" }))
		jestExpect(expected).toEqual(InstanceSubset.new("Frame", { Name = "ParentFrame" }))
	end)

	it("only returns matching subset", function()
		local subset = {
			Name = "ParentFrame",
			Foo = "Bar",
		}
		local received, expected = getInstanceSubset(parentFrame, subset)
		jestExpect(received).toEqual(InstanceSubset.new("Frame", { Name = "ParentFrame" }))
		jestExpect(expected).toEqual(InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			Foo = "Bar",
		}))
	end)

	it("returns subset of child", function()
		local subset = {
			Name = "ParentFrame",
			ChildFrame = {
				Name = "ChildFrame",
			},
		}
		local received, expected = getInstanceSubset(parentFrame, subset)
		jestExpect(received).toEqual(InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			ChildFrame = InstanceSubset.new("Frame", {
				Name = "ChildFrame",
			}),
		}))
		jestExpect(expected).toEqual(InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			ChildFrame = InstanceSubset.new("Frame", {
				Name = "ChildFrame",
			}),
		}))
	end)

	it("returns only matching subset of child", function()
		local subset = {
			Name = "ParentFrame",
			ChildFrame = {
				Name = "ChildFrame",
				Foo = "Bar",
			},
		}
		local received, expected = getInstanceSubset(parentFrame, subset)
		jestExpect(received).toEqual(InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			ChildFrame = InstanceSubset.new("Frame", {
				Name = "ChildFrame",
			}),
		}))
		jestExpect(expected).toEqual(InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			ChildFrame = InstanceSubset.new("Frame", {
				Name = "ChildFrame",
				Foo = "Bar",
			}),
		}))
	end)

	it("mismatched Name", function()
		local subset = {
			Name = "ChildFrame",
		}
		local received, expected = getInstanceSubset(parentFrame, subset)
		jestExpect(received).toEqual(InstanceSubset.new("Frame", { Name = "ParentFrame" }))
		jestExpect(expected).toEqual(InstanceSubset.new("Frame", { Name = "ChildFrame" }))
	end)

	it("mismatched ClassName", function()
		local subset = {
			Name = "ParentFrame",
			ClassName = "ScrollingFrame",
		}
		local received, expected = getInstanceSubset(parentFrame, subset)
		jestExpect(received).toEqual(InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			ClassName = "Frame",
		}))
		jestExpect(expected).toEqual(InstanceSubset.new("ScrollingFrame", {
			Name = "ParentFrame",
			ClassName = "ScrollingFrame",
		}))
	end)
end)

return {}
