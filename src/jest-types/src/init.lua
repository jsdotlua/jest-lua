-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/jest-types/src/index.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

local CurrentModule = script

local Config = require(CurrentModule.Config)

return {
	Config = Config
}
