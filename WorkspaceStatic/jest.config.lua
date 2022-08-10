local Workspace = script.Parent

return {
	setupFilesAfterEnv = { Workspace.testSetupFile },
	testMatch = { "**/*.(spec|test)", "**/__tests__/index"},
}
