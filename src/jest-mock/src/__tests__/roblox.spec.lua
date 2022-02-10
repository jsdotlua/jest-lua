-- ROBLOX NOTE: no upstream

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local ModuleMocker = require(CurrentModule)
	local jestExpect = require(Packages.Dev.Expect)

	local moduleMocker
	beforeEach(function()
		moduleMocker = ModuleMocker.new()
	end)

	it("mock return chaining", function()
		local myMock = moduleMocker:fn()
		jestExpect(myMock()).toBeNil()

		myMock.mockReturnValueOnce(10).mockReturnValueOnce('x').mockReturnValue(true)
		jestExpect(myMock()).toBe(10)
		jestExpect(myMock()).toBe('x')
		jestExpect(myMock()).toBe(true)
		jestExpect(myMock()).toBe(true)
	end)

	it("default mock function name is jest.fn()", function()
		local myMock = moduleMocker:fn()
		jestExpect(myMock.getMockName()).toBe("jest.fn()")
	end)

	it("returns a function as the second return value", function()
		local mock, mockFn = moduleMocker:fn()
		mock.mockImplementationOnce(function(a, b) return a .. b end)
		mock.mockReturnValue(true)

		jestExpect(typeof(mockFn)).toBe("function")

		jestExpect(mockFn("a", "b")).toBe("ab")
		jestExpect(mock).toHaveBeenLastCalledWith("a", "b")
		jestExpect(mock).toHaveLastReturnedWith("ab")

		jestExpect(mockFn()).toBe(true)
		jestExpect(mock).toHaveLastReturnedWith(true)
	end)
end