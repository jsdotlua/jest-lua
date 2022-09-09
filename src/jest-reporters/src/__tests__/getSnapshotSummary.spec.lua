-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-reporters/src/__tests__/getSnapshotSummary.test.js
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
local it = JestGlobals.it

local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array

local getSnapshotSummary = require(CurrentModule.getSnapshotSummary).default

local testResultModule = require(Packages.JestTestResult)
type SnapshotSummary = testResultModule.SnapshotSummary

local typesModule = require(Packages.JestTypes)
type Config_GlobalConfig = typesModule.Config_GlobalConfig

local UPDATE_COMMAND = "press --u"
local globalConfig = { rootDir = Packages }

it("creates a snapshot summary", function()
	local snapshots = {
		added = 1,
		didUpdate = false,
		filesAdded = 1,
		filesRemoved = 1,
		filesRemovedList = {},
		filesUnmatched = 1,
		filesUpdated = 1,
		matched = 2,
		total = 2,
		unchecked = 1,
		uncheckedKeysByFile = { { filePath = "path/to/suite_one", keys = { "unchecked snapshot 1" } } },
		unmatched = 1,
		updated = 1,
	}
	local result = Array.join(
		getSnapshotSummary(snapshots :: SnapshotSummary, globalConfig :: Config_GlobalConfig, UPDATE_COMMAND),
		"\n"
	):gsub("\\", "/")
	expect(result).toMatchSnapshot()
end)

it("creates a snapshot summary after an update", function()
	local snapshots = {
		added = 1,
		didUpdate = true,
		filesAdded = 1,
		filesRemoved = 1,
		filesRemovedList = {},
		filesUnmatched = 1,
		filesUpdated = 1,
		unchecked = 1,
		uncheckedKeysByFile = { { filePath = "path/to/suite_one", keys = { "unchecked snapshot 1" } } },
		unmatched = 1,
		updated = 1,
	}
	local result = Array.join(
		getSnapshotSummary(snapshots :: SnapshotSummary, globalConfig :: Config_GlobalConfig, UPDATE_COMMAND),
		"\n"
	):gsub("\\", "/")
	expect(result).toMatchSnapshot()
end)

it("creates a snapshot summary with multiple snapshot being written/updated", function()
	local snapshots = {
		added = 2,
		didUpdate = false,
		filesAdded = 2,
		filesRemoved = 2,
		filesRemovedList = {},
		filesUnmatched = 2,
		filesUpdated = 2,
		unchecked = 2,
		uncheckedKeysByFile = {
			{ filePath = "path/to/suite_one", keys = { "unchecked snapshot 1" } },
			{ filePath = "path/to/suite_two", keys = { "unchecked snapshot 2" } },
		},
		unmatched = 2,
		updated = 2,
	}
	local result = Array.join(
		getSnapshotSummary(snapshots :: SnapshotSummary, globalConfig :: Config_GlobalConfig, UPDATE_COMMAND),
		"\n"
	):gsub("\\", "/")
	expect(result).toMatchSnapshot()
end)

it("returns nothing if there are no updates", function()
	local snapshots = {
		added = 0,
		didUpdate = false,
		filesAdded = 0,
		filesRemoved = 0,
		filesRemovedList = {},
		filesUnmatched = 0,
		filesUpdated = 0,
		unchecked = 0,
		uncheckedKeysByFile = {},
		unmatched = 0,
		updated = 0,
	}
	local result = Array.join(
		getSnapshotSummary(snapshots :: SnapshotSummary, globalConfig :: Config_GlobalConfig, UPDATE_COMMAND),
		"\n"
	)
	expect(result).toMatchSnapshot()
end)

return {}
