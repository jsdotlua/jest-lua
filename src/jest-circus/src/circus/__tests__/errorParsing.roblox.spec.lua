local CurrentModule = script.Parent
local SrcModule = CurrentModule.Parent
local Packages = SrcModule.Parent.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error

local typesModule = require(Packages.JestTypes)
type Circus_DescribeBlock = typesModule.Circus_DescribeBlock

local RobloxShared = require(Packages.RobloxShared)
local pruneDeps = RobloxShared.pruneDeps

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local it = JestGlobals.it

local utils = require(SrcModule.utils)

type FIXME_ANALYZE = any

local function mockDescribeBlock(): Circus_DescribeBlock
	return {
		type = "describeBlock",
		children = {},
		hooks = {},
		mode = nil,
		name = "mock describe",
		parent = nil,
		tests = {},
	}
end

local function errorWithStack(stack: string, message: string?)
	local errorObject = Error.new(message)
	errorObject.stack = stack

	return errorObject
end

local errors: { { name: string, err: LuauPolyfill.Error } } = {
	{ name = "a string error", err = "something went wrong!!" :: any },
	{ name = "an error object", err = Error.new() },
	{ name = "an error object with a message", err = Error.new("something went wrong!!") },
	{
		name = "an error object with a stack and message",
		err = errorWithStack(debug.traceback(), "something went wrong!!"),
	},
	{
		name = "an error object with only a stack",
		err = errorWithStack("Error: something went wrong!!\n" .. debug.traceback()),
	},
};

(it.each :: FIXME_ANALYZE)(errors)("formats $name into proper output with message", function(errorData)
	local result = utils.makeRunResult(mockDescribeBlock(), { errorData.err })
	local prunedErrors = {}
	for _, err in result.unhandledErrors do
		table.insert(prunedErrors, pruneDeps(err))
	end

	expect(prunedErrors).toMatchSnapshot()
end)
