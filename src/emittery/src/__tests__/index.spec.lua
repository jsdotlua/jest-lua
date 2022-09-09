-- ROBLOX upstream: https://github.com/sindresorhus/emittery/blob/v0.11.0/test/index.js
--[[
	MIT License

	Copyright (c) Sindre Sorhus <sindresorhus@gmail.com> (https://sindresorhus.com)
]]

local Packages = script.Parent.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local setTimeout = LuauPolyfill.setTimeout
local Symbol = LuauPolyfill.Symbol
local Promise = require(Packages.Promise)
local setImmediate = setTimeout
local TypeError = Error
type Object = LuauPolyfill.Object

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local it = JestGlobals.it
local itFIXME = function(description: string, ...: any)
	JestGlobals.it.todo(description)
end

-- ROBLOX deviation START: implement t object to limit deviations in tests
local function pEvent(emitter, eventName, _options: Object?)
	return emitter:once(eventName)
end
local t = {
	deepEqual = function(_self, value1, value2)
		expect(value1).toEqual(value2)
	end,
	is = function(_self, value1, value2)
		expect(value1).toBe(value2)
	end,
	true_ = function(_self, value)
		expect(value).toBe(true)
	end,
	false_ = function(_self, value)
		expect(value).toBe(false)
	end,
	pass = function(_self) end,
	fail = function(_self)
		error(Error.new("fail"))
	end,
	throws = function(_self, fn, err)
		expect(fn).toThrow(err)
	end,
	throwsAsync = function(_self, ...)
		error("throwsAsync not implemented yet")
	end,
	notThrowsAsync = function(_self, ...)
		error("notThrowsAsync not implemented yet")
	end,
}
-- ROBLOX deviation END

-- local test = require(Packages.ava).default
-- local delay_ = require(Packages.delay).default
-- local pEvent = require(Packages["p-event"]).default
local Emittery = require(script.Parent.Parent).default
it("on()", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local eventName = Symbol("eventName")
			local calls = {}
			local function listener1()
				table.insert(calls, 1)
			end

			local function listener2()
				table.insert(calls, 2)
			end

			local function listener3()
				table.insert(calls, 3)
			end

			emitter:on("🦄", listener1)
			emitter:on("🦄", listener2)
			emitter:on(eventName, listener3)
			emitter:emit("🦄"):expect()
			emitter:emit(eventName):expect()
			t:deepEqual(calls, { 1, 2, 3 })
		end)
		:expect()
end)

it("on() - multiple event names", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local eventName = Symbol("eventName")
			local count = 0
			local function listener()
				count += 1
			end

			emitter:on({ "🦄", "🐶", eventName }, listener)
			emitter:emit("🦄"):expect()
			emitter:emit("🐶"):expect()
			emitter:emit(eventName):expect()
			t:is(count, 3)
		end)
		:expect()
end)

it("on() - symbol eventName", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local eventName = Symbol("eventName")
			local calls = {}
			local function listener1()
				table.insert(calls, 1)
			end

			local function listener2()
				table.insert(calls, 2)
			end

			emitter:on(eventName, listener1)
			emitter:on(eventName, listener2)
			emitter:emit(eventName):expect()
			t:deepEqual(calls, { 1, 2 })
		end)
		:expect()
end)

it("on() - listenerAdded", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local function addListener()
				return 1
			end
			setImmediate(function()
				return emitter:on("abc", addListener)
			end)
			local ref = pEvent(emitter, Emittery.listenerAdded, { rejectionEvents = {} }):expect()
			local eventName, listener = ref.eventName, ref.listener
			t:is(listener, addListener)
			t:is(eventName, "abc")
		end)
		:expect()
end)

it("on() - listenerRemoved", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local function addListener()
				return 1
			end
			emitter:on("abc", addListener)
			setImmediate(function()
				return emitter:off("abc", addListener)
			end)
			local ref = pEvent(emitter, Emittery.listenerRemoved, { rejectionEvents = {} }):expect()
			local eventName, listener = ref.eventName, ref.listener
			t:is(listener, addListener)
			t:is(eventName, "abc")
		end)
		:expect()
end)

it("on() - listenerAdded onAny", function()
	return Promise.resolve():andThen(function()
		local emitter = Emittery.new()
		local function addListener()
			return 1
		end
		setImmediate(function()
			return emitter:onAny(addListener)
		end)
		local ref = pEvent(emitter, Emittery.listenerAdded, { rejectionEvents = {} }):expect()
		local eventName, listener = ref.eventName, ref.listener
		t:is(listener, addListener)
		t:is(eventName, nil)
	end)
end)

it("off() - listenerAdded", function()
	local emitter = Emittery.new()
	local off = emitter:on(Emittery.listenerAdded, function()
		return t:fail()
	end)
	off()
	emitter:emit("a")
	t:pass()
end)

it("off() - isDebug logs output", function()
	local eventStore = {}

	local emitter = Emittery.new({
		debug = {
			name = "testEmitter",
			enabled = true,
			logger = function(_self, type_, debugName, eventName, eventData)
				table.insert(eventStore, {
					type = type_,
					debugName = debugName,
					eventName = eventName,
					eventData = eventData,
				})
			end,
		},
	})

	local off = emitter:on("test", function() end)
	off()
	t:true_(#eventStore > 0)
	t:is(eventStore[3].type, "unsubscribe")
	t:is(eventStore[3].eventName, "test")
	t:is(eventStore[3].debugName, "testEmitter")
end)

it("on() - listenerAdded offAny", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local function addListener()
				return 1
			end
			emitter:onAny(addListener)
			setImmediate(function()
				return emitter:offAny(addListener)
			end)
			local ref = pEvent(emitter, Emittery.listenerRemoved):expect()
			local listener, eventName = ref.listener, ref.eventName
			t:is(listener, addListener)
			t:is(eventName, nil)
		end)
		:expect()
end)

