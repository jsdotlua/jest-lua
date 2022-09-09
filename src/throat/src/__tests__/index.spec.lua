-- ROBLOX upstream: https://github.com/ForbesLindesay/throat/blob/6.0.1/test/index.js
--[[
	Copyright (c) 2013 Forbes Lindesay

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
]]
local Packages = script.Parent.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local console = LuauPolyfill.console
local instanceof = LuauPolyfill.instanceof
local setTimeout = LuauPolyfill.setTimeout
local Promise = require(Packages.Promise)
type Promise<T> = LuauPolyfill.Promise<T>

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local itFIXME = function(description: string, ...: any)
	JestGlobals.it.todo(description)
end

local throatModule = require(script.Parent.Parent)
local throat = throatModule.default
type ThroatEarlyBound<TResult, TArgs> = throatModule.ThroatEarlyBound<TResult, TArgs>
type ThroatLateBound<TResult, TArgs> = throatModule.ThroatLateBound<TResult, TArgs>
local sentA, sentB, sentC = {}, {}, {}
local function job()
	local resolve, reject
	local promise = Promise.new(function(_resolve, _reject)
		resolve = _resolve
		reject = _reject
	end)

	local executeJob
	local function _executeJob(...): Promise<any>
		local arguments = { ... }
		if executeJob.isRun then
			error(Error.new("Job was run multiple times"))
		end
		executeJob.isRun = true
		executeJob.args = Array.slice(arguments)
		return promise
	end
	executeJob = setmetatable({}, {
		__call = function(self: any, ...: any)
			return _executeJob(...)
		end,
	})

	executeJob.fail = function(_self: any, err)
		reject(err)
	end
	executeJob.complete = function(_self: any, val)
		resolve(val)
	end
	executeJob.isRun = false
	return executeJob
end

local Processed = {}
Processed.__index = Processed
function Processed.new(val)
	return setmetatable({
		val = val,
	}, Processed)
end
local function worker(max)
	local concurrent = 0
	local function execute(...)
		local arguments = { ... }
		concurrent += 1
		if concurrent > max then
			error(Error.new("Extra processes were run in parallel."))
		end
		local res = Processed.new(Array.slice(arguments))
		return Promise.new(function(resolve)
			setTimeout(function()
				concurrent -= 1
				resolve(res)
			end, 100)
		end)
	end
	return execute
end
describe("throat(n)", function()
	it("throat(1) acts as a lock", function()
		local lock = throat(1) :: ThroatLateBound<any, any>
		local a, b, c = job(), job(), job()
		local resA = lock(a, 123)
		local resB = lock(b, 456)
		local resC = lock(c, 789)
		assert(a.isRun)
		assert(not b.isRun)
		assert(not c.isRun)
		a:complete(sentA)
		return resA
			:andThen(function(resA)
				assert(resA == sentA)
				assert(a.isRun)
				assert(b.isRun)
				assert(not c.isRun)
				b:fail(sentB)
				return resB:andThen(function()
					error(Error.new("b should have been rejected"))
				end, function(errB)
					assert(errB == sentB)
				end)
			end)
			:andThen(function()
				assert(a.isRun)
				assert(b.isRun)
				assert(c.isRun)
				expect(a.args).toEqual({ 123 })
				expect(b.args).toEqual({ 456 })
				expect(c.args).toEqual({ 789 })
				c:complete(sentC)
				return resC
			end)
			:andThen(function(resC)
				assert(resC == sentC)
			end)
			:expect()
	end)
	it("throat(2) lets two processes acquire the same lock", function()
		local lock = throat(2) :: ThroatLateBound<any, any>
		local a, b, c = job(), job(), job()
		local resA = lock(a)
		local resB = lock(b)
		local resC = lock(c)
		assert(a.isRun)
		assert(b.isRun)
		assert(not c.isRun)
		a:complete(sentA)
		return resA
			:andThen(function(resA)
				assert(resA == sentA)
				assert(a.isRun)
				assert(b.isRun)
				assert(c.isRun)
				b:fail(sentB)
				return resB:andThen(function()
					error(Error.new("b should have been rejected"))
				end, function(errB)
					assert(errB == sentB)
				end)
			end)
			:andThen(function()
				assert(a.isRun)
				assert(b.isRun)
				assert(c.isRun)
				c:complete(sentC)
				return resC
			end)
			:andThen(function(resC)
				assert(resC == sentC)
			end)
			:expect()
	end)
	it("throat(3) lets three processes acquire the same lock", function()
		local lock = throat(3) :: ThroatLateBound<any, any>
		local a, b, c = job(), job(), job()
		local resA = lock(a)
		local resB = lock(b)
		local resC = lock(c)
		assert(a.isRun)
		assert(b.isRun)
		assert(c.isRun)
		a:complete(sentA)
		return resA
			:andThen(function(resA)
				assert(resA == sentA)
				assert(a.isRun)
				assert(b.isRun)
				assert(c.isRun)
				b:fail(sentB)
				return resB:andThen(function()
					error(Error.new("b should have been rejected"))
				end, function(errB)
					assert(errB == sentB)
				end)
			end)
			:andThen(function()
				assert(a.isRun)
				assert(b.isRun)
				assert(c.isRun)
				c:complete(sentC)
				return resC
			end)
			:andThen(function(resC)
				assert(resC == sentC)
			end)
			:expect()
	end)
end)

