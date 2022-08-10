-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-globals/src/index.ts

local Packages = script.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error

local JestEnvironment = require(Packages.JestEnvironment)
type Jest = JestEnvironment.Jest
local importedExpect = require(Packages.Expect)

-- ROBLOX deviation START: additional imports
local jestTypesModule = require(Packages.JestTypes)
type TestFrameworkGlobals = jestTypesModule.Global_TestFrameworkGlobals
-- ROBLOX deviation END

type JestGlobals =
	{
		jest: Jest,
		expect: typeof(importedExpect),
	}
	-- ROBLOX deviation START: using TestFrameworkGlobals instead of declaring variables one by one
	& TestFrameworkGlobals
-- ROBLOX deviation END

error(Error.new(
	-- ROBLOX deviation START: aligned message to make sense for jest-roblox
	"Do not import `JestGlobals` outside of the Jest test environment"
	-- ROBLOX deviation END
))

return ({} :: any) :: JestGlobals
