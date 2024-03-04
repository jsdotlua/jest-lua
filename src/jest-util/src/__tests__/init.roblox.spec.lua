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

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local initModule = require("../init")

describe("jest-util init", function()
	it("should export all necessary props", function()
		expect(initModule.clearLine).toBeDefined()
		expect(typeof(initModule.clearLine)).toEqual("function")

		expect(initModule.createDirectory).toBeDefined()
		expect(typeof(initModule.createDirectory)).toEqual("function")

		expect(initModule.ErrorWithStack).toBeDefined()
		expect(typeof(initModule.ErrorWithStack)).toEqual("table")

		expect(initModule.installCommonGlobals).toBeDefined()
		expect(typeof(initModule.installCommonGlobals)).toEqual("function")

		expect(initModule.isInteractive).toBeDefined()
		expect(typeof(initModule.isInteractive)).toEqual("boolean")

		expect(initModule.isPromise).toBeDefined()
		expect(typeof(initModule.isPromise)).toEqual("function")

		expect(initModule.setGlobal).toBeDefined()
		expect(typeof(initModule.setGlobal)).toEqual("function")

		expect(initModule.deepCyclicCopy).toBeDefined()
		expect(typeof(initModule.deepCyclicCopy)).toEqual("function")

		expect(initModule.convertDescriptorToString).toBeDefined()
		expect(typeof(initModule.convertDescriptorToString)).toEqual("function")

		-- specialChars
		expect(initModule.ARROW).toBeDefined()
		expect(typeof(initModule.ARROW)).toEqual("string")
		expect(initModule.ICONS).toBeDefined()
		expect(typeof(initModule.ICONS)).toEqual("table")
		expect(initModule.CLEAR).toBeDefined()
		expect(typeof(initModule.CLEAR)).toEqual("string")

		expect(initModule.globsToMatcher).toBeDefined()
		expect(typeof(initModule.globsToMatcher)).toEqual("function")

		-- preRunMessage
		expect(initModule.print).toBeDefined()
		expect(typeof(initModule.print)).toEqual("function")
		expect(initModule.remove).toBeDefined()
		expect(typeof(initModule.remove)).toEqual("function")

		expect(initModule.pluralize).toBeDefined()
		expect(typeof(initModule.pluralize)).toEqual("function")

		expect(initModule.formatTime).toBeDefined()
		expect(typeof(initModule.formatTime)).toEqual("function")
	end)
end)
