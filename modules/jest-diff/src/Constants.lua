-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/jest-diff/src/constants.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  */

local Constants = {}

Constants.NO_DIFF_MESSAGE = 'Compared values have no visual difference.'

Constants.SIMILAR_MESSAGE = 'Compared values serialize to the same structure.\n' ..
	'Printing internal object structure without calling `toJSON` instead.'

return Constants