describe("throat(n, fn)", function()
	it("throat(1, fn) acts as a sequential worker", function()
		return Promise.all(Array.map({ sentA, sentB, sentC }, throat(1, worker(1)) :: ThroatEarlyBound<any, any>))
			:andThen(function(res)
				assert(instanceof(res[1], Processed) and #res[1].val > 1 and res[1].val[1] == sentA)
				assert(instanceof(res[2], Processed) and #res[2].val > 1 and res[2].val[1] == sentB)
				assert(instanceof(res[3], Processed) and #res[3].val > 1 and res[3].val[1] == sentC)
			end)
			:expect()
	end)
	it("throat(2, fn) works on two inputs in parallel", function()
		return Promise.all(Array.map({ sentA, sentB, sentC }, throat(2, worker(2)) :: ThroatEarlyBound<any, any>))
			:andThen(function(res)
				assert(instanceof(res[1], Processed) and #res[1].val > 1 and res[1].val[1] == sentA)
				assert(instanceof(res[2], Processed) and #res[2].val > 1 and res[2].val[1] == sentB)
				assert(instanceof(res[3], Processed) and #res[3].val > 1 and res[3].val[1] == sentC)
			end)
			:expect()
	end)
	it("throat(3, fn) works on three inputs in parallel", function()
		return Promise.all(Array.map({ sentA, sentB, sentC }, throat(3, worker(3)) :: ThroatEarlyBound<any, any>))
			:andThen(function(res)
				assert(instanceof(res[1], Processed) and #res[1].val > 1 and res[1].val[1] == sentA)
				assert(instanceof(res[2], Processed) and #res[2].val > 1 and res[2].val[1] == sentB)
				assert(instanceof(res[3], Processed) and #res[3].val > 1 and res[3].val[1] == sentC)
			end)
			:expect()
	end)
end)

describe("throat(fn, n)", function()
	it("throat(fn, 1) acts as a sequential worker", function()
		return Promise.all(
			Array.map({ sentA, sentB, sentC }, throat(worker(1) :: any, 1 :: any) :: ThroatEarlyBound<any, any>)
		)
			:andThen(function(res)
				assert(instanceof(res[1], Processed) and #res[1].val > 1 and res[1].val[1] == sentA)
				assert(instanceof(res[2], Processed) and #res[2].val > 1 and res[2].val[1] == sentB)
				assert(instanceof(res[3], Processed) and #res[3].val > 1 and res[3].val[1] == sentC)
			end)
			:expect()
	end)
	it("throat(fn, 2) works on two inputs in parallel", function()
		return Promise.all(
			Array.map({ sentA, sentB, sentC }, throat(worker(2) :: any, 2 :: any) :: ThroatEarlyBound<any, any>)
		)
			:andThen(function(res)
				assert(instanceof(res[1], Processed) and #res[1].val > 1 and res[1].val[1] == sentA)
				assert(instanceof(res[2], Processed) and #res[2].val > 1 and res[2].val[1] == sentB)
				assert(instanceof(res[3], Processed) and #res[3].val > 1 and res[3].val[1] == sentC)
			end)
			:expect()
	end)
	it("throat(fn, 3) works on three inputs in parallel", function()
		return Promise.all(
			Array.map({ sentA, sentB, sentC }, throat(worker(3) :: any, 3 :: any) :: ThroatEarlyBound<any, any>)
		)
			:andThen(function(res)
				assert(instanceof(res[1], Processed) and #res[1].val > 1 and res[1].val[1] == sentA)
				assert(instanceof(res[2], Processed) and #res[2].val > 1 and res[2].val[1] == sentB)
				assert(instanceof(res[3], Processed) and #res[3].val > 1 and res[3].val[1] == sentC)
			end)
			:expect()
	end)
end)

describe("type errors", function()
	it("size as a string", function()
		local ok, result = pcall(function()
			throat("foo" :: any)
		end)
		if not ok then
			local ex = result
			expect(ex.message).toMatch("Expected throat size to be a number")
			return
		end
		error(Error.new("Expected a failure"))
	end)
	it("fn as a string", function()
		local ok, result = pcall(function()
			throat(2, "foo" :: any)
		end)
		if not ok then
			local ex = result
			expect(ex.message).toMatch("Expected throat fn to be a function")
			return
		end
		error(Error.new("Expected a failure"))
	end)
	it("late fn as a string", function()
		local ok, result = pcall(function()
			(throat(2) :: ThroatLateBound<any, any>)("foo" :: any)
		end)
		if not ok then
			local ex = result
			expect(ex.message).toMatch("Expected throat fn to be a function")
			return
		end
		error(Error.new("Expected a failure"))
	end)
end)

it("sync errors are converted to async errors", function()
	local lock = throat(1) :: ThroatLateBound<any, any>
	return Promise.all({
		lock(function()
			error(Error.new("whatever"))
		end):catch(function()
			return true
		end),
		lock(function()
			error(Error.new("whatever"))
		end):catch(function()
			return true
		end),
		lock(function()
			error(Error.new("whatever"))
		end):catch(function()
			return true
		end),
	})
		:andThen(function(results)
			expect(results).toEqual({ true, true, true })
		end)
		:expect()
end)

it("handles loads of promises", function()
	local lock = throat(1, function(i)
		return Promise.resolve(i)
	end) :: ThroatEarlyBound<any, any>
	local results = {}
	local expected = {}
	for i = 0, 64 * 10 do
		local l = lock(i)
		table.insert(results, l)
		table.insert(expected, i)
	end
	return Promise.all(results)
		:andThen(function(results)
			expect(results).toEqual(expected)
		end)
		:expect()
end)

local function supportsAsyncStackTraces()
	return Promise.resolve():andThen(function()
		local function innerFunction()
			return Promise.resolve():andThen(function()
				Promise.new(function(resolve)
					return setTimeout(resolve, 10)
				end):expect()
				error(Error.new("whatever"))
			end)
		end
		local function myOuterFunction()
			return Promise.resolve():andThen(function()
				innerFunction():expect()
			end)
		end
		local ok, result = pcall(function()
			myOuterFunction():expect()
		end)
		if not ok then
			local ex = result
			return Boolean.toJSBoolean(ex.stack) and string.match(ex.stack, "myOuterFunction")
		end
		return false
	end)
end

-- ROBLOX TODO: async stacktrace doesn't seem to be supported by Promise library
itFIXME("stack traces", function()
	return Promise.resolve()
		:andThen(function()
			if not supportsAsyncStackTraces():expect() then
				console.warn("Async stack traces not supported")
				return
			end
			local lock = throat(1) :: ThroatLateBound<any, any>

			local function myInnerFunction()
				return Promise.resolve():andThen(function()
					Promise.new(function(resolve)
						return setTimeout(resolve, 10)
					end):expect()
					error(Object.assign(Error.new("My Error"), { code = "MY_ERROR" }))
				end)
			end
			local function myOuterFunction()
				return Promise.resolve():andThen(function()
					lock(myInnerFunction):expect()
				end)
			end
			return Promise.all({
				myOuterFunction():andThen(function()
					error(Error.new("Expected an error to be thrown"))
				end, function(ex)
					assert(
						string.match(ex.stack, "myInnerFunction"),
						("Stack should include myInnerFunction: %s\n\n"):format(tostring(ex.stack))
					)
					assert(
						string.match(ex.stack, "myOuterFunction"),
						("Stack should include myOuterFunction: %s\n\n"):format(tostring(ex.stack))
					)
					expect(ex.code).toBe("MY_ERROR")
					expect(ex.message).toBe("My Error")
				end),
				myOuterFunction():andThen(function()
					error(Error.new("Expected an error to be thrown"))
				end, function(ex)
					assert(
						string.match(ex.stack, "myInnerFunction"),
						("Stack should include myInnerFunction: %s\n\n"):format(tostring(ex.stack))
					)
					assert(
						string.match(ex.stack, "myOuterFunction"),
						("Stack should include myOuterFunction: %s\n\n"):format(tostring(ex.stack))
					)
					expect(ex.code).toBe("MY_ERROR")
					expect(ex.message).toBe("My Error")
				end),
				myOuterFunction():andThen(function()
					error(Error.new("Expected an error to be thrown"))
				end, function(ex)
					assert(
						string.match(ex.stack, "myInnerFunction"),
						("Stack should include myInnerFunction: %s\n\n"):format(tostring(ex.stack))
					)
					assert(
						string.match(ex.stack, "myOuterFunction"),
						("Stack should include myOuterFunction: %s\n\n"):format(tostring(ex.stack))
					)
					expect(ex.code).toBe("MY_ERROR")
					expect(ex.message).toBe("My Error")
				end),
			})
		end)
		:expect()
end)

-- ROBLOX TODO: async stacktrace doesn't seem to be supported by Promise library
itFIXME("stack traces - ready provided fn", function()
	return Promise.resolve()
		:andThen(function()
			if not (supportsAsyncStackTraces():expect()) then
				console.warn("Async stack traces not supported")
				return
			end
			local function myInnerFunction()
				return Promise.resolve():andThen(function()
					Promise.new(function(resolve)
						return setTimeout(resolve, 10)
					end):expect()
					error(Object.assign(Error.new("My Error"), { code = "MY_ERROR" }))
				end)
			end
			local lock = throat(1, myInnerFunction) :: ThroatEarlyBound<any, any>
			local function myOuterFunction()
				return Promise.resolve():andThen(function()
					lock():expect()
				end)
			end
			return Promise.all({
				myOuterFunction():andThen(function()
					error(Error.new("Expected an error to be thrown"))
				end, function(ex)
					assert(
						string.match(ex.stack, "myInnerFunction"),
						("Stack should include myInnerFunction: %s\n\n"):format(tostring(ex.stack))
					)
					assert(
						string.match(ex.stack, "myOuterFunction"),
						("Stack should include myOuterFunction: %s\n\n"):format(tostring(ex.stack))
					)
					expect(ex.code).toBe("MY_ERROR")
					expect(ex.message).toBe("My Error")
				end),
				myOuterFunction():andThen(function()
					error(Error.new("Expected an error to be thrown"))
				end, function(ex)
					assert(
						string.match(ex.stack, "myInnerFunction"),
						("Stack should include myInnerFunction: %s\n\n"):format(tostring(ex.stack))
					)
					assert(
						string.match(ex.stack, "myOuterFunction"),
						("Stack should include myOuterFunction: %s\n\n"):format(tostring(ex.stack))
					)
					expect(ex.code).toBe("MY_ERROR")
					expect(ex.message).toBe("My Error")
				end),
				myOuterFunction():andThen(function()
					error(Error.new("Expected an error to be thrown"))
				end, function(ex)
					assert(
						string.match(ex.stack, "myInnerFunction"),
						("Stack should include myInnerFunction: %s\n\n"):format(tostring(ex.stack))
					)
					assert(
						string.match(ex.stack, "myOuterFunction"),
						("Stack should include myOuterFunction: %s\n\n"):format(tostring(ex.stack))
					)
					expect(ex.code).toBe("MY_ERROR")
					expect(ex.message).toBe("My Error")
				end),
			})
		end)
		:expect()
end)

return {}
