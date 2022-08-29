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
-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local initModule = require(SrcModule)

describe("jest-util init", function()
	it("should export all necessary props", function()
		jestExpect(initModule.clearLine).toBeDefined()
		jestExpect(typeof(initModule.clearLine)).toEqual("function")

		jestExpect(initModule.createDirectory).toBeDefined()
		jestExpect(typeof(initModule.createDirectory)).toEqual("function")

		jestExpect(initModule.ErrorWithStack).toBeDefined()
		jestExpect(typeof(initModule.ErrorWithStack)).toEqual("table")

		jestExpect(initModule.installCommonGlobals).toBeDefined()
		jestExpect(typeof(initModule.installCommonGlobals)).toEqual("function")

		jestExpect(initModule.isInteractive).toBeDefined()
		jestExpect(typeof(initModule.isInteractive)).toEqual("boolean")

		jestExpect(initModule.isPromise).toBeDefined()
		jestExpect(typeof(initModule.isPromise)).toEqual("function")

		jestExpect(initModule.setGlobal).toBeDefined()
		jestExpect(typeof(initModule.setGlobal)).toEqual("function")

		jestExpect(initModule.deepCyclicCopy).toBeDefined()
		jestExpect(typeof(initModule.deepCyclicCopy)).toEqual("function")

		jestExpect(initModule.convertDescriptorToString).toBeDefined()
		jestExpect(typeof(initModule.convertDescriptorToString)).toEqual("function")

		-- specialChars
		jestExpect(initModule.ARROW).toBeDefined()
		jestExpect(typeof(initModule.ARROW)).toEqual("string")
		jestExpect(initModule.ICONS).toBeDefined()
		jestExpect(typeof(initModule.ICONS)).toEqual("table")
		jestExpect(initModule.CLEAR).toBeDefined()
		jestExpect(typeof(initModule.CLEAR)).toEqual("string")

		jestExpect(initModule.globsToMatcher).toBeDefined()
		jestExpect(typeof(initModule.globsToMatcher)).toEqual("function")

		-- preRunMessage
		jestExpect(initModule.print).toBeDefined()
		jestExpect(typeof(initModule.print)).toEqual("function")
		jestExpect(initModule.remove).toBeDefined()
		jestExpect(typeof(initModule.remove)).toEqual("function")

		jestExpect(initModule.pluralize).toBeDefined()
		jestExpect(typeof(initModule.pluralize)).toEqual("function")

		jestExpect(initModule.formatTime).toBeDefined()
		jestExpect(typeof(initModule.formatTime)).toEqual("function")
	end)
end)

return {}
