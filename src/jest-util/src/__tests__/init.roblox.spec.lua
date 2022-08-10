-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent

type Function = (...any) -> ...any

local JestGlobals = require(Packages.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = (JestGlobals.describe :: any) :: Function
local it = (JestGlobals.it :: any) :: Function

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
