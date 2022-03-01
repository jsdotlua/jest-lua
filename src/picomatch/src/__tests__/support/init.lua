-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/support/index.js

-- ROBLOX FIXME: need a way to mock
local path = { sep = "/" } -- require("path")
-- Don't use "path.sep" here, as it's conceivable that it might have been
-- modified somewhere by the user. Node.js only handles these two path separators
-- with similar logic, and this is only for unit tests, so we should be fine.
-- ROBLOX FIXME: need a test for platform
local isWindows = false
local sep = isWindows and "\\" or "/"
return {
	windowsPathSep = function()
		path.sep = "\\"
	end,
	resetPathSep = function()
		path.sep = sep
	end,
}
