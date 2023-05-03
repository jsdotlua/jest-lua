-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-reporters/src/__tests__/VerboseReporter.test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local function wrap(obj)
	return { suites = obj, tests = {}, title = "" }
end

local groupTestsBySuites

beforeEach(function()
	local VerboseReporter = require(CurrentModule.VerboseReporter).default
	groupTestsBySuites = VerboseReporter.groupTestsBySuites
end)

describe("groupTestsBySuites", function()
	it("should handle empty results", function()
		expect(groupTestsBySuites({})).toEqual(wrap({}))
	end)

	it("should group A1 in A", function()
		expect(groupTestsBySuites({
			{
				ancestorTitles = { "A" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "A1",
			},
		})).toEqual(wrap({
			{
				suites = {},
				tests = {
					{
						ancestorTitles = { "A" },
						failureMessages = {},
						numPassingAsserts = 1,
						title = "A1",
					},
				},
				title = "A",
			},
		}))
	end)

	it("should group A1 in A; B1 in B", function()
		expect(groupTestsBySuites({
			{
				ancestorTitles = { "A" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "A1",
			},
			{
				ancestorTitles = { "B" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "B1",
			},
		})).toEqual(wrap({
			{
				suites = {},
				tests = {
					{
						ancestorTitles = { "A" },
						failureMessages = {},
						numPassingAsserts = 1,
						title = "A1",
					},
				},
				title = "A",
			},
			{
				suites = {},
				tests = {
					{
						ancestorTitles = { "B" },
						failureMessages = {},
						numPassingAsserts = 1,
						title = "B1",
					},
				},
				title = "B",
			},
		}))
	end)

	it("should group A1, A2 in A", function()
		expect(groupTestsBySuites({
			{
				ancestorTitles = { "A" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "A1",
			},
			{
				ancestorTitles = { "A" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "A2",
			},
		})).toEqual(wrap({
			{
				suites = {},
				tests = {
					{
						ancestorTitles = { "A" },
						failureMessages = {},
						numPassingAsserts = 1,
						title = "A1",
					},
					{
						ancestorTitles = { "A" },
						failureMessages = {},
						numPassingAsserts = 1,
						title = "A2",
					},
				},
				title = "A",
			},
		}))
	end)

	it("should group A1, A2 in A; B1, B2 in B", function()
		expect(groupTestsBySuites({
			{
				ancestorTitles = { "A" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "A1",
			},
			{
				ancestorTitles = { "A" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "A2",
			},
			{
				ancestorTitles = { "B" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "B1",
			},
			{
				ancestorTitles = { "B" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "B2",
			},
		})).toEqual(wrap({
			{
				suites = {},
				tests = {
					{
						ancestorTitles = { "A" },
						failureMessages = {},
						numPassingAsserts = 1,
						title = "A1",
					},
					{
						ancestorTitles = { "A" },
						failureMessages = {},
						numPassingAsserts = 1,
						title = "A2",
					},
				},
				title = "A",
			},
			{
				suites = {},
				tests = {
					{
						ancestorTitles = { "B" },
						failureMessages = {},
						numPassingAsserts = 1,
						title = "B1",
					},
					{
						ancestorTitles = { "B" },
						failureMessages = {},
						numPassingAsserts = 1,
						title = "B2",
					},
				},
				title = "B",
			},
		}))
	end)

	it("should group AB1 in AB", function()
		expect(groupTestsBySuites({
			{
				ancestorTitles = { "A", "B" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "AB1",
			},
		})).toEqual(wrap({
			{
				suites = {
					{
						suites = {},
						tests = {
							{
								ancestorTitles = { "A", "B" },
								failureMessages = {},
								numPassingAsserts = 1,
								title = "AB1",
							},
						},
						title = "B",
					},
				},
				tests = {},
				title = "A",
			},
		}))
	end)

	it("should group AB1, AB2 in AB", function()
		expect(groupTestsBySuites({
			{
				ancestorTitles = { "A", "B" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "AB1",
			},
			{
				ancestorTitles = { "A", "B" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "AB2",
			},
		})).toEqual(wrap({
			{
				suites = {
					{
						suites = {},
						tests = {
							{
								ancestorTitles = { "A", "B" },
								failureMessages = {},
								numPassingAsserts = 1,
								title = "AB1",
							},
							{
								ancestorTitles = { "A", "B" },
								failureMessages = {},
								numPassingAsserts = 1,
								title = "AB2",
							},
						},
						title = "B",
					},
				},
				tests = {},
				title = "A",
			},
		}))
	end)

	it("should group A1 in A; AB1 in AB", function()
		expect(groupTestsBySuites({
			{
				ancestorTitles = { "A" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "A1",
			},
			{
				ancestorTitles = { "A", "B" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "AB1",
			},
		})).toEqual(wrap({
			{
				suites = {
					{
						suites = {},
						tests = {
							{
								ancestorTitles = { "A", "B" },
								failureMessages = {},
								numPassingAsserts = 1,
								title = "AB1",
							},
						},
						title = "B",
					},
				},
				tests = {
					{
						ancestorTitles = { "A" },
						failureMessages = {},
						numPassingAsserts = 1,
						title = "A1",
					},
				},
				title = "A",
			},
		}))
	end)

	it("should group AB1 in AB; A1 in A", function()
		expect(groupTestsBySuites({
			{
				ancestorTitles = { "A", "B" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "AB1",
			},
			{
				ancestorTitles = { "A" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "A1",
			},
		})).toEqual(wrap({
			{
				suites = {
					{
						suites = {},
						tests = {
							{
								ancestorTitles = { "A", "B" },
								failureMessages = {},
								numPassingAsserts = 1,
								title = "AB1",
							},
						},
						title = "B",
					},
				},
				tests = {
					{
						ancestorTitles = { "A" },
						failureMessages = {},
						numPassingAsserts = 1,
						title = "A1",
					},
				},
				title = "A",
			},
		}))
	end)

	it("should group AB1 in AB; CD1 in CD", function()
		expect(groupTestsBySuites({
			{
				ancestorTitles = { "A", "B" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "AB1",
			},
			{
				ancestorTitles = { "C", "D" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "CD1",
			},
		})).toEqual(wrap({
			{
				suites = {
					{
						suites = {},
						tests = {
							{
								ancestorTitles = { "A", "B" },
								failureMessages = {},
								numPassingAsserts = 1,
								title = "AB1",
							},
						},
						title = "B",
					},
				},
				tests = {},
				title = "A",
			},
			{
				suites = {
					{
						suites = {},
						tests = {
							{
								ancestorTitles = { "C", "D" },
								failureMessages = {},
								numPassingAsserts = 1,
								title = "CD1",
							},
						},
						title = "D",
					},
				},
				tests = {},
				title = "C",
			},
		}))
	end)

	it("should group ABC1 in ABC; BC1 in BC; D1 in D; A1 in A", function()
		expect(groupTestsBySuites({
			{
				ancestorTitles = { "A", "B", "C" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "ABC1",
			},
			{
				ancestorTitles = { "B", "C" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "BC1",
			},
			{
				ancestorTitles = { "D" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "D1",
			},
			{
				ancestorTitles = { "A" },
				failureMessages = {},
				numPassingAsserts = 1,
				title = "A1",
			},
		})).toEqual(wrap({
			{
				suites = {
					{
						suites = {
							{
								suites = {},
								tests = {
									{
										ancestorTitles = { "A", "B", "C" },
										failureMessages = {},
										numPassingAsserts = 1,
										title = "ABC1",
									},
								},
								title = "C",
							},
						},
						tests = {},
						title = "B",
					},
				},
				tests = {
					{
						ancestorTitles = { "A" },
						failureMessages = {},
						numPassingAsserts = 1,
						title = "A1",
					},
				},
				title = "A",
			},
			{
				suites = {
					{
						suites = {},
						tests = {
							{
								ancestorTitles = { "B", "C" },
								failureMessages = {},
								numPassingAsserts = 1,
								title = "BC1",
							},
						},
						title = "C",
					},
				},
				tests = {},
				title = "B",
			},
			{
				suites = {},
				tests = {
					{
						ancestorTitles = { "D" },
						failureMessages = {},
						numPassingAsserts = 1,
						title = "D1",
					},
				},
				title = "D",
			},
		}))
	end)
end)
