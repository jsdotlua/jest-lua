-- ROBLOX NOTE: no upstream
-- ROBLOX deviation: this file is not aligned with upstream version

return function()
	local CurrentModule = script.Parent.Parent
	local Globals = require(CurrentModule)

	describe("jest globals are initialized", function()
		it("expect", function()
			expect(Globals.expect).to.be.ok()
		end)

		it("jest object", function()
			expect(Globals.jest).to.be.ok()
		end)

		it("jestSnapshot", function()
			expect(Globals.jestSnapshot.toMatchSnapshot).to.be.ok()
			expect(Globals.jestSnapshot.toThrowErrorMatchingSnapshot).to.be.ok()
		end)
	end)
end
