return function()
	local CurrentModule = script.Parent.Parent

	local getType = require(CurrentModule).getType
	local isRobloxBuiltin = require(CurrentModule).isRobloxBuiltin

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
			expect(getType(Vector3.new())).to.equal("Vector3")
			expect(getType(Color3.new())).to.equal("Color3")
			expect(getType(UDim2.new())).to.equal("UDim2")
		end)
	end)

	describe(".isRobloxBuiltin()", function()
		it("returns true for builtin types", function()
			expect(isRobloxBuiltin(Vector3.new())).to.equal(true)
			expect(isRobloxBuiltin(Color3.new())).to.equal(true)
			expect(isRobloxBuiltin(UDim2.new())).to.equal(true)
		end)

		it("returns false for non builtin types", function()
			expect(isRobloxBuiltin(1)).to.equal(false)
			expect(isRobloxBuiltin({})).to.equal(false)
			expect(isRobloxBuiltin(newproxy())).to.equal(false)
		end)
	end)
end
