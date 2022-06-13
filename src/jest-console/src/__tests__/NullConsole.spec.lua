-- ROBLOX note: no upstream

return function()
	local CurrentModule = script.Parent
	local Packages = CurrentModule.Parent.Parent
	local jestExpect = require(Packages.Dev.JestGlobals).expect
	local Writeable = require(Packages.RobloxShared).Writeable

	local NullConsoleModule = require(CurrentModule.Parent.NullConsole)
	local NullConsole = NullConsoleModule.default
	type NullConsole = NullConsoleModule.NullConsole

	describe("NullConsole", function()
		local _console: NullConsole
		local _stdout: string
		local _stderr: string

		beforeEach(function()
			_stdout = ""
			_stderr = ""

			local stdout = Writeable.new({
				write = function(message: string)
					_stdout ..= message .. "\n"
				end,
			})

			local stderr = Writeable.new({
				write = function(message: string)
					_stderr ..= message .. "\n"
				end,
			})

			_console = NullConsole.new(stdout, stderr)
		end)

		it("should not write to the console stdout", function()
			_console:log("Hello, world!")
			jestExpect(_stdout).toBe("")
		end)

		it("should not write to the console stderr", function()
			_console:error("Somethign went wrong")
			jestExpect(_stdout).toBe("")
		end)
	end)
end
