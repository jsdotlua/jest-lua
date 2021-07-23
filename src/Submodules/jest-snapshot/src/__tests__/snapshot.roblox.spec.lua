local CurrentModule = script.Parent.Parent
local Modules = CurrentModule.Parent

local jestExpect = require(Modules.Expect)

local toMatchSnapshot = require(CurrentModule).toMatchSnapshot

return function()
	jestExpect.extend({
		toMatchTrimmedSnapshot = function(self, received, length)
			return toMatchSnapshot(
				self,
				string.sub(received, 1, length),
				'toMatchTrimmedSnapshot'
			)
		end
	})

	it("native lua errors", function()
		jestExpect(function() error("oops") end).toThrowErrorMatchingSnapshot()
	end)

	it("custom snapshot matchers", function()
		jestExpect('extra long string oh my gerd').toMatchTrimmedSnapshot(10)
	end)
end