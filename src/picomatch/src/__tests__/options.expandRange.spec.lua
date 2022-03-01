-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/options.expandRange.js

return function()
	local CurrentModule = script.Parent
	local PicomatchModule = CurrentModule.Parent

	-- ROBLOX deviation: not supported in Lua
	-- local fill = require("fill-range")
	local isMatch = require(PicomatchModule).isMatch
	describe("options.expandRange", function()
		it("should support a custom function for expanding ranges in brace patterns", function()
			assert(isMatch("a/c", "a/{a..c}", {
				expandRange = function(a, b)
					return ("([%s-%s])"):format(tostring(a), tostring(b))
				end,
			}))
			assert(not isMatch("a/z", "a/{a..c}", {
				expandRange = function(a, b)
					return ("([%s-%s])"):format(tostring(a), tostring(b))
				end,
			}))
			-- ROBLOX deviation START: not supported in Lua
			-- assert(isMatch("a/99", "a/{1..100}", {
			-- 	expandRange = function(self, a, b)
			-- 		return ("(%s)"):format(fill(a, b, { toRegex = true }))
			-- 	end,
			-- }))
			-- ROBLOX deviation END
		end)
	end)
end
