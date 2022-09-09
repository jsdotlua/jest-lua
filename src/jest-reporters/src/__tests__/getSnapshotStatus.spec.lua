-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-reporters/src/__tests__/getSnapshotStatus.test.js
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

local getSnapshotStatus = require(CurrentModule.getSnapshotStatus).default

it("Retrieves the snapshot status", function()
	local snapshotResult = {
		added = 1,
		fileDeleted = false,
		matched = 1,
		unchecked = 1,
		uncheckedKeys = { "test suite with unchecked snapshot" },
		unmatched = 1,
		updated = 1,
	}
	expect(getSnapshotStatus(snapshotResult, false)).toMatchSnapshot()
end)

it("Shows no snapshot updates if all snapshots matched", function()
	local snapshotResult = {
		added = 0,
		fileDeleted = false,
		matched = 1,
		unchecked = 0,
		uncheckedKeys = {},
		unmatched = 0,
		updated = 0,
	}
	expect(getSnapshotStatus(snapshotResult, true)).toMatchSnapshot()
end)

it("Retrieves the snapshot status after a snapshot update", function()
	local snapshotResult = {
		added = 2,
		fileDeleted = true,
		matched = 2,
		unchecked = 2,
		uncheckedKeys = {
			"first test suite with unchecked snapshot",
			"second test suite with unchecked snapshot",
		},
		unmatched = 2,
		updated = 2,
	}
	expect(getSnapshotStatus(snapshotResult, true)).toMatchSnapshot()
end)

return {}
