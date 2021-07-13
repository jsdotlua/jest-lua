--!nocheck
-- deviation: these tests are not included in upstream
return function()
	local Workspace = script.Parent.Parent
	local Modules = Workspace.Parent
	local Packages = Modules.Parent.Parent

	local Polyfill = require(Packages.LuauPolyfill)
	local Array = Polyfill.Array

	local snapshots = require(script.Parent.__snapshots__['spyMatchers.roblox.snap'])

	local jestExpect = require(Workspace)
	local jestMock = require(Modules.JestMock)

	local mock

	beforeAll(function()
		mock = jestMock.new()
	end)

	local function createSpy(fn)
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
			end
		}

		return spy
	end

	describe("Lua tests", function()
		describe("nil argument calls", function()
			it("lastCalledWith works with trailing nil argument", function()
				local fn = mock:fn()
				fn('a', 'b', nil)
				jestExpect(fn).never.lastCalledWith('a', 'b')
				jestExpect(function() jestExpect(fn).lastCalledWith('a', 'b') end).toThrow(snapshots['Lua tests nil argument calls lastCalledWith works with trailing nil arguments 1'])
			end)

			it("lastCalledWith works with inner nil argument", function()
				local fn = mock:fn()
				fn('a', nil, 'b')
				jestExpect(fn).never.lastCalledWith('a', nil)
				jestExpect(fn).lastCalledWith('a', nil, 'b')
				jestExpect(function() jestExpect(fn).lastCalledWith('a', nil) end).toThrow(snapshots['Lua tests nil argument calls lastCalledWith works with inner nil argument 1'])
				jestExpect(function() jestExpect(fn).never.lastCalledWith('a', nil, 'b') end).toThrow(snapshots['Lua tests nil argument calls lastCalledWith works with inner nil argument 2'])
			end)

			it("lastCalledWith complex call with nil", function()
				local fn = mock:fn()
				fn('a', {1, 2}, nil, nil)
				jestExpect(fn).lastCalledWith('a', {1, 2}, nil, nil)
				jestExpect(function() jestExpect(fn).lastCalledWith('a', {1, 3}, nil, 'b') end).toThrow(snapshots['Lua tests nil argument calls lastCalledWith complex call with nil 1'])
				jestExpect(function() jestExpect(fn).lastCalledWith('a', {1, 2}, nil) end).toThrow(snapshots['Lua tests nil argument calls lastCalledWith complex call with nil 2'])
			end)

			it("lastCalledWith complex multi-call with nil", function()
				local fn = mock:fn()
				fn('a', {1, 2})
				fn('a', {1, 2}, nil, nil)
				jestExpect(fn).lastCalledWith('a', {1, 2}, nil, nil)
				jestExpect(function() jestExpect(fn).lastCalledWith('a', {1, 2}, nil) end).toThrow(snapshots['Lua tests nil argument calls lastCalledWith complex multi-call with nil 1'])
			end)

			it("toBeCalledWith single call", function()
				local fn = mock:fn()
				fn('a', 'b', nil)
				jestExpect(fn).never.toBeCalledWith('a', 'b')
				jestExpect(fn).toBeCalledWith('a', 'b', nil)
				jestExpect(fn).never.toBeCalledWith('a', 'b', nil, nil)
			end)

			it("toBeCalledWith multi-call", function()
				local fn = mock:fn()
				fn('a', 'b', nil)
				fn('a', 'b', nil, nil, 4)
				jestExpect(fn).never.toBeCalledWith('a', 'b')
				jestExpect(fn).toBeCalledWith('a', 'b', nil)
				jestExpect(fn).never.toBeCalledWith('a', 'b', nil, nil)
				jestExpect(fn).toBeCalledWith('a', 'b', nil, nil, 4)
				jestExpect(fn).never.toBeCalledWith('a', 'b', nil, nil, 4, nil)
				jestExpect(function() jestExpect(fn).toBeCalledWith('a', 'b') end).toThrow(snapshots['Lua tests nil argument calls toBeCalledWith multi-call 1'])
				jestExpect(function() jestExpect(fn).toBeCalledWith('a', 'b', nil, nil, 4, nil) end).toThrow(snapshots['Lua tests nil argument calls toBeCalledWith multi-call 2'])
			end)

			it("lastCalledWith single call", function()
				local fn = mock:fn()
				fn('a', 'b', nil)
				jestExpect(fn).never.lastCalledWith('a', 'b')
				jestExpect(fn).lastCalledWith('a', 'b', nil)
				jestExpect(fn).never.lastCalledWith('a', 'b', nil, nil)
			end)

			it("lastCalledWith multi-call", function()
				local fn = mock:fn()
				fn('a', 'b', nil)
				fn('a', 'b', nil, nil, 4)
				jestExpect(fn).never.lastCalledWith('a', 'b')
				jestExpect(fn).never.lastCalledWith('a', 'b', nil, nil)
				jestExpect(fn).lastCalledWith('a', 'b', nil, nil, 4)
				jestExpect(fn).never.lastCalledWith('a', 'b', nil, nil, 4, nil)
			end)

			it("nthCalledWith single call", function()
				local fn = mock:fn()
				fn('a', 'b', nil)
				jestExpect(fn).never.nthCalledWith(1, 'a', 'b')
				jestExpect(fn).nthCalledWith(1, 'a', 'b', nil)
				jestExpect(fn).never.nthCalledWith(1, 'a', 'b', nil, nil)
			end)

			it("nthCalledWith multi-call", function()
				local fn = mock:fn()
				fn('a', 'b', nil)
				fn('a', 'b', nil, nil, 4)
				jestExpect(fn).never.nthCalledWith(1, 'a', 'b')
				jestExpect(fn).nthCalledWith(1, 'a', 'b', nil)
				jestExpect(fn).never.nthCalledWith(1, 'a', 'b', nil, nil)
				jestExpect(fn).nthCalledWith(2, 'a', 'b', nil, nil, 4)
				jestExpect(fn).never.nthCalledWith(2, 'a', 'b', nil, nil, 4, nil)
			end)

			it("works with spies", function()
				local fn = mock:fn()
				fn('arg0', nil)
				jestExpect(createSpy(fn)).never.lastCalledWith('arg0')
				jestExpect(createSpy(fn)).lastCalledWith('arg0', nil)
			end)
		end)
	end)
end