it("on() - eventName must be a string, symbol, or number", function()
	local emitter = Emittery.new()

	emitter:on("string", function() end)
	emitter:on(Symbol("symbol"), function() end)
	emitter:on(42, function() end)

	t:throws(function()
		emitter:on(true, function() end)
	end, TypeError)
end)

it("on() - must have a listener", function()
	local emitter = Emittery.new()
	t:throws(function()
		emitter:on("🦄")
	end, TypeError)
end)

it("on() - returns a unsubcribe method", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			local function listener()
				table.insert(calls, 1)
			end

			local off = emitter:on("🦄", listener)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })

			off()
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })
		end)
		:expect()
end)

it("on() - dedupes identical listeners", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			local function listener()
				table.insert(calls, 1)
			end

			emitter:on("🦄", listener)
			emitter:on("🦄", listener)
			emitter:on("🦄", listener)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })
		end)
		:expect()
end)

it("on() - isDebug logs output", function()
	local eventStore = {}
	local calls = {}

	local emitter = Emittery.new({
		debug = {
			name = "testEmitter",
			enabled = true,
			logger = function(_self, type_, debugName, eventName, eventData)
				table.insert(eventStore, {
					type = type_,
					debugName = debugName,
					eventName = eventName,
					eventData = eventData,
				})
			end,
		},
	})

	emitter:on("test", function(data)
		return table.insert(calls, data)
	end)
	t:true_(#eventStore > 0)
	t:is(eventStore[1].type, "subscribe")
	t:is(eventStore[1].debugName, "testEmitter")
	t:is(eventStore[1].eventName, "test")
end)

-- ROBLOX TODO START: implement test:serial tests
-- 	test:serial("events()", function()
-- 		return Promise.resolve():andThen(function()
-- 			local emitter = Emittery.new()
-- 			local iterator = emitter:events("🦄")
-- 			emitter:emit("🦄", "🌈"):expect()
-- 			setTimeout(function()
-- 				emitter:emit("🦄", Promise.resolve("🌟"))
-- 			end, 10)
-- 			t:plan(3)
-- 			local expected = { "🌈", "🌟" }
-- 			error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: ForOfStatement with await modifier ]] --[[ for await (const data of iterator) {
--     t.deepEqual(data, expected.shift());

--     if (expected.length === 0) {
--       break;
--     }
--   } ]]
-- 			t:deepEqual(iterator:next():expect(), { done = true })
-- 		end)
-- 	end)
-- 	test:serial("events() - multiple event names", function()
-- 		return Promise.resolve():andThen(function()
-- 			local emitter = Emittery.new()
-- 			local iterator = emitter:events({ "🦄", "🐶" })
-- 			emitter:emit("🦄", "🌈"):expect()
-- 			emitter:emit("🐶", "🌈"):expect()
-- 			setTimeout(function()
-- 				emitter:emit("🦄", Promise.resolve("🌟"))
-- 			end, 10)
-- 			t:plan(4)
-- 			local expected = { "🌈", "🌈", "🌟" }
-- 			error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: ForOfStatement with await modifier ]] --[[ for await (const data of iterator) {
--     t.deepEqual(data, expected.shift());

--     if (expected.length === 0) {
--       break;
--     }
--   } ]]
-- 			t:deepEqual(iterator:next():expect(), { done = true })
-- 		end)
-- 	end)
-- ROBLOX TODO END

it("events() - return() called during emit", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = nil
			emitter:on("🦄", function()
				iterator["return"](iterator)
			end)
			iterator = emitter:events("🦄")
			emitter:emit("🦄", "🌈")
			t:deepEqual(iterator:next():expect(), { done = false, value = "🌈" })
			t:deepEqual(iterator:next():expect(), { done = true })
		end)
		:expect()
end)

it("events() - return() awaits its argument", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = emitter:events("🦄")
			t:deepEqual(iterator["return"](iterator, Promise.resolve(1)):expect(), { done = true, value = 1 })
		end)
		:expect()
end)

it("events() - return() without argument", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = emitter:events("🦄")
			t:deepEqual(iterator["return"](iterator):expect(), { done = true })
		end)
		:expect()
end)

it("events() - discarded iterators should stop receiving events", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = emitter:events("🦄")

			emitter:emit("🦄", "🌈"):expect()
			t:deepEqual(iterator:next():expect(), { value = "🌈", done = false })
			iterator["return"](iterator):expect()
			emitter:emit("🦄", "🌈"):expect()
			t:deepEqual(iterator:next():expect(), { done = true })

			setTimeout(function()
				emitter:emit("🦄", "🌟")
			end, 10)

			Promise.new(function(resolve)
				setTimeout(resolve, 20)
			end):expect()

			t:deepEqual(iterator:next():expect(), { done = true })
		end)
		:expect()
end)

it("off()", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			local function listener()
				table.insert(calls, 1)
			end

			emitter:on("🦄", listener)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })

			emitter:off("🦄", listener)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })
		end)
		:expect()
end)

it("off() - multiple event names", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			local function listener()
				table.insert(calls, 1)
			end

			emitter:on({ "🦄", "🐶", "🦊" }, listener)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })

			emitter:off({ "🦄", "🐶" }, listener)
			emitter:emit("🦄"):expect()
			emitter:emit("🐶"):expect()
			t:deepEqual(calls, { 1 })

			emitter:emit("🦊"):expect()
			t:deepEqual(calls, { 1, 1 })
		end)
		:expect()
end)

it("off() - eventName must be a string, symbol, or number", function()
	local emitter = Emittery.new()
	emitter:on("string", function() end)
	emitter:on(Symbol("symbol"), function() end)
	emitter:on(42, function() end)
	t:throws(function()
		emitter:off(true)
	end, TypeError)
end)

it("off() - no listener", function()
	local emitter = Emittery.new()
	t:throws(function()
		emitter:off("🦄")
	end, TypeError)
end)

