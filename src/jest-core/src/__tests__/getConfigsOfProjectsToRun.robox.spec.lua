-- ROBLOX NOTE: no upstream

local test_utilsModule = require("@pkg/@jsdotlua/test-utils")
local makeProjectConfig = test_utilsModule.makeProjectConfig

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local describe = JestGlobals.describe
local it = JestGlobals.it
local expect = JestGlobals.expect

local getConfigsOfProjectsToRun = require("../getConfigsOfProjectsToRun").default

describe("getConfigsOfProjectsToRun", function()
	local config1 = makeProjectConfig({
		displayName = { name = "testRunner1" },
		automock = false,
		rootDir = "/path/to/dir1",
		roots = { "path/to/dir/test1" },
		testRunner = "myRunner1",
	})
	local config2 = makeProjectConfig({
		displayName = { name = "testRunner2" },
		automock = false,
		rootDir = "/path/to/dir2",
		roots = { "path/to/dir/test2" },
		testRunner = "myRunner2",
	})

	it("should be able to run without any filters", function()
		local result

		result = getConfigsOfProjectsToRun({ config1 }, {})
		expect(result).toEqual({ config1 })
		expect(result[1]).toBe(config1)

		result = getConfigsOfProjectsToRun({ config1, config2 }, {})
		expect(result).toEqual({ config1, config2 })
		expect(result[1]).toBe(config1)
		expect(result[2]).toBe(config2)
	end)

	it("should be able to run with a select filter", function()
		local result

		result = getConfigsOfProjectsToRun({ config1, config2 }, { selectProjects = { "testRunner1" } })
		expect(result).toEqual({ config1 })

		result = getConfigsOfProjectsToRun({ config1, config2 }, { selectProjects = { "testRunner2" } })
		expect(result).toEqual({ config2 })

		result = getConfigsOfProjectsToRun({ config1, config2 }, { selectProjects = { "testRunner1", "testRunner2" } })
		expect(result).toEqual({ config1, config2 })
	end)

	it("should be able to run with an ignore filter", function()
		local result

		result = getConfigsOfProjectsToRun({ config1, config2 }, { ignoreProjects = { "testRunner1" } })
		expect(result).toEqual({ config2 })

		result = getConfigsOfProjectsToRun({ config1, config2 }, { ignoreProjects = { "testRunner2" } })
		expect(result).toEqual({ config1 })

		result = getConfigsOfProjectsToRun({ config1, config2 }, { ignoreProjects = { "testRunner1", "testRunner2" } })
		expect(result).toEqual({})
	end)

	it("should be able to run with both select and ignore filters", function()
		local result

		result = getConfigsOfProjectsToRun(
			{ config1, config2 },
			{ selectProjects = { "testRunner2" }, ignoreProjects = { "testRunner1" } }
		)
		expect(result).toEqual({ config2 })

		result = getConfigsOfProjectsToRun(
			{ config1, config2 },
			{ selectProjects = { "testRunner1" }, ignoreProjects = { "testRunner2" } }
		)
		expect(result).toEqual({ config1 })
	end)

	it("should treat ignore with precendence over select", function()
		local result = getConfigsOfProjectsToRun(
			{ config1, config2 },
			{ selectProjects = { "testRunner1", "testRunner2" }, ignoreProjects = { "testRunner1", "testRunner2" } }
		)
		expect(result).toEqual({})
	end)
end)
