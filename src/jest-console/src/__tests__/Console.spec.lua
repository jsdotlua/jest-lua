-- ROBLOX note: no upstream

return function()
	local CurrentModule = script.Parent
	local Packages = CurrentModule.Parent.Parent
	local jestExpect = require(Packages.Dev.JestGlobals).expect
	local Writeable = require(Packages.RobloxShared).Writeable

	local ConsoleModule = require(CurrentModule.Parent.Console)
	local Console = ConsoleModule.default
	type Console = ConsoleModule.Console

	describe("Console", function()
		local _console: Console
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

			_console = Console.new(stdout, stderr)
		end)

		it("can write to the console", function()
			_console:log("Hello, world!")
			jestExpect(_stdout).toBe("Hello, world!\n")
		end)

		it("properly formats input", function()
			_console:log("Hello, %s!", "world")
			jestExpect(_stdout).toBe("Hello, world!\n")
		end)

		it("writes to stderr", function()
			_console:error("Hello, world!")
			jestExpect(_stderr).toBe("Hello, world!\n")
		end)
	end)
end