it("once()", function()
	return Promise.resolve()
		:andThen(function()
			local fixture = "🌈"
			local emitter = Emittery.new()
			local promise = emitter:once("🦄")
			emitter:emit("🦄", fixture)
			t:is(promise:expect(), fixture)
		end)
		:expect()
end)

it("once() - multiple event names", function()
	return Promise.resolve():andThen(function()
		local fixture = "🌈"
		local emitter = Emittery.new()
		local promise = emitter:once({ "🦄", "🐶" })
		emitter:emit("🐶", fixture)
		t:is(promise:expect(), fixture)
	end)
end)

-- ROBLOX TODO: implement throwsAsync
itFIXME("once() - eventName must be a string, symbol, or number", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			emitter:once("string")
			emitter:once(Symbol("symbol"))
			emitter:once(42)
			t:throwsAsync(emitter:once("true", function() end), TypeError):expect()
		end)
		:expect()
end)

-- ROBLOX TODO START: implement test:cb tests
-- test:cb("emit() - one event", function()
-- 	t:plan(1)
-- 	local emitter = Emittery.new()
-- 	local eventFixture = { foo = true }
-- 	emitter:on("🦄", function(data)
-- 		t:deepEqual(data, eventFixture)
-- 		t:end_()
-- 	end)
-- 	emitter:emit("🦄", eventFixture)
-- end)
-- test:cb("emit() - multiple events", function()
-- 	t:plan(1)
-- 	local emitter = Emittery.new()
-- 	local count = 0
-- 	emitter:on("🦄", function()
-- 		return Promise.resolve():andThen(function()
-- 			delay_(Math:random() * 100):expect()
-- 			if
-- 				(function()
-- 					count += 1
-- 					return count
-- 				end)()
-- 				>= 5 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
-- 			then
-- 				t:is(count, 5)
-- 				t:end_()
-- 			end
-- 		end)
-- 	end)
-- 	emitter:emit("🦄")
-- 	emitter:emit("🦄")
-- 	emitter:emit("🦄")
-- 	emitter:emit("🦄")
-- 	emitter:emit("🦄")
-- end)
-- ROBLOX TODO END

-- ROBLOX TODO: implement throwsAsync
itFIXME("emit() - eventName must be a string, symbol, or number", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			emitter:emit("string")
			emitter:emit(Symbol("symbol"))
			emitter:emit(42)
			t:throwsAsync(emitter:emit(true), TypeError):expect()
		end)
		:expect()
end)

-- ROBLOX TODO: implement throwsAsync
itFIXME("emit() - userland cannot emit the meta events", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			t:throwsAsync(emitter:emit(Emittery.listenerRemoved), TypeError):expect()
			t:throwsAsync(emitter:emit(Emittery.listenerAdded), TypeError):expect()
		end)
		:expect()
end)

-- ROBLOX TODO START: implement test:cb tests
-- test:cb("emit() - is async", function()
-- 	t:plan(2)
-- 	local emitter = Emittery.new()
-- 	local unicorn = false
-- 	emitter:on("🦄", function()
-- 		unicorn = true
-- 		t:pass()
-- 		t:end_()
-- 	end)
-- 	emitter:emit("🦄")
-- 	t:false_(unicorn)
-- end)
-- ROBLOX TODO END

it("emit() - awaits async listeners", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local unicorn = false

			emitter:on("🦄", function()
				return Promise.resolve():andThen(function()
					Promise.resolve():expect()
					unicorn = true
				end)
			end)

			local promise = emitter:emit("🦄")
			t:false_(unicorn)
			promise:expect()
			t:true_(unicorn)
		end)
		:expect()
end)

it("emit() - calls listeners subscribed when emit() was invoked", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			local off1 = emitter:on("🦄", function()
				table.insert(calls, 1)
			end)
			local p = emitter:emit("🦄")
			emitter:on("🦄", function()
				table.insert(calls, 2)
			end)
			p:expect()
			t:deepEqual(calls, { 1 })
			local off3 = emitter:on("🦄", function()
				table.insert(calls, 3)
				off1()
				emitter:on("🦄", function()
					table.insert(calls, 4)
				end)
			end)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3 })
			off3()

			local off5 = emitter:on("🦄", function()
				table.insert(calls, 5)
				emitter:onAny(function()
					table.insert(calls, 6)
				end)
			end)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5 })
			off5()

			local off8 = nil
			emitter:on("🦄", function()
				table.insert(calls, 7)
				off8()
			end)
			off8 = emitter:on("🦄", function()
				table.insert(calls, 8)
			end)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6 })

			local off10 = nil
			emitter:onAny(function()
				table.insert(calls, 9)
				off10()
			end)
			off10 = emitter:onAny(function()
				table.insert(calls, 10)
			end)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6, 2, 4, 7, 6, 9 })

			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6, 2, 4, 7, 6, 9, 2, 4, 7, 6, 9 })

			local p2 = emitter:emit("🦄")
			emitter:clearListeners()
			p2:expect()
			-- ROBLOX FIXME: this assertion fails
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6, 2, 4, 7, 6, 9, 2, 4, 7, 6, 9 })
		end)
		:expect()
end)

it("emit() - isDebug logs output", function()
	return Promise.resolve()
		:andThen(function()
			local eventStore = {}

			local emitter = Emittery.new({
				debug = {
					name = "testEmitter",
					enabled = true,
					logger = function(_self, type_, debugName, eventName, eventData)
						table.insert(eventStore, {
							type = type_,
							debugName = debugName,
							eventName = eventName,
							eventData = eventData,
						})
					end,
				},
			})

			emitter:on("test", function() end)
			emitter:emit("test", "data"):expect()
			t:true_(#eventStore > 0)
			t:is(eventStore[3].type, "emit")
			t:is(eventStore[3].eventName, "test")
			t:is(eventStore[3].debugName, "testEmitter")
			t:is(eventStore[3].eventData, "data")
		end)
		:expect()
end)

it("emit() - returns undefined", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()

			emitter:on("🦄", function()
				return "🌈"
			end)
			t:is(emitter:emit("🦄"):expect(), nil)

			emitter:on("🦄🦄", function()
				return Promise.resolve():andThen(function()
					return "🌈"
				end)
			end)
			t:is(emitter:emit("🦄🦄"):expect(), nil)
		end)
		:expect()
end)

