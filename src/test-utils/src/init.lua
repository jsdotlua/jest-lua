-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/test-utils/src/index.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

local alignedAnsiStyleSerializer = require("./alignedAnsiStyleSerializer")
local configModule = require("./config")

--[[
	ROBLOX deviation: ommiting ConditionalTest and config imports
	original code:
	export {
	  isJestJasmineRun,
	  skipSuiteOnJasmine,
	  skipSuiteOnJestCircus,
	  onNodeVersions,
	} from './ConditionalTest';

	export {makeGlobalConfig, makeProjectConfig} from './config';
]]

return {
	alignedAnsiStyleSerializer = alignedAnsiStyleSerializer,
	makeGlobalConfig = configModule.makeGlobalConfig,
	makeProjectConfig = configModule.makeProjectConfig,
}
