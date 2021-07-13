return function()
	local Workspace = script.Parent.Parent

	local getType = require(Workspace).getType

	describe(".getType()", function()
		it("supports tables with a throwing __index metamethod", function()
			local testObj = {}
			setmetatable(testObj, {
				__index = function(self, key)
					error(("%q is not a valid member of BackBehavior"):format(tostring(key)), 2)
				end
			})
			expect(getType(testObj)).to.equal("table")
		end)
	end)
end