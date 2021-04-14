-- deviation: these tests are not included in upstream
return function()
	local Workspace = script.Parent.Parent
	local Modules = Workspace.Parent
	local Packages = Modules.Parent.Parent

	local Polyfill = require(Packages.LuauPolyfill)
	local Array = Polyfill.Array

	local jestExpect = require(Workspace)
	local mock = require(Modules.JestMock)

	local jest
	beforeAll(function()
		jest = mock.new()
	end)

	-- A smart spy is just like a regular spy but it works with recognizing
	-- nil arguments in mocked calls since it exposes the fn.mock.callLengths
	-- array
	local function createSmartSpy(fn)
		local spy = {}
		setmetatable(spy, {
			__call = function() end
		})

		spy.calls = {
			all = function()
				return Array.map(
					fn.mock.calls,
					function(args)
						return {args = args}
					end
				)
			end,
			count = function()
				return #fn.mock.calls
			end,
			lengths = function()
				return fn.mock.callLengths
			end
		}

		return spy
	end

	describe("Lua tests", function()
		describe("calls with nil arguments", function()
			it("lastCalledWith works with trailing nil arguments", function()
				local fn = jest:fn()
				fn('a', 'b', nil)
				jestExpect(fn).never.lastCalledWith('a', 'b')
			end)

			it("lastCalledWith works with inner nil argument", function()
				local fn = jest:fn()
				fn('a', nil, 'b')
				jestExpect(fn).never.lastCalledWith('a', nil)
				jestExpect(fn).lastCalledWith('a', nil, 'b')
			end)

			it("toBeCalledWith single call", function()
				local fn = jest:fn()
				fn('a', 'b', nil)
				jestExpect(fn).never.toBeCalledWith('a', 'b')
				jestExpect(fn).toBeCalledWith('a', 'b', nil)
				jestExpect(fn).never.toBeCalledWith('a', 'b', nil, nil)
			end)

			it("toBeCalledWith multi-call", function()
				local fn = jest:fn()
				fn('a', 'b', nil)
				fn('a', 'b', nil, nil, 4)
				jestExpect(fn).never.toBeCalledWith('a', 'b')
				jestExpect(fn).toBeCalledWith('a', 'b', nil)
				jestExpect(fn).never.toBeCalledWith('a', 'b', nil, nil)
				jestExpect(fn).toBeCalledWith('a', 'b', nil, nil, 4)
				jestExpect(fn).never.toBeCalledWith('a', 'b', nil, nil, 4, nil)
			end)

			it("lastCalledWith single call", function()
				local fn = jest:fn()
				fn('a', 'b', nil)
				jestExpect(fn).never.lastCalledWith('a', 'b')
				jestExpect(fn).lastCalledWith('a', 'b', nil)
				jestExpect(fn).never.lastCalledWith('a', 'b', nil, nil)
			end)

			it("lastCalledWith multi-call", function()
				local fn = jest:fn()
				fn('a', 'b', nil)
				fn('a', 'b', nil, nil, 4)
				jestExpect(fn).never.lastCalledWith('a', 'b')
				jestExpect(fn).never.lastCalledWith('a', 'b', nil, nil)
				jestExpect(fn).lastCalledWith('a', 'b', nil, nil, 4)
				jestExpect(fn).never.lastCalledWith('a', 'b', nil, nil, 4, nil)
			end)

			it("nthCalledWith single call", function()
				local fn = jest:fn()
				fn('a', 'b', nil)
				jestExpect(fn).never.nthCalledWith(1, 'a', 'b')
				jestExpect(fn).nthCalledWith(1, 'a', 'b', nil)
				jestExpect(fn).never.nthCalledWith(1, 'a', 'b', nil, nil)
			end)

			it("nthCalledWith multi-call", function()
				local fn = jest:fn()
				fn('a', 'b', nil)
				fn('a', 'b', nil, nil, 4)
				jestExpect(fn).never.nthCalledWith(1, 'a', 'b')
				jestExpect(fn).nthCalledWith(1, 'a', 'b', nil)
				jestExpect(fn).never.nthCalledWith(1, 'a', 'b', nil, nil)
				jestExpect(fn).nthCalledWith(2, 'a', 'b', nil, nil, 4)
				jestExpect(fn).never.nthCalledWith(2, 'a', 'b', nil, nil, 4, nil)
			end)

			it("works with smart spies", function()
				local fn = jest:fn()
				fn('arg0', nil)
				jestExpect(createSmartSpy(fn)).never.lastCalledWith('arg0')
				jestExpect(createSmartSpy(fn)).lastCalledWith('arg0', nil)
			end)
		end)
	end)
end