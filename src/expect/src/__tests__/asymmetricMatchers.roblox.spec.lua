--!nocheck
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

local CurrentModule = script.Parent.Parent
local Packages = CurrentModule.Parent

local chalk = require(Packages.Dev.ChalkLua)

local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local AsymmetricMatchers = require(CurrentModule.asymmetricMatchers)
local stringContaining = AsymmetricMatchers.stringContaining
local stringNotContaining = AsymmetricMatchers.stringNotContaining
local stringMatching = AsymmetricMatchers.stringMatching
local stringNotMatching = AsymmetricMatchers.stringNotMatching

local nestedStyle = chalk.green .. chalk.italic .. chalk.bgMagenta

describe("chalk tests", function()
	it("tests stringContaining", function()
		expect(stringContaining("red"):asymmetricMatch(chalk.red("red"))).toEqual(true)
		expect(stringContaining(chalk.red("red")):asymmetricMatch(chalk.red("red"))).toEqual(true)

		expect(stringContaining("multi"):asymmetricMatch(nestedStyle("multi"))).toEqual(true)
		expect(stringContaining(chalk.italic(chalk.bgMagenta("multi"))):asymmetricMatch(nestedStyle("multi"))).toEqual(
			true
		)

		expect(stringContaining("multi"):asymmetricMatch(nestedStyle("multi"))).toEqual(true)
		expect(stringContaining(chalk.green("multi")):asymmetricMatch(nestedStyle("multi"))).never.toEqual(true)
	end)

	it("tests stringNotContaining", function()
		expect(stringNotContaining("red"):asymmetricMatch(chalk.red("red"))).never.toEqual(true)
		expect(stringNotContaining(chalk.red("red")):asymmetricMatch(chalk.red("red"))).never.toEqual(true)

		expect(stringNotContaining("multi"):asymmetricMatch(nestedStyle("multi"))).never.toEqual(true)
		expect(stringNotContaining(chalk.italic(chalk.bgMagenta("multi"))):asymmetricMatch(nestedStyle("multi"))).never.toEqual(
			true
		)

		expect(stringNotContaining("multi"):asymmetricMatch(nestedStyle("multi"))).never.toEqual(true)
		expect(stringNotContaining(chalk.green("multi")):asymmetricMatch(nestedStyle("multi"))).toEqual(true)
	end)

	it("tests stringMatching", function()
		expect(stringMatching("red"):asymmetricMatch(chalk.red("red"))).toEqual(true)
		expect(stringMatching(chalk.red("red")):asymmetricMatch(chalk.red("red"))).toEqual(true)

		expect(stringMatching("multi"):asymmetricMatch(nestedStyle("multi"))).toEqual(true)
		expect(stringMatching(chalk.italic(chalk.bgMagenta("multi"))):asymmetricMatch(nestedStyle("multi"))).toEqual(
			true
		)

		expect(stringMatching("multi"):asymmetricMatch(nestedStyle("multi"))).toEqual(true)
		expect(stringMatching(chalk.green("multi")):asymmetricMatch(nestedStyle("multi"))).never.toEqual(true)
	end)

	it("tests stringNotMatching", function()
		expect(stringNotMatching("red"):asymmetricMatch(chalk.red("red"))).never.toEqual(true)
		expect(stringNotMatching(chalk.red("red")):asymmetricMatch(chalk.red("red"))).never.toEqual(true)

		expect(stringNotMatching("multi"):asymmetricMatch(nestedStyle("multi"))).never.toEqual(true)
		expect(stringNotMatching(chalk.italic(chalk.bgMagenta("multi"))):asymmetricMatch(nestedStyle("multi"))).never.toEqual(
			true
		)

		expect(stringNotMatching("multi"):asymmetricMatch(nestedStyle("multi"))).never.toEqual(true)
		expect(stringNotMatching(chalk.green("multi")):asymmetricMatch(nestedStyle("multi"))).toEqual(true)
	end)
end)

it("any works with Roblox types", function()
	expect(Vector3.new()).toEqual(expect.any("Vector3"))
	expect(Color3.new()).toEqual(expect.any("Color3"))
	expect(UDim2.new()).toEqual(expect.any("UDim2"))
end)

return {}
