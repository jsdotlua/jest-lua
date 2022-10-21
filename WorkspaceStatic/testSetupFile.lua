--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]
-- Some of the `jest-runtime` tests are very slow and cause
-- timeouts on travis
-- jest.setTimeout(70000)
type Function = (...any) -> ...any

local JestGlobals = require(script.Parent.JestGlobals.JestGlobals)
local jestExpect = JestGlobals.expect

local JestSnapshotSerializerRaw = require(script.Parent.Parent.JestSnapshotSerializerRaw)
local ConvertAnsi = require(script.Parent.Parent.PrettyFormat).plugins.ConvertAnsi

jestExpect.addSnapshotSerializer(JestSnapshotSerializerRaw)
jestExpect.addSnapshotSerializer(ConvertAnsi)
