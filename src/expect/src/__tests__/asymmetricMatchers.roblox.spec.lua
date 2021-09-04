--!nocheck

return function()
	local CurrentModule = script.Parent.Parent
	local Packages = CurrentModule.Parent

	local chalk = require(Packages.Dev.ChalkLua)

	local jestExpect = require(CurrentModule)

	local AsymmetricMatchers = require(CurrentModule.asymmetricMatchers)
	local stringContaining = AsymmetricMatchers.stringContaining
	local stringNotContaining = AsymmetricMatchers.stringNotContaining
	local stringMatching = AsymmetricMatchers.stringMatching
	local stringNotMatching = AsymmetricMatchers.stringNotMatching

	local nestedStyle = chalk.green .. chalk.italic .. chalk.bgMagenta

	describe("chalk tests", function()
		it("tests stringContaining", function()
			jestExpect(stringContaining("red"):asymmetricMatch(chalk.red("red"))).toEqual(true)
			jestExpect(stringContaining(chalk.red("red")):asymmetricMatch(chalk.red("red"))).toEqual(true)

			jestExpect(stringContaining("multi"):asymmetricMatch(nestedStyle("multi"))).toEqual(true)
			jestExpect(stringContaining(chalk.italic(chalk.bgMagenta("multi"))):asymmetricMatch(nestedStyle("multi"))).toEqual(true)

			jestExpect(stringContaining("multi"):asymmetricMatch(nestedStyle("multi"))).toEqual(true)
			jestExpect(stringContaining(chalk.green("multi")):asymmetricMatch(nestedStyle("multi"))).never.toEqual(true)
		end)

		it("tests stringNotContaining", function()
			jestExpect(stringNotContaining("red"):asymmetricMatch(chalk.red("red"))).never.toEqual(true)
			jestExpect(stringNotContaining(chalk.red("red")):asymmetricMatch(chalk.red("red"))).never.toEqual(true)

			jestExpect(stringNotContaining("multi"):asymmetricMatch(nestedStyle("multi"))).never.toEqual(true)
			jestExpect(stringNotContaining(chalk.italic(chalk.bgMagenta("multi"))):asymmetricMatch(nestedStyle("multi"))).never.toEqual(true)

			jestExpect(stringNotContaining("multi"):asymmetricMatch(nestedStyle("multi"))).never.toEqual(true)
			jestExpect(stringNotContaining(chalk.green("multi")):asymmetricMatch(nestedStyle("multi"))).toEqual(true)
		end)

		it("tests stringMatching", function()
			jestExpect(stringMatching("red"):asymmetricMatch(chalk.red("red"))).toEqual(true)
			jestExpect(stringMatching(chalk.red("red")):asymmetricMatch(chalk.red("red"))).toEqual(true)

			jestExpect(stringMatching("multi"):asymmetricMatch(nestedStyle("multi"))).toEqual(true)
			jestExpect(stringMatching(chalk.italic(chalk.bgMagenta("multi"))):asymmetricMatch(nestedStyle("multi"))).toEqual(true)

			jestExpect(stringMatching("multi"):asymmetricMatch(nestedStyle("multi"))).toEqual(true)
			jestExpect(stringMatching(chalk.green("multi")):asymmetricMatch(nestedStyle("multi"))).never.toEqual(true)
		end)

		it("tests stringNotMatching", function()
			jestExpect(stringNotMatching("red"):asymmetricMatch(chalk.red("red"))).never.toEqual(true)
			jestExpect(stringNotMatching(chalk.red("red")):asymmetricMatch(chalk.red("red"))).never.toEqual(true)

			jestExpect(stringNotMatching("multi"):asymmetricMatch(nestedStyle("multi"))).never.toEqual(true)
			jestExpect(stringNotMatching(chalk.italic(chalk.bgMagenta("multi"))):asymmetricMatch(nestedStyle("multi"))).never.toEqual(true)

			jestExpect(stringNotMatching("multi"):asymmetricMatch(nestedStyle("multi"))).never.toEqual(true)
			jestExpect(stringNotMatching(chalk.green("multi")):asymmetricMatch(nestedStyle("multi"))).toEqual(true)
		end)
	end)
end