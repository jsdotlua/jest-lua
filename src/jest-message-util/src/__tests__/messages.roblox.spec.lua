--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local expect = JestGlobals.expect
local it = JestGlobals.it

local Promise = require("@pkg/@jsdotlua/promise")
local Error = require("@pkg/@jsdotlua/luau-polyfill").Error

local RobloxShared = require("@pkg/@jsdotlua/jest-roblox-shared")
local pruneDeps = RobloxShared.pruneDeps

local CurentModule = require("..")
local formatExecError = CurentModule.formatExecError

it(".formatExecError() - Promise throw string", function()
	local ok, err = pcall(function()
		Promise.resolve()
			:andThen(function()
				error("kaboom")
			end)
			:expect()
	end)

	expect(ok).toBe(false)

	local message = formatExecError(err, { rootDir = "" :: any, testMatch = {} }, { noStackTrace = false }, "path_test")
	expect(pruneDeps(message)).toMatchSnapshot()
end)

it(".formatExecError() - Promise throw Error", function()
	local ok, err = pcall(function()
		Promise.resolve()
			:andThen(function()
				error(Error.new("kaboom"))
			end)
			:expect()
	end)

	expect(ok).toBe(false)

	local message = formatExecError(err, { rootDir = "" :: any, testMatch = {} }, { noStackTrace = false }, "path_test")
	expect(pruneDeps(message)).toMatchSnapshot()
end)

it(".formatExecError() - nested Promise throw string", function()
	local ok, err = pcall(function()
		Promise.resolve()
			:andThen(function()
				return Promise.resolve():andThen(function()
					return error("kaboom")
				end)
			end)
			:expect()
	end)

	expect(ok).toBe(false)

	local message = formatExecError(err, { rootDir = "" :: any, testMatch = {} }, { noStackTrace = false }, "path_test")
	expect(pruneDeps(message)).toMatchSnapshot()
end)

it(".formatExecError() - nested Promise throw Error", function()
	local ok, err = pcall(function()
		Promise.resolve()
			:andThen(function()
				return Promise.resolve():andThen(function()
					return error(Error.new("kaboom"))
				end)
			end)
			:expect()
	end)

	expect(ok).toBe(false)

	local message = formatExecError(err, { rootDir = "" :: any, testMatch = {} }, { noStackTrace = false }, "path_test")
	expect(pruneDeps(message)).toMatchSnapshot()
end)

return {}