-- ROBLOX TODO: implement throwsAsync
itFIXME("emit() - throws an error if any listener throws", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()

			emitter:on("🦄", function()
				error(Error.new("🌈"))
			end)
			t:throwsAsync(emitter:emit("🦄"), { instanceOf = Error }):expect()

			emitter:on("🦄🦄", function()
				return Promise.resolve():andThen(function()
					error(Error.new("🌈"))
				end)
			end)
			t:throwsAsync(emitter:emit("🦄🦄"), { instanceOf = Error }):expect()
		end)
		:expect()
end)

-- ROBLOX TODO START: implement test:cb tests
-- test:cb("emitSerial()", function()
-- 	t:plan(1)
-- 	local emitter = Emittery.new()
-- 	local events = {}
-- 	local function listener(data)
-- 		return Promise.resolve():andThen(function()
-- 			delay_(Math:random() * 100):expect()
-- 			table.insert(events, data) --[[ ROBLOX CHECK: check if 'events' is an Array ]]
-- 			if
-- 				events.length
-- 				>= 5 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
-- 			then
-- 				t:deepEqual(events, { 1, 2, 3, 4, 5 })
-- 				t:end_()
-- 			end
-- 		end)
-- 	end
-- 	emitter:on("🦄", function()
-- 		return listener(1)
-- 	end)
-- 	emitter:on("🦄", function()
-- 		return listener(2)
-- 	end)
-- 	emitter:on("🦄", function()
-- 		return listener(3)
-- 	end)
-- 	emitter:on("🦄", function()
-- 		return listener(4)
-- 	end)
-- 	emitter:on("🦄", function()
-- 		return listener(5)
-- 	end)
-- 	emitter:emitSerial("🦄", "e")
-- end)
-- ROBLOX TODO END

-- ROBLOX TODO: implement throwsAsync
itFIXME("emitSerial() - eventName must be a string, symbol, or number", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()

			emitter:emitSerial("string")
			emitter:emitSerial(Symbol("symbol"))
			emitter:emitSerial(42)

			t:throwsAsync(emitter:emitSerial(true), TypeError):expect()
		end)
		:expect()
end)

-- ROBLOX TODO: implement throwsAsync
itFIXME("emitSerial() - userland cannot emit the meta events", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			t:throwsAsync(emitter:emitSerial(Emittery.listenerRemoved), TypeError):expect()
			t:throwsAsync(emitter:emitSerial(Emittery.listenerAdded), TypeError):expect()
		end)
		:expect()
end)

-- ROBLOX TODO START: implement test:cb tests
-- test:cb("emitSerial() - is async", function()
-- 	t:plan(2)
-- 	local emitter = Emittery.new()
-- 	local unicorn = false
-- 	emitter:on("🦄", function()
-- 		unicorn = true
-- 		t:pass()
-- 		t:end_()
-- 	end)
-- 	emitter:emitSerial("🦄")
-- 	t:false_(unicorn)
-- end)
-- ROBLOX TODO END

