return function()
	local CurrentModule = script.Parent.Parent

	local getType = require(CurrentModule).getType

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

		it("supports builtin Roblox Datatypes", function()
			expect(getType(Vector3.new())).to.equal("builtin")
			expect(getType(Color3.new())).to.equal("builtin")
			expect(getType(UDim2.new())).to.equal("builtin")
		end)
	end)
end
