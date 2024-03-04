-- ROBLOX upstream: https://github.com/facebook/jest/blob/v28.0.0/packages/jest-core/src/__tests__/collectHandles.test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
-- ROBLOX deviation START: collectHandles not ported yet
-- local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
-- local Array = LuauPolyfill.Array
-- local clearInterval = LuauPolyfill.clearInterval
-- local setInterval = LuauPolyfill.setInterval
-- local Promise = require("@pkg/@jsdotlua/promise")
-- local dns = require("@pkg/dns").promises
-- local http = require("@pkg/http").default
-- local PerformanceObserver = require("@pkg/perf_hooks").PerformanceObserver
-- local zlib = require("@pkg/zlib").default
-- local collectHandles = require("../collectHandles").default
-- describe("collectHandles", function()
-- 	it("should collect Timeout", function()
-- 		return Promise.resolve():andThen(function()
-- 			local handleCollector = collectHandles()
-- 			local interval = setInterval(function() end, 100)
-- 			local openHandles = handleCollector():expect()
-- 			expect(openHandles).toContainEqual(expect:objectContaining({ message = "Timeout" }))
-- 			clearInterval(interval)
-- 		end)
-- 	end)
-- 	it("should not collect the PerformanceObserver open handle", function()
-- 		return Promise.resolve():andThen(function()
-- 			local handleCollector = collectHandles()
-- 			local obs = PerformanceObserver.new(function(list, observer) end)
-- 			obs:observe({ entryTypes = { "mark" } })
-- 			local openHandles = handleCollector():expect()
-- 			expect(openHandles)["not"].toContainEqual(expect:objectContaining({ message = "PerformanceObserver" }))
-- 			obs:disconnect()
-- 		end)
-- 	end)
-- 	it("should not collect the DNSCHANNEL open handle", function()
-- 		return Promise.resolve():andThen(function()
-- 			local handleCollector = collectHandles()
-- 			local resolver = dns.Resolver.new()
-- 			resolver:getServers()
-- 			local openHandles = handleCollector():expect()
-- 			expect(openHandles)["not"].toContainEqual(expect:objectContaining({ message = "DNSCHANNEL" }))
-- 		end)
-- 	end)
-- 	it("should not collect the ZLIB open handle", function()
-- 		return Promise.resolve():andThen(function()
-- 			local handleCollector = collectHandles()
-- 			local decompressed = zlib:inflateRawSync(
-- 				Array.from(Buffer, "cb2a2d2e5128492d2ec9cc4b0700", "hex") --[[ ROBLOX CHECK: check if 'Buffer' is an Array ]]
-- 			)
-- 			local openHandles = handleCollector():expect()
-- 			expect(openHandles)["not"].toContainEqual(expect:objectContaining({ message = "ZLIB" }))
-- 		end)
-- 	end)
-- 	it("should collect handles opened in test functions with `done` callbacks", function(done)
-- 		local handleCollector = collectHandles()
-- 		local server = http:createServer(function(_, response)
-- 			return response:end_("ok")
-- 		end)
-- 		server:listen(0, function()
-- 			-- Collect results while server is still open.
-- 			handleCollector()
-- 				:then_(function(openHandles)
-- 					server:close(function()
-- 						expect(openHandles).toContainEqual(expect:objectContaining({ message = "TCPSERVERWRAP" }))
-- 						done()
-- 					end)
-- 				end)
-- 				:catch(done)
-- 		end)
-- 	end)
-- 	it("should not collect handles that have been queued to close", function()
-- 		return Promise.resolve():andThen(function()
-- 			local handleCollector = collectHandles()
-- 			local server = http:createServer(function(_, response)
-- 				return response:end_("ok")
-- 			end) -- Start and stop server.
-- 			Promise.new(function(r)
-- 				return server:listen(0, r)
-- 			end):expect()
-- 			Promise.new(function(r)
-- 				return server:close(r)
-- 			end):expect()
-- 			local openHandles = handleCollector():expect()
-- 			expect(openHandles).toHaveLength(0)
-- 		end)
-- 	end)
-- 	it("should collect handles indirectly triggered by user code", function()
-- 		return Promise.resolve():andThen(function()
-- 			local handleCollector = collectHandles() -- Calling `server.listen` with just a port (e.g. `server.listen(0)`)
-- 			-- creates a `TCPSERVERWRAP` async resource. However, including a `host`
-- 			-- option instead creates a `GETADDRINFOREQWRAP` resource that only
-- 			-- lasts for the lifetime of the `listen()` call, but which *indirectly*
-- 			-- creates a long-lived `TCPSERVERWRAP` resource. We want to make sure we
-- 			-- capture that long-lived resource.
-- 			local server = http.Server.new()
-- 			Promise.new(function(r)
-- 				return server:listen({ host = "localhost", port = 0 }, r)
-- 			end):expect()
-- 			local openHandles = handleCollector():expect()
-- 			Promise.new(function(r)
-- 				return server:close(r)
-- 			end):expect()
-- 			expect(openHandles).toContainEqual(expect:objectContaining({ message = "TCPSERVERWRAP" }))
-- 		end)
-- 	end)
-- end)
-- ROBLOX deviation END

-- ROBLOX deviation START: checking if collectHandles.lua file loads without errors
describe("collectHandles - custom tests", function()
	it("should load collectHandles module", function()
		local collectHandlesModule = require("../collectHandles")

		expect(collectHandlesModule).toBeDefined()
	end)
end)
-- ROBLOX deviation END
