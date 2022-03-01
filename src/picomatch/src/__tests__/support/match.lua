-- ROBLOX upstream: https://github.com/micromatch/picomatch/tree/2.3.1/test/support/match.js

local CurrentModule = script.Parent
local PicomatchModule = CurrentModule.Parent.Parent
local Packages = PicomatchModule.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Set = LuauPolyfill.Set

type Object = LuauPolyfill.Object

local picomatch = require(PicomatchModule)

return function(list, pattern, options_: Object?)
	local options: Object = options_ or {}
	local isMatch = picomatch(pattern, options, true)
	local matches = Boolean.toJSBoolean(options.matches) and options.matches or Set.new()

	for _, item in ipairs(list) do
		local match = isMatch(item, true)

		if match and match.output and match.isMatch == true then
			matches:add(match.output)
		end
	end

	--[[
		ROBLOX deviation START: using Set:ipairs because Array.concat doesn't work with Set
		original code:
		return [...matches]
	]]
	local result = {}
	for _, value in matches:ipairs() do
		table.insert(result, value)
	end
	return result
	-- ROBLOX deviation: END
end
