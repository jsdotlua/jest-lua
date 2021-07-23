local Modules = script.Parent.Submodules

local expect = require(Modules.Expect)

local jest = require(Modules.Jest)
local jestSnapshot = require(Modules.JestSnapshot)

return {
	expect = expect,
	jest = jest,
	jestSnapshot = {
		toMatchSnapshot = jestSnapshot.toMatchSnapshot,
		toThrowErrorMatchingSnapshot = jestSnapshot.toThrowErrorMatchingSnapshot
	},
}