it("emitSerial() - calls listeners subscribed when emitSerial() was invoked", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			local off1 = emitter:on("🦄", function()
				table.insert(calls, 1)
			end)
			local p = emitter:emitSerial("🦄")
			emitter:on("🦄", function()
				table.insert(calls, 2)
			end)
			p:expect()
			t:deepEqual(calls, { 1 })

			local off3 = emitter:on("🦄", function()
				table.insert(calls, 3)
				off1()
				emitter:on("🦄", function()
					table.insert(calls, 4)
				end)
			end)
			emitter:emitSerial("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3 })
			off3()

			local off5 = emitter:on("🦄", function()
				table.insert(calls, 5)
				emitter:onAny(function()
					table.insert(calls, 6)
				end)
			end)
			emitter:emitSerial("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5 })
			off5()

			local off8 = nil
			emitter:on("🦄", function()
				table.insert(calls, 7)
				off8()
			end)
			off8 = emitter:on("🦄", function()
				table.insert(calls, 8)
			end)
			emitter:emitSerial("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6 })

			local off10 = nil
			emitter:onAny(function()
				table.insert(calls, 9)
				off10()
			end)
			off10 = emitter:onAny(function()
				table.insert(calls, 10)
			end)
			emitter:emitSerial("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6, 2, 4, 7, 6, 9 })

			emitter:emitSerial("🦄"):expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6, 2, 4, 7, 6, 9, 2, 4, 7, 6, 9 })

			local p2 = emitter:emitSerial("🦄")
			emitter:clearListeners()
			p2:expect()
			t:deepEqual(calls, { 1, 1, 2, 3, 2, 4, 5, 2, 4, 7, 6, 2, 4, 7, 6, 9, 2, 4, 7, 6, 9 })
		end)
		:expect()
end)

it("emitSerial() - isDebug logs output", function()
	return Promise.resolve()
		:andThen(function()
			local eventStore = {}

			local emitter = Emittery.new({
				debug = {
					name = "testEmitter",
					enabled = true,
					logger = function(_self, type_, debugName, eventName, eventData)
						table.insert(eventStore, {
							type = type_,
							debugName = debugName,
							eventName = eventName,
							eventData = eventData,
						})
					end,
				},
			})

			emitter:on("test", function() end)
			emitter:emitSerial("test", "data"):expect()
			t:true_(#eventStore > 0)
			t:is(eventStore[3].type, "emitSerial")
			t:is(eventStore[3].eventName, "test")
			t:is(eventStore[3].debugName, "testEmitter")
			t:is(eventStore[3].eventData, "data")
		end)
		:expect()
end)

it("onAny()", function()
	return Promise.resolve()
		:andThen(function()
			-- ROBLOX deviation: implement t:plan(4) using manual assertCount
			local assertCount = 0
			local emitter = Emittery.new()
			local eventFixture = { foo = true }
			emitter:onAny(function(eventName, data)
				t:is(eventName, "🦄")
				t:deepEqual(data, eventFixture)
				-- ROBLOX deviation: implement t:plan(4) using manual assertCount
				assertCount += 2
			end)
			emitter:emit("🦄", eventFixture):expect()
			emitter:emitSerial("🦄", eventFixture):expect()
			-- ROBLOX deviation: implement t:plan(4) using manual assertCount
			expect(assertCount).toBe(4)
		end)
		:expect()
end)

it("onAny() - must have a listener", function()
	local emitter = Emittery.new()
	t:throws(function()
		emitter:onAny()
	end, TypeError)
end)

-- ROBLOX TODO START: implement test:serial tests
-- test:serial("anyEvent()", function()
-- 	return Promise.resolve():andThen(function()
-- 		local emitter = Emittery.new()
-- 		local iterator = emitter:anyEvent()
-- 		emitter:emit("�����", "🌈"):expect()
-- 		setTimeout(function()
-- 			emitter:emit("🦄", Promise.resolve("🌟"))
-- 		end, 10)
-- 		t:plan(3)
-- 		local expected = { { "🦄", "🌈" }, { "🦄", "🌟" } }
-- 		error("not implemented")
-- 		--[[ ROBLOX TODO: Unhandled node for type: ForOfStatement with await modifier ]]
-- 		--[[
-- 			for await (const data of iterator) {
-- 				t.deepEqual(data, expected.shift());

-- 				if (expected.length === 0) {
-- 				break;
-- 				}
-- 			}
-- 		]]
-- 		t:deepEqual(iterator:next():expect(), { done = true })
-- 	end)
-- end)
-- ROBLOX TODO END

it("anyEvent() - return() called during emit", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = nil
			emitter:onAny(function()
				iterator["return"](iterator)
			end)
			iterator = emitter:anyEvent()
			emitter:emit("🦄", "🌈")
			t:deepEqual(iterator:next():expect(), { done = false, value = { "🦄", "🌈" } })
			t:deepEqual(iterator:next():expect(), { done = true })
		end)
		:expect()
end)

it("anyEvents() - discarded iterators should stop receiving events", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = emitter:anyEvent()

			emitter:emit("🦄", "🌈"):expect()
			t:deepEqual(iterator:next():expect(), { value = { "🦄", "🌈" }, done = false })
			iterator["return"](iterator):expect()
			emitter:emit("🦄", "🌈"):expect()
			t:deepEqual(iterator:next():expect(), { done = true })

			setTimeout(function()
				emitter:emit("🦄", "🌟")
			end, 10)

			Promise.new(function(resolve)
				setTimeout(resolve, 20)
			end):expect()

			t:deepEqual(iterator:next():expect(), { done = true })
		end)
		:expect()
end)

it("offAny()", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			local function listener()
				table.insert(calls, 1)
			end

			emitter:onAny(listener)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })
			emitter:offAny(listener)
			emitter:emit("🦄"):expect()
			t:deepEqual(calls, { 1 })
		end)
		:expect()
end)

it("offAny() - no listener", function()
	local emitter = Emittery.new()
	t:throws(function()
		emitter:offAny()
	end, TypeError)
end)

it("clearListeners()", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			emitter:on("🦄", function()
				table.insert(calls, "🦄1")
			end)
			emitter:on("🌈", function()
				table.insert(calls, "🌈")
			end)
			emitter:on("🦄", function()
				table.insert(calls, "🦄2")
			end)
			emitter:onAny(function()
				table.insert(calls, "any1")
			end)
			emitter:onAny(function()
				table.insert(calls, "any2")
			end)
			emitter:emit("🦄"):expect()
			emitter:emit("🌈"):expect()
			t:deepEqual(calls, { "🦄1", "🦄2", "any1", "any2", "🌈", "any1", "any2" })
			emitter:clearListeners()
			emitter:emit("🦄"):expect()
			emitter:emit("🌈"):expect()
			t:deepEqual(calls, { "🦄1", "🦄2", "any1", "any2", "🌈", "any1", "any2" })
		end)
		:expect()
end)

it("clearListeners() - also clears iterators", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = emitter:events("🦄")
			local anyIterator = emitter:anyEvent()
			emitter:emit("🦄", "🌟"):expect()
			emitter:emit("🌈", "🌟"):expect()
			t:deepEqual(iterator:next():expect(), { done = false, value = "🌟" })
			t:deepEqual(anyIterator:next():expect(), { done = false, value = { "🦄", "🌟" } })
			t:deepEqual(anyIterator:next():expect(), { done = false, value = { "🌈", "🌟" } })
			emitter:emit("🦄", "💫"):expect()
			emitter:clearListeners()
			emitter:emit("🌈", "💫"):expect()
			t:deepEqual(iterator:next():expect(), { done = false, value = "💫" })
			t:deepEqual(iterator:next():expect(), { done = true })
			t:deepEqual(anyIterator:next():expect(), { done = false, value = { "🦄", "💫" } })
			t:deepEqual(anyIterator:next():expect(), { done = true })
		end)
		:expect()
end)

