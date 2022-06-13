-- ROBLOX note: no upstream

return function()
	local CurrentModule = script.Parent
	local Packages = CurrentModule.Parent.Parent

	local Writeable = require(CurrentModule.Parent.Writeable).Writeable

	local ModuleMocker = require(Packages.JestMock).ModuleMocker
	local jestExpect = require(Packages.Dev.JestGlobals).expect

	local moduleMocker = ModuleMocker.new()
	local mockWrite = moduleMocker:fn()

	describe("Writeable", function()
		it("takes a write function and returns a writeable object with the write method attached", function()
			local writeFn = function(data: string)
				mockWrite(data)
			end
			local writeable = Writeable.new({ write = writeFn })
			writeable:write("Hello, world!")
			jestExpect(mockWrite).toBeCalledWith("Hello, world!")
		end)
	end)
end
