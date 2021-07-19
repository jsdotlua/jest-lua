-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/jest-snapshot/src/plugins.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

local CurrentModule = script.Parent
local Modules = CurrentModule.Parent

local jestMockSerializer = require(CurrentModule.mock_serializer)

local plugins = require(Modules.PrettyFormat).plugins
-- deviation: omitting DOMCollection, DOMElement, Immutable, ReactElement, ReactTestComponent
local AsymmetricMatcher = plugins.AsymmetricMatcher

-- ROBLOX TODO: ADO-1182 Add more plugins here as we translate them
local PLUGINS = {
	jestMockSerializer,
	AsymmetricMatcher
}

-- // Prepend to list so the last added is the first tested.
local function addSerializer(plugin_)
	table.insert(PLUGINS, 1, plugin_)
end

local function getSerializers()
	return PLUGINS
end

return {
	addSerializer = addSerializer,
	getSerializers = getSerializers
}

