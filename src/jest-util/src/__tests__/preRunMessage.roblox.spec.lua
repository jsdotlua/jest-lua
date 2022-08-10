-- ROBLOX NOTE: no upstream

local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent

local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local preRunMessageModule = require(SrcModule.preRunMessage)
local print_, remove = preRunMessageModule.print, preRunMessageModule.remove

describe("preRunMessage", function()
	local writeMock
	local stream
	beforeEach(function()
		writeMock = jest.fn()
		stream = {
			write = writeMock,
		}
	end)

	it("should execute print without error", function()
		jestExpect(function()
			print_(stream)
		end).never.toThrow()
	end)

	it("should execute remove without error", function()
		jestExpect(function()
			remove(stream)
		end).never.toThrow()
	end)
end)

return {}
