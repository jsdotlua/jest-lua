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

local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local RobloxInstance = require(CurrentModule.RobloxInstance)
local instanceSubsetEquality = RobloxInstance.instanceSubsetEquality
local getInstanceSubset = RobloxInstance.getInstanceSubset
local listProps = RobloxInstance.listProps
local listDefaultProps = RobloxInstance.listDefaultProps
local InstanceSubset = RobloxInstance.InstanceSubset

describe("listDefaultProps()", function()
	it("doesn't return properties for abstract superclasses", function()
		expect(function()
			listDefaultProps("Instance")
		end).toThrow("abstract or not creatable")
	end)

	it("doesn't return protected properties", function()
		expect(listDefaultProps("ModuleScript")).never.toHaveProperty("Source")
	end)

	it("doesn't return hidden properties", function()
		expect(listDefaultProps("TextLabel")).never.toHaveProperty("LocalizedText")
		expect(listDefaultProps("TextLabel")).never.toHaveProperty("Transparency")
	end)

	it("returns inherited properties", function()
		expect(listDefaultProps("Part")).toHaveProperty("Anchored")
	end)

	it("returns nil properties as None", function()
		expect(listDefaultProps("Part")).toHaveProperty("Parent", Object.None)
	end)

	it("returns default properties and values for TextLabel", function()
		local defaults = listDefaultProps("TextLabel")
		expect(defaults).toMatchSnapshot()
	end)

	it("returns default properties and values for Camera", function()
		local defaults = listDefaultProps("Camera")
		expect(defaults).toMatchSnapshot()
	end)
end)

describe("listProps()", function()
	it("returns properties for a simple instance", function()
		local simpleInstance = Instance.new("ObjectValue")
		simpleInstance.Name = "Bryan"
		simpleInstance.Value = simpleInstance
		expect(listProps(simpleInstance)).toEqual({
			Archivable = true,
			ClassName = "ObjectValue",
			Name = "Bryan",
			Parent = Object.None,
			Value = simpleInstance,
		})
	end)

	it("doesn't return protected properties", function()
		local moduleScript = Instance.new("ModuleScript")
		expect(listProps(moduleScript)).never.toHaveProperty("Source")
	end)

	it("doesn't return hidden properties", function()
		local textLabel = Instance.new("TextLabel")
		expect(listProps(textLabel)).never.toHaveProperty("LocalizedText")
		expect(listProps(textLabel)).never.toHaveProperty("Transparency")
	end)

	it("returns inherited properties", function()
		local part = Instance.new("Part")
		expect(listProps(part)).toHaveProperty("Anchored")
	end)

	it("returns nil properties as None", function()
		local part = Instance.new("Part")
		expect(listProps(part)).toHaveProperty("Parent", Object.None)
	end)

	it("returns properties and values for TextLabel", function()
		local props = listProps(Instance.new("TextLabel"))
		expect(props).toMatchSnapshot()
	end)

	it("returns properties and values for Camera", function()
		local props = listProps(Instance.new("Camera"))
		expect(props).toMatchSnapshot()
	end)
end)

describe("instanceSubsetEquality()", function()
	local parentFrame = Instance.new("Frame")
	parentFrame.Name = "ParentFrame"

	local childFrame = Instance.new("Frame")
	childFrame.Parent = parentFrame
	childFrame.Name = "ChildFrame"

	it("matching Instance returns true", function()
		expect(instanceSubsetEquality(parentFrame, { Name = "ParentFrame", ClassName = "Frame" })).toBe(true)
	end)

	it("Instance does not match", function()
		expect(instanceSubsetEquality(parentFrame, { Name = "ParentFrame", ClassName = "TextButton" })).toBe(false)
	end)

	it("Instance does not have property", function()
		expect(instanceSubsetEquality(parentFrame, { Foo = "Bar" })).toBe(false)
	end)

	it("table without keys is undefined", function()
		expect(instanceSubsetEquality(parentFrame, { 1, 2, 3 })).toBeNil()
	end)

	it("non table subset is undefined", function()
		expect(instanceSubsetEquality(parentFrame, 1)).toBeNil()
	end)

	it("non Instance object is undefined", function()
		expect(instanceSubsetEquality({}, { Foo = "Bar" })).toBeNil()
	end)

	it("returns false for circular references", function()
		local circularObjA = {}
		local circularObjB = { Parent = circularObjA }
		circularObjA.Parent = circularObjB

		expect(instanceSubsetEquality(parentFrame, circularObjA)).toBe(false)
	end)

	it("returns true if child matches subset", function()
		expect(instanceSubsetEquality(parentFrame, {
			Name = "ParentFrame",
			ChildFrame = {
				Name = "ChildFrame",
			},
		})).toBe(true)
	end)

	it("returns false if child does not match subset", function()
		expect(instanceSubsetEquality(parentFrame, {
			Name = "ParentFrame",
			ChildFrame = {
				Name = "Foo",
			},
		})).toBe(false)
	end)

	it("returns false if child does not exist", function()
		expect(instanceSubsetEquality(parentFrame, {
			Name = "ParentFrame",
			ChildButton = {
				Name = "ChildFrame",
			},
		})).toBe(false)
	end)

	it("returns true if nested Instance matches", function()
		expect(instanceSubsetEquality(childFrame, {
			Name = "ChildFrame",
			Parent = {
				Name = "ParentFrame",
			},
		})).toBe(true)
	end)

	it("returns false if nested Instance does not match", function()
		expect(instanceSubsetEquality(childFrame, {
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
		expect(received).toEqual(InstanceSubset.new("Frame", { Name = "ParentFrame" }))
		expect(expected).toEqual(InstanceSubset.new("Frame", { Name = "ParentFrame" }))
	end)

	it("only returns matching subset", function()
		local subset = {
			Name = "ParentFrame",
			Foo = "Bar",
		}
		local received, expected = getInstanceSubset(parentFrame, subset)
		expect(received).toEqual(InstanceSubset.new("Frame", { Name = "ParentFrame" }))
		expect(expected).toEqual(InstanceSubset.new("Frame", {
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
		expect(received).toEqual(InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			ChildFrame = InstanceSubset.new("Frame", {
				Name = "ChildFrame",
			}),
		}))
		expect(expected).toEqual(InstanceSubset.new("Frame", {
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
		expect(received).toEqual(InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			ChildFrame = InstanceSubset.new("Frame", {
				Name = "ChildFrame",
			}),
		}))
		expect(expected).toEqual(InstanceSubset.new("Frame", {
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
		expect(received).toEqual(InstanceSubset.new("Frame", { Name = "ParentFrame" }))
		expect(expected).toEqual(InstanceSubset.new("Frame", { Name = "ChildFrame" }))
	end)

	it("mismatched ClassName", function()
		local subset = {
			Name = "ParentFrame",
			ClassName = "ScrollingFrame",
		}
		local received, expected = getInstanceSubset(parentFrame, subset)
		expect(received).toEqual(InstanceSubset.new("Frame", {
			Name = "ParentFrame",
			ClassName = "Frame",
		}))
		expect(expected).toEqual(InstanceSubset.new("ScrollingFrame", {
			Name = "ParentFrame",
			ClassName = "ScrollingFrame",
		}))
	end)
end)