it("clearListeners() - with event name", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			emitter:on("🦄", function()
				table.insert(calls, "🦄1")
			end)
			emitter:on("🌈", function()
				table.insert(calls, "🌈")
			end)
			emitter:on("🦄", function()
				table.insert(calls, "🦄2")
			end)
			emitter:onAny(function()
				table.insert(calls, "any1")
			end)
			emitter:onAny(function()
				table.insert(calls, "any2")
			end)
			emitter:emit("🦄"):expect()
			emitter:emit("🌈"):expect()
			t:deepEqual(calls, { "🦄1", "🦄2", "any1", "any2", "🌈", "any1", "any2" })
			emitter:clearListeners("🦄")
			emitter:emit("🦄"):expect()
			emitter:emit("🌈"):expect()
			t:deepEqual(calls, {
				"🦄1",
				"🦄2",
				"any1",
				"any2",
				"🌈",
				"any1",
				"any2",
				"any1",
				"any2",
				"🌈",
				"any1",
				"any2",
			})
		end)
		:expect()
end)

it("clearListeners() - with multiple event names", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local calls = {}
			emitter:on("🦄", function()
				table.insert(calls, "🦄1")
			end)
			emitter:on("🌈", function()
				table.insert(calls, "🌈")
			end)
			emitter:on("🦄", function()
				table.insert(calls, "🦄2")
			end)
			emitter:onAny(function()
				table.insert(calls, "any1")
			end)
			emitter:emit("🦄"):expect()
			emitter:emit("🌈"):expect()
			t:deepEqual(calls, { "🦄1", "🦄2", "any1", "🌈", "any1" })
			emitter:clearListeners({ "🦄", "🌈" })
			emitter:emit("🦄"):expect()
			emitter:emit("🌈"):expect()
			t:deepEqual(calls, { "🦄1", "🦄2", "any1", "🌈", "any1", "any1", "any1" })
		end)
		:expect()
end)

it("clearListeners() - with event name - clears iterators for that event", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new()
			local iterator = emitter:events("🦄")
			local anyIterator = emitter:anyEvent()
			emitter:emit("🦄", "🌟"):expect()
			emitter:emit("🌈", "🌟"):expect()
			t:deepEqual(iterator:next():expect(), { done = false, value = "🌟" })
			t:deepEqual(anyIterator:next():expect(), { done = false, value = { "🦄", "🌟" } })
			t:deepEqual(anyIterator:next():expect(), { done = false, value = { "🌈", "🌟" } })
			emitter:emit("🦄", "💫"):expect()
			emitter:clearListeners("🦄")
			emitter:emit("🌈", "💫"):expect()
			t:deepEqual(iterator:next():expect(), { done = false, value = "💫" })
			t:deepEqual(iterator:next():expect(), { done = true })
			t:deepEqual(anyIterator:next():expect(), { done = false, value = { "🦄", "💫" } })
			t:deepEqual(anyIterator:next():expect(), { done = false, value = { "🌈", "💫" } })
		end)
		:expect()
end)

