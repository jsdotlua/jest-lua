--!strict
-- upstream: https://github.com/facebook/jest/blob/v26.5.3/packages/expect/src/jestMatchersObject.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */
local Workspace = script.Parent
local Modules = Workspace.Parent
local Packages = Modules.Parent.Parent

local Polyfill = require(Packages.LuauPolyfill)
local Symbol = Polyfill.Symbol
local Object = Polyfill.Object

--local AsymmetricMatchers = require(Workspace.asymmetricMatchers)

-- deviation: omitted external type definitions

-- // Global matchers object holds the list of available matchers and
-- // the state, that can hold matcher specific values that change over time.
local JEST_MATCHERS_OBJECT = Symbol.for_("$$jest-matchers-object")

-- // Notes a built-in/internal Jest matcher.
-- // Jest may override the stack trace of Errors thrown by internal matchers.
local INTERNAL_MATCHER_FLAG = Symbol.for_("$$jest-internal-matcher")

if not _G[JEST_MATCHERS_OBJECT] then
	local defaultState = {
		assertionCalls = 0,
		expectedAssertionsNumber = nil, -- doesn't have significance in Lua but kept for translation
		isExpectingAssertions = false,
		suppressedErrors = {}
	}

	_G[JEST_MATCHERS_OBJECT] = {
		matchers = {},
		state = defaultState
	}
end

local function getState()
	return _G[JEST_MATCHERS_OBJECT].state
end

local function setState(state): ()
	Object.assign(_G[JEST_MATCHERS_OBJECT].state, state)
end

local function getMatchers()
	return _G[JEST_MATCHERS_OBJECT].matchers
end

local function setMatchers(
	matchers,--: MatchersObject
	isInternal: boolean,
	expect--: Expect
): ()
	-- ROBLOX TODO: Implement the non-internal matcher case
	if not isInternal then
		error("Non-internal matchers are not yet implemented")
	end

	Object.assign(_G[JEST_MATCHERS_OBJECT].matchers, matchers)
end


return {
	INTERNAL_MATCHER_FLAG = INTERNAL_MATCHER_FLAG,
	getState = getState,
	setState = setState,
	getMatchers = getMatchers,
	setMatchers = setMatchers
}


