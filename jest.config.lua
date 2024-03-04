return {
	setupFilesAfterEnv = { script.Parent.jestSetup },
	testMatch = { "**/*.(spec|test)", "**/__tests__/index" },
}