it("clearListeners() - isDebug logs output", function()
	local eventStore = {}

	local emitter = Emittery.new({
		debug = {
			name = "testEmitter",
			enabled = true,
			logger = function(_self, type_, debugName, eventName, eventData)
				table.insert(eventStore, {
					type = type_,
					debugName = debugName,
					eventName = eventName,
					eventData = eventData,
				})
			end,
		},
	})

	emitter:on("test", function() end)
	emitter:clearListeners("test")
	t:true_(#eventStore > 0)
	t:is(eventStore[3].type, "clear")
	t:is(eventStore[3].eventName, "test")
	t:is(eventStore[3].debugName, "testEmitter")
end)

it("onAny() - isDebug logs output", function()
	local eventStore = {}

	local emitter = Emittery.new({
		debug = {
			name = "testEmitter",
			enabled = true,
			logger = function(_self, type_, debugName, eventName, eventData)
				table.insert(eventStore, {
					type = type_,
					debugName = debugName,
					eventName = eventName,
					eventData = eventData,
				})
			end,
		},
	})

	emitter:onAny(function() end)
	t:true_(#eventStore > 0)
	t:is(eventStore[1].type, "subscribeAny")
	t:is(eventStore[1].eventName, nil)
	t:is(eventStore[1].debugName, "testEmitter")
end)

it("offAny() - isDebug logs output", function()
	local eventStore = {}

	local emitter = Emittery.new({
		debug = {
			name = "testEmitter",
			enabled = true,
			logger = function(_self, type_, debugName, eventName, eventData)
				table.insert(eventStore, {
					type = type_,
					debugName = debugName,
					eventName = eventName,
					eventData = eventData,
				})
			end,
		},
	})

	local off = emitter:onAny(function() end)
	off()
	t:true_(#eventStore > 0)
	t:is(eventStore[3].type, "unsubscribeAny")
	t:is(eventStore[3].eventName, nil)
	t:is(eventStore[3].debugName, "testEmitter")
end)

it("listenerCount()", function()
	local emitter = Emittery.new()
	emitter:on("🦄", function() end)
	emitter:on("🌈", function() end)
	emitter:on("🦄", function() end)
	emitter:onAny(function() end)
	emitter:onAny(function() end)
	t:is(emitter:listenerCount("🦄"), 4)
	t:is(emitter:listenerCount("🌈"), 3)
	t:is(emitter:listenerCount(), 5)
end)

it("listenerCount() - multiple event names", function()
	local emitter = Emittery.new()
	emitter:on("🦄", function() end)
	emitter:on("🌈", function() end)
	emitter:on("🦄", function() end)
	emitter:onAny(function() end)
	emitter:onAny(function() end)
	t:is(emitter:listenerCount({ "🦄", "🌈" }), 7)
	t:is(emitter:listenerCount(), 5)
end)

it("listenerCount() - works with empty eventName strings", function()
	local emitter = Emittery.new()
	emitter:on("", function() end)
	t:is(emitter:listenerCount(""), 1)
end)

it("listenerCount() - eventName must be undefined if not a string, symbol, or number", function()
	local emitter = Emittery.new()
	emitter:listenerCount("string")
	emitter:listenerCount(Symbol("symbol"))
	emitter:listenerCount(42)
	emitter:listenerCount()
	t:throws(function()
		emitter:listenerCount(true)
	end, TypeError)
end)

-- ROBLOX deviation START: not supporting Emittery:bindMethods for now
-- it("bindMethods()", function()
-- 	local methodsToBind = { "on", "off", "emit", "listenerCount" }
-- 	local emitter = Emittery.new()
-- 	local target = {}
-- 	local oldPropertyNames = Object.getOwnPropertyNames(target)
-- 	emitter:bindMethods(target, methodsToBind)
-- 	t:deepEqual(
-- 		Array.sort(Object.getOwnPropertyNames(target)), --[[ ROBLOX CHECK: check if 'Object.getOwnPropertyNames(target)' is an Array ]]
-- 		Array.sort(Array.concat({}, Array.spread(oldPropertyNames), Array.spread(methodsToBind)))
-- 	)
-- 	for _, method in methodsToBind do
-- 		t:is(typeof(target[tostring(method)]), "function")
-- 	end
-- 	t:is(target:listenerCount(), 0)
-- end)

-- it("bindMethods() - methodNames must be array of strings or undefined", function()
-- 	t:throws(function()
-- 		Emittery.new():bindMethods({}, nil)
-- 	end)
-- 	t:throws(function()
-- 		Emittery.new():bindMethods({}, "string")
-- 	end)
-- 	t:throws(function()
-- 		Emittery.new():bindMethods({}, {})
-- 	end)
-- 	t:throws(function()
-- 		Emittery.new():bindMethods({}, { nil })
-- 	end)
-- 	t:throws(function()
-- 		Emittery.new():bindMethods({}, { 1 })
-- 	end)
-- 	t:throws(function()
-- 		Emittery.new():bindMethods({}, { {} })
-- 	end)
-- end)

-- it("bindMethods() - must bind all methods if no array supplied", function()
-- 	local methodsExpected = {
-- 		"on",
-- 		"off",
-- 		"once",
-- 		"events",
-- 		"emit",
-- 		"emitSerial",
-- 		"onAny",
-- 		"anyEvent",
-- 		"offAny",
-- 		"clearListeners",
-- 		"listenerCount",
-- 		"bindMethods",
-- 		"logIfDebugEnabled",
-- 	}
-- 	local emitter = Emittery.new()
-- 	local target = {}
-- 	local oldPropertyNames = Object.getOwnPropertyNames(target)
-- 	emitter:bindMethods(target)
-- 	t:deepEqual(
-- 		Array.sort(Object.getOwnPropertyNames(target)), --[[ ROBLOX CHECK: check if 'Object.getOwnPropertyNames(target)' is an Array ]]
-- 		Array.sort(Array.concat({}, Array.spread(oldPropertyNames), Array.spread(methodsExpected)))
-- 	)
-- 	for _, method in
-- 		ipairs(methodsExpected) --[[ ROBLOX CHECK: check if 'methodsExpected' is an Array ]]
-- 	do
-- 		t:is(typeof(target[tostring(method)]), "function")
-- 	end
-- 	t:is(target:listenerCount(), 0)
-- end)

-- it("bindMethods() - methodNames must only include Emittery methods", function()
-- 	local emitter = Emittery.new()
-- 	local target = {}
-- 	t:throws(function()
-- 		return emitter:bindMethods(target, { "noexistent" })
-- 	end)
-- end)

-- it("bindMethods() - must not set already existing fields", function()
-- 	local emitter = Emittery.new()
-- 	local target = { on = true }
-- 	t:throws(function()
-- 		return emitter:bindMethods(target, { "on" })
-- 	end)
-- end)

-- it("bindMethods() - target must be an object", function()
-- 	local emitter = Emittery.new()
-- 	t:throws(function()
-- 		return emitter:bindMethods("string", {})
-- 	end)
-- 	t:throws(function()
-- 		return emitter:bindMethods(nil, {})
-- 	end)
-- 	t:throws(function()
-- 		return emitter:bindMethods(nil, {})
-- 	end)
-- end)
-- ROBLOX deviation END

-- ROBLOX deviation START: not supporting Emittery.mixin for now
-- it("mixin()", function()
-- 	type TestClass = {}
-- 	local TestClass = {}
-- 	TestClass.__index = TestClass
-- 	function TestClass.new(v): TestClass
-- 		local self = setmetatable({}, TestClass)
-- 		self.v = v
-- 		return (self :: any) :: TestClass
-- 	end
-- 	local TestClassWithMixin = Emittery:mixin("emitter", {
-- 		"on",
-- 		"off",
-- 		"once",
-- 		"emit",
-- 		"emitSerial",
-- 		"onAny",
-- 		"offAny",
-- 		"clearListeners",
-- 		"listenerCount",
-- 		"bindMethods",
-- 	})(TestClass)
-- 	local symbol = Symbol("test symbol")
-- 	local instance = TestClassWithMixin.new(symbol)
-- 	t:true_(
-- 		error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: BinaryExpression with 'instanceof' operator ]] --[[ instance.emitter instanceof Emittery ]]
-- 	)
-- 	t:true_(
-- 		error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: BinaryExpression with 'instanceof' operator ]] --[[ instance instanceof TestClass ]]
-- 	)
-- 	t:is(instance.emitter, instance.emitter)
-- 	t:is(instance.v, symbol)
-- 	t:is(instance:listenerCount(), 0)
-- end)

-- it("mixin() - methodNames must be array of strings or undefined", function()
-- 	type TestClass = {}
-- 	local TestClass = {}
-- 	TestClass.__index = TestClass
-- 	function TestClass.new(): TestClass
-- 		local self = setmetatable({}, TestClass)
-- 		return (self :: any) :: TestClass
-- 	end
-- 	t:throws(function()
-- 		return Emittery:mixin("emitter", nil)(TestClass)
-- 	end)
-- 	t:throws(function()
-- 		return Emittery:mixin("emitter", "string")(TestClass)
-- 	end)
-- 	t:throws(function()
-- 		return Emittery:mixin("emitter", {})(TestClass)
-- 	end)
-- 	t:throws(function()
-- 		return Emittery:mixin("emitter", { nil })(TestClass)
-- 	end)
-- 	t:throws(function()
-- 		return Emittery:mixin("emitter", { 1 })(TestClass)
-- 	end)
-- 	t:throws(function()
-- 		return Emittery:mixin("emitter", { {} })(TestClass)
-- 	end)
-- end)

