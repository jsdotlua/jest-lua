_G.NOCOLOR = _G.NOCOLOR

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Jest = require("@DevPackages/Jest")

local runCLIOptions = {
	verbose = false,
	ci = false,
}

local projects = {
	Packages.Project,
}

Jest.runCLI(script, runCLIOptions, projects):await()

return nil
