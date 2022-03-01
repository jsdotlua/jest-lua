-- ROBLOX NOTE: no upstream

return function()
	local CurrentModule = script.Parent
	local SrcModule = CurrentModule.Parent
	local Packages = SrcModule.Parent

	local jestExpect = require(Packages.Dev.Expect)

	local createDirectory = require(SrcModule.createDirectory).default

	describe("createDirectory", function()
		local mockFileSystem: any
		local mockFileSystemPrevValue

		beforeEach(function()
			mockFileSystem = {}
			mockFileSystemPrevValue = _G.__MOCK_FILE_SYSTEM__
			_G.__MOCK_FILE_SYSTEM__ = mockFileSystem
		end)

		afterEach(function()
			_G.__MOCK_FILE_SYSTEM__ = mockFileSystemPrevValue
		end)

		it("should re-throw error from CreateDirectories", function()
			function mockFileSystem:CreateDirectories()
				error("kaboom")
			end

			jestExpect(function()
				createDirectory("Packages/foo/bar")
			end).toThrow("kaboom")
		end)

		it("should throw 'Provided path is invalid' when access denied", function()
			function mockFileSystem:CreateDirectories()
				error("Error(13): Access Denied. Path is outside of sandbox.")
			end

			jestExpect(function()
				createDirectory("Packages/foo/bar")
			end).toThrow(
				"Provided path is invalid: you likely need to provide a different argument to --fs.readwrite.\nYou may need to pass in `--fs.readwrite=$PWD`"
			)
		end)

		it("should not throw when CreateDirectories executes successfully", function()
			function mockFileSystem:CreateDirectories() end

			jestExpect(function()
				createDirectory("Packages/foo/bar")
			end).never.toThrow()
		end)
	end)
end