-- it("mixin() - must mixin all methods if no array supplied", function()
-- 	local methodsExpected = {
-- 		"on",
-- 		"off",
-- 		"once",
-- 		"events",
-- 		"emit",
-- 		"emitSerial",
-- 		"onAny",
-- 		"anyEvent",
-- 		"offAny",
-- 		"clearListeners",
-- 		"listenerCount",
-- 		"bindMethods",
-- 		"logIfDebugEnabled",
-- 	}
-- 	type TestClass = {}
-- 	local TestClass = {}
-- 	TestClass.__index = TestClass
-- 	function TestClass.new(): TestClass
-- 		local self = setmetatable({}, TestClass)
-- 		return (self :: any) :: TestClass
-- 	end
-- 	local TestClassWithMixin = Emittery:mixin("emitter")(TestClass)
-- 	t:deepEqual(
-- 		Array.sort(Object.getOwnPropertyNames(TestClassWithMixin.prototype)), --[[ ROBLOX CHECK: check if 'Object.getOwnPropertyNames(TestClassWithMixin.prototype)' is an Array ]]
-- 		Array.sort(Array.concat({}, Array.spread(methodsExpected), { "constructor", "emitter" }))
-- 	)
-- end)

-- it("mixin() - methodNames must only include Emittery methods", function()
-- 	type TestClass = {}
-- 	local TestClass = {}
-- 	TestClass.__index = TestClass
-- 	function TestClass.new(): TestClass
-- 		local self = setmetatable({}, TestClass)
-- 		return (self :: any) :: TestClass
-- 	end
-- 	t:throws(function()
-- 		return Emittery:mixin("emitter", { "nonexistent" })(TestClass)
-- 	end)
-- end)

-- it("mixin() - must not set already existing methods", function()
-- 	type TestClass = { on: (self: TestClass) -> any }
-- 	local TestClass = {}
-- 	TestClass.__index = TestClass
-- 	function TestClass.new(): TestClass
-- 		local self = setmetatable({}, TestClass)
-- 		return (self :: any) :: TestClass
-- 	end
-- 	function TestClass:on()
-- 		return true
-- 	end
-- 	t:throws(function()
-- 		return Emittery:mixin("emitter", { "on" })(TestClass)
-- 	end)
-- end)

-- it("mixin() - target must be function", function()
-- 	t:throws(function()
-- 		return Emittery:mixin("emitter")("string")
-- 	end)
-- 	t:throws(function()
-- 		return Emittery:mixin("emitter")(nil)
-- 	end)
-- 	t:throws(function()
-- 		return Emittery:mixin("emitter")(nil)
-- 	end)
-- 	t:throws(function()
-- 		return Emittery:mixin("emitter")({})
-- 	end)
-- end)
-- ROBLOX deviation END

-- ROBLOX FIXME: implement notThrowsAsync
itFIXME("isDebug default logger handles symbol event names and object for event data", function()
	return Promise.resolve()
		:andThen(function()
			local emitter = Emittery.new({ debug = { name = "testEmitter", enabled = true } })
			local eventName = Symbol("test")
			emitter:on(eventName, function() end)
			t:notThrowsAsync(emitter:emit(eventName, { complex = { "data", "structure", 1 } })):expect()
		end)
		:expect()
end)

it("isDebug can be turned on globally during runtime", function()
	-- ROBLOX deviation: setIsDebugEnabled instead of a setter
	Emittery.setIsDebugEnabled(true)
	local eventStore = {}

	local emitter = Emittery.new({
		debug = {
			name = "testEmitter",
			enabled = false,
			logger = function(_self, type_, debugName, eventName, eventData)
				table.insert(eventStore, {
					type = type_,
					debugName = debugName,
					eventName = eventName,
					eventData = eventData,
				})
			end,
		},
	})

	emitter:on("test", function() end)
	emitter:emit("test", "test data")
	-- ROBLOX deviation: setIsDebugEnabled instead of a setter
	Emittery.setIsDebugEnabled(false)
	t:true_(#eventStore > 0)
	t:is(eventStore[3].type, "emit")
	t:is(eventStore[3].eventName, "test")
	t:is(eventStore[3].debugName, "testEmitter")
	t:is(eventStore[3].eventData, "test data")
end)

it("isDebug can be turned on for and instance without using the constructor", function()
	local eventStore = {}

	local emitter = Emittery.new({
		debug = {
			name = "testEmitter",
			enabled = false,
			logger = function(_self, type_, debugName, eventName, eventData)
				table.insert(eventStore, {
					type = type_,
					debugName = debugName,
					eventName = eventName,
					eventData = eventData,
				})
			end,
		},
	})
	emitter.debug.enabled = true

	emitter:on("test", function() end)
	emitter:emit("test", "test data")
	t:true_(#eventStore > 0)
	t:is(eventStore[3].type, "emit")
	t:is(eventStore[3].eventName, "test")
	t:is(eventStore[3].debugName, "testEmitter")
	t:is(eventStore[3].eventData, "test data")
end)

-- ROBLOX FIXME: implement notThrowsAsync
itFIXME("debug mode - handles circular references in event data", function()
	return Promise.resolve():andThen(function()
		local emitter = Emittery.new({ debug = { name = "testEmitter", enabled = true } })

		local data = {}
		data.circular = data

		t:notThrowsAsync(emitter:emit("test", data)):expect()
	end)
end)

return {}
