-- ROBLOX upstream: https://github.com/facebook/jest/tree/v27.4.7/packages/jest-util/src/__tests__/createProcessObject.test.ts

--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

return (function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	type Function = (...any) -> ...any

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local it = JestGlobals.it --(JestGlobals.it :: any) :: Function
	--[[
		ROBLOX deviation:
		skipped whole file as it seems unnecessary in Lua environment
	]]
	-- local LuauPolyfill = require(Packages.LuauPolyfill)
	-- local Array = LuauPolyfill.Array
	-- -- local EventEmitter = require(Packages.events).EventEmitter
	-- local createProcessObject
	-- local function requireCreateProcessObject()
	-- 	jest:isolateModules(function()
	-- 		createProcessObject = require("../createProcessObject").default
	-- 	end)
	-- end
	-- it("creates a process object that looks like the original one", function()
	-- 	requireCreateProcessObject()
	-- 	local fakeProcess = createProcessObject() -- "process" inherits from EventEmitter through the prototype chain.
	-- 	expect(
	-- 		error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: BinaryExpression ]] --[[ fakeProcess instanceof EventEmitter ]]
	-- 	).toBe(true) -- They look the same, but they are NOT the same (deep copied object). The
	-- 	-- "_events" property is checked to ensure event emitter properties are
	-- 	-- properly copied.
	-- 	Array.forEach({ "argv", "env", "_events" }, function(key)
	-- 		-- @ts-expect-error
	-- 		expect(fakeProcess[tostring(key)]).toEqual(process[tostring(key)]) -- @ts-expect-error
	-- 		expect(fakeProcess[tostring(key)]).not_.toBe(process[tostring(key)])
	-- 	end) -- Check that process.stdout/stderr are the same.
	-- 	expect(process.stdout).toBe(fakeProcess.stdout)
	-- 	expect(process.stderr).toBe(fakeProcess.stderr)
	-- end)
	-- it('fakes require("process") so it is equal to "global.process"', function()
	-- 	expect(require("process") == process).toBe(true)
	-- end)
	-- it("checks that process.env works as expected on Linux platforms", function()
	-- 	Object.defineProperty(process, "platform", {
	-- 		get = function()
	-- 			return "linux"
	-- 		end,
	-- 	})
	-- 	requireCreateProcessObject() -- Existing properties inside process.env are copied to the fake environment.
	-- 	process.env.PROP_STRING = "foo" -- @ts-expect-error
	-- 	process.env.PROP_NUMBER = 3
	-- 	process.env.PROP_UNDEFINED = nil
	-- 	local fake = createProcessObject().env -- All values converted to strings.
	-- 	expect(fake.PROP_STRING).toBe("foo")
	-- 	expect(fake.PROP_NUMBER).toBe("3")
	-- 	expect(fake.PROP_UNDEFINED).toBe("undefined") -- Mac and Linux are case sensitive.
	-- 	expect(fake.PROP_string).toBe(nil) -- Added properties to the fake object are not added to the real one.
	-- 	fake.PROP_ADDED = "new!"
	-- 	expect(fake.PROP_ADDED).toBe("new!")
	-- 	expect(process.env.PROP_ADDED).toBe(nil) -- You can delete properties, but they are case sensitive!
	-- 	fake.prop = "foo"
	-- 	fake.PROP = "bar"
	-- 	expect(fake.prop).toBe("foo")
	-- 	expect(fake.PROP).toBe("bar")
	-- 	fake.PROP = nil
	-- 	expect(fake.prop).toBe("foo")
	-- 	expect(fake.PROP).toBe(nil)
	-- end)
	-- it("checks that process.env works as expected in Windows platforms", function()
	-- 	Object.defineProperty(process, "platform", {
	-- 		get = function()
	-- 			return "win32"
	-- 		end,
	-- 	})
	-- 	requireCreateProcessObject() -- Windows is not case sensitive when it comes to property names.
	-- 	process.env.PROP_STRING = "foo"
	-- 	local fake = createProcessObject().env
	-- 	expect(fake.PROP_STRING).toBe("foo")
	-- 	expect(fake.PROP_string).toBe("foo") -- Inherited methods, however, are not affected by case insensitiveness.
	-- 	expect(typeof(fake.toString)).toBe("function")
	-- 	expect(typeof(fake.valueOf)).toBe("function")
	-- 	expect(typeof(fake.tostring)).toBe("undefined")
	-- 	expect(typeof(fake.valueof)).toBe("undefined") -- You can delete through case-insensitiveness too.
	-- 	fake.prop_string = nil
	-- 	expect(fake:hasOwnProperty("PROP_STRING")).toBe(false)
	-- 	expect(fake:hasOwnProperty("PROP_string")).toBe(false)
	-- end)

	it.todo("empty test")

	return {}
end)